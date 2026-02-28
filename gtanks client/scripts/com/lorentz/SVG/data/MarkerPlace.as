// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.lorentz.SVG.data.MarkerPlace

package com.lorentz.SVG.data
{
    import flash.geom.Point;

    public class MarkerPlace 
    {

        public var position:Point;
        public var angle:Number;
        public var type:String;
        public var strokeWidth:Number;

        public function MarkerPlace(position:Point, angle:Number, _arg_3:String, strokeWidth:Number=0)
        {
            this.position = position;
            this.angle = angle;
            this.type = _arg_3;
            this.strokeWidth = strokeWidth;
        }

        public function averageAngle(otherAngle:Number):void
        {
            this.angle = ((this.angle + otherAngle) * 0.5);
        }


    }
}//package com.lorentz.SVG.data

