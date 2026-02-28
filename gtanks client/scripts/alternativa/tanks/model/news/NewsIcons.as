package alternativa.tanks.model.news
{
   import flash.display.BitmapData;
   
   public class NewsIcons
   {
      
      private static const crystalls_box:Class = NewsIcons_crystalls_box;
      
      private static const crystalls_book:Class = NewsIcons_crystalls_book;
      
      private static const fev_14:Class = NewsIcons_fev_14;
      
      private static const crystall:Class = NewsIcons_crystall;
      
      private static const magazine:Class = NewsIcons_magazine;
      
      private static const hand_crystalls:Class = NewsIcons_hand_crystalls;
      
      private static const happy_birthday:Class = NewsIcons_happy_birthday;
      
      private static const helm_space:Class = NewsIcons_helm_space;
      
      private static const news_lamp:Class = NewsIcons_news_lamp;
      
      private static const no_cheats:Class = NewsIcons_no_cheats;
      
      private static const shaft:Class = NewsIcons_shaft;
      
      private static const shaft_secret:Class = NewsIcons_shaft_secret;
      
      private static const sale_20:Class = NewsIcons_sale_20;
      
      private static const shaft_targeting:Class = NewsIcons_shaft_targeting;
      
      private static const technical:Class = NewsIcons_technical;
      
      private static const fight:Class = NewsIcons_fight;
      
      private static const update:Class = NewsIcons_update;
      
      private static const ml5:Class = NewsIcons_ml5;
      
      private static const _8march:Class = NewsIcons__8march;
      
      private static var instance:NewsIcons = new NewsIcons();
      
      private static var Y:int = 100;
       
      
      private var crystalls_box_bd:BitmapData;
      
      private var crystalls_book_bd:BitmapData;
      
      private var fev_14_bd:BitmapData;
      
      private var crystall_bd:BitmapData;
      
      private var magazine_bd:BitmapData;
      
      private var hand_crystalls_bd:BitmapData;
      
      private var happy_birthday_bd:BitmapData;
      
      private var helm_space_bd:BitmapData;
      
      private var news_lamp_bd:BitmapData;
      
      private var no_cheats_bd:BitmapData;
      
      private var shaft_bd:BitmapData;
      
      private var shaft_secret_bd:BitmapData;
      
      private var sale_20_bd:BitmapData;
      
      private var shaft_targeting_bd:BitmapData;
      
      private var technical_bd:BitmapData;
      
      private var fight_bd:BitmapData;
      
      private var update_bd:BitmapData;
      
      private var ml5_bd:BitmapData;
      
      private var _8_march_bd:BitmapData;
      
      public function NewsIcons()
      {
         this.crystalls_box_bd = new crystalls_box().bitmapData;
         this.crystalls_book_bd = new crystalls_book().bitmapData;
         this.fev_14_bd = new fev_14().bitmapData;
         this.crystall_bd = new crystall().bitmapData;
         this.magazine_bd = new magazine().bitmapData;
         this.hand_crystalls_bd = new hand_crystalls().bitmapData;
         this.happy_birthday_bd = new happy_birthday().bitmapData;
         this.helm_space_bd = new helm_space().bitmapData;
         this.news_lamp_bd = new news_lamp().bitmapData;
         this.no_cheats_bd = new no_cheats().bitmapData;
         this.shaft_bd = new shaft().bitmapData;
         this.shaft_secret_bd = new shaft_secret().bitmapData;
         this.sale_20_bd = new sale_20().bitmapData;
         this.shaft_targeting_bd = new shaft_targeting().bitmapData;
         this.technical_bd = new technical().bitmapData;
         this.fight_bd = new fight().bitmapData;
         this.update_bd = new update().bitmapData;
         this.ml5_bd = new ml5().bitmapData;
         this._8_march_bd = new _8march().bitmapData;
         super();
      }
      
      public static function getIcon(id:String) : BitmapData
      {
         var bitmapData:BitmapData = instance.update_bd;
         try
         {
            bitmapData = instance[id + "_bd"];
         }
         catch(e:Error)
         {
            bitmapData = instance.update_bd;
         }
         return bitmapData;
      }
   }
}
