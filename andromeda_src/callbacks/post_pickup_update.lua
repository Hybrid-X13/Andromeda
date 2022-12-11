local MoonStone = require("andromeda_src.items.trinkets.moon_stone")

local function MC_POST_PICKUP_UPDATE(_, pickup)
	MoonStone.postPickupUpdate(pickup)
end

return MC_POST_PICKUP_UPDATE