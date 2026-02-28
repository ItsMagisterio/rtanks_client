// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.test.spectator.MovementMethods

package scpacker.test.spectator
{
    import __AS3__.vec.Vector;

    public class MovementMethods 
    {

        private var methods:Vector.<MovementMethod>;
        private var currentMethodIndex:int;

        public function MovementMethods(param1:Vector.<MovementMethod>)
        {
            this.methods = param1;
        }

        public function getMethod():MovementMethod
        {
            return (this.methods[this.currentMethodIndex]);
        }

        public function selectNextMethod():void
        {
            this.currentMethodIndex = ((this.currentMethodIndex + 1) % this.methods.length);
        }


    }
}//package scpacker.test.spectator

