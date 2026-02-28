// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum

package com.alternativaplatform.projects.tanks.client.commons.models.itemtype
{
    public class ItemTypeEnum 
    {

        public static var WEAPON:ItemTypeEnum = new ItemTypeEnum(1);
        public static var ARMOR:ItemTypeEnum = new ItemTypeEnum(2);
        public static var COLOR:ItemTypeEnum = new ItemTypeEnum(3);
        public static var INVENTORY:ItemTypeEnum = new ItemTypeEnum(4);
        public static var PLUGIN:ItemTypeEnum = new ItemTypeEnum(5);

        public var value:int;

        public function ItemTypeEnum(value:int)
        {
            this.value = value;
        }

    }
}//package com.alternativaplatform.projects.tanks.client.commons.models.itemtype

