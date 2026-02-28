




package alternativa.tanks.models.effects.common.bonuscommon{
    import alternativa.math.Vector3;
    import alternativa.math.Quaternion;

    public class LandingState {

        public const position:Vector3 = new Vector3();
        public const orientation:Quaternion = new Quaternion();

        public function interpolate(a:LandingState, b:LandingState, t:Number):void{
            this.position.interpolate(t, a.position, b.position);
            this.orientation.slerp(a.orientation, b.orientation, t);
        }
        public function copy(src:LandingState):void{
            this.position.vCopy(src.position);
            this.orientation.copy(src.orientation);
        }

    }
}

