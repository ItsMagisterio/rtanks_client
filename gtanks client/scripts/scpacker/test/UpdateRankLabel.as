// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.test.UpdateRankLabel

package scpacker.test
{
    import flash.display.Sprite;
    import controls.Label;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import flash.filters.GlowFilter;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.Event;

    public class UpdateRankLabel extends Sprite 
    {

        private var time:int = 0;
        private var _alpha:Number = 1;
        private var welcome:Label = new Label();
        private var rankNotification:Label = new Label();
        private var localeService:ILocaleService;

        public function UpdateRankLabel(rankName:String)
        {
            this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.welcome.size = 20;
            this.rankNotification.size = 20;
            this.welcome.textColor = 16777011;
            this.rankNotification.textColor = 16777011;
            var glow:GlowFilter = new GlowFilter(0);
            this.filters = [glow];
            this.welcome.text = this.localeService.getText(TextConst.BATTLE_PLAYER_RANKED_UP_CONGRATS);
            this.rankNotification.text = (((this.localeService.getText(TextConst.BATTLE_PLAYER_RANKED_UP_RANK) + "«") + rankName) + "»");
            addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onDeleteFromFrame);
        }

        private function onAdded(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            addEventListener(Event.ENTER_FRAME, this.update);
            Main.stage.addEventListener(Event.RESIZE, this.resize);
            addChild(this.welcome);
            addChild(this.rankNotification);
            this.resize(null);
        }

        public function resize(e:Event):void
        {
            this.welcome.x = ((Main.stage.stageWidth - this.welcome.width) >>> 1);
            this.welcome.y = (((Main.stage.stageHeight / 2) - (this.height / 2)) - this.rankNotification.height);
            this.rankNotification.x = ((Main.stage.stageWidth - this.rankNotification.width) >>> 1);
            this.rankNotification.y = (this.welcome.y + this.rankNotification.height);
        }

        private function update(e:Event):void
        {
            this.time = (this.time + 20);
            if (this.time >= 2500)
            {
                this._alpha = (this._alpha - 0.05);
                this.alpha = this._alpha;
                if (this._alpha <= 0.01)
                {
                    removeEventListener(Event.ENTER_FRAME, this.update);
                    removeEventListener(Event.RESIZE, this.resize);
                    this.filters = [];
                    this.onDeleteFromFrame(null);
                };
            };
        }

        private function onDeleteFromFrame(e:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onDeleteFromFrame);
            removeChild(this.welcome);
            removeChild(this.rankNotification);
            Main.contentUILayer.removeChild(this);
        }


    }
}//package scpacker.test

