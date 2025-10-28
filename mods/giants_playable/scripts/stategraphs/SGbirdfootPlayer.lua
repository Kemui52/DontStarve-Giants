require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local stompstarttime = 0
local function GetTimeSinceStomp()
    return GetTime() - stompstarttime
end

local events=
{
    EventHandler("locomote", 
    function(inst) 
        if (not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving")) then return end
        if inst.sg:HasStateTag("STOPFUCKINGMOVING") then return end

        if not inst.components.locomotor:WantsToMoveForward() then
            if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("busy") then
                inst.sg:GoToState("idle")
            end
        else
            if not inst.sg:HasStateTag("busy") then
				if GetTimeSinceStomp() < 1.5 and inst.sg:HasStateTag("idle") and inst.sg:HasStateTag("canrotate") then
					inst.sg:GoToState("idle_move")
				elseif not inst.sg:HasStateTag("moving") then --How does this not work???
					inst.sg:GoToState("stomp_pre")
				end
            end
        end
    end),
}

local function roundToNearest(numToRound, multiple)
	local half = multiple/2
	return numToRound+half - (numToRound+half) % multiple
end

local function GetRotation(inst)
	local rotationTranslation = 
	{
		["0"] = 180, -- "E"
		["1"] = 135, -- "up skipped?"
		["2"] = 0, -- "W"
		["3"] = -135, --"down skipped?"
		["4"] = 110, --"NE/N"
		["5"] = 65, --"NW"
		["6"] = -100, --"SE/S"
		["7"] = -80, --"SW"
	}
	local cameraVec = TheCamera:GetDownVec()
	local cameraAngle =  math.atan2(cameraVec.z, cameraVec.x)
	cameraAngle = cameraAngle * (180/math.pi)
	cameraAngle = roundToNearest(cameraAngle, 45)
	local rot = inst.AnimState:GetCurrentFacing()
	return rotationTranslation[tostring(rot)] - cameraAngle
end

local function SpawnPrint(inst)
	local footprint = SpawnPrefab("rocfootprint")
	footprint.Transform:SetPosition(inst:GetPosition():Get())
	footprint.Transform:SetRotation(GetRotation(inst))
end

local function DoStep(inst)
	--local player = GetPlayer()
	--local distToPlayer = inst:GetPosition():Dist(player:GetPosition())
	--local power = Lerp(3, 1, distToPlayer/180)
	inst.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.5, 0.03, 1.7, 40) 
	inst.components.groundpounder:GroundPound()
	if GetWorld():HasTag("shipwrecked") or GetWorld():HasTag("porkland") then
		if inst.GetIsOnWater(inst) then
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_water")
		else
			SpawnPrint(inst)
			inst.SoundEmitter:PlaySound(inst.altsound)
		end
	else
		SpawnPrint(inst)
		inst.SoundEmitter:PlaySound(inst.altsound)
	end
	GetWorld():PushEvent("bigfootstep") --Wakes up sleeping entities.
end

local function destroystuff(inst, radius)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, radius)
    local heading_angle = -(inst.Transform:GetRotation())
GlobalDestroyings(inst, pt, ents, heading_angle)
end

local states=
{

	State{
		name = "idle_move",

		tags = {"idle", "canrotate"},

		onenter = function(inst)
			if inst.components.locomotor:WantsToMoveForward() then
				inst.components.locomotor:WalkForward()
			end
		end,
		
		onexit = function(inst)

		end,
	},

	State{
		name = "idle",

		tags = {"idle"},

		onenter = function(inst)
		--	inst:Hide()
			inst.components.locomotor:Stop()
		end,
		
		onexit = function(inst)
			inst:Show()
		end,
	},

	State{
		name = "stomp_pre",

		tags = {"canrotate"},

		onenter = function(inst)
            inst.sg:SetTimeout(1/30)
		end,
		
		onexit = function(inst)

		end,
        
        ontimeout= function(inst)
			if inst.components.locomotor:WantsToMoveForward() then
				inst.sg:GoToState("stomp")
			else
				inst.sg:GoToState("idle")
			end
        end,
	},

	State{
		name = "stomp",

		tags = {"busy"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("stomp_pre")
			inst.components.locomotor:Stop()
		end,
		
		events =
		{
			--EventHandler("playernear", function(inst) inst.sg:GoToState("stomp_pst") end),
			EventHandler("animover", function(inst) inst.sg:GoToState("stomp_pst") end)
		},

		timeline =
		{
			TimeEvent(5*FRAMES, function(inst)
				DoStep(inst)
				destroystuff(inst,7.0)
				inst.StompSplash(inst)
				inst.AnimState:SetSortOrder(2)
			--	inst.AnimState:SetFinalOffset(15)
			end),
			TimeEvent(6*FRAMES, function(inst)
				destroystuff(inst,7.0)
			end),
			TimeEvent(11*FRAMES, function(inst)
				destroystuff(inst,9.0)
			end),
	--		TimeEvent(12*FRAMES, function(inst)
	--			destroystuff(inst,9.0)
	--		end),
			TimeEvent(16*FRAMES, function(inst)
				destroystuff(inst,11.3)
			end),
	--		TimeEvent(18*FRAMES, function(inst)
	--			destroystuff(inst,11.3)
	--		end),
		},
	},

	State{
		name = "stomp_pst",
		
		tags = {"busy", "STOPFUCKINGMOVING"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("stomp_pst")
		end,

		onexit = function(inst)

		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle_move")
				stompstarttime = GetTime()
			end),
			EventHandler("locomote", function(inst)
				if inst.components.locomotor:WantsToMoveForward() then
					inst.components.locomotor:WalkForward()
				end
			end)
		},

		timeline =
		{
			TimeEvent(23*FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				inst.sg:AddStateTag("canrotate")
				inst.sg:AddStateTag("moving")
			end),
			TimeEvent(24*FRAMES, function(inst)
				if inst.components.locomotor:WantsToMoveForward() then
					inst.components.locomotor:WalkForward()
				end
			end)
		},
	},
}
  
return StateGraph("birdfootPlayer", states, events, "idle", actionhandlers)