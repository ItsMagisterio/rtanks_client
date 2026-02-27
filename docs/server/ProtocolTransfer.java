package gtanks.main.netty;

import gtanks.auth.Auth;
import gtanks.commands.Command;
import gtanks.commands.Commands;
import gtanks.commands.Type;
import gtanks.lobby.LobbyManager;
import gtanks.logger.Logger;
import gtanks.utils.StringUtils;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;

import java.io.IOException;

/**
 * Совместимая с AS3-клиентом реализация протокола.
 *
 * AS3 (см. scpacker.networking.Network):
 * - клиент -> сервер: packet = (encrypt(raw) или method_137(raw)) + "end~"
 * - метод_137: keyDigit + каждый_символ(raw + (keyDigit + 1))
 * - keyDigit циклически по 1..8 (в исходной формуле первый пакет отправляется с key=2)
 */
public class ProtocolTransfer {

    private static final String SPLITTER_CMDS = "end~";
    private static final int[] KEYS = new int[]{1, 2, 3, 4, 5, 6, 7, 8, 9};

    private final StringBuffer inputRequest = new StringBuffer();
    private final StringBuffer badRequest = new StringBuffer();

    public LobbyManager lobby;
    public Auth auth;

    private final Channel channel;
    private final ChannelHandlerContext context;

    // совместимость с AS3 method_137 key rotation
    private int outKeyCursor = 1;

    // флаг для поэтапного включения plaintext-режима (если нужен)
    private final boolean plaintextMode;

    private static int[] $SWITCH_TABLE$gtanks$commands$Type;

    public ProtocolTransfer(Channel channel, ChannelHandlerContext context) {
        this(channel, context, false);
    }

    public ProtocolTransfer(Channel channel, ChannelHandlerContext context, boolean plaintextMode) {
        this.channel = channel;
        this.context = context;
        this.plaintextMode = plaintextMode;
    }

    // ===============================
    // ===== ПРИЕМ + ДЕШИФРОВКА =====
    // ===============================
    public void decryptProtocol(String protocolChunk) {
        if (protocolChunk == null || protocolChunk.isEmpty()) {
            return;
        }

        this.inputRequest.append(protocolChunk);

        if (!this.inputRequest.toString().contains(SPLITTER_CMDS)) {
            return;
        }

        String full = StringUtils.concatStrings(this.badRequest.toString(), this.inputRequest.toString());
        this.badRequest.setLength(0);
        this.inputRequest.setLength(0);

        int start = 0;
        while (true) {
            int end = full.indexOf(SPLITTER_CMDS, start);
            if (end < 0) {
                if (start < full.length()) {
                    this.badRequest.append(full.substring(start));
                }
                break;
            }

            String frame = full.substring(start, end);
            start = end + SPLITTER_CMDS.length();

            if (frame.isEmpty()) {
                continue;
            }

            try {
                String decrypted = decodeInbound(frame);
                this.sendRequestToManagers(decrypted);
            } catch (Exception e) {
                Logger.log("Bad request from " + this.channel + ": " + frame + " err=" + e.getMessage());
            }
        }
    }

    /**
     * Совместимость:
     * 1) plaintextMode=true -> без преобразования
     * 2) если первый символ не цифра, считаем что plaintext (или внешнее encrypt())
     * 3) иначе декодируем по AS3 method_137
     */
    private String decodeInbound(String frame) {
        if (this.plaintextMode) {
            return frame;
        }
        if (frame.isEmpty() || !Character.isDigit(frame.charAt(0))) {
            return frame;
        }

        int key = Character.getNumericValue(frame.charAt(0));
        if (key < 0) {
            return frame;
        }

        char[] out = new char[frame.length() - 1];
        for (int i = 1; i < frame.length(); i++) {
            out[i - 1] = (char) (frame.charAt(i) - (key + 1));
        }
        return new String(out);
    }

    private void sendRequestToManagers(String request) {
        this.sendCommandToManagers(Commands.decrypt(request));
    }

    private void sendCommandToManagers(Command cmd) {
        if (this.auth == null) {
            this.auth = new Auth(this, this.context);
        }

        switch ($SWITCH_TABLE$gtanks$commands$Type()[cmd.type.ordinal()]) {
            case 1:
            case 2:
            case 8:
                this.auth.executeCommand(cmd);
                break;
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
                this.lobby.executeCommand(cmd);
                break;
            case 9:
                Logger.log("User " + this.channel + " send unknown request: " + cmd);
                break;
            case 11:
                if (this.auth != null) {
                    this.auth.executeCommand(cmd);
                }
                if (this.lobby != null) {
                    this.lobby.executeCommand(cmd);
                }
                break;
            default:
                break;
        }
    }

    // ===============================
    // =========== SEND =============
    // ===============================
    public boolean send(Type type, String... args) throws IOException {
        StringBuilder request = new StringBuilder();
        request.append(type.toString().toLowerCase()).append(";");

        for (int i = 0; i < args.length - 1; i++) {
            request.append(args[i]).append(";");
        }
        request.append(args[args.length - 1]);

        String raw = request.toString();
        String packetBody = this.plaintextMode ? raw : encodeOutbound(raw);
        String packet = packetBody + SPLITTER_CMDS;

        if (this.channel.isWritable() && this.channel.isConnected() && this.channel.isOpen()) {
            this.channel.write(packet);
        }
        return true;
    }

    /** AS3-совместимый аналог method_137(). */
    private String encodeOutbound(String raw) {
        int key = (this.outKeyCursor + 1) % KEYS.length;
        if (key <= 0) {
            key = 1;
        }
        this.outKeyCursor = key;

        StringBuilder out = new StringBuilder(raw.length() + 1);
        out.append(key);
        for (int i = 0; i < raw.length(); i++) {
            out.append((char) (raw.charAt(i) + (key + 1)));
        }
        return out.toString();
    }

    protected void onDisconnect() {
        if (this.lobby != null) {
            this.lobby.onDisconnect();
        }
    }

    public void closeConnection() {
        this.channel.close();
    }

    public String getIP() {
        return this.channel.getRemoteAddress().toString();
    }

    static int[] $SWITCH_TABLE$gtanks$commands$Type() {
        int[] var10000 = $SWITCH_TABLE$gtanks$commands$Type;
        if (var10000 != null) {
            return var10000;
        }

        int[] var0 = new int[Type.values().length];
        try { var0[Type.AUTH.ordinal()] = 1; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.REGISTRATON.ordinal()] = 2; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.GARAGE.ordinal()] = 3; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.CHAT.ordinal()] = 4; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.LOBBY.ordinal()] = 5; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.LOBBY_CHAT.ordinal()] = 6; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.BATTLE.ordinal()] = 7; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.PING.ordinal()] = 8; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.UNKNOWN.ordinal()] = 9; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.HTTP.ordinal()] = 10; } catch (NoSuchFieldError ignored) {}
        try { var0[Type.SYSTEM.ordinal()] = 11; } catch (NoSuchFieldError ignored) {}

        $SWITCH_TABLE$gtanks$commands$Type = var0;
        return var0;
    }
}
