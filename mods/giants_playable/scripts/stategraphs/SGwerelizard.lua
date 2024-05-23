require("stategraphs/commonstates")

local actionhandlers = 
{
    
--    ActionHandler(ACTIONS.CHOP, "work"),
--    ActionHandler(ACTIONS.MINE, "work"),
    ActionHandler(ACTIONS.DIG, "work"),
    ActionHandler(ACTIONS.HAMMER, "work"),
    ActionHandler(ACTIONS.EAT, "eat"),
}


local events=
{
    CommonHandlers.OnLocomote(true,false),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    EventHandler("transform_person", function(inst) inst.sg:GoToState("towik") end)

}

local function destroystuff(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 4.3)
    local heading_angle = -(inst.Transform:GetRotation())
GlobalDestroyings(inst, pt, ents, heading_angle)
end

local function TheShake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    local player = GetPlayer() --GetClosestInstWithTag("player", inst, SHAKE_DIST)
        player.components.playercontroller:ShakeCamera(inst, "FULL", 0.3, 0.03, 0.3, 40)
end

local states=
{
    

    State{
        name = "transform_pst",
        tags = {"busy"},
        onenter = function(inst)
	    inst.components.playercontroller:Enable(false)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("transform_pst")
            inst.components.health:SetInvincible(true)
        end,
        
        onexit = function(inst)
            --inst.components.health:SetInvincible(false)
            inst.components.playercontroller:Enable(true)
        end,
        
        events=
        {
            EventHandler("animover", function(inst) TheCamera:SetDistance(30) inst.sg:GoToState("idle") end ),
        },        
    },    

    State{
        name = "work",
        tags = {"busy", "working"},
        
        onenter = function(inst)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.action = inst:GetBufferedAction()
        end,
        
        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
            TimeEvent(6*FRAMES, function(inst) inst:PerformBufferedAction() end),
            TimeEvent(7*FRAMES, function(inst) inst.sg:RemoveStateTag("working") inst.sg:RemoveStateTag("busy") inst.sg:AddStateTag("idle") end),
            TimeEvent(8*FRAMES, function(inst)
                if (TheInput:IsMouseDown(MOUSEBUTTON_LEFT) or
                   TheInput:IsKeyDown(KEY_SPACE)) and 
                    inst.sg.statemem.action and 
                    inst.sg.statemem.action:IsValid() and 
                    inst.sg.statemem.action.target and 
                    inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action) and 
                    inst.sg.statemem.action.target.components.workable then
                        inst:ClearBufferedAction()
                        inst:PushBufferedAction(inst.sg.statemem.action)
                end
            end),            
        },
    },

    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("eat")
            inst.SoundEmitter:PlaySound("dontstarve/characters/wik/eat_lizard") 
        end,
        
        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) inst:PerformBufferedAction()  end),
            TimeEvent(12*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") inst.sg:AddStateTag("idle") end),
        },        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
}

CommonStates.AddCombatStates(states,
{
    hittimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/wik/hurt_lizard") end),
    },
    
    attacktimeline = 
    {
    
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
        TimeEvent(6*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        TimeEvent(8*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") inst.sg:RemoveStateTag("busy") inst.sg:AddStateTag("idle") end),
    },

    deathtimeline=
    {
    },
})

CommonStates.AddRunStates(states,
{
	starttimeline =
	{
        TimeEvent(1*FRAMES, function(inst)
                    TheShake(inst)
                    destroystuff(inst)
                    end),
	},
    runtimeline = 
    {
        TimeEvent(0*FRAMES, function(inst)
					TheShake(inst)
                    destroystuff(inst)
                    end),
        TimeEvent(10*FRAMES, function(inst)
					TheShake(inst)
                    destroystuff(inst)
					inst.StompSplash(inst)
                    end),
--[[        TimeEvent(36*FRAMES, function(inst)
                    destroystuff(inst)
                    end),
        TimeEvent(48*FRAMES, function(inst)
                    destroystuff(inst)
                    end),--]]
    },
})

CommonStates.AddIdle(states)
    
return StateGraph("werelizard", states, events, "idle", actionhandlers)

