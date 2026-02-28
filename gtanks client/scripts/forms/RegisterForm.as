package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.captcha.CaptchaForm;
   import assets.icons.InputCheckIcon;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import forms.events.LoginFormEvent;
   import forms.registration.bubbles.Bubble;
   import forms.registration.bubbles.RegisterBubbleFactory;
   
   public class RegisterForm extends Sprite
   {
      
      public static const CALLSIGN_STATE_OFF:int = 0;
      
      public static const CALLSIGN_STATE_PROGRESS:int = 1;
      
      public static const CALLSIGN_STATE_VALID:int = 2;
      
      public static const CALLSIGN_STATE_INVALID:int = 3;
      
      private static var background:Class = RegisterForm_background;
      
      private static var backgroundImage:Bitmap = new Bitmap(new background().bitmapData);
       
      
      private var backgroundContainer:Sprite;
      
      public var callSign:TankInput;
      
      public var pass1:TankInput;
      
      public var pass2:TankInput;
      
      private var callSignCheckIcon:InputCheckIcon;
      
      private var pass1CheckIcon:InputCheckIcon;
      
      private var pass2CheckIcon:InputCheckIcon;
      
      private var nameIncorrectBubble:Bubble;
      
      private var passwordsDoNotMatchBubble:Bubble;
      
      private var passwordEasyBubble:Bubble;
      
      public var chekRemember:TankCheckBox;
      
      public var playButton:DefaultButton;
      
      public var loginButton:Label;
      
      public var rulesButton:Label;
      
      public var captchaView:CaptchaForm;
      
      private var label:Label;
      
      private var bg:TankWindow;
      
      private var p:Number = 0.5;
      
      public function RegisterForm(antiAddictionEnabled:Boolean)
      {
         this.backgroundContainer = new Sprite();
         this.callSign = new TankInput();
         this.pass1 = new TankInput();
         this.pass2 = new TankInput();
         this.callSignCheckIcon = new InputCheckIcon();
         this.pass1CheckIcon = new InputCheckIcon();
         this.pass2CheckIcon = new InputCheckIcon();
         this.nameIncorrectBubble = RegisterBubbleFactory.nameIsIncorrectBubble();
         this.passwordsDoNotMatchBubble = RegisterBubbleFactory.passwordsDoNotMatchBubble();
         this.passwordEasyBubble = RegisterBubbleFactory.passwordIsTooEasyBubble();
         this.chekRemember = new TankCheckBox();
         this.playButton = new DefaultButton();
         this.loginButton = new Label();
         this.label = new Label();
         this.bg = new TankWindow(380,290);
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var title:Label = new Label();
         addChild(this.backgroundContainer);
         this.backgroundContainer.addChild(backgroundImage);
         addChild(this.bg);
         this.bg.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.bg.header = TankWindowHeader.REGISTER;
         this.bg.addChild(title);
         this.bg.addChild(this.callSign);
         this.bg.addChild(this.pass1);
         this.bg.addChild(this.pass2);
         this.bg.addChild(this.chekRemember);
         this.bg.addChild(this.playButton);
         this.bg.addChild(this.loginButton);
         this.bg.addChild(this.callSignCheckIcon);
         this.bg.addChild(this.pass1CheckIcon);
         this.bg.addChild(this.pass2CheckIcon);
         title.x = 25;
         title.y = 23;
         title.text = localeService.getText(TextConst.REGISTER_FORM_HEADER_TEXT);
         this.loginButton.htmlText = localeService.getText(TextConst.REGISTER_FORM_BUTTON_LOGIN_TEXT);
         this.loginButton.x = title.x + title.width;
         this.loginButton.y = 23;
         this.callSign.x = 80;
         this.callSign.y = 60;
         this.callSign.maxChars = 20;
         this.callSign.tabIndex = 0;
         this.callSign.restrict = ".0-9a-zA-z_\\-";
         this.callSign.label = localeService.getText(TextConst.REGISTER_FORM_CALLSIGN_INPUT_LABEL_TEXT);
         this.callSign.validValue = true;
         this.callSign.width = 275;
         this.callSignCheckIcon.x = 330;
         this.callSignCheckIcon.y = this.callSign.y + 7;
         this.callSignState = CALLSIGN_STATE_OFF;
         this.pass1.x = 80;
         this.pass1.y = this.callSign.y + 40;
         this.pass1.label = localeService.getText(TextConst.REGISTER_FORM_PASSWORD_INPUT_LABEL_TEXT);
         this.pass1.maxChars = 46;
         this.pass1.hidden = true;
         this.pass1.validValue = true;
         this.pass1.width = 275;
         this.pass1.tabIndex = 1;
         this.pass1CheckIcon.x = 330;
         this.pass1CheckIcon.y = this.pass1.y + 7;
         this.pass1CheckIcon.visible = false;
         this.pass2.x = 80;
         this.pass2.y = this.pass1.y + 40;
         this.pass2.label = localeService.getText(TextConst.REGISTER_FORM_REPEAT_PASSWORD_INPUT_LABEL_TEXT);
         this.pass2.maxChars = 46;
         this.pass2.hidden = true;
         this.pass2.validValue = true;
         this.pass2.width = 275;
         this.pass2.tabIndex = 2;
         this.pass2CheckIcon.x = 330;
         this.pass2CheckIcon.y = this.pass2.y + 7;
         this.pass2CheckIcon.visible = false;
         this.label.x = 113;
         this.label.y = 195;
         this.label.text = localeService.getText(TextConst.REGISTER_FORM_REMEMBER_ME_CHECKBOX_LABEL_TEXT);
         this.bg.addChild(this.label);
         this.chekRemember.x = 80;
         this.chekRemember.y = 190;
         this.playButton.x = 255;
         this.playButton.y = 190;
         this.playButton.label = localeService.getText(TextConst.REGISTER_FORM_BUTTON_PLAY_TEXT);
         this.playButton.enable = false;
         this.rulesButton = new Label();
         this.rulesButton.x = 25;
         this.rulesButton.y = 235;
         this.rulesButton.htmlText = localeService.getText(TextConst.REGISTER_FORM_AGREEMENT_NOTE_TEXT);
         this.bg.addChild(this.rulesButton);
         this.callSignCheckIcon.addChild(this.nameIncorrectBubble);
         this.pass1CheckIcon.addChild(this.passwordEasyBubble);
         this.pass2CheckIcon.addChild(this.passwordsDoNotMatchBubble);
         this.callSign.addEventListener(FocusEvent.FOCUS_OUT,this.validateCallSign);
         this.pass1.addEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass1.addEventListener(LoginFormEvent.TEXT_CHANGED,this.validatePassword);
         this.pass2.addEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass2.addEventListener(LoginFormEvent.TEXT_CHANGED,this.validatePassword);
      }
      
      public function set callSignState(value:int) : void
      {
         this.nameIncorrectBubble.visible = false;
         if(value == CALLSIGN_STATE_OFF)
         {
            this.callSignCheckIcon.visible = false;
         }
         else
         {
            this.callSignCheckIcon.visible = true;
            this.callSignCheckIcon.gotoAndStop(value);
            if(value != CALLSIGN_STATE_INVALID)
            {
               this.callSign.validValue = true;
               this.validatePassword(null);
            }
            else
            {
               this.nameIncorrectBubble.visible = true;
               this.callSign.validValue = false;
               this.pass1.validValue = this.pass2.validValue = true;
               this.pass1CheckIcon.visible = this.pass2CheckIcon.visible = false;
               this.passwordsDoNotMatchBubble.visible = this.passwordEasyBubble.visible = false;
            }
         }
      }
      
      private function switchPlayButton(event:Event) : void
      {
         this.playButton.enable = this.callSign.validValue && this.callSign.value != "" && (this.pass1.validValue && this.pass1.value != "") && (this.pass2.validValue && this.pass2.value != "");
      }
      
      private function validatePassword(event:Event) : void
      {
         var verySimplePassword:Boolean = false;
         this.passwordsDoNotMatchBubble.visible = this.passwordEasyBubble.visible = false;
         if(!this.callSign.validValue || this.pass1.value == "" && this.pass2.value == "")
         {
            this.pass1.validValue = this.pass2.validValue = true;
            this.pass1CheckIcon.visible = this.pass2CheckIcon.visible = false;
         }
         else if(this.pass1.value != this.pass2.value)
         {
            this.pass1.validValue = true;
            this.pass1CheckIcon.visible = false;
            this.pass2.validValue = false;
            this.pass2CheckIcon.visible = true;
            this.pass2CheckIcon.gotoAndStop(3);
            this.passwordsDoNotMatchBubble.visible = true;
         }
         else
         {
            verySimplePassword = this.pass1.value == this.callSign.value || this.pass1.value.length < 4 || this.pass1.value == "12345" || this.pass1.value == "qwerty";
            this.pass2.validValue = true;
            this.pass2CheckIcon.visible = true;
            this.pass2CheckIcon.gotoAndStop(2);
            this.pass1.validValue = !verySimplePassword;
            this.pass1CheckIcon.visible = true;
            if(!this.pass1.validValue)
            {
               this.pass1CheckIcon.gotoAndStop(3);
               this.passwordEasyBubble.visible = true;
            }
            else
            {
               this.pass1CheckIcon.gotoAndStop(2);
            }
         }
         this.switchPlayButton(event);
      }
      
      private function validateCallSign(event:Event) : void
      {
         this.switchPlayButton(null);
      }
      
      public function playButtonActivate() : void
      {
         this.playButton.enable = true;
      }
      
      public function hide() : void
      {
         this.callSign.removeEventListener(FocusEvent.FOCUS_OUT,this.validateCallSign);
         this.pass1.removeEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass1.removeEventListener(LoginFormEvent.TEXT_CHANGED,this.validatePassword);
         this.pass2.removeEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass2.removeEventListener(LoginFormEvent.TEXT_CHANGED,this.validatePassword);
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function onResize(e:Event) : void
      {
         this.bg.x = int(stage.stageWidth / 2 - this.bg.width / 2);
         this.bg.y = int(stage.stageHeight / 2 - this.bg.height / 2) + 100;
         backgroundImage.x = int(Main.stage.stageWidth - backgroundImage.width >> 1);
         backgroundImage.y = 110;
      }
      
      public function captcha(value:Boolean) : void
      {
         var height:Number = NaN;
         if(value && this.captchaView == null)
         {
            this.captchaView = new CaptchaForm();
            this.bg.addChild(this.captchaView);
            this.bg.addChild(this.pass2CheckIcon);
            this.bg.addChild(this.pass1CheckIcon);
            this.bg.addChild(this.callSignCheckIcon);
            this.captchaView.y = this.pass2.y + 47;
            this.captchaView.x = 80;
            height = this.captchaView.height + 17;
            this.bg.height += height;
            this.playButton.y += height;
            this.chekRemember.y += height;
            this.label.y += height;
            this.rulesButton.y += height;
            y -= this.captchaView.height;
            this.p = this.y / stage.height;
            this.onResize(null);
         }
      }
   }
}
