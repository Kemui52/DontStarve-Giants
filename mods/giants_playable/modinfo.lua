-- v1.08

-- This information tells other players more about the mod
name = "Playable Giants"
description = "\"This is monumental.\"\n\nBased off mods by Sodasorbet, Bones, DarkXero, and ziyuan."
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
		label = "Play Intro",
		options =	{
						{description = "None", data="None"},
						{description = "Wicked (default)", data="Wicked"},
						{description = "Normal", data="Normal"},
					},

		default = "Wicked",
	
	},

	{
		name = "wikStartingLevel",
		label = "Starting Level",
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
		label = "After Wickzilla Level",

		options =	{
						{description = "Down 10 levels", data=-10},
						{description = "Down 5 levels", data=-5},
						{description = "Down 3 levels (default)", data=-3},
						{description = "Down 1 level", data=-1},		
						{description = "0 (original)", data=0},
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

		default = -3,
	
	},

	{
		name = "wikLoseExp",
		label = "Lose Level After Wickzilla?",
		options =	{
						{description = "Yes (default)", data = true},
						{description = "No", data = false},
					},

		default = true,
	
	},

	{
		name = "wikExpMulti",
		label = "Exp gain from meat?",
		options =	{
						{description = "x1 (original)", data = 1},
						{description = "x2", data = 2},
						{description = "x3 (default)", data = 3},
						{description = "x5", data = 5},
					},

		default = 3,
	
	},

	{
		name = "wikColour",
		label = "Skin Colour",
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
