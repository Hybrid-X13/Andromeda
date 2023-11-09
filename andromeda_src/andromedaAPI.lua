local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local CustomData = require("andromeda_src.customdata")
local game = Game()

--[[
	- Makes an item count towards the Spode transformation.
	- This should only be zodiac and planetarium items (passives only).
	- The 2nd argument is a boolean for whether or not Book of Cosmos can summon the zodiac/planetarium item wisp for the current room.
	- If the item would be useless for one room or it shouldn't be summonable, just ignore it or pass false. Otherwise pass true to add it to Book of Cosmos.
]]
function ANDROMEDA:AddToSpode(itemID, bookOfCosmos)
	if itemID < 733 then return end
	
	table.insert(CustomData.SpodeList, itemID)

	if bookOfCosmos == nil then
		bookOfCosmos = false
	end

	if bookOfCosmos then
		table.insert(CustomData.BookOfCosmosList, itemID)
	end
end

--[[
	- Adds an item to the Abandoned Planetarium pool and also the Wisp Wizard payout pool.
	- This should only be zodiac items.
]]
function ANDROMEDA:AddToAbandonedPlanetarium(itemID)
	if itemID < 733 then return end
	
	table.insert(CustomData.AbandonedPlanetariumPool, itemID)
end

--[[
	- Makes your custom pickup count towards charging Singularity when picked up.
	- You need to pass a table that has all the pickups you're adding, each with four keys:
		- Variant: The variant of your pickup.
		- SubType: The subtype of your pickup.
		- NumCharges: The number of charges the pickup should add to Singularity when collected. Can be a number or a function that returns an int.
		- CanPickUp: A function with the conditions for checking whether or not the player can collect your pickup when they collide with it.
	- Example:
		if ANDROMEDA then
			local pickupTable = {
				{
					Variant = PickupVariant.PICKUP_KEY,
					SubType = myPickup.SubType,
					NumCharges = 2,
					CanPickUp = function()
						return true
					end,
				},
				{
					Variant = PickupVariant.PICKUP_HEART,
					SubType = myPickup.SubType,
					NumCharges = function()
						if ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_MOMS_LOCKET) then
							return 2
						end

						return 1
					end,
					CanPickUp = function()
						return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
					end,
				},
			}

			ANDROMEDA:AddSingularityPickups(pickupTable)
		end

	- You can look at customdata.lua to get an idea of how many charges your pickup should add, which is mainly based on rarity of the pickup.
	- Batteries are the only pickups that don't add charges to Singularity.
	- Make sure you use ANDROMEDA.player when using any EntityPlayer functions.
]]
function ANDROMEDA:AddSingularityPickups(pickupTable)
	if type(pickupTable) ~= "table" then return end
	if #pickupTable == 0 then return end
	
	for _, pickup in pairs(pickupTable) do
		table.insert(CustomData.SingularityPickups, pickup)
	end
end

--[[
	- Teleports the player to an Abandoned Planetarium using the "goto" command.
	- Paramaters:
		- player: Player entity
		- itemLayoutChance: The chance of teleporting to a layout with an item (as a float). This won't take you to an item layout if the Abandoned Planetarium pool is empty.
		- includeSpecial: Allow the chance to teleport to a special layout. Special layouts offer much better and greater rewards than normal ones.
		- forceSpecial: Guaranteed to teleport to a special layout.
		- roomIdx: Only pass a room index if you're replacing/creating a room, that way it'll properly replace the room with a matching room shape.
]]
function ANDROMEDA:GoToAbandonedPlanetarium(player, itemLayoutChance, includeSpecial, forceSpecial, roomIdx)
	local rng = player:GetCollectibleRNG(Enums.Collectibles.GRAVITY_SHIFT)
	local level = game:GetLevel()
	local itemRoomIDs = {}
	local rewardRoomIDs = {}
	local randFloat = rng:RandomFloat()
	local isVerticalRoom = false
	local isHorizontalRoom = false

	if itemLayoutChance == nil then
		itemLayoutChance = 0.333
	end

	if roomIdx then
		if level:GetRoomByIdx(roomIdx, 0).Data.Shape == RoomShape.ROOMSHAPE_IV then
			isVerticalRoom = true
		elseif level:GetRoomByIdx(roomIdx, 0).Data.Shape == RoomShape.ROOMSHAPE_IH then
			isHorizontalRoom = true
		end
	end

	if not forceSpecial then
		if isVerticalRoom then
			for i = 4342, 4346 do
				table.insert(itemRoomIDs, i)
			end
			for i = 4542, 4546 do
				table.insert(rewardRoomIDs, i)
			end
		elseif isHorizontalRoom then
			for i = 4347, 4351 do
				table.insert(itemRoomIDs, i)
			end
			for i = 4547, 4551 do
				table.insert(rewardRoomIDs, i)
			end
		else
			--Normal rooms
			for i = 4242, 4281 do
				table.insert(itemRoomIDs, i)
			end
			for i = 4442, 4487 do
				table.insert(rewardRoomIDs, i)
			end

			--Closet rooms
			if roomIdx == nil then
				for i = 4342, 4351 do
					table.insert(itemRoomIDs, i)
				end
				for i = 4542, 4551 do
					table.insert(rewardRoomIDs, i)
				end
			end
		end
	end

	if forceSpecial
	or includeSpecial
	then
		if isVerticalRoom then
			table.insert(itemRoomIDs, 4853)
			table.insert(rewardRoomIDs, 4653)
		elseif isHorizontalRoom then
			table.insert(itemRoomIDs, 4854)
			table.insert(rewardRoomIDs, 4654)
		else
			--Normal rooms
			for i = 4842, 4852 do
				table.insert(itemRoomIDs, i)
			end
			for i = 4642, 4652 do
				table.insert(rewardRoomIDs, i)
			end

			--Closet rooms
			if roomIdx == nil then
				table.insert(itemRoomIDs, 4853)
				table.insert(itemRoomIDs, 4854)
				table.insert(rewardRoomIDs, 4653)
				table.insert(rewardRoomIDs, 4654)
			end
		end
	end

	if #CustomData.AbPlPoolCopy > 0
	and player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA
	and randFloat < itemLayoutChance
	then
		local randNum = rng:RandomInt(#itemRoomIDs) + 1
		Isaac.ExecuteCommand("goto s.dice." .. itemRoomIDs[randNum])
	else
		local randNum = rng:RandomInt(#rewardRoomIDs) + 1
		Isaac.ExecuteCommand("goto s.dice." .. rewardRoomIDs[randNum])
	end
end

--[[
	- Checks if the current room is the Abandoned Planetarium.
]]
function ANDROMEDA:IsAbandonedPlanetarium()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data
	local roomVariant = roomConfig.Variant

	if room:GetType() == RoomType.ROOM_DICE
	and roomVariant >= 4242
	and roomVariant < 4900
	then
		return true
	end

	return false
end

--[[
	- Checks if a certain item from this mod is unlocked.
	- Make sure to only use this function inside a callback instead of when your mod is loaded.
]]
function ANDROMEDA:IsItemUnlocked(itemID, variant)
	if variant == nil then
		variant = PickupVariant.PICKUP_COLLECTIBLE
	end

	if variant == PickupVariant.PICKUP_COLLECTIBLE then
		local unlocks = {
			[Enums.Collectibles.GRAVITY_SHIFT] = SaveData.UnlockData.Andromeda.BlueBaby,
			[Enums.Collectibles.EXTINCTION_EVENT] = SaveData.UnlockData.Andromeda.TheLamb,
			[Enums.Collectibles.CELESTIAL_CROWN] = SaveData.UnlockData.Andromeda.Hush,
			[Enums.Collectibles.BABY_PLUTO] = SaveData.UnlockData.Andromeda.MegaSatan,
			[Enums.Collectibles.HARMONIC_CONVERGENCE] = SaveData.UnlockData.Andromeda.Delirium,
			[Enums.Collectibles.JUNO] = SaveData.UnlockData.Andromeda.Mother,
			[Enums.Collectibles.PALLAS] = SaveData.UnlockData.Andromeda.Beast,
			[Enums.Collectibles.OPHIUCHUS] = SaveData.UnlockData.Andromeda.Greedier,
			[Enums.Collectibles.BOOK_OF_COSMOS] = SaveData.UnlockData.T_Andromeda.BlueBaby,
			[Enums.Collectibles.LUMINARY_FLARE] = SaveData.UnlockData.T_Andromeda.TheLamb,
			[Enums.Collectibles.SINGULARITY] = SaveData.UnlockData.T_Andromeda.Delirium,
			[Enums.Collectibles.CERES] = SaveData.UnlockData.T_Andromeda.Mother,
			[Enums.Collectibles.VESTA] = SaveData.UnlockData.T_Andromeda.Beast,
			[Enums.Collectibles.CHIRON] = Functions.HasFullCompletion(Enums.Characters.T_ANDROMEDA),
			[Enums.Collectibles.STARBURST] = SaveData.UnlockData.Secrets.Starburst,
		}

		return unlocks[itemID]
	elseif variant == PickupVariant.PICKUP_TRINKET then
		local unlocks = {
			[Enums.Trinkets.CRYING_PEBBLE] = SaveData.UnlockData.Andromeda.Isaac,
			[Enums.Trinkets.METEORITE] = SaveData.UnlockData.Andromeda.Satan,
			[Enums.Trinkets.STARDUST] = SaveData.UnlockData.Andromeda.Greed,
			[Enums.Trinkets.ALIEN_TRANSMITTER] = SaveData.UnlockData.T_Andromeda.Isaac,
			[Enums.Trinkets.MOON_STONE] = SaveData.UnlockData.T_Andromeda.Satan,
			[Enums.Trinkets.POLARIS] = SaveData.UnlockData.T_Andromeda.BossRush,
			[Enums.Trinkets.SEXTANT] = SaveData.UnlockData.T_Andromeda.Greed,
			[Enums.Trinkets.EYE_OF_SPODE] = SaveData.UnlockData.Secrets.EyeOfSpode,
		}

		return unlocks[itemID]
	elseif variant == PickupVariant.PICKUP_TAROTCARD then
		local unlocks = {
			[Enums.Cards.BETELGEUSE] = SaveData.UnlockData.Andromeda.BossRush,
			[Enums.Cards.ALPHA_CENTAURI] = SaveData.UnlockData.Andromeda.BossRush,
			[Enums.Cards.SIRIUS] = SaveData.UnlockData.T_Andromeda.BossRush,
			[Enums.Cards.SOUL_OF_ANDROMEDA] = SaveData.UnlockData.T_Andromeda.Hush,
			[Enums.Cards.THE_UNKNOWN] = SaveData.UnlockData.T_Andromeda.Greedier,
		}

		return unlocks[itemID]
	end
end

function ANDROMEDA:IsWispWizardUnlocked()
    return SaveData.UnlockData.T_Andromeda.MegaSatan
end

function ANDROMEDA:IsSpecialAbandonedPlanetarium()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data
	local roomVariant = roomConfig.Variant

	if room:GetType() == RoomType.ROOM_DICE
	and roomVariant >= 4642
	and roomVariant < 4855
	then
		return true
	end

	return false
end

--[[
	- Returns the item ID of an item from the Abandoned Planetarium pool.
	- Pass an RNG object and a boolean of whether to remove the item from the pool or not (defaults to true).
	- ignoreChaos: A boolean to ignore the effect of Chaos to guarantee an item is pulled from the Abandoned Planetarium pool (defaults to false).
]]
function ANDROMEDA:PullFromAbandonedPlanetariumPool(rng, decrease, ignoreChaos)
	local itemPool = game:GetItemPool()
	
	if decrease == nil then
		decrease = true
	end

	if ignoreChaos == nil then
		ignoreChaos = false
	end

	if #CustomData.AbPlPoolCopy > 0 then
		for i = 1, #CustomData.AbandonedPlanetariumPool do
			if Functions.AnyPlayerHasCollectible(CustomData.AbandonedPlanetariumPool[i], true) then
				for j = 1, #CustomData.AbPlPoolCopy do
					if CustomData.AbPlPoolCopy[j] == CustomData.AbandonedPlanetariumPool[i] then
						table.remove(CustomData.AbPlPoolCopy, j)
					end
				end
			end
		end
	end
	
	if Functions.AnyPlayerHasCollectible(CollectibleType.COLLECTIBLE_CHAOS)
	and not ignoreChaos
	then
		local pool = rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS)
		local seed = rng:RandomInt(999999999)

		return itemPool:GetCollectible(pool, decrease, seed)
	elseif #CustomData.AbPlPoolCopy == 0 then
		local pool = ItemPoolType.POOL_TREASURE
		local seed = game:GetSeeds():GetStartSeed()
		
		if game:IsGreedMode() then
			pool = ItemPoolType.POOL_GREED_TREASURE
		end
		
		return itemPool:GetCollectible(pool, decrease, seed)
	else
		local zodiac = rng:RandomInt(#CustomData.AbPlPoolCopy) + 1
		local itemID = CustomData.AbPlPoolCopy[zodiac]
	
		if decrease then
			itemPool:RemoveCollectible(CustomData.AbPlPoolCopy[zodiac])
			table.remove(CustomData.AbPlPoolCopy, zodiac)
		end
	
		return itemID
	end
end
