local require = GLOBAL.require
require "stategraphs/SGwik"
require "consolecommands"

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH

GLOBAL.TUNING.AUTOSAVE_INTERVAL = 18000

PrefabFiles = {
	"wik",
	"wikhouse.lua",
    "bucket.lua",
    "wikcage.lua",
    "cageobstacle.lua",
    "wikthought.lua",

--	"deerclops_item",
}

Assets = {
--	Asset("IMAGE", MODROOT.."images/inventoryimages/mybearger.tex"),
--	Asset("ATLAS", MODROOT.."images/inventoryimages/mybearger.xml"),


    Asset( "IMAGE", "images/saveslot_portraits/wik.tex" ),
    Asset( "IMAGE", "images/selectscreen_portraits/wik.tex" ),
    Asset( "IMAGE", "images/selectscreen_portraits/wik_silho.tex" ),
    Asset( "IMAGE", "bigportraits/wik.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wik.xml" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wik.xml" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wik_silho.xml" ),
    Asset( "ATLAS", "bigportraits/wik.xml" ),
    Asset( "ATLAS", "images/inventoryimages/mermhouse.xml" ),
    Asset( "IMAGE", "images/inventoryimages/mermhouse.tex" ),
    Asset( "IMAGE", "images/minimap/wikmini.tex" ),
    Asset( "IMAGE", "images/colour_cubes/lizard_vision_cc.tex" ),
    Asset( "ATLAS", "images/minimap/wikmini.xml" ),
   
    Asset( "SOUND", "sound/wik.fsb" ),
    Asset( "SOUNDPACKAGE", "sound/wik.fev"),

    Asset( "ANIM", "anim/wik.zip" ),
    Asset( "ANIM", "anim/cold.zip" ),        
    Asset( "ANIM", "anim/hot.zip" ),
        
    Asset( "ANIM", "anim/wik_skinny.zip" ),
    Asset( "ANIM", "anim/skinny_col.zip" ),
    Asset( "ANIM", "anim/skinny_hot.zip" ),

    Asset( "ANIM", "anim/wik_mighty.zip" ),
    Asset( "ANIM", "anim/wik_m_cold.zip" ),
    Asset( "ANIM", "anim/wik_m__hot.zip" ),

}


--[[GLOBAL.STRINGS.RECIPE_DESC.DEERCLOPS_ITEM = "A monster's prototype"

local deerclops_item = GLOBAL.Ingredient( "deerclops_item", 1)
  deerclops_item.atlas = "images/inventoryimages/mybearger.xml"
function modGamePostInit()
	local deerclops_item = GLOBAL.Recipe( "deerclops_item", { Ingredient("cutstone", 2) }, RECIPETABS.TOWN, TECH.SCIENCE_ONE)
	deerclops_item.atlas = "images/inventoryimages/mybearger.xml"
	end
AddGamePostInit(modGamePostInit)--]]


SpawnPrefab = GLOBAL.SpawnPrefab


AddSimPostInit(SimInit)


RemapSoundEvent( "dontstarve/characters/wik/hurt", "wik/characters/wik/hurt" )
RemapSoundEvent( "dontstarve/characters/wik/talk_LP", "wik/characters/wik/talk_LP" )
RemapSoundEvent( "dontstarve/characters/wik/death", "wik/characters/wik/death" )
RemapSoundEvent( "dontstarve/characters/wik/increase", "wik/characters/wik/increase" )

-- Set Wik's strings
GLOBAL.STRINGS.CHARACTERS.WIK = GLOBAL.require "wikSpeech"

GLOBAL.STRINGS.CHARACTER_TITLES.wik = "The Lizardman"
GLOBAL.STRINGS.CHARACTER_NAMES.wik = "Wicked"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.wik = "*Must eat meat in moderation.\n*Is a lizard and has lots of Merm cousins.\n*Can't talk smart."
GLOBAL.STRINGS.CHARACTER_QUOTES.wik = "\"Me want more food!\""

-- Register Wik as a player
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wik")
AddModCharacter("wik")
AddMinimapAtlas("images/minimap/wikmini.xml")


local function SetStartingLevel(inst)

    local hunger_percent = inst.components.hunger:GetPercent()
    local health_percent = inst.components.health:GetPercent()

        if inst.level < 45 then 
            inst.components.hunger.max = 75 + (inst.level * 5)
            inst.components.health.maxhealth = 150
            
        elseif inst.level > 45 and inst.level < 90 then 
            inst.components.hunger.max = 300
            inst.components.health.maxhealth = 150 + ((inst.level - 45) * 2)
            
        else 
            inst.components.hunger.max = 300
            inst.components.health.maxhealth = 240

        end

    inst.components.hunger:SetPercent(hunger_percent)
    inst.components.health:SetPercent(health_percent)

end

local function setWikState(inst)


    if not inst.HasSaveData and GetModConfigData("wikPlayIntro") == "Wicked" then
        inst.components.sanity:SetPercent(.2)
        inst.components.hunger:SetPercent(.85)
    end

    if  inst.components.hunger.current > 200 then

        if inst.wikColourSetting == "green" or inst.wikColourSetting == "default" then
            inst.AnimState:SetBuild("wik_mighty")
        elseif inst.wikColourSetting == "red" or inst.CurrentTemp == "Hotter" or inst.CurrentTemp == "Hot" then
            inst.AnimState:SetBuild("wik_m__hot")
        elseif inst.wikColourSetting == "blue" or inst.CurrentTemp == "Colder" or inst.CurrentTemp == "Cold" then
            inst.AnimState:SetBuild("wik_m_cold")
        end

        local wikSize = 1 + (((inst.components.hunger.current - 200) / 100) * .3)
        inst.Transform:SetScale(wikSize, wikSize, wikSize, wikSize)   

    elseif  inst.components.hunger.current < 100 then

        if inst.wikColourSetting == "green" or inst.wikColourSetting == "default" then
            inst.AnimState:SetBuild("wik_skinny")
        elseif inst.wikColourSetting == "red" or inst.CurrentTemp == "Hotter" or inst.CurrentTemp == "Hot" then
            inst.AnimState:SetBuild("skinny_hot")
        elseif inst.wikColourSetting == "blue" or inst.CurrentTemp == "Colder" or inst.CurrentTemp == "Cold" then
            inst.AnimState:SetBuild("skinny_col")
        end

        local wikSize = 0.9 + (inst.components.hunger.current / 1000) 
        inst.Transform:SetScale(wikSize, wikSize, wikSize, wikSize)  

    else

        if inst.wikColourSetting == "green" or inst.wikColourSetting == "default" then
            inst.AnimState:SetBuild("wik")
        elseif inst.wikColourSetting == "red" or inst.CurrentTemp == "Hotter" or inst.CurrentTemp == "Hot" then
            inst.AnimState:SetBuild("hot")
        elseif inst.wikColourSetting == "blue" or inst.CurrentTemp == "Colder" or inst.CurrentTemp == "Cold" then
            inst.AnimState:SetBuild("cold")
        end

    end

    if not inst.HasSaveData and GetModConfigData("wikPlayIntro") == "Wicked" then
        inst:AddTag("PlayingIntro")

        local gamer = GLOBAL.GetPlayer()

        GLOBAL.TheCamera:SetDistance(13)
        GLOBAL.TheCamera:Snap()

        introCage = GLOBAL.SpawnPrefab("wikcage")

        introCage.Transform:SetPosition(gamer:GetPosition().x-1,gamer:GetPosition().y,gamer:GetPosition().z-4)     

        -- Left wheel obstacle
        introCage = GLOBAL.SpawnPrefab("cageobstacle")
        introCage.Transform:SetPosition(gamer:GetPosition().x-1.5,gamer:GetPosition().y,gamer:GetPosition().z-4.5)     

        -- Mid wheel obstacle
        introCage = GLOBAL.SpawnPrefab("cageobstacle")
        introCage.Transform:SetPosition(gamer:GetPosition().x-3,gamer:GetPosition().y,gamer:GetPosition().z-4)     

        -- Right wheel obstacle
        introCage = GLOBAL.SpawnPrefab("cageobstacle")
        introCage.Transform:SetPosition(gamer:GetPosition().x-4,gamer:GetPosition().y,gamer:GetPosition().z-2)     

        -- Sign Left
        introCage = GLOBAL.SpawnPrefab("cageobstacle")
        introCage.Transform:SetPosition(gamer:GetPosition().x+2.5,gamer:GetPosition().y,gamer:GetPosition().z-7.5)     

        -- Sign Right
        introCage = GLOBAL.SpawnPrefab("cageobstacle")
        introCage.Transform:SetPosition(gamer:GetPosition().x,gamer:GetPosition().y,gamer:GetPosition().z-6)     

        introBucket = GLOBAL.SpawnPrefab("bucket")
        introBucket.Transform:SetPosition(gamer:GetPosition().x+5,gamer:GetPosition().y,gamer:GetPosition().z)     

        introSkeleton = GLOBAL.SpawnPrefab("skeleton")
        introSkeleton.Transform:SetPosition(gamer:GetPosition().x+6,gamer:GetPosition().y,gamer:GetPosition().z)   

        introCage = GLOBAL.SpawnPrefab("boards")
        introCage.Transform:SetPosition(gamer:GetPosition().x+3,gamer:GetPosition().y,gamer:GetPosition().z-6)     
        introCage = GLOBAL.SpawnPrefab("boards")
        introCage.Transform:SetPosition(gamer:GetPosition().x-2,gamer:GetPosition().y,gamer:GetPosition().z-3)     
        introCage = GLOBAL.SpawnPrefab("boards")
        introCage.Transform:SetPosition(gamer:GetPosition().x-1,gamer:GetPosition().y,gamer:GetPosition().z+3)     
        introCage = GLOBAL.SpawnPrefab("boards")
        introCage.Transform:SetPosition(gamer:GetPosition().x-5,gamer:GetPosition().y,gamer:GetPosition().z-2)     

        inst.HUD:Hide()

        GLOBAL.GetPlayer().sg:GoToState("sleep")

        inst:PushEvent("wikintro")

    end
        

end

function playerpostinit(inst)    
    
    if GLOBAL.GetPlayer().prefab == "wik" then

        if not inst.HasSaveData then
                inst.level = GetModConfigData("wikStartingLevel")
        end

        inst.WickzillaLevel = GetModConfigData("wikPostLevel")
        inst.WickzillaLoseExp = GetModConfigData("wikLoseExp")
        inst.WickzillaExpMulti = GetModConfigData("wikExpMulti")
        SetStartingLevel(inst)

        inst.wikColourSetting = GetModConfigData("wikColour")

        if not inst:HasTag("beaver") then
            setWikState(inst)
        end 
        
    end

	inst.StompSplash = function(inst) return end --Define this empty so it can be called when waves are off.

	inst.giantWaves = GetModConfigData("giantWaves")

end

AddSimPostInit(playerpostinit)

local function ModMaxwellIntro(inst)

    if GLOBAL.GetPlayer().prefab == "wik" then

        if GetModConfigData("wikPlayIntro") == "Wicked" or GetModConfigData("wikPlayIntro") == "None" then

            inst.components.maxwelltalker.speeches.SANDBOX_1 =
            {
                                   
            }

        end
        
    end
    
end

AddPrefabPostInit("maxwellintro", ModMaxwellIntro)

local function wikmerm(inst)

    require "stategraphs/SGwikmerm"
    
    local function wikShouldSleep(inst)

        -- Removed for follower
        if not inst.components.follower.leader then
            return GLOBAL.GetClock():IsDay()
                   and not (inst.components.combat and inst.components.combat.target)
                   and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
                   and not (inst.components.burnable and inst.components.burnable:IsBurning() )
                   and not (inst.components.freezable and inst.components.freezable:IsFrozen() )
        else
            return false
        end

    end

    local function wikShouldWake(inst)

        -- Removed for follower
        if not inst.components.follower.leader then
            return not GLOBAL.GetClock():IsDay()
                   and not (inst.components.combat and inst.components.combat.target)
                   and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
                   and not (inst.components.burnable and inst.components.burnable:IsBurning() )
                   and not (inst.components.freezable and inst.components.freezable:IsFrozen() )
        else
            return false
        end

    end


    -- Original Retarget
    local function wikRetargetFn(inst)

        local defenseTarget = inst
        local home = inst.components.homeseeker and inst.components.homeseeker.home

            
        if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
            defenseTarget = home
        end

        local dist = TUNING.MERM_TARGET_DIST
        --if GLOBAL.GetSeasonManager() and GLOBAL.GetSeasonManager():IsSpring() then
        --    dist = dist * TUNING.SPRING_COMBAT_MOD
        --end

        local invader = GLOBAL.FindEntity(defenseTarget or inst, dist, function(guy)
            return guy:HasTag("character") and not guy:HasTag("merm") and not guy:HasTag("chester") -- Added chester in the exceptions in case
        end)

        -- Added for follower to add extra targets 
        if inst.components.follower.leader then
            invader = GLOBAL.FindEntity(inst, 18, function(guy)
                return ( guy:HasTag("monster") or guy:HasTag("pig") or guy:HasTag("smallcreature") or guy:HasTag("animal") or guy:HasTag("walrus") ) 
                    and not guy:HasTag("merm") and not guy:HasTag("butterfly") and not guy:HasTag("koalefant") and not guy:HasTag("mole")
                    and not guy:HasTag("penguin") and not guy.prefab == "smallbird" and not guy:HasTag("catcoon") and not guy:HasTag("tentacle") and not guy:HasTag("beefalo") and not guy:HasTag("frog") and not guy:HasTag("ghost")
                    end)
        end

        return invader    

    end


    local function wikKeepTargetFn(inst, target)
        
        -- If follower skip the function to not get confused
        if not inst.components.follower.leader then
        
            local home = inst.components.homeseeker and inst.components.homeseeker.home
            if home then
                return home:GetDistanceSqToInst(target) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
                   and home:GetDistanceSqToInst(inst) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
            end
            return inst.components.combat:CanTarget(target)     
        
        else
        
            return true
        
        end

    end


    local function wikOnAttacked(inst, data)

        -- If follower skip the function to not get confused
        if not inst.components.follower.leader then
            
            local attacker = data and data.attacker
            
            if attacker and inst.components.combat:CanTarget(attacker) then
                inst.components.combat:SetTarget(attacker)
                local targetshares = MAX_TARGET_SHARES
                if inst.components.homeseeker and inst.components.homeseeker.home then
                    local home = inst.components.homeseeker.home
                    if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= SHARE_TARGET_DIST*SHARE_TARGET_DIST then
                        targetshares = targetshares - home.components.childspawner.childreninside
                        home.components.childspawner:ReleaseAllChildren(attacker)
                    end
                    inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
                        return dude.components.homeseeker
                               and dude.components.homeseeker.home
                               and dude.components.homeseeker.home == home
                    end, targetshares)
                end
            end
        end

    end


-- Added for following 

    -- TRADING

    local function ShouldAcceptItem(inst, item)

        if inst.components.sleeper:IsAsleep() then
            inst.components.talker:Say"Argh!"
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/hurt")
            return false

        elseif item:HasTag("meat") or inst.components.eater:CanEat(item) or item:HasTag("pigskin") then
            return true

        end

        if item.components.equippable ~= nil then
            if item.components.equippable and item.components.equippable.equipslot == "head" then
                return true
            end
        end

    end

    local function OnStopFollowing(inst) 
        inst:RemoveTag("companion") 
    end

    local function OnStartFollowing(inst) 
        inst:AddTag("companion") 
    end

    local function OnGetItemFromPlayer(inst, giver, item)

        --I wear hats
        if item.components.equippable ~= nil then

            if item.components.equippable and item.components.equippable.equipslot == "head" then
                local current = inst.components.inventory:GetEquippedItem("head")
                if current then
                    inst.components.inventory:DropItem(current)
                end
                
                inst.components.inventory:Equip(item)
                inst.AnimState:Show("hat")

            end

        elseif item:HasTag("pigskin") then 

            -- This is where they are set up as a follower
            if giver.components.leader then
            inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            inst.components.talker:Say("Let's kill some curly tails!!")
                giver.components.leader:AddFollower(inst)
                local loyaltyTime = TUNING.TOTAL_DAY_TIME * 100
                inst.components.follower:AddLoyaltyTime(loyaltyTime)  
                item:Remove()
            end
            
        elseif item:HasTag("meat") and not item:HasTag("pigskin") then
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/death")
            inst.components.talker:Say"Urgh meat!"
            inst.components.inventory:DropItem(item,false,true)

        elseif not item:HasTag("pigskin") and inst.components.eater:CanEat(item) then

            if inst.components.follower.leader then
                inst.components.talker:Say("Thanks")
            else
                inst.components.talker:Say("Tasty")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/idle")
            end
            item:Remove()

        else
            inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/death")
            inst.components.talker:Say"Don't want that?!"
            inst.components.inventory:DropItem(item,false,true)
            
        end

    end

    local function OnRefuseItem(inst, item)

        if not inst.components.sleeper:IsAsleep() then
            
        end    
        
    end

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then

        local mermbrain = require "brains/wikmermbrain"
        inst:SetBrain(mermbrain)

        inst:SetStateGraph("SGwikmerm") 

        local anim = inst.entity:AddAnimState()
        anim:Hide("hat")
        inst:AddComponent("inventory") 

        inst:AddComponent("follower")
        -- Lazy makes them last for 100 days ... I like lazy
        inst.components.follower.maxfollowtime = TUNING.TOTAL_DAY_TIME * 100

        -- Only for Wicked (Defined in ShouldAcceptItem)
        inst:AddComponent("talker")
        inst.components.talker.colour = GLOBAL.Vector3(119/255, 140/255, 81/255)

        inst.components.talker:StopIgnoringAll()

        -- Allow giving items
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem

        inst:ListenForEvent("stopfollowing", OnStopFollowing)
        inst:ListenForEvent("startfollowing", OnStartFollowing)

        inst.components.sleeper:SetWakeTest(wikShouldWake)
        inst.components.sleeper:SetSleepTest(wikShouldSleep)

        inst.components.combat:SetRetargetFunction(1, wikRetargetFn)
        
        inst.components.combat:SetKeepTargetFunction(wikKeepTargetFn)

        --inst:ListenForEvent("attacked", wikOnAttacked)    

        inst:AddComponent("named")
        inst.components.named.possiblenames = GLOBAL.STRINGS.PIGNAMES
        inst.components.named:PickNewName()

    end

end


local function wikpigskin(inst) inst:AddTag("pigskin") end


local function wikcatcoon(inst)

local function wikRetargetFn(inst)
    return GLOBAL.FindEntity(inst, TUNING.CATCOON_TARGET_DIST,
        function(guy)
            if not guy:HasTag("wik") then
            if guy:HasTag("catcoon") then
                return  not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and inst.components.follower.leader == guy.components.follower.leader) and
                        not (inst.components.follower and guy.components.follower and inst.components.follower.leader == nil and guy.components.follower.leader == nil) and
                        guy.components.health and 
                        not guy.components.health:IsDead() and 
                        inst.components.combat:CanTarget(guy)
            else
                return  ((guy:HasTag("monster") or guy:HasTag("smallcreature")) and 
                        guy.components.health and 
                        not guy.components.health:IsDead() and 
                        inst.components.combat:CanTarget(guy) and 
                        not (inst.components.follower and inst.components.follower.leader ~= nil and guy:HasTag("abigail"))) and
                        not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and inst.components.follower.leader == guy.components.follower.leader) and
                        not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and guy.components.follower.leader and guy.components.follower.leader.components.inventoryitem and guy.components.follower.leader.components.inventoryitem.owner and inst.components.follower.leader == guy.components.follower.leader.components.inventoryitem.owner)
                    or  (guy:HasTag("cattoyairborne") and 
                        not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and inst.components.follower.leader == guy.components.follower.leader) and 
                        not (inst.components.follower and guy.components.follower and inst.components.follower.leader ~= nil and guy.components.follower.leader and guy.components.follower.leader.components.inventoryitem and guy.components.follower.leader.components.inventoryitem.owner and inst.components.follower.leader == guy.components.follower.leader.components.inventoryitem.owner)) 
            end
            end
        end)
end

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then

        inst.components.combat:SetRetargetFunction(3, wikRetargetFn)

    end

end


local function wikspider(inst)

        local function wikNormalRetarget(inst)

            local targetDist = TUNING.SPIDER_TARGET_DIST
            if inst.components.knownlocations:GetLocation("investigate") then
                targetDist = TUNING.SPIDER_INVESTIGATETARGET_DIST
            end
            --if GLOBAL.GetSeasonManager() and GLOBAL.GetSeasonManager():IsSpring() then
            --    targetDist = targetDist * TUNING.SPRING_COMBAT_MOD
            --end
            return GLOBAL.FindEntity(inst, targetDist, 
                function(guy) 
                    if inst.components.combat:CanTarget(guy)
                       and not (inst.components.follower and inst.components.follower.leader == guy)
                       and not (inst.components.follower and inst.components.follower.leader == GLOBAL.GetPlayer() and guy:HasTag("companion")) then
                        return (guy:HasTag("character") and not guy:HasTag("monster") or guy:HasTag("wik"))
                    end
            end)
        end

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then

        inst.components.combat:SetRetargetFunction(1, wikNormalRetarget)

    end

end

local function wikwarriorspider(inst)

        local function wikWarriorRetarget(inst)
            local targetDist = TUNING.SPIDER_WARRIOR_TARGET_DIST
            --if GLOBAL.GetSeasonManager() and GLOBAL.GetSeasonManager():IsSpring() then
            --    targetDist = targetDist * TUNING.SPRING_COMBAT_MOD
            --end
            return GLOBAL.FindEntity(inst, targetDist, function(guy)
                return ((guy:HasTag("character") and not guy:HasTag("monster")) or guy:HasTag("pig") or guy:HasTag("wik"))
                       and inst.components.combat:CanTarget(guy)
                       and not (inst.components.follower and inst.components.follower.leader == guy)
                       and not (inst.components.follower and inst.components.follower.leader == GLOBAL.GetPlayer() and guy:HasTag("companion"))
            end)
        end

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then

        inst.components.combat:SetRetargetFunction(2, wikWarriorRetarget)

    end

end

local function wikmermhouse(inst)

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then
        inst:AddComponent("named")
        inst.components.named:SetName("Merm House")
    end

end

local function wikpigman(inst)

    --print("Character", string.sub(tostring(GLOBAL.GetPlayer()),-3))

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then
        inst.components.named:SetName("Curly Tail")
    end

end

local function wikpighouse(inst)

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then
        inst:AddComponent("named")
        inst.components.named:SetName("Rundown House")
    end

end

local function wikbunny(inst)

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then
        inst.components.named:SetName("Fluffy Tail")
    end

end

local function wikbunnyhouse(inst)

    if string.sub(tostring(GLOBAL.GetPlayer()),-3) == "wik" then
        inst:AddComponent("named")
        inst.components.named:SetName("Rundown Food")
    end

end

-----Begin playable giants section-----
local function wikcarrot(inst)
	local function fnCrushed(inst, chopper)
	--not needed for carrot?	if inst.components.pickable:CanBePicked() then
			inst.components.lootdropper:SpawnLootPrefab("carrot")
	--	end
		inst:Remove()
	end
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	--caused error	    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikflower(inst)
	local function fnCrushed(inst, chopper)
		inst:Remove()
		inst.components.lootdropper:SpawnLootPrefab("petals")
	end
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
	inst.components.workable:SetWorkLeft(1)
end
local function wikflowerevil(inst)
	local function fnCrushed(inst, chopper)
		inst:Remove()
		inst.components.lootdropper:SpawnLootPrefab("petals_evil")
	end
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikflowercave(inst)
	local function fnCrushed(inst, chopper)
		inst:Remove()
		inst.components.lootdropper:SpawnLootPrefab("lightbulb")
	end
	--inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikflowercavedouble(inst)
	local function fnCrushed(inst, chopper)
		inst:Remove()
		inst.components.lootdropper:SpawnLootPrefab("lightbulb")
		inst.components.lootdropper:SpawnLootPrefab("lightbulb")
	end
	--inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikflowercavetriple(inst)
	local function fnCrushed(inst, chopper)
		inst:Remove()
		inst.components.lootdropper:SpawnLootPrefab("lightbulb")
		inst.components.lootdropper:SpawnLootPrefab("lightbulb")
		inst.components.lootdropper:SpawnLootPrefab("lightbulb")
	end
	--inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikgravestone(inst)
	local function fnCrushed(inst, chopper)
		if inst.SoundEmitter == nil then
			inst.entity:AddSoundEmitter()
		end
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
		inst.components.lootdropper:SpawnLootPrefab("cutstone")
	end
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikreeds(inst)
	local function fnCrushed(inst, chopper)
		if inst.components.pickable:CanBePicked() then
			inst.components.lootdropper:SpawnLootPrefab("cutreeds")
		end
		inst.components.lootdropper:SpawnLootPrefab("cutreeds")
		inst:Remove()
	end
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikbirds(inst)
	local brain = require "brains/wikbirdbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGbirdStill")
end
local function wikcactus(inst)
	local function fnCrushed(inst, chopper)
		if inst.components.pickable:CanBePicked() then
			if inst.has_flower then
				inst.components.lootdropper:SpawnLootPrefab("cactus_flower")
			end
			inst.components.lootdropper:SpawnLootPrefab("cactus_meat")
		end
		--inst.components.lootdropper:SpawnLootPrefab("cactus_meat")
		if inst.SoundEmitter == nil then
			inst.entity:AddSoundEmitter()
		end
		inst.SoundEmitter:PlaySound("dontstarve/wilson/hit_animal")
		inst:Remove()
	end
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	--inst:AddTag("squishyworkable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wiktumbleweed(inst)
 local function onpickupUnnecessaryDupe(inst, owner)
	if owner and owner.components.inventory then
		if inst.owner and inst.owner.components.childspawner then 
			inst:PushEvent("pickedup")
		end

		local item = nil
		for i, v in ipairs(inst.loot) do
			item = SpawnPrefab(v)
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            if item.components.inventoryitem and item.components.inventoryitem.ondropfn then
                item.components.inventoryitem.ondropfn(item)
            end
            if inst.lootaggro[i] and item.components.combat and owner then
                if not (owner:HasTag("spiderwhisperer") and item:HasTag("spider")) and not (owner:HasTag("monster") and item:HasTag("spider")) then
                    item.components.combat:SuggestTarget(owner)
                end
            end
    	end
    end
    --inst:RemoveEventCallback("animover", startmoving, inst)
    inst.AnimState:PlayAnimation("break")
    inst.DynamicShadow:Enable(false)
    inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)
    
    return true --This makes the inventoryitem component not actually give the tumbleweed to the player
 end
	local function fnCrushed(inst, chopper)
		if inst.components.pickable:CanBePicked() then
			onpickupUnnecessaryDupe(inst, chopper)
		end
		--print("Tumbleweed: " .. inst.components.workable:GetDebugString())
		inst.components.workable:SetWorkable(false)
		--inst:Remove()
	end
--	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikbigfootprint(inst)
	inst.AnimState:SetSortOrder(4)
	inst.components.colourtweener:StartTween({1,1,1,1}, 1, function(inst)  end)
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("bigfootprefade", 30, false)
	inst:ListenForEvent("timerdone", function(inst, data)
					if data.name == "bigfootprefade" then
						inst.components.colourtweener:StartTween({0,0,0,0}, 25, function(inst) inst:Remove() end)
					end
				end)
end
local function wikgroundpoundring(inst)
	inst.AnimState:SetSortOrder(5)
end
local function wikhounded(inst)
--if data enabled
	inst.attack_levels.intro.numhounds = function() return 3 + math.random(2) end
	inst.attack_levels.light.numhounds = function() return 5 + math.random(3) end
	inst.attack_levels.med.numhounds =   function() return 6 + math.random(3) end
	inst.attack_levels.heavy.numhounds = function() return 7 + math.random(3) end
	inst.attack_levels.crazy.numhounds = function() return 8 + math.random(4) end

	inst.attack_levels.intro.warnduration = function() return 80 end
	inst.attack_levels.light.warnduration = function() return 70 end
	inst.attack_levels.med.warnduration =   function() return 60 end
	inst.attack_levels.heavy.warnduration = function() return 60 end
	inst.attack_levels.crazy.warnduration = function() return 60 end
	--return GetWorld().components.hounded.attack_levels.intro.numhounds()
	--GetWorld().components.hounded:PlanNextHoundAttack()
end
local function wikmoisture(self)
	local easing = require("easing")
	self.GetMoistureRate = function()
		local seasonmgr = GLOBAL.GetSeasonManager()

		if seasonmgr and not seasonmgr:IsRaining() then
			return 0
		end

		local precip = seasonmgr.precip_rate	
		if seasonmgr and seasonmgr:IsSpring() and seasonmgr.incaves then
			precip = precip * TUNING.CAVES_MOISTURE_MULT
		end

		local rate = easing.inSine(precip, self.minMoistureRate, self.maxMoistureRate, 1)

		if self.inst.components.inventory:IsWaterproof() then
			rate = 0
		else
			if self.sheltered then
				rate = rate * (1 - (self.inst.components.inventory:GetWaterproofness() + self.shelter_waterproofness))
			else
				rate = rate * (1 - self.inst.components.inventory:GetWaterproofness())
			end
		end

		if self.inst.components.waterproofer and rate > 0 then
			rate = rate * (1 - self.inst.components.waterproofer:GetEffectiveness())
		end

		return rate
	end
end
local function wikdirtpile(inst)
	local function fnCrushed(inst, doer)
		local pt = GLOBAL.Vector3(inst.Transform:GetWorldPosition())
		--inst.trace("dirtpile - fnCrushed", pt)
		if GLOBAL.GetWorld().components.hunter then
			GLOBAL.GetWorld().components.hunter:OnDirtInvestigated(pt)
		end

		local fx = SpawnPrefab("small_puff")
		local pos = inst:GetPosition()
		fx.Transform:SetPosition(pos.x, pos.y, pos.z)
		--PlayFX(Vector3(inst.Transform:GetWorldPosition()), "small_puff", "smoke_puff_small", "puff", "dontstarve/common/deathpoof", nil, Vector3(216/255, 154/255, 132/255))
		inst:Remove()
	end
	--inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
end
local function wikfireflies(inst)
	local function fnCrushed(inst, chopper)
	 if not GLOBAL.GetPlayer().lizard then
        if worker.components.inventory then
            if inst.components.inventoryitem then inst.components.inventoryitem.canbepickedup = true end
            if inst.components.fader then inst.components.fader:StopAll() end
            inst:AddTag("NOCLICK")
            inst.Light:Enable(false)
            inst.lighton = false
            worker.components.inventory:GiveItem(inst, nil, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
        end
	 else
		--inst.components.lootdropper:SpawnLootPrefab("cactus_meat")
		inst:Remove()
	 end
	end
	--inst:AddComponent("lootdropper")
	--inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    --inst.components.workable:SetWorkLeft(1)
	inst.components.playerprox:SetOnPlayerNear(function() return end)
	inst:AddTag("firefly")
end
local function wikslurtlehole(inst)
	inst:AddTag("slurtlehole")
end
local function wikpillar_cave(inst)
GLOBAL.SetSharedLootTable( 'pillar_cave',
{
    {'rocks',     	1.00},
    {'rocks',     	1.00},
    {'rocks', 		1.00},
    {'rocks',     	1.00},
    {'rocks',     	1.00},
    {'rocks', 		1.00},
    {'rocks',     	1.00},
    {'rocks',     	1.00},
    {'rocks', 		1.00},
    {'rocks', 		0.50},
    {'rocks', 		0.50},
    {'rocks', 		0.50},
    {'rocks', 		0.50},
    {'flint',      	1.00},
    {'flint',      	1.00},
    {'flint',      	1.00},
    {'flint',      	1.00},
    {'flint',      	1.00},
    {'flint',      	1.00},
    {'flint',		0.75},
    {'flint',      	0.60},
    {'bluegem',     0.05},
    {'redgem',     	0.05},
})
	local function fnCrushed(inst, chopper)
		inst.components.lootdropper:DropLoot(Point(inst.Transform:GetWorldPosition()))
		if inst.SoundEmitter == nil then
			inst.entity:AddSoundEmitter()
		end
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('pillar_cave')
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
	--inst:AddTag("wikpillar")
end
local function wikpillar_stalactite(inst)
GLOBAL.SetSharedLootTable( 'pillar_stalactite',
{
    {'rocks',     	1.00},
    {'rocks',     	1.00},
    {'rocks', 		0.50},
    {'rocks', 		0.50},
    {'flint',      	1.00},
    {'flint',		0.75},
    {'flint',      	0.60},
    {'bluegem',     0.05},
    {'redgem',     	0.05},
})
	local function fnCrushed(inst, chopper)
		inst.components.lootdropper:DropLoot(Point(inst.Transform:GetWorldPosition()))
		if inst.SoundEmitter == nil then
			inst.entity:AddSoundEmitter()
		end
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		inst:Remove()
	end
	inst.entity:AddPhysics()
    inst.Physics:SetMass(0) 
    inst.Physics:SetCapsule(1.5,2)
    inst.Physics:ClearCollisionMask()
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('pillar_stalactite')
	inst:AddComponent("workable")
    inst.components.workable:SetOnFinishCallback(fnCrushed)
    inst.components.workable:SetWorkLeft(1)
	--inst:AddTag("wikpillar")
end
local function wikspiderhole(inst)
	inst.fnCrushed = function(inst, chopper)
		inst.components.lootdropper:DropLoot(Point(inst.Transform:GetWorldPosition()))
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		inst:Remove()
	end
	inst:AddTag("spiderhole")
end

AddPrefabPostInit("carrot_planted", wikcarrot)
AddPrefabPostInit("flower", wikflower)
AddPrefabPostInit("flower_evil", wikflowerevil)
AddPrefabPostInit("flower_cave", wikflowercave)
AddPrefabPostInit("flower_cave_double", wikflowercavedouble)
AddPrefabPostInit("flower_cave_triple", wikflowercavetriple)
AddPrefabPostInit("gravestone", wikgravestone)
AddPrefabPostInit("reeds", wikreeds)
AddPrefabPostInit("crow", wikbirds)
AddPrefabPostInit("robin", wikbirds)
AddPrefabPostInit("robin_winter", wikbirds)
AddComponentPostInit("hounded", wikhounded)
AddPrefabPostInit("dirtpile", wikdirtpile)
AddPrefabPostInit("fireflies", wikfireflies)
AddPrefabPostInit("slurtlehole", wikslurtlehole)
AddPrefabPostInit("pillar_cave", wikpillar_cave)
AddPrefabPostInit("pillar_algae", wikpillar_cave)
AddPrefabPostInit("pillar_stalactite", wikpillar_stalactite)
--AddPrefabPostInit("pillar_ruins", wikpillar_cave)
AddPrefabPostInit("spiderhole", wikspiderhole)
if GLOBAL.softresolvefilepath("anim/foot_build.zip") then
 AddPrefabPostInit("cactus", wikcactus)
 AddPrefabPostInit("tumbleweed", wiktumbleweed)
 AddPrefabPostInit("bigfootprint", wikbigfootprint)
 AddPrefabPostInit("groundpoundring_fx", wikgroundpoundring)
 AddComponentPostInit("moisture", wikmoisture)
else
 print("Skipped RoG prefabs.")
end
if GLOBAL.softresolvefilepath("anim/parrot_pirate.zip") then
 AddPrefabPostInit("parrot", wikbirds)
 AddPrefabPostInit("parrot_pirate", wikbirds)
 AddPrefabPostInit("toucan", wikbirds)
 AddPrefabPostInit("seagull", wikbirds)
 AddPrefabPostInit("seagull_water", wikbirds)
else
 print("Skipped SW prefabs.")
end
if GLOBAL.softresolvefilepath("anim/pigeon_build.zip") then
 AddPrefabPostInit("pigeon", wikbirds)
 AddPrefabPostInit("parrot_blue", wikbirds)
 AddPrefabPostInit("kingfisher", wikbirds)
else
 print("Skipped HL prefabs.")
end

--[[   	   makebird("robin", "robin"),
	   makebird("robin_winter", "junco"),
	   makebirdex("parrot", "robin", "dontstarve_DLC002/creatures/parrot/takeoff", "dontstarve_DLC002/creatures/parrot/chirp"),
	   makebirdex("parrot_pirate", "robin", "dontstarve_DLC002/creatures/parrot/takeoff", "dontstarve_DLC002/creatures/parrot/chirp"),
	   makebirdex("toucan", "crow", "dontstarve_DLC002/creatures/toucan/takeoff", "dontstarve_DLC002/creatures/toucan/chirp"),
	   makebirdex("seagull","robin_winter", "dontstarve_DLC002/creatures/seagull/takeoff_seagull", "dontstarve_DLC002/creatures/seagull/chirp_seagull"),
	   makebirdex("seagull_water", "robin_winter", "dontstarve_DLC002/creatures/seagull/takeoff_seagull", "dontstarve_DLC002/creatures/seagull/chirp_seagull","dontstarve_DLC002/creatures/seagull/landwater"),
	   makebirdex("pigeon", "robin_winter", "dontstarve_DLC003/creatures/pigeon/takeoff", "dontstarve_DLC003/creatures/pigeon/chirp"),
	   makebirdex("parrot_blue", "robin_winter", "dontstarve_DLC002/creatures/parrot/takeoff", "dontstarve_DLC002/creatures/parrot/chirp"),
	   makebirdex("kingfisher", "robin_winter", "dontstarve/birds/takeoff_faster", "dontstarve_DLC003/creatures/king_fisher/chirp",nil,"dontstarve_DLC003/creatures/king_fisher/take_off")	   --]]

--if setting
AddPrefabPostInit("merm", wikmerm)
AddPrefabPostInit("mermhouse", wikmermhouse)
AddPrefabPostInit("pigman", wikpigman)
AddPrefabPostInit("pighouse", wikpighouse)
AddPrefabPostInit("bunnyman", wikbunny)
AddPrefabPostInit("rabbithouse", wikbunnyhouse)
AddPrefabPostInit("pigskin", wikpigskin)
AddPrefabPostInit("catcoon", wikcatcoon)
AddPrefabPostInit("spider", wikspider)
AddPrefabPostInit("spider_warrior", wikwarriorspider)