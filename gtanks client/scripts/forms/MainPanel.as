package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.ButtonXP;
   import controls.PlayerInfo;
   import controls.rangicons.RangIconNormal;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.events.MainButtonBarEvents;
   
   public class MainPanel extends Sprite
   {
      
      private static const i:Class = MainPanel_i;
       
      
      private var crystallsStart:Bitmap;
      
      public var rangIcon:RangIconNormal;
      
      public var playerInfo:PlayerInfo;
      
      public var buttonBar:ButtonBar;
      
      private var _rang:int;
      
      private var _isTester:Boolean = false;
      
      public var buttonXP:ButtonXP;
      
      public function MainPanel(doubleCrystalls:Boolean = false)
      {
         this.crystallsStart = new Bitmap(new i().bitmapData);
         this.rangIcon = new RangIconNormal();
         this.playerInfo = new PlayerInfo();
         super();
         this._isTester = this.isTester;
         this.buttonBar = new ButtonBar(doubleCrystalls);
         this.buttonXP = new ButtonXP();
         this.buttonXP.addEventListener(MouseEvent.CLICK,this.buttonBar.listClick);
         addEventListener(Event.ADDED_TO_STAGE,this.configUI);
      }
      
      public function set rang(value:int) : void
      {
         this._rang = value;
         this.playerInfo.rang = value;
         this.rangIcon.rang1 = this._rang;
      }
      
      public function get rang() : int
      {
         return this._rang;
      }
      
      private function configUI(e:Event) : void
      {
         this.y = 3;
         addChild(this.rangIcon);
         addChild(this.playerInfo);
         addChild(this.buttonBar);
         addChild(this.crystallsStart);
         addChild(this.buttonXP);
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.buttonXP.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_XP);
         this.rangIcon.y = -2;
         this.rangIcon.x = 2;
         removeEventListener(Event.ADDED_TO_STAGE,this.configUI);
         this.playerInfo.indicators.changeButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.buttonBar.addButton = this.playerInfo.indicators.changeButton;
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
         var timer:Timer = new Timer(100,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            onResize(null);
         });
         timer.start();
      }
      
      private function listClick(e:MouseEvent) : void
      {
         this.buttonBar.dispatchEvent(new MainButtonBarEvents(1));
      }
      
      public function onResize(e:Event) : void
      {
            var minWidth:int = int(Math.max(1000, stage.stageWidth));
            this.playerInfo.width = (((minWidth - this.buttonBar.width) - this.buttonXP.width) + 5);
            this.buttonXP.x = ((((minWidth - this.buttonBar.width) - this.buttonXP.width) + 5) - 105);
            this.playerInfo.indicators.getCrystallSprite().x = (((this.buttonXP.x + this.buttonXP.width) - this.playerInfo.indicators.getCrystallbRight().width) - 23/*+ 6*/);
            this.playerInfo.indicators.getCrystallbRight().x = (this.playerInfo.indicators.getCrystallSprite().x + this.playerInfo.indicators.getCrystallSprite().width);
            this.crystallsStart.x = (this.playerInfo.indicators.getCrystallSprite().x + 53);
            this.playerInfo.indicators.getCrystallInfo().x = (this.playerInfo.indicators.getCrystallSprite().x - 2);
            this.buttonBar.x = ((this.playerInfo.indicators.getCrystallbRight().x + this.playerInfo.indicators.getCrystallbRight().width) + 50/*21*/);
      }
      
      public function hide() : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function get isTester() : Boolean
      {
         return this._isTester;
      }
      
      public function set isTester(value:Boolean) : void
      {
         this._isTester = value;
         this.buttonBar.isTester = this._isTester;
         this.buttonBar.draw();
         this.onResize(null);
      }
      
      public function set doubleCrystalls(value:Boolean) : void
      {
         this.buttonBar.doubleCrystalls = value;
      }
   }
}
