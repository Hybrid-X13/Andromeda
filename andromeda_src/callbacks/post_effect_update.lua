local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local LuminaryFlare = require("andromeda_src.items.passives.luminary_flare")
local AlienTransmitter = require("andromeda_src.items.trinkets.alien_transmitter")

local function MC_POST_EFFECT_UPDATE(_, effect)
	Andromeda.postEffectUpdate(effect)
	T_Andromeda.postEffectUpdate(effect)
	
	LuminaryFlare.postEffectUpdate(effect)

	AlienTransmitter.postEffectUpdate(effect)
end

return MC_POST_EFFECT_UPDATE