// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.test.RenderSystem

package scpacker.test
{
    import alternativa.engine3d.core.Camera3D;
    import flash.display.Stage;
    import flash.events.Event;

    public class RenderSystem 
    {

        private var camera:Camera3D;
        private var _stage:Stage;

        public function RenderSystem(camera:Camera3D, _stage:Stage)
        {
            this.camera = camera;
            this._stage = _stage;
            this._stage.addEventListener(Event.ENTER_FRAME, this.enterFrame);
        }

        private function enterFrame(e:Event):void
        {
            this.camera.render();
        }


    }
}//package scpacker.test

