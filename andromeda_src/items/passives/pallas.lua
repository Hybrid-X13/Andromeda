local Enums = require("andromeda_src.enums")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local rng = RNG()

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.PALLAS) then return end
	if cacheFlag ~= CacheFlag.CACHE_DAMAGE then return end
	
	local itemNum = player:GetCollectibleNum(Enums.Collectibles.PALLAS)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		player.Damage = player.Damage + (0.2 * SaveData.ItemData.Pallas.newRoomDMG * 0.2 * itemNum)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
		player.Damage = player.Damage + (0.2 * SaveData.ItemData.Pallas.newRoomDMG * 0.3 * itemNum)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		player.Damage = player.Damage + (0.2 * SaveData.ItemData.Pallas.newRoomDMG * 0.8 * itemNum)
	else
		player.Damage = player.Damage + (0.2 * SaveData.ItemData.Pallas.newRoomDMG * itemNum)
	end
end

function Item.postNewRoom()
	local room = game:GetRoom()
	
	if not room:IsFirstVisit() then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasCollectible(Enums.Collectibles.PALLAS) then
			if room:GetType() == RoomType.ROOM_PLANETARIUM
			or room:GetType() == RoomType.ROOM_LIBRARY
			or room:GetType() == RoomType.ROOM_SECRET
			or room:GetType() == RoomType.ROOM_SUPERSECRET
			or room:GetType() == RoomType.ROOM_ULTRASECRET
			or ANDROMEDA:IsAbandonedPlanetarium()
			then
				SaveData.ItemData.Pallas.newRoomDMG = SaveData.ItemData.Pallas.newRoomDMG + 3
			elseif room:GetType() > RoomType.ROOM_DEFAULT then
				SaveData.ItemData.Pallas.newRoomDMG = SaveData.ItemData.Pallas.newRoomDMG + 2
			else
				SaveData.ItemData.Pallas.newRoomDMG = SaveData.ItemData.Pallas.newRoomDMG + 1
			end
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS then return end
	if SaveData.ItemData.Pallas.newRoomDMG == 0 then return end

	local room = game:GetRoom()

	if room:IsFirstVisit() then
		if room:GetType() == RoomType.ROOM_PLANETARIUM
		or room:GetType() == RoomType.ROOM_LIBRARY
		or room:GetType() == RoomType.ROOM_SECRET
		or room:GetType() == RoomType.ROOM_SUPERSECRET
		or room:GetType() == RoomType.ROOM_ULTRASECRET
		or ANDROMEDA:IsAbandonedPlanetarium()
		then
			SaveData.ItemData.Pallas.newRoomDMG = SaveData.ItemData.Pallas.newRoomDMG - 3
		elseif room:GetType() > RoomType.ROOM_DEFAULT then
			SaveData.ItemData.Pallas.newRoomDMG = SaveData.ItemData.Pallas.newRoomDMG - 2
		else
			SaveData.ItemData.Pallas.newRoomDMG = SaveData.ItemData.Pallas.newRoomDMG - 1
		end
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.PALLAS) then return end
	
	local level = game:GetLevel()
	
	if level:GetCurses() & LevelCurse.CURSE_OF_THE_LOST == LevelCurse.CURSE_OF_THE_LOST then
		level:RemoveCurses(LevelCurse.CURSE_OF_THE_LOST)
	end
end

return Item