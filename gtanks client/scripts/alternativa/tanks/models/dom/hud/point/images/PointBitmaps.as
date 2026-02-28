package alternativa.tanks.models.dom.hud.point.images
{
   import flash.display.BitmapData;
   
   public class PointBitmaps
   {
      
      private static var BLUE:Class = PointBitmaps_BLUE;
      
      public static var BLUE_POINT:BitmapData = new BLUE().bitmapData;
      
      private static var NETURAL:Class = PointBitmaps_NETURAL;
      
      public static var NETURAL_POINT:BitmapData = new NETURAL().bitmapData;
      
      private static var RED:Class = PointBitmaps_RED;
      
      public static var RED_POINT:BitmapData = new RED().bitmapData;
       
      
      public function PointBitmaps()
      {
         super();
      }
   }
}
