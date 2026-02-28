package scpacker.gui
{
   import flash.display.Bitmap;
   import flash.utils.ByteArray;
   import sineysoft.WebpSwc;
   
   public class GTanksI implements GTanksLoaderImages
   {
       
      
      private var coldload1:Class;
      
      private var coldload2:Class;
      
      private var coldload3:Class;
      
      private var coldload4:Class;
      
      private var coldload5:Class;
      
      private var coldload6:Class;
      
      private var coldload7:Class;
      
      private var coldload8:Class;
      
      private var coldload9:Class;
      
      private var coldload10:Class;
      
      private var coldload11:Class;
      
      private var coldload12:Class;
      
      private var coldload13:Class;
      
      private var coldload14:Class;
      
      private var coldload15:Class;
      
      private var coldload16:Class;
      
      private var coldload17:Class;
      
      private var coldload18:Class;
      
      private var coldload19:Class;
      
      private var coldload20:Class;
      
      private var coldload21:Class;
      
      private var coldload22:Class;
      
      private var coldload23:Class;
      
      private var coldload24:Class;
      
      private var items:Array;
      
      private var prev:int;
      
      public function GTanksI()
      {
         this.coldload1 = GTanksI_coldload1;
         this.coldload2 = GTanksI_coldload2;
         this.coldload3 = GTanksI_coldload3;
         this.coldload4 = GTanksI_coldload4;
         this.coldload5 = GTanksI_coldload5;
         this.coldload6 = GTanksI_coldload6;
         this.coldload7 = GTanksI_coldload7;
         this.coldload8 = GTanksI_coldload8;
         this.coldload9 = GTanksI_coldload9;
         this.coldload10 = GTanksI_coldload10;
         this.coldload11 = GTanksI_coldload11;
         this.coldload12 = GTanksI_coldload12;
         this.coldload13 = GTanksI_coldload13;
         this.coldload14 = GTanksI_coldload14;
         this.coldload15 = GTanksI_coldload15;
         this.coldload16 = GTanksI_coldload16;
         this.coldload17 = GTanksI_coldload17;
         this.coldload18 = GTanksI_coldload18;
         this.coldload19 = GTanksI_coldload19;
         this.coldload20 = GTanksI_coldload20;
         this.coldload21 = GTanksI_coldload21;
         this.coldload22 = GTanksI_coldload22;
         this.coldload23 = GTanksI_coldload23;
         this.coldload24 = GTanksI_coldload24;
         this.items = new Array(this.coldload1,this.coldload2,this.coldload3,this.coldload4,this.coldload5,this.coldload6,this.coldload7,this.coldload8,this.coldload9,this.coldload10,this.coldload11,this.coldload12,this.coldload13,this.coldload14,this.coldload15,this.coldload16,this.coldload17,this.coldload18,this.coldload19,this.coldload20,this.coldload21,this.coldload22,this.coldload23,this.coldload24);
         super();
      }
      
      public function getRandomPict() : Bitmap
      {
         var r:int = 0;
         while((r = Math.random() * this.items.length) == this.prev)
         {
         }
         return new Bitmap(WebpSwc.decode(new this.items[r]() as ByteArray));
      }
   }
}
