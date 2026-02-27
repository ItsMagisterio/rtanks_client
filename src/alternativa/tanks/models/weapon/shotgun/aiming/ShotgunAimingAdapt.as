package alternativa.tanks.models.weapon.shotgun.aiming
{
   import alternativa.tanks.models.weapon.shotgun.PelletDirectionCalculator;
   import alternativa.tanks.models.weapon.shotgun.ShotgunRicochetTargetingSystem;
   import package_39.Model;
   import platform.client.fp10.core.type.name_70;
   
   public class ShotgunAimingAdapt implements ShotgunAiming
   {
       
      
      private var object:name_70;
      
      private var impl:ShotgunAiming;
      
      public function ShotgunAimingAdapt(param1:name_70, param2:ShotgunAiming)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }
      
      public function createTargetingSystem() : ShotgunRicochetTargetingSystem
      {
         var result:ShotgunRicochetTargetingSystem = null;
         try
         {
            Model.object = this.object;
            result = this.impl.createTargetingSystem();
         }
         finally
         {
            Model.method_38();
         }
         return result;
      }
      
      public function method_881() : PelletDirectionCalculator
      {
         var result:PelletDirectionCalculator = null;
         try
         {
            Model.object = this.object;
            result = this.impl.method_881();
         }
         finally
         {
            Model.method_38();
         }
         return result;
      }
   }
}
