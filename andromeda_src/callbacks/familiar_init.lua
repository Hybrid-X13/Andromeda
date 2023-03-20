local TheSporepedia = require("andromeda_src.items.actives.the_sporepedia")
local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local Plutonium = require("andromeda_src.items.familiars.plutonium")
local Charon = require("andromeda_src.items.familiars.charon")
local MegaPlutonium = require("andromeda_src.items.familiars.mega_plutonium")
local Nix = require("andromeda_src.items.familiars.nix")
local CelestialCrown = require("andromeda_src.items.passives.celestial_crown")
local Vesta = require("andromeda_src.items.passives.vesta")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_FAMILIAR_INIT(_, familiar)
	TheSporepedia.familiarInit(familiar)

	BabyPluto.familiarInit(familiar)
	Plutonium.familiarInit(familiar)
	Charon.familiarInit(familiar)
	MegaPlutonium.familiarInit(familiar)
	Nix.familiarInit(familiar)
	
	CelestialCrown.familiarInit(familiar)
	Vesta.familiarInit(familiar)

	Wisp.familiarInit(familiar)
end

return MC_FAMILIAR_INIT