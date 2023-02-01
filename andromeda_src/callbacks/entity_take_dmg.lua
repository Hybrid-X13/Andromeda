local BookOfCosmos = require("andromeda_src.items.actives.book_of_cosmos")
local Ceres = require("andromeda_src.items.passives.ceres")
local Vesta = require("andromeda_src.items.passives.vesta")
local Chiron = require("andromeda_src.items.passives.chiron")
local Wisp = require("andromeda_src.misc.custom_wisps")

local function MC_ENTITY_TAKE_DMG(_, entity, amount, flags, source, countdown)
	local returned = Vesta.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = Ceres.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
	
	local returned = Chiron.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
	
	local returned = BookOfCosmos.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = Wisp.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
end

return MC_ENTITY_TAKE_DMG