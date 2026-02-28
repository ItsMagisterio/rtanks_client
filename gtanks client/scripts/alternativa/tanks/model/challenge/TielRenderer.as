package alternativa.tanks.model.challenge
{
   import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
   import controls.Label;
   import fl.controls.listClasses.CellRenderer;
   
   public class TielRenderer extends CellRenderer
   {
       
      
      private var panel:GreenPanel;
      
      private var task:Label;
      
      private var taskValue:Label;
      
      private var prize:Label;
      
      private var prizeValue:Label;
      
      public function TielRenderer()
      {
         this.panel = new GreenPanel(240,200);
         this.task = new Label();
         this.taskValue = new Label();
         this.prize = new Label();
         this.prizeValue = new Label();
         super();
         this.buttonMode = false;
         this.useHandCursor = true;
         addChild(this.panel);
         this.task.color = 5898034;
         this.task.text = "Задание:";
         this.task.x = 5;
         this.task.y = 5;
         addChild(this.task);
         this.taskValue.color = 16777215;
         this.taskValue.x = 5;
         this.taskValue.y = 20;
         addChild(this.taskValue);
         this.prize.color = 5898034;
         this.prize.text = "Приз:";
         this.prize.x = 5;
         this.prize.y = 165;
         addChild(this.prize);
         this.prizeValue.color = 16777215;
         this.prizeValue.x = 5;
         this.prizeValue.y = 180;
         addChild(this.prizeValue);
      }
      
      override public function set data(param1:Object) : void
      {
         var prize:String = null;
         _data = param1;
         this.taskValue.text = _data.description;
         var countPrizes:int = _data.prizes.length;
         for each(prize in _data.prizes)
         {
            this.prizeValue.text += prize + "\n";
         }
         this.prize.y -= countPrizes * (this.prize.height - 9);
         this.prizeValue.y = this.prize.y + 15;
         this.panel.setState(_data.state);
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function drawLayout() : void
      {
      }
      
      override protected function drawIcon() : void
      {
      }
   }
}
