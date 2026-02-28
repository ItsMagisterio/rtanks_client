// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.alternativaplatform.projects.tanks.client.models.tank.ClientTank

package com.alternativaplatform.projects.tanks.client.models.tank
{
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import com.alternativaplatform.projects.tanks.client.commons.types.TankSpecification;
    import com.alternativaplatform.projects.tanks.client.commons.types.TankState;

    public class ClientTank 
    {

        public var self:Boolean;
        public var teamType:BattleTeamType;
        public var incarnationId:int;
        public var tankSpecification:TankSpecification;
        public var tankState:TankState;
        public var spawnState:TankSpawnState;
        public var health:int;


    }
}//package com.alternativaplatform.projects.tanks.client.models.tank

