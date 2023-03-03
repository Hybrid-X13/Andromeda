local Andromeda = require("andromeda_src.characters.andromeda")
local Singularity = require("andromeda_src.items.actives.singularity")

local function MC_PRE_PICKUP_COLLISION(_, entity, collider, low)
	local returned = Andromeda.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = Singularity.prePickupCollision(entity, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_PICKUP_COLLISION