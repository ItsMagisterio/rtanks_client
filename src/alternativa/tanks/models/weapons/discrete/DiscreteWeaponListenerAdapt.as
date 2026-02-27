package alternativa.tanks.models.weapons.discrete
{
   import package_37.Vector3;
   import package_39.Model;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete.TargetHit;
   import platform.client.fp10.core.type.name_70;
   
   public class DiscreteWeaponListenerAdapt implements DiscreteWeaponListener
   {
       
      
      private var object:name_70;
      
      private var impl:DiscreteWeaponListener;
      
      public function DiscreteWeaponListenerAdapt(param1:name_70, param2:DiscreteWeaponListener)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }
      
      public function method_796(param1:name_70, param2:Vector3, param3:Vector.<TargetHit>) : void
      {
         var shooter:name_70 = param1;
         var direction:Vector3 = param2;
         var targets:Vector.<TargetHit> = param3;
         try
         {
            Model.object = this.object;
            this.impl.method_796(shooter,direction,targets);
            return;
         }
         finally
         {
            Model.method_38();
         }
      }
   }
}
