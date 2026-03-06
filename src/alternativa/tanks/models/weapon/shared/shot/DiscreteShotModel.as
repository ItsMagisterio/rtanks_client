package alternativa.tanks.models.weapon.shared.shot
{
   import package_13.Long;
   import package_39.Model;
   
   public class DiscreteShotModel extends Model
   {
       
      
      private var var_25:Long;
      
      public function DiscreteShotModel()
      {
         this.var_25 = Long.getLong(1366230363,-857495328);
         super();
      }
      
      override public function get id() : Long
      {
         return this.var_25;
      }
   }
}
