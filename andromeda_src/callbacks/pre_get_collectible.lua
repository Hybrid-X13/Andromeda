local AbandonedPlanetarium = require("andromeda_src.misc.abandoned_planetarium")

local function MC_PRE_GET_COLLECTIBLE(_, pool, decrease, seed)
	local returned = AbandonedPlanetarium.preGetCollectible(pool, decrease, seed)
	if returned ~= nil then return returned end
end

return MC_PRE_GET_COLLECTIBLE