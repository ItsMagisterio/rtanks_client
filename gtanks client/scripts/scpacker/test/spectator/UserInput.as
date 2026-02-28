// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.test.spectator.UserInput

package scpacker.test.spectator
{
    public interface UserInput 
    {

        function getForwardDirection():int;
        function getSideDirection():int;
        function getVerticalDirection():int;
        function isAcceleratied():Boolean;
        function getYawDirection():int;
        function getPitchDirection():int;
        function isRotating():Boolean;
        function reset():void;

    }
}//package scpacker.test.spectator

