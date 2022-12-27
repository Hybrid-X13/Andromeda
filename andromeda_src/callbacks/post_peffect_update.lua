local UnlockManager = require("andromeda_src.unlock_manager")
local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local GravityShift = require("andromeda_src.items.actives.gravity_shift")
local Singularity = require("andromeda_src.items.actives.singularity")
local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local Plutonium = require("andromeda_src.items.familiars.plutonium")
local Charon = require("andromeda_src.items.familiars.charon")
local MegaPlutonium = require("andromeda_src.items.familiars.mega_plutonium")
local Nix = require("andromeda_src.items.familiars.nix")
local ExtinctionEvent = require("andromeda_src.items.actives.extinction_event")
local Ophiuchus = require("andromeda_src.items.passives.ophiuchus")
local Pallas = require("andromeda_src.items.passives.pallas")
local Vesta = require("andromeda_src.items.passives.vesta")
local CelestialCrown = require("andromeda_src.items.passives.celestial_crown")
local LuminaryFlare = require("andromeda_src.items.passives.luminary_flare")
local AndromedaKnife = require("andromeda_src.items.passives.andromeda_knife")
local AndromedaTechX = require("andromeda_src.items.passives.andromeda_techx")
local Meteorite = require("andromeda_src.items.trinkets.meteorite")
local MoonStone = require("andromeda_src.items.trinkets.moon_stone")
local Polaris = require("andromeda_src.items.trinkets.polaris")
local Spode = require("andromeda_src.misc.spode")
local WispWizard = require("andromeda_src.misc.wisp_wizard")

local function MC_POST_PEFFECT_UPDATE(_, player)
	UnlockManager.postPEffectUpdate(player)
	
	Andromeda.postPEffectUpdate(player)
	T_Andromeda.postPEffectUpdate(player)
	
	GravityShift.postPEffectUpdate(player)
	Singularity.postPEffectUpdate(player)
	
	BabyPluto.postPEffectUpdate(player)
	Plutonium.postPEffectUpdate(player)
	Charon.postPEffectUpdate(player)
	MegaPlutonium.postPEffectUpdate(player)
	Nix.postPEffectUpdate(player)

	ExtinctionEvent.postPEffectUpdate(player)
	
	Ophiuchus.postPEffectUpdate(player)
	Pallas.postPEffectUpdate(player)
	Vesta.postPEffectUpdate(player)
	CelestialCrown.postPEffectUpdate(player)
	LuminaryFlare.postPEffectUpdate(player)
	AndromedaKnife.postPEffectUpdate(player)
	AndromedaTechX.postPEffectUpdate(player)
	
	Meteorite.postPEffectUpdate(player)
	MoonStone.postPEffectUpdate(player)
	Polaris.postPEffectUpdate(player)

	Spode.postPEffectUpdate(player)
	WispWizard.postPEffectUpdate(player)
end

return MC_POST_PEFFECT_UPDATE