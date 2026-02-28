package alternativa.tanks.model.challenge
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Sprite;
   
   public class ChallengeWindow extends Sprite
   {
       
      
      private var window:TankWindow;
      
      private var progress:ChallengeProgressBar;
      
      private var list:TierList;
      
      public var closeBtn:DefaultButton;
      
      public function ChallengeWindow()
      {
         this.window = new TankWindow();
         this.progress = new ChallengeProgressBar();
         this.list = new TierList();
         this.closeBtn = new DefaultButton();
         super();
         this.window.width = 600;
         this.window.height = 300;
         this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).language.toLocaleLowerCase();
         this.window.header = TankWindowHeader.ATTANTION;
         addChild(this.window);
         this.window.addChild(this.progress);
         this.progress.y = 15;
         this.progress.x = 16;
         this.progress.width = 565;
         this.window.addChild(this.list);
         this.list.x = 15;
         this.list.y = 43;
         this.list.width = 565;
         this.list.height = this.window.height - 85;
         this.closeBtn.x = this.window.width / 2 - this.closeBtn.width / 2;
         this.closeBtn.y = this.window.height - this.closeBtn.height - 10;
         this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         addChild(this.closeBtn);
      }
      
      public function show(progress_:int, targetProgress:int, currLevel:int, quests:Array) : void
      {
         this.progress.setProgress(progress_ * 100 / targetProgress,progress_,targetProgress);
         this.list.setTiers(quests,currLevel);
      }
   }
}
