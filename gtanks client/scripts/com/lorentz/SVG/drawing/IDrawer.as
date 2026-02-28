// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.lorentz.SVG.drawing.IDrawer

package com.lorentz.SVG.drawing
{
    public interface IDrawer 
    {

        function get penX():Number;
        function get penY():Number;
        function moveTo(_arg_1:Number, _arg_2:Number):void;
        function lineTo(_arg_1:Number, _arg_2:Number):void;
        function curveTo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void;
        function cubicCurveTo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):void;
        function arcTo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Number, _arg_7:Number):void;

    }
}//package com.lorentz.SVG.drawing

