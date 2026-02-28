package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.ButtonXP;
   import controls.panel.BaseButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.buttons.MainPanelDonateButton;
   import forms.buttons.MainPanelDoubleDonateButton;
   import forms.buttons.MainPanelWideButton;
   import forms.events.MainButtonBarEvents;
   
   public class ButtonBar extends Sprite
   {
       
      
      public var battlesButton:MainPanelBattlesButton;
      
      public var garageButton:MainPanelGarageButton;
      
      public var statButton:MainPaneHallButton;
      
      public var referalsButton:MainPanelReferalButton;
      
      public var bugsButton:MainPanelBugButton;
      
      public var settingsButton:MainPanelConfigButton;
      
      public var soundButton:MainPanelSoundButton;
      
      public var helpButton:MainPanelHelpButton;
      
      public var closeButton:MainPanelCloseButton;
      
      public var addButton:BaseButton;
      
      private var donateNormalButton:MainPanelWideButton;
      
      private var _soundOn:Boolean = true;
      
      private var soundIcon:MovieClip;
      
      public var isTester:Boolean = false;
      
      public var haveDoubleCrystalls:Boolean = false;
      
      public function ButtonBar(doubleCrystalls:Boolean = false)
      {
         this.battlesButton = new MainPanelBattlesButton();
         this.garageButton = new MainPanelGarageButton();
         this.statButton = new MainPaneHallButton();
         this.referalsButton = new MainPanelReferalButton();
         this.bugsButton = new MainPanelBugButton();
         this.settingsButton = new MainPanelConfigButton();
         this.soundButton = new MainPanelSoundButton();
         this.helpButton = new MainPanelHelpButton();
         this.closeButton = new MainPanelCloseButton();
         this.donateNormalButton = new MainPanelDoubleDonateButton();
         super();
         this.haveDoubleCrystalls = doubleCrystalls;
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         addChild(this.battlesButton);
         this.battlesButton.type = 2;
         this.battlesButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_BATTLES);
         this.battlesButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.garageButton);
         this.garageButton.type = 3;
         this.garageButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_GARAGE);
         this.garageButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.statButton.type = 4;
         this.statButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_HALL);
         this.statButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.referalsButton);
         this.referalsButton.type = 11;
         this.referalsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.bugsButton);
         this.bugsButton.type = 9;
         this.bugsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.settingsButton);
         this.settingsButton.type = 5;
         this.settingsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.soundButton);
         this.soundButton.type = 6;
         this.soundButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.soundIcon = this.soundButton.getChildByName("icon") as MovieClip;
         addChild(this.helpButton);
         this.helpButton.type = 7;
         this.helpButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.closeButton);
         this.closeButton.type = 8;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.listClick);
         if(doubleCrystalls)
         {
            this.donateNormalButton = new MainPanelDoubleDonateButton();
         }
         else
         {
            this.donateNormalButton = new MainPanelDonateButton();
         }
         addChild(this.donateNormalButton);
         this.donateNormalButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_DONATE);
         this.donateNormalButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.draw();
      }
      
      public function draw() : void
      {
         this.battlesButton.x = this.donateNormalButton.x + this.donateNormalButton.width + 11;
         this.garageButton.x = this.battlesButton.x + this.battlesButton.width;
         this.referalsButton.x = this.garageButton.x + this.garageButton.width + 11;
         this.bugsButton.visible = false;
         this.settingsButton.x = this.referalsButton.x + this.referalsButton.width;
         this.soundButton.x = this.settingsButton.x + this.settingsButton.width;
         this.helpButton.x = this.soundButton.x + this.soundButton.width;
         this.closeButton.x = this.helpButton.x + this.helpButton.width + 11;
         this.soundIcon.gotoAndStop(!!this.soundOn ? 1 : 2);
      }
      
      public function set soundOn(value:Boolean) : void
      {
         this._soundOn = value;
         this.draw();
      }
      
      public function get soundOn() : Boolean
      {
         return this._soundOn;
      }
      
      public function set doubleCrystalls(value:Boolean) : void
      {
         this.haveDoubleCrystalls = value;
         removeChild(this.donateNormalButton);
         var savedLabel:String = this.donateNormalButton.savelLabel;
         if(this.haveDoubleCrystalls)
         {
            this.donateNormalButton = new MainPanelDoubleDonateButton();
         }
         else
         {
            this.donateNormalButton = new MainPanelDonateButton();
         }
         this.donateNormalButton.label = savedLabel;
         this.donateNormalButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.donateNormalButton);
      }
      
      public function listClick(e:MouseEvent) : void
      {
         var target:BaseButton = null;
         var trget:BaseButton = null;
         var i:int = 0;
         if(e.currentTarget as BaseButton != null)
         {
            target = e.currentTarget as BaseButton;
            if(target.enable)
            {
               dispatchEvent(new MainButtonBarEvents(target.type));
            }
            if(target == this.soundButton)
            {
               this.soundOn = !this.soundOn;
            }
            if(target == this.battlesButton || target == this.garageButton || target == this.statButton)
            {
               for(i = 0; i < 3; i++)
               {
                  trget = getChildAt(i) as BaseButton;
                  trget.enable = target != trget;
               }
            }
         }
         else if(e.currentTarget as ButtonXP != null)
         {
            dispatchEvent(new MainButtonBarEvents(13));
         }
      }
   }
}
