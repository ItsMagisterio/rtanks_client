package alternativa.tanks.models.dom
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.dom.hud.point.KeyPointView;
   import alternativa.tanks.models.dom.sounds.KeyPointSoundEffects;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import com.reygazu.anticheat.variables.SecureBoolean;
   
   public class Point
   {
      
      private static const CON_SMOOTHING_FACTOR:ConsoleVarFloat = new ConsoleVarFloat("dom_smoothing_factor",0.95,0,1);
      
      private static const MAX_PROGRESS:Number = 100;
       
      
      public var pos:Vector3;
      
      private var radius:Number;
      
      private var model:DOMModel;
      
      public var countRedPlayerOnPoint:int;
      
      public var countBluePlayerOnPoint:int;
      
      private var capture:SecureBoolean;
      
      public var id:String;
      
      public var serverProgress:Number = 0;
      
      public var _clientProgress:Number = 0;
      
      public var progressSpeed:Number = 1;
      
      private var updateForced:Boolean;
      
      private var view:KeyPointView;
      
      private var light:OmniLight;
      
      private var debug:int = 0;
      
      private var soundEffects:KeyPointSoundEffects;
      
      public function Point(id:String, pos:Vector3, radius:Number, model:DOMModel, view:KeyPointView, soundEffects:KeyPointSoundEffects)
      {
         this.capture = new SecureBoolean("capture");
         super();
         this.pos = pos;
         this.radius = radius;
         this.model = model;
         this.id = id;
         this.view = view;
         this.soundEffects = soundEffects;
         view.addToScene((Main.osgi.getService(IBattleField) as BattlefieldModel).bfData.viewport._mapContainer,pos);
         this.light = new OmniLight(14013909,500,1000);
         this.light.x = pos.x;
         this.light.y = pos.y;
         this.light.z = pos.z + 150;
         (Main.osgi.getService(IBattleField) as BattlefieldModel).bfData.viewport._mapContainer.addChild(this.light);
      }
      
      public function set clientProgress(value:Number) : void
      {
         this._clientProgress = value;
      }
      
      public function get clientProgress() : Number
      {
         return this._clientProgress;
      }
      
      public function drawDebug(scene:Scene3DContainer) : void
      {
      }
      
      public function tick(time:int, deltaMsec:int, deltaSec:Number, interpolationCoeff:Number) : void
      {
         var tankPos:Vector3 = null;
         var dot:Number = NaN;
         this.view.update(this.clientProgress,(Main.osgi.getService(IBattleField) as BattlefieldModel).bfData.viewport.camera);
         this.updateSound();
         if(DOMModel.userTankData == null)
         {
            return;
         }
         if(DOMModel.userTankData.spawnState == TankSpawnState.ACTIVE)
         {
            tankPos = DOMModel.userTankData.tank.state.pos;
            dot = this.pos.distanceTo(tankPos);
            if(!this.capture.value)
            {
               if(dot <= this.radius)
               {
                  this.capture.value = true;
                  this.model.tankCapturingPoint(this,DOMModel.userTankData);
               }
            }
            else if(dot > this.radius)
            {
               this.capture.value = false;
               this.model.tankLeaveCapturingPoint(this,DOMModel.userTankData);
            }
         }
         else if(this.capture.value)
         {
            this.capture.value = false;
            this.model.tankLeaveCapturingPoint(this,DOMModel.userTankData);
         }
         this.updateSound();
      }
      
      private function updateSound() : void
      {
         var score:Number = this.clientProgress * this.progressSpeed;
         if(this.clientProgress == 101 || this.clientProgress == -101)
         {
            this.progressSpeed = 0;
         }
         if(score > 0 || this.clientProgress == 0 && this.progressSpeed != 0)
         {
            this.soundEffects.playActivationSound(this.pos);
         }
         else if(score < 0)
         {
            this.soundEffects.playDeactivationSound(this.pos);
         }
         else
         {
            this.soundEffects.stopSound();
         }
      }
      
      public function onCapturedByTeam(team:String) : void
      {
         if(team == "red")
         {
            this.view.changeTexturePedestal(this.view.pedstalTextureRed);
         }
         else
         {
            this.view.changeTexturePedestal(this.view.pedstalTextureBlue);
         }
      }
      
      public function onNeutralized() : void
      {
         this.view.changeTexturePedestal(this.view.pedstalTextureNeutral);
      }
      
      public function readPos(v:Vector3) : void
      {
         v.x = this.pos.x;
         v.y = this.pos.y;
         v.z = this.pos.z + KeyPointView.CIRCLE_ASCENSION;
      }
   }
}
