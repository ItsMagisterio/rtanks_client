// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.resource.SoundResourceLoader

package scpacker.resource
{
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.media.Sound;
    import scpacker.resource.cache.SoundCacheLoader;
    import flash.events.IOErrorEvent;
    import alternativa.init.Main;
    import flash.events.SecurityErrorEvent;
    import flash.media.SoundLoaderContext;

    public class SoundResourceLoader 
    {

        private var path:String;
        public var list:SoundResourcesList;
        public var status:int = 0;

        public function SoundResourceLoader(path:String)
        {
            this.path = path;
            this.list = new SoundResourcesList();
            this.load();
        }

        private function load():void
        {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, this.parse);
            loader.load(new URLRequest(this.path));
        }

        private function parse(e:Event):void
        {
            var config:Object;
            var temp:Object;
            var obj:Object;
            try
            {
                config = JSON.parse(e.target.data);
                if (config.id == "SOUNDS")
                {
                    for each (obj in config.items)
                    {
                        temp = obj;
                        this.loadSound(obj);
                    };
                    this.status = 1;
                    ResourceUtil.onCompleteLoading();
                }
                else
                {
                    throw (new Error("file dont sound's resource"));
                };
            }
            catch(e:Error)
            {
                throw (e);
            };
        }

        private function loadSound(configObject:Object):void
        {
            var soundLoader:Sound;
            var prefix:String = ((Game.local) ? "" : "resources/");
            soundLoader = new SoundCacheLoader();
            soundLoader.addEventListener(Event.COMPLETE, function (e:Event):void
            {
                list.add(new SoundResource(soundLoader, configObject.name));
            });
            soundLoader.addEventListener(IOErrorEvent.IO_ERROR, function (e:Event):void
            {
                Main.debug.showAlert(("Can't load sound resource: " + configObject.src));
            });
            soundLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:Event):void
            {
            });
            configObject.src = (configObject.src as String).split("?")[0];
            soundLoader.load(new URLRequest((prefix + configObject.src)), new SoundLoaderContext());
        }


    }
}//package scpacker.resource

