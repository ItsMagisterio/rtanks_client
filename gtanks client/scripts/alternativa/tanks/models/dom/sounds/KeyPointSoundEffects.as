package alternativa.tanks.models.dom.sounds
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import flash.media.Sound;
   
   public class KeyPointSoundEffects
   {
      
      private static var objectPoolService:IObjectPoolService;
       
      
      private var battleService:BattlefieldModel;
      
      private var activationSound:Sound;
      
      private var deactivationSound:Sound;
      
      private var activationSoundEffect:ISound3DEffect;
      
      private var deactivationSoundEffect:ISound3DEffect;
      
      public function KeyPointSoundEffects(param2:Sound, param3:Sound)
      {
         super();
         this.activationSound = param2;
         this.deactivationSound = param3;
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         this.battleService = Main.osgi.getService(IBattleField) as BattlefieldModel;
      }
      
      public function playActivationSound(param1:Vector3) : void
      {
         var sound3d:Sound3D = null;
         this.stopDeactivationSoundEffect();
         if(this.activationSoundEffect == null)
         {
            sound3d = Sound3D.create(this.activationSound,1500,5000,10,1.3);
            this.activationSoundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,param1,sound3d,0,0,999999);
            this.battleService.addSound3DEffect(this.activationSoundEffect);
         }
      }
      
      public function playDeactivationSound(param1:Vector3) : void
      {
         var sound3d:Sound3D = null;
         this.stopActivationSoundEffect();
         if(this.deactivationSoundEffect == null)
         {
            sound3d = Sound3D.create(this.deactivationSound,1500,5000,10,1.3);
            this.deactivationSoundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,param1,sound3d,0,0,999999);
            this.battleService.addSound3DEffect(this.deactivationSoundEffect);
         }
      }
      
      public function stopSound() : void
      {
         this.stopActivationSoundEffect();
         this.stopDeactivationSoundEffect();
      }
      
      private function stopDeactivationSoundEffect() : void
      {
         if(this.deactivationSoundEffect != null)
         {
            this.deactivationSoundEffect.kill();
            this.deactivationSoundEffect = null;
         }
      }
      
      private function stopActivationSoundEffect() : void
      {
         if(this.activationSoundEffect != null)
         {
            this.activationSoundEffect.kill();
            this.activationSoundEffect = null;
         }
      }
   }
}
