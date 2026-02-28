package scpacker.test.bots.debug.waypoints
{
   import alternativa.init.Main;
   import alternativa.tanks.models.dom.sfx.AllBeamProperties;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   
   public class WaypointVisualization
   {
      
      public static var INSTANCE:WaypointVisualization = new WaypointVisualization();
      
      private static var objectPoolService:IObjectPoolService;
       
      
      private var boxes:Array;
      
      private var effects:Array;
      
      private var allBeamProperties:AllBeamProperties;
      
      private var enabled:Boolean = false;
      
      public function WaypointVisualization()
      {
         this.boxes = new Array();
         this.effects = new Array();
         this.allBeamProperties = new AllBeamProperties(null);
         super();
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
      }
      
      public function init(points:Array) : void
      {
      }
      
      public function toogle1() : void
      {
      }
   }
}
