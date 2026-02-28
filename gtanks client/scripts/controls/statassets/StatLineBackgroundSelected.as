// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//controls.statassets.StatLineBackgroundSelected

package controls.statassets
{
    import flash.display.Sprite;
    import flash.display.Bitmap;

    public class StatLineBackgroundSelected extends Sprite 
    {

        public static var bg:Bitmap = new Bitmap();

        public function StatLineBackgroundSelected()
        {
            addChild(new Bitmap(bg.bitmapData));
        }

    }
}//package controls.statassets

