local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local Plutonium = require("andromeda_src.items.familiars.plutonium")
local Charon = require("andromeda_src.items.familiars.charon")
local MegaPlutonium = require("andromeda_src.items.familiars.mega_plutonium")
local Nix = require("andromeda_src.items.familiars.nix")
local CelestialCrown = require("andromeda_src.items.passives.celestial_crown")
local Vesta = require("andromeda_src.items.passives.vesta")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_FAMILIAR_UPDATE(_, familiar)
	T_Andromeda.familiarUpdate(familiar)

	BabyPluto.familiarUpdate(familiar)
	Plutonium.familiarUpdate(familiar)
	Charon.familiarUpdate(familiar)
	MegaPlutonium.familiarUpdate(familiar)
	Nix.familiarUpdate(familiar)
	
	CelestialCrown.familiarUpdate(familiar)
	Vesta.familiarUpdate(familiar)

	Wisp.familiarUpdate(familiar)
end

return MC_FAMILIAR_UPDATE