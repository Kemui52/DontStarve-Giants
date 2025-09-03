require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.HAMMER, "attack"),
	ActionHandler(ACTIONS.GOHOME, "taunt"),
}

local SHAKE_DIST = 40

local function DeerclopsFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    local player = GetPlayer() --GetClosestInstWithTag("player", inst, SHAKE_DIST)
        player.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.5, 0.03, 1.0, 40)
end

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local BeargerSoundfile = false

if softresolvefilepath("sound/bearger.fsb") then
	BeargerSoundfile = true
end

local function destroystuff(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4.3)
    local heading_angle = -(inst.Transform:GetRotation())
GlobalDestroyings(inst, pt, ents, heading_angle)
end

local states=
{
    State{
        name = "gohome",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst:ClearBufferedAction()
            inst.components.knownlocations:RememberLocation("home", nil)
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },      
    
	State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.GOHOME then
                inst:ClearBufferedAction()
                inst.components.knownlocations:RememberLocation("home", nil)
            end
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr") end),
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl") end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

}

CommonStates.AddWalkStates( states,
{
	starttimeline =
	{
        TimeEvent(7*FRAMES, function(inst)
                    DeerclopsFootstep(inst)
					inst.StompSplash(inst)
                    destroystuff(inst)
                    end),
	},
    walktimeline = 
    { 
        TimeEvent(12*FRAMES, function(inst)
                --    DeerclopsFootstep(inst)
                    destroystuff(inst)
                    end),
        TimeEvent(23*FRAMES, function(inst)
                    DeerclopsFootstep(inst)
					inst.StompSplash(inst)
                    destroystuff(inst)
                    end),
        TimeEvent(36*FRAMES, function(inst)
                --    DeerclopsFootstep(inst)
                    destroystuff(inst)
                    end),
        TimeEvent(48*FRAMES, function(inst)
                    DeerclopsFootstep(inst)
					inst.StompSplash(inst)
                    destroystuff(inst)
                    end),
    },
    endtimeline=
    {
        TimeEvent(5*FRAMES, function(inst)
                    DeerclopsFootstep(inst)
                --    destroystuff(inst)
                    end),
    },
})

CommonStates.AddCombatStates(states,
{
	hittimeline =
	{
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/hurt") end),
	},
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
        TimeEvent(35*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
			if BeargerSoundfile then
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
			end
            inst.components.combat:DoAttack(inst.sg.statemem.target)
            if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.HAMMER then
                inst.bufferedaction.target.components.workable:SetWorkLeft(1)
                inst:PerformBufferedAction()
            end
            local player = GetPlayer() --ClosestInstWithTag("player", inst, SHAKE_DIST)

                player.components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 2, SHAKE_DIST)

        end),
        TimeEvent(36*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },
    deathtimeline=
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/death") end),
        TimeEvent(50*FRAMES, function(inst)
            if GetSeasonManager():GetSnowPercent() > 0.02 then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_snow")
            else
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_dirt")
            end    
            local player = GetPlayer() --ClosestInstWithTag("player", inst, SHAKE_DIST)
            if player then
                player.components.playercontroller:ShakeCamera(inst, "FULL", 0.7, 0.02, 3, SHAKE_DIST)
            end
        end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        --TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("deerclopsPlayer", states, events, "idle", actionhandlers)

