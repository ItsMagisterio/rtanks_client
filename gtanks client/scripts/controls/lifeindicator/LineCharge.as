// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//controls.lifeindicator.LineCharge

package controls.lifeindicator
{
    public class LineCharge extends HorizontalBar 
    {

        private static const bitmapLeft:Class = LineCharge_bitmapLeft;
        private static const bitmapCenter:Class = LineCharge_bitmapCenter;
        private static const bitmapRight:Class = LineCharge_bitmapRight;

        public function LineCharge()
        {
            super(new bitmapLeft().bitmapData, new bitmapCenter().bitmapData, new bitmapRight().bitmapData);
        }

    }
}//package controls.lifeindicator

