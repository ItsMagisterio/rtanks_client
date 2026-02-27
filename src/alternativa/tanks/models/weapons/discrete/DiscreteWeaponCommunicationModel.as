package alternativa.tanks.models.weapons.discrete
{
   import alternativa.tanks.battle.BattleUtils;
   import package_37.Vector3;
   import package_67.Vector3d;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete.DiscreteWeaponCommunicationModelBase;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete.TargetHit;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete.IDiscreteWeaponCommunicationModelBase;
   import platform.client.fp10.core.type.name_70;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.name_1378;
   
   public class DiscreteWeaponCommunicationModel extends DiscreteWeaponCommunicationModelBase implements IDiscreteWeaponCommunicationModelBase, DiscreteWeapon
   {
       
      
      public function DiscreteWeaponCommunicationModel()
      {
         super();
      }
      
      public function shoot(param1:name_70, param2:Vector3d, param3:Vector.<TargetHit>) : void
      {
         var _loc4_:DiscreteWeaponListener = DiscreteWeaponListener(object.event(DiscreteWeaponListener));
         _loc4_.method_796(param1,BattleUtils.getVector3(param2),param3);
      }
      
      public function method_909(param1:int, param2:Vector3, param3:Vector.<name_1378>) : void
      {
         server.method_909(param1,BattleUtils.getVector3d(param2),param3);
      }
      
      public function method_910(param1:int, param2:Vector3) : void
      {
         server.method_910(param1,BattleUtils.getVector3d(param2));
      }
   }
}
