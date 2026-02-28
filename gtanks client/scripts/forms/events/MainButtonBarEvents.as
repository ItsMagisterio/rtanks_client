package forms.events
{
   import flash.events.Event;
   
   public class MainButtonBarEvents extends Event
   {
      
      public static const ADDMONEY:String = "AddMoney";
      
      public static const BATTLE:String = "Batle";
      
      public static const GARAGE:String = "Garage";
      
      public static const STAT:String = "Stat";
      
      public static const CLANS:String = "Clans";
      
      public static const SOUND:String = "Sound";
      
      public static const SETTINGS:String = "Settings";
      
      public static const HELP:String = "Help";
      
      public static const CLOSE:String = "Close";
      
      public static const BUGS:String = "Bugs";
      
      public static const EXCHANGE:String = "ChangeMoney";
      
      public static const REFERAL:String = "Referal";
      
      public static const XP:String = "Xp";
      
      public static const PANEL_BUTTON_PRESSED:String = "Close";
       
      
      private var types:Array;
      
      private var _typeButton:String;
      
      public function MainButtonBarEvents(typeButton:int)
      {
         this.types = new Array(ADDMONEY,BATTLE,GARAGE,STAT,SETTINGS,SOUND,HELP,CLOSE,BUGS,EXCHANGE,REFERAL,CLANS,XP);
         super(MainButtonBarEvents.PANEL_BUTTON_PRESSED,true,false);
         this._typeButton = this.types[typeButton - 1];
      }
      
      public function get typeButton() : String
      {
         return this._typeButton;
      }
   }
}
