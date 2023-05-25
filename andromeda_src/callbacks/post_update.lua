local AlienTransmitter = require("andromeda_src.items.trinkets.alien_transmitter")
local AbandonedPlanetarium = require("andromeda_src.misc.abandoned_planetarium")

local function MC_POST_UPDATE()
	AlienTransmitter.postUpdate()
	
	AbandonedPlanetarium.postUpdate()
end

return MC_POST_UPDATE