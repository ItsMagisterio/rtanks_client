package alternativa.tanks.models.weapons.discrete
{
   import alternativa.tanks.models.weapon.WeaponObject;
   import package_39.Model;
   import package_4.ClientObject;
   
   public class DiscreteWeaponObject extends WeaponObject
   {
       
      
      public function DiscreteWeaponObject(param1:ClientObject)
      {
         super(param1);
      }
      
      public function name_1449(): DiscreteWeapon
      {
         return DiscreteWeapon(Model.object.name_176(DiscreteWeapon));
      }
   }
}
