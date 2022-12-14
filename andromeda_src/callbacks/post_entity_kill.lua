local UnlockManager = require("andromeda_src.unlock_manager")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_POST_ENTITY_KILL(_, entity)
	UnlockManager.postEntityKill(entity)

	Wisp.postEntityKill(entity)
end

return MC_POST_ENTITY_KILL