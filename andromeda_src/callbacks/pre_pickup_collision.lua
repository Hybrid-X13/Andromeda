local Andromeda = require("andromeda_src.characters.andromeda")

local function MC_PRE_PICKUP_COLLISION(_, entity, collider, low)
	local returned = Andromeda.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_PICKUP_COLLISION