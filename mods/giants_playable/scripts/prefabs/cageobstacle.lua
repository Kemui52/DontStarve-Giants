local assets=
{
	Asset("ANIM", "anim/cageobstacle.zip"),
}


local prefabs =
{
    "wikcage",
}    


local function fn(sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("cageobstacle")
    inst.AnimState:SetBuild("cageobstacle")
    inst.AnimState:PlayAnimation("anim")
    
    MakeObstaclePhysics(inst, 1.1)

    return inst

end

return Prefab( "cageobstacle", fn, assets, prefabs) 