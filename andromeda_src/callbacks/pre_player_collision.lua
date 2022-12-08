local WispWizard = require("andromeda_src.misc.wisp_wizard")

local function MC_PRE_PLAYER_COLLISION(_, player, collider, low)
	local returned = WispWizard.prePlayerCollision(player, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_PLAYER_COLLISION