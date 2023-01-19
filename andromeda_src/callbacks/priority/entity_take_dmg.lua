local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")

local function MC_ENTITY_TAKE_DMG(_, entity, amount, flags, source, countdown)
	local returned = Andromeda.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
	
	local returned = T_Andromeda.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
end

return MC_ENTITY_TAKE_DMG