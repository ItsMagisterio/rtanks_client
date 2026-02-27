package alternativa.tanks.models.weapon.shotgun.sfx
{
   import package_39.Model;
   import platform.client.fp10.core.type.name_70;
   
   public class ShotgunSFXEvents implements ShotgunSFX
   {
       
      
      private var object:name_70;
      
      private var impl:Vector.<Object>;
      
      public function ShotgunSFXEvents(param1:name_70, param2:Vector.<Object>)
      {
         super();
         this.object = param1;
         this.impl = param2;
      }
      
      public function getEffects() : ShotgunEffects
      {
         var result:ShotgunEffects = null;
         var i:int = 0;
         var m:ShotgunSFX = null;
         try
         {
            Model.object = this.object;
            i = 0;
            while(i < this.impl.length)
            {
               m = ShotgunSFX(this.impl[i]);
               result = m.getEffects();
               i++;
            }
         }
         finally
         {
            Model.method_38();
         }
         return result;
      }
   }
}
