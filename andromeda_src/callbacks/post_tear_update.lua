local Spode = require("andromeda_src.misc.spode")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_POST_TEAR_UPDATE(_, tear)
	Spode.postTearUpdate(tear)
	Wisp.postTearUpdate(tear)
end

return MC_POST_TEAR_UPDATE