local Singularity = require("andromeda_src.items.actives.singularity")

local function MC_PRE_PICKUP_COLLISION(_, entity, collider, low)
	local returned = Singularity.SingularityPickupCollision(entity, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_PICKUP_COLLISION