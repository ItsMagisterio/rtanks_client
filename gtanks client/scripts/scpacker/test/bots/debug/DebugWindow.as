package scpacker.test.bots.debug
{
   import alternativa.init.Main;
   import controls.Label;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class DebugWindow extends Sprite
   {
      
      public static var INSTANCE:DebugWindow = new DebugWindow();
       
      
      private var bot2label:Dictionary;
      
      public function DebugWindow()
      {
         super();
         this.bot2label = new Dictionary();
      }
      
      public function botToDebug(name:String) : void
      {
         this.addToStage();
         var label:Label = new Label();
         label.text = "Bot " + name;
         label.x = 10;
         label.y = 60 + this.getSize() * 10;
         addChild(label);
         this.bot2label[name] = label;
      }
      
      public function botFromDebug(name:String) : void
      {
         var label:Label = this.bot2label[name];
         removeChild(label);
      }
      
      public function updateInfo(name:String, info:String) : void
      {
         var label:Label = this.bot2label[name];
         label.text = "Bot " + name + " " + info;
      }
      
      public function addToStage() : void
      {
         if(!Main.stage.contains(this))
         {
            Main.stage.addChild(this);
         }
      }
      
      public function removeFromStage() : void
      {
         if(Main.stage.contains(this))
         {
            Main.stage.removeChild(this);
         }
         INSTANCE = new DebugWindow();
      }
      
      private function getSize() : int
      {
         var key:* = undefined;
         var n:int = 0;
         for(key in this.bot2label)
         {
            n++;
         }
         return n;
      }
   }
}
