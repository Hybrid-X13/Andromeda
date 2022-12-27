local LuminaryFlare = require("andromeda_src.items.passives.luminary_flare")
local Vesta = require("andromeda_src.items.passives.vesta")
local AlienTransmitter = require("andromeda_src.items.trinkets.alien_transmitter")

local function MC_POST_EFFECT_INIT(_, effect)
	LuminaryFlare.postEffectInit(effect)
	Vesta.postEffectInit(effect)

	AlienTransmitter.postEffectInit(effect)
end

return MC_POST_EFFECT_INIT