// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.bonuses.SpawnAnimation

package alternativa.tanks.models.effects.common.bonuscommon
{
    import alternativa.tanks.utils.objectpool.PooledObject;
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
    import alternativa.tanks.battle.Renderer;
    import alternativa.tanks.utils.objectpool.Pool;

    public class SpawnAnimation extends PooledObject implements Renderer 
    {

        private static const ALPHA_SPEED:Number = 0.001;

        private var bonus:BattleBonus;
        private var battleScene3D:Scene3DContainer;//BattleScene3D;
        private var alpha:Number = 0;

        public function SpawnAnimation(pool:Pool)
        {
            super(pool);
        }

        public function start(bonus:ParaBonus, battleScene3D:Scene3DContainer; BattleScene3D):void
        {
            this.bonus = bonus;
            this.battleScene3D = battleScene3D;
            this.alpha = 0;
            bonus.onDestroy.add(this.destroy);
            battleScene3D.addRenderer(this, 0);
        }

        public function render(time:int, deltaMillis:int):void
        {
            this.alpha = (this.alpha + (ALPHA_SPEED * deltaMillis));
            if (this.alpha > 1){
                this.alpha = 1;
            };
            this.bonus.setAlpha(this.alpha);
            if (this.alpha >= 1){
                this.destroy();
            };
        }

        private function destroy():void
        {
            this.battleScene3D.removeRenderer(this, 0);
            this.battleScene3D = null;
            this.bonus.onDestroy.remove(this.destroy);
            this.bonus = null;
            recycle();
        }


    }
}//package alternativa.tanks.models.effects.common.bonuscommon

