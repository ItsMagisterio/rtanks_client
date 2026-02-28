// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//scpacker.resource.tanks.TankResourceList

package scpacker.resource.tanks
{
    import flash.utils.Dictionary;

    public class TankResourceList 
    {

        public var models:Dictionary;

        public function TankResourceList()
        {
            this.models = new Dictionary();
        }

        public function add(model:TankResource):void
        {
            if (this.models[model.id] == null)
            {
                if (model.mesh != null)
                {
                    this.models[model.id] = model;
                }
                else
                {
                    throw (new Error("Model null!"));
                };
            }
            else
            {
                trace("Model arleady registered!");
            };
        }

        public function getModel(key:String):TankResource
        {
            return (this.models[key]);
        }


    }
}//package scpacker.resource.tanks

