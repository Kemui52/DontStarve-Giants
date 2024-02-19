require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 20
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8

local SEE_TARGET_DIST = 20

local SEE_TREE_DIST = 15
local KEEP_CHOPPING_DIST = 10

local SEE_ROCK_DIST = 15
local KEEP_MINING_DIST = 10

local wikmermbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)



-- Added for follower

require "behaviours/chattynode"
require "behaviours/leash" 
require "behaviours/follow" 
require "behaviours/chaseandattack" 

local MAX_FOLLOW_DIST = 10 -- Originally 9 from Pigs

local function GetLeader(inst)
    return inst.components.follower.leader 
end

-- Add End


-- Original Functions
local function EatFoodAction(inst)
    local target = nil
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if not target then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end)
        if target then
            --check for scary things near the food
            local predator = GetClosestInstWithTag("scarytoprey", target, SEE_PLAYER_DIST)
            if predator then target = nil end
        end
    end
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem.owner and target.components.inventoryitem.owner ~= inst) end
        return act
    end
end

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       not inst.components.homeseeker.home:HasTag("fire") and
       not inst.components.homeseeker.home:HasTag("burnt") and
       inst.components.homeseeker.home:IsValid() and
       not inst.components.combat.target then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= SEE_PLAYER_DIST*SEE_PLAYER_DIST
end

local function ShouldGoHome(inst)
    --one merm should stay outside
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    local shouldStay = home and home.components.childspawner
                      and home.components.childspawner:CountChildrenOutside() <= 1
    return GetClock():IsDay() and not shouldStay
end

local function KeepChoppingAction(inst)
    return inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_CHOPPING_DIST*KEEP_CHOPPING_DIST
end

local function StartChoppingCondition(inst)
    return inst.components.follower.leader and inst.components.follower.leader.sg and inst.components.follower.leader.sg:HasStateTag("chopping")
end


local function FindTreeToChopAction(inst)
    local target = FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.CHOP end)
    if target then
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

local function KeepMiningAction(inst)
    return inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_MINING_DIST*KEEP_MINING_DIST
end

local function StartMiningCondition(inst)
    return inst.components.follower.leader and inst.components.follower.leader.sg and inst.components.follower.leader.sg:HasStateTag("mining")
end


local function FindRockToMineAction(inst)
    local target = FindEntity(inst, SEE_ROCK_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.MINE end)
    if target then
        return BufferedAction(inst, target, ACTIONS.MINE)
    end
end

function wikmermbrain:OnStart()


------------------------------------------------------------------------------------------------------
-- NOTES
-- Put the original Brain in the notfollowingPlayer part and if not a merm remove the SpringMod.    
-- SpringMod can be left in but you must move the function aswell -- Removed as breaks original
------------------------------------------------------------------------------------------------------

    -- Normal Brain
    local notfollowingPlayer = WhileNode( function() return not GetLeader(self.inst) end, "has Leader",
        PriorityNode
    {        
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST )),
        WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) ),
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true )),
        DoAction(self.inst, EatFoodAction, "Eat Food"),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, .25)

    -- Follower Brain
    local followingPlayer = WhileNode( function() return GetLeader(self.inst) end, "has leader",
        PriorityNode
        {
            WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

            IfNode(function() return StartChoppingCondition(self.inst) end, "chop", 
                WhileNode(function() return KeepChoppingAction(self.inst) end, "keep chopping",
                    LoopNode{ 
                        DoAction(self.inst, FindTreeToChopAction )})),

            IfNode(function() return StartMiningCondition(self.inst) end, "mine", 
                WhileNode(function() return KeepMiningAction(self.inst) end, "keep mining",
                    LoopNode{ 
                        DoAction(self.inst, FindRockToMineAction )})),

	    ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST ),
	    -- ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST ),	

            WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
                RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) ),

  	    Follow(self.inst, function() return self.inst.components.follower.leader end, .5, 6, MAX_FOLLOW_DIST),
	    Wander(self.inst, function() return Vector3( math.random()*360, 0, 0 ) end, 0),
        -- Added to follower, not in there originally but makes followers kill birds or rabbits too easily
        self.inst:AddTag("scarytoprey"),
        -- Increased attack speed for followers or Merm's will die pretty quick
        self.inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD/2),
    },.5)


    local root = PriorityNode(
    {

	notfollowingPlayer,
	followingPlayer
	
    }, .5)
    
    self.bt = BT(self.inst, root)

end

return wikmermbrain