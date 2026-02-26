package alternativa.tanks.models.battlefield
{
   import alternativa.tanks.service.settings.SettingsService;
   import alternativa.tanks.service.settings.name_1086;
   import flash.display.Screen;
   import alternativa.tanks.models.battlefield.logic.class_23;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import package_12.name_24;
   import package_3.GPUCapabilities;
   
   public class name_284 implements class_23
   {
      
      public static var battleService:IBattleField;
      
      public static var display:name_24;
      
      private static const const_410:Number = 60;
      
      private static const const_411:Number = 40;
      
      private static const const_409:int = 10;
      
      private static const const_412:int = 30;
       
      
      private var stage:Stage;
      
      private var var_606:name_668;
      
      private var var_604:int;
      
      private var frameCounter:int;
      
      private var var_608:Number;
      
      private var var_607:String;
      
      private var var_605:Boolean;
      
      public function name_284(param1:Stage, param2:name_668)
      {
         super();
         this.stage = param1;
         this.var_606 = param2;
         this.method_831();
         this.method_825();
         this.method_827();
      }
      
      private function method_825() : void
      {
         this.var_608 = this.stage.frameRate;
         this.var_607 = this.stage.quality;
      }
      
      private function method_827() : void
      {
         this.stage.frameRate = this.var_604;
         if(GPUCapabilities.method_95)
         {
            this.stage.quality = StageQuality.MEDIUM;
         }
         else
         {
            this.stage.quality = StageQuality.LOW;
         }
      }
      
      public function name_766() : void
      {
         this.stage.frameRate = this.var_608;
         this.stage.quality = this.var_607;
      }
      
      private function method_831() : void
      {
         var _loc1_:int = this.method_833();
         if(GPUCapabilities.method_95)
         {
            this.var_604 = _loc1_ < 60 ? _loc1_ : 60;
         }
         else
         {
            this.var_604 = _loc1_ < 40 ? _loc1_ : 40;
         }
      }

      private function method_833() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(SettingsService.storageService != null)
         {
            _loc1_ = Number(SettingsService.storageService.getStorage().data[name_1086.const_1705.name]);
            if(!isNaN(_loc1_))
            {
               return this.method_834(_loc1_);
            }
         }
         if(Screen.mainScreen != null)
         {
            _loc2_ = Screen.mainScreen.refreshRate;
            if(_loc2_ > 0)
            {
               return this.method_834(_loc2_);
            }
         }
         return 120;
      }

      private function method_834(param1:Number) : int
      {
         var _loc2_:int = int(param1);
         if(_loc2_ < 30)
         {
            _loc2_ = 30;
         }
         if(_loc2_ > 240)
         {
            _loc2_ = 240;
         }
         return _loc2_;
      }
      
      public function name_674(param1:Boolean) : void
      {
         if(param1)
         {
            this.method_826();
         }
         else
         {
            this.method_829();
         }
      }
      
      private function method_826() : void
      {
         if(!this.var_605)
         {
            battleService.name_165().name_212(this);
            this.var_605 = true;
         }
      }
      
      private function method_829() : void
      {
         if(this.var_605)
         {
            battleService.name_165().name_977(this);
            this.var_605 = false;
            this.stage.frameRate = this.var_604;
         }
      }
      
      public function method_504(param1:int, param2:int) : void
      {
         ++this.frameCounter;
         if(this.frameCounter == 30)
         {
            this.frameCounter = 0;
            if(this.method_832())
            {
               this.method_828();
            }
            else
            {
               this.method_830();
            }
         }
      }
      
      private function method_832() : Boolean
      {
         return this.var_606.fps < display.stage.frameRate - 1;
      }
      
      private function method_828() : void
      {
         display.stage.frameRate = this.var_606.fps < 10 ? Number(10) : Number(this.var_606.fps);
      }
      
      private function method_830() : void
      {
         var _loc1_:Number = display.stage.frameRate + 1;
         display.stage.frameRate = _loc1_ > this.var_604 ? Number(this.var_604) : Number(_loc1_);
      }
   }
}
