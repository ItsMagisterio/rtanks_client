// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Game

package 
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import alternativa.init.OSGi;
    import alternativa.init.Main;
    import alternativa.init.BattlefieldModelActivator;
    import alternativa.init.BattlefieldSharedActivator;
    import alternativa.init.PanelModelActivator;
    import alternativa.init.TanksLocaleActivator;
    import alternativa.init.TanksServicesActivator;
    import alternativa.init.TanksWarfareActivator;
    import alternativa.init.BattlefieldGUIActivator;
    import alternativa.init.TanksLocaleRuActivator;
    import alternativa.init.TanksLocaleEnActivator;
    import alternativa.init.TanksFonts;
    import alternativa.object.ClientObject;
    import flash.display.BitmapData;
    import controls.Label;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.tank.TankModel;
    import scpacker.networking.Network;
    import flash.text.TextField;
    import scpacker.networking.INetworker;
    import com.reygazu.anticheat.events.CheatManagerEvent;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import alternativa.service.Logger;
    import flash.net.SharedObject;
    import sineysoft.WebpSwc;
    import specter.utils.Logger;
    import alternativa.tanks.loader.ILoaderWindowService;
    import alternativa.tanks.loader.LoaderWindow;
    import scpacker.SocketListener;
    import alternativa.register.ObjectRegister;
    import scpacker.gui.IGTanksLoader;
    import scpacker.gui.GTanksLoaderWindow;
    import alternativa.osgi.service.storage.IStorageService;
    import scpacker.networking.connecting.ServerConnectionServiceImpl;
    import scpacker.networking.connecting.ServerConnectionService;
    import scpacker.resource.ResourceUtil;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.model.panel.IPanel;
    import scpacker.networking.aes.AESEncrypterModel;
    import scpacker.networking.aes.IAESModel;

    public class Game extends Sprite 
    {

        public static var getInstance:Game;
        public static var currLocale:String;
        public static var local:Boolean = false;
        public static var _stage:Stage;
        private static var classInited:Boolean;

        public var osgi:OSGi;
        public var main:Main;
        public var battlefieldModel:BattlefieldModelActivator;
        public var battlefieldShared:BattlefieldSharedActivator;
        public var panel:PanelModelActivator;
        public var locale:TanksLocaleActivator;
        public var services:TanksServicesActivator;
        public var warfare:TanksWarfareActivator;
        public var battleGui:BattlefieldGUIActivator;
        public var localeRu:TanksLocaleRuActivator = new TanksLocaleRuActivator();
        public var localeEn:TanksLocaleEnActivator = new TanksLocaleEnActivator();
        public var fonts:TanksFonts = new TanksFonts();
        public var classObject:ClientObject;
        public var colorMap:BitmapData = new BitmapData(100, 100);
        private var test:Label = new Label();
        public var battleModel:BattlefieldModel;
        public var tankModel:TankModel;
        public var loaderObject:Object;

        public function Game()
        {
            if (numChildren > 1)
            {
                removeChildAt(0);
                removeChildAt(0);
            };
        }

        public static function onUserEntered(e:CheatManagerEvent):void
        {
            var network:Network;
            var cheaterTextField:TextField;
            var osgi:OSGi = Main.osgi;
            if (osgi != null)
            {
                network = (osgi.getService(INetworker) as Network);
            };
            if (network != null)
            {
                network.send(("system;c01;" + e.data.variableName));
            }
            else
            {
                while (_stage.numChildren > 0)
                {
                    _stage.removeChildAt(0);
                };
                cheaterTextField = new TextField();
                cheaterTextField.textColor = 0xFF0000;
                cheaterTextField.text = "CHEATER!";
                _stage.addChild(cheaterTextField);
            };
        }


        public function activateAllModels():void
        {
            var localize:String;
            this.main.start(this.osgi);
            this.fonts.start(this.osgi);
            try
            {
                localize = root.loaderInfo.url.split("locale=")[1];
                localize = localize.toLocaleLowerCase();
                localize = localize.substring(0, 2);
            }
            catch(e:Error)
            {
                try
                {
                    localize = _stage.loaderInfo.url.split("locale=")[1];
                    localize = localize.toLocaleLowerCase();
                    localize = localize.substring(0, 2);
                }
                catch(e:Error)
                {
                    localize = null;
                };
            };
            if (((localize == null) || (localize == "ru")))
            {
                this.localeRu.start(this.osgi);
                currLocale = "RU";
            }
            else
            {
                this.localeEn.start(this.osgi);
                currLocale = "EN";
            };
            this.panel.start(this.osgi);
            this.locale.start(this.osgi);
            this.services.start(this.osgi);
        }

        public function SUPER(stage:Stage):void
        {
            if (classInited)
            {
                return;
            };
            classInited = true;
            _stage = stage;
            this.focusRect = false;
            stage.focus = this;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            _stage = stage;
            this.osgi = OSGi.init(false, stage, this, "127.0.0.1", [12345], "127.0.0.1", 12345, "res/", new alternativa.service.Logger(), SharedObject.getLocal("gtanks"), "RU", Object);
            this.main = new Main();
            this.battlefieldModel = new BattlefieldModelActivator();
            this.panel = new PanelModelActivator();
            this.locale = new TanksLocaleActivator();
            this.services = new TanksServicesActivator();
            getInstance = this;
            this.activateAllModels();
            //WebpSwc.start();
            specter.utils.Logger.init();
            var loaderService:LoaderWindow = (Main.osgi.getService(ILoaderWindowService) as LoaderWindow);
            this.loaderObject = new Object();
            var listener:SocketListener = new SocketListener();
            var objectRegister:ObjectRegister = new ObjectRegister(listener);
            this.classObject = new ClientObject("sdf", null, "GTanks", listener);
            this.classObject.register = objectRegister;
            objectRegister.createObject("sdfsd", null, "GTanks");
            Main.osgi.registerService(IGTanksLoader, new GTanksLoaderWindow(IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_new_loader"]));
            var serverConnectionServie:ServerConnectionService = new ServerConnectionServiceImpl();
            serverConnectionServie.connect("socket.cfg", this.onConnected);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            specter.utils.Logger.log(("Loader url: " + stage.loaderInfo.url));
        }

        private function onConnected():void
        {
            specter.utils.Logger.log("Connected to server");
            ResourceUtil.addEventListener(function ():void
            {
                onResourceLoaded();
                specter.utils.Logger.log("Resources loaded");
            });
            ResourceUtil.loadResource();
        }

        private function onResourceLoaded():void
        {
            var netwoker:Network = (Main.osgi.getService(INetworker) as Network);
            var lobbyServices:Lobby = new Lobby();
            var panel:PanelModel = new PanelModel();
            Main.osgi.registerService(IPanel, panel);
            Main.osgi.registerService(ILobby, lobbyServices);
            var auth:Authorization = new Authorization();
            Main.osgi.registerService(IAuthorization, auth);
            var aes:AESEncrypterModel = new AESEncrypterModel();
            Main.osgi.registerService(IAESModel, aes);
            netwoker.addListener(aes);
            aes.resourceLoaded(netwoker);
            specter.utils.Logger.log("Game::onResourceLoaded()");
        }


    }
}//package 

