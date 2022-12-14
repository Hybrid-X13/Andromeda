local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local BookOfCosmos = require("andromeda_src.items.actives.book_of_cosmos")
local Pallas = require("andromeda_src.items.passives.pallas")
local Juno = require("andromeda_src.items.passives.juno")
local LuminaryFlare = require("andromeda_src.items.passives.luminary_flare")
local Sextant = require("andromeda_src.items.trinkets.sextant")
local MoonStone = require("andromeda_src.items.trinkets.moon_stone")
local AbandonedPlanetarium = require("andromeda_src.misc.abandoned_planetarium")
local WispWizard = require("andromeda_src.misc.wisp_wizard")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_POST_NEW_ROOM()
	Andromeda.postNewRoom()
	T_Andromeda.postNewRoom()

	BookOfCosmos.postNewRoom()
	
	Pallas.postNewRoom()
	Juno.postNewRoom()
	LuminaryFlare.postNewRoom()
	
	Sextant.postNewRoom()
	MoonStone.postNewRoom()
	
	AbandonedPlanetarium.postNewRoom()
	WispWizard.postNewRoom()
	Wisp.postNewRoom()
end

return MC_POST_NEW_ROOM