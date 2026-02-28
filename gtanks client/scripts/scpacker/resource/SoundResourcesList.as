// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.resource.SoundResourcesList

package scpacker.resource
{
    import flash.utils.Dictionary;

    public class SoundResourcesList 
    {

        private var sounds:Dictionary;

        public function SoundResourcesList()
        {
            this.sounds = new Dictionary();
        }

        public function add(sound:SoundResource):void
        {
            if (this.sounds[sound.nameID] == null)
            {
                if (sound.sound != null)
                {
                    this.sounds[sound.nameID] = sound;
                }
                else
                {
                    throw (new Error("Sound null!"));
                };
            }
            else
            {
                trace("Sound arleady registered!");
            };
        }

        public function getSound(key:String):SoundResource
        {
            return (this.sounds[key]);
        }


    }
}//package scpacker.resource

