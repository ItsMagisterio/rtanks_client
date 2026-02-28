package forms.registration.bubbles
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.help.HelperAlign;
   import alternativa.tanks.locale.constants.TextConst;
   import flash.geom.Point;
   
   public class RegisterBubbleFactory
   {
      
      private static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
       
      
      public function RegisterBubbleFactory()
      {
         super();
      }
      
      public static function passwordIsTooEasyBubble() : Bubble
      {
         return customBubble(localeService.getText(TextConst.REGISTER_FORM_BUBBLE_PASSWORD_SIMPLE),HelperAlign.TOP_LEFT);
      }
      
      public static function passwordsDoNotMatchBubble() : Bubble
      {
         return customBubble(localeService.getText(TextConst.REGISTER_FORM_BUBBLE_PASSWORD_MISMATCH),HelperAlign.TOP_LEFT);
      }
      
      public static function nameIsIncorrectBubble() : Bubble
      {
         return customBubble(localeService.getText(TextConst.REGISTER_FORM_BUBBLE_LOGIN_WRONG),HelperAlign.TOP_LEFT);
      }
      
      private static function customBubble(text:String, arrowAlign:int) : Bubble
      {
         var bubble:Bubble = new Bubble(new Point(10,10));
         bubble.text = text;
         bubble.arrowLehgth = 20;
         bubble.arrowAlign = HelperAlign.TOP_LEFT;
         return bubble;
      }
   }
}
