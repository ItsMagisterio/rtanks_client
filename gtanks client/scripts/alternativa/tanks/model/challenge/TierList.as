package alternativa.tanks.model.challenge
{
   import alternativa.tanks.model.challenge.greenpanel.State;
   import alternativa.tanks.model.challenge.server.ChallengeServerData;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.TankWindowInner;
   import fl.controls.ScrollBarDirection;
   import fl.controls.TileList;
   import fl.data.DataProvider;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import forms.Styles;
   
   public class TierList extends TankWindowInner
   {
      
      public static const STATE_DEFAULT:int = 0;
      
      public static const STATE_CURRENT:int = 1;
      
      public static const STATE_DONE:int = 2;
      
      private static const MIN_POSSIBLE_SPEED:Number = 70;
      
      private static const MAX_DELTA_FOR_SELECT:Number = 7;
      
      private static const ADDITIONAL_SCROLL_AREA_HEIGHT:Number = 3;
       
      
      private var list:TileList;
      
      private var previousPositionX:Number;
      
      private var currentPositionX:Number;
      
      private var sumDragWay:Number;
      
      private var lastItemIndex:int;
      
      private var previousTime:int;
      
      private var currentTime:int;
      
      private var scrollSpeed:Number = 0;
      
      private var blinkTimer:Timer;
      
      public function TierList()
      {
         this.list = new TileList();
         super(0,0,GREEN);
         this.list.x = 3;
         this.list.y = 3;
         this.list.rowCount = 1;
         this.list.rowHeight = 223;
         this.list.columnWidth = 246;
         this.list.focusEnabled = false;
         this.list.horizontalScrollBar.focusEnabled = false;
         this.list.direction = ScrollBarDirection.HORIZONTAL;
         this.list.setStyle(Styles.CELL_RENDERER,TielRenderer);
         this.list.dataProvider = new DataProvider();
         this.list.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.list.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.list.setStyle("trackUpSkin",ScrollTrackGreen);
         this.list.setStyle("trackDownSkin",ScrollTrackGreen);
         this.list.setStyle("trackOverSkin",ScrollTrackGreen);
         this.list.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.list.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
         addChild(this.list);
         addEventListener(Event.ADDED_TO_STAGE,this.addListeners);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeListeners);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = Math.ceil(param1);
         this.list.width = width - 5;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = Math.ceil(param1);
         this.list.height = height + 2;
      }
      
      public function testInit() : void
      {
         var obj:Object = null;
         this.list.dataProvider.removeAll();
         for(var i:int = 0; i < 100; i++)
         {
            obj = new Object();
            obj.id = Math.random();
            if(i == 0)
            {
               obj.state = State.COMPLETED;
            }
            if(i == 1)
            {
               obj.state = State.CURRENT;
            }
            if(i > 1)
            {
               obj.state = State.BLOCKED;
            }
            this.list.dataProvider.addItem(obj);
         }
      }
      
      public function setTiers(quests:Array, level:int) : *
      {
         var quest:ChallengeServerData = null;
         var obj:Object = null;
         this.list.dataProvider.removeAll();
         for each(quest in quests)
         {
            obj = new Object();
            obj.description = quest.description;
            obj.prizes = quest.prizes;
            obj.state = quest.level == level ? State.CURRENT : (quest.level < level ? State.COMPLETED : State.BLOCKED);
         }
         this.list.dataProvider.addItem(obj);
      }
      
      private function stopTimer() : *
      {
         if(this.blinkTimer != null)
         {
            this.blinkTimer.stop();
            this.blinkTimer = null;
         }
      }
      
      private function scrollList(param1:MouseEvent) : void
      {
         this.list.horizontalScrollPosition -= param1.delta * (!!Boolean(Capabilities.os.search("Linux") != -1) ? 50 : 10);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.scrollSpeed = 0;
         var _loc2_:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
         _loc2_.top -= ADDITIONAL_SCROLL_AREA_HEIGHT;
         if(!_loc2_.contains(param1.stageX,param1.stageY))
         {
            this.sumDragWay = 0;
            this.previousPositionX = this.currentPositionX = param1.stageX;
            this.currentTime = this.previousTime = getTimer();
            this.lastItemIndex = this.list.selectedIndex;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         var _loc2_:* = Number((getTimer() - this.previousTime) / 1000);
         if(_loc2_ == 0)
         {
            _loc2_ = 0.1;
         }
         var _loc3_:Number = param1.stageX - this.previousPositionX;
         this.scrollSpeed = _loc3_ / _loc2_;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = (this.currentTime - this.previousTime) / 1000;
         this.list.horizontalScrollPosition -= this.scrollSpeed * _loc2_;
         var _loc3_:Number = this.list.horizontalScrollPosition;
         var _loc4_:Number = this.list.maxHorizontalScrollPosition;
         if(Math.abs(this.scrollSpeed) > MIN_POSSIBLE_SPEED && 0 < _loc3_ && _loc3_ < _loc4_)
         {
            this.scrollSpeed *= Math.exp(-1.5 * _loc2_);
         }
         else
         {
            this.scrollSpeed = 0;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         this.previousPositionX = this.currentPositionX;
         this.currentPositionX = param1.stageX;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = this.currentPositionX - this.previousPositionX;
         this.sumDragWay += Math.abs(_loc2_);
         if(this.sumDragWay > MAX_DELTA_FOR_SELECT)
         {
            this.list.horizontalScrollPosition -= _loc2_;
         }
         param1.updateAfterEvent();
      }
      
      private function addListeners(param1:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function removeListeners(param1:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      public function destroy() : void
      {
         this.stopTimer();
      }
   }
}
