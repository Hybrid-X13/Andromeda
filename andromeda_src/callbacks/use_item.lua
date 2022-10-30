local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local GravityShift = require("andromeda_src.items.actives.gravity_shift")
local Singularity = require("andromeda_src.items.actives.singularity")
local ExtinctionEvent = require("andromeda_src.items.actives.extinction_event")
local BookOfCosmos = require("andromeda_src.items.actives.book_of_cosmos")
local Pallas = require("andromeda_src.items.passives.pallas")

local function MC_USE_ITEM(_, item, rng, player, flags, activeSlot, customVarData)
	local returned = Andromeda.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = T_Andromeda.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
	
	local returned = GravityShift.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
	
	local returned = Singularity.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = ExtinctionEvent.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = BookOfCosmos.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end

	local returned = Pallas.useItem(item, rng, player, flags, activeSlot, customVarData)
	if returned ~= nil then return returned end
end

return MC_USE_ITEM