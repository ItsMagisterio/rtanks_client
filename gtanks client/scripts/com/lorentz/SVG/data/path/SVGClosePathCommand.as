// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.lorentz.SVG.data.path.SVGClosePathCommand

package com.lorentz.SVG.data.path
{
    public class SVGClosePathCommand extends SVGPathCommand 
    {


        override public function get type():String
        {
            return ("z");
        }

        override public function clone():Object
        {
            return (new SVGClosePathCommand());
        }


    }
}//package com.lorentz.SVG.data.path

