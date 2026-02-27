package alternativa.tanks.models.weapons.discrete
{
   import package_37.Vector3;
   import package_39.Model;
   import projects.tanks.client.battlefield.models.tankparts.weapons.common.discrete.TargetHit;
   import platform.client.fp10.core.model.name_66;
   import platform.client.fp10.core.type.name_70;
   
   public class DiscreteWeaponListenerEvents implements DiscreteWeaponListener
   {
       
      
      private var object:name_70;
      
      private var impl:Vector.<DiscreteWeaponListener>;
      
      public function DiscreteWeaponListenerEvents(param1:name_70, param2:Vector.<name_66>)
      {
         super();
         this.object = param1;
         this.impl = new Vector.<DiscreteWeaponListener>();
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            this.impl.push(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      public function method_796(param1:name_70, param2:Vector3, param3:Vector.<TargetHit>) : void
      {
         var i:int = 0;
         var m:DiscreteWeaponListener = null;
         var shooter:name_70 = param1;
         var direction:Vector3 = param2;
         var targets:Vector.<TargetHit> = param3;
         try
         {
            Model.object = this.object;
            i = 0;
            while(i < this.impl.length)
            {
               m = DiscreteWeaponListener(this.impl[i]);
               m.method_796(shooter,direction,targets);
               i++;
            }
            return;
         }
         finally
         {
            Model.method_38();
         }
      }
   }
}
