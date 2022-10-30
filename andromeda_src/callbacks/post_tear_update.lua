local Spode = require("andromeda_src.misc.spode")

local function MC_POST_TEAR_UPDATE(_, tear)
	Spode.postTearUpdate(tear)
end

return MC_POST_TEAR_UPDATE