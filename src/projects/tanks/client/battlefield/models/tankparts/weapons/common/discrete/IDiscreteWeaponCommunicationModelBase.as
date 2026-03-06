package projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete
{
   import package_67.Vector3d;
   import platform.client.fp10.core.type.name_70;
   
   public interface IDiscreteWeaponCommunicationModelBase
   {
       
      
      function shoot(param1:name_70, param2:Vector3d, param3:Vector.<TargetHit>) : void;
   }
}
