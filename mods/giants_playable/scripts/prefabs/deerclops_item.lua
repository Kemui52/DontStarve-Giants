local assets=
{
	Asset("ANIM", "anim/mybearger.zip"),
}

--require "prefabs/wik"


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("mybearger")
    inst.AnimState:SetBuild("mybearger")
    inst.AnimState:PlayAnimation("idle")
local function SetStandState(inst, state)
    inst.StandState = string.lower(state)
end
local function OnDeploy (inst, pt, deployer)
    BecomeDeerclops(deployer)   --inst.components.lizardness.makelizard(inst) --which means BecomeLizard(pt) pt has user's coords, at least.
--[[    local mybear = SpawnPrefab("deerclops_item")
    mybear.Transform:SetPosition(pt.x, pt.y, pt.z)
    mybear.AnimState:SetBank("bearger")
    mybear.AnimState:SetBuild("bearger_build")
    mybear.AnimState:PlayAnimation("idle_loop", true)
    mybear.Transform:SetScale(1, 1, 1)
    mybear.Transform:SetFourFaced()
    local sound = mybear.entity:AddSoundEmitter()
    local shadow = mybear.entity:AddDynamicShadow()
    shadow:SetSize(3, 1.8)
    MakeCharacterPhysics(mybear, 500, 1)
    mybear:RemoveComponent("equippable")
    mybear:RemoveComponent("inventoryitem")
    mybear:RemoveComponent("fueled")
    mybear:RemoveComponent("deployable")
    SetStandState(mybear, "QUAD")
    mybear.CanGroundPound = false
    mybear.SetStandState = SetStandState
    mybear.IsStandState = function(mybear, state)
        return mybear.StandState == string.lower(state)
    end
    mybear.WorkEntities = function(mybear)
        mybear.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
        GetPlayer().components.playercontroller:ShakeCamera(mybear, "FULL", 0.5, 0.05, 2, 40)
    end
    mybear:AddComponent("groundpounder")
    mybear.components.groundpounder.destroyer = true
    mybear.components.groundpounder.damageRings = 3
    mybear.components.groundpounder.destructionRings = 4
    mybear.components.groundpounder.numRings = 5
    mybear:AddComponent("named")
    mybear.components.named:SetName("My Bear")
    mybear:AddComponent("inventory")
    mybear:AddComponent("knownlocations")
    mybear:AddComponent("timer")
    mybear:AddComponent("eater")
    mybear.components.eater.foodprefs = {"MEAT"}
    mybear:AddComponent("follower")
    mybear.components.follower:SetLeader(GetPlayer())
    mybear:AddComponent("lootdropper")
    mybear.components.lootdropper:SetLoot({"meat", "meat", "meat", "meat", "bearger_fur"})
    mybear:AddComponent("health")
    mybear.components.health:SetMaxHealth(2000)
    mybear:AddComponent("combat")
    mybear.components.combat:SetDefaultDamage(100)
    mybear.components.combat:SetAttackPeriod(0.5)
    mybear.components.combat.hiteffectsymbol = "bearger_body"
    mybear.components.combat:SetAreaDamage(4, 1)
    mybear.components.combat.playerdamagepercent = 0
    mybear.components.combat:SetRange(2, 4)
    mybear.components.combat:SetHurtSound("dontstarve_DLC001/creatures/bearger/hurt")
    mybear.components.combat:SetRetargetFunction(1, function(mybear)
        if not mybear.components.health:IsDead() then
            return FindEntity(mybear, 25, function(guy)
                if guy.components.combat then
                   return guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy or guy:HasTag("monster")
                end
            end )
        end
    end )
    mybear.components.combat:SetKeepTargetFunction(function(mybear, target) return target and target:IsValid() end )
    mybear:ListenForEvent("attacked", function(mybear, data)
        if data.attacker ~= GetPlayer() then
           mybear.components.combat:SetTarget(data.attacker)
        else
           mybear.components.combat:SetTarget(nil)
        end
    end )
    mybear:AddComponent("locomotor")
    mybear.components.locomotor.walkspeed = 15
    mybear.components.locomotor.runspeed = 20
    mybear.components.locomotor:SetShouldRun(true)
    mybear:SetStateGraph("SGbearger")
    local brain = require "brains/abigailbrain"
    mybear:SetBrain(brain)
    mybear:AddComponent("trader")
    mybear.components.trader:SetAcceptTest(function(mybear, item)
        if item.prefab == "meat" then
           return mybear.components.health:GetPercent() < 1
        end
        return false
    end )
    mybear.components.trader.onaccept = function(mybear, giver, item)
        if item.prefab == "meat" then
           mybear.components.health:DoDelta(200)
        end
    end
    mybear.components.inspectable.getstatus = function(mybear)
        if not mybear:HasTag("stophere") then
           mybear:AddTag("stophere")
           mybear.components.locomotor:Stop()
           mybear:SetBrain(nil)
           mybear.components.follower:SetLeader(nil)
           mybear.AnimState:PlayAnimation("sleep_loop",true)
        else
           mybear:RemoveTag("stophere")
           local brain = require "brains/abigailbrain"
           mybear:SetBrain(brain)
           mybear:RestartBrain()
           mybear.components.follower:SetLeader(GetPlayer())
        end
    end
    mybear:AddTag("companion")
    mybear:AddTag("mybears")
    inst:Remove() --]]
end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
--[[local function onsave(inst, data)
    if inst:HasTag("mybears") then
        data.mybears = true
    end
    if inst:HasTag("stophere") then
        data.stophere = true
    end
end
local function onload(inst, data)
  if data and data.mybears then
    inst.AnimState:SetBank("bearger")
    inst.AnimState:SetBuild("bearger_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.Transform:SetScale(1, 1, 1)
    inst.Transform:SetFourFaced()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(3, 1.8)
    MakeCharacterPhysics(inst, 500, 1)
    inst:RemoveComponent("equippable")
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("fueled")
    inst:RemoveComponent("deployable")
    SetStandState(inst, "QUAD")
    inst.CanGroundPound = false
    inst.SetStandState = SetStandState
    inst.IsStandState = function(inst, state)
        return inst.StandState == string.lower(state)
    end
    inst.WorkEntities = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
        GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 2, 40)
    end
    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 3
    inst.components.groundpounder.destructionRings = 4
    inst.components.groundpounder.numRings = 5
    inst:AddComponent("named")
    inst.components.named:SetName("My Bear")
    inst:AddComponent("inventory")
    inst:AddComponent("knownlocations")
    inst:AddComponent("timer")
    inst:AddComponent("eater")
    inst.components.eater.foodprefs = {"MEAT"}
    inst:AddComponent("follower")
    inst.components.follower:SetLeader(GetPlayer())
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"meat", "meat", "meat", "meat", "bearger_fur"})
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(6000)
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(100)
    inst.components.combat:SetAttackPeriod(0.5)
    inst.components.combat.hiteffectsymbol = "bearger_body"
    inst.components.combat:SetAreaDamage(4, 1)
    inst.components.combat.playerdamagepercent = 0
    inst.components.combat:SetRange(2, 4)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/bearger/hurt")
    inst.components.combat:SetRetargetFunction(1, function(inst)
        if not inst.components.health:IsDead() then
            return FindEntity(inst, 25, function(guy)
                if guy.components.combat then
                   return guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy or guy:HasTag("monster")
                end
            end )
        end
    end )
    inst.components.combat:SetKeepTargetFunction(function(inst, target) return target and target:IsValid() end )
    inst:ListenForEvent("attacked", function(inst, data)
        if data.attacker ~= GetPlayer() then
           inst.components.combat:SetTarget(data.attacker)
        else
           inst.components.combat:SetTarget(nil)
        end
    end )
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 15
    inst.components.locomotor.runspeed = 20
    inst.components.locomotor:SetShouldRun(true)
    inst:SetStateGraph("SGbearger")
    local brain = require "brains/abigailbrain"
    inst:SetBrain(brain)
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(inst, item)
        if item.prefab == "meat" then
           return inst.components.health:GetPercent() < 1
        end
        return false
    end )
    inst.components.trader.onaccept = function(inst, giver, item)
        if item.prefab == "meat" then
           inst.components.health:DoDelta(200)
        end
    end
    inst.components.inspectable.getstatus = function(inst)
        if not inst:HasTag("stophere") then
           inst:AddTag("stophere")
           inst.components.locomotor:Stop()
           inst:SetBrain(nil)
           inst.components.follower:SetLeader(nil)
           inst.AnimState:PlayAnimation("sleep_loop",true)
        else
           inst:RemoveTag("stophere")
           local brain = require "brains/abigailbrain"
           inst:SetBrain(brain)
           inst:RestartBrain()
           inst.components.follower:SetLeader(GetPlayer())
        end
    end
    inst:AddTag("companion")
    inst:AddTag("mybears")
  end
  if data and data.stophere then
    inst:AddTag("stophere")
    inst.components.locomotor:Stop()
    inst:SetBrain(nil)
    inst.components.follower:SetLeader(nil)
    inst.AnimState:PlayAnimation("sleep_loop",true)
  end
end
    inst.OnSave = onsave
    inst.OnLoad = onload --]]
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mybearger.xml"

	return inst
end

STRINGS.NAMES.DEERCLOPS_ITEM = "Bear Prototype" --item name
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEERCLOPS_ITEM = "Stay here or not?" --item desc

return Prefab( "common/inventory/deerclops_item", fn, assets) 
