local AbandonedPlanetarium = require("andromeda_src.misc.abandoned_planetarium")

local function MC_GET_TRINKET(_, trinket, rng)
	local returned = AbandonedPlanetarium.getTrinket(trinket, rng)
	if returned ~= nil then return returned end
end

return MC_GET_TRINKET