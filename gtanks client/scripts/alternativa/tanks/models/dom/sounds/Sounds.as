package alternativa.tanks.models.dom.sounds
{
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.sound.ISoundManager;
   import flash.media.Sound;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   
   public class Sounds
   {
       
      
      private var soundManager:ISoundManager;
      
      private var sounds:DominationSounds;
      
      public function Sounds(param1:ISoundManager, param2:DominationSounds)
      {
         super();
         this.soundManager = param1;
         this.sounds = param2;
      }
      
      public function playCaptureStartSound(param1:BattleTeamType) : void
      {
         var _loc2_:Sound = null;
         if(param1 == TankData.localTankData.teamType || TankData.localTankData.teamType == null)
         {
            _loc2_ = this.sounds.startCapturingSound;
         }
         else
         {
            _loc2_ = this.sounds.enemyCaptureSound;
         }
         this.soundManager.playSound(_loc2_);
      }
      
      public function playCaptureStopSound(param1:BattleTeamType) : void
      {
         var _loc2_:Sound = null;
         if(param1 == TankData.localTankData.teamType || TankData.localTankData.teamType == null)
         {
            _loc2_ = this.sounds.stopCapturingSound;
         }
         else
         {
            _loc2_ = this.sounds.pauseCaptureSound;
         }
         this.soundManager.playSound(_loc2_);
      }
      
      public function playCapturingSound(param1:BattleTeamType) : void
      {
         var _loc2_:Sound = null;
         if(param1 == TankData.localTankData.teamType || TankData.localTankData.teamType == null)
         {
            _loc2_ = this.sounds.pointCapturedSound;
         }
         else
         {
            _loc2_ = this.sounds.enemyPointCapturedSound;
         }
         this.soundManager.playSound(_loc2_);
      }
      
      public function playNeutralizedSound(param1:BattleTeamType) : void
      {
         var _loc2_:Sound = null;
         if(param1 == TankData.localTankData.teamType || TankData.localTankData.teamType == null)
         {
            _loc2_ = this.sounds.lostPointSound;
         }
         else
         {
            _loc2_ = this.sounds.enemyLostPointSound;
         }
         this.soundManager.playSound(_loc2_);
      }
   }
}
