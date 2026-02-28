// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//controls.statassets.StatLineBackgroundNormal

package controls.statassets
{
    import flash.display.Sprite;
    import flash.display.Bitmap;

    public class StatLineBackgroundNormal extends Sprite 
    {

        public static var bg:Bitmap = new Bitmap();

        public function StatLineBackgroundNormal()
        {
            addChild(new Bitmap(bg.bitmapData));
        }

    }
}//package controls.statassets

