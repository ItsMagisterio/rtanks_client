// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.test.spectator.SpectatorBonusRegionController

package scpacker.test.spectator
{
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;

    public class SpectatorBonusRegionController implements KeyboardHandler 
    {

        [Inject]
        public static var bonusRegionService:Object;


        public function handleKeyDown(param1:KeyboardEvent):void
        {
            if (param1.keyCode == Keyboard.QUOTE)
            {
            };
        }

        public function handleKeyUp(param1:KeyboardEvent):void
        {
        }


    }
}//package scpacker.test.spectator

