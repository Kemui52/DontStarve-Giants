local assets=
{
	Asset("ANIM", "anim/wikthought.zip"),
}


local prefabs =
{
    "wikthought",
}    


local function fn(sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("wikthought")
    inst.AnimState:SetBuild("wikthought")
    inst.AnimState:PlayAnimation("meat",true)
  
    return inst

end

return Prefab( "wikthought", fn, assets, prefabs) 