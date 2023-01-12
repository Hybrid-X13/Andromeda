local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local CustomData = require("andromeda_src.customdata")
local extraItems = {
	Enums.Collectibles.BABY_PLUTO,
	Enums.Collectibles.PLUTONIUM,
	Enums.Collectibles.MEGA_PLUTONIUM,
	Enums.Collectibles.BOOK_OF_COSMOS,
}

local Trinket = {}

function Trinket.evaluateCache(player, cacheFlag)
	if not player:HasTrinket(Enums.Trinkets.CRYING_PEBBLE) then return end
	
	local itemCount = 0
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.CRYING_PEBBLE)
		
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
	
	if cacheFlag == CacheFlag.CACHE_DAMAGE
	and (player:HasCollectible(Enums.Collectibles.PLUTONIUM) or player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM))
	then
		local dmg = 0.3

		if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then
			dmg = 0.6
		end

		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (dmg * trinketMultiplier * itemCount * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (dmg * trinketMultiplier * itemCount * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (dmg * trinketMultiplier * itemCount * 0.8)
		else
			player.Damage = player.Damage + (dmg * trinketMultiplier * itemCount)
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