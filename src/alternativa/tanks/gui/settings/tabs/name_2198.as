package alternativa.tanks.gui.settings.tabs
{
   import alternativa.tanks.gui.settings.SettingsWindow;
   import alternativa.tanks.gui.settings.controls.GridLayout;
   import alternativa.tanks.service.settings.name_1086;
   import controls.base.LabelBase;
   import controls.checkbox.CheckBoxBase;
   import controls.name_2873;
   import controls.TankWindowInner;
   import flash.display.Screen;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import package_1.Main;
   import package_280.name_2872;
   import package_3.GPUCapabilities;
   import package_95.IStorageService;
   import projects.tanks.clients.fp10.libraries.name_390;
   
   public class name_2198 extends SettingsTabView
   {
       
      
      private var var_2847:TankWindowInner;
      
      private var var_2846:CheckBoxBase;
      
      private var var_2851:CheckBoxBase;
      
      private var var_2848:CheckBoxBase;
      
      private var var_2853:CheckBoxBase;
      
      private var var_2850:CheckBoxBase;
      
      private var var_2856:CheckBoxBase;
      
      private var var_2855:CheckBoxBase;
      
      private var var_2849:CheckBoxBase;
      
      private var var_2854:CheckBoxBase;
      
      private var var_2845:CheckBoxBase;
      
      private var var_2857:CheckBoxBase;
      
      private var var_2852:CheckBoxBase;
      
      private var var_2844:CheckBoxBase;
      
      private var storage:SharedObject;

      private var var_3399:name_2873;

      private var var_3400:LabelBase;

      private var var_3401:int;

      private var var_3402:int;

      private var var_3403:int;
      
      public function name_2198()
      {
         this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         this.var_3401 = this.method_2688();
         this.var_3402 = this.method_2690(this.method_2689(),this.var_3401);
         var _loc1_:int = 0;
         var _loc2_:GridLayout = null;
         super();
         this.var_2847 = new TankWindowInner(0,0,TankWindowInner.name_2114);
         this.var_2847.width = SettingsWindow.name_2112;
         this.var_2847.y = 0;
         this.var_2847.x = 0;
         addChild(this.var_2847);
         this.var_3400 = new LabelBase();
         this.var_3400.x = 8;
         this.var_3400.y = 8;
         this.method_2692(this.var_3402);
         addChild(this.var_3400);
         this.var_3399 = new name_2873();
         this.var_3399.minValue = 30;
         this.var_3399.maxValue = this.var_3401;
         this.var_3399.tickInterval = 10;
         this.var_3399.width = SettingsWindow.name_2112 - this.var_3400.x - 8;
         this.var_3399.y = this.var_3400.y + this.var_3400.height + 4;
         this.var_3403 = this.var_3399.y + this.var_3399.height + 8;
         this.var_3399.value = this.var_3402;
         this.var_3399.addEventListener(name_2872.name_2874,this.method_2691);
         addChild(this.var_3399);
         this.var_2846 = method_1693(name_1086.name_2215,localeService.getText(name_390.const_785),settingsService.showFPS);
         addChild(this.var_2846);
         this.var_2851 = method_1693(name_1086.name_2206,localeService.getText(name_390.const_1129),settingsService.adaptiveFPS);
         addChild(this.var_2851);
         this.var_2848 = method_1693(name_1086.name_2211,localeService.getText(name_390.const_1144),settingsService.showSkyBox);
         addChild(this.var_2848);
         this.var_2856 = method_1693(name_1086.name_2216,localeService.getText(name_390.const_1177),settingsService.mipMapping);
         addChild(this.var_2856);
         _loc2_ = new GridLayout(8,this.var_3403,SettingsWindow.name_2112 * 0.5,this.var_2846.height + 8);
         if(this.method_2686())
         {
            this.var_2855 = method_1693(name_1086.FOG,localeService.getText(name_390.const_1183),settingsService.fog);
            addChild(this.var_2855);
            this.var_2849 = method_1693(name_1086.name_2205,localeService.getText(name_390.const_1141),settingsService.shadows);
            addChild(this.var_2849);
            this.var_2854 = method_1693(name_1086.name_2207,localeService.getText(name_390.const_666),settingsService.dynamicShadows);
            addChild(this.var_2854);
            this.var_2845 = method_1693(name_1086.name_2204,localeService.getText(name_390.const_797),settingsService.softParticles);
            addChild(this.var_2845);
            this.var_2845.addEventListener(MouseEvent.CLICK,this.method_2682);
            this.var_2857 = method_1693(name_1086.name_2217,localeService.getText(name_390.const_990),settingsService.dust);
            addChild(this.var_2857);
            this.var_2852 = method_1693(name_1086.SSAO,localeService.getText(name_390.const_643),settingsService.ssao);
            addChild(this.var_2852);
            this.var_2853 = method_1693(name_1086.name_2218,localeService.getText(name_390.const_1374),settingsService.antialiasing);
            addChild(this.var_2853);
            this.var_2850 = method_1693(name_1086.name_2210,localeService.getText(name_390.const_1161),settingsService.dynamicLighting);
            addChild(this.var_2850);
            this.method_2685();
            _loc1_ = this.method_2684(_loc2_);
            if(this.var_2844.checked)
            {
               _loc1_ = this.var_2844.y + this.var_2844.height;
            }
         }
         else
         {
            _loc1_ = this.method_2687(_loc2_);
         }
         this.var_2847.height = _loc1_ + 8;
      }
      
      private function method_2686() : Boolean
      {
         return GPUCapabilities.method_95 && !GPUCapabilities.constrained;
      }
      
      private function method_2682(param1:MouseEvent) : void
      {
         this.method_2683();
      }
      
      private function method_2683() : void
      {
         this.var_2857.visible = Boolean(this.var_2845) && !this.var_2844.checked && this.var_2845.checked;
      }
      
      private function method_2685() : void
      {
         this.var_2844 = method_1693(name_1086.name_2201,localeService.getText(name_390.const_544),settingsService.graphicsAutoQuality);
         addChild(this.var_2844);
         this.method_2681();
         this.var_2844.addEventListener(MouseEvent.CLICK,this.method_2681);
      }
      
      private function method_2681(param1:MouseEvent = null) : void
      {
         var _loc2_:Boolean = !this.var_2844.checked;
         this.var_2855.visible = _loc2_;
         this.var_2849.visible = _loc2_;
         this.var_2854.visible = _loc2_;
         this.var_2845.visible = _loc2_;
         this.var_2852.visible = _loc2_;
         this.var_2850.visible = _loc2_;
         this.var_2853.visible = _loc2_;
         this.var_2847.height = (_loc2_ ? Number(7 * this.var_2846.height + 8 * 8) : Number(3 * this.var_2846.height + 4 * 8)) + this.var_3403 - 8;
         this.method_2683();
      }
      
      private function method_2687(param1:GridLayout) : int
      {
         return param1.layout([[this.var_2846,this.var_2851],[this.var_2848,this.var_2856]]);
      }
      
      private function method_2684(param1:GridLayout) : int
      {
         return param1.layout([[this.var_2846,this.var_2851],[this.var_2848,this.var_2856],[this.var_2844],[this.var_2854,this.var_2852],[this.var_2850,this.var_2855],[this.var_2849,this.var_2853],[this.var_2845,this.var_2857]]);
      }
      
      override public function destroy() : void
      {
         this.var_3399.removeEventListener(name_2872.name_2874,this.method_2691);
         if(this.var_2844 != null)
         {
            this.var_2844.removeEventListener(MouseEvent.CLICK,this.method_2681);
         }
         if(this.var_2845 != null)
         {
            this.var_2845.removeEventListener(MouseEvent.CLICK,this.method_2682);
         }
         super.destroy();
      }

      private function method_2688() : int
      {
         if(Screen.mainScreen != null && Screen.mainScreen.refreshRate > 0)
         {
            return this.method_2690(int(Screen.mainScreen.refreshRate),240);
         }
         return 120;
      }

      private function method_2689() : int
      {
         var _loc1_:Number = Number(this.storage.data[name_1086.const_1705.name]);
         if(isNaN(_loc1_))
         {
            _loc1_ = this.var_3401;
         }
         return int(_loc1_);
      }

      private function method_2690(param1:int, param2:int) : int
      {
         if(param1 < 30)
         {
            return 30;
         }
         if(param1 > param2)
         {
            return param2;
         }
         return param1;
      }

      private function method_2691(param1:name_2872) : void
      {
         var _loc2_:int = this.method_2690(int(param1.value),this.var_3401);
         this.var_3399.value = _loc2_;
         this.method_2692(_loc2_);
         settingsService.method_588(name_1086.const_1705,_loc2_);
      }

      private function method_2692(param1:int) : void
      {
         this.var_3400.text = "Предельная частота кадров: (" + param1 + ")";
      }
   }
}
