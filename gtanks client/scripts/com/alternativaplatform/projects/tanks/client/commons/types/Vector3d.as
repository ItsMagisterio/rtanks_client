// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.alternativaplatform.projects.tanks.client.commons.types.Vector3d

package com.alternativaplatform.projects.tanks.client.commons.types
{
    import alternativa.math.Vector3;

    public class Vector3d 
    {

        public var x:Number;
        public var y:Number;
        public var z:Number;

        public function Vector3d(x:Number, y:Number, z:Number)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public function toVector3():Vector3
        {
            return (new Vector3(this.x, this.y, this.z));
        }

        public function toString():String
        {
            return (((((("Vector3d(" + this.x) + " , ") + this.y) + " , ") + this.z) + ")");
        }


    }
}//package com.alternativaplatform.projects.tanks.client.commons.types

