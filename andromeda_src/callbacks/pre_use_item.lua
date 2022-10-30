local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Singularity = require("andromeda_src.items.actives.singularity")

local function MC_PRE_USE_ITEM(_, item, rng, player, flags, activeSlot, customVarData)
	local returned = Andromeda.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
	
	local returned = T_Andromeda.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = Singularity.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
end

return MC_PRE_USE_ITEM