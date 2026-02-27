package alternativa.tanks.models.weapon.shotgun.aiming
{
   import alternativa.tanks.models.weapon.shotgun.PelletDirectionCalculator;
   import alternativa.tanks.models.weapon.shotgun.ShotgunRicochetTargetingSystem;
   
   public interface ShotgunAiming
   {
       
      
      function createTargetingSystem() : ShotgunRicochetTargetingSystem;
      
      function method_881() : PelletDirectionCalculator;
   }
}
