// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//controls.statassets.StatHeader

package controls.statassets
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import forms.events.StatListEvent;
    import flash.events.MouseEvent;

    public class StatHeader extends Sprite 
    {

        protected var tabs:Array = new Array();
        protected var headers:Array;
        protected var _currentSort:int = 0;
        protected var _oldSort:int = 0;
        protected var _width:int = 800;

        public function StatHeader()
        {
            var cell:StatHeaderButton;
            super();
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.headers = [localeService.getText(TextConst.STATISTICS_HEADER_NUMBER), localeService.getText(TextConst.STATISTICS_HEADER_RANK), localeService.getText(TextConst.STATISTICS_HEADER_CALLSIGN), localeService.getText(TextConst.STATISTICS_HEADER_ACHIVIMENTS), localeService.getText(TextConst.STATISTICS_HEADER_RATING)];
            var i:int;
            while (i < 5)
            {
                cell = new StatHeaderButton(((i < 1) || (i > 3)));
                cell.label = this.headers[i];
                cell.height = 18;
                cell.numSort = i;
                addChild(cell);
                i++;
            };
            this.draw();
        }

        override public function set width(w:Number):void
        {
            this._width = Math.floor(w);
            this.draw();
        }

        protected function draw():void
        {
            var cell:StatHeaderButton;
            var i:int;
            var infoX:int = int((this._width - 65));
            this.tabs = [0, 55, 200, 330, infoX, (this._width - 1), (infoX + 130), (infoX + 180), (infoX + 220), (infoX + 285), (this._width - 1)];
            i = 0;
            while (i < 5)
            {
                cell = (getChildAt(i) as StatHeaderButton);
                cell.width = ((this.tabs[(i + 1)] - this.tabs[i]) - 2);
                cell.x = this.tabs[i];
                cell.selected = (i == this._currentSort);
                i++;
            };
        }

        protected function changeSort(e:MouseEvent):void
        {
            var trgt:StatHeaderButton = (e.currentTarget as StatHeaderButton);
            this._currentSort = trgt.numSort;
            if (this._currentSort != this._oldSort)
            {
                this.draw();
                dispatchEvent(new StatListEvent(StatListEvent.UPDATE_SORT, 0, 0, this._currentSort));
                this._oldSort = this._currentSort;
            };
        }


    }
}//package controls.statassets

