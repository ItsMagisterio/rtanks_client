package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.BitmapData;
   
   public class SpaceGameMode implements IGameMode
   {
       
      
      public function SpaceGameMode()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
      }
      
      public function applyChangesBeforeSettings(settings:IBattleSettings) : void
      {
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         return skybox;
      }
   }
}
