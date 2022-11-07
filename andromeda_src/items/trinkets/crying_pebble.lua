local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local CustomData = require("andromeda_src.customdata")

local Trinket = {}

function Trinket.evaluateCache(player, cacheFlag)
	if not player:HasTrinket(Enums.Trinkets.CRYING_PEBBLE) then return end
	
	local itemCount = 0
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.CRYING_PEBBLE)
	local extraItems = {
		Enums.Collectibles.BABY_PLUTO,
		Enums.Collectibles.PLUTONIUM,
		Enums.Collectibles.MEGA_PLUTONIUM,
		Enums.Collectibles.BOOK_OF_COSMOS,
	}
		
	for i = 1, #CustomData.SpodeList do
		if player:HasCollectible(CustomData.SpodeList[i]) then
			itemCount = itemCount + player:GetCollectibleNum(CustomData.SpodeList[i])
		end
	end
	
	for i = 1, #extraItems do
		if player:HasCollectible(extraItems[i]) then
			itemCount = itemCount + player:GetCollectibleNum(extraItems[i])
		end
	end
	
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = Functions.TearsUp(player.MaxFireDelay, 0.35 * trinketMultiplier * itemCount)
	end
	
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
				player.Damage = player.Damage + (0.6 * trinketMultiplier * itemCount * 0.2)
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
				player.Damage = player.Damage + (0.6 * trinketMultiplier * itemCount * 0.33)
			else
				player.Damage = player.Damage + (0.6 * trinketMultiplier * itemCount)
			end
		elseif player:HasCollectible(Enums.Collectibles.PLUTONIUM) then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
				player.Damage = player.Damage + (0.3 * trinketMultiplier * itemCount * 0.2)
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
				player.Damage = player.Damage + (0.3 * trinketMultiplier * itemCount * 0.33)
			else
				player.Damage = player.Damage + (0.3 * trinketMultiplier * itemCount)
			end
		end
	end
end

function Trinket.postPEffectUpdate(player)
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	
	if player:HasTrinket(Enums.Trinkets.CRYING_PEBBLE) then
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	else
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end

return Trinket