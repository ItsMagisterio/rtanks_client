// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.resource.tanks.TankResourceLoader

package scpacker.resource.tanks
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import scpacker.resource.cache.CacheURLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.Object3D;
    import flash.utils.ByteArray;
    import alternativa.engine3d.loaders.Parser3DS;
    import specter.utils.Logger;
    import alternativa.engine3d.objects.Mesh;
    import scpacker.resource.failed.FailedResource;
    import scpacker.resource.ResourceUtil;
    import flash.events.IOErrorEvent;
    import alternativa.init.Main;
    import __AS3__.vec.*;

    public class TankResourceLoader 
    {

        private var path:String;
        public var list:TankResourceList;
        private var queue:Vector.<TankResource>;
        private var length:int = 0;
        public var status:int = 0;
        private var lengthFailed:int = 0;
        private var failedResources:Dictionary = new Dictionary();

        public function TankResourceLoader(path:String)
        {
            this.path = path;
            this.list = new TankResourceList();
            this.queue = new Vector.<TankResource>();
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, this.parse);
            loader.load(new URLRequest(path));
        }

        private function parse(e:Event):void
        {
            var obj:Object;
            var config:Object = JSON.parse(e.target.data);
            if (config.id == "MODELS")
            {
                for each (obj in config.items)
                {
                    this.queue.push(new TankResource(null, obj.name, obj.src));
                    this.length++;
                };
                this.loadQueue();
            };
        }

        private function loadQueue():void
        {
            var file:TankResource;
            for each (file in this.queue)
            {
                this.loadModel(file);
            };
        }

        private function loadModel(str:TankResource):void
        {
            var prefix:String;
            var loader:CacheURLLoader;
            try
            {
                prefix = ((Game.local) ? "" : "resources/");
                loader = new CacheURLLoader();
                loader.dataFormat = URLLoaderDataFormat.BINARY;
                loader.addEventListener(Event.COMPLETE, function (e:Event):void
                {
                    var flagMount:Vector3D;
                    var turretMount:Vector3D;
                    var obj:Object3D;
                    var bytes:ByteArray = ByteArray(loader.data);
                    var parser:Parser3DS = new Parser3DS();
                    var muzzles:Vector.<Vector3D> = new Vector.<Vector3D>();
                    parser.parse(bytes);
                    for each (obj in parser.objects)
                    {
                        if (obj.name.split("0")[0] == "muzzle")
                        {
                            muzzles.push(new Vector3D(obj.x, obj.y, obj.z));
                        };
                        if (obj.name.indexOf("fmnt") >= 0)
                        {
                            flagMount = new Vector3D(obj.x, obj.y, obj.z);
                        };
                        if (obj.name == "mount")
                        {
                            turretMount = new Vector3D(obj.x, obj.y, obj.z);
                        };
                    };
                    if (parser.objects.length < 1)
                    {
                        Logger.log((("Invalid mesh width 0 objects: " + str.next) as String));
                        return;
                    };
                    var tnk:TankResource = new TankResource(Mesh(parser.objects[0]), str.id, null, muzzles, flagMount, turretMount);
                    tnk.objects = parser.objects;
                    list.add(tnk);
                    var url:String = (str.next as String);
                    if (url.indexOf("?") >= 0)
                    {
                        url = url.split("?")[0];
                    };
                    var failedImage:FailedResource = failedResources[url];
                    if (failedImage != null)
                    {
                        lengthFailed--;
                    };
                    if (((length == 1) && (lengthFailed <= 0)))
                    {
                        status = 1;
                        ResourceUtil.onCompleteLoading();
                        failedResources = new Dictionary();
                    };
                    length--;
                    muzzles = null;
                });
                loader.load(new URLRequest((prefix + (str.next as String))));
                loader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void
                {
                    Main.debug.showAlert((("Coun't load resouce: " + prefix) + (str.next as String)));
                    var url:String = (str.next as String);
                    if (url.indexOf("?") >= 0)
                    {
                        url = url.split("?")[0];
                    };
                    var failedImage:FailedResource = failedResources[url];
                    if (failedImage == null)
                    {
                        failedImage = new FailedResource();
                        failedResources[url] = failedImage;
                        lengthFailed++;
                    };
                    failedImage.failedCount++;
                    url = (str.next as String);
                    if (url.indexOf("?") >= 0)
                    {
                        url = ((url.split("?")[0] + "?rand=") + Math.random());
                    }
                    else
                    {
                        url = (url + ("?rand=" + Math.random()));
                    };
                    str.next = url;
                    if (failedImage.failedCount >= 3)
                    {
                        Main.debug.showAlert(((("Coun't load resouce: " + prefix) + str.next) + " before 3 attempt."));
                        return;
                    };
                    loadModel(str);
                });
            }
            catch(e:Error)
            {
                throw (new Error((("Can't load resource. (src: " + (str.next as String)) + ")")));
            };
        }


    }
}//package scpacker.resource.tanks

