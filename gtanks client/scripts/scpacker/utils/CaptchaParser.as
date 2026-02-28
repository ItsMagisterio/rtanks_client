// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.utils.CaptchaParser

package scpacker.utils
{
    import flash.display.Loader;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.display.Bitmap;
    import flash.events.EventDispatcher;

    public class CaptchaParser 
    {


        public static function parse(packet:String, onBitmapParsedHandler:Function):void
        {
            var byte:String;
            var loader:Loader;
            var byteArray:ByteArray = new ByteArray();
            var i:int;
            var bytes:Array = packet.split(",");
            for each (byte in bytes)
            {
                byteArray.writeByte(parseInt(byte));
                i = (i + 1);
            };
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (param1:Event):void
            {
                onBitmapParsedHandler.apply(null, [(loader.content as Bitmap)]);
                (param1.target as EventDispatcher).removeEventListener(param1.type, arguments.callee);
            });
            loader.loadBytes(byteArray);
        }


    }
}//package scpacker.utils

