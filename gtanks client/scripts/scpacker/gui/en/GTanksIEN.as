package scpacker.gui.en
{
   import flash.display.Bitmap;
   import flash.utils.ByteArray;
   import scpacker.gui.GTanksLoaderImages;
   import sineysoft.WebpSwc;
   
   public class GTanksIEN implements GTanksLoaderImages
   {
       
      
      private var _1:Class;
      
      private var _10:Class;
      
      private var _11:Class;
      
      private var _12:Class;
      
      private var _13:Class;
      
      private var _14:Class;
      
      private var _15:Class;
      
      private var _16:Class;
      
      private var _17:Class;
      
      private var _18:Class;
      
      private var _19:Class;
      
      private var _2:Class;
      
      private var _20:Class;
      
      private var _21:Class;
      
      private var _22:Class;
      
      private var _23:Class;
      
      private var _24:Class;
      
      private var _3:Class;
      
      private var _4:Class;
      
      private var _5:Class;
      
      private var _6:Class;
      
      private var _7:Class;
      
      private var _8:Class;
      
      private var _9:Class;
      
      private var items:Array;
      
      private var prev:int;
      
      public function GTanksIEN()
      {
         this._1 = GTanksIEN__1;
         this._10 = GTanksIEN__10;
         this._11 = GTanksIEN__11;
         this._12 = GTanksIEN__12;
         this._13 = GTanksIEN__13;
         this._14 = GTanksIEN__14;
         this._15 = GTanksIEN__15;
         this._16 = GTanksIEN__16;
         this._17 = GTanksIEN__17;
         this._18 = GTanksIEN__18;
         this._19 = GTanksIEN__19;
         this._2 = GTanksIEN__2;
         this._20 = GTanksIEN__20;
         this._21 = GTanksIEN__21;
         this._22 = GTanksIEN__22;
         this._23 = GTanksIEN__23;
         this._24 = GTanksIEN__24;
         this._3 = GTanksIEN__3;
         this._4 = GTanksIEN__4;
         this._5 = GTanksIEN__5;
         this._6 = GTanksIEN__6;
         this._7 = GTanksIEN__7;
         this._8 = GTanksIEN__8;
         this._9 = GTanksIEN__9;
         this.items = new Array(this._1,this._10,this._11,this._12,this._13,this._14,this._15,this._16,this._17,this._18,this._19,this._2,this._20,this._21,this._22,this._23,this._24,this._3,this._4,this._5,this._6,this._7,this._8,this._9);
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
