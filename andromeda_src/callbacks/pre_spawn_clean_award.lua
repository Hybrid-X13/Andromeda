local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Polaris = require("andromeda_src.items.trinkets.polaris")

local function MC_PRE_SPAWN_CLEAN_AWARD()
	T_Andromeda.preSpawnCleanAward()
	
	Polaris.preSpawnCleanAward()
end

return MC_PRE_SPAWN_CLEAN_AWARD