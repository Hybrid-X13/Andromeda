local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemPool = game:GetItemPool()

local headCostume = Isaac.GetCostumeIdByPath("gfx/characters/character_andromeda_head.anm2")
local bodyCostume = Isaac.GetCostumeIdByPath("gfx/characters/character_andromeda_body.anm2")

local Stats = {
	Speed = 0,
	Tears = 1,
	DMG = 0.1,
	Range = 40,
	ShotSpeed = -100,
	Luck = 0,
	TearFlags = TearFlags.TEAR_NORMAL | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_ORBIT | TearFlags.TEAR_WAIT,
}

local Blacklist = {
	Items = {
		CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
		CollectibleType.COLLECTIBLE_EPIC_FETUS,
		CollectibleType.COLLECTIBLE_TRACTOR_BEAM,
		CollectibleType.COLLECTIBLE_BRITTLE_BONES,
	},
	Trinkets = {
		TrinketType.TRINKET_TELESCOPE_LENS,
		TrinketType.TRINKET_FRIENDSHIP_NECKLACE,
	}
}

local Character = {}

function Character.evaluateCache(player, cacheFlag)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage + (Stats.DMG * Functions.GetDamageMultiplier(player))
	end
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * Stats.Tears
	end
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + Stats.ShotSpeed
	end
	if cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + Stats.Range
	end
	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + Stats.Speed
	end
	if cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + Stats.Luck
	end
	if cacheFlag == CacheFlag.CACHE_TEARFLAG then
		player.TearFlags = player.TearFlags | Stats.TearFlags
	end
end

function Character.postPlayerInit(player)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local startRoomIndex = 84
	
	if game:GetFrameCount() == 0
	or roomIndex == startRoomIndex
	or level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX
	then
		for i = 1, #Blacklist.Items do
			itemPool:RemoveCollectible(Blacklist.Items[i])
		end
		for i = 1, #Blacklist.Trinkets do
			itemPool:RemoveTrinket(Blacklist.Trinkets[i])
		end
		for i = 1, #CustomData.AbPlPoolCopy do
			itemPool:RemoveCollectible(CustomData.AbPlPoolCopy[i])
		end
	
		player:AddNullCostume(headCostume)
		player:AddNullCostume(bodyCostume)
	end
end

function Character.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local gameSeed = game:GetSeeds()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
			if room:GetType() == RoomType.ROOM_TREASURE then
				if Functions.CheckTreasureRoom(roomIndex) then
					table.insert(SaveData.PlayerData.Andromeda.GravShift.Treasure, {roomIndex, false, false})
				end
				
				if not Functions.CheckAbandonedPlanetarium(roomIndex)
				and not Functions.CheckTreasureTaken(roomIndex)
				and not Functions.ContainsQuestItem()
				and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
				and room:IsFirstVisit()
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.GRAV_SHIFT_INDICATOR, 0, player.Position, Vector.Zero, player)
				end
				
				--Remove treasure room items if the abandoned planetarium was visited
				if Functions.CheckAbandonedPlanetarium(roomIndex) then
					Functions.RemoveAllCollectibles()
				end
			end

			if room:GetType() == RoomType.ROOM_PLANETARIUM then
				local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
				
				if SaveData.PlayerData.Andromeda.GravShift.Planetarium == 0
				and #items > 0
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.GRAV_SHIFT_INDICATOR, 0, player.Position, Vector.Zero, player)
				end

				if room:IsFirstVisit()
				and player:HasTrinket(Enums.Trinkets.ANDROMEDA_BIRTHCAKE)
				then
					local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.ANDROMEDA_BIRTHCAKE)
					local seed = gameSeed:GetStartSeed()
					local itemID
					local pos
					
					for i = 1, trinketMultiplier do
						if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
							local rng = player:GetTrinketRNG(Enums.Trinkets.ANDROMEDA_BIRTHCAKE)
							local pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
							seed = rng:RandomInt(999999999)
							itemID = itemPool:GetCollectible(pool, true, seed)
						else
							itemID = itemPool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, seed)
						end

						if #items > 0 then
							pos = Isaac.GetFreeNearPosition(items[1].Position, 40)

							for i = 1, #items do
								local item = items[i]:ToPickup()
								item.OptionsPickupIndex = 42
							end
						elseif #items == 0 then
							pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
						end

						local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, pos, Vector.Zero, nil):ToPickup()
						collectible.OptionsPickupIndex = 42
						Functions.StarBurst(player, collectible.Position)
					end
				end
			end
			
			--Change backdrop of rooms where Gravity Shift was used
			if room:GetType() == RoomType.ROOM_SHOP
			and SaveData.PlayerData.Andromeda.GravShift.Shop > 0
			then
				game:ShowHallucination(0, SaveData.PlayerData.Andromeda.GravShift.Shop)
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
			elseif room:GetType() == RoomType.ROOM_SECRET
			and SaveData.PlayerData.Andromeda.GravShift.Secret > 0
			then
				game:ShowHallucination(0, SaveData.PlayerData.Andromeda.GravShift.Secret)
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
			elseif room:GetType() == RoomType.ROOM_SUPERSECRET
			and SaveData.PlayerData.Andromeda.GravShift.SuperSecret > 0
			then
				game:ShowHallucination(0, SaveData.PlayerData.Andromeda.GravShift.SuperSecret)
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
			elseif room:GetType() == RoomType.ROOM_ANGEL
			and level:GetCurrentRoomIndex() ~= GridRooms.ROOM_ANGEL_SHOP_IDX
			and SaveData.PlayerData.Andromeda.GravShift.Angel > 0
			then
				game:ShowHallucination(0, SaveData.PlayerData.Andromeda.GravShift.Angel)
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
			elseif room:GetType() == RoomType.ROOM_DEVIL
			and SaveData.PlayerData.Andromeda.GravShift.Devil > 0
			then
				game:ShowHallucination(0, SaveData.PlayerData.Andromeda.GravShift.Devil)
				sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
			elseif room:GetType() == RoomType.ROOM_PLANETARIUM
			and SaveData.PlayerData.Andromeda.GravShift.Planetarium > 0
			then
				room:TurnGold()
				room:SetSlowDown(9999)
				gameSeed:AddSeedEffect(SeedEffect.SEED_ICE_PHYSICS)
			end
			
			if room:GetType() ~= RoomType.ROOM_PLANETARIUM
			and SaveData.PlayerData.Andromeda.GravShift.Planetarium > 0
			and gameSeed:HasSeedEffect(SeedEffect.SEED_ICE_PHYSICS)
			then
				gameSeed:RemoveSeedEffect(SeedEffect.SEED_ICE_PHYSICS)
			end
		end
	end
end

function Character.postNewLevel()
	if not Functions.AnyPlayerIsType(Enums.Characters.ANDROMEDA) then return end

	SaveData.PlayerData.Andromeda.GravShift = {
		Treasure = {},
		Shop = 0,
		Secret = 0,
		SuperSecret = 0,
		Angel = 0,
		Devil = 0,
		Planetarium = 0,
	}
end

function Character.entityTakeDmg(target, amount, flags, source, countdown)
	local player = target:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end
	
	local room = game:GetRoom()
	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local numStars = rng:RandomInt(4) + 2
	local totalHearts = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts()
		
	if player:GetEffectiveMaxHearts() < 1
	and player:GetEternalHearts() > 0
	then
		totalHearts = totalHearts + player:GetEternalHearts()
	end
	
	if not player:WillPlayerRevive()
	and amount >= totalHearts
	then
		room:MamaMegaExplosion(player.Position)
	end

	for i = 1, numStars do
		local randMulti = rng:RandomInt(3) + 4
		local pos = player.Position - Vector(0, player.Size * 2)
		local star = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.STARBURST_STAR_TRAIL, 0, pos, RandomVector() * randMulti, player)
		local sprite = star:GetSprite()
		local randNum = rng:RandomInt(5) + 1

		sprite:Play("Shiny " .. randNum)
		star.PositionOffset = player.PositionOffset
		star.SpriteScale = Vector(player.SpriteScale.X + 0.25, player.SpriteScale.Y + 0.25)
		star.DepthOffset = 1
		star.Color = Color(rng:RandomFloat(), rng:RandomFloat(), rng:RandomFloat(), 1, 0, 0, 0)
	end

	if player:HasTrinket(Enums.Trinkets.ANDROMEDA_BIRTHCAKE) then
		Functions.StarBurst(player, player.Position)
	end
end

function Character.preTearCollision(tear, collider, low)
	if not (tear:HasTearFlags(TearFlags.TEAR_ORBIT) or tear:HasTearFlags(TearFlags.TEAR_ORBIT_ADVANCED)) then return end
	if collider.Type ~= EntityType.ENTITY_BOMB then return end
	
	return true
end

function Character.postTearInit(tear)
	if tear.SpawnerEntity == nil then return end

	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	Functions.ChangeTear(tear, player)
end

function Character.postLaserUpdate(laser)
	if laser.SpawnerEntity == nil then return end
	
	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then return end
	if laser:GetData().isSolarFlare then return end
	
	Functions.ChangeLaserColor(laser, player)
end

function Character.postPickupInit(pickup)
	if not Functions.AnyPlayerIsType(Enums.Characters.ANDROMEDA) then return end
	
	rng:SetSeed(pickup.InitSeed, 35)
	local room = game:GetRoom()
	local roomType = room:GetType()

	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
	and pickup.SubType == Enums.Collectibles.GRAVITY_SHIFT
	then
		local seed = game:GetSeeds():GetStartSeed()
		local pool = itemPool:GetPoolForRoom(roomType, seed)
		
		if pool == ItemPoolType.POOL_NULL then
			pool = ItemPoolType.POOL_TREASURE
		end

		local newItem = itemPool:GetCollectible(pool, true, pickup.InitSeed)
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, false, false)
	end

	if pickup.Variant == PickupVariant.PICKUP_TRINKET then
		if pickup.SubType == TrinketType.TRINKET_TELESCOPE_LENS
		or pickup.SubType == (TrinketType.TRINKET_TELESCOPE_LENS + TrinketType.TRINKET_GOLDEN_FLAG)
		or pickup.SubType == TrinketType.TRINKET_FRIENDSHIP_NECKLACE
		or pickup.SubType == (TrinketType.TRINKET_FRIENDSHIP_NECKLACE + TrinketType.TRINKET_GOLDEN_FLAG)
		then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, true, false, false)
		end
	end
end

function Character.prePickupCollision(pickup, collider, low)
	if pickup.SubType == 0 then return end
	
	local player = collider:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end
	if player:IsCoopGhost() or (player.SubType == 59 and player.Parent ~= nil) then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()

	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
	and Functions.CanPickUpItem(player, pickup)
	then
		if room:GetType() == RoomType.ROOM_TREASURE
		and not Functions.CheckTreasureTaken(roomIndex)
		then
			Functions.SetTreasureRoom(roomIndex, "treasure taken")
		elseif room:GetType() == RoomType.ROOM_SHOP
		and pickup.Price ~= 0
		and SaveData.PlayerData.Andromeda.GravShift.Shop == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Shop = -1
		elseif room:GetType() == RoomType.ROOM_ANGEL
		and pickup.Price <= 0
		and SaveData.PlayerData.Andromeda.GravShift.Angel == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Angel = -1
		elseif room:GetType() == RoomType.ROOM_DEVIL
		and pickup.Price ~= 0
		and SaveData.PlayerData.Andromeda.GravShift.Devil == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Devil = -1
		elseif room:GetType() == RoomType.ROOM_PLANETARIUM
		and SaveData.PlayerData.Andromeda.GravShift.Planetarium == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Planetarium = -1
		end
	else
		if room:GetType() == RoomType.ROOM_SHOP
		and pickup.Price ~= 0
		and player:GetNumCoins() >= pickup.Price
		and not player:IsHoldingItem()
		and SaveData.PlayerData.Andromeda.GravShift.Shop == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Shop = -1
		end
	end
end

function Character.postPEffectUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end
	if player:HasCurseMistEffect() then return end
	if player:IsCoopGhost() then return end
	if player.Parent then return end

	if player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= Enums.Collectibles.GRAVITY_SHIFT then
		player:SetPocketActiveItem(Enums.Collectibles.GRAVITY_SHIFT, ActiveSlot.SLOT_POCKET, false)
	end
	
	if not player:HasTrinket(TrinketType.TRINKET_TELESCOPE_LENS, false) then
		Functions.AddSmeltedTrinket(player, TrinketType.TRINKET_TELESCOPE_LENS)
	end
	
	if not player:HasTrinket(TrinketType.TRINKET_FRIENDSHIP_NECKLACE, false) then
		Functions.AddSmeltedTrinket(player, TrinketType.TRINKET_FRIENDSHIP_NECKLACE)
	end
end

function Character.postPlayerUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	local hearts = player:GetMaxHearts()
	local boneHearts = player:GetBoneHearts()

	if boneHearts > 0 then
		player:AddBoneHearts(-boneHearts)
		player:AddBlackHearts(boneHearts * 2)
	end

	if hearts > 0 then
		player:AddMaxHearts(-hearts)
		player:AddSoulHearts(hearts)
	end
end

function Character.postEffectUpdate(effect)
	if effect.SpawnerEntity == nil then return end

	local player = effect.SpawnerEntity:ToPlayer()

  	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	
	if effect.Variant == Enums.Effects.GRAV_SHIFT_INDICATOR then
		effect:FollowParent(player)
		effect.SortingLayer = SortingLayer.SORTING_BACKGROUND

		if (room:GetType() == RoomType.ROOM_TREASURE and (Functions.CheckAbandonedPlanetarium(roomIndex) or Functions.CheckTreasureTaken(roomIndex)))
		or (room:GetType() == RoomType.ROOM_PLANETARIUM and SaveData.PlayerData.Andromeda.GravShift.Planetarium ~= 0)
		then
			effect:Remove()
		end
	elseif (effect.Variant == EffectVariant.BRIMSTONE_SWIRL or effect.Variant == EffectVariant.TECH_DOT)
	and not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
	then
		Functions.ChangeLaserColor(effect, player)
	end
end

function Character.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end
	if item ~= CollectibleType.COLLECTIBLE_CLICKER then return end
	
	player:TryRemoveNullCostume(headCostume)
	player:TryRemoveNullCostume(bodyCostume)
end

function Character.useItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()

	if item == CollectibleType.COLLECTIBLE_D4
	or item == CollectibleType.COLLECTIBLE_D100
	then
		player:AddNullCostume(headCostume)
		player:AddNullCostume(bodyCostume)
	elseif item == CollectibleType.COLLECTIBLE_COUPON then
		if room:GetType() == RoomType.ROOM_SHOP
		and SaveData.PlayerData.Andromeda.GravShift.Shop == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Shop = -1
		elseif room:GetType() == RoomType.ROOM_DEVIL
		and SaveData.PlayerData.Andromeda.GravShift.Devil == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Devil = -1
		end
	elseif item == CollectibleType.COLLECTIBLE_VOID
	or item == CollectibleType.COLLECTIBLE_ABYSS
	or item == Isaac.GetItemIdByName("Quasar")
	then
		if room:GetType() == RoomType.ROOM_TREASURE
		and not Functions.CheckTreasureTaken(roomIndex)
		then
			Functions.SetTreasureRoom(roomIndex, "treasure taken")
		elseif room:GetType() == RoomType.ROOM_PLANETARIUM
		and SaveData.PlayerData.Andromeda.GravShift.Planetarium == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Planetarium = -1
		end
	end
end

function Character.useCard(card, player, flag)
	if player:GetPlayerType() ~= Enums.Characters.ANDROMEDA then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()

	if card == Card.CARD_CREDIT then
		if room:GetType() == RoomType.ROOM_SHOP
		and SaveData.PlayerData.Andromeda.GravShift.Shop == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Shop = -1
		elseif room:GetType() == RoomType.ROOM_DEVIL
		and SaveData.PlayerData.Andromeda.GravShift.Devil == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Devil = -1
		end
	elseif card == Card.RUNE_BLACK
	or card == Enums.Cards.ALPHA_CENTAURI
	or card == Isaac.GetCardIdByName("Red Rune")
	then
		if room:GetType() == RoomType.ROOM_TREASURE
		and not Functions.CheckTreasureTaken(roomIndex)
		then
			Functions.SetTreasureRoom(roomIndex, "treasure taken")
		elseif room:GetType() == RoomType.ROOM_PLANETARIUM
		and SaveData.PlayerData.Andromeda.GravShift.Planetarium == 0
		then
			SaveData.PlayerData.Andromeda.GravShift.Planetarium = -1
		end
	end
end

return Character
