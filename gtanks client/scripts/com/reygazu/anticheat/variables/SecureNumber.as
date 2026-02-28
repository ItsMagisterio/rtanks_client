// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.reygazu.anticheat.variables.SecureNumber

package com.reygazu.anticheat.variables
{
    import com.reygazu.anticheat.managers.CheatManager;

    public class SecureNumber 
    {

        private var secureData:SecureObject;
        private var fake:Number;

        public function SecureNumber(name:String="Unnamed SecureNumber", _fake:Number=0)
        {
            this.fake = _fake;
            this.secureData = new SecureObject(name, _fake);
        }

        public function set value(data:Number):void
        {
            if (this.fake != this.secureData.objectValue)
            {
                CheatManager.getInstance().detectCheat(this.secureData.name, this.fake, this.secureData.objectValue);
            };
            this.secureData.objectValue = data;
            this.fake = data;
        }

        public function get value():Number
        {
            return (this.secureData.objectValue as Number);
        }


    }
}//package com.reygazu.anticheat.variables

