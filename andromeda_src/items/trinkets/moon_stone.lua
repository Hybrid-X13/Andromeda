local Enums = require("andromeda_src.enums")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local GOLDEN_MOON_STONE = Enums.Trinkets.MOON_STONE + TrinketType.TRINKET_GOLDEN_FLAG

local Trinket = {}

local function IsChest(pickup)
	if pickup.Variant == PickupVariant.PICKUP_CHEST
	or pickup.Variant == PickupVariant.PICKUP_BOMBCHEST
	or pickup.Variant == PickupVariant.PICKUP_SPIKEDCHEST
	or pickup.Variant == PickupVariant.PICKUP_ETERNALCHEST
	or pickup.Variant == PickupVariant.PICKUP_MIMICCHEST
	or pickup.Variant == PickupVariant.PICKUP_WOODENCHEST
	or pickup.Variant == PickupVariant.PICKUP_HAUNTEDCHEST
	or pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST
	then
		return true
	end

	return false
end

function Trinket.postNewRoom()
	local room = game:GetRoom()

	if not room:IsFirstVisit() then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.MOON_STONE)
		and (room:GetType() == RoomType.ROOM_PLANETARIUM or ANDROMEDA:IsAbandonedPlanetarium())
		then
			local itemPool = game:GetItemPool()
			local rng = player:GetTrinketRNG(Enums.Trinkets.MOON_STONE)
			local runeSeed = rng:RandomInt(1000) + 1
			local rune = itemPool:GetCard(runeSeed, false, true, true)
			local pos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, pos, Vector.Zero, nil)
		end
	end
end

function Trinket.postPickupUpdate(pickup)
	if not IsChest(pickup) then return end
	
	rng:SetSeed(pickup.InitSeed, 35)
	
	local sprite = pickup:GetSprite()

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.MOON_STONE)
		or player:HasCollectible(Enums.Collectibles.PLUTONIUM)
		or player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM)
		then
			local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE)
			local divisor = player:GetCollectibleNum(Enums.Collectibles.MEGA_PLUTONIUM) + player:GetCollectibleNum(Enums.Collectibles.PLUTONIUM) + trinketMultiplier
			local randFloat = rng:RandomFloat() / divisor
			
			if randFloat < 0.1
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
	if player:HasTrinket(Enums.Trinkets.MOON_STONE)
	or player:HasCollectible(Enums.Collectibles.PLUTONIUM)
	or player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM)
	then
		local room = game:GetRoom()
		local slots = Isaac.FindByType(EntityType.ENTITY_SLOT, -1)
		local rng = player:GetTrinketRNG(Enums.Trinkets.MOON_STONE)
		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE)
		local divisor = player:GetCollectibleNum(Enums.Collectibles.MEGA_PLUTONIUM) + player:GetCollectibleNum(Enums.Collectibles.PLUTONIUM) + trinketMultiplier

		for i = 0, room:GetGridSize() do
			local grid = room:GetGridEntity(i)

			if grid
			and grid:GetType() == GridEntityType.GRID_ROCKT
			and grid.State == 2
			and grid.VarData == 0
			then
				local randFloat = rng:RandomFloat() / divisor

				if randFloat < 0.1 then
					local itemPool = game:GetItemPool()
					local runeSeed = rng:RandomInt(1000) + 1
					local rune = itemPool:GetCard(runeSeed, false, true, true)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, grid.Position, RandomVector() * 4, nil)
				end
				grid.VarData = 9
			end
		end

		if #slots > 0 then
			for _, slot in pairs(slots) do
				local sprite = slot:GetSprite()

				if sprite:IsPlaying("Broken")
				and slot:GetData().destroyed == nil
				then
					local randFloat = rng:RandomFloat() / divisor

					if randFloat < 0.1 then
						local itemPool = game:GetItemPool()
						local runeSeed = rng:RandomInt(1000) + 1
						local rune = itemPool:GetCard(runeSeed, false, true, true)
						Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, slot.Position, RandomVector() * 4, nil)
					end
					slot:GetData().destroyed = true
				end
			end
		end

		if player:IsExtraAnimationFinished() then
			local moonStoneMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.MOON_STONE) - player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MOMS_BOX, true)

			if (player:HasCollectible(Enums.Collectibles.BABY_PLUTO, true) or player:HasCollectible(Enums.Collectibles.PLUTONIUM, true))
			and (
				player:GetTrinket(0) == GOLDEN_MOON_STONE
				or player:GetTrinket(1) == GOLDEN_MOON_STONE
				or (moonStoneMultiplier > 1 and player:GetTrinket(0) ~= GOLDEN_MOON_STONE and player:GetTrinket(1) ~= GOLDEN_MOON_STONE)
			)
			then
				game:GetHUD():ShowItemText("Mega Plutonium!")
				sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED)
				player:RemoveCollectible(Enums.Collectibles.BABY_PLUTO)
				player:RemoveCollectible(Enums.Collectibles.PLUTONIUM)
				player:AddCollectible(Enums.Collectibles.MEGA_PLUTONIUM)
				player:TryRemoveTrinket(GOLDEN_MOON_STONE)
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