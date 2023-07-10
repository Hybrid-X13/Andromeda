local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemPool = game:GetItemPool()

local SINGULARITY_MAX = 12

local frameCount = 0
local bossRoomCleared = false
local rewinding = false
local shiftIndex = 0
local roomShape = 0

local headCostume = Isaac.GetCostumeIdByPath("gfx/characters/andromedabhead.anm2")
local eyeCostume = Isaac.GetCostumeIdByPath("gfx/characters/andromedabheadeyes.anm2")
local bloodHeadCostume = Isaac.GetCostumeIdByPath("gfx/characters/andromedabhead_blood.anm2")
local bloodEyeCostume = Isaac.GetCostumeIdByPath("gfx/characters/andromedabheadeyes_blood.anm2")

local Stats = {
	Speed = -0.1,
	Tears = 0.915,
	DMG = 0.7,
	Range = 0,
	ShotSpeed = 0.6,
	Luck = 0,
	TearFlags = TearFlags.TEAR_NORMAL | TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_SPECTRAL,
}

local Blacklist = {
	CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
	CollectibleType.COLLECTIBLE_EPIC_FETUS,
	CollectibleType.COLLECTIBLE_CAR_BATTERY,
	CollectibleType.COLLECTIBLE_YUM_HEART,
	CollectibleType.COLLECTIBLE_YUCK_HEART,
	CollectibleType.COLLECTIBLE_CANDY_HEART,
	CollectibleType.COLLECTIBLE_BLOOD_OATH,
	CollectibleType.COLLECTIBLE_ADRENALINE,
	CollectibleType.COLLECTIBLE_OUIJA_BOARD,
	CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN,
	CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,
	CollectibleType.COLLECTIBLE_POTATO_PEELER,
	CollectibleType.COLLECTIBLE_CLICKER,
	CollectibleType.COLLECTIBLE_ANALOG_STICK,
	CollectibleType.COLLECTIBLE_HYPERCOAGULATION,
	CollectibleType.COLLECTIBLE_FLIP,
	CollectibleType.COLLECTIBLE_EYE_OF_GREED,
	CollectibleType.COLLECTIBLE_POUND_OF_FLESH,
	CollectibleType.COLLECTIBLE_THE_JAR,
	CollectibleType.COLLECTIBLE_LITTLE_CHAD,
	CollectibleType.COLLECTIBLE_BRITTLE_BONES,
}

local blackHoleAnims = {
	"IdleVoidBasic",
	"IdleVoidWhite",
	"IdleVoidBlack",
	"IdleVoidBlue",
	"IdleVoidStrawberry",
	"IdleVoidGreen",
	"IdleVoidGray",
}

local colors = {
	"basic",
	"_white",
	"_black",
	"_blue",
	"_red",
	"_green",
	"_grey",
}

local Costumes = {
	{Item = CollectibleType.COLLECTIBLE_PENTAGRAM, 			Path = "costume_054_pentagram"},
	{Item = CollectibleType.COLLECTIBLE_SAD_ONION, 			Path = "costume_058_sadonion"},
	{Item = CollectibleType.COLLECTIBLE_SPELUNKER_HAT, 		Path = "costume_063_spelunkerhat"},
	{Item = CollectibleType.COLLECTIBLE_SPOON_BENDER, 		Path = "costume_063_spelunkerhat"},
	{Item = CollectibleType.COLLECTIBLE_XRAY_VISION, 		Path = "costume_077_xrayvision"},
	{Item = CollectibleType.COLLECTIBLE_PYRO, 				Path = "costume_107_pyro"},
	{Item = CollectibleType.COLLECTIBLE_HALO, 				Path = "costume_119_halo"},
	{Item = CollectibleType.COLLECTIBLE_MITRE, 				Path = "costume_173_mitre"},
	{Item = CollectibleType.COLLECTIBLE_HOT_BOMBS, 			Path = "costume_256_hotbombs"},
	{Item = CollectibleType.COLLECTIBLE_FIRE_MIND, 			Path = "costume_257_firemind"},
	{Item = CollectibleType.COLLECTIBLE_MISSING_NO, 		Path = "costume_258_missingno"},
	{Item = CollectibleType.COLLECTIBLE_ROBO_BABY_2, 		Path = "costume_267_robobaby20"},
	{Item = CollectibleType.COLLECTIBLE_ARIES, 				Path = "costume_300_aries"},
	{Item = CollectibleType.COLLECTIBLE_AQUARIUS, 			Path = "costume_308_aquarius"},
	{Item = CollectibleType.COLLECTIBLE_BLUE_CAP, 			Path = "costume_342_bluecap"},
	{Item = CollectibleType.COLLECTIBLE_MATCH_BOOK, 		Path = "costume_344_matchbook"},
	{Item = CollectibleType.COLLECTIBLE_DEAD_EYE, 			Path = "costume_373_deadeye"},
	{Item = CollectibleType.COLLECTIBLE_HOST_HAT, 			Path = "costume_375_hosthat"},
	{Item = CollectibleType.COLLECTIBLE_TECH_X, 			Path = "costume_395_techx"},
	{Item = Enums.Collectibles.ANDROMEDA_TECHX, 			Path = "costume_395_techx"},
	{Item = CollectibleType.COLLECTIBLE_TRACTOR_BEAM, 		Path = "costume_397_tractorbeam"},
	{Item = CollectibleType.COLLECTIBLE_NIGHT_LIGHT, 		Path = "costume_425_nightlight"},
	{Item = CollectibleType.COLLECTIBLE_BELLY_BUTTON, 		Path = "costume_458_bellybutton"},
	{Item = CollectibleType.COLLECTIBLE_LITTLE_HORN, 		Path = "costume_503_littlehorn"},
	{Item = CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,	Path = "costume_524_technology0"},
	{Item = CollectibleType.COLLECTIBLE_PARASITE,			Path = "costume_053_parasite"},
	{Item = CollectibleType.COLLECTIBLE_MAGIC_8_BALL,		Path = "costume_097_magic8ball"},
	{Item = CollectibleType.COLLECTIBLE_SCAPULAR,			Path = "costume_109_scapular"},
	{Item = CollectibleType.COLLECTIBLE_TECH_5,				Path = "costume_244_tech05"},
	{Item = CollectibleType.COLLECTIBLE_JACOBS_LADDER,		Path = "costume_494_jacobsladder"},
	{Item = CollectibleType.COLLECTIBLE_BAR_OF_SOAP,		Path = "costume_011x_soap"},
	{Item = CollectibleType.COLLECTIBLE_IMMACULATE_HEART,	Path = "costume_020x_immaculateheart"},
	{Item = CollectibleType.COLLECTIBLE_VENUS,				Path = "costume_038x_venus"},
	{Item = CollectibleType.COLLECTIBLE_OCULAR_RIFT,		Path = "costume_053x_oculusrift"},
	{Item = CollectibleType.COLLECTIBLE_TROPICAMIDE,		Path = "costume_106x_tropicamide"},
	{Item = CollectibleType.COLLECTIBLE_GUPPYS_EYE,			Path = "costume_665_guppyseye"},
	{Item = CollectibleType.COLLECTIBLE_GLASS_EYE,			Path = "costume_730_glasseye"},
	{Item = CollectibleType.COLLECTIBLE_MONSTRANCE,			Path = "costume_021x_monstrance"},
	{Item = CollectibleType.COLLECTIBLE_MERCURIUS,			Path = "costume_037x_mercurius"},
	{Item = CollectibleType.COLLECTIBLE_BLOOD_BOMBS,		Path = "costume_061x_bloodbombs"},
	{Item = CollectibleType.COLLECTIBLE_CRACKED_ORB,		Path = "costume_675_crackedorb"},
	{Item = CollectibleType.COLLECTIBLE_SOUL_LOCKET,		Path = "costume_686_soullocket"},
	{Item = CollectibleType.COLLECTIBLE_CARD_READING,		Path = "costume_660_card_reading"},
	{Item = CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT,	Path = "costume_019x_occulteye"},
	{Item = Enums.Collectibles.CELESTIAL_CROWN,				Path = "spacetume_celestialcrown"},
	{Item = Enums.Collectibles.HARMONIC_CONVERGENCE,		Path = "spacetume_harmonicconvergence"},
	{Item = Enums.Collectibles.JUNO,						Path = "spacetume_juno"},
	{Item = Enums.Collectibles.PALLAS,						Path = "spacetume_pallas"},
	--Costumes that need to be null costumes
	{Item = CollectibleType.COLLECTIBLE_INNER_EYE,			Path = "costume_029_theinnereye", 	Special = true},
	{Item = CollectibleType.COLLECTIBLE_MUTANT_SPIDER,		Path = "costume_103_mutantspider", 	Special = true},
	{Item = CollectibleType.COLLECTIBLE_THERES_OPTIONS,		Path = "costume_249_theresoptions", Special = true},
	{Item = CollectibleType.COLLECTIBLE_PUPULA_DUPLEX,		Path = "costume_379_pupuladuplex", 	Special = true},
	{Item = CollectibleType.COLLECTIBLE_MORE_OPTIONS,		Path = "costume_414_moreoptions", 	Special = true},
	{Item = CollectibleType.COLLECTIBLE_OPTIONS,			Path = "costume_670_options", 		Special = true},
}

local Character = {}

--Handles swapping of item costumes with and without skin alts for T Andromeda
local function ChangeCostume(player)
	local skinColor = player:GetHeadColor()
	
	if SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] ~= 1
	and Functions.HasBloodTears(player)
	then
		player:AddNullCostume(bloodHeadCostume)
		player:AddNullCostume(bloodEyeCostume)
		SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] = 1
	elseif SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] ~= 0
	and not Functions.HasBloodTears(player)
	then
		player:AddNullCostume(headCostume)
		player:AddNullCostume(eyeCostume)
		SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] = 0
	end
	
	for i = 1, #Costumes do
		local itemConfig = Isaac.GetItemConfig():GetCollectible(Costumes[i].Item)
		local itemName = itemConfig.Name
		local hasSkinAlt = itemConfig.Costume.HasSkinAlt
		
		if player:HasCollectible(Costumes[i].Item) then
			if Costumes[i].Item == Enums.Collectibles.ANDROMEDA_TECHX then
				itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_TECH_X)
			end
			
			if SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] == 1
			and SaveData.PlayerData.T_Andromeda.Costumes[itemName] ~= 10
			then
				if Costumes[i].Special then
					if not hasSkinAlt then
						player:RemoveCostume(itemConfig)
						player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. Costumes[i].Path .. "_blood.anm2"))
					else
						player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. Costumes[i].Path .. "_blood.png", Costumes[i].Item)
					end
				else
					player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. Costumes[i].Path .. "_blood.png", Costumes[i].Item)
				end
				SaveData.PlayerData.T_Andromeda.Costumes[itemName] = 10
			elseif SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] ~= 1
			and SaveData.PlayerData.T_Andromeda.Costumes[itemName] ~= skinColor + 2
			then
				if Costumes[i].Special then
					if not hasSkinAlt then
						player:RemoveCostume(itemConfig)
						player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. Costumes[i].Path .. ".anm2"))
					else
						if skinColor == SkinColor.SKIN_PINK then
							player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. Costumes[i].Path .. ".png", Costumes[i].Item)
						else
							player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. Costumes[i].Path .. colors[skinColor + 2] .. ".png", Costumes[i].Item)
						end
					end
				else
					if skinColor == SkinColor.SKIN_PINK then
						player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. Costumes[i].Path .. ".png", Costumes[i].Item)
					else
						player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. Costumes[i].Path .. colors[skinColor + 2] .. ".png", Costumes[i].Item)
					end
				end
				SaveData.PlayerData.T_Andromeda.Costumes[itemName] = skinColor + 2
			end
		else
			if SaveData.PlayerData.T_Andromeda.Costumes[itemName] ~= 0 then
				player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. Costumes[i].Path .. ".anm2"))
				player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. Costumes[i].Path .. "_blood.anm2"))
				SaveData.PlayerData.T_Andromeda.Costumes[itemName] = 0
			end
		end
	end
end

function Character.evaluateCache(player, cacheFlag)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			player.Damage = player.Damage + (Stats.DMG * 0.2)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
			player.Damage = player.Damage + (Stats.DMG * 0.3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			player.Damage = player.Damage + (Stats.DMG * 0.8)
		else
			player.Damage = player.Damage + Stats.DMG
		end
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
	frameCount = 0

	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local startRoomIndex = 84
	
	if game:GetFrameCount() == 0
	or roomIndex == startRoomIndex
	or level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX
	then
		for i = 1, #Blacklist do
			itemPool:RemoveCollectible(Blacklist[i])
		end
	
		player:AddNullCostume(headCostume)
		player:AddNullCostume(eyeCostume)
		SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] = 0
	end
end

function Character.preRoomEntitySpawn(entity, variant, subType, gIndex, seed)
	if not Functions.AnyPlayerIsType(Enums.Characters.T_ANDROMEDA) then return end
	
	local room = game:GetRoom()
	local roomType = room:GetType()

	if entity == EntityType.ENTITY_PICKUP
	and variant == PickupVariant.PICKUP_COLLECTIBLE
	and subType ~= 0
	then
		local itemConfig = Isaac.GetItemConfig():GetCollectible(subType)
		
		if itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
		and roomType ~= RoomType.ROOM_DUNGEON
		and roomType ~= RoomType.ROOM_ULTRASECRET
		and roomType ~= RoomType.ROOM_CHALLENGE
		then
			return {0, 0, 0}
		end
	end

	if entity == EntityType.ENTITY_SLOT
	and variant == Enums.Slots.RESTOCK
	and (roomType == RoomType.ROOM_SHOP or roomType == RoomType.ROOM_BLACK_MARKET or roomType == RoomType.ROOM_TREASURE)
	then
		return {0, 0, 0}
	end
end

function Character.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomIndex = level:GetCurrentRoomIndex()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, room:GetCenterPos() + Vector(0, -20), Vector.Zero, player)
			local sprite = blackHole:GetSprite()
			local skinColor = player:GetHeadColor()

			if Functions.HasBloodTears(player) then
				sprite:Play("IdleVoidBlood")
			elseif not Functions.HasBloodTears(player) then
				sprite:Play(blackHoleAnims[skinColor + 2])
			end

			if not player:HasTrinket(Enums.Trinkets.EYE_OF_SPODE)
			and not game:IsGreedMode()
			and not Functions.ContainsQuestItem()
			and not (room:IsMirrorWorld() or (StageAPI and StageAPI:IsMirrorDimension()))
			then
				if room:GetType() == RoomType.ROOM_TREASURE then
					player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false)
					sfx:Stop(SoundEffect.SOUND_HELL_PORTAL2)
					local blackout = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, Vector(320, 400), Vector.Zero, nil)
					blackout.SpriteScale = Vector(50, 50)
					rewinding = true
					shiftIndex = roomIndex
					roomShape = room:GetRoomShape()
				end
				
				for i = 0, DoorSlot.NUM_DOOR_SLOTS do
					local door = room:GetDoor(i)
			
					if door
					and door.TargetRoomType == RoomType.ROOM_TREASURE
					and room:GetType() ~= RoomType.ROOM_SECRET
					and room:GetType() ~= RoomType.ROOM_SUPERSECRET
					then
						local doorSprite = door:GetSprite()
		
						for i = 0, 4 do
							doorSprite:ReplaceSpritesheet(i, "gfx/grid/andromeda_abandonedplanetariumdoor_out.png")
						end
						
						doorSprite:LoadGraphics()
					end
				end
			end

			--Prevent abusing deal rooms
			if room:GetType() == RoomType.ROOM_BOSS then
				for i = 0, DoorSlot.NUM_DOOR_SLOTS do
					local door = room:GetDoor(i)
					
					if door
					and (door.TargetRoomType == RoomType.ROOM_DEVIL or door.TargetRoomType == RoomType.ROOM_ANGEL)
					then
						room:RemoveDoor(i)
					end
				end
			end

			if room:IsFirstVisit() then
				--Charge Singularity when entering boss rush and error rooms
				if (room:GetType() == RoomType.ROOM_BOSSRUSH or room:GetType() == RoomType.ROOM_ERROR)
				and player:GetActiveCharge(ActiveSlot.SLOT_POCKET) < SINGULARITY_MAX * 2
				then
					Functions.ChargeSingularity(player, 12)
				end
				
				if #items > 0
				and not Functions.ContainsQuestItem()
				and Functions.GetDimension(roomDesc) ~= Enums.Dimensions.DEATH_CERTIFICATE
				and roomIndex ~= GridRooms.ROOM_GENESIS_IDX
				then
					for _, collectible in pairs(items) do
						if collectible.SubType > 0 then
							collectible:Remove()
							
							--Replace items in crawlspaces and ultra secret rooms since they're rare
							if room:GetType() == RoomType.ROOM_DUNGEON then
								local randNum = rng:RandomInt(100)
								Functions.GetRandomChest(collectible.Position, randNum)
							elseif room:GetType() == RoomType.ROOM_ULTRASECRET then
								Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, collectible.Position, Vector.Zero, nil)
							end
						end
					end

					if room:GetType() == RoomType.ROOM_CHALLENGE then
						local pos = {room:GetCenterPos(), Vector(400, 280), Vector(240, 280)}
						
						for i = 1, 3 do
							local randNum = rng:RandomInt(100)
							Functions.GetRandomChest(pos[i], randNum)
						end
					end
				end

				if game:IsGreedMode()
				and room:IsFirstVisit()
				and (room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL or room:GetType() == RoomType.ROOM_PLANETARIUM)
				and roomIndex ~= GridRooms.ROOM_ANGEL_SHOP_IDX
				then
					Functions.ChargeSingularity(player, 12)
				end
			end
		end
	end
end

function Character.postNewLevel()
	if not Functions.AnyPlayerIsType(Enums.Characters.T_ANDROMEDA) then return end
	
	SaveData.PlayerData.T_Andromeda.PlanetariumChance = 100
end

function Character.preSpawnCleanAward()
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA
		and (room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH)
		and level:GetStage() ~= LevelStage.STAGE7
		then
			bossRoomCleared = true
			frameCount = game:GetFrameCount()
			
			--Recharge Singularity when clearing a boss room before Hush
			if player:GetActiveCharge(ActiveSlot.SLOT_POCKET) < SINGULARITY_MAX * 2
			and level:GetStage() < LevelStage.STAGE4_3
			then
				Functions.ChargeSingularity(player, 12)
			end
		end
	end
end

function Character.entityTakeDmg(target, amount, flags, source, countdown)
	local player = target:ToPlayer()
	local enemy = target:ToNPC()

	if player ~= nil then
		if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
		
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MY_REFLECTION)
		local randNum = rng:RandomInt(20)
		
		--Built-in Marbles effect
		if randNum == 0
		and (player:GetTrinket(0) > 0 or player:GetTrinket(1) > 0)
		then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)
			sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 2, false, 0.9)
		end
	elseif enemy ~= nil
	and enemy.HitPoints - amount <= 0
	and source.Entity
	and source.Type == EntityType.ENTITY_EFFECT
	and source.Variant == Enums.Effects.BLACK_HOLE
	and source.Entity.SpawnerEntity
	then
		player = source.Entity.SpawnerEntity:ToPlayer()
		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.T_ANDROMEDA_BIRTHCAKE)
		local numKills = 10

		if trinketMultiplier > 1 then
			numKills = 5
		end

		if player:GetData().blackHoleKills == nil then
			player:GetData().blackHoleKills = 0
		end
		
		if player:GetData().blackHoleKills < numKills then
			player:GetData().blackHoleKills = player:GetData().blackHoleKills + 1
		end

		if player:GetData().blackHoleKills == numKills then
			player:GetData().blackHoleKills = 0
			Functions.ChargeSingularity(player, 1)
		end
	end
end

function Character.postTearInit(tear)
	if tear.SpawnerEntity == nil then return end

	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	Functions.ChangeTear(tear, player)
end

function Character.postFireTear(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()
	tear.Position = room:GetCenterPos()
	tear.Scale = tear.Scale + 0.37

	Functions.AddLightToTear(player, tear)
	
	--Tainted Andromeda Birthright effect. Spawn additional tears that converge toward the black hole
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local randNum = rng:RandomInt(360)
		Functions.ConvergingTears(tear, player, room:GetCenterPos(), randNum, 1, true)
	end
end

function Character.preTearCollision(tear, collider, low)
	if tear.SpawnerEntity == nil then return end

	local player = Functions.GetPlayerFromSpawnerEntity(tear)

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
	local bishops = Isaac.FindByType(EntityType.ENTITY_BISHOP, -1)

	if (collider:IsActiveEnemy() and not collider:IsVulnerableEnemy())
	or collider.Type == EntityType.ENTITY_MINECART
	or (collider.Type == EntityType.ENTITY_FIREPLACE and collider.Variant == 13)
	or (#bishops > 0 and collider.Type ~= EntityType.ENTITY_BISHOP and collider:IsEnemy())
	then
		return true
	end
end

function Character.postLaserInit(laser)
	if laser.SpawnerEntity == nil then return end
	if laser:GetData().isSolarFlare then return end
	if laser.Variant == LaserVariant.TRACTOR_BEAM then return end
	if laser.Variant == LaserVariant.LIGHT_RING then return end
	if laser.Variant == LaserVariant.ELECTRIC then return end
	if laser.Variant == LaserVariant.THICK_BROWN then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()

	if laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR
	or (laser.Variant == LaserVariant.SHOOP and laser.MaxDistance == 0)
	then
		laser.Position = room:GetCenterPos()
		local vec = laser.Position - player.Position
		laser.Angle = vec:GetAngleDegrees()
		laser.ParentOffset = room:GetCenterPos() - player.Position
	end
	
	if laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
	or laser.Variant == LaserVariant.SHOOP
	then
		laser.Position = room:GetCenterPos()
	end
			
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	and laser.Variant ~= LaserVariant.SHOOP
	then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local randNum = rng:RandomInt(360)
		Functions.ConvergingTears(laser, player, room:GetCenterPos(), randNum, 1, true)
	end
end

function Character.postLaserUpdate(laser)
	if laser.SpawnerEntity == nil then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()
	Functions.ChangeLaserColor(laser, player)

	if laser:GetData().isSolarFlare then return end
	if laser.Variant == LaserVariant.THIN_RED then return end
	if laser.Variant == LaserVariant.SHOOP and laser.MaxDistance ~= 0 then return end
	if laser.Variant == LaserVariant.TRACTOR_BEAM then return end
	if laser.Variant == LaserVariant.LIGHT_RING then return end
	if laser.Variant == LaserVariant.ELECTRIC then return end
	if laser.Variant == LaserVariant.THICK_BROWN then return end
	if laser.SubType > LaserSubType.LASER_SUBTYPE_LINEAR then return end
	
	laser.Position = room:GetCenterPos()
	local vec = laser.Position - player.Position
	laser.Angle = vec:GetAngleDegrees()
	laser.ParentOffset = room:GetCenterPos() - player.Position
end

function Character.postBombUpdate(bomb)
	if bomb.FrameCount ~= 1 then return end
	if not bomb.IsFetus then return end
	if bomb.SpawnerEntity == nil then return end

	local player = bomb.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()

	bomb.Position = room:GetCenterPos()
end

function Character.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if not Functions.AnyPlayerIsType(Enums.Characters.T_ANDROMEDA) then return end

	local room = game:GetRoom()
	local roomType = room:GetType()

	if pickup.SubType == Enums.Collectibles.SINGULARITY then
		rng:SetSeed(pickup.InitSeed, 35)
		local seed = game:GetSeeds():GetStartSeed()
		local pool = game:GetItemPool():GetPoolForRoom(roomType, seed)
		
		if pool == ItemPoolType.POOL_NULL then
			pool = ItemPoolType.POOL_TREASURE
		end
		local newItem = game:GetItemPool():GetCollectible(pool, true, pickup.InitSeed)
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, false, false)
	elseif pickup.SubType == CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_COUPON, true, false, false)
	end

	if (roomType == RoomType.ROOM_BOSS and not room:IsClear())
	or (roomType == RoomType.ROOM_BOSSRUSH and room:IsAmbushActive())
	then
		pickup:GetData().dontRemove = true
	end
end

function Character.familiarUpdate(familiar)
	local player = familiar.Player

	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	if familiar.Variant ~= FamiliarVariant.ITEM_WISP then return end
	if familiar.SubType ~= CollectibleType.COLLECTIBLE_ANALOG_STICK then return end

	if familiar.Visible then
		familiar:RemoveFromOrbit()
		familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		familiar.Visible = false
		familiar.CollisionDamage = 0
		familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		familiar:GetData().tAndromedaWisp = true
	end
end

function Character.postPEffectUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomIndex = level:GetCurrentRoomIndex()
	local timer = frameCount + 4
	local gameFrame = game:GetFrameCount()
	local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)

	if rewinding
	and roomIndex ~= shiftIndex
	then
		player:StopExtraAnimation()
		local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, Vector(320, 400), Vector.Zero, nil)
		blackHole.SpriteScale = Vector(50, 50)
		
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

		if roomShape == RoomShape.ROOMSHAPE_IH then
			Isaac.ExecuteCommand("goto s.dice.4899")
		elseif roomShape == RoomShape.ROOMSHAPE_IV then
			Isaac.ExecuteCommand("goto s.dice.4898")
		else
			Isaac.ExecuteCommand("goto s.dice.4897")
		end

		local data = level:GetRoomByIdx(GridRooms.ROOM_DEBUG_IDX, 0).Data
		local treasureDesc = level:GetRoomByIdx(shiftIndex, 0)
		treasureDesc.Data = data
		game:StartRoomTransition(shiftIndex, Direction.NO_DIRECTION, RoomTransitionAnim.FADE_MIRROR, player)

		rewinding = false
		shiftIndex = 0
		roomShape = 0
	end
			
	--Update costumes to match head color
	ChangeCostume(player)
			
	--Gravitational pull on pickups
	if #pickups > 0 then
		for _, pickup in pairs(pickups) do
			if (pickup.Variant > 0 and pickup.Variant < PickupVariant.PICKUP_MEGACHEST)
			or (pickup.Variant > PickupVariant.PICKUP_MEGACHEST and pickup.Variant < PickupVariant.PICKUP_COLLECTIBLE)
			or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
			or pickup.Variant == PickupVariant.PICKUP_TRINKET
			or pickup.Variant == PickupVariant.PICKUP_REDCHEST
			then
				local vec = player.Position - pickup.Position
				local angle = vec:GetAngleDegrees()
				local fromAngle = Vector.FromAngle(angle)
				local newVec = Vector(fromAngle.X / 20, fromAngle.Y / 20)
				pickup:AddVelocity(newVec)
			end
		end
	end
	
	--For modded items that add additional items when entering rooms
	if room:IsFirstVisit()
	and room:GetFrameCount() == 1
	and Functions.GetDimension(roomDesc) ~= Enums.Dimensions.DEATH_CERTIFICATE
	and level:GetCurrentRoomIndex() ~= GridRooms.ROOM_GENESIS_IDX
	then
		Functions.RemoveAllCollectibles()
	end
			
	--Remove non-quest items that spawn when clearing a boss room
	if bossRoomCleared
	and timer == gameFrame
	and gameFrame > 4
	then
		Functions.RemoveAllCollectibles()
		bossRoomCleared = false
	end
			
	if not player:HasCurseMistEffect()
	and not player:IsCoopGhost()
	then
		if player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= Enums.Collectibles.SINGULARITY then
			player:SetPocketActiveItem(Enums.Collectibles.SINGULARITY, ActiveSlot.SLOT_POCKET, false)
			player:SetActiveCharge(0, ActiveSlot.SLOT_POCKET)
		end

		if not Functions.HasInnateItem(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
			Functions.AddInnateItem(player, CollectibleType.COLLECTIBLE_ANALOG_STICK)
		end
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		game:UpdateStrangeAttractor(room:GetCenterPos(), 6.5, 9999)
	end
end

function Character.postPlayerUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local hearts = player:GetMaxHearts()
	local boneHearts = player:GetBoneHearts()

	if boneHearts > 0 then
		player:AddBoneHearts(-boneHearts)
		player:AddBlackHearts(boneHearts * 2)
	end

	if hearts > 0 then
		player:AddMaxHearts(-hearts)
		player:AddBlackHearts(hearts)
	end
end

function Character.postEffectUpdate(effect)
	if effect.SpawnerEntity == nil then return end

	local player = effect.SpawnerEntity:ToPlayer()

  	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
	local room = game:GetRoom()
	local sprite = effect:GetSprite()

	if effect.Variant == Enums.Effects.BLACK_HOLE then
		local skinColor = player:GetHeadColor()
		local rituals = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PATCH, 3666)
		
		effect.Position = room:GetCenterPos() + Vector(0, -20)

		if not sprite:IsPlaying("IdleVoidBlood")
		and Functions.HasBloodTears(player)
		then
			sprite:Play("IdleVoidBlood")
		elseif not Functions.HasBloodTears(player)
		and not sprite:IsPlaying(blackHoleAnims[skinColor + 2])
		then
			sprite:Play(blackHoleAnims[skinColor + 2])
		end

		if player:HasTrinket(Enums.Trinkets.T_ANDROMEDA_BIRTHCAKE) then
			local enemies = Isaac.FindInRadius(room:GetCenterPos(), 40, EntityPartition.ENEMY)

			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
					and enemy:IsActiveEnemy()
					and enemy:IsVulnerableEnemy()
					and effect.FrameCount % 6 == 0
					then
						enemy:TakeDamage(player.Damage / 5, 0, EntityRef(effect), 0)
					end
				end
			end
		end

		if #rituals > 0 then
			sprite.Color = Color(1, 1, 1, 0.4, 0, 0, 0)
		end

		for i = 0, room:GetGridSize() do
			local grid = room:GetGridEntity(i)

			if grid
			and (room:GetCenterPos() - grid.Position):Length() <= 40
			and grid.State ~= 2
			and grid:GetType() ~= GridEntityType.GRID_DECORATION
			then
				sprite.Color = Color(1, 1, 1, 0.4, 0, 0, 0)
			end
		end
	elseif effect.Variant == EffectVariant.BLACK_HOLE then
		local tempEffects = player:GetEffects()

		if effect.FrameCount == 1
		and not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_LEO)
		then
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_LEO, false, 1)
			tempEffects:AddNullEffect(NullItemID.ID_TOOTH_AND_NAIL, false, 1)
		end

		effect.Position = player.Position
		effect.TargetPosition = player.Position
	elseif (effect.Variant == EffectVariant.BRIMSTONE_SWIRL or effect.Variant == EffectVariant.TECH_DOT)
	and not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
	then
		Functions.ChangeLaserColor(effect, player)
	elseif effect.Variant == Enums.Effects.TEAR_GLOW
	or effect.Variant == Enums.Effects.TEAR_GLOW_WHITE
	or effect.Variant == Enums.Effects.TEAR_GLOW_BLACK
	or effect.Variant == Enums.Effects.TEAR_GLOW_BLUE
	or effect.Variant == Enums.Effects.TEAR_GLOW_RED
	or effect.Variant == Enums.Effects.TEAR_GLOW_GREEN
	or effect.Variant == Enums.Effects.TEAR_GLOW_GRAY
	or effect.Variant == Enums.Effects.TEAR_GLOW_BLOOD
	then
		if effect.Parent == nil then
			effect:Remove()
		else
			effect:FollowParent(effect.Parent)
		end
	end
end

function Character.postEntityRemove(entity)
	if entity.Type ~= EntityType.ENTITY_EFFECT then return end
	if entity.Variant ~= EffectVariant.BLACK_HOLE then return end
	if entity.SpawnerEntity == nil then return end

	local player = entity.SpawnerEntity:ToPlayer()

  	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
	local tempEffects = player:GetEffects()

	if entity.FrameCount == 206 then
		tempEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_LEO, 1)
		tempEffects:RemoveNullEffect(NullItemID.ID_TOOTH_AND_NAIL, 1)
		player:SetMinDamageCooldown(60)
	end
end

function Character.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	if item ~= CollectibleType.COLLECTIBLE_CLICKER then return end

	local costumes = {
		headCostume,
		eyeCostume,
		bloodHeadCostume,
		bloodEyeCostume,
	}
	
	for _, costume in pairs(costumes) do
		player:TryRemoveNullCostume(costume)
	end
end

function Character.useItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	if item == CollectibleType.COLLECTIBLE_D4
	or item == CollectibleType.COLLECTIBLE_D100
	then
		if Functions.HasBloodTears(player) then
			player:AddNullCostume(bloodHeadCostume)
			player:AddNullCostume(bloodEyeCostume)
			SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] = 1
		else
			player:AddNullCostume(headCostume)
			player:AddNullCostume(eyeCostume)
			SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] = 0
		end
	end
end

function Character.NPCUpdate(npc)
	if npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then return end
	if not Functions.AnyPlayerIsType(Enums.Characters.T_ANDROMEDA) then return end
		
	npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
end

return Character