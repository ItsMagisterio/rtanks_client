// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.alternativaplatform.projects.tanks.client.commons.types.DeathReason

package com.alternativaplatform.projects.tanks.client.commons.types
{
    public class DeathReason 
    {

        public static var SUICIDE:DeathReason = new (DeathReason)();
        public static var KILLED_IN_BATTLE:DeathReason = new (DeathReason)();


        public static function getReason(str:String):DeathReason
        {
            if (str == "suicide")
            {
                return (SUICIDE);
            };
            return (KILLED_IN_BATTLE);
        }


    }
}//package com.alternativaplatform.projects.tanks.client.commons.types

