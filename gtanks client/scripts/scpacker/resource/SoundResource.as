// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.resource.SoundResource

package scpacker.resource
{
    import flash.media.Sound;

    public class SoundResource 
    {

        public var sound:Sound;
        public var nameID:String;

        public function SoundResource(sound:Sound, id:String)
        {
            this.nameID = id;
            this.sound = sound;
        }

    }
}//package scpacker.resource

