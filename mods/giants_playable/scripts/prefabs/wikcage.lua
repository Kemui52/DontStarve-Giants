local assets=
{
	Asset("ANIM", "anim/wikCage.zip"),
}


local prefabs =
{
    "wikcage",
}    


local function fn(sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("wikCage")
    inst.AnimState:SetBuild("wikCage")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddTag("wikCage")
    
    --MakeObstaclePhysics(inst, 1)
    inst:AddComponent("inspectable")
    
    return inst

end

STRINGS.NAMES.WIKCAGE = "Cage"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.WIKCAGE = 
{  
    "I make curly tails pay!!",
}

return Prefab( "wikcage", fn, assets, prefabs) 
