package clan.notifications
{
   import base.class_122;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class ClanJoinButton extends class_122
   {
      
      private static var var_2701:Class = ClanJoinButtonIcon;
      
      private static var var_2700:BitmapData = Bitmap(new var_2701()).bitmapData;
       
      
      public function ClanJoinButton()
      {
         super();
         this.tabChildren = false;
         this.tabEnabled = false;
         this.useHandCursor = true;
         this.buttonMode = true;
         var _loc1_:Bitmap = new Bitmap(var_2700);
         addChild(_loc1_);
      }
   }
}
