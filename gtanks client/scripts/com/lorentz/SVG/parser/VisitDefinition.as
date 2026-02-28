// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.lorentz.SVG.parser.VisitDefinition

package com.lorentz.SVG.parser
{
    public class VisitDefinition 
    {

        public var node:XML;
        public var onComplete:Function;

        public function VisitDefinition(node:XML, onComplete:Function=null)
        {
            this.node = node;
            this.onComplete = onComplete;
        }

    }
}//package com.lorentz.SVG.parser

