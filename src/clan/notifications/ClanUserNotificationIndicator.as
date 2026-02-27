package clan.notifications
{
   import package_13.Long;
   import package_26.ClanUserNotificationsManager;
   
   public class ClanUserNotificationIndicator extends NotificationIndicatorLabel
   {
       
      
      private var clanId:Long;
      
      public function ClanUserNotificationIndicator(param1:Long)
      {
         super();
         this.clanId = param1;
      }
      
      override public function updateNotifications() : void
      {
         visible = ClanUserNotificationsManager.name_1873(this.clanId);
      }
   }
}
