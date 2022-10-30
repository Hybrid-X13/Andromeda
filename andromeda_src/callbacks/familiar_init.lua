local UnlockManager = require("andromeda_src.unlock_manager")
local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local Plutonium = require("andromeda_src.items.familiars.plutonium")
local Charon = require("andromeda_src.items.familiars.charon")
local MegaPlutonium = require("andromeda_src.items.familiars.mega_plutonium")
local Nix = require("andromeda_src.items.familiars.nix")
local CelestialCrown = require("andromeda_src.items.passives.celestial_crown")
local Vesta = require("andromeda_src.items.passives.vesta")

local function MC_FAMILIAR_INIT(_, familiar)
	UnlockManager.familiarInit(familiar)

	BabyPluto.familiarInit(familiar)
	Plutonium.familiarInit(familiar)
	Charon.familiarInit(familiar)
	MegaPlutonium.familiarInit(familiar)
	Nix.familiarInit(familiar)
	
	CelestialCrown.familiarInit(familiar)
	Vesta.familiarInit(familiar)
end

return MC_FAMILIAR_INIT