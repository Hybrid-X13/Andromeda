local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local getHeldPill = 0

local IsGoodPill = {
	[PillEffect.PILLEFFECT_HEALTH_UP] = true,
	[PillEffect.PILLEFFECT_RANGE_UP] = true,
	[PillEffect.PILLEFFECT_TEARS_UP] = true,
	[PillEffect.PILLEFFECT_LUCK_UP] = true,
	[PillEffect.PILLEFFECT_SPEED_UP] = true,
	[PillEffect.PILLEFFECT_SHOT_SPEED_UP] = true,
	[PillEffect.PILLEFFECT_BALLS_OF_STEEL] = true,
	[PillEffect.PILLEFFECT_SEE_FOREVER] = true,
	[PillEffect.PILLEFFECT_PERCS] = true,
	[PillEffect.PILLEFFECT_EXPERIMENTAL] = true,
	[PillEffect.PILLEFFECT_POWER] = true,
	[PillEffect.PILLEFFECT_GULP] = true,
	[PillEffect.PILLEFFECT_PRETTY_FLY] = true,
	[PillEffect.PILLEFFECT_FULL_HEALTH] = true,
	[PillEffect.PILLEFFECT_INFESTED_EXCLAMATION] = true,
	[PillEffect.PILLEFFECT_INFESTED_QUESTION] = true,
	[PillEffect.PILLEFFECT_SUNSHINE] = true,
}

local IsBadPill = {
	[PillEffect.PILLEFFECT_BAD_TRIP] = true,
	[PillEffect.PILLEFFECT_HEALTH_DOWN] = true,
	[PillEffect.PILLEFFECT_RANGE_DOWN] = true,
	[PillEffect.PILLEFFECT_SPEED_DOWN] = true,
	[PillEffect.PILLEFFECT_TEARS_DOWN] = true,
	[PillEffect.PILLEFFECT_LUCK_DOWN] = true,
	[PillEffect.PILLEFFECT_SHOT_SPEED_DOWN] = true,
	[PillEffect.PILLEFFECT_EXPERIMENTAL] = true,
	[PillEffect.PILLEFFECT_WIZARD] = true,
	[PillEffect.PILLEFFECT_AMNESIA] = true,
	[PillEffect.PILLEFFECT_PARALYSIS] = true,
	[PillEffect.PILLEFFECT_ADDICTED] = true,
	[PillEffect.PILLEFFECT_IM_EXCITED] = true,
	[PillEffect.PILLEFFECT_RETRO_VISION] = true,
	[PillEffect.PILLEFFECT_QUESTIONMARK] = true,
}

local IsBuffedCard = {
	[Card.CARD_MAGICIAN] = true,
	[Card.CARD_HIGH_PRIESTESS] = true,
	[Card.CARD_EMPRESS] = true,
	[Card.CARD_EMPEROR] = true,
	[Card.CARD_HIEROPHANT] = true,
	[Card.CARD_LOVERS] = true,
	[Card.CARD_CHARIOT] = true,
	[Card.CARD_JUSTICE] = true,
	[Card.CARD_HERMIT] = true,
	[Card.CARD_WHEEL_OF_FORTUNE] = true,
	[Card.CARD_STRENGTH] = true,
	[Card.CARD_DEATH] = true,
	[Card.CARD_TEMPERANCE] = true,
	[Card.CARD_DEVIL] = true,
	[Card.CARD_TOWER] = true,
	[Card.CARD_STARS] = true,
	[Card.CARD_SUN] = true,
	[Card.CARD_JUDGEMENT] = true,
	[Card.CARD_REVERSE_FOOL] = true,
	[Card.CARD_REVERSE_EMPRESS] = true,
	[Card.CARD_REVERSE_HIEROPHANT] = true,
	[Card.CARD_REVERSE_LOVERS] = true,
	[Card.CARD_REVERSE_JUSTICE] = true,
	[Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = true,
	[Card.CARD_REVERSE_HANGED_MAN] = true,
	[Card.CARD_REVERSE_TEMPERANCE] = true,
	[Card.CARD_REVERSE_TOWER] = true,
	[Card.CARD_REVERSE_STARS] = true,
	[Card.CARD_REVERSE_JUDGEMENT] = true,
	[Enums.Cards.THE_UNKNOWN] = true,
}

local Item = {}

local function SingularityPortal(pos)
	local portal = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, 0, pos, Vector.Zero, nil)
	local sprite = portal:GetSprite()
	portal.SpriteScale = Vector(1.5, 1.5)
	sprite.Color = Color(0, 0, 0, 1, 0, 0, 0)
	sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 1.3, 2, false, 0.5)
end

local function SingularityConditions()
	local room = game:GetRoom()
	local roomType = room:GetType()
	local level = game:GetLevel()
	local stageType = level:GetStageType()
	
	if game:IsGreedMode()
	and level:GetStage() < LevelStage.STAGE7_GREED
	then
		return true
	end

	--Rooms that always yield an item, regardless of floor (planetariums and secret rooms still have their restrictions)
	if roomType == RoomType.ROOM_ANGEL
	or roomType == RoomType.ROOM_DEVIL
	or roomType == RoomType.ROOM_PLANETARIUM
	or roomType == RoomType.ROOM_ERROR
	or roomType == RoomType.ROOM_BLACK_MARKET
	or roomType == RoomType.ROOM_LIBRARY
	or roomType == RoomType.ROOM_TREASURE
	or roomType == RoomType.ROOM_SHOP
	or roomType == RoomType.ROOM_SECRET
	or roomType == RoomType.ROOM_SUPERSECRET
	or ANDROMEDA:IsAbandonedPlanetarium()
	then
		return true
	end

	if level:GetStage() < LevelStage.STAGE4_1
	and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
	then
		return true
	end
	
	if roomType == RoomType.ROOM_BOSS
	and (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2)
	and not game:IsGreedMode()
	and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
	then
		if stageType == StageType.STAGETYPE_REPENTANCE
		and not room:IsClear()
		then
			return false
		else
			return true
		end
	end

	return false
end

local function IsModdedPickup(pickup)
	if pickup.Variant == PickupVariant.PICKUP_COIN then
		return pickup.SubType > CoinSubType.COIN_GOLDEN
	elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
		return pickup.SubType > BombSubType.BOMB_GIGA
	elseif pickup.Variant == PickupVariant.PICKUP_KEY then
		return pickup.SubType > KeySubType.KEY_CHARGED
	end
end

function Item.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if game:GetFrameCount() == 0 then return end
	if item ~= CollectibleType.COLLECTIBLE_SMELTER then return end
	if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then return end

	if player:GetTrinket(0) > 0
	and player:GetTrinket(1) > 0
	then
		Functions.ChargeSingularity(player, 2)
	elseif player:GetTrinket(0) > 0
	and player:GetTrinket(1) == 0
	then
		Functions.ChargeSingularity(player, 1)
	end
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if player:HasCollectible(Enums.Collectibles.SINGULARITY)
	and (item == CollectibleType.COLLECTIBLE_VOID or item == CollectibleType.COLLECTIBLE_ABYSS or item == Isaac.GetItemIdByName("Quasar"))
	then
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		if #items > 0 then
			Functions.ChargeSingularity(player, 6)
		end
	end

	if item ~= Enums.Collectibles.SINGULARITY then return end

	local room = game:GetRoom()
	local roomType = room:GetType()
	local level = game:GetLevel()
	local roomIdx = level:GetCurrentRoomIndex()
	local seed = rng:RandomInt(999999999)
	local pool = game:GetItemPool():GetPoolForRoom(roomType, seed)
	local numItems = 1
	local planetariumRNG = rng:RandomInt(100)
	local optionsIndex = rng:RandomInt(1000) + 1
	local forcePickup = false
	local randNum = rng:RandomInt(10)
	local spawnpos

	if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) then
		local slot
		local curCharge
		
		for i = 0, 2 do
			if player:GetActiveItem(i) == Enums.Collectibles.SINGULARITY then
				slot = i
			end
		end
		curCharge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
		
		if curCharge == 12 then
			Functions.ChargeSingularity(player, 1)
		end
	end
	
	--Spawn an item from the current room's pool
	if ((player:GetPlayerType() == Enums.Characters.T_ANDROMEDA and SingularityConditions()) or randNum == 0)
	and not forcePickup
	then
		local secretRNG = rng:RandomInt(100)

		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA
		and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
		and activeSlot == ActiveSlot.SLOT_POCKET
		then
			player:AddWisp(Enums.Collectibles.SINGULARITY, player.Position, false)
			sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
		end
		
		--Pull from treasure pool if room has no pool
		if pool == ItemPoolType.POOL_NULL then
			if game:IsGreedMode() then
				pool = ItemPoolType.POOL_GREED_TREASURE
			else
				pool = ItemPoolType.POOL_TREASURE
			end
		end
		
		if roomType == RoomType.ROOM_TREASURE then
			if Functions.IsGreedTreasureRoom() then
				pool = ItemPoolType.POOL_GREED_BOSS
			elseif player:HasTrinket(TrinketType.TRINKET_DEVILS_CROWN) then
				pool = ItemPoolType.POOL_DEVIL
			elseif player:HasTrinket(Isaac.GetTrinketIdByName("Angel's Crown")) then
				pool = ItemPoolType.POOL_ANGEL
			end
		elseif roomType == RoomType.ROOM_SHOP
		and player:HasTrinket(TrinketType.TRINKET_ADOPTION_PAPERS)
		then
			pool = ItemPoolType.POOL_BABY_SHOP
		end

		--Chance to spawn a secret room item is halved every time Singularity is used in there
		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
			spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
			
			if roomType == RoomType.ROOM_SECRET
			or roomType == RoomType.ROOM_SUPERSECRET
			then
				if secretRNG > SaveData.PlayerData.T_Andromeda.SecretChance then
					local collectible = game:GetItemPool():GetCollectible(pool, false, seed)
					local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
					
					--Loop until a passive item is chosen
					while itemConfig.Type == ItemType.ITEM_ACTIVE do
						seed = rng:RandomInt(999999999)
						collectible = game:GetItemPool():GetCollectible(pool, false, seed)
						itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
					end

					player:AddItemWisp(collectible, spawnpos, true)
					SingularityPortal(spawnpos)
					pool = ItemPoolType.POOL_NULL
				end
				SaveData.PlayerData.T_Andromeda.SecretChance = math.ceil(SaveData.PlayerData.T_Andromeda.SecretChance / 2)
			elseif roomType == RoomType.ROOM_PLANETARIUM then
				if SaveData.PlayerData.T_Andromeda.PlanetariumChance < 100
				and planetariumRNG > SaveData.PlayerData.T_Andromeda.PlanetariumChance
				then
					local wispID = game:GetItemPool():GetCollectible(pool, false, seed)
					player:AddItemWisp(wispID, spawnpos, true)
					SingularityPortal(spawnpos)
					pool = ItemPoolType.POOL_NULL
				end
				SaveData.PlayerData.T_Andromeda.PlanetariumChance = math.ceil(SaveData.PlayerData.T_Andromeda.PlanetariumChance / 2)
			elseif ANDROMEDA:IsAbandonedPlanetarium() then
				local wispID = ANDROMEDA:PullFromAbandonedPlanetariumPool(rng, false)
				player:AddItemWisp(wispID, spawnpos, true)
				SingularityPortal(spawnpos)
				pool = ItemPoolType.POOL_NULL
			end
		end
		
		if pool ~= ItemPoolType.POOL_NULL then
			--Synergies
			if player:HasCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS)
			and roomType == RoomType.ROOM_BOSS
			then
				numItems = numItems + 1
			end
			
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
			and (pool == ItemPoolType.POOL_TREASURE or pool == ItemPoolType.POOL_GREED_TREASURE or roomType == RoomType.ROOM_TREASURE)
			then
				numItems = numItems + 1
			end

			if player:HasTrinket(TrinketType.TRINKET_GOLDEN_HORSE_SHOE)
			and (pool == ItemPoolType.POOL_TREASURE or pool == ItemPoolType.POOL_GREED_TREASURE or roomType == RoomType.ROOM_TREASURE)
			then
				local trinketMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_GOLDEN_HORSE_SHOE)
				local rngMax = 60 / trinketMultiplier
				randNum = rng:RandomInt(rngMax)
				
				if randNum < 9 then
					numItems = numItems + 1
				end
			end
			
			if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS)
			or player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA
			or (player:GetPlayerType() == Enums.Characters.T_ANDROMEDA and not SingularityConditions())
			then
				pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
			end
			
			if roomType == RoomType.ROOM_ERROR then
				player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
			end
			
			for i = 1, numItems do
				spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
				local itemID = game:GetItemPool():GetCollectible(pool, true, seed)
				local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnpos, Vector.Zero, nil):ToPickup()
				
				if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA
				and roomType == RoomType.ROOM_TREASURE
				and not Functions.IsGreedTreasureRoom()
				then
					if player:HasTrinket(TrinketType.TRINKET_DEVILS_CROWN) then
						local trinketMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_DEVILS_CROWN)
						
						if trinketMultiplier > 3 then
							collectible.Price = 0
						elseif trinketMultiplier == 3 then
							collectible.Price = PickupPrice.PRICE_ONE_SOUL_HEART
							collectible.AutoUpdatePrice = false
						elseif trinketMultiplier == 2 then
							collectible.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS
							collectible.AutoUpdatePrice = false
						else
							collectible.Price = PickupPrice.PRICE_SOUL
						end
						collectible.ShopItemId = -1
					elseif player:HasTrinket(Isaac.GetTrinketIdByName("Angel's Crown")) then
						local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
						
						if itemConfig.DevilPrice == 2 then
							collectible.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
							collectible.AutoUpdatePrice = false
						else
							collectible.Price = 15
						end
						collectible.ShopItemId = -1
					end
				end
					
				if numItems > 1 then
					collectible.OptionsPickupIndex = optionsIndex
				end

				SingularityPortal(spawnpos)
			end
			
			if roomType == RoomType.ROOM_ERROR then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
			end
		end
	else --Spawn a random pickup or chest
		spawnpos = Isaac.GetFreeNearPosition(player.Position, 40)
		randNum = rng:RandomInt(9)
		
		if randNum == 0 then --Spawn coin
			local coinSubType = rng:RandomInt(7) + 1
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, coinSubType, spawnpos, Vector.Zero, nil)
		elseif randNum == 1 then --Spawn key
			local keySubType = rng:RandomInt(4) + 1
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, keySubType, spawnpos, Vector.Zero, nil)
		elseif randNum == 2 then --Spawn bomb
			local bombSubType = rng:RandomInt(7) + 1
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, bombSubType, spawnpos, Vector.Zero, nil)
		elseif randNum == 3 then --Spawn sack
			local sackSubType = rng:RandomInt(2) + 1
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, sackSubType, spawnpos, Vector.Zero, nil)
		elseif randNum == 4 then --Spawn card or rune
			local pool = game:GetItemPool()
			local cardType = rng:RandomInt(2)

			if cardType == 0 then
				local card = pool:GetCard(Random(), false, false, false)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, spawnpos, Vector.Zero, nil)
			else
				local rune = pool:GetCard(Random(), false, true, true)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, spawnpos, Vector.Zero, nil)
			end
		elseif randNum == 5 then --Spawn trinket
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, spawnpos, Vector.Zero, nil)
		elseif randNum == 6 then --Spawn pill
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, spawnpos, Vector.Zero, nil)
		elseif randNum == 7 then --Spawn heart
			local heartSubType = rng:RandomInt(12) + 1
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartSubType, spawnpos, Vector.Zero, nil)
		elseif randNum == 8 then --Spawn chest
			local chestType = {
				PickupVariant.PICKUP_CHEST,
				PickupVariant.PICKUP_BOMBCHEST,
				PickupVariant.PICKUP_SPIKEDCHEST,
				PickupVariant.PICKUP_ETERNALCHEST,
				PickupVariant.PICKUP_MIMICCHEST,
				PickupVariant.PICKUP_OLDCHEST,
				PickupVariant.PICKUP_WOODENCHEST,
				PickupVariant.PICKUP_MEGACHEST,
				PickupVariant.PICKUP_HAUNTEDCHEST,
				PickupVariant.PICKUP_LOCKEDCHEST,
				PickupVariant.PICKUP_REDCHEST,
			}
			randNum = rng:RandomInt(#chestType) + 1
			Isaac.Spawn(EntityType.ENTITY_PICKUP, chestType[randNum], 0, spawnpos, Vector.Zero, nil)
		end

		SingularityPortal(spawnpos)
	end
	return true
end

function Item.usePill(pill, player, flag)
	if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then return end
	if pill == PillEffect.PILLEFFECT_VURP then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end
	
	if pill == PillEffect.PILLEFFECT_48HOUR_ENERGY then
		if getHeldPill > PillColor.PILL_GIANT_FLAG then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) then
				Functions.ChargeSingularity(player, 8)
			else
				Functions.ChargeSingularity(player, 4)
			end
		else
			if player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) then
				Functions.ChargeSingularity(player, 4)
			else
				Functions.ChargeSingularity(player, 2)
			end
		end
	elseif getHeldPill == PillColor.PILL_GOLD
	or getHeldPill == PillColor.PILL_GOLD + PillColor.PILL_GIANT_FLAG
	then
		local rng = player:GetCollectibleRNG(Enums.Collectibles.SINGULARITY)
		local randNum = rng:RandomInt(2)
		
		if randNum == 0 then
			if getHeldPill == PillColor.PILL_GOLD + PillColor.PILL_GIANT_FLAG then
				if (player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) and IsGoodPill[pill])
				or (player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) and IsBadPill[pill])
				then
					Functions.ChargeSingularity(player, 4)
				else
					Functions.ChargeSingularity(player, 2)
				end
			else
				if (player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) and IsGoodPill[pill])
				or (player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) and IsBadPill[pill])
				then
					Functions.ChargeSingularity(player, 2)
				else
					Functions.ChargeSingularity(player, 1)
				end
			end
		end
	elseif getHeldPill > PillColor.PILL_GIANT_FLAG then
		if (player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) and IsGoodPill[pill])
		or (player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) and IsBadPill[pill])
		then
			Functions.ChargeSingularity(player, 4)
		else
			Functions.ChargeSingularity(player, 2)
		end
	else
		if (player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) and IsGoodPill[pill])
		or (player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) and IsBadPill[pill])
		then
			Functions.ChargeSingularity(player, 2)
		else
			Functions.ChargeSingularity(player, 1)
		end
	end
end

function Item.useCard(card, player, flag)
	if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end
	if flag & UseFlag.USE_OWNED ~= UseFlag.USE_OWNED then return end
	if card == Card.CARD_ANCIENT_RECALL then return end
	if card == Isaac.GetCardIdByName("Storage Battery") then return end
	if card == Isaac.GetCardIdByName("Storage Battery (1)") then return end
	if card == Isaac.GetCardIdByName("Storage Battery (2)") then return end
	if card == Isaac.GetCardIdByName("Storage Battery (Full)") then return end
	if card == Isaac.GetCardIdByName("Corroded Battery") then return end
	if card == Isaac.GetCardIdByName("Pot of Greed") then return end
	if card == Isaac.GetCardIdByName("Denial's D9") then return end

	if card == Isaac.GetCardIdByName("Quasar Shard") then
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)

		if #items > 0 then
			Functions.ChargeSingularity(player, 6)
		else
			Functions.ChargeSingularity(player, 1)
		end
	elseif card == Isaac.GetCardIdByName("Red Rune") then
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)

		if #items == 0 then
			Functions.ChargeSingularity(player, 1)
		end
	elseif card == Card.RUNE_BLACK
	or card == Enums.Cards.ALPHA_CENTAURI
	then
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)

		if #items > 0 then
			Functions.ChargeSingularity(player, 6)
		else
			Functions.ChargeSingularity(player, 1)
		end
	else
		if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH)
		and IsBuffedCard[card]
		then
			Functions.ChargeSingularity(player, 2)
		else
			Functions.ChargeSingularity(player, 1)
		end
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then return end

	getHeldPill = player:GetPill(0)

	if player:GetData().singularityHeartCounter == nil then
		player:GetData().singularityHeartCounter = 0
	end

	if player:GetData().singularityCoinCounter == nil then
		player:GetData().singularityCoinCounter = 0
	end

	if not player:HasTrinket(TrinketType.TRINKET_SAFETY_SCISSORS) then return end

	local bombBums = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.BOMB_BUM)

	if #bombBums == 0 then return end

	for _, beggar in pairs(bombBums) do
		local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
		local mamaMega = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION)

		for _, splosion in pairs(explosions) do
			local frame = splosion:GetSprite():GetFrame()

			if frame < 3 then
				local size = splosion.SpriteScale.X
				local nearby = Isaac.FindInRadius(splosion.Position, 75 * size)

				for _, ent in pairs(nearby) do
					if ent.Type == EntityType.ENTITY_SLOT
					and ent.Variant == Enums.Slots.BOMB_BUM
					then
						beggar:Kill()
						beggar:Remove()
						game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
					end
				end
			end
		end
		
		if #mamaMega > 0 then
			beggar:Kill()
			beggar:Remove()
			game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
		end
	end
end

function Item.prePickupCollision(pickup, collider, low)
	if pickup.Variant ~= PickupVariant.PICKUP_HEART and not IsModdedPickup(pickup) then return end
	if pickup.Wait ~= 0 then return end

	local player = collider:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then return end
	if player:IsCoopGhost() or (player.SubType == 59 and player.Parent ~= nil) then return end

	ANDROMEDA.player = player

	if (player:IsHoldingItem() and pickup.Price == 0)
	or (not player:IsHoldingItem() and player:GetNumCoins() >= pickup.Price)
	then
		for i = 1, #CustomData.SingularityPickups do
			if CustomData.SingularityPickups[i].Variant == pickup.Variant
			and CustomData.SingularityPickups[i].SubType == pickup.SubType
			and CustomData.SingularityPickups[i].CanPickUp()
			then
				if type(CustomData.SingularityPickups[i].NumCharges) == "number" then
					Functions.ChargeSingularity(player, CustomData.SingularityPickups[i].NumCharges)
				else
					Functions.ChargeSingularity(player, CustomData.SingularityPickups[i].NumCharges())
				end
				
				break
			elseif i == #CustomData.SingularityPickups
			and IsModdedPickup(pickup)
			then
				Functions.ChargeSingularity(player, 1)
				break
			end
		end
	end
end

--Items and vanilla pickups that aren't hearts need to be checked later to avoid mod conflicts
function Item.prePickupCollisionLate(pickup, collider, low)
	if pickup.SubType == 0 then return end
	if pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == CoinSubType.COIN_STICKYNICKEL then return end
	if pickup.Variant == PickupVariant.PICKUP_HEART then return end
	if IsModdedPickup(pickup) then return end
	
	local player = collider:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then return end
	if player:IsCoopGhost() or (player.SubType == 59 and player.Parent ~= nil) then return end

	ANDROMEDA.player = player

	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
		if Functions.CanPickUpItem(player, pickup) then
			for i = 1, #CustomData.SingularityPickups do
				if CustomData.SingularityPickups[i].Variant == pickup.Variant
				and CustomData.SingularityPickups[i].SubType == pickup.SubType
				and CustomData.SingularityPickups[i].CanPickUp()
				then
					if type(CustomData.SingularityPickups[i].NumCharges) == "number" then
						Functions.ChargeSingularity(player, CustomData.SingularityPickups[i].NumCharges)
					else
						Functions.ChargeSingularity(player, CustomData.SingularityPickups[i].NumCharges())
					end

					break
				end
			end
		end
	else
		if ((player:IsHoldingItem() and pickup.Price == 0) or (not player:IsHoldingItem() and player:GetNumCoins() >= pickup.Price))
		and pickup.Wait == 0
		then
			for i = 1, #CustomData.SingularityPickups do
				if CustomData.SingularityPickups[i].Variant == pickup.Variant
				and CustomData.SingularityPickups[i].SubType == pickup.SubType
				and CustomData.SingularityPickups[i].CanPickUp()
				then
					local extraCharge = 0
					
					if player:HasTrinket(TrinketType.TRINKET_CHARGED_PENNY)
					and pickup.Variant == PickupVariant.PICKUP_COIN
					then
						local trinketMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_CHARGED_PENNY)
						local coinValues = {1, 5, 10, 2, 1, 0, 1}
						local max = coinValues[pickup.SubType] * trinketMultiplier

						for i = 1, max do
							local rng = player:GetTrinketRNG(TrinketType.TRINKET_CHARGED_PENNY)
							local randNum = rng:RandomInt(6)

							if randNum == 0
							and extraCharge ~= 1
							then
								extraCharge = 1
							end
						end
					end
					
					if type(CustomData.SingularityPickups[i].NumCharges) == "number" then
						Functions.ChargeSingularity(player, CustomData.SingularityPickups[i].NumCharges)
					else
						Functions.ChargeSingularity(player, CustomData.SingularityPickups[i].NumCharges())
					end

					break
				end
			end
		end
	end
end

return Item