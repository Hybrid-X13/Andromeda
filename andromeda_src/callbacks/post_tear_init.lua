local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_POST_TEAR_INIT(_, tear)
	Andromeda.postTearInit(tear)
	T_Andromeda.postTearInit(tear)

	Wisp.postTearInit(tear)
end

return MC_POST_TEAR_INIT