local Singularity = require("andromeda_src.items.actives.singularity")

local function MC_USE_PILL(_, pill, player, flags)
	Singularity.usePill(pill, player, flags)
end

return MC_USE_PILL