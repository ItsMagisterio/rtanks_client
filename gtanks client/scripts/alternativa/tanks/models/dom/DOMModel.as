package alternativa.tanks.models.dom
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.IBattlefieldPlugin;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.dom.hud.KeyPointMarker;
   import alternativa.tanks.models.dom.hud.KeyPointMarkers;
   import alternativa.tanks.models.dom.hud.gui.panel.KeyPointsHUDPanel;
   import alternativa.tanks.models.dom.hud.point.KeyPointView;
   import alternativa.tanks.models.dom.server.DOMPointData;
   import alternativa.tanks.models.dom.sfx.AllBeamProperties;
   import alternativa.tanks.models.dom.sfx.BeamEffects;
   import alternativa.tanks.models.dom.sfx.DominationBeamEffect;
   import alternativa.tanks.models.dom.sounds.DominationSounds;
   import alternativa.tanks.models.dom.sounds.KeyPointSoundEffects;
   import alternativa.tanks.models.dom.sounds.Sounds;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class DOMModel implements IDOMModel, IObjectLoadListener, IBattlefieldPlugin
   {
      
      private static var objectPoolService:IObjectPoolService;
      
      public static var userTankData:TankData;
       
      
      private var points:Vector.<Point>;
      
      private var pointsById:Dictionary;
      
      private var tanksInBattle:Dictionary;
      
      private var tankModel:ITank;
      
      private var battlefieldModel:BattlefieldModel;
      
      private var beamEffects:BeamEffects;
      
      private var allBeamProperties:AllBeamProperties;
      
      private var pointHuds:KeyPointMarkers;
      
      private var bfData:BattlefieldData;
      
      private var guiModel:IBattlefieldGUI;
      
      private var locale:ILocaleService;
      
      private var sounds:Sounds;
      
      public function DOMModel()
      {
         this.pointsById = new Dictionary();
         this.tanksInBattle = new Dictionary();
         this.allBeamProperties = new AllBeamProperties(null);
         super();
         this.points = new Vector.<Point>();
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.guiModel = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
         this.locale = ILocaleService(Main.osgi.getService(ILocaleService));
         this.battlefieldModel.addPlugin(this);
         this.bfData = this.battlefieldModel.getBattlefieldData();
         this.tankModel = ITank(modelService.getModelsByInterface(ITank)[0]);
         this.beamEffects = new BeamEffects(this.battlefieldModel);
         this.pointHuds = new KeyPointMarkers(this.battlefieldModel.bfData.viewport.camera,this.battlefieldModel);
      }
      
      public function initObject(points:Vector.<DOMPointData>) : void
      {
         var data:DOMPointData = null;
         var pointView:KeyPointView = null;
         var pointSounds:KeyPointSoundEffects = null;
         var point:Point = null;
         var userId:String = null;
         for each(data in points)
         {
            pointView = new KeyPointView(data.id);
            pointSounds = new KeyPointSoundEffects(DominationSounds.INSTANCE.captureSound,DominationSounds.INSTANCE.returnSound);
            point = new Point(data.id,data.pos,data.radius,this,pointView,pointSounds);
            this.points.push(point);
            this.pointHuds.addMarker(new KeyPointMarker(point));
            this.pointsById[point.id] = point;
            this.serverSetPointScore(point.id,data.score,0);
            for each(userId in data.occupatedUsers)
            {
               this.serverTankCapturingPoint(point.id,BattleController.activeTanks[userId]);
            }
         }
         this.sounds = new Sounds(this.battlefieldModel.soundManager,DominationSounds.INSTANCE);
         this.guiModel.createPointsHUD(new KeyPointsHUDPanel(this.points));
      }
      
      public function tankCapturingPoint(point:Point, tankData:TankData) : void
      {
         var effect:DominationBeamEffect = null;
         effect = DominationBeamEffect(objectPoolService.objectPool.getObject(DominationBeamEffect));
         var pointPos:Vector3 = new Vector3();
         point.readPos(pointPos);
         pointPos.z -= 40;
         effect.init(tankData.tank.skin.turretMesh,pointPos,this.allBeamProperties.getBeamProperties(tankData.teamType),new Dictionary());
         this.beamEffects.addEffect(tankData.user,effect);
         var teamType:* = TankData.localTankData.teamType;
         if(teamType == BattleTeamType.BLUE)
         {
            ++point.countBluePlayerOnPoint;
         }
         else
         {
            ++point.countRedPlayerOnPoint;
         }
         if(point.countBluePlayerOnPoint != point.countRedPlayerOnPoint)
         {
            if(teamType == BattleTeamType.BLUE && point.clientProgress < 100 && point.countBluePlayerOnPoint > point.countRedPlayerOnPoint)
            {
               this.sounds.playCaptureStartSound(teamType);
            }
            else if(teamType == BattleTeamType.RED && point.clientProgress > -100 && point.countBluePlayerOnPoint < point.countRedPlayerOnPoint)
            {
               this.sounds.playCaptureStartSound(teamType);
            }
         }
         else
         {
            this.playSoundEffect(DominationSounds.INSTANCE.pauseCaptureSound,point);
         }
         Network(Main.osgi.getService(INetworker)).send("battle;tank_capturing_point;" + point.id + ";" + this.getPositionString(tankData.tank.state.pos));
      }
      
      public function playSoundEffect(effectSound:Sound, point:Point) : void
      {
         var soundEffect:ISound3DEffect = this.createSoundEffect(effectSound,point);
         if(soundEffect != null)
         {
            this.battlefieldModel.addSound3DEffect(soundEffect);
         }
      }
      
      private function createSoundEffect(effectSound:Sound, point:Point) : ISound3DEffect
      {
         var sound:Sound3D = Sound3D.create(effectSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,1.5);
         return Sound3DEffect.create(objectPoolService.objectPool,null,point.pos,sound);
      }
      
      public function tankLeaveCapturingPoint(point:Point, tank:TankData) : void
      {
         this.beamEffects.removeEffect(tank.user);
         var teamType:* = TankData.localTankData.teamType;
         if(teamType == BattleTeamType.BLUE)
         {
            --point.countBluePlayerOnPoint;
         }
         else
         {
            --point.countRedPlayerOnPoint;
         }
         var pointEmpty:Boolean = point.countBluePlayerOnPoint == 0 && point.countRedPlayerOnPoint == 0;
         if(point.countBluePlayerOnPoint != point.countRedPlayerOnPoint || pointEmpty)
         {
            if(teamType == BattleTeamType.BLUE && point.clientProgress < 100 && (point.countBluePlayerOnPoint > point.countRedPlayerOnPoint || pointEmpty))
            {
               this.sounds.playCaptureStopSound(teamType);
            }
            else if(teamType == BattleTeamType.RED && point.clientProgress > -100 && (point.countBluePlayerOnPoint < point.countRedPlayerOnPoint || pointEmpty))
            {
               this.sounds.playCaptureStopSound(teamType);
            }
         }
         else
         {
            this.playSoundEffect(DominationSounds.INSTANCE.pauseCaptureSound,point);
         }
         Network(Main.osgi.getService(INetworker)).send("battle;tank_leave_capturing_point;" + point.id);
      }
      
      public function serverSetPointScore(pointId:String, score:int, progressSpeed:int) : void
      {
         var point:Point = this.pointsById[pointId];
         point.clientProgress = score;
         point.progressSpeed = progressSpeed;
         trace(score,progressSpeed);
      }
      
      [ServerData]
      public function serverPointCapturedBy(team:String, pointId:String) : void
      {
         if(TankData.localTankData.teamType == null)
         {
            this.guiModel.logUserAction(null,team == "blue" ? this.locale.getText(TextConst.DOM_BLUE_TEAM_CAPTURED) + pointId : this.locale.getText(TextConst.DOM_RED_TEAM_CAPTURED) + pointId,null);
            this.battlefieldModel.messages.addMessage(team == "blue" ? uint(4691967) : uint(15741974),(team == "blue" ? this.locale.getText(TextConst.DOM_BLUE_TEAM_CAPTURED) : this.locale.getText(TextConst.DOM_RED_TEAM_CAPTURED)) + pointId);
         }
         else
         {
            this.guiModel.logUserAction(null,team == TankData.localTankData.teamType.toString() ? this.locale.getText(TextConst.DOM_WE_TEAM_CAPTURED) + pointId : this.locale.getText(TextConst.DOM_ENEMIES_TEAM_CAPTURED) + pointId,null);
            this.battlefieldModel.messages.addMessage(team == TankData.localTankData.teamType.toString() ? uint(65280) : uint(16776960),(team == TankData.localTankData.teamType.toString() ? this.locale.getText(TextConst.DOM_WE_TEAM_CAPTURED) : this.locale.getText(TextConst.DOM_ENEMIES_TEAM_CAPTURED)) + pointId);
         }
         this.sounds.playCapturingSound(BattleTeamType.getType(team));
         var point:Point = this.pointsById[pointId];
         point.onCapturedByTeam(team);
      }
      
      [ServerData]
      public function serverPointLostBy(ownedTeam:String, pointId:String) : void
      {
         if(TankData.localTankData.teamType == null)
         {
            this.guiModel.logUserAction(null,ownedTeam == "blue" ? this.locale.getText(TextConst.DOM_BLUE_TEAM_LOSTED) + pointId : this.locale.getText(TextConst.DOM_RED_TEAM_LOSTED) + pointId,null);
            this.battlefieldModel.messages.addMessage(ownedTeam == "blue" ? uint(4691967) : uint(15741974),(ownedTeam == ownedTeam == "blue" ? this.locale.getText(TextConst.DOM_BLUE_TEAM_LOSTED) : this.locale.getText(TextConst.DOM_RED_TEAM_LOSTED)) + pointId);
         }
         else
         {
            this.guiModel.logUserAction(null,ownedTeam == TankData.localTankData.teamType.toString() ? this.locale.getText(TextConst.DOM_WE_TEAM_LOSTED) + pointId : this.locale.getText(TextConst.DOM_ENEMIES_TEAM_LOSTED) + pointId,null);
            this.battlefieldModel.messages.addMessage(ownedTeam == TankData.localTankData.teamType.toString() ? uint(16776960) : uint(65280),(ownedTeam == TankData.localTankData.teamType.toString() ? this.locale.getText(TextConst.DOM_WE_TEAM_LOSTED) : this.locale.getText(TextConst.DOM_ENEMIES_TEAM_LOSTED)) + pointId);
         }
         this.sounds.playNeutralizedSound(BattleTeamType.getType(ownedTeam));
         var point:Point = this.pointsById[pointId];
         point.onNeutralized();
      }
      
      public function serverTankCapturingPoint(pointId:String, tank:ClientObject) : void
      {
         var effect:DominationBeamEffect = null;
         var point:Point = this.pointsById[pointId];
         var tankData:TankData = this.tankModel.getTankData(tank);
         if(tankData == null)
         {
            return;
         }
         effect = DominationBeamEffect(objectPoolService.objectPool.getObject(DominationBeamEffect));
         var pointPos:Vector3 = new Vector3();
         point.readPos(pointPos);
         pointPos.z -= 40;
         effect.init(tankData.tank.skin.turretMesh,pointPos,this.allBeamProperties.getBeamProperties(tankData.teamType),new Dictionary());
         this.beamEffects.addEffect(tankData.user,effect);
         var teamType:* = tankData.teamType;
         if(teamType == BattleTeamType.BLUE)
         {
            ++point.countBluePlayerOnPoint;
         }
         else
         {
            ++point.countRedPlayerOnPoint;
         }
         if(point.countBluePlayerOnPoint != point.countRedPlayerOnPoint)
         {
            if(teamType == BattleTeamType.BLUE && point.clientProgress < 100 && point.countBluePlayerOnPoint > point.countRedPlayerOnPoint)
            {
               this.sounds.playCaptureStartSound(teamType);
            }
            else if(teamType == BattleTeamType.RED && point.clientProgress > -100 && point.countBluePlayerOnPoint < point.countRedPlayerOnPoint)
            {
               this.sounds.playCaptureStartSound(teamType);
            }
         }
         else
         {
            this.playSoundEffect(DominationSounds.INSTANCE.pauseCaptureSound,point);
         }
      }
      
      public function serverTankLeaveCapturingPoint(tank:ClientObject, pointId:String) : void
      {
         var point:Point = this.pointsById[pointId];
         var tankData:TankData = this.tankModel.getTankData(tank);
         if(tankData == null)
         {
            return;
         }
         this.beamEffects.removeEffect(tank);
         var teamType:* = tankData.teamType;
         if(teamType == BattleTeamType.BLUE)
         {
            --point.countBluePlayerOnPoint;
         }
         else
         {
            --point.countRedPlayerOnPoint;
         }
         var pointEmpty:Boolean = point.countBluePlayerOnPoint == 0 && point.countRedPlayerOnPoint == 0;
         if(point.countBluePlayerOnPoint != point.countRedPlayerOnPoint || pointEmpty)
         {
            if(teamType == BattleTeamType.BLUE && point.clientProgress < 100 && (point.countBluePlayerOnPoint > point.countRedPlayerOnPoint || pointEmpty))
            {
               this.sounds.playCaptureStopSound(teamType);
            }
            else if(teamType == BattleTeamType.RED && point.clientProgress > -100 && (point.countBluePlayerOnPoint < point.countRedPlayerOnPoint || pointEmpty))
            {
               this.sounds.playCaptureStopSound(teamType);
            }
         }
         else
         {
            this.playSoundEffect(DominationSounds.INSTANCE.pauseCaptureSound,point);
         }
      }
      
      private function getPositionString(vector:Vector3) : String
      {
         return vector.x + ";" + vector.y + ";" + vector.z;
      }
      
      public function isPositionInFlagProximity(position:Vector3, distanceSquared:Number) : Boolean
      {
         var point:Point = null;
         var pointPos:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var distanceNormal:Boolean = true;
         for each(point in this.points)
         {
            if(point == null)
            {
               return false;
            }
            pointPos = point.pos;
            dx = pointPos.x - position.x;
            dy = pointPos.y - position.y;
            dz = pointPos.z - position.z;
            distanceNormal = dx * dx + dy * dy + dz * dz < distanceSquared;
            if(!distanceNormal)
            {
               break;
            }
         }
         return distanceNormal;
      }
      
      public function tick(time:int, deltaMsec:int, deltaSec:Number, interpolationCoeff:Number) : void
      {
         var point:Point = null;
         for each(point in this.points)
         {
            point.tick(time,deltaMsec,deltaSec,interpolationCoeff);
         }
         this.pointHuds.render(time,deltaMsec);
         this.guiModel.updatePointsHUD();
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var point:Point = null;
         for each(point in this.points)
         {
            point.drawDebug(this.battlefieldModel.getBattlefieldData().viewport.getMapContainer());
         }
         this.pointHuds.show();
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.battlefieldModel.removePlugin(this);
         DOMModel.userTankData = null;
      }
      
      public function get battlefieldPluginName() : String
      {
         return "DOM";
      }
      
      public function startBattle() : void
      {
      }
      
      public function restartBattle() : void
      {
         this.beamEffects.killAllEffects();
      }
      
      public function finishBattle() : void
      {
      }
      
      public function addUser(clientObject:ClientObject) : void
      {
      }
      
      public function removeUser(clientObject:ClientObject) : void
      {
      }
      
      public function addUserToField(clientObject:ClientObject) : void
      {
         var tankData:TankData = this.tankModel.getTankData(clientObject);
         if(this.bfData.localUser == clientObject)
         {
            userTankData = tankData;
         }
         this.tanksInBattle[tankData] = tankData.tank;
      }
      
      public function removeUserFromField(clientObject:ClientObject) : void
      {
         var tankData:TankData = this.tankModel.getTankData(clientObject);
         delete this.tanksInBattle[tankData];
      }
   }
}
