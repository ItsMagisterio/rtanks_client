package alternativa.tanks.models.weapon.shared.streamweapon
{
   import alternativa.physics.Body;
   import alternativa.tanks.models.weapon.shared.name_1742;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class DefaultConicAreaTargetValidator implements name_1742
   {
       
      
      public function DefaultConicAreaTargetValidator()
      {
         super();
      }
      
      public function name_2686(param1:Body) : Boolean
      {
         var _loc2_:Tank = param1 as Tank;
         return _loc2_ != null && _loc2_.tankData.health > 0;
      }
   }
}
