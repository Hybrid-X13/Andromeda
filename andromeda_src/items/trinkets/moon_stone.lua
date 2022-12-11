local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Trinket = {}

function Trinket.postNewRoom()
	local room = game:GetRoom()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.MOON_STONE)
		and (room:GetType() == RoomType.ROOM_PLANETARIUM or Functions.IsAbandonedPlanetarium())
		and room:IsFirstVisit()
		then
			local rng = player:GetTrinketRNG(Enums.Trinkets.MOON_STONE)
			local runeSeed = rng:RandomInt(1000) + 1
			local itemPool = game:GetItemPool()
			local rune = itemPool:GetCard(runeSeed, false, true, true)
			local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, pos, Vector.Zero, nil)
		end
	end
end

function Trinket.postPickupUpdate(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_CHEST
	and pickup.Variant ~= PickupVariant.PICKUP_BOMBCHEST
	and pickup.Variant ~= PickupVariant.PICKUP_SPIKEDCHEST
	and pickup.Variant ~= PickupVariant.PICKUP_ETERNALCHEST
	and pickup.Variant ~= PickupVariant.PICKUP_MIMICCHEST
	and pickup.Variant ~= PickupVariant.PICKUP_WOODENCHEST
	and pickup.Variant ~= PickupVariant.PICKUP_HAUNTEDCHEST
	and pickup.Variant ~= PickupVariant.PICKUP_LOCKEDCHEST
	then
		return
	end
	
	rng:SetSeed(pickup.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local sprite = pickup:GetSprite()
		
		if player:HasTrinket(Enums.Trinkets.MOON_STONE)
		or player:HasCollectible(Enums.Collectibles.PLUTONIUM)
		or player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM)
		then
			local randNum
			
			if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then
				randNum = rng:RandomInt(30)
			elseif player:HasCollectible(Enums.Collectibles.PLUTONIUM) then
				randNum = rng:RandomInt(60)
			else
				local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE)
				local rngMax = 60 / trinketMultiplier
				randNum = rng:RandomInt(rngMax)
			end
			
			if randNum < 6
			and sprite:IsPlaying("Open")
			and pickup:GetData().opened == nil
			then
				local itemPool = game:GetItemPool()
				local rune = itemPool:GetCard(pickup.InitSeed, false, true, true)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, pickup.Position, RandomVector() * 4, pickup)
				pickup:GetData().opened = true
			end
		end
	end
end

function Trinket.postPEffectUpdate(player)
	local room = game:GetRoom()
	local slots = Isaac.FindByType(EntityType.ENTITY_SLOT, -1)

	if player:HasTrinket(Enums.Trinkets.MOON_STONE)
	or player:HasCollectible(Enums.Collectibles.PLUTONIUM)
	or player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM)
	then
		for i = 0, room:GetGridSize() do
			local grid = room:GetGridEntity(i)

			if grid
			and grid:GetType() == GridEntityType.GRID_ROCKT
			and grid.State == 2
			and grid.VarData == 0
			then
				local rng = player:GetTrinketRNG(Enums.Trinkets.MOON_STONE)
				local runeSeed = rng:RandomInt(1000) + 1

				local randNum
			
				if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then
					randNum = rng:RandomInt(30)
				elseif player:HasCollectible(Enums.Collectibles.PLUTONIUM) then
					randNum = rng:RandomInt(60)
				else
					local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE)
					local rngMax = 60 / trinketMultiplier
					randNum = rng:RandomInt(rngMax)
				end

				if randNum < 6 then
					local itemPool = game:GetItemPool()
					local rune = itemPool:GetCard(runeSeed, false, true, true)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, grid.Position, RandomVector() * 4, nil)
				end
				grid.VarData = 9
			end
		end

		if #slots > 0 then
			for i = 1, #slots do
				local sprite = slots[i]:GetSprite()

				if sprite:IsPlaying("Broken")
				and slots[i]:GetData().destroyed == nil
				then
					local rng = player:GetTrinketRNG(Enums.Trinkets.MOON_STONE)
					local runeSeed = rng:RandomInt(1000) + 1
					local randNum
			
					if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then
						randNum = rng:RandomInt(30)
					elseif player:HasCollectible(Enums.Collectibles.PLUTONIUM) then
						randNum = rng:RandomInt(60)
					else
						local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE)
						local rngMax = 60 / trinketMultiplier
						randNum = rng:RandomInt(rngMax)
					end

					if randNum < 6 then
						local itemPool = game:GetItemPool()
						local rune = itemPool:GetCard(runeSeed, false, true, true)
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, slots[i].Position, RandomVector() * 4, nil)
					end
					slots[i]:GetData().destroyed = true
				end
			end
		end

		if player:IsExtraAnimationFinished() then
			local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE)

			if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
				trinketMultiplier = trinketMultiplier - 1
			end

			if (player:HasCollectible(Enums.Collectibles.BABY_PLUTO, true) or player:HasCollectible(Enums.Collectibles.PLUTONIUM, true))
			and (player:GetTrinket(0) == (Enums.Trinkets.MOON_STONE + TrinketType.TRINKET_GOLDEN_FLAG)
				or player:GetTrinket(1) == (Enums.Trinkets.MOON_STONE + TrinketType.TRINKET_GOLDEN_FLAG)
				or (trinketMultiplier > 1 and player:GetTrinket(0) ~= (Enums.Trinkets.MOON_STONE + TrinketType.TRINKET_GOLDEN_FLAG) and player:GetTrinket(1) ~= (Enums.Trinkets.MOON_STONE + TrinketType.TRINKET_GOLDEN_FLAG))
			)
			then
				game:GetHUD():ShowItemText("Mega Plutonium!")
				sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED)
				player:RemoveCollectible(Enums.Collectibles.BABY_PLUTO)
				player:RemoveCollectible(Enums.Collectibles.PLUTONIUM)
				player:AddCollectible(Enums.Collectibles.MEGA_PLUTONIUM)
				player:TryRemoveTrinket(Enums.Trinkets.MOON_STONE + TrinketType.TRINKET_GOLDEN_FLAG)
			elseif player:HasCollectible(Enums.Collectibles.BABY_PLUTO, true) then
				game:GetHUD():ShowItemText("Plutonium!")
				sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
				player:RemoveCollectible(Enums.Collectibles.BABY_PLUTO)
				player:AddCollectible(Enums.Collectibles.PLUTONIUM)
				player:TryRemoveTrinket(Enums.Trinkets.MOON_STONE)
			end
		end
	end
end

return Trinket