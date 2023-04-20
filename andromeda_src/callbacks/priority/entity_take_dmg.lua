local Ophiuchus = require("andromeda_src.items.passives.ophiuchus")
local Juno = require("andromeda_src.items.passives.juno")
local Starburst = require("andromeda_src.items.passives.starburst")
local Locust = require("andromeda_src.misc.custom_locusts")

local function MC_ENTITY_TAKE_DMG(_, entity, amount, flags, source, countdown)
	local returned = Ophiuchus.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = Juno.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = Starburst.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end

	local returned = Locust.entityTakeDmg(entity, amount, flags, source, countdown)
	if returned ~= nil then return returned end
end

return MC_ENTITY_TAKE_DMG