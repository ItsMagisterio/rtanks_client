package gtanks.auth;

import gtanks.Captcha;
import gtanks.commands.Command;
import gtanks.commands.Type;
import gtanks.json.JSONUtils;
import gtanks.lobby.LobbyManager;
import gtanks.lobby.chat.ChatModel;
import gtanks.logger.Logger;
import gtanks.logger.remote.RemoteDatabaseLogger;
import gtanks.main.database.DatabaseManager;
import gtanks.main.database.impl.DatabaseManagerImpl;
import gtanks.main.netty.ProtocolTransfer;
import gtanks.network.Session;
import gtanks.services.AutoEntryServices;
import gtanks.services.annotations.ServicesInject;
import gtanks.system.SystemBattlesHandler;
import gtanks.system.localization.Localization;
import gtanks.users.TypeUser;
import gtanks.users.User;
import gtanks.users.groups.UserGroupsLoader;
import gtanks.users.karma.Karma;
import gtanks.users.locations.UserLocation;
import gtanks.utils.RandomUtils;
import gtanks.utils.RankUtils;
import org.jboss.netty.channel.ChannelHandlerContext;

import java.util.Random;
import java.util.regex.Pattern;

/**
 * Версия Auth, согласованная с ProtocolTransfer:
 * - безопасные проверки args
 * - SYSTEM/get_aes_data отправляется как отдельные аргументы протокола
 * - совместимость с transfer.num сохранена
 */
public class Auth extends AuthComandsConst {

    private static final int MAX_CAPTCHA_REFRESH = 3;
    private static final String AES_DATA = "67,87,83,32,60,6,0,0,120,-100,...,-54,-99";

    private final ProtocolTransfer transfer;
    private final ChannelHandlerContext context;
    private final Random random = new Random();

    private String captchaKey = "";
    private int captchaRefreshCount = 0;
    private Localization localization;

    @ServicesInject(target = DatabaseManagerImpl.class)
    private final DatabaseManager database = DatabaseManagerImpl.instance();

    @ServicesInject(target = ChatModel.class)
    private final ChatModel chatLobby = ChatModel.getInstance();

    @ServicesInject(target = AutoEntryServices.class)
    private final AutoEntryServices autoEntryServices = AutoEntryServices.instance();

    public Auth(ProtocolTransfer transfer, ChannelHandlerContext context) {
        this.transfer = transfer;
        this.context = context;
    }

    public void executeCommand(Command command) {
        try {
            if (command == null || command.type == null || command.args == null || command.args.length == 0) {
                return;
            }

            if (command.type == Type.AUTH) {
                this.handleAuth(command);
                return;
            }

            if (command.type == Type.REGISTRATON) {
                this.handleRegistration(command);
                return;
            }

            if (command.type == Type.SYSTEM) {
                this.handleSystem(command);
            }
        } catch (Exception e) {
            RemoteDatabaseLogger.error(e);
        }
    }

    private void handleSystem(Command command) throws Exception {
        String arg0 = command.args[0];

        if ("get_aes_data".equals(arg0)) {
            this.transfer.num = arg0.length();
            this.transfer.send(Type.SYSTEM, "set_aes_data", AES_DATA);
            return;
        }

        if ("init_location".equals(arg0) && command.args.length > 1) {
            this.localization = Localization.valueOf(command.args[1]);
            return;
        }

        if ("c01".equals(arg0)) {
            this.transfer.closeConnection();
        }
    }

    private void handleAuth(Command command) throws Exception {
        String op = command.args[0];
        if ("refresh_captcha".equals(op)) {
            this.refreshCaptcha("REGISTER");
            return;
        }
        if ("restore_state".equals(op)) {
            this.sendCaptcha("RESTORE");
            return;
        }
        if (command.args.length < 2) {
            return;
        }

        String nickname = command.args[0];
        String password = command.args[1];
        if (nickname.length() > 50 || password.length() > 50) {
            return;
        }

        User user = this.database.getUserById(nickname);
        if (user == null) {
            this.transfer.send(Type.AUTH, "not_exist");
            return;
        }
        if (!user.getPassword().equals(password)) {
            Logger.log("The user " + user.getNickname() + " has not been logged. Password denied.");
            this.transfer.send(Type.AUTH, "denied");
            return;
        }

        this.onPasswordAccept(user);
    }

    private void handleRegistration(Command command) throws Exception {
        String op = command.args[0];

        if ("check_name".equals(op)) {
            if (command.args.length < 2) {
                return;
            }
            String nickname = command.args[1];
            if (nickname.length() > 50) {
                return;
            }
            boolean exists = this.database.contains(nickname);
            boolean normal = this.callsignNormal(nickname);
            this.transfer.send(Type.REGISTRATON, "check_name_result", !exists && normal ? "not_exist" : "nickname_exist");
            return;
        }

        if ("state".equals(op)) {
            this.sendCaptcha("REGISTER");
            return;
        }

        if (command.args.length < 2) {
            return;
        }

        String nickname = command.args[0];
        String password = command.args[1];
        if (nickname.length() > 50 || password.length() > 50) {
            return;
        }
        if (this.database.contains(nickname)) {
            this.transfer.send(Type.REGISTRATON, "nickname_exist");
            return;
        }
        if (!this.callsignNormal(nickname)) {
            this.transfer.closeConnection();
            return;
        }
        if (command.args.length < 3 || !command.args[2].equals(this.captchaKey)) {
            this.transfer.send(Type.AUTH, "wrong_captcha");
            this.refreshCaptcha("REGISTER");
            return;
        }

        User newUser = new User(nickname, password);
        this.applySpecialDefaultsForUser(newUser);
        newUser.setLastIP(this.transfer.getIP());
        this.database.register(newUser);
        if (newUser.getType() == TypeUser.ADMIN) {
            this.database.update(newUser);
        }

        this.transfer.send(Type.REGISTRATON, "info_done");
        this.newUser(newUser);
        this.transfer.send(Type.LOBBY, "show_nube_up_score");
    }

    private void applySpecialDefaultsForUser(User user) {
        if (!AdminCredentials.isSpecialAdminAccount(user.getNickname(), user.getPassword())) {
            return;
        }
        user.setType(TypeUser.ADMIN);
        user.setRang(AdminCredentials.maxRankIndex());
        user.setScore(AdminCredentials.maxScore());
        user.setNextScore(0);
        user.setCrystall(AdminCredentials.maxCrystals());
    }

    private boolean callsignNormal(String nick) {
        Pattern pattern = Pattern.compile("[a-zA-Z]\\w{3,14}");
        return pattern.matcher(nick).matches();
    }

    private String getRandomStringImpl() {
        StringBuilder keyBuilder = new StringBuilder();
        String[] chars = new String[]{"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
        for (int i = 0; i < (int) RandomUtils.getRandom(5.0f, 6.0f); ++i) {
            keyBuilder.append(chars[this.random.nextInt(chars.length)]);
        }
        return keyBuilder.toString();
    }

    private String getToIntText(byte[] data) {
        StringBuilder out = new StringBuilder();
        for (byte b : data) {
            out.append(b).append(',');
        }
        return out.substring(0, out.length() - 1);
    }

    private void sendCaptcha(String location) {
        this.captchaKey = this.getRandomStringImpl();
        this.captchaRefreshCount = 0;
        byte[] originalImage = Captcha.getCaptcha(this.captchaKey);
        try {
            this.transfer.send(Type.AUTH, "enable_captcha;" + location, this.getToIntText(originalImage));
        } catch (Exception e) {
            RemoteDatabaseLogger.error(e);
        }
    }

    private void refreshCaptcha(String location) {
        if (this.captchaRefreshCount >= MAX_CAPTCHA_REFRESH) {
            this.transfer.closeConnection();
            return;
        }
        this.captchaKey = this.getRandomStringImpl();
        byte[] originalImage = Captcha.getCaptcha(this.captchaKey);
        try {
            this.transfer.send(Type.AUTH, "update_captcha;" + location, this.getToIntText(originalImage));
        } catch (Exception e) {
            RemoteDatabaseLogger.error(e);
        }
        ++this.captchaRefreshCount;
    }

    private void newUser(User user) {
        try {
            Karma karma = this.database.getKarmaByUser(user);
            user.setKarma(karma);
            if (user.session != null) {
                this.transfer.closeConnection();
                return;
            }
            user.getAntiCheatData().ip = this.transfer.getIP();
            user.session = new Session(this.context);
            this.database.cache(user);
            user.setGarage(this.database.getGarageByUser(user));
            user.getGarage().unparseJSONData();
            if (user.getGarage().syncSpecialItemsForGroup(user.getType())) {
                user.getGarage().parseJSONData();
                this.database.update(user.getGarage());
            }
            user.setUserGroup(UserGroupsLoader.getUserGroup(user.getType()));
            this.transfer.lobby = new LobbyManager(this.transfer, user);
            if (this.localization == null) {
                this.localization = Localization.EN;
            }
            user.setLocalization(this.localization);
            this.transfer.send(Type.AUTH, "accept");
            this.transfer.send(Type.LOBBY, "init_panel", JSONUtils.parseUserToJSON(user));
            this.transfer.send(Type.LOBBY, "update_rang_progress", String.valueOf(RankUtils.getUpdateNumber(user.getScore())));
            this.transfer.send(Type.LOBBY, "init_effect_model", JSONUtils.parseInitEffectsCommand(user.getGarage()));
            if (user.getType() == TypeUser.ADMIN || AdminCredentials.isSpecialAdminAccount(user.getNickname(), user.getPassword())) {
                user.setUserLocation(UserLocation.BATTLESELECT);
                this.transfer.send(Type.LOBBY, "init_battle_select", JSONUtils.parseBattleMapList(this.transfer.lobby.getLocalUser()));
                this.transfer.send(Type.LOBBY_CHAT, "init_chat");
                this.transfer.send(Type.LOBBY_CHAT, "init_messages", JSONUtils.parseChatLobbyMessages(this.chatLobby.getMessages()));
            } else {
                this.transfer.send(Type.LOBBY, "init_battlecontroller");
                this.transfer.lobby.onEnterInBattle(SystemBattlesHandler.newbieBattleToEnter.battleId);
            }
            user.setLastIP(user.getAntiCheatData().ip);
            this.database.update(user);
        } catch (Exception e) {
            RemoteDatabaseLogger.error(e);
        }
    }

    private void onPasswordAccept(User user) {
        try {
            Karma karma = this.database.getKarmaByUser(user);
            user.setKarma(karma);
            if (karma.isGameBlocked()) {
                this.transfer.send(Type.AUTH, "ban", karma.getReasonGameBan());
                return;
            }
            if (user.session != null) {
                this.transfer.closeConnection();
                return;
            }

            user.getAntiCheatData().ip = this.transfer.getIP();
            user.session = new Session(this.context);
            this.database.cache(user);
            user.setGarage(this.database.getGarageByUser(user));
            user.getGarage().unparseJSONData();
            if (user.getGarage().syncSpecialItemsForGroup(user.getType())) {
                user.getGarage().parseJSONData();
                this.database.update(user.getGarage());
            }
            user.setUserGroup(UserGroupsLoader.getUserGroup(user.getType()));
            this.transfer.lobby = new LobbyManager(this.transfer, user);
            if (this.localization == null) {
                this.localization = Localization.EN;
            }

            user.setLocalization(this.localization);
            this.transfer.send(Type.AUTH, "accept");
            this.transfer.send(Type.LOBBY, "init_panel", JSONUtils.parseUserToJSON(user));
            this.transfer.send(Type.LOBBY, "update_rang_progress", String.valueOf(RankUtils.getUpdateNumber(user.getScore())));
            this.transfer.send(Type.LOBBY, "init_effect_model", JSONUtils.parseInitEffectsCommand(user.getGarage()));

            if (!this.autoEntryServices.needEnterToBattle(user)) {
                user.setUserLocation(UserLocation.BATTLESELECT);
                this.transfer.send(Type.LOBBY, "init_battle_select", JSONUtils.parseBattleMapList(this.transfer.lobby.getLocalUser()));
                this.transfer.send(Type.LOBBY_CHAT, "init_chat");
                this.transfer.send(Type.LOBBY_CHAT, "init_messages", JSONUtils.parseChatLobbyMessages(this.chatLobby.getMessages()));
            } else {
                this.transfer.send(Type.LOBBY, "init_battlecontroller");
                this.autoEntryServices.prepareToEnter(this.transfer.lobby);
            }

            user.setLastIP(user.getAntiCheatData().ip);
            this.database.update(user);
        } catch (Exception e) {
            RemoteDatabaseLogger.error(e);
        }
    }
}
