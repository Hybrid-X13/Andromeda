local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local rewinding = false
local shiftIndex = 0

local backdrops = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,22,23,24,25,26,30,31,32,33,34,36,37,38,39,40,41,42,43,44,45,46,47,48,49,51,54}

local Item = {}

function Item.postPlayerInit(player)
	rewinding = false
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.GRAVITY_SHIFT then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local tears = Isaac.FindByType(EntityType.ENTITY_TEAR, -1)
	local projectiles = Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1)
	
	if #tears > 0 then
		for _, tear in pairs(tears) do
			local tear = tear:ToTear()
			tear.Velocity = Vector.Zero
			tear.WaitFrames = 0
			tear:ClearTearFlags(TearFlags.TEAR_ORBIT | TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_ORBIT_ADVANCED)

			if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
				tear.FallingSpeed = tear.FallingSpeed - 1.5
			end

			local sprite = tear:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
			sprite:LoadGraphics()
		end
	end
	
	if #projectiles > 0 then
		for _, projectile in pairs(projectiles) do
			local projectile = projectile:ToProjectile()
			projectile.Velocity = Vector.Zero
			projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)

			if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
				projectile.FallingSpeed = projectile.FallingSpeed - 1.5
			end

			local sprite = projectile:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
			sprite:LoadGraphics()
		end
	end
	
	--Andromeda's room-changing effects
	if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
		local roomIndex = level:GetCurrentRoomIndex()

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
		and activeSlot == ActiveSlot.SLOT_POCKET
		then
			player:AddWisp(Enums.Collectibles.GRAVITY_SHIFT, player.Position, false)
			sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
		end
		
		--Rewind to keep planetarium chance intact
		if room:GetType() == RoomType.ROOM_TREASURE
		and room:IsFirstVisit()
		and not Functions.CheckAbandonedPlanetarium(roomIndex)
		and not Functions.CheckTreasureTaken(roomIndex)
		and not Functions.ContainsQuestItem()
		and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
		then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false)
			Functions.SetTreasureRoom(roomIndex, "abandoned planetarium")
			rewinding = true
			shiftIndex = roomIndex
		end

		if not room:IsClear() then return true end
			
		--Replace all shop items with a treasure room item that costs 30 cents
		if room:GetType() == RoomType.ROOM_SHOP
		and not game:IsGreedMode()
		then
			local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
			local shopItems = {}
			local pool = ItemPoolType.POOL_TREASURE
			local seed = game:GetSeeds():GetStartSeed()
			
			if #pickups > 0 then
				for _, j in pairs(pickups) do
					local pickup = j:ToPickup()
					
					if pickup.Price ~= 0 then
						table.insert(shopItems, pickup)
					end
				end
			end
			
			if #shopItems > 0
			and SaveData.PlayerData.Andromeda.GravShift.Shop == 0
			then
				local restock = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.RESTOCK)
				local donation = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.DONATION)
				local backdrop = rng:RandomInt(#backdrops) + 1
				
				for _, shopItem in pairs(shopItems) do
					shopItem:Remove()
				end
				
				if #restock > 0 then
					for _, restockBox in pairs(restock) do
						restockBox:Remove()
					end
				end

				if #donation > 0 then
					for _, donationMachine in pairs(donation) do
						donationMachine:Remove()
					end
				end
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
					pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
					seed = rng:RandomInt(999999999)
				end
				
				local itemID = game:GetItemPool():GetCollectible(pool, true, seed)
				local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, room:GetCenterPos(), Vector.Zero, nil)
				local pickup = collectible:ToPickup()
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH) then
					pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
				else
					pickup.Price = math.floor(30 / (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) + 1))
				end
				
				pickup.AutoUpdatePrice = false
				pickup.ShopItemId = -1
				game:ShowHallucination(0, backdrops[backdrop])
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
				sfx:Play(SoundEffect.SOUND_MIRROR_EXIT)
				SaveData.PlayerData.Andromeda.GravShift.Shop = backdrops[backdrop]
			end
		end

		--Convert secret/super secret pickups into wisps
		if (room:GetType() == RoomType.ROOM_SECRET and SaveData.PlayerData.Andromeda.GravShift.Secret == 0)
		or (room:GetType() == RoomType.ROOM_SUPERSECRET and SaveData.PlayerData.Andromeda.GravShift.SuperSecret == 0)
		then
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
			local backdrop = rng:RandomInt(#backdrops) + 1
			
			if #items > 0 then
				for _, j in pairs(items) do
					local pickup = j:ToPickup()

					if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
					and pickup.SubType > 0
					then
						for i = 1, 5 do
							if room:GetType() == RoomType.ROOM_SUPERSECRET then
								Functions.GetRandomWisp(player, pickup.Position, player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES))
							else
								player:AddWisp(0, pickup.Position, true, false)
							end
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
							pickup:Remove()
						end
					elseif pickup.Variant == PickupVariant.PICKUP_HEART
					or pickup.Variant == PickupVariant.PICKUP_COIN
					or pickup.Variant == PickupVariant.PICKUP_KEY
					or pickup.Variant == PickupVariant.PICKUP_BOMB
					or pickup.Variant == PickupVariant.PICKUP_GRAB_BAG
					or pickup.Variant == PickupVariant.PICKUP_PILL
					or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
					or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
					or pickup.Variant == PickupVariant.PICKUP_TRINKET
					or (((pickup.Variant >= PickupVariant.PICKUP_CHEST and pickup.Variant <= PickupVariant.PICKUP_LOCKEDCHEST) or pickup.Variant == PickupVariant.PICKUP_REDCHEST) and pickup.SubType == ChestSubType.CHEST_CLOSED)
					then
						local randNum = rng:RandomInt(2)
						
						if randNum == 0 then
							if room:GetType() == RoomType.ROOM_SUPERSECRET then
								Functions.GetRandomWisp(player, pickup.Position, player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES))
							else
								player:AddWisp(0, pickup.Position, true, false)
							end
						end
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
						pickup:Remove()
					end
				end
				
				game:ShowHallucination(0, backdrops[backdrop])
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
				sfx:Play(SoundEffect.SOUND_MIRROR_EXIT)

				if room:GetType() == RoomType.ROOM_SUPERSECRET then
					SaveData.PlayerData.Andromeda.GravShift.SuperSecret = backdrops[backdrop]
				else
					SaveData.PlayerData.Andromeda.GravShift.Secret = backdrops[backdrop]
				end
			end
		end
	
		--Gain 2 Bible wisps for each angel item in the room
		if room:GetType() == RoomType.ROOM_ANGEL
		and SaveData.PlayerData.Andromeda.GravShift.Angel == 0
		then
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			local backdrop = rng:RandomInt(#backdrops) + 1
			
			if #items > 0 then
				for _, collectible in pairs(items) do
					if collectible.SubType > 0 then
						player:AddWisp(CollectibleType.COLLECTIBLE_BIBLE, collectible.Position, true, false)
						player:AddWisp(CollectibleType.COLLECTIBLE_BIBLE, collectible.Position, true, false)
						collectible:Remove()
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, collectible.Position, Vector.Zero, collectible)
					end
				end
				
				game:ShowHallucination(0, backdrops[backdrop])
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
				sfx:Play(SoundEffect.SOUND_MIRROR_EXIT)
				SaveData.PlayerData.Andromeda.GravShift.Angel = backdrops[backdrop]
			end
		end
			
		--Gain 3 Book of Belial wisps for each devil deal, but also remove a soul heart for each item
		if room:GetType() == RoomType.ROOM_DEVIL
		and SaveData.PlayerData.Andromeda.GravShift.Devil == 0
		then
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			local backdrop = rng:RandomInt(#backdrops) + 1
			
			if #items > 0 then
				for _, j in pairs(items) do
					local pickup = j:ToPickup()

					if pickup.Price ~= 0
					and pickup.SubType > 0
					then
						for i = 1, 3 do
							player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, pickup.Position, true, false)
						end
						
						player:AddSoulHearts(-2)
						pickup:Remove()
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
					end
				end
				
				game:ShowHallucination(0, backdrops[backdrop])
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
				sfx:Play(SoundEffect.SOUND_MIRROR_EXIT)
				SaveData.PlayerData.Andromeda.GravShift.Devil = backdrops[backdrop]
			end
		end

		--Gain Lemegeton wisp and give a choice between 4 treasure room items
		if room:GetType() == RoomType.ROOM_PLANETARIUM
		and SaveData.PlayerData.Andromeda.GravShift.Planetarium == 0
		then
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			local gameSeed = game:GetSeeds()
			
			if #items > 0 then
				for _, collectible in pairs(items) do
					if collectible.SubType > 0 then
						player:UseActiveItem(CollectibleType.COLLECTIBLE_LEMEGETON, false)
						collectible:Remove()
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, collectible.Position, Vector.Zero, collectible)
					end
				end
				
				for i = 1, 4 do
					local pool = ItemPoolType.POOL_TREASURE
					local seed = game:GetSeeds():GetStartSeed()
					local positions = {Vector(280, 240), Vector(360, 240), Vector(280, 320), Vector(360, 320)}
					
					if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
						pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
						seed = rng:RandomInt(999999999)
					end
					
					local itemID = game:GetItemPool():GetCollectible(pool, true, seed)
					local pos = room:FindFreePickupSpawnPosition(positions[i], 0)
					local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, pos, Vector.Zero, nil)
					local pickup = collectible:ToPickup()
					pickup.OptionsPickupIndex = 1
				end
				
				room:TurnGold()
				room:SetSlowDown(9999)
				gameSeed:AddSeedEffect(SeedEffect.SEED_ICE_PHYSICS)
				sfx:Play(SoundEffect.SOUND_MIRROR_EXIT)
				SaveData.PlayerData.Andromeda.GravShift.Planetarium = 1
			end
		end
	end
	return true
end

function Item.postPEffectUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end
	
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	
	--Teleport to abandoned planetarium
	if rewinding
	and roomIndex ~= shiftIndex
	then
		player:StopExtraAnimation()
		
		if (level:GetStage() ~= LevelStage.STAGE1_1 and not game:IsGreedMode())
		or (game:IsGreedMode() and shiftIndex ~= 98)
		then
			local hasStars = false
			
			for i = 0, 3 do
				if player:GetCard(i) == Card.CARD_STARS then
					player:SetCard(i, 0)
					hasStars = true
				end
			end

			if not hasStars then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY)
				and player:GetNumCoins() > 0
				then
					player:AddCoins(-1)
				elseif player:GetNumKeys() > 0
				and not player:HasGoldenKey()
				then
					player:AddKeys(-1)
				end
			end
		end
		
		--Go to normal planetarium instead if Andromeda has Birthright
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		and not game:IsGreedMode()
		then
			local rooms = {0, 1, 2, 3, 4, 5, 6, 9429}
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			local randNum = rng:RandomInt(#rooms) + 1
			Isaac.ExecuteCommand("goto s.planetarium." .. rooms[randNum])
		else
			Functions.GoToAbandonedPlanetarium(player, true, shiftIndex)
		end

		local data = level:GetRoomByIdx(GridRooms.ROOM_DEBUG_IDX, 0).Data
		local treasureDesc = level:GetRoomByIdx(shiftIndex, 0)
		treasureDesc.Data = data
		game:StartRoomTransition(shiftIndex, Direction.NO_DIRECTION, RoomTransitionAnim.FADE_MIRROR, player)

		rewinding = false
		shiftIndex = 0
	end
end

return Item