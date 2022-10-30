local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local WispWizard = require("andromeda_src.misc.wisp_wizard")

local function MC_PRE_ROOM_ENTITY_SPAWN(_, entity, variant, subType, gIndex, seed)
	local returned = T_Andromeda.preRoomEntitySpawn(entity, variant, subType, gIndex, seed)
	if returned ~= nil then return returned end

	local returned = WispWizard.preRoomEntitySpawn(entity, variant, subType, gIndex, seed)
	if returned ~= nil then return returned end
end

return MC_PRE_ROOM_ENTITY_SPAWN