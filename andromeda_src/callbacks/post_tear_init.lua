local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")

local function MC_POST_TEAR_INIT(_, tear)
	Andromeda.postTearInit(tear)
	T_Andromeda.postTearInit(tear)
end

return MC_POST_TEAR_INIT