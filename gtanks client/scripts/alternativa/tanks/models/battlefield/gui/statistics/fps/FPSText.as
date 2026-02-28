package alternativa.tanks.models.battlefield.gui.statistics.fps
{
   import alternativa.tanks.utils.MathUtils;
   import controls.Label;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   
   public class FPSText extends Sprite
   {
       
      
      private const OFFSET_X:int = 70;
      
      private const OFFSET_Y:int = 74;
      
      private const FPS_OFFSET_X:int = 60;
      
      private const NUM_FRAMES:int = 10;
      
      private var fps:Label;
      
      private var label:Label;
      
      private var tfDelay:int = 0;
      
      private var tfTimer:int;
      
      private var filter:DropShadowFilter;
      
      public var colored:Boolean = false;
      
      public function FPSText(color:Boolean = false)
      {
         this.fps = new Label();
         this.label = new Label();
         this.filter = new DropShadowFilter(0,0,0,1,2,2,3,3,false,false,false);
         super();
         this.colored = color;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(e:Event) : void
      {
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.color = 16777215;
         this.label.text = "FPS: ";
         this.label.selectable = false;
         addChild(this.label);
         this.fps.autoSize = TextFieldAutoSize.RIGHT;
         this.fps.color = 16777215;
         this.fps.text = Number(stage.frameRate).toFixed(2);
         this.fps.selectable = false;
         this.fps.bold = true;
         if(this.colored)
         {
            this.fps.filters = [this.filter];
         }
         addChild(this.fps);
         this.tfTimer = getTimer();
         this.onResize(null);
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var delta:uint = 0;
         var offset:Number = NaN;
         var r:String = null;
         var g:String = null;
         if(++this.tfDelay >= this.NUM_FRAMES)
         {
            delta = this.tfTimer;
            this.tfTimer = getTimer();
            delta = this.tfTimer - delta;
            this.fps.text = Number(1000 * this.tfDelay / delta).toFixed(2);
            if(this.colored)
            {
               offset = Number(this.fps.text) / 60;
               r = MathUtils.clamp(255 * (1 - offset) + 150,0,255).toString(16);
               g = MathUtils.clamp(255 * offset + 150,0,255).toString(16);
               this.fps.color = uint("0x" + (r == "0" ? "00" : r) + (g == "0" ? "00" : g) + "00");
               this.fps.filters = [this.filter];
            }
            else
            {
               this.fps.color = 16777215;
               this.fps.filters = null;
            }
            this.tfDelay = 0;
         }
      }
      
      private function onResize(e:Event) : void
      {
         x = stage.stageWidth - this.OFFSET_X;
         y = stage.stageHeight - this.OFFSET_Y;
         this.fps.x = this.FPS_OFFSET_X - this.fps.width;
      }
   }
}
