package alternativa.tanks.models.weapons.discrete
{
   import package_37.Vector3;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete.TargetHit;
   import platform.client.fp10.core.type.name_70;
   
   public interface DiscreteWeaponListener
   {
       
      
      function method_796(param1:name_70, param2:Vector3, param3:Vector.<TargetHit>) : void;
   }
}
