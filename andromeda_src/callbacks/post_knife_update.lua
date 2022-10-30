local AndromedaKnife = require("andromeda_src.items.passives.andromeda_knife")
local Spode = require("andromeda_src.misc.spode")

local function MC_POST_KNIFE_UPDATE(_, knife)
	AndromedaKnife.postKnifeUpdate(knife)

	Spode.postKnifeUpdate(knife)
end

return MC_POST_KNIFE_UPDATE