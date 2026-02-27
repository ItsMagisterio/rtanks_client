package package_62
{
   import package_67.Vector3d;
   import platform.client.fp10.core.type.name_70;
   
   public interface ILaserPointerModelBase
   {
       
      
      function aimRemoteAtTank(param1:name_70, param2:Vector3d) : void;
      
      function hideRemote() : void;
      
      function updateRemoteDirection(param1:Number) : void;
   }
}
