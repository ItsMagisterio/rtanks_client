package alternativa.tanks.models.weapon.common
{
   import alternativa.tanks.models.weapon.IWeaponController;
   import package_37.Vector3;
   
   public class WeaponCommonData
   {
       
      
      public var kickback:Number = 0;
      
      public var name_1498:Number = 0;
      
      public var impactForce:Number = 0;
      
      public var turretRotationAccel:Number = 0;
      
      public var turretRotationSpeed:Number = 0;
      
      public var muzzles:Vector.<Vector3>;
      
      public var currBarrel:int;
      
      public var name_1493:IWeaponController;
      
      public function WeaponCommonData()
      {
         super();
      }
   }
}
