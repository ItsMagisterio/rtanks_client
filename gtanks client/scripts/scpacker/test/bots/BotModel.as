package scpacker.test.bots
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.register.ClientClass;
   import alternativa.tanks.models.battlefield.logic.updaters.RemoteHullTransformUpdater;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankParts;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankSpecification;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankState;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import com.alternativaplatform.projects.tanks.client.models.tank.ClientTank;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import flash.utils.Dictionary;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import scpacker.resource.ResourceUtil;
   import scpacker.test.bots.debug.waypoints.WaypointVisualization;
   
   public class BotModel
   {
       
      
      private var botControllers:Dictionary;
      
      public function BotModel()
      {
         super();
         this.botControllers = new Dictionary();
      }
      
      public function initDebug(waypoints:Array) : void
      {
         WaypointVisualization.INSTANCE.init(waypoints);
      }
      
      public function addBot(js:String) : void
      {
         var state:TankState = null;
         var clientObject:ClientObject = null;
         var targetPos:Vector3 = null;
         var posParser:Object = null;
         var json:Object = JSON.parse(js);
         var tankParts:TankParts = new TankParts();
         tankParts.coloringObjectId = json.colormap_id;
         tankParts.hullObjectId = json.hull_id;
         tankParts.turretObjectId = json.turret_id;
         var spec:TankSpecification = new TankSpecification();
         spec.speed = json.speed;
         spec.turnSpeed = json.turn_speed;
         spec.turretRotationSpeed = json.turret_turn_speed;
         var position:Vector3d = new Vector3d(0,0,0);
         var temp:Array = String(json.position).split("@");
         position.x = int(temp[0]);
         position.y = int(temp[1]);
         position.z = int(temp[2]);
         if(!json.state_null)
         {
            state = new TankState();
            state.health = json.health;
            state.orientation = new Vector3d(0,0,temp[3]);
            state.position = position;
            state.turretAngle = 0;
         }
         var clientTank:ClientTank = new ClientTank();
         clientTank.health = json.health;
         clientTank.incarnationId = json.icration;
         clientTank.self = false;
         var stateSpawn:String = json.state;
         clientTank.spawnState = stateSpawn == "newcome" ? TankSpawnState.NEWCOME : (stateSpawn == "active" ? TankSpawnState.ACTIVE : (stateSpawn == "suicide" ? TankSpawnState.SUICIDE : TankSpawnState.ACTIVE));
         clientTank.tankSpecification = spec;
         clientTank.tankState = state;
         clientTank.teamType = BattleTeamType.getType(json.team_type);
         var clientClass:ClientClass = new ClientClass(json.tank_id,null,json.tank_id);
         clientObject = new ClientObject(json.tank_id,clientClass,json.tank_id,null);
         BattleController.activeTanks[json.nickname] = clientObject;
         var tankModelService:TankModel = Main.osgi.getService(ITank) as TankModel;
         tankModelService.initObject(clientObject,json.battleId,json.mass,json.power,null,tankParts,null,json.impact_force,json.kickback,json.turret_rotation_accel,json.turret_turn_speed,json.nickname,json.rank,tankParts.turretObjectId);
         tankModelService.initTank(clientObject,clientTank,tankParts,false);
         var tankData:TankData = tankModelService.getTankData(clientObject);
         targetPos = null;
         if(json.current_waypoint != null)
         {
            posParser = JSON.parse(json.current_waypoint);
            targetPos = new Vector3(posParser.x,posParser.y,posParser.z);
         }
         if(tankData == null || tankData.tank == null)
         {
            ResourceUtil.addEventListener(function():void
            {
               configureBot(clientObject,targetPos);
            });
         }
         else
         {
            this.configureBot(clientObject,targetPos);
         }
      }
      
      public function removeBot(nickname:String) : void
      {
         var tankModelService:TankModel = Main.osgi.getService(ITank) as TankModel;
         var tankData:TankData = tankModelService.getTankData(BattleController.activeTanks[nickname]);
         if(tankData != null)
         {
            this.botControllers[tankData.userName] = null;
         }
      }
      
      private function configureBot(clientObject:ClientObject, targetPos:Vector3) : void
      {
         var tankModelService:TankModel = Main.osgi.getService(ITank) as TankModel;
         var tankData:TankData = tankModelService.getTankData(clientObject);
         tankData.tank.setHullTransformUpdater(new RemoteHullTransformUpdater(tankData.tank));
      }
      
      public function destroy() : void
      {
         this.botControllers = new Dictionary();
      }
      
      public function playerIsBot(nickname:String) : Boolean
      {
         return this.botControllers[nickname] != null;
      }
      
      public function isBot(nickname:String) : Boolean
      {
         return this.botControllers[nickname] != null;
      }
   }
}
