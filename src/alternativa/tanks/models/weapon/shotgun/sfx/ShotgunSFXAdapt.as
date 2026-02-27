package alternativa.tanks.models.weapon.shotgun.sfx
{
   import package_39.Model;
   import platform.client.fp10.core.type.name_70;
   
   public class ShotgunSFXAdapt implements ShotgunSFX
   {
       
      
      private var object:name_70;
      
      private var impl:ShotgunSFX;
      
      public function ShotgunSFXAdapt(param1:name_70, param2:ShotgunSFX)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }
      
      public function getEffects() : ShotgunEffects
      {
         var result:ShotgunEffects = null;
         try
         {
            Model.object = this.object;
            result = this.impl.getEffects();
         }
         finally
         {
            Model.method_38();
         }
         return result;
      }
   }
}
