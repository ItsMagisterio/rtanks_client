// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.lorentz.SVG.text.ISVGTextDrawer

package com.lorentz.SVG.text
{
    import com.lorentz.SVG.data.text.SVGTextToDraw;
    import com.lorentz.SVG.data.text.SVGDrawnText;

    public interface ISVGTextDrawer 
    {

        function start():void;
        function drawText(_arg_1:SVGTextToDraw):SVGDrawnText;
        function end():void;

    }
}//package com.lorentz.SVG.text

