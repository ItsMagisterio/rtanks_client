package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelDoubleDonateButton extends MainPanelWideButton
   {
      
      private static const iconN:Class = MainPanelDoubleDonateButton_iconN;
      
      private static const overBtn:Class = MainPanelDoubleDonateButton_overBtn;
      
      private static const normalBtn:Class = MainPanelDoubleDonateButton_normalBtn;
       
      
      public function MainPanelDoubleDonateButton()
      {
         super(new Bitmap(new iconN().bitmapData),5,5,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
