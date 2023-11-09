local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()
local bossRoomCleared = false
local frameCount = 0

local Trinket = {}

local function HasDealRoomSpawned()
	local room = game:GetRoom()
	
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		
		if door
		and (door.TargetRoomType == RoomType.ROOM_DEVIL or door.TargetRoomType == RoomType.ROOM_ANGEL)
		then
			return true
		end
	end

	return false
end

function Trinket.preSpawnCleanAward()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local room = game:GetRoom()
		
		if player:HasTrinket(Enums.Trinkets.POLARIS)
		and room:GetType() == RoomType.ROOM_BOSS
		and player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA
		then
			bossRoomCleared = true
			frameCount = game:GetFrameCount()
		end
	end
end

function Trinket.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end

	local room = game:GetRoom()

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:HasTrinket(Enums.Trinkets.POLARIS)
		and room:GetType() == RoomType.ROOM_BOSS
		and not room:IsClear()
		then
			pickup:GetData().dontMorph = true
		end
	end
end

function Trinket.postPEffectUpdate(player)
	if not player:HasTrinket(Enums.Trinkets.POLARIS) then return end
	if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then return end
	
	local room = game:GetRoom()
	local timer = frameCount + 4
	local gameFrame = game:GetFrameCount()
	local rng = player:GetTrinketRNG(Enums.Trinkets.POLARIS)
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.POLARIS)
	local maxRedHearts = player:GetEffectiveMaxHearts()
	
	if bossRoomCleared
	and timer == gameFrame
	and gameFrame > 4
	then
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		
		if not HasDealRoomSpawned()
		and #items > 0
		then
			for i = 1, #items do
				local collectible = items[i]:ToPickup()
				local seed = game:GetSeeds():GetStartSeed()
				local pool = {ItemPoolType.POOL_DEVIL, ItemPoolType.POOL_ANGEL}
				local randNum = rng:RandomInt(2) + 1
				local itemID = game:GetItemPool():GetCollectible(pool[randNum], true, seed)
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local devilPrice = itemConfig.DevilPrice
				
				if collectible.SubType > 0
				and not Isaac.GetItemConfig():GetCollectible(collectible.SubType):HasTags(ItemConfig.TAG_QUEST)
				and collectible:GetData().dontMorph == nil
				then
					collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, true, false, false)

					if trinketMultiplier == 1 then
						if randNum == 1 then
							if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
								collectible.Price = PickupPrice.PRICE_SOUL
							elseif Functions.IsKeeper(player)
							or player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH)
							then
								if devilPrice == 2 then
									collectible.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
								else
									collectible.Price = math.floor(15 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
								end
							elseif maxRedHearts > 0
							and not Functions.IsSoulHeartCharacter(player)
							then
								if devilPrice == 2
								and not player:HasTrinket(TrinketType.TRINKET_JUDAS_TONGUE)
								then
									if maxRedHearts >= 4 then
										collectible.Price = PickupPrice.PRICE_TWO_HEARTS
									else
										collectible.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
									end
								else
									collectible.Price = PickupPrice.PRICE_ONE_HEART
								end
							else
								if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
									if devilPrice == 2 then
										collectible.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
									else
										collectible.Price = PickupPrice.PRICE_ONE_SOUL_HEART
									end
								else
									collectible.Price = PickupPrice.PRICE_THREE_SOULHEARTS
								end
							end
						else
							if devilPrice == 2 then
								collectible.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
							else
								collectible.Price = math.floor(15 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
							end
						end

						collectible.ShopItemId = -1
						collectible.AutoUpdatePrice = false
					end
				end
			end
		end
		bossRoomCleared = false
		frameCount = 0
	end
	
	if room:GetType() == RoomType.ROOM_BOSS then
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		
		for _, j in pairs(items) do
			local collectible = j:ToPickup()
			
			if collectible.SubType > 0 then
				local itemID = collectible.SubType
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local devilPrice = itemConfig.DevilPrice
				
				--Check every scenario of current health and pickup price
				if collectible.Price < 0 then
					if player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
						collectible.Price = PickupPrice.PRICE_SOUL
					elseif maxRedHearts > 0
					and not Functions.IsSoulHeartCharacter(player)
					then
						if devilPrice == 2
						and not player:HasTrinket(TrinketType.TRINKET_JUDAS_TONGUE)
						then
							if maxRedHearts >= 4 then
								collectible.Price = PickupPrice.PRICE_TWO_HEARTS
							else
								collectible.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
							end
						else
							collectible.Price = PickupPrice.PRICE_ONE_HEART
						end
					else
						if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
							if devilPrice == 2 then
								collectible.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
							else
								collectible.Price = PickupPrice.PRICE_ONE_SOUL_HEART
							end
						else
							collectible.Price = PickupPrice.PRICE_THREE_SOULHEARTS
						end
					end

					collectible.ShopItemId = -1
					collectible.AutoUpdatePrice = false
				end
			end
		end
	end
end

return Trinket
