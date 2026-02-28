package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class NewYearGameMode implements IGameMode
   {
       
      
      private var camera:GameCamera;
      
      public function NewYearGameMode()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         var camera:GameCamera = null;
         camera = viewport.camera;
         this.camera = camera;
         camera.directionalLightStrength = 1;
         camera.ambientColor = 794160;
         camera.deferredLighting = true;
         var light:DirectionalLight = new DirectionalLight(1513239);
         light.useShadowMap = true;
         var x:Number = -1.1;
         var z:Number = -3.8;
         var matrix:Matrix3 = new Matrix3();
         matrix.setRotationMatrix(x,0,z);
         var toPos:Vector3 = new Vector3(0,1,0);
         toPos.vTransformBy3(matrix);
         light.lookAt(toPos.x,toPos.y,toPos.z);
         light.intensity = 1;
         camera.directionalLight = light;
         camera.fogColor = 6974058;
         camera.fogNear = 100;
         camera.fogFar = 5000;
         camera.fogStrength = 1;
         camera.fogAlpha = 0.9;
         camera.shadowMap = new ShadowMap(2048,5000,10000,0,0);
         camera.shadowMapStrength = 1;
         camera.shadowMap.bias = 0.5;
         camera.shadowMap.biasMultiplier = 30;
         camera.shadowMap.additionalSpace = 10000;
         camera.shadowMap.alphaThreshold = 0.1;
         camera.useShadowMap = true;
      }
      
      public function applyChangesBeforeSettings(settings:IBattleSettings) : void
      {
         if(settings.fog && this.camera.fogStrength != 1)
         {
            this.camera.fogColor = 16777215;
            this.camera.fogNear = 5000;
            this.camera.fogFar = 10000;
            this.camera.fogStrength = 1;
            this.camera.fogAlpha = 0.35;
         }
         else if(!settings.fog)
         {
            this.camera.fogStrength = 0;
         }
         if(settings.shadows && !this.camera.useShadowMap)
         {
            this.camera.useShadowMap = true;
            if(this.camera.directionalLight != null)
            {
               this.camera.directionalLight.useShadowMap = true;
            }
            this.camera.shadowMapStrength = 1;
         }
         else if(!settings.shadows)
         {
            this.camera.useShadowMap = false;
            if(this.camera.directionalLight != null)
            {
               this.camera.directionalLight.useShadowMap = false;
            }
            this.camera.shadowMapStrength = 0;
         }
         if(settings.defferedLighting && this.camera.directionalLightStrength != 1)
         {
            this.camera.directionalLight.intensity = 1;
            this.camera.directionalLightStrength = 1;
            this.camera.deferredLighting = true;
            this.camera.deferredLightingStrength = 1;
         }
         else if(!settings.defferedLighting)
         {
            this.camera.directionalLight.intensity = 0;
            this.camera.directionalLightStrength = 0;
            this.camera.deferredLighting = false;
            this.camera.deferredLightingStrength = 0;
         }
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         var btm:BitmapData = new BitmapData(1,1,false,1382169 + 7559484);
         skybox.colorTransform(skybox.rect,new Bitmap(btm).transform.colorTransform);
         return skybox;
      }
   }
}
