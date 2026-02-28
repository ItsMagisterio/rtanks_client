package alternativa.tanks.loader
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class ProgressBar extends Sprite
   {
      
      private static const bitmapBar:Class = ProgressBar_bitmapBar;
      
      public static const barBd:BitmapData = new bitmapBar().bitmapData;
      
      private static const bitmapLampOn:Class = ProgressBar_bitmapLampOn;
      
      private static const lampOnBd:BitmapData = new bitmapLampOn().bitmapData;
      
      private static const bitmapLampOff:Class = ProgressBar_bitmapLampOff;
      
      private static const lampOffBd:BitmapData = new bitmapLampOff().bitmapData;
       
      
      private var bar:Bitmap;
      
      private var lamps:Array;
      
      private const lampsNum:int = 20;
      
      private const margin:int = 6;
      
      private const space:int = -2;
      
      public function ProgressBar()
      {
         var lamp:Bitmap = null;
         super();
         this.bar = new Bitmap(barBd);
         addChild(this.bar);
         this.lamps = new Array();
         for(var i:int = 0; i < this.lampsNum; i++)
         {
            lamp = new Bitmap(lampOffBd);
            addChild(lamp);
            this.lamps.push(lamp);
            lamp.x = this.margin + (lampOffBd.width + this.space) * i;
            lamp.y = Math.round((this.bar.height - lampOffBd.height) * 0.5);
         }
      }
      
      public function set progress(value:Number) : void
      {
         var lamp:Bitmap = null;
         var n:int = Math.floor(this.lampsNum * value);
         for(var i:int = 0; i < this.lampsNum; i++)
         {
            lamp = this.lamps[i] as Bitmap;
            if(i < n)
            {
               lamp.bitmapData = lampOnBd;
            }
            else
            {
               lamp.bitmapData = lampOffBd;
            }
         }
      }
   }
}
