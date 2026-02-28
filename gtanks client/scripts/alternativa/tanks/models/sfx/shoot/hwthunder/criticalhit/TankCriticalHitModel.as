package alternativa.tanks.models.sfx.shoot.hwthunder.criticalhit
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class TankCriticalHitModel implements ITankCriticalHitModel
   {
      
	[Embed(source="criticalHit.png")]
      private static var _criticalHit:Class;
       
      
      private const BASE_DIAGONAL:Number = 600;
      
      private var objectPoolService:IObjectPoolService;
      
      private var animationData:TextureAnimation;
      
      public function TankCriticalHitModel()
      {
         super();
      }
      
      public function createCriticalHitEffects(pos:Vector3, tank:Tank) : void
      {
         if(this.objectPoolService == null)
         {
            this.objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         }
         if(this.animationData == null)
         {
            this.animationData = GraphicsUtils.getTextureAnimation(null,new _criticalHit().bitmapData,200,200,8);
            this.animationData.frames;
            this.animationData.fps = 25;
         }
         var hullMesh:Mesh = tank.skin.hullMesh;
         var dx:Number = hullMesh.boundMaxX - hullMesh.boundMinX;
         var dy:Number = hullMesh.boundMaxY - hullMesh.boundMinY;
         var dz:Number = hullMesh.boundMaxZ - hullMesh.boundMinZ;
         var diagonal:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         var effectScale:Number = diagonal / this.BASE_DIAGONAL;
         var effectSize:* = 400 * effectScale;
         var posProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(this.objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         posProvider.init(pos,100);
         var effect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(this.objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
         effect.initLooped(effectSize,effectSize,this.animationData,0,posProvider,0.5,0.5,null,70,"normal",2);
         (Main.osgi.getService(IBattleField) as BattlefieldModel).addGraphicEffect(effect);
      }
   }
}
