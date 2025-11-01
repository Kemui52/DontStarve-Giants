--require "stategraphs/SGbigfoot"
local assets = {}
if softresolvefilepath("anim/roc_foot_print.zip") then
assets = 
{
--	Asset("ANIM", "anim/foot_build.zip"),
--	Asset("ANIM", "anim/foot_basic.zip"),
	Asset("ANIM", "anim/roc_foot_print.zip"),
--	Asset("ANIM", "anim/foot_shadow.zip"),
}
end

local prefabs = 
{
    --"groundpound_fx",
    --"groundpoundring_fx",
}

local function roc_footprint_fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()

	anim:SetBank("foot_print")
	anim:SetBuild("roc_foot_print")
	anim:PlayAnimation("idle")
	anim:SetOrientation( ANIM_ORIENTATION.OnGround )
	anim:SetLayer( LAYER_BACKGROUND )
	anim:SetSortOrder( 4 )
	trans:SetRotation( 0 )

	inst:AddTag("scarytoprey")

	inst:AddComponent("colourtweener")
	--inst.components.colourtweener:StartTween({0,0,0,0}, 15, function(inst) inst:Remove() end)

	inst.persists = false

	inst.components.colourtweener:StartTween({1,1,1,1}, 1, function(inst)  end)
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("bigfootprefade", 30, false)
	inst:ListenForEvent("timerdone", function(inst, data)
					if data.name == "bigfootprefade" then
						inst.components.colourtweener:StartTween({0,0,0,0}, 25, function(inst) inst:Remove() end)
					end
				end)

	return inst
end


return Prefab("common/rocfootprint", roc_footprint_fn, assets, prefabs)