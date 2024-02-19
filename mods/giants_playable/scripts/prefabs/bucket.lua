local assets=
{
	Asset("ANIM", "anim/bucket.zip"),
}


local prefabs =
{
    "bucket",
}    


local function fn()

	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("bucket")
    inst.AnimState:SetBuild("bucket")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddTag("bucket")
    
    MakeObstaclePhysics(inst, 0.25)
    inst:AddComponent("inspectable")
    
    inst.Transform:SetScale(.8, .8, .8, .8)

    return inst

end

STRINGS.NAMES.BUCKET = "Bucket"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUCKET = 
{  
    "It's broken.",
}

return Prefab( "bucket", fn, assets, prefabs) 
