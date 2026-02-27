package clan.notifications
{
   import package_13.Long;
   import package_26.ClanNotificationsManager;
   
   public class ClanMemberNotificationIndicator extends NotificationIndicatorLabel
   {
       
      
      private var userId:Long;
      
      private var var_2702:Boolean = true;
      
      public function ClanMemberNotificationIndicator(param1:Long)
      {
         super();
         this.userId = param1;
      }
      
      override public function hide() : void
      {
         this.var_2702 = false;
      }
      
      override public function show() : void
      {
         this.var_2702 = true;
      }
      
      override public function updateNotifications() : void
      {
         visible = ClanNotificationsManager.name_1949(this.userId) && this.var_2702;
      }
   }
}
