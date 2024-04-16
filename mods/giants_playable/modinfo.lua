-- v1.07

-- This information tells other players more about the mod
name = "Playable Giants"
description = "\"This is monumental.\"\n\nBased off mods by Reislet and Bones, DarkXero, and ziyuan."
--             Updated Mod character Wicked the Lizardman./n"
author = "Kemui52"
api_version = 6
version = "1.5"
priority = 2.5
dont_starve_compatible = nil --random crash with no log. wtf??? was it 'cause I wasn't wik?
reign_of_giants_compatible = true
shipwrecked_compatible = nil --might be fine, but can't test
hamlet_compatible = true --seems okay

forumthread = ""

icon_atlas = "modicon.xml"
icon = "modicon.tex"
--modicons not done, yet.


configuration_options =
{
	{
		name = "wikPlayIntro",
		label = "Included",
		options =	{
						{description = "None", data="None"},
						{description = "Wicked (default)", data="Wicked"},
						{description = "Normal", data="Normal"},
					},

		default = 6,
	
	},

	{
		name = "wikStartingLevel",
		label = "for",
		options =	{
						{description = "0 (min)", data=0},
						{description = "6 (default)", data=6},
						{description = "10", data=10},
						{description = "20", data=20},
						{description = "30", data=30},
						{description = "40", data=40},
						{description = "45 (max hunger)", data=45},
						{description = "50", data=50},
						{description = "60", data=60},
						{description = "70", data=70},
						{description = "80", data=80},
						{description = "90 (max health)", data=90},
					},

		default = 6,
	
	},
	
	{
		name = "wikPostLevel",
		label = "Compatibility",

		options =	{
						{description = "Down 10 Level", data=-10},
						{description = "Down 5 Level", data=-5},
						{description = "Down 3 Level", data=-3},
						{description = "Down 1 Level", data=-1},		
						{description = "0 (default)", data=0},
						{description = "6", data=6},
						{description = "10", data=10},
						{description = "20", data=20},
						{description = "30", data=30},
						{description = "40", data=40},
						{description = "45 (max hunger)", data=45},
						{description = "50", data=50},
						{description = "60", data=60},
						{description = "70", data=70},
						{description = "80", data=80},
						{description = "90 (max health)", data=90},
					},

		default = 0,
	
	},

	{
		name = "wikLoseExp",
		label = "Got",
		options =	{
						{description = "Yes (default)", data = true},
						{description = "No", data = false},
					},

		default = true,
	
	},

	{
		name = "wikColour",
		label = "That?",
		options =	{
						{description = "Default", data = "default"},
						{description = "Green", data = "green"},
						{description = "Red", data = "red"},
						{description = "Blue", data = "blue"},
					},

		default = "default",
	
	},

	{
		name = "giantWaves",
		label = "Waves in Water",
		options =	{
						{description = "Yes", data = true},
						{description = "No", data = false},
					},

		default = true,
	
	},

}
