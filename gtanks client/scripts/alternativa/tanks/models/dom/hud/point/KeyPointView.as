package alternativa.tanks.models.dom.hud.point
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.resource.StubBitmapData;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.dom.hud.MarkerBitmaps;
   import alternativa.tanks.models.dom.hud.point.images.PointBitmaps;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class KeyPointView
   {
      
      private static const _stand:Class = KeyPointView__stand;
      
      public static const CIRCLE_SIZE:Number = 1000;
      
      public static const CIRCLE_ASCENSION:Number = 350;
      
      private static const MAX_PROGRESS:Number = 100;
      
      private static const CURVE:Number = 1.5;
      
      private static var materialRegistry:IMaterialRegistry;
       
      
      private var pedestal:BSP;
      
      public var pedstalTextureNeutral:TextureMaterial;
      
      public var pedstalTextureRed:TextureMaterial;
      
      public var pedstalTextureBlue:TextureMaterial;
      
      private var redTexture:BitmapData;
      
      private var blueTexture:BitmapData;
      
      private var neutralTexture:BitmapData;
      
      private var plane:ProgressPlane;
      
      public function KeyPointView(char:String)
      {
         super();
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         this.pedstalTextureNeutral = new TextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE,"dom_pestal_neutral").bitmapData as BitmapData,false,true,1,1);
         this.pedstalTextureRed = new TextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE,"dom_pestal_red").bitmapData as BitmapData,false,true,1,1);
         this.pedstalTextureBlue = new TextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE,"dom_pestal_blue").bitmapData as BitmapData,false,true,1,1);
         this.pedestal = createPedestal("flagBlueModel_pedestal",this.pedstalTextureNeutral);
         this.blueTexture = PointBitmaps.BLUE_POINT.clone();
         this.redTexture = PointBitmaps.RED_POINT.clone();
         this.neutralTexture = PointBitmaps.NETURAL_POINT.clone();
         this.createIndicator(char);
         (Main.osgi.getService(IBattleField) as BattlefieldModel).bfData.viewport.addObjectToExclusion(this.plane);
         (Main.osgi.getService(IBattleField) as BattlefieldModel).bfData.viewport.addObjectToExclusion(this.pedestal);
      }
      
      private static function createPedestal(resourceId:String, texture:TextureMaterial) : BSP
      {
         var parser:Parser3DS = new Parser3DS();
         parser.parse(new _stand() as ByteArray);
         var object:Mesh = parser.objects[0] as Mesh;
         var pedestal:BSP = new BSP();
         pedestal.createTree(object);
         if(texture == null)
         {
            texture = new TextureMaterial(new StubBitmapData(16776960));
         }
         pedestal.setMaterialToAllFaces(texture);
         return pedestal;
      }
      
      private static function createRectangle(param1:BitmapData, param2:BitmapData) : Rectangle
      {
         var _loc3_:int = param2.height;
         var _loc4_:Number = (param1.height - _loc3_) / 2;
         return new Rectangle(_loc4_,_loc4_,_loc3_,_loc3_);
      }
      
      private static function createFillingTexture(param1:BitmapData, param2:BitmapData) : BitmapData
      {
         var _loc3_:BitmapData = param1.clone();
         _loc3_.copyChannel(param2,param2.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
         return _loc3_;
      }
      
      private static function getCircleMaterial(param1:BitmapData) : TextureMaterial
      {
         var _loc2_:TextureMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,param1,5);
         _loc2_.resolution = CIRCLE_SIZE / param1.width;
         return _loc2_;
      }
      
      private static function createMatrix(param1:BitmapData, param2:BitmapData, param3:int) : Matrix
      {
         var _loc4_:int = param2.height;
         var _loc5_:Matrix = new Matrix();
         _loc5_.tx = (param1.height - _loc4_) / 2 - _loc4_ * param3;
         _loc5_.ty = (param1.height - _loc4_) / 2;
         return _loc5_;
      }
      
      public function update(param1:Number, param2:Camera3D) : void
      {
         this.plane.setProgress(param1);
         this.plane.updateRotation(param2);
      }
      
      public function changeTexturePedestal(material:TextureMaterial) : void
      {
         this.pedestal.setMaterialToAllFaces(material);
      }
      
      public function addToScene(param1:Object3DContainer, param2:Vector3) : void
      {
         this.pedestal.x = param2.x;
         this.pedestal.y = param2.y;
         this.pedestal.z = param2.z;
         param1.addChild(this.pedestal);
         this.plane.x = param2.x;
         this.plane.y = param2.y;
         this.plane.z = param2.z + CIRCLE_ASCENSION;
         param1.addChild(this.plane);
      }
      
      private function createIndicator(param1:String) : void
      {
         var _loc3_:BitmapData = this.neutralTexture;
         var _loc4_:BitmapData = this.blueTexture;
         var _loc5_:BitmapData = this.redTexture;
         var _loc6_:BitmapData = MarkerBitmaps.letterViewBar;
         var _loc7_:int = param1.charCodeAt(0) - "A".charCodeAt(0);
         var _loc8_:Rectangle = createRectangle(_loc3_,_loc6_);
         var _loc9_:Matrix = createMatrix(_loc3_,_loc6_,_loc7_);
         _loc3_.draw(_loc6_,_loc9_,null,BlendMode.NORMAL,_loc8_,true);
         _loc4_.draw(_loc6_,_loc9_,null,BlendMode.NORMAL,_loc8_,true);
         _loc5_.draw(_loc6_,_loc9_,null,BlendMode.NORMAL,_loc8_,true);
         var _loc10_:BitmapData = createFillingTexture(_loc4_,_loc3_);
         var _loc11_:BitmapData = createFillingTexture(_loc5_,_loc3_);
         var _loc12_:TextureMaterial = getCircleMaterial(_loc3_);
         var _loc13_:TextureMaterial = getCircleMaterial(_loc4_);
         var _loc14_:TextureMaterial = getCircleMaterial(_loc10_);
         var _loc15_:TextureMaterial = getCircleMaterial(_loc5_);
         var _loc16_:TextureMaterial = getCircleMaterial(_loc11_);
         this.plane = new ProgressPlane(CIRCLE_SIZE,CIRCLE_SIZE,_loc12_,_loc14_,_loc13_,_loc16_,_loc15_);
      }
   }
}
