package alternativa.tanks.models.dom.sounds
{
   import flash.media.Sound;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class DominationSounds
   {
      
      public static var INSTANCE:DominationSounds = new DominationSounds();
       
      
      public var startCapturingSound:Sound;
      
      public var stopCapturingSound:Sound;
      
      public var pointCapturedSound:Sound;
      
      public var enemyPointCapturedSound:Sound;
      
      public var enemyLostPointSound:Sound;
      
      public var lostPointSound:Sound;
      
      public var captureSound:Sound;
      
      public var enemyCaptureSound:Sound;
      
      public var returnSound:Sound;
      
      public var pauseCaptureSound:Sound;
      
      public function DominationSounds()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         if(this.startCapturingSound != null)
         {
            return;
         }
         this.startCapturingSound = ResourceUtil.getResource(ResourceType.SOUND,"startCapturingSound").sound as Sound;
         this.stopCapturingSound = ResourceUtil.getResource(ResourceType.SOUND,"stopCapturingSound").sound as Sound;
         this.pointCapturedSound = ResourceUtil.getResource(ResourceType.SOUND,"pointCapturedSound").sound as Sound;
         this.enemyPointCapturedSound = ResourceUtil.getResource(ResourceType.SOUND,"enemy_PointCapturedSound").sound as Sound;
         this.enemyLostPointSound = ResourceUtil.getResource(ResourceType.SOUND,"enemy_LostPointSound").sound as Sound;
         this.lostPointSound = ResourceUtil.getResource(ResourceType.SOUND,"lostPointSound").sound as Sound;
         this.captureSound = ResourceUtil.getResource(ResourceType.SOUND,"capture_sound").sound as Sound;
         this.enemyCaptureSound = ResourceUtil.getResource(ResourceType.SOUND,"enemy_capture_sound").sound as Sound;
         this.returnSound = ResourceUtil.getResource(ResourceType.SOUND,"return_sound").sound as Sound;
         this.pauseCaptureSound = ResourceUtil.getResource(ResourceType.SOUND,"pause_capture_sound").sound as Sound;
      }
   }
}
