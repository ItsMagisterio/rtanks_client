// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.lorentz.SVG.data.path.SVGLineToHorizontalCommand

package com.lorentz.SVG.data.path
{
    public class SVGLineToHorizontalCommand extends SVGPathCommand 
    {

        public var x:Number = 0;
        public var absolute:Boolean = false;

        public function SVGLineToHorizontalCommand(absolute:Boolean, x:Number=0)
        {
            this.absolute = absolute;
            this.x = x;
        }

        override public function get type():String
        {
            return ((this.absolute) ? "H" : "h");
        }

        override public function clone():Object
        {
            var copy:SVGLineToHorizontalCommand = new SVGLineToHorizontalCommand(this.absolute);
            copy.x = this.x;
            return (copy);
        }


    }
}//package com.lorentz.SVG.data.path

