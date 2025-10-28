require "stategraphs/SGwik"
require "stategraphs/SGwerelizard"

local function localPlaySound(v, sound, skipcheck)
	if not skipcheck and not v.SoundEmitter then
		v.entity:AddSoundEmitter()
	end
	v.SoundEmitter:PlaySound(sound)
end

function GlobalDestroyings(inst, pt, ents, heading_angle)
    for k,v in pairs(ents) do
       if v then
		if v.components.workable and (v.components.workable.action ~= ACTIONS.NET or (v:HasTag("firefly") and not v:HasTag("NOCLICK"))) and v.components.workable:CanBeWorked() then
--[[			if v:HasTag("squishyworkable") then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/hit_animal")
				SpawnPrefab("collapse_small").Transform:SetPosition(v:GetPosition():Get())
			else--]]
			if v:HasTag("firefly") then
				localPlaySound(v, "dontstarve/wilson/hit_animal")
			elseif v:HasTag("spiderhole") then
				--v.components.workable:SetWorkLeft(1)
				--GoToBrokenState(v)
				--workcallback(v, inst, 0)
				v.components.workable:SetOnFinishCallback(v.fnCrushed)
				SpawnPrefab("collapse_small").Transform:SetPosition(v:GetPosition():Get())
			else
				SpawnPrefab("collapse_small").Transform:SetPosition(v:GetPosition():Get())
			end
            v.components.workable:Destroy(inst)
        elseif (inst.components.combat:CanTarget(v) or v:HasTag("mole")) and v.components.health:GetPercent() > 0 then
			if v.components.combat and v.components.combat.onhitfn then
				v.components.combat.onhitfn(v, inst, 1000)
			end
			v.components.health:Kill() --SetPercent(0)
			if v:HasTag("chess") then
				localPlaySound(v, "dontstarve/common/destroy_metal")
			elseif v:HasTag("ghost") or v:HasTag("shadowcreature") then
				localPlaySound(v, "dontstarve/ghost/ghost_haunt")
			elseif v:HasTag("houndmound") or v:HasTag("slurtlehole") then
				localPlaySound(v, "dontstarve/common/destroy_stone")
			elseif v:HasTag("tree") then
				localPlaySound(v, "dontstarve/wilson/use_axe_tree")
				localPlaySound(v, "dontstarve/forest/treefall",true)
			elseif v:HasTag("rocky") then
				localPlaySound(v, "dontstarve/common/destroy_stone")
			elseif v:HasTag("butterfly") then
				localPlaySound(v, "dontstarve/wilson/hit_animal")
				v.components.lootdropper:DropLoot(Point(v.Transform:GetWorldPosition()))
				v:Remove(inst)
			else
				localPlaySound(v, "dontstarve/wilson/hit_animal")
			end
        end
	   end
    end
end

local Badge = require "widgets/badge"
local easing = require "easing"
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {

    Asset( "ANIM", "anim/player_basic.zip" ),
    Asset( "ANIM", "anim/player_idles_shiver.zip" ),
    Asset( "ANIM", "anim/player_actions.zip" ),
    Asset( "ANIM", "anim/player_actions_axe.zip" ),
    Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
    Asset( "ANIM", "anim/player_actions_shovel.zip" ),
    Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
    Asset( "ANIM", "anim/player_actions_eat.zip" ),
    Asset( "ANIM", "anim/player_actions_item.zip" ),
    Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
    Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
    Asset( "ANIM", "anim/player_actions_fishing.zip" ),
    Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
    Asset( "ANIM", "anim/player_bush_hat.zip" ),
    Asset( "ANIM", "anim/player_attacks.zip" ),
    Asset( "ANIM", "anim/player_idles.zip" ),
    Asset( "ANIM", "anim/player_rebirth.zip" ),
    Asset( "ANIM", "anim/player_jump.zip" ),
    Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
    Asset( "ANIM", "anim/player_teleport.zip" ),
    Asset( "ANIM", "anim/wilson_fx.zip" ),
    Asset( "ANIM", "anim/player_one_man_band.zip" ),
    Asset( "ANIM", "anim/shadow_hands.zip" ),
	Asset( "ANIM", "anim/beard.zip" ),

    Asset( "SOUND", "sound/sfx.fsb" ),	

    Asset( "SOUND", "sound/wik.fsb" ),
    Asset( "SOUNDPACKAGE", "sound/wik.fev"),
	--Asset( "SOUND", "sound/webber.fsb" ),        
	--Asset( "SOUND", "sound/wilson.fsb" ),              

	-- Don't forget to include your character's custom assets!

    Asset( "ANIM", "anim/wik.zip" ),
    Asset( "ANIM", "anim/cold.zip" ),        
    Asset( "ANIM", "anim/hot.zip" ),
        
   	Asset( "ANIM", "anim/wik_skinny.zip" ),
   	Asset( "ANIM", "anim/skinny_col.zip" ),
   	Asset( "ANIM", "anim/skinny_hot.zip" ),

   	Asset( "ANIM", "anim/wik_mighty.zip" ),
   	Asset( "ANIM", "anim/wik_m_cold.zip" ),
   	Asset( "ANIM", "anim/wik_m__hot.zip" ),

	Asset( "ANIM", "anim/player_woodie.zip"),
	Asset( "ANIM", "anim/woodie.zip"),
	Asset( "ANIM", "anim/player_wolfgang.zip"),

	Asset( "ANIM", "anim/pig_house.zip"),

    Asset( "ANIM", "anim/lizard_meter.zip"),
    Asset( "ANIM", "anim/werelizard_build.zip"),
--[[    Asset( "ANIM", "anim/deerclops_build.zip"),
    Asset( "ANIM", "anim/deerclops_eyeball.zip"),
    Asset( "ANIM", "anim/deerclops_basic.zip"),
    Asset( "ANIM", "anim/deerclops_actions.zip"),
    Asset( "ANIM", "anim/bearger_basic.zip"),
    Asset( "ANIM", "anim/bearger_build.zip"),
    Asset( "ANIM", "anim/bearger_actions.zip"),
    Asset( "ANIM", "anim/bearger_ground_fx.zip"),
    Asset( "ANIM", "anim/bearger_ring_fx.zip"),
	Asset("ANIM", "anim/goosemoose_build.zip"),
    Asset("ANIM", "anim/goosemoose_basic.zip"),
    Asset("ANIM", "anim/goosemoose_actions.zip"),--]]

	Asset( "IMAGE", "images/colour_cubes/lizard_vision_cc.tex" ),
	Asset( "IMAGE", "images/colour_cubes/lizard_vision_1_cc.tex" ),
	Asset( "IMAGE", "images/colour_cubes/lizard_vision_2_cc.tex" ),
	Asset( "IMAGE", "images/colour_cubes/lizard_vision_3_cc.tex" ),
	Asset( "IMAGE", "images/colour_cubes/lizard_vision_4_cc.tex" ),
	Asset( "IMAGE", "images/colour_cubes/lizard_vision_5_cc.tex" ),
	Asset( "IMAGE", "images/colour_cubes/lizard_vision_6_cc.tex" ),

	Asset( "ATLAS", "images/woodie.xml"),
	Asset( "IMAGE", "images/woodie.tex"),

}

local prefabs = {}

local function levelUp(inst)

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

    if inst.level > 5 and not inst:HasTag("beaver") then 
    	inst.components.eater:SetOmnivore()
    	STRINGS.CHARACTERS.WIK = require "wikSpeech"
    else
    	inst.components.eater:SetVegetarian()
    	STRINGS.CHARACTERS.WIK = require "wikSpeechVeggie"
    end

    print ('LevelUp Called')

end


local function ontemperaturechange(inst, data)

	--print ('Checking Temp')

	if inst:HasTag("beaver") or inst:HasTag("PlayingIntro") then
		return
	end

	local HungryLevel = 100
	local FullupLevel = 200

	local CurrentSpeed = 1

	local HungrySpeed = 0.1
	local FullupSpeed = 0.1

	local ColdSpeed = 0.6

	local HotterSpeed = 1.1
	local HotSpeed = 1.4

	local CurrentInsulation = 1

	local HungryInsulation = 0.2
	local FullupInsulation = 0.1

	local ColdInsulation = 0.6

	local CurrentAttack = 1

	local HungryAttack = 0.2
	local FullupAttack = 0.5

	local ColdAttack = 0.9
	local HotAttack = 0.8

	local TemperatureCold = 10 -- When Insulation and slow down happens

	-- !!Need updating in the mod main too!!
	local TemperatureColder = 20 -- When Colour changes
	local TemperatureHotter = 64 -- 
	-- !!Just those 2!!

	local TemperatureHot = 85

	local HotTemperaturePain = 1.3
	local ColdTemperaturePain = 1

	local MarshAttack = 0.2
	local MarshSpeed = 0.2
	local NonMarshAttack = 0
	local NonMarshSpeed = 0

	local skipHungerSaying = false
	
	inst.wikCurrentHunger = inst.components.hunger.current 

	-- HOT TEMPERATURE --
	
	if inst.components.temperature.current > TemperatureHot then

		-- Once temperature drops for the first time do saying --
		if inst.CurrentTemp == "Hotter" then
			inst.CurrentTemp = "Hot"
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOT_INITIAL"))
			skipHungerSaying = true
			inst.CurrentHunger = ""

		else
			inst.CurrentTemp = "Hot"
			
		end

		-- General Hot Stats --
		inst.components.temperature.hurtrate = HotTemperaturePain
		CurrentSpeed = HotSpeed

		if inst.components.hunger.current < HungryLevel then
			
			if inst.CurrentHunger ~= "Hungry" then
				inst.CurrentHunger = "Hungry"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("skinny_hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_skinny")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("skinny_col")
				end	
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOT_HUNGRY"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				end
			end

			-- Hot Hungry Stats --	
			CurrentSpeed = CurrentSpeed - HungrySpeed
			CurrentAttack = CurrentAttack - HungryAttack

		elseif inst.components.hunger.current > FullupLevel then

			if inst.CurrentHunger ~= "Full" then
				inst.CurrentHunger = "Full"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("wik_m__hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_mighty")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("wik_m_cold")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOT_FULL"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
					inst.sg:PushEvent("powerup")
				end
			end

			-- Hot Full Stats --	
			CurrentSpeed = CurrentSpeed + FullupSpeed
			CurrentAttack = CurrentAttack + FullupAttack

		else
			if inst.CurrentHunger ~= "Normal" then
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOT_NORMAL"))
				end
				if inst.CurrentHunger == "Full" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				elseif inst.CurrentHunger == "Hungry" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
				end
				inst.CurrentHunger = "Normal"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("cold")
				end

			else
				inst.CurrentHunger = "Normal"

			end			
	
		end

	-- HOTTER TEMPERATURE --

	elseif inst.components.temperature.current > TemperatureHotter then

		-- Once temperature drops for the first time do saying --
		if inst.CurrentTemp == "Normal" then
			inst.CurrentTemp = "Hotter"
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOTTER_INITIAL"))
			skipHungerSaying = true
			inst.CurrentHunger = ""

		else
			inst.CurrentTemp = "Hotter"
			
		end

		-- General Hot Stats --
		CurrentSpeed = HotterSpeed

		if inst.components.hunger.current < HungryLevel then
			
			if inst.CurrentHunger ~= "Hungry" then
				inst.CurrentHunger = "Hungry"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("skinny_hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_skinny")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("skinny_col")
				end				
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOTTER_HUNGRY"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				end
			end

			-- Hotter Hungry Stats --	
			CurrentSpeed = CurrentSpeed - HungrySpeed
			CurrentAttack = CurrentAttack - HungryAttack

		elseif inst.components.hunger.current > FullupLevel then

			if inst.CurrentHunger ~= "Full" then
				inst.CurrentHunger = "Full"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("wik_m__hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_mighty")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("wik_m_cold")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOTTER_FULL"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
					inst.sg:PushEvent("powerup")
				end

			end

			-- Hotter Full Stats --	
			CurrentSpeed = CurrentSpeed + FullupSpeed
			CurrentAttack = CurrentAttack + FullupAttack

		else
			if inst.CurrentHunger ~= "Normal" then
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_HOTTER_NORMAL"))
				end
				if inst.CurrentHunger == "Full" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				elseif inst.CurrentHunger == "Hungry" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
				end
				inst.CurrentHunger = "Normal"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("cold")
				end
				
			else
				inst.CurrentHunger = "Normal"
			
			end			
	
		end

	
	-- NORMAL TEMPERATURE --

	elseif inst.components.temperature.current > TemperatureColder and inst.components.temperature.current < TemperatureHotter then

		-- Once temperature drops for the first time do saying --
		if inst.CurrentTemp == "Colder" or inst.CurrentTemp == "Hotter" then
			inst.CurrentTemp = "Normal"
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_NORMAL_TEMP"))
			skipHungerSaying = true
			inst.CurrentHunger = ""

		else
			inst.CurrentTemp = "Normal"
			
		end

		if inst.components.hunger.current < HungryLevel then
			
			if inst.CurrentHunger ~= "Hungry" then
				inst.CurrentHunger = "Hungry"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_skinny")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("skinny_hot")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("skinny_col")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_STOMACH_HUNGRY"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				end
			end

			-- Normal Hungry Stats --	
			CurrentSpeed = CurrentSpeed - HungrySpeed
			CurrentAttack = CurrentAttack - HungryAttack

		elseif inst.components.hunger.current > FullupLevel then

			if inst.CurrentHunger ~= "Full" then
				inst.CurrentHunger = "Full"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_mighty")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("wik_m__hot")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("wik_m_cold")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_STOMACH_FULL"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
					inst.sg:PushEvent("powerup")
				end

			end

			-- Normal Full Stats --	
			CurrentSpeed = CurrentSpeed + FullupSpeed
			CurrentAttack = CurrentAttack + FullupAttack

		else
			if inst.CurrentHunger ~= "Normal" then
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_STOMACH_NORMAL"))
				end
				if inst.CurrentHunger == "Full" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				elseif inst.CurrentHunger == "Hungry" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
				end
				inst.CurrentHunger = "Normal"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("hot")
				elseif inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("cold")
				end
				
			else
				inst.CurrentHunger = "Normal"

			end

		end
	
	-- COLDER TEMPERATURE --

	elseif inst.components.temperature.current > TemperatureCold then
	
		-- Once temperature drops for the first time do saying --
		if inst.CurrentTemp ~= "Colder" then
			inst.CurrentTemp = "Colder"
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLDER_INITIAL"))
			skipHungerSaying = true
			inst.CurrentHunger = ""
		else
			inst.CurrentTemp = "Colder"

		end

		if inst.components.hunger.current < HungryLevel then

			if inst.CurrentHunger ~= "Hungry" then
				inst.CurrentHunger = "Hungry"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("skinny_col")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("skinny_hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_skinny")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLDER_HUNGRY"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				end
			end

		elseif inst.components.hunger.current > FullupLevel then

			if inst.CurrentHunger ~= "Full" then
				inst.CurrentHunger = "Full"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("wik_m_cold")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("wik_m__hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_mighty")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLDER_FULL"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
					inst.sg:PushEvent("powerup")
				end

			end

		else
			if inst.CurrentHunger ~= "Normal" then
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLDER_NORMAL"))
				end
				if inst.CurrentHunger == "Full" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				elseif inst.CurrentHunger == "Hungry" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
				end
				inst.CurrentHunger = "Normal"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("cold")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik")
				end
				
			else
				inst.CurrentHunger = "Normal"

			end

		end
	
	-- COLD TEMPERATURE --

	else

		-- Once temperature drops for the first time do saying --
		if inst.CurrentTemp ~= "Cold" then
			inst.CurrentTemp = "Cold"
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLD_INITIAL"))
			skipHungerSaying = true
			inst.CurrentHunger = ""
		end

		-- General Cold Stats --
	    inst.components.temperature.hurtrate = ColdTemperaturePain
		CurrentSpeed = ColdSpeed
		CurrentInsulation = ColdInsulation
		CurrentAttack = ColdAttack

		if inst.components.hunger.current < HungryLevel then
			
			if inst.CurrentHunger ~= "Hungry" then
				inst.CurrentHunger = "Hungry"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("skinny_col")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("skinny_hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_skinny")
				end

				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLD_HUNGRY"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				end	
			end

			-- Cold Hungry Stats --	
			CurrentSpeed = CurrentSpeed - HungrySpeed
			CurrentInsulation = CurrentInsulation - HungryInsulation
			CurrentAttack = CurrentAttack - HungryAttack

		elseif inst.components.hunger.current > FullupLevel then

			if inst.CurrentHunger ~= "Full" then
				inst.CurrentHunger = "Full"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("wik_m_cold")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("wik_m__hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik_mighty")
				end
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLD_FULL"))
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
					inst.sg:PushEvent("powerup")
				end

			end

			-- Cold Full Stats --	
			CurrentSpeed = CurrentSpeed + FullupSpeed
			CurrentInsulation = CurrentInsulation + FullupInsulation
			CurrentAttack = CurrentAttack + FullupAttack

		else
			if inst.CurrentHunger ~= "Normal" then
				if skipHungerSaying == false then
					inst.components.talker:Say(GetString("wik", "ANNOUNCE_COLD_NORMAL"))
				end
				if inst.CurrentHunger == "Full" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/decrease", "decrease")
					inst.sg:PushEvent("powerdown")
				elseif inst.CurrentHunger == "Hungry" then
					inst.SoundEmitter:PlaySound("wik/characters/wik/increase", "increase")
				end
				inst.CurrentHunger = "Normal"
				if inst.wikColourSetting == "default" or inst.wikColourSetting == "blue" then
					inst.AnimState:SetBuild("cold")
				elseif inst.wikColourSetting == "red" then
					inst.AnimState:SetBuild("hot")
				elseif inst.wikColourSetting == "green" then
					inst.AnimState:SetBuild("wik")
				end
				
			else
				inst.CurrentHunger = "Normal"

			end

		end

		print ("Wik Colour - ",inst.wikColourSetting)

	end
	

	-- SWAMP FLOORING --

	if getIsMarsh(inst) == GROUND.MARSH then

		if inst.CurrentTile == "Normal" then
			if math.random(3) > 2.5 then
				inst.CurrentTile = "Swamp"
				inst.components.talker:Say(GetString("wik", "ANNOUNCE_MARSH_AREA"))
			end
		end
		
		-- Marsh Stats --
		CurrentAttack = CurrentAttack + MarshAttack
		CurrentSpeed = CurrentSpeed + MarshSpeed

	else
		inst.CurrentTile = "Normal"

		-- Non Marsh Stats --
		CurrentAttack = CurrentAttack + NonMarshAttack
		CurrentSpeed = CurrentSpeed + NonMarshSpeed				

	end

	-- FINAL STATS --

	inst.components.locomotor.walkspeed = ((TUNING.WILSON_WALK_SPEED * CurrentSpeed))
	inst.components.locomotor.runspeed = ((TUNING.WILSON_RUN_SPEED * CurrentSpeed))
		
	inst.components.temperature.inherentinsulation = ((TUNING.INSULATION_PER_BEARD_BIT * CurrentInsulation))
	inst.components.combat.damagemultiplier = (1 * CurrentAttack)

	if inst.CurrentHunger == 'Full' then
		local wikSize = 1 + (((inst.components.hunger.current - 200) / 100) * .3)
		inst.Transform:SetScale(wikSize, wikSize, wikSize, wikSize)				
	elseif inst.CurrentHunger == 'Hungry' then
		local wikSize = 0.9 + (inst.components.hunger.current / 1000) 
		inst.Transform:SetScale(wikSize, wikSize, wikSize, wikSize)				
	else
		inst.Transform:SetScale(1, 1, 1, 1) --I had this commented out earlier... Why?
	end

end


function getIsMarsh(inst)


	local x,y,z = inst.Transform:GetWorldPosition()
	local Flooring = GetWorld()
	if Flooring then
		local CurrentFlooring = Flooring.Map:GetTileAtPoint(x,y,z)
		return CurrentFlooring
	end


end




-- WERELIZARD FUNCTIONS --


local function lizardactionstring(inst, action) --having this here should be fine


    return "Chomp"


end

--space
local function LizardActionButton(inst)

	local action_target = FindEntity(inst, 6, function(guy) return (guy.components.edible and inst.components.eater:CanEat(guy)) or
		 													 (guy.components.workable and inst.components.worker:CanDoAction(guy.components.workable.action)) end)

	if not inst.sg:HasStateTag("busy") and action_target then
		if (action_target.components.edible and inst.components.eater:CanEat(action_target)) then
			return BufferedAction(inst, action_target, ACTIONS.EAT)
		else
			return BufferedAction(inst, action_target, action_target.components.workable.action)
		end
	end

end



													 

local function LizardLeftClickPicker(inst, target_ent, pos)
    if inst.components.combat:CanTarget(target_ent) then
        return inst.components.playeractionpicker:SortActionList({ACTIONS.ATTACK}, target_ent, nil)
    end

    if target_ent and target_ent.components.edible and inst.components.eater:CanEat(target_ent) then
        return inst.components.playeractionpicker:SortActionList({ACTIONS.EAT}, target_ent, nil)
    end

    if target_ent and target_ent.components.workable and inst.components.worker:CanDoAction(target_ent.components.workable.action) then
        return inst.components.playeractionpicker:SortActionList({target_ent.components.workable.action}, target_ent, nil)
    end
end


local function dcattackactionstring(inst, action)

    return "Attack"
	--return "Chomp"
end

local function DeerclopsActionButton(inst)
	local action_target = FindEntity(inst, 6, function(guy) return (guy.components.workable and inst.components.worker:CanDoAction(guy.components.workable.action)) end)
	if not inst.sg:HasStateTag("busy") and action_target then
			return BufferedAction(inst, action_target, action_target.components.workable.action)
	end
end

local function LeftClickPicker(inst, target_ent, pos)
    if inst.components.combat:CanTarget(target_ent) then
        return inst.components.playeractionpicker:SortActionList({ACTIONS.ATTACK}, target_ent, nil)
    end

    if target_ent and target_ent.components.workable and inst.components.worker:CanDoAction(target_ent.components.workable.action) then
        return inst.components.playeractionpicker:SortActionList({target_ent.components.workable.action}, target_ent, nil)
    end
end

local function RightClickPicker(inst, target_ent, pos)
    return {}
end


------------------
-- CHANGE BADGE --
------------------

local LizardBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "lizard_meter", owner)
end)


--------------------
-- CHANGE TO MEAT --
--------------------

local function onlizardeat(inst, data)


    if data.food and data.food.components.edible.ismeat and inst.components.lizardness:IsLizard() then
        if data.food.components.edible.hungervalue == TUNING.CALORIES_TINY then
            inst.components.lizardness:DoDelta(1)
        elseif data.food.components.edible.hungervalue == TUNING.CALORIES_SMALL then
            inst.components.lizardness:DoDelta(3)
        elseif data.food.components.edible.hungervalue == TUNING.CALORIES_MEDSMALL then
            inst.components.lizardness:DoDelta(6)
        elseif data.food.components.edible.hungervalue == TUNING.CALORIES_MED then
            inst.components.lizardness:DoDelta(10)
		else
            inst.components.lizardness:DoDelta(15)
		end
    end


end

-- =============================
-- Lizardness 0.185 = 150 Hunger
-- =============================
-- 150 / 34 = 4.411
-- 0.226 * 4.411 = 0.996

-- ==============
-- Lizardness 0.1
-- ==============
-- @4 mins = Lizardness (0.461) Hunger (122)
-- @8 mins = Lizardness (0.339) Hunger (88)
-- ============================================
-- In 4 mins = Lizardness (-0.122) Hunger (-34)
-- 150 / 34 = 4.411
-- 0.122 * 4.411 = 0.538

-- ===============
-- Lizardness 0.05
-- ===============
-- @4 mins = Lizardness (0.444) Hunger (118)
-- @8 mins = Lizardness (0.384) Hunger (84)
-- ============================================
-- In 4 mins = Lizardness (-0.060) Hunger (-34)
-- 150 / 34 = 4.411
-- 0.060 * 4.411 = 0.264


local function onwikeat(inst, food)

	if inst:HasTag("beaver") then 
		return
	end

	-- 1 Delta is 1%

	local AlreadyFull = 1 
    local EatenMeat = false
    local Recovered = 0

    print ('HungerPercent',(inst.wikCurrentHunger / inst.components.hunger.max) * 100)

	if (inst.wikCurrentHunger / inst.components.hunger.max) * 100  > 95 then
		AlreadyFull = 0
	elseif inst.WickzillaExpMulti > 1 then
		AlreadyFull = inst.WickzillaExpMulti
    end

    if inst.level < 5 and food.name ~= 'Petals' then
     	inst.exp = inst.exp + (5 * AlreadyFull)
    end

	-- Lizardness 70
    if food.name == 'Meaty Stew' then
	    inst.exp = inst.exp + (40 * AlreadyFull)	
		inst.components.lizardness:DoDelta(70)
		EatenMeat = true

	-- Lizardness 40
    elseif food.name == 'Meat' then
	    inst.exp = inst.exp + (5 * AlreadyFull)	
		inst.components.lizardness:DoDelta(40)
		EatenMeat = true

	-- Lizardness 35
    elseif food.name == 'Monster Meat' or food.name == 'Bacon and Eggs' or food.name == 'Honey Ham' or food.name == 'Turkey Dinner' or food.name == 'Monster Lasagna' then
    	if food.name == 'Monster Meat' then
		    inst.exp = inst.exp + (3 * AlreadyFull)	
		else					
		    inst.exp = inst.exp + (25 * AlreadyFull)	
		end
		inst.components.lizardness:DoDelta(35)
		EatenMeat = true
		
	-- Lizardness 30
    elseif food.name == 'Pierogi' or food.name == 'Meatballs' or food.name == 'Morsel' or food.name == 'Eel' or food.name == 'Frog Legs' or food.name == 'Batilisk Wing' then
		if food.name == 'Pierogi' or food.name == 'Meatballs' then
			inst.exp = inst.exp + (15 * AlreadyFull)
		elseif food.name == 'Meatballs' then 
			inst.exp = inst.exp + (7 * AlreadyFull)
		elseif food.name == 'Drumstick' or food.name ==  'Fish' then
			inst.exp = inst.exp + (4 * AlreadyFull)
		else
			inst.exp = inst.exp + (3 * AlreadyFull)
		end	
		inst.components.lizardness:DoDelta(30)
		EatenMeat = true

    -- Lizardness 20
    elseif food.name == 'Fish Tacos' or food.name == 'Fishsticks' or food.name == 'Froggle Bunwich' or food.name == 'Honey Nuggets' or food.name == 'Kabobs' then
		inst.exp = inst.exp + (6 * AlreadyFull)
		inst.components.lizardness:DoDelta(20)
		EatenMeat = true

    -- Lizardness 12
    elseif food.name == 'Jerky' then
	    inst.exp = inst.exp + (6 * AlreadyFull)
		inst.components.lizardness:DoDelta(12)
		EatenMeat = true

    -- Lizardness 10
    elseif food.name == 'Cooked Meat' or food.name == 'Unagi' then
		if food.name == 'Cooked Meat' then
			inst.exp = inst.exp + (7 * AlreadyFull)
		else
			inst.exp = inst.exp + (10 * AlreadyFull)
		end
		inst.components.lizardness:DoDelta(10)
		EatenMeat = true

	-- Lizardness 8
    elseif food.name == 'Monster Jerky' or food.name == 'Cooked Monster Meat' or food.name == 'Small Jerky' then
		inst.exp = inst.exp + (4 * AlreadyFull)
		inst.components.lizardness:DoDelta(7)
		EatenMeat = true

	-- Lizardness 7
    elseif food.name == 'Fried Drumstick' or food.name == 'Cooked Fish' or food.name == 'Cooked Batilisk Wing' or food.name == 'Cooked Eel' or food.name == 'Cooked Frog Legs' or food.name == 'Cooked Morsel' then
		if food.name == 'Cooked Morsel' then
			inst.exp = inst.exp + (3 * AlreadyFull)
		else
			inst.exp = inst.exp + (5 * AlreadyFull)
		end
		inst.components.lizardness:DoDelta(7)
		EatenMeat = true

	-- Lizardness 5
    elseif food.name == 'Guardians Horn' or food.name == 'Glommers Goop' or food.name == 'Koalefant Trunk' or food.name == 'Winter Koalefant Trunk' or food.name == 'Koalefant Trunk Steak' then
		inst.exp = inst.exp + (50 * AlreadyFull)
		inst.components.lizardness:DoDelta(5)
		EatenMeat = true

	-- Lizardness Deerclops
    elseif food.name == 'Deerclops Eyeball' then
		inst.exp = inst.exp + 300
		EatenMeat = true

	end

	if inst.level < 6 and inst.exp > 49 then
		inst.level = inst.level + 1
		levelUp(inst)
		inst.exp = 0

	end

	if EatenMeat == true then

		if inst.level > 5 and inst.level < 26 and inst.exp > (99 + ((inst.level - 6) * 10)) then
			inst.level = inst.level + 1
			levelUp(inst)
			inst.exp = 0
	
		elseif inst.level > 26 and inst.level < 91 and inst.exp > 299 then
			inst.level = inst.level + 1
			levelUp(inst)
			inst.exp = 0

		end	

		if inst.components.lizardness:GetPercent() > .8 then
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_LIZARDNESS_HIGHEST"))

		elseif inst.components.lizardness:GetPercent() > .65 then
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_LIZARDNESS_HIGHER"))
		
		elseif inst.components.lizardness:GetPercent() > .5 then
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_LIZARDNESS_AVERAGE"))
		
		elseif inst.components.lizardness:GetPercent() > .3 then
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_LIZARDNESS_LOW"))

		elseif inst.components.lizardness:GetPercent() > .2 then
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_LIZARDNESS_LOWER"))
		
		elseif inst.components.lizardness:GetPercent() > .1 then
			inst.components.talker:Say(GetString("wik", "ANNOUNCE_LIZARDNESS_LOWEST"))
	
		end
	
    end

	print ('Level', inst.level)	
	print ('Exp', inst.exp)	
    print ('Lizardness', inst.components.lizardness:GetPercent())


end


local function lizardhurt(inst, delta)
    if delta < 0 then
        inst.sg:PushEvent("attacked")
        inst.components.lizardness:DoDelta(delta*.25)
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_down")
        inst.HUD.controls.lizardbadge:PulseRed()
        if inst.HUD.bloodover then
            inst.HUD.bloodover:Flash()
        end
    end
end


local function SetHUDState(inst)
    if inst.HUD then
        if (inst.components.lizardness and inst.components.lizardness:IsLizard()) or inst.lizard == true then --inst:HasTag("beaver") then
        --[[if inst.components.lizardness:IsLizard() and not inst.HUD.controls.lizardbadge then
            inst.HUD.controls.lizardbadge = GetPlayer().HUD.controls.sidepanel:AddChild(LizardBadge(inst))
            inst.HUD.controls.lizardbadge:SetPosition(0,-100,0)
            inst.HUD.controls.lizardbadge:SetPercent(1)
            
            inst.HUD.controls.lizardbadge.inst:ListenForEvent("lizardnessdelta", function(_, data) 
                inst.HUD.controls.lizardbadge:SetPercent(inst.components.lizardness:GetPercent(), inst.components.lizardness.max)
                if not data.overtime then
                    if data.newpercent > data.oldpercent then
                        inst.HUD.controls.lizardbadge:PulseGreen()
                        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_up")
                    elseif data.newpercent < data.oldpercent then
                        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/health_down")
                        inst.HUD.controls.lizardbadge:PulseRed()
                    end
                end
            end, inst)--]]
            inst.HUD.controls.crafttabs:Hide()
            inst.HUD.controls.inv:Hide()
            --inst.HUD.controls.status:Hide()
            --inst.HUD.controls.mapcontrols.minimapBtn:Hide()
            if inst.HUD.lizardOL then
                return
            end
            inst.HUD.lizardOL = inst.HUD.under_root:AddChild(Image(resolvefilepath "images/woodie.xml", "beaver_vision_OL.tex"))
            inst.HUD.lizardOL:SetVRegPoint(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetHRegPoint(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetVAnchor(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetHAnchor(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetScaleMode(SCALEMODE_FILLSCREEN)
            inst.HUD.lizardOL:SetClickable(false)
		
        else --if not inst.components.lizardness:IsLizard() and inst.HUD.controls.lizardbadge then
												 
													
												   
			   

            if inst.HUD.lizardOL then
                inst.HUD.lizardOL:Kill()
                inst.HUD.lizardOL = nil
            end

            inst.HUD.controls.crafttabs:Show()
            inst.HUD.controls.inv:Show()
            inst.HUD.controls.status:Show()
            inst.HUD.controls.mapcontrols.minimapBtn:Show()

        end

    end
end


local function IsWorldWithWater()
	return GetWorld():HasTag("shipwrecked") or GetWorld():HasTag("porkland")
end

local function CustomWarWaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActive, random_angle)
	wavePrefab = wavePrefab or "rogue_wave"
	totalAngle = math.clamp(totalAngle, 1, 360)

    local pos = inst:GetPosition()
    local startAngle = (random_angle and math.random(-180, 180)) or inst.Transform:GetRotation()
    local anglePerWave = totalAngle/(numWaves - 1)

	if totalAngle == 360 then
		anglePerWave = totalAngle/numWaves
	end

    for i = 0, numWaves - 1 do
        local wave = SpawnPrefab(wavePrefab)

        local angle = (startAngle - (totalAngle/2)) + (i * anglePerWave)
        local rad = initialOffset or (inst.Physics and inst.Physics:GetRadius()) or 0.0
        local total_rad = rad + wave.Physics:GetRadius() + 0.1
        local offset = Vector3(math.cos(angle*DEGREES),0, -math.sin(angle*DEGREES)):Normalize()
        local wavepos = pos + (offset * total_rad)

		wave.Transform:SetPosition(wavepos:Get())

		local speed = waveSpeed or 6
		wave.Transform:SetRotation(angle)
		wave.Physics:SetMotorVel(speed, 0, 0)
		wave.idle_time = idleTime or 5

		if instantActive then
			wave.sg:GoToState("idle")
		end

		if wave.soundtidal then
			wave.SoundEmitter:PlaySound("dontstarve_DLC002/common/rogue_waves/"..wave.soundtidal)
		end
    end
end


function BecomeWik(inst)

    inst.Transform:SetScale(1, 1, 1, 1)
	TheCamera:SetDefault()
    
    inst.lizard = false
    inst.ActionStringOverride = nil
    if inst.level > 5 then 
    	inst.components.eater:SetOmnivore()
    	STRINGS.CHARACTERS.WIK = require "wikSpeech"

    else
    	inst.components.eater:SetVegetarian()
    	STRINGS.CHARACTERS.WIK = require "wikSpeechVeggie"

    end
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wik_skinny")
    inst:SetStateGraph("SGwik")
	inst.Transform:SetFourFaced()
	inst.entity:AddMiniMapEntity():SetIcon( "wikmini.tex" )
    inst:RemoveTag("beaver")
	inst:AddTag("merm")

	inst.shallwalk = nil
	inst.altsound = nil
    
    if inst.components.worker then inst:RemoveComponent("worker") end
	if inst.components.waterproofer then inst:RemoveComponent("waterproofer") end
	if inst.storedOnStrike then
		inst.components.playerlightningtarget:SetOnStrikeFn(inst.storedOnStrike)
	end

    inst.components.talker:StopIgnoringAll()
    inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
    inst.components.locomotor:EnableGroundSpeedMultiplier(true)
	ChangeToCharacterPhysics(inst)
	inst.Physics:SetMass(75)

    inst.components.combat:SetDefaultDamage(TUNING.UNARMED_DAMAGE)
    inst.components.combat:SetAreaDamage(nil, 1)
    inst.components.combat:SetRange(3, 3)
    
    inst.components.playercontroller.actionbuttonoverride = nil
    inst.components.playeractionpicker.leftclickoverride = nil
    inst.components.playeractionpicker.rightclickoverride = nil
    --inst.components.eater:SetOmnivore()

    inst.components.eater.strongstomach = false

	inst.components.health.invincible = false
    inst.components.hunger:Resume()
    inst.components.sanity.ignore = false
    inst.components.health.redirect = nil

    inst.components.lizardness:StartTimeEffect(2, -0.185)

    --inst:RemoveEventCallback("oneatsomething", onlizardeat)
    --inst:ListenForEvent("oneatsomething", onwikeat)
 
    inst.Light:Enable(false)
    inst.components.dynamicmusic:Enable()
    --inst.SoundEmitter:KillSound("danger")
	inst.DynamicShadow:SetSize(1.3, 0.6)
    GetWorld().components.colourcubemanager:SetOverrideColourCube(nil)
    inst.components.temperature:SetTemp(nil)
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)

    --inst:ListenForEvent("temperaturedelta", ontemperaturechange)

	levelUp(inst)

end

local function oncollide(inst, other)
    if other == GetPlayer() or not inst:HasTag("beaver") then
    	return
    end

--[[    inst:DoTaskInTime(2*FRAMES, function()

            if other and other.components.workable then
                SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
                other.components.workable:Destroy(inst)
				TheCamera:Shake("FULL", 0.5, 0.05, 0.1)

            end
    end)--]]
end

local function ChangeToBigFootPhysics(inst)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(GetWorldCollision())
    --inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	if COLLISION.WAVES then
		inst.Physics:CollidesWith(COLLISION.WAVES)
	end
	if COLLISION.INTWALL then
		inst.Physics:CollidesWith(COLLISION.INTWALL)
	end
end

local function CheckMonsterFile(file)
	if softresolvefilepath(file) then
		return true
	else
		print("ERROR - Can't play as this with current world DLC: '"..file.."' not found!")
		return false
	end
end

local function CreateNightvision(inst)
    inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(8)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.6)
    inst.Light:SetColour(255/255,0/255,0/255)
end

local function GenericMonsterSetup(inst)
	inst:RemoveTag("merm") --Hostile merms
	if not inst:HasTag("monster") then
		inst:AddTag("monster") --Hostile pigs
		inst:AddTag("catcoon") --I dunno what this does...
	end
--Null lightning strike to avoid stategraph errors.
	if inst.components.playerlightningtarget then --This is null on vanilla, but didn't we give up on vanilla?
		inst.storedOnStrike = inst.components.playerlightningtarget.onstrikefn --Save default function for restoring
		inst.components.playerlightningtarget:SetOnStrikeFn(function(inst) inst:PushEvent("lightningdamageavoided") end)
	end
--Null the function that kicks you off the water.
	if IsWorldWithWater() then
		inst.components.keeponland.OnUpdateSw = function(self, dt) return end
	end
--Disable wetness by overriding delta with 0.
	if inst.components.moisture then
		local moisture_DoDelta = inst.components.moisture.DoDelta
		inst.components.moisture.DoDelta = function(self, num)
			return moisture_DoDelta(self, 0)
		end
	end
end

function BecomeLizard()
local inst = GetPlayer()
--Set up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(2.4, 2.4, 2.4, 2.4)
--Default camera in case it was changed.
	TheCamera:SetDefault()
--Set map icon.
	inst.entity:AddMiniMapEntity():SetIcon("wikmini.tex")
--The actual transformation.
    inst.AnimState:SetBuild("werelizard_build")
    inst.AnimState:SetBank("werelizard")
    inst:SetStateGraph("SGwerelizard")
--Set up animation facing rules.
	inst.Transform:SetFourFaced()
--Do common setup.
	GenericMonsterSetup(inst)
	--inst:AddTag("monster")
	--inst:AddTag("catcoon")
--[[    local loot = {"meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "deerclops_eyeball"}
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)--]]
--Remove text.
    inst.components.talker:IgnoreAll()
--General speed.
    --inst.components.locomotor.walkspeed = 7
    inst.components.locomotor.runspeed = 4
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--    inst.components.inventory:DropEverything()
--Create waves when stomping through water.
	if IsWorldWithWater() and inst.giantWaves then
		inst.StompSplash = function(inst)
			if inst.GetIsOnWater(inst) then
				CustomWarWaves(inst, 6, 110, 4+2, "wave_ripple", 2.0)
			end
		end
	end
--Remove collisions and make heavy.
	ChangeToGhostPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = DeerclopsActionButton
    inst.components.playeractionpicker.leftclickoverride = LeftClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
    --inst.components.eater:SetBeaver()
    --inst.components.eater:SetCarnivore(true)
--Blobby shadow size.
    inst.DynamicShadow:SetSize(11, 6)
--[[    inst:AddComponent("timer")
    inst.WorkEntities = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
        GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 1.4, 40)
    end
    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 4
    inst.components.groundpounder.destructionRings = 4
    inst.components.groundpounder.numRings = 5--]]
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(6, 1)
    inst.components.combat:SetRange(4)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 1)
    inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
													  

    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(20)
    --inst:RemoveEventCallback("temperaturedelta", ontemperaturechange)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true 
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
	inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
																					
																																 
										   
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
    --inst:RemoveEventCallback("oneatsomething", onwikeat)
    --inst:ListenForEvent("oneatsomething", onlizardeat)
--    local dt = 3
--    local BEAVER_DRAIN_TIME = 120
--    inst.components.lizardness:StartTimeEffect(dt, (-100/BEAVER_DRAIN_TIME)*dt)
--    inst.SoundEmitter:KillSound("eating")
--    inst.SoundEmitter:PlaySound("dontstarve/music/music_epicfight_winter", "danger")
    --GetWorld().components.colourcubemanager:SetOverrideColourCube(resolvefilepath "images/colour_cubes/lizard_vision_3_cc.tex")
   --[[         inst.HUD.controls.crafttabs:Hide()
            inst.HUD.controls.inv:Hide()
            --inst.HUD.controls.status:Hide()
            --inst.HUD.controls.mapcontrols.minimapBtn:Hide()

            inst.HUD.lizardOL = inst.HUD.under_root:AddChild(Image(resolvefilepath "images/woodie.xml", "beaver_vision_OL.tex"))
            inst.HUD.lizardOL:SetVRegPoint(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetHRegPoint(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetVAnchor(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetHAnchor(ANCHOR_MIDDLE)
            inst.HUD.lizardOL:SetScaleMode(SCALEMODE_FILLSCREEN)
            inst.HUD.lizardOL:SetClickable(false)--]]
	if inst.WickzillaLoseExp then
		if inst.WickzillaLevel ~= 0 then
			if inst.WickzillaLevel < 0 then
				inst.level = inst.level + inst.WickzillaLevel
				if 	inst.level < 0 then
					inst.level = 0
				end
			else
				inst.level = inst.WickzillaLevel
			end
		else
			inst.level = 0
		end
		inst.exp = 0
	end
end

function BecomeDeerclops()
local inst = GetPlayer()
--Set up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(1.65, 1.65, 1.65, 1.65)
--Move camera up for tall monster.
	TheCamera:SetOffset(Vector3(0,3,0))
--Set map icon.
	if softresolvefilepath("images/deerclops.tex") then
		--print("Icon change should have succeeded!")
		inst.entity:AddMiniMapEntity():SetIcon("deerclops.tex")
	end
--The actual transformation.
    inst.AnimState:SetBuild("deerclops_build")
    inst.AnimState:SetBank("deerclops")
    inst:SetStateGraph("SGdeerclopsPlayer")
--Set up animation facing rules.
	inst.Transform:SetFourFaced()
--Do common setup.
	GenericMonsterSetup(inst)
--Remove text.
    inst.components.talker:IgnoreAll()
--General speed.
    inst.components.locomotor.walkspeed = 3.6
--    inst.components.locomotor.runspeed = 3
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--Create waves when stomping through water.
	if IsWorldWithWater() and inst.giantWaves then
		inst.StompSplash = function(inst)
			if inst.GetIsOnWater(inst) then
				CustomWarWaves(inst, 6, 110, 3.6+2, "wave_ripple", 2.0)
			end
		end
	end
--Remove collisions and make heavy.
	ChangeToGhostPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = DeerclopsActionButton
    inst.components.playeractionpicker.leftclickoverride = LeftClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
--Blobby shadow size.
    inst.DynamicShadow:SetSize(7, 4)
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(6, 1)
    inst.components.combat:SetRange(5, 5)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 1)
    inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(20)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true 
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
    inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
end

function BecomeBearger(shallwalk)
if not CheckMonsterFile("anim/bearger_build.zip") then return end
local inst = GetPlayer()
if shallwalk == nil then shallwalk = 0 end
--Sets up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(1, 1, 1, 1)
--Default camera in case it was changed.
	TheCamera:SetDefault()
--Set map icon.
	if softresolvefilepath("images/bearger.tex") then
		inst.entity:AddMiniMapEntity():SetIcon( "bearger.tex" )
	end
--The actual transformation.
    inst.AnimState:SetBuild("bearger_build")
    inst.AnimState:SetBank("bearger")
	--Stategraph moved for Bearger.
--Set up animation facing rules.
	inst.Transform:SetFourFaced()
--Do common setup.
	GenericMonsterSetup(inst)
--Remove text.
    inst.components.talker:IgnoreAll()
--Set speed and Bearger-specific movement.
	if shallwalk >= 2 then
		inst.shallwalk = 2
		inst.components.locomotor.walkspeed = 6
	elseif shallwalk == 1 then
		inst.shallwalk = 1
		inst.components.locomotor.walkspeed = 4
	else
		inst.shallwalk = 0
	end
    inst.components.locomotor.runspeed = 9
	--Stategraph uses these two functions.
    inst.SetStandState = function(inst, state)
		 inst.StandState = string.lower(state)
	 end
    inst.IsStandState = function(inst, state)
		 return inst.StandState == string.lower(state)
	 end
	inst.SetStandState(inst, "BI")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--Stategraph needs to come after all that junk.
    inst:SetStateGraph("SGBeargerPlayer")
--Create waves when stomping through water.
	if IsWorldWithWater() and inst.giantWaves then
		inst.StompSplash = function(inst, speed, pound)
			if inst.GetIsOnWater(inst) then
				local amount, radius
				if pound then
					amount = 12
					radius = 360
				else
					amount = 6
					radius = 110
				end
				CustomWarWaves(inst, amount, radius, speed, "wave_ripple", 2.0)
			end
		end
	end
--Remove collisions and make heavy.
	ChangeToGhostPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = LizardActionButton
    inst.components.playeractionpicker.leftclickoverride = LizardLeftClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
--Timer used for some stategraph stuff.
    inst:AddComponent("timer")
--Used by some creatures to supplement their attack with destruction.
--Bearger uses it in attack, but I blocked it from being called.
    inst.WorkEntities = function(inst)
print("Bearger WorkEntities ran. I wonder how?")
 --       inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
 --       GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 1.4, 40)
    end
--Blobby shadow size.
    --local shadow = inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(10, 4.5)
--AoE attack for Bearger.
	if inst.components.groundpounder == nil then
		inst:AddComponent("groundpounder")
	end
    inst.components.groundpounder.destroyer = false
    inst.components.groundpounder.damageRings = 0
    inst.components.groundpounder.destructionRings = 0
    inst.components.groundpounder.numRings = 3
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(6, 1)
    inst.components.combat:SetRange(6, 4.8)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 4)
    inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(20)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true   
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
    inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
end
function BeargerSpeed(speed)
	local inst = GetPlayer()
	if inst.shallwalk == nil then print("ERROR - You're not a bearger!") return end
	if speed == nil then
		if inst.shallwalk == 2 then
			inst.shallwalk = 0
		else
			inst.shallwalk = inst.shallwalk + 1
		end
	elseif speed >= 2 then
		inst.shallwalk = 2
	elseif speed <= 0 then
		inst.shallwalk = 0
	else
		inst.shallwalk = speed
	end
end

function BecomeMooseGoose()
if not CheckMonsterFile("anim/goosemoose_build.zip") then return end
local inst = GetPlayer()
--Set up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(1.55, 1.55, 1.55, 1.55)
--Move camera up for tall monster.
	TheCamera:SetOffset(Vector3(0,4,0))
--Set map icon.
	if softresolvefilepath("images/moose.tex") then
		--print("Icon change should have succeeded!")
		inst.entity:AddMiniMapEntity():SetIcon("moose.tex")
	end
--The actual transformation.
    inst.AnimState:SetBuild("goosemoose_build")
    inst.AnimState:SetBank("goosemoose")
    inst:SetStateGraph("SGMooseGoosePlayer")
--Set up animation facing rules.
	inst.Transform:SetFourFaced()
--Do common setup.
	GenericMonsterSetup(inst)
--Remove text.
    inst.components.talker:IgnoreAll()
--General speed.
    inst.components.locomotor.walkspeed = 7
    --inst.components.locomotor.runspeed = 13
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--Create waves when stomping through water.
	if IsWorldWithWater() and inst.giantWaves then
		inst.StompSplash = function(inst)
			if inst.GetIsOnWater(inst) then
				CustomWarWaves(inst, 6, 110, 7, "wave_ripple", 2.0)
			end
		end
	end
--Remove collisions and make heavy.
	ChangeToGhostPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = DeerclopsActionButton
    inst.components.playeractionpicker.leftclickoverride = LeftClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
--Timer used for Disarm attack.
    inst:AddComponent("timer")
--Used by some creatures to supplement their attack with destruction.
--[[    inst.WorkEntities = function(inst) --bad, weird version I made???
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
     --   GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 1.4, 40)
    end--]]
--Blobby shadow size.
    inst.DynamicShadow:SetSize(6, 2.75)
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(4, 1)
    inst.components.combat:SetRange(4, 4)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 1)
    inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(20)
 --   inst:DoTaskInTime(1, function() inst:RemoveEventCallback("temperaturedelta", ontemperaturechange) end)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
    inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
end
function BecomeGooseMoose()
	BecomeMooseGoose()
end
function BecomeMoose()
	BecomeMooseGoose()
end
function BecomeGoose()
	BecomeMooseGoose()
end

function BecomeBigFoot(altsound)
if not CheckMonsterFile("anim/foot_build.zip") then return end
local inst = GetPlayer()
--Sets up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(1, 1, 1, 1)
--Default camera in case it was changed.
	TheCamera:SetDefault()
--Set map icon.
	inst.entity:AddMiniMapEntity():SetIcon( "wikmini.tex" )
--The actual transformation.
    inst.AnimState:SetBuild("foot_build")
    inst.AnimState:SetBank("foot")
    inst:SetStateGraph("SGbigfootPlayer")
--Set up animation facing rules.
	inst.Transform:SetFourFaced()
--Do common setup.
	GenericMonsterSetup(inst)
--Remove text.
    inst.components.talker:IgnoreAll()
--General speed.
    inst.components.locomotor.walkspeed = 7
    --inst.components.locomotor.runspeed = 13
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--Create waves when stomping through water.
	if IsWorldWithWater() and inst.giantWaves then
		inst.StompSplash = function(inst)
			if inst.GetIsOnWater(inst) then
				CustomWarWaves(inst, 14, 360, 6, nil, 2.0)
			end
		end
	end
--Remove collisions with objects and make heavy.
	ChangeToBigFootPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = DeerclopsActionButton
    inst.components.playeractionpicker.leftclickoverride = RightClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
--Timer used for nothing, for this creature.
 --   inst:AddComponent("timer")
--Used by some creatures to supplement their attack with destruction.
--    inst.WorkEntities = function(inst) --bad, weird version I made???
--        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
     --   GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 1.4, 40)
--    end
--Blobby shadow size.
    inst.DynamicShadow:SetSize(12, 12)
--Alt stomp sound option.
	if altsound == nil or altsound <= 0 then
		inst.altsound = "dontstarve_DLC001/creatures/glommer/foot_ground"
	else
		inst.altsound = "dontstarve_DLC001/creatures/bearger/groundpound"
	end
--Special AoE attack effects.
	if inst.components.groundpounder == nil then
		inst:AddComponent("groundpounder")
	end
    inst.components.groundpounder.destroyer = false
    inst.components.groundpounder.damageRings = 0
    inst.components.groundpounder.destructionRings = 0
    inst.components.groundpounder.numRings = 3
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(4, 1)
    inst.components.combat:SetRange(4, 4)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 1)
    --inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(30)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
    inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
end
function BigFootSound()
	local inst = GetPlayer()
	if inst.altsound == nil then print("ERROR - You're not the big foot!") return end
	if inst.altsound == "dontstarve_DLC001/creatures/glommer/foot_ground" then
		inst.altsound = "dontstarve_DLC001/creatures/bearger/groundpound"
	else
		inst.altsound = "dontstarve_DLC001/creatures/glommer/foot_ground"
	end
end

function BecomeTreeguard(kind)
if kind == nil then kind = 0 end
local inst = GetPlayer()
--Set up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(1.5, 1.5, 1.5, 1.5)
--Move camera up for tall monster.
	TheCamera:SetOffset(Vector3(0,3,0))
--Set map icon.
	if softresolvefilepath("images/leif.tex") then
		if kind <= 0 then
			inst.entity:AddMiniMapEntity():SetIcon("leif.tex")
		else
			inst.entity:AddMiniMapEntity():SetIcon("leif_sparse.tex")
		end
	end
--The actual transformation.
	if kind <= 0 then
		inst.AnimState:SetBuild("leif_build")
	else
		inst.AnimState:SetBuild("leif_lumpy_build")
	end
    inst.AnimState:SetBank("leif")
    inst:SetStateGraph("SGleifPlayer")
--Set up animation facing rules.
	inst.Transform:SetFourFaced()
--Do common setup.
	GenericMonsterSetup(inst)
--Remove text.
    inst.components.talker:IgnoreAll()
--General speed.
    inst.components.locomotor.walkspeed = 3
--    inst.components.locomotor.runspeed = 3
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--Remove collisions and make heavy.
	ChangeToGhostPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = DeerclopsActionButton
    inst.components.playeractionpicker.leftclickoverride = LeftClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
--Blobby shadow size.
    inst.DynamicShadow:SetSize(9, 3.5)
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(5, 1)
    inst.components.combat:SetRange(4, 4)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 1)
    inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(20)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true 
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
    inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
end
function BecomeLumpyTreeguard()
	BecomeTreeguard(1)
end

function BecomeBirdFoot(altsound)
if not CheckMonsterFile("anim/roc_leg.zip") then return end
local inst = GetPlayer()
--Sets up transformation flags.
    inst.lizard = true
    inst:AddTag("beaver")
--Define size of creature.
    inst.Transform:SetScale(1, 1, 1, 1)
--Default camera in case it was changed.
	TheCamera:SetDefault()
--Set map icon.
	inst.entity:AddMiniMapEntity():SetIcon( "wikmini.tex" )
--The actual transformation.
    inst.AnimState:SetBuild("roc_leg")
    inst.AnimState:SetBank("foot") --Huh, so that's why...
    inst:SetStateGraph("SGbirdfootPlayer")
--Set up animation facing rules.
	inst.Transform:SetSixFaced()
--Do common setup.
	GenericMonsterSetup(inst)
--Remove text.
    inst.components.talker:IgnoreAll()
--General speed.
    inst.components.locomotor.walkspeed = 7
    --inst.components.locomotor.runspeed = 13
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--Create waves when stomping through water.
	if IsWorldWithWater() and inst.giantWaves then
		inst.StompSplash = function(inst)
			if inst.GetIsOnWater(inst) then
				CustomWarWaves(inst, 14, 360, 6, nil, 2.0)
			end
		end
	end
--Remove collisions with objects and make heavy.
	ChangeToBigFootPhysics(inst)
	inst.Physics:SetMass(99999)
--Mouseover string and action overrides.
    inst.ActionStringOverride = dcattackactionstring
    inst.components.playercontroller.actionbuttonoverride = DeerclopsActionButton
    inst.components.playeractionpicker.leftclickoverride = RightClickPicker
    inst.components.playeractionpicker.rightclickoverride = RightClickPicker
--Timer used for nothing, for this creature.
 --   inst:AddComponent("timer")
--Used by some creatures to supplement their attack with destruction.
--    inst.WorkEntities = function(inst) --bad, weird version I made???
--        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
     --   GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.5, 0.05, 1.4, 40)
--    end
--Blobby shadow size.
    inst.DynamicShadow:SetSize(12, 12)
--Alt stomp sound option.
	if altsound == nil or altsound <= 0 then
		inst.altsound = "dontstarve_DLC001/creatures/glommer/foot_ground"
	else
		inst.altsound = "dontstarve_DLC001/creatures/bearger/groundpound"
	end
--Special AoE attack effects.
	if inst.components.groundpounder == nil then
		inst:AddComponent("groundpounder")
	end
    inst.components.groundpounder.destroyer = false
    inst.components.groundpounder.damageRings = 0
    inst.components.groundpounder.destructionRings = 0
    inst.components.groundpounder.numRings = 3
--Generic combat stats.
    inst.components.combat:SetDefaultDamage(1000)
    inst.components.combat:SetAreaDamage(4, 1)
    inst.components.combat:SetRange(4, 4)
--Sets what you can click on and your effectiveness. Worker is always needed.
    inst:AddComponent("worker")
    --inst.components.worker:SetAction(ACTIONS.DIG, 1)
	--inst.components.worker:SetAction(ACTIONS.CHOP, 4)
    --inst.components.worker:SetAction(ACTIONS.MINE, 1)
    --inst.components.worker:SetAction(ACTIONS.HAMMER, 4)
--Sets max values.
    inst.components.health.maxhealth = 2000
    inst.components.sanity:SetPercent(1)
    inst.components.health:SetPercent(1)
    inst.components.hunger:SetPercent(1)
--Sets a safe temperature.
    inst.components.temperature:SetTemp(30)
--Invulnerabilities.
	inst.components.health.invincible = true
    inst.components.hunger:Pause()
    inst.components.sanity.ignore = true
--Set waterproof since rain does nothing anyway. The only reason this works on the entity directly is because I patched it in modmain.
	if softresolvefilepath("scripts/components/waterproofer.lua") then --vanilla compatibility
		inst:AddComponent("waterproofer")
	end
--Just in case...
    inst.components.eater.strongstomach = true
    inst.components.eater.monsterimmune = true
--Nightvision.
	if not inst.Light then
		CreateNightvision(inst)
	end
    inst.Light:Enable(true)
--Ambiance.
    inst.components.dynamicmusic:Disable()
--Various HUD elements.
    inst:DoTaskInTime(0, function() SetHUDState(inst) end)
end

function mon(who, option)
	local TransformFunctions =
	{
	[0] = function() BecomeLizard() end,
		function() BecomeTreeguard(option) end,
		function() BecomeDeerclops() end,
		function() BecomeBearger(option) end,
		function() BecomeMooseGoose() end,
		function() BecomeBigFoot(option) end,
		function() BecomeBirdFoot(option) end,
	}

	if who <= -1 then
		BecomeWik(GetPlayer())
	elseif TransformFunctions[who] then
		TransformFunctions[who]()
	else
		print("WARNING - Provided monster index too high. Max is "..#TransformFunctions..".")
		print("Becoming BirdFoot.")
		TransformFunctions[#TransformFunctions]()
	end

	-- if who == -1 then
		-- BecomeWik(GetPlayer())
	-- elseif who == 0 then
		-- BecomeLizard()
	-- elseif who == 1 then
		-- BecomeTreeguard(option)
	-- elseif who == 2 then
		-- BecomeDeerclops()
	-- elseif who == 3 then
		-- BecomeBearger(option)
	-- elseif who == 4 then
		-- BecomeMooseGoose()
	-- elseif who == 5 then
		-- BecomeBigFoot(option)
	-- end

end

--duplicate function?!
--[[local function oncollide(inst, other)


    if other == GetPlayer() or not GetPlayer():HasTag("beaver") then 
    	return
    end 

    inst:DoTaskInTime(2*FRAMES, function()   

            if other and other.components.workable then
                SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
                other.components.workable:Destroy(inst)
				TheCamera:Shake("FULL", 0.5, 0.05, 0.1)

            end
    end)


end--]]


-- WERELIZARD FUNCTIONS END --


local function onpreload(inst, data)

	if data then

		if data.level then
			inst.HasSaveData = true
			inst.level = data.level
			inst.exp = data.exp
			inst.CurrentTemp = data.CurrentTemp
			data.wikColourSetting = inst.wikColourSetting

			if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end

			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)

		end

	end

end


local function onsave(inst, data)

	data.level = inst.level
	data.exp = inst.exp
	data.CurrentTemp = inst.CurrentTemp
	data.wikColourSetting = inst.wikColourSetting

end

local start_inv = --inventory
{
	"fish",
	"rabbit",
}


local fn = function(inst)

	inst.level = 6
	inst.WickzillaLevel = 0
	inst.WickzillaLoseExp = true
	inst.WickzillaExpMulti = 0
	inst.wikColourSetting = "default"
	inst.HasSaveData = false 

	inst.exp = 0

    CreateNightvision(inst)
							
						   
							 
							   
											 

	local MaximumHealth = 150
	local MaximumHunger = 0.5 -- 1 is Wilson's which is 150
	local MaximumSanity = .8 -- 1 is Wilson's which is 200

	local OverheatTemperature = 85 -- 2 degree's of the top (38 originally up'd to 43)

	local ExtraSanityMultplier = 0
	local CombatMultplier = 1

	local EatSpoiledFood = false
	local HasStrongStomach = false

	local HungerDrainRate = 1

	-- Change to custom minimap icon
	--moved to BecomeWik inst.entity:AddMiniMapEntity():SetIcon( "wikmini.tex" )
	-- Custom Sound
	inst.soundsname = "wik"
	--inst.talker_path_override = "dontstarve_DLC001/characters/"

	inst:SetStateGraph("SGwik")

    -- Add the Rundown House and put it to the top of the house list just before Pig House
	local mermhouse = Recipe("mermhouse", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("fish", 16), Ingredient("froglegs",8)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, "wikhouse_placer")


	mermhouse.sortkey = 13
	STRINGS.NAMES.MERMHOUSE = "Cousin's House"
	STRINGS.RECIPE_DESC.MERMHOUSE = "Cousin's House"
	mermhouse.atlas = "images/inventoryimages/mermhouse.xml"
	
    -- Make Pig House locked
    local PigHouse = GetRecipe("pighouse")
	PigHouse.nounlock = "nounlock"
	--STRINGS.RECIPE_DESC.PIGHOUSE = "Yuck!!"  
	PigHouse.name = "Rundown House 2"

    -- Make Rabbit House locked
    local RabbitHouse = GetRecipe("rabbithouse")
	RabbitHouse.nounlock = "nounlock"
	--STRINGS.RECIPE_DESC.RABBITHOUSE = "Weird"          	
	RabbitHouse.name = "Rundown House 3"
	
	-- Make Mermen Friends --
	inst:AddTag("wik")
	inst:AddTag("player")
	inst:AddTag("character")
	--added in BecomeWik inst:AddTag("merm")
	-- Make Pigmen Attack --
	inst:AddTag("monster")
	inst:AddTag("catcoon")

	-- Set Personal Variables --
	inst.CurrentHunger = ""
	inst.CurrentTemp = ""
	inst.CurrentTile = "Normal"
	inst.wikCurrentHunger = 0

	-- Core Stats
	inst.components.sanity:SetMax(TUNING.WILSON_SANITY * MaximumSanity) 

	inst.components.temperature.overheattemp = OverheatTemperature
    inst.components.eater.ignoresspoilage = EatSpoiledFood
	inst.components.eater.strongstomach = HasStrongStomach
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * HungerDrainRate)

	--inst.components.sanity.neg_aura_mult = ExtraSanityMultplier
	inst.components.combat.damagemultiplier = CombatMultplier

	inst.components.talker.colour = Vector3(119/255, 140/255, 81/255)

	-- WERELIZARD --

        inst:AddComponent("lizardness")
        inst.components.lizardness.makeperson = BecomeWik
        inst.components.lizardness.makelizard = BecomeLizard
    
        inst.components.lizardness.onbecomeperson = function()
            inst:PushEvent("transform_person")

        end

        inst.components.lizardness.onbecomelizard = function()
            inst:PushEvent("transform_werelizard")

        end

	BecomeWik(inst)

    inst.components.eater:SetOnEatFn(onwikeat)
    
	-- WERELIZARD END --

	inst.Physics:SetCollisionCallback(oncollide)
	inst:ListenForEvent("temperaturedelta", ontemperaturechange)

	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	levelUp(inst)

	--print("**Test - ",inst.TestLevel)

end

return MakePlayerCharacter("wik", prefabs, assets, fn, start_inv)