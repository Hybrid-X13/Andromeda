local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local rng = RNG()
local Character = Enums.Characters
local Collectible = Enums.Collectibles
local Trinket = Enums.Trinkets
local Card = Enums.Cards
local blueBabyDead = false
local lambDead = false

local collectibleUnlocks = {
	[Collectible.GRAVITY_SHIFT] = {
		Unlock = "BlueBaby",
		Tainted = false,
	},
	[Collectible.EXTINCTION_EVENT] = {
		Unlock = "TheLamb",
		Tainted = false,
	},
	[Collectible.CELESTIAL_CROWN] = {
		Unlock = "Hush",
		Tainted = false,
	},
	[Collectible.BABY_PLUTO] = {
		Unlock = "MegaSatan",
		Tainted = false,
	},
	[Collectible.HARMONIC_CONVERGENCE] = {
		Unlock = "Delirium",
		Tainted = false,
	},
	[Collectible.JUNO] = {
		Unlock = "Mother",
		Tainted = false,
	},
	[Collectible.PALLAS] = {
		Unlock = "Beast",
		Tainted = false,
	},
	[Collectible.OPHIUCHUS] = {
		Unlock = "Greedier",
		Tainted = false,
	},
	[Collectible.BOOK_OF_COSMOS] = {
		Unlock = "BlueBaby",
		Tainted = true,
	},
	[Collectible.LUMINARY_FLARE] = {
		Unlock = "TheLamb",
		Tainted = true,
	},
	[Collectible.SINGULARITY] = {
		Unlock = "Delirium",
		Tainted = true,
	},
	[Collectible.CERES] = {
		Unlock = "Mother",
		Tainted = true,
	},
	[Collectible.VESTA] = {
		Unlock = "Beast",
		Tainted = true,
	},
	[Collectible.CHIRON] = {
		Special = function()
			return Functions.HasFullCompletion(Character.T_ANDROMEDA)
		end,
		Tainted = true,
	},
}

local trinketUnlocks = {
	[Trinket.CRYING_PEBBLE] = {
		Unlock = "Isaac",
		Tainted = false,
	},
	[Trinket.METEORITE] = {
		Unlock = "Satan",
		Tainted = false,
	},
	[Trinket.STARDUST] = {
		Unlock = "Greed",
		Tainted = false,
	},
	[Trinket.ALIEN_TRANSMITTER] = {
		Unlock = "Isaac",
		Tainted = true,
	},
	[Trinket.MOONSTONE] = {
		Unlock = "Satan",
		Tainted = true,
	},
	[Trinket.POLARIS] = {
		Unlock = "BossRush",
		Tainted = true,
	},
	[Trinket.SEXTANT] = {
		Unlock = "Greed",
		Tainted = true,
	},
}

local cardUnlocks = {
	[Card.BETELGEUSE] = {
		Unlock = "BossRush",
		Tainted = false,
	},
	[Card.ALPHA_CENTAURI] = {
		Unlock = "BossRush",
		Tainted = false,
	},
	[Card.SIRIUS] = {
		Unlock = "BossRush",
		Tainted = true,
	},
	[Card.SOUL_OF_ANDROMEDA] = {
		Unlock = "Hush",
		Tainted = true,
	},
	[Card.THE_UNKNOWN] = {
		Unlock = "Greedier",
		Tainted = true,
	},
}

local UnlockManager = {}

local function UpdateCompletion(str1, str2, tainted)
	if game:IsGreedMode() then
		if game.Difficulty == Difficulty.DIFFICULTY_GREED then
			if tainted then
				SaveData.UnlockData.T_Andromeda.Greed = true
			else
				SaveData.UnlockData.Andromeda.Greed = true
			end
			CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/andromeda_achievements/achievement_" .. str1 .. ".png")
		elseif game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then
			if tainted then
				SaveData.UnlockData.T_Andromeda.Greed = true
				SaveData.UnlockData.T_Andromeda.Greedier = true
			else
				SaveData.UnlockData.Andromeda.Greed = true
				SaveData.UnlockData.Andromeda.Greedier = true
			end
			CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/andromeda_achievements/achievement_" .. str1 .. ".png")
			CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/andromeda_achievements/achievement_" .. str2 .. ".png")
		end
	else
		CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/andromeda_achievements/achievement_" .. str1 .. ".png")
	end

	if not tainted
	and Functions.HasFullCompletion(Enums.Characters.ANDROMEDA)
	then
		CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/andromeda_achievements/achievement_worshipper.png")
	elseif tainted
	and Functions.HasFullCompletion(Enums.Characters.T_ANDROMEDA)
	then
		CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/andromeda_achievements/achievement_chiron.png")
	end

	SaveData.SaveModData()
end

function UnlockManager.postEntityKill(entity)
	if game.Challenge > 0 then return end
	if game:GetVictoryLap() > 0 then return end
	if entity.Type ~= EntityType.ENTITY_BEAST then return end
	if entity.Variant ~= 0 then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		
		if playerType == Character.ANDROMEDA
		or playerType == Character.T_ANDROMEDA
		then
			if playerType == Character.ANDROMEDA
			and not SaveData.UnlockData.Andromeda.Beast
			then
				SaveData.UnlockData.Andromeda.Beast = true
				UpdateCompletion("pallas", "", false)
			elseif playerType == Character.T_ANDROMEDA
			and not SaveData.UnlockData.T_Andromeda.Beast
			then
				SaveData.UnlockData.T_Andromeda.Beast = true
				UpdateCompletion("vesta", "", true)
			end
		end
	end
end

function UnlockManager.postNPCDeath(npc)
	if game.Challenge > 0 then return end
	if game:GetVictoryLap() > 0 then return end

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		local level = game:GetLevel()
		local levelStage = level:GetStage()

		if playerType == Character.ANDROMEDA
		or playerType == Character.T_ANDROMEDA
		then
			if levelStage == LevelStage.STAGE5 then
				if npc.Type == EntityType.ENTITY_ISAAC then
					if playerType == Character.ANDROMEDA
					and not SaveData.UnlockData.Andromeda.Isaac
					then
						SaveData.UnlockData.Andromeda.Isaac = true
						UpdateCompletion("cryingpebble", "", false)
					elseif playerType == Character.T_ANDROMEDA
					and not SaveData.UnlockData.T_Andromeda.Isaac
					then
						SaveData.UnlockData.T_Andromeda.Isaac = true
						UpdateCompletion("alientransmitter", "", true)
					end
				elseif npc.Type == EntityType.ENTITY_SATAN then
					if playerType == Character.ANDROMEDA
					and not SaveData.UnlockData.Andromeda.Satan
					then
						SaveData.UnlockData.Andromeda.Satan = true
						UpdateCompletion("meteorite", "", false)
					elseif playerType == Character.T_ANDROMEDA
					and not SaveData.UnlockData.T_Andromeda.Satan
					then
						SaveData.UnlockData.T_Andromeda.Satan = true
						UpdateCompletion("moonstone", "", true)
					end
				end
			elseif levelStage == LevelStage.STAGE6 then
				if npc.Type == EntityType.ENTITY_ISAAC
				and npc.Variant == 1
				then
					if playerType == Character.ANDROMEDA
					and not SaveData.UnlockData.Andromeda.BlueBaby
					then
						blueBabyDead = true
					elseif playerType == Character.T_ANDROMEDA
					and not SaveData.UnlockData.T_Andromeda.BlueBaby
					then
						blueBabyDead = true
					end
				elseif npc.Type == EntityType.ENTITY_THE_LAMB then
					if playerType == Character.ANDROMEDA
					and not SaveData.UnlockData.Andromeda.TheLamb
					then
						lambDead = true
					elseif playerType == Character.T_ANDROMEDA
					and not SaveData.UnlockData.T_Andromeda.TheLamb
					then
						lambDead = true
					end
				elseif npc.Type == EntityType.ENTITY_MEGA_SATAN_2 then
					if playerType == Character.ANDROMEDA
					and not SaveData.UnlockData.Andromeda.MegaSatan
					then
						SaveData.UnlockData.Andromeda.MegaSatan = true
						UpdateCompletion("babypluto", "", false)
					elseif playerType == Character.T_ANDROMEDA
					and not SaveData.UnlockData.T_Andromeda.MegaSatan
					then
						SaveData.UnlockData.T_Andromeda.MegaSatan = true
						UpdateCompletion("wispwiz", "", true)
					end
				end
			elseif levelStage == LevelStage.STAGE7
			and npc.Type == EntityType.ENTITY_DELIRIUM
			then
				if playerType == Character.ANDROMEDA
				and not SaveData.UnlockData.Andromeda.Delirium
				then
					SaveData.UnlockData.Andromeda.Delirium = true
					UpdateCompletion("harmonicconvergence", "", false)
				elseif playerType == Character.T_ANDROMEDA
				and not SaveData.UnlockData.T_Andromeda.Delirium
				then
					SaveData.UnlockData.T_Andromeda.Delirium = true
					UpdateCompletion("singularity", "", true)
				end
			elseif (levelStage == LevelStage.STAGE4_1 or levelStage == LevelStage.STAGE4_2)
			and npc.Type == EntityType.ENTITY_MOTHER
			and npc.Variant == 10
			then
				if playerType == Character.ANDROMEDA
				and not SaveData.UnlockData.Andromeda.Mother
				then
					SaveData.UnlockData.Andromeda.Mother = true
					UpdateCompletion("juno", "", false)
				elseif playerType == Character.T_ANDROMEDA
				and not SaveData.UnlockData.T_Andromeda.Mother
				then
					SaveData.UnlockData.T_Andromeda.Mother = true
					UpdateCompletion("ceres", "", true)
				end
			end
		end
	end
end

function UnlockManager.postPEffectUpdate(player)
	if game.Challenge > 0 then return end
	if game:GetVictoryLap() > 0 then return end
	
	local playerType = player:GetPlayerType()

	if playerType ~= Character.ANDROMEDA and playerType ~= Character.T_ANDROMEDA then return end

	local level = game:GetLevel()
	local levelStage = level:GetStage()
	local room = game:GetRoom()
	
	if levelStage == LevelStage.STAGE6
	and room:GetType() == RoomType.ROOM_BOSS
	and room:IsClear()
	then
		if blueBabyDead then
			if playerType == Character.ANDROMEDA
			and not SaveData.UnlockData.Andromeda.BlueBaby
			then
				SaveData.UnlockData.Andromeda.BlueBaby = true
				UpdateCompletion("gravityshift", "", false)
				blueBabyDead = false
			elseif playerType == Character.T_ANDROMEDA
			and not SaveData.UnlockData.T_Andromeda.BlueBaby
			then
				SaveData.UnlockData.T_Andromeda.BlueBaby = true
				UpdateCompletion("bookofcosmos", "", true)
				blueBabyDead = false
			end
		elseif lambDead then
			if playerType == Character.ANDROMEDA
			and not SaveData.UnlockData.Andromeda.TheLamb
			then
				SaveData.UnlockData.Andromeda.TheLamb = true
				UpdateCompletion("extinctionevent", "", false)
				lambDead = false
			elseif playerType == Character.T_ANDROMEDA
			and not SaveData.UnlockData.T_Andromeda.TheLamb
			then
				SaveData.UnlockData.T_Andromeda.TheLamb = true
				UpdateCompletion("luminaryflare", "", true)
				lambDead = false
			end
		end
	end
			
	if game:GetStateFlag(GameStateFlag.STATE_BOSSRUSH_DONE)
	and (levelStage == LevelStage.STAGE3_1 or levelStage == LevelStage.STAGE3_2)
	then
		if playerType == Character.ANDROMEDA
		and not SaveData.UnlockData.Andromeda.BossRush
		then
			SaveData.UnlockData.Andromeda.BossRush = true
			UpdateCompletion("runes1", "", false)
		elseif playerType == Character.T_ANDROMEDA
		and not SaveData.UnlockData.T_Andromeda.BossRush
		then
			SaveData.UnlockData.T_Andromeda.BossRush = true
			UpdateCompletion("rune2", "", true)
		end
	end
	
	if game:GetStateFlag(GameStateFlag.STATE_BLUEWOMB_DONE)
	and levelStage == LevelStage.STAGE4_3
	then
		if playerType == Character.ANDROMEDA
		and not SaveData.UnlockData.Andromeda.Hush
		then
			SaveData.UnlockData.Andromeda.Hush = true
			UpdateCompletion("celestialcrown", "", false)
		elseif playerType == Character.T_ANDROMEDA
		and not SaveData.UnlockData.T_Andromeda.Hush
		then
			SaveData.UnlockData.T_Andromeda.Hush = true
			UpdateCompletion("soulofandromeda", "", true)
		end
	end
	
	if game:IsGreedMode()
	and levelStage == LevelStage.STAGE7_GREED
	and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x2
	and room:IsClear()
	then
		if game.Difficulty == Difficulty.DIFFICULTY_GREED then
			if playerType == Character.ANDROMEDA
			and not SaveData.UnlockData.Andromeda.Greed
			then
				UpdateCompletion("stardust", "", false)
			elseif playerType == Character.T_ANDROMEDA
			and not SaveData.UnlockData.T_Andromeda.Greed
			then
				UpdateCompletion("sextant", "", true)
			end
		elseif game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then
			if playerType == Character.ANDROMEDA then
				if not SaveData.UnlockData.Andromeda.Greed
				and not SaveData.UnlockData.Andromeda.Greedier
				then
					UpdateCompletion("ophiuchus", "stardust", false)
				elseif SaveData.UnlockData.Andromeda.Greed
				and not SaveData.UnlockData.Andromeda.Greedier
				then
					UpdateCompletion("ophiuchus", "", false)
				end
			elseif playerType == Character.T_ANDROMEDA then
				if not SaveData.UnlockData.T_Andromeda.Greed
				and not SaveData.UnlockData.T_Andromeda.Greedier
				then
					UpdateCompletion("unknown", "sextant", true)
				elseif SaveData.UnlockData.T_Andromeda.Greed
				and not SaveData.UnlockData.T_Andromeda.Greedier
				then
					UpdateCompletion("unknown", "", true)
				end
			end
		end
	end
end

function UnlockManager.postPlayerInit(player)
	if game:GetFrameCount() > 0 then return end

	for item, tab in pairs(collectibleUnlocks) do
		local prefix = ""
		local unlocked = false

		if tab.Special then
			unlocked = tab.Special()
		else
			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]
		end
		
		if not unlocked then
			game:GetItemPool():RemoveCollectible(item)
		end
	end

	for trinket, tab in pairs(trinketUnlocks) do
		local prefix = ""
		local unlocked = false

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]

		if not unlocked then
			game:GetItemPool():RemoveTrinket(trinket)
		end
	end

	if not SaveData.UnlockData.Andromeda.Greedier then
		table.remove(CustomData.AbPlPoolCopy, 13)
	end
end

function UnlockManager.familiarInit(familiar)
	if familiar.Variant ~= FamiliarVariant.ITEM_WISP then return end

	local tab = collectibleUnlocks[familiar.SubType]
	local prefix = ""
	local unlocked = false

	if tab == nil then return end

	if tab.Special then
		unlocked = tab.Special()
	else
		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]
	end

	if not unlocked then
		local seed = game:GetSeeds():GetStartSeed()
		local pool = ItemPoolType.POOL_TREASURE

		if familiar.SubType == Collectible.HARMONIC_CONVERGENCE then
			pool = ItemPoolType.POOL_ANGEL
		end

		if familiar.SubType == Collectible.JUNO
		or familiar.SubType == Collectible.PALLAS
		or familiar.SubType == Collectible.CERES
		or familiar.SubType == Collectible.VESTA
		or familiar.SubType == Collectible.CHIRON
		then
			pool = ItemPoolType.POOL_PLANETARIUM
		end
		
		local newItem = game:GetItemPool():GetCollectible(pool, false, familiar.InitSeed)
		local itemConfig = Isaac.GetItemConfig():GetCollectible(newItem)
		
		while itemConfig.Type == ItemType.ITEM_ACTIVE do
			newItem = game:GetItemPool():GetCollectible(pool, false, seed)
			itemConfig = Isaac.GetItemConfig():GetCollectible(newItem)
		end

		familiar.SubType = newItem
	end
end

function UnlockManager.postPickupInit(pickup)
	local room = game:GetRoom()
	local roomType = room:GetType()
	rng:SetSeed(pickup.InitSeed, 35)

	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
		local tab = collectibleUnlocks[pickup.SubType]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Special then
			unlocked = tab.Special()
		else
			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]
		end

		if not unlocked then
			local seed = game:GetSeeds():GetStartSeed()
			local pool = game:GetItemPool():GetPoolForRoom(roomType, seed)

			if pool == ItemPoolType.POOL_NULL then
				pool = ItemPoolType.POOL_TREASURE
			end

			if roomType ~= RoomType.ROOM_ANGEL
			and pickup.SubType == Collectible.HARMONIC_CONVERGENCE
			then
				pool = ItemPoolType.POOL_ANGEL
			end

			if roomType ~= RoomType.ROOM_SECRET
			and pickup.SubType == Collectible.SINGULARITY
			then
				pool = ItemPoolType.POOL_SECRET
			end

			if roomType ~= RoomType.ROOM_PLANETARIUM then
				if pickup.SubType == Collectible.JUNO
				or pickup.SubType == Collectible.PALLAS
				or pickup.SubType == Collectible.CERES
				or pickup.SubType == Collectible.VESTA
				or pickup.SubType == Collectible.CHIRON
				then
					pool = ItemPoolType.POOL_PLANETARIUM
				end
			end
			
			local newItem = game:GetItemPool():GetCollectible(pool, true, pickup.InitSeed)
			game:GetItemPool():RemoveCollectible(pickup.SubType)
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, false, false)
		end
	elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
		local tab = trinketUnlocks[pickup.SubType]
		local trinketID = pickup.SubType
		local isGolden = false
		local prefix = ""
		local unlocked = false

		if pickup.SubType > TrinketType.TRINKET_GOLDEN_FLAG then
			tab = trinketUnlocks[pickup.SubType - TrinketType.TRINKET_GOLDEN_FLAG]
			trinketID = pickup.SubType - TrinketType.TRINKET_GOLDEN_FLAG
			isGolden = true
		end

		if tab == nil then return end

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]
		
		if not unlocked then
			local newTrinket = game:GetItemPool():GetTrinket(false)

			if isGolden then
				newTrinket = newTrinket + TrinketType.TRINKET_GOLDEN_FLAG
			end

			game:GetItemPool():RemoveTrinket(trinketID)
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, newTrinket, true, false, false)
		end
	elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
		local tab = cardUnlocks[pickup.SubType]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]

		if not unlocked then
			local pool = game:GetItemPool()
			local rune = pool:GetCard(pickup.InitSeed, false, true, true)
			
			if pickup.SubType == Card.THE_UNKNOWN then
				rune = 0
			end
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, true, false, false)
		end
	end
end

function UnlockManager.postPlayerUpdate(player)
	for item, val in pairs(collectibleUnlocks) do
		if player:GetPlayerType() == Character.ANDROMEDA and item == Collectible.GRAVITY_SHIFT then return end
		if player:GetPlayerType() == Character.T_ANDROMEDA and item == Collectible.SINGULARITY then return end
		
		local tab = collectibleUnlocks[item]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Special then
			unlocked = tab.Special()
		else
			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]
		end
		
		if player:HasCollectible(item, true)
		and not unlocked
		then
			local itemConfig = Isaac.GetItemConfig()
			local pool = ItemPoolType.POOL_TREASURE

			if item == Collectible.HARMONIC_CONVERGENCE then
				pool = ItemPoolType.POOL_ANGEL
			elseif item == Collectible.SINGULARITY then
				pool = ItemPoolType.POOL_SECRET
			elseif item == Collectible.JUNO
			or item == Collectible.PALLAS
			or item == Collectible.CERES
			or item == Collectible.VESTA
			or item == Collectible.CHIRON
			then
				pool = ItemPoolType.POOL_PLANETARIUM
			end

			local newItem = game:GetItemPool():GetCollectible(pool, true, player.InitSeed)
			player:RemoveCollectible(item)
			player:AddCollectible(newItem, itemConfig:GetCollectible(newItem).MaxCharges)
		end
	end
	
	for trinket, val in pairs(trinketUnlocks) do
		local tab = trinketUnlocks[trinket]
		local prefix = ""
		local unlocked = false

		if tab == nil then return end

		if tab.Tainted then
			prefix = "T_"
		end
		unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]
		
		if player:HasTrinket(trinket)
		and not unlocked
		then
			local newTrinket = game:GetItemPool():GetTrinket(false)

			if trinket > TrinketType.TRINKET_GOLDEN_FLAG then
				newTrinket = newTrinket + TrinketType.TRINKET_GOLDEN_FLAG
			end

			player:TryRemoveTrinket(trinket)
			player:AddTrinket(newTrinket)
		end
	end

	for i = 0, 3 do
		for card, val in pairs(cardUnlocks) do
			local tab = cardUnlocks[card]
			local prefix = ""
			local unlocked = false

			if tab == nil then return end

			if tab.Tainted then
				prefix = "T_"
			end
			unlocked = SaveData.UnlockData[prefix .. "Andromeda"][tab.Unlock]

			if player:GetCard(i) == card
			and not unlocked
			then
				local pool = game:GetItemPool()
				local rune = pool:GetCard(Random(), false, true, true)
				
				if card == Card.THE_UNKNOWN then
					rune = pool:GetCard(Random(), false, false, false)
				end
				player:SetCard(i, rune)
			end
		end
	end
end

return UnlockManager