package alternativa.tanks.model.challenge
{
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ChallengeProgressBar extends Sprite
   {
      
      private static const bg:Class = ChallengeProgressBar_bg;
      
      private static const bg_bitmap:BitmapData = new bg().bitmapData;
      
      private static const fill_bg:Class = ChallengeProgressBar_fill_bg;
      
      private static const fill_bg_bitmap:BitmapData = new fill_bg().bitmapData;
       
      
      private var point:Point;
      
      private var fillBitmap:Bitmap;
      
      private var label:Label;
      
      public function ChallengeProgressBar()
      {
         super();
         this.point = new Point();
         this.fillBitmap = new Bitmap();
         this.label = new Label();
         addChild(new Bitmap(bg_bitmap));
         addChild(this.fillBitmap);
         this.label.bold = false;
         this.label.color = 5898034;
         this.label.x = 10;
         this.label.y = 2;
         addChild(this.label);
      }
      
      public function setProgress(progress:int, currentScore:int = 453, maxScore:int = 666) : void
      {
         this.label.text = currentScore + " / " + maxScore;
         if(progress == 0)
         {
            this.fillBitmap.bitmapData = null;
            return;
         }
         if(progress == 100)
         {
            this.fillBitmap.bitmapData = fill_bg_bitmap;
            return;
         }
         var _loc4_:Number = bg_bitmap.width * progress / 100;
         var _loc5_:BitmapData = new BitmapData(_loc4_,bg_bitmap.height);
         _loc5_.copyPixels(fill_bg_bitmap,_loc5_.rect,this.point);
         this.fillBitmap.bitmapData = _loc5_;
      }
   }
}
