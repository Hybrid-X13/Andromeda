local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local ExtinctionEvent = require("andromeda_src.items.actives.extinction_event")

local function MC_POST_ENTITY_REMOVE(_, entity)
	T_Andromeda.postEntityRemove(entity)

	ExtinctionEvent.postEntityRemove(entity)
end

return MC_POST_ENTITY_REMOVE