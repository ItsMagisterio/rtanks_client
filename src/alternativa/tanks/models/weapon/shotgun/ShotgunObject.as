package alternativa.tanks.models.weapon.shotgun
{
   import package_39.Model;
   import package_4.ClientObject;
   import alternativa.tanks.models.weapons.discrete.DiscreteWeaponObject;
   import alternativa.tanks.models.weapon.shotgun.aiming.ShotgunAiming;
   
   public class ShotgunObject extends DiscreteWeaponObject
   {
       
      
      public function ShotgunObject(param1:ClientObject)
      {
         super(param1);
      }
      
      public function method_2196() : PelletDirectionCalculator
      {
         var _loc1_:ShotgunAiming = ShotgunAiming(Model.object.name_176(ShotgunAiming));
         return _loc1_.method_881();
      }
   }
}
