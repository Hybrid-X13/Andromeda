local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Ceres = require("andromeda_src.items.passives.ceres")
local LuminaryFlare = require("andromeda_src.items.passives.luminary_flare")
local HarmonicConvergence = require("andromeda_src.items.passives.harmonic_convergence")
local AlienTransmitter = require("andromeda_src.items.trinkets.alien_transmitter")
local AbandonedPlanetarium = require("andromeda_src.misc.abandoned_planetarium")
local Spode = require("andromeda_src.misc.spode")

local function MC_POST_EFFECT_UPDATE(_, effect)
	Andromeda.postEffectUpdate(effect)
	T_Andromeda.postEffectUpdate(effect)
	
	Ceres.postEffectUpdate(effect)
	LuminaryFlare.postEffectUpdate(effect)
	HarmonicConvergence.postEffectUpdate(effect)

	AlienTransmitter.postEffectUpdate(effect)

	AbandonedPlanetarium.postEffectUpdate(effect)
	Spode.postEffectUpdate(effect)
end

return MC_POST_EFFECT_UPDATE