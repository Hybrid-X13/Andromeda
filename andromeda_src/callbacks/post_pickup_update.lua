local Moonstone = require("andromeda_src.items.trinkets.moonstone")

local function MC_POST_PICKUP_UPDATE(_, pickup)
	Moonstone.postPickupUpdate(pickup)
end

return MC_POST_PICKUP_UPDATE