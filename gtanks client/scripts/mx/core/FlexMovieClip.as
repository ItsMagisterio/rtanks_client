// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//mx.core.FlexMovieClip

package mx.core
{
    import flash.display.MovieClip;
    import mx.utils.NameUtil;
    import mx.core.mx_internal; 

    use namespace mx_internal;

    public class FlexMovieClip extends MovieClip 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public function FlexMovieClip()
        {
            try
            {
                name = NameUtil.createUniqueName(this);
            }
            catch(e:Error)
            {
            };
        }

        override public function toString():String
        {
            return (NameUtil.displayObjectToString(this));
        }


    }
}//package mx.core

