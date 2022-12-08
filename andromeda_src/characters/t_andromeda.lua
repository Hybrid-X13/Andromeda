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

local itemCostumes = {
	CollectibleType.COLLECTIBLE_PENTAGRAM,
	CollectibleType.COLLECTIBLE_SAD_ONION,
	CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
	CollectibleType.COLLECTIBLE_SPOON_BENDER,
	CollectibleType.COLLECTIBLE_XRAY_VISION,
	CollectibleType.COLLECTIBLE_PYRO,
	CollectibleType.COLLECTIBLE_HALO,
	CollectibleType.COLLECTIBLE_MITRE,
	CollectibleType.COLLECTIBLE_HOT_BOMBS,
	CollectibleType.COLLECTIBLE_FIRE_MIND,
	CollectibleType.COLLECTIBLE_MISSING_NO,
	CollectibleType.COLLECTIBLE_ROBO_BABY_2,
	CollectibleType.COLLECTIBLE_ARIES,
	CollectibleType.COLLECTIBLE_AQUARIUS,
	CollectibleType.COLLECTIBLE_BLUE_CAP,
	CollectibleType.COLLECTIBLE_MATCH_BOOK,
	CollectibleType.COLLECTIBLE_DEAD_EYE,
	CollectibleType.COLLECTIBLE_HOST_HAT,
	CollectibleType.COLLECTIBLE_TECH_X,
	Enums.Collectibles.ANDROMEDA_TECHX,
	CollectibleType.COLLECTIBLE_TRACTOR_BEAM,
	CollectibleType.COLLECTIBLE_NIGHT_LIGHT,
	CollectibleType.COLLECTIBLE_BELLY_BUTTON,
	CollectibleType.COLLECTIBLE_LITTLE_HORN,
	CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
	CollectibleType.COLLECTIBLE_PARASITE,
	CollectibleType.COLLECTIBLE_MAGIC_8_BALL,
	CollectibleType.COLLECTIBLE_SCAPULAR,
	CollectibleType.COLLECTIBLE_TECH_5,
	CollectibleType.COLLECTIBLE_JACOBS_LADDER,
	CollectibleType.COLLECTIBLE_BAR_OF_SOAP,
	CollectibleType.COLLECTIBLE_IMMACULATE_HEART,
	CollectibleType.COLLECTIBLE_VENUS,
	CollectibleType.COLLECTIBLE_OCULAR_RIFT,
	CollectibleType.COLLECTIBLE_TROPICAMIDE,
	CollectibleType.COLLECTIBLE_GUPPYS_EYE,
	CollectibleType.COLLECTIBLE_GLASS_EYE,
	CollectibleType.COLLECTIBLE_MONSTRANCE,
	CollectibleType.COLLECTIBLE_MERCURIUS,
	CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
	CollectibleType.COLLECTIBLE_CRACKED_ORB,
	CollectibleType.COLLECTIBLE_SOUL_LOCKET,
	CollectibleType.COLLECTIBLE_CARD_READING,
	CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT,
	Enums.Collectibles.CELESTIAL_CROWN,
	Enums.Collectibles.HARMONIC_CONVERGENCE,
	Enums.Collectibles.JUNO,
	
	CollectibleType.COLLECTIBLE_INNER_EYE,
	CollectibleType.COLLECTIBLE_MUTANT_SPIDER,
	CollectibleType.COLLECTIBLE_THERES_OPTIONS,
	CollectibleType.COLLECTIBLE_PUPULA_DUPLEX,
	CollectibleType.COLLECTIBLE_MORE_OPTIONS,
	CollectibleType.COLLECTIBLE_OPTIONS,
}

local costumeFileNames = {
	"costume_054_pentagram",
	"costume_058_sadonion",
	"costume_063_spelunkerhat",
	"costume_065_spoonbender",
	"costume_077_xrayvision",
	"costume_107_pyro",
	"costume_119_halo",
	"costume_173_mitre",
	"costume_256_hotbombs",
	"costume_257_firemind",
	"costume_258_missingno",
	"costume_267_robobaby20",
	"costume_300_aries",
	"costume_308_aquarius",
	"costume_342_bluecap",
	"costume_344_matchbook",
	"costume_373_deadeye",
	"costume_375_hosthat",
	"costume_395_techx",
	"costume_395_techx",
	"costume_397_tractorbeam",
	"costume_425_nightlight",
	"costume_458_bellybutton",
	"costume_503_littlehorn",
	"costume_524_technology0",
	"costume_053_parasite",
	"costume_097_magic8ball",
	"costume_109_scapular",
	"costume_244_tech05",
	"costume_494_jacobsladder",
	"costume_011x_soap",
	"costume_020x_immaculateheart",
	"costume_038x_venus",
	"costume_053x_oculusrift",
	"costume_106x_tropicamide",
	"costume_665_guppyseye",
	"costume_730_glasseye",
	"costume_021x_monstrance",
	"costume_037x_mercurius",
	"costume_061x_bloodbombs",
	"costume_675_crackedorb",
	"costume_686_soullocket",
	"costume_660_card_reading",
	"costume_019x_occulteye",
	"spacetume_celestialcrown",
	"spacetume_harmonicconvergence",
	"spacetume_juno",
	--48
	"costume_029_theinnereye",
	"costume_103_mutantspider",
	"costume_249_theresoptions",
	"costume_379_pupuladuplex",
	"costume_414_moreoptions",
	"costume_670_options",
}

local Character = {}

--Handles swapping of item costumes with and without skin alts for T Andromeda's costumes
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
	
	for i = 1, #itemCostumes do
		local itemConfig = Isaac.GetItemConfig():GetCollectible(itemCostumes[i])
		local itemName = itemConfig.Name
		local hasSkinAlt = itemConfig.Costume.HasSkinAlt
		
		if player:HasCollectible(itemCostumes[i]) then
			if itemCostumes[i] == Enums.Collectibles.ANDROMEDA_TECHX then
				itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_TECH_X)
			end
			
			if SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] == 1
			and SaveData.PlayerData.T_Andromeda.Costumes[itemName] ~= 10
			then
				if i < 48 then
					player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. costumeFileNames[i] .. "_blood.png", itemCostumes[i])
				else
					if not hasSkinAlt then
						player:RemoveCostume(itemConfig)
						player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. costumeFileNames[i] .. "_blood.anm2"))
					else
						player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. costumeFileNames[i] .. "_blood.png", itemCostumes[i])
					end
				end
				SaveData.PlayerData.T_Andromeda.Costumes[itemName] = 10
			elseif SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] ~= 1
			and SaveData.PlayerData.T_Andromeda.Costumes[itemName] ~= skinColor + 2
			then
				if i < 48 then
					if skinColor == SkinColor.SKIN_PINK then
						player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. costumeFileNames[i] .. ".png", itemCostumes[i])
					else
						player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. costumeFileNames[i] .. colors[skinColor + 2] .. ".png", itemCostumes[i])
					end
				else
					if not hasSkinAlt then
						player:RemoveCostume(itemConfig)
						player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. costumeFileNames[i] .. ".anm2"))
					else
						if skinColor == SkinColor.SKIN_PINK then
							player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. costumeFileNames[i] .. ".png", itemCostumes[i])
						else
							player:ReplaceCostumeSprite(itemConfig, "gfx/characters/costumes_andromedab/" .. costumeFileNames[i] .. colors[skinColor + 2] .. ".png", itemCostumes[i])
						end
					end
				end
				SaveData.PlayerData.T_Andromeda.Costumes[itemName] = skinColor + 2
			end
		else
			if SaveData.PlayerData.T_Andromeda.Costumes[itemName] ~= 0 then
				player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. costumeFileNames[i] .. ".anm2"))
				player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/" .. costumeFileNames[i] .. "_blood.anm2"))
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
	
	if game:GetFrameCount() > 0 then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
	for i = 1, #Blacklist do
		itemPool:RemoveCollectible(Blacklist[i])
	end

	player:AddNullCostume(headCostume)
	player:AddNullCostume(eyeCostume)
end

function Character.preRoomEntitySpawn(entity, variant, subType, gIndex, seed)
	if not Functions.AnyPlayerIsType(Enums.Characters.T_ANDROMEDA) then return end
	
	local room = game:GetRoom()

	if entity == EntityType.ENTITY_PICKUP
	and variant == PickupVariant.PICKUP_COLLECTIBLE
	and room:GetType() ~= RoomType.ROOM_BOSS
	and room:GetType() ~= RoomType.ROOM_DUNGEON
	and room:GetType() ~= RoomType.ROOM_ULTRASECRET
	and room:GetType() ~= RoomType.ROOM_CHALLENGE
	and not room:IsMirrorWorld()
	and not room:HasCurseMist()
	then
		return {0, 0, 0}
	end
end

function Character.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, room:GetCenterPos() + Vector(0, -20), Vector.Zero, player)
		local sprite = blackHole:GetSprite()
		local skinColor = player:GetHeadColor()

		if Functions.HasBloodTears(player) then
			sprite:Play("IdleVoidBlood")
		elseif not Functions.HasBloodTears(player) then
			sprite:Play(blackHoleAnims[skinColor + 2])
		end

		if SaveData.PlayerData.T_Andromeda.PlanetariumChance < 100 then
			if room:GetType() == RoomType.ROOM_PLANETARIUM then
				Functions.SetAbandonedPlanetarium(player, false)
			end

			for i = 0, 8 do
				local door = room:GetDoor(i)
				
				if door
				and door.TargetRoomType ~= RoomType.ROOM_SECRET
				and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET
				and ((door.TargetRoomType == RoomType.ROOM_PLANETARIUM or room:GetType() == RoomType.ROOM_PLANETARIUM) and room:GetType() ~= RoomType.ROOM_SECRET)
				then
					local doorSprite = room:GetDoor(i):GetSprite()
					doorSprite:Load("gfx/grid/andromeda_abandonedplanetariumdoor_hollowlol.anm2", true)
					doorSprite:ReplaceSpritesheet(0, "gfx/grid/andromeda_abandonedplanetariumdoor_hollowlol.png")
					doorSprite:Play("Opened")
				end
			end
		end

		--Prevent abusing deal rooms
		if room:GetType() == RoomType.ROOM_BOSS then
			for i = 0, 8 do
				local door = room:GetDoor(i)
				
				if door
				and (door.TargetRoomType == RoomType.ROOM_DEVIL or door.TargetRoomType == RoomType.ROOM_ANGEL)
				then
					room:RemoveDoor(i)
				end
			end
		end

		if level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then
			player:AddNullCostume(headCostume)
			player:AddNullCostume(eyeCostume)
			SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] = 0
		end

		if room:IsFirstVisit() then
			if room:GetType() == RoomType.ROOM_TREASURE
			and not Functions.ContainsQuestItem()
			and not player:HasTrinket(TrinketType.TRINKET_DEVILS_CROWN)
			and level:GetStage() < LevelStage.STAGE4_1
			and not game:IsGreedMode()
			and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
			then
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
			end
			
			--Recharge Singularity so that boss rush can be triggered
			if (room:GetType() == RoomType.ROOM_BOSSRUSH or room:GetType() == RoomType.ROOM_ERROR)
			and player:GetActiveCharge(ActiveSlot.SLOT_POCKET) < SINGULARITY_MAX * 2
			then
				Functions.ChargeSingularity(player, 12)
			end
			
			if #items > 0
			and not Functions.ContainsQuestItem()
			and Functions.GetDimension(roomDesc) ~= 2
			and level:GetCurrentRoomIndex() ~= GridRooms.ROOM_GENESIS_IDX
			then
				for i = 1, #items do
					if items[i].SubType > 0 then
						items[i]:Remove()
						
						--Replace items in crawlspaces and ultra secret rooms since they're rare
						if room:GetType() == RoomType.ROOM_DUNGEON then
							local randNum = rng:RandomInt(100)
							Functions.GetRandomChest(items[i].Position, randNum)
						elseif room:GetType() == RoomType.ROOM_ULTRASECRET then
							Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, items[i].Position, Vector.Zero, nil)
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
			
			--Remove restock machines in shops and black markets
			if room:GetType() == RoomType.ROOM_SHOP
			or room:GetType() == RoomType.ROOM_BLACK_MARKET
			then
				local restock = Isaac.FindByType(EntityType.ENTITY_SLOT, 10)
				
				if #restock > 0 then
					for i = 1, #restock do
						restock[i]:Remove()
					end
				end
			end

			if game:IsGreedMode()
			and room:IsFirstVisit()
			and (room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL or room:GetType() == RoomType.ROOM_PLANETARIUM)
			and level:GetCurrentRoomIndex() ~= GridRooms.ROOM_ANGEL_SHOP_IDX
			then
				Functions.ChargeSingularity(player, 12)
			end
		end
	end
end

function Character.postNewLevel()
	SaveData.PlayerData.T_Andromeda.PlanetariumChance = 100
end

function Character.preSpawnCleanAward()
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

		if (room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH)
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

	if player == nil then return end
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
end

function Character.postTearInit(tear)
	if tear.SpawnerEntity == nil then return end
	if tear.SpawnerEntity.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	Functions.ChangeTear(tear, player)
end

function Character.postFireTear(tear)
	local player = tear.Parent:ToPlayer()

	if tear.SpawnerType ~= EntityType.ENTITY_PLAYER then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()
	tear.Position = room:GetCenterPos()
	tear.Scale = tear.Scale + 0.37
	
	--Tainted Andromeda Birthright effect. Spawn additional tears that converge toward the black hole
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local randNum = rng:RandomInt(360)
		Functions.ConvergingTears(tear, player, room:GetCenterPos(), randNum, 1, true)
	end
end

function Character.preTearCollision(tear, collider, low)
	if tear.Parent == nil then return end
	if tear.SpawnerEntity == nil then return end
	if tear.SpawnerEntity.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = tear.Parent:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
	local bishops = Isaac.FindByType(EntityType.ENTITY_BISHOP, -1)

	if (collider:IsActiveEnemy() and not collider:IsVulnerableEnemy())
	or collider.Type == EntityType.ENTITY_MINECART
	or (#bishops > 0 and collider.Type ~= EntityType.ENTITY_BISHOP and collider:IsEnemy())
	then
		return true
	end
end

function Character.postLaserInit(laser)
	if laser.SpawnerEntity == nil then return end
	if laser.SpawnerType ~= EntityType.ENTITY_PLAYER then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()

	if (laser.SubType == 0 or ((laser.Variant == LaserVariant.THICK_RED or laser.Variant == LaserVariant.THICKER_RED or laser.Variant == LaserVariant.THICKER_BRIM_TECH) and laser.SubType == 2))
	and laser.Variant ~= LaserVariant.TRACTOR_BEAM
	and laser.Variant ~= LaserVariant.LIGHT_RING
	and laser.Variant ~= LaserVariant.ELECTRIC
	and laser.Variant ~= LaserVariant.THICK_BROWN
	then
		laser.Position = room:GetCenterPos()
		local vec = laser.Position - player.Position
		laser.Angle = vec:GetAngleDegrees()
		laser.ParentOffset = room:GetCenterPos() - player.Position
	end
	
	if (laser.Variant == LaserVariant.THIN_RED and laser.SubType == 2) --Tech X
	or laser.Variant == LaserVariant.BRIM_TECH
	then
		laser.Position = room:GetCenterPos()
	end
			
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	and laser.Variant ~= LaserVariant.SHOOP
	and laser.Variant ~= LaserVariant.TRACTOR_BEAM
	and laser.Variant ~= LaserVariant.LIGHT_RING
	and laser.Variant ~= LaserVariant.ELECTRIC
	then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local randNum = rng:RandomInt(360)
		Functions.ConvergingTears(laser, player, room:GetCenterPos(), randNum, 1, true)
	end
end

function Character.postLaserUpdate(laser)
	if laser.Parent == nil then return end
	if laser.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = laser.Parent:ToPlayer()

	if player == nil then return end
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

	local room = game:GetRoom()
	Functions.ChangeLaserColor(laser, player)
	
	--Exlude ring lasers, Technology, Trisagion, Tractor Beam, Jacob's Ladder/Tech 0, Montezuma's Revenge
	if laser.SubType == 0
	and laser.Variant ~= LaserVariant.THIN_RED
	and laser.Variant ~= LaserVariant.SHOOP
	and laser.Variant ~= LaserVariant.TRACTOR_BEAM
	and laser.Variant ~= LaserVariant.ELECTRIC
	and laser.Variant ~= LaserVariant.THICK_BROWN
	then
		laser.Position = room:GetCenterPos()
		local vec = laser.Position - player.Position
		laser.Angle = vec:GetAngleDegrees()
		laser.ParentOffset = room:GetCenterPos() - player.Position
	end
end

function Character.postBombUpdate(bomb)
	if bomb.FrameCount ~= 1 then return end
	if not bomb.IsFetus then return end
	if bomb.Parent == nil then return end
	if bomb.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = bomb.Parent:ToPlayer()

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
	local timer = frameCount + 4
	local gameFrame = game:GetFrameCount()
	local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
			
	--Update costumes to match head color
	ChangeCostume(player)
			
	--Gravitational pull on pickups
	if #pickups > 0 then
		for i = 1, #pickups do
			if (pickups[i].Variant > 0 and pickups[i].Variant < PickupVariant.PICKUP_MEGACHEST)
			or (pickups[i].Variant > PickupVariant.PICKUP_MEGACHEST and pickups[i].Variant < PickupVariant.PICKUP_COLLECTIBLE)
			or pickups[i].Variant == PickupVariant.PICKUP_TAROTCARD
			or pickups[i].Variant == PickupVariant.PICKUP_TRINKET
			or pickups[i].Variant == PickupVariant.PICKUP_REDCHEST
			then
				local vec = player.Position - pickups[i].Position
				local angle = vec:GetAngleDegrees()
				local fromAngle = Vector.FromAngle(angle)
				local newVec = Vector(fromAngle.X / 20, fromAngle.Y / 20)
				pickups[i]:AddVelocity(newVec)
			end
		end
	end
	
	--For modded items that add additional items when entering rooms
	if room:IsFirstVisit()
	and room:GetFrameCount() == 1
	and Functions.GetDimension(roomDesc) ~= 2
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
		if not player:HasCollectible(Enums.Collectibles.SINGULARITY) then
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
	
	if room:GetType() == RoomType.ROOM_PLANETARIUM
	and SaveData.PlayerData.T_Andromeda.PlanetariumChance < 100
	and MusicManager():GetCurrentMusicID() ~= Enums.Music.EDGE_OF_THE_UNIVERSE
	then
		MusicManager():Play(Enums.Music.EDGE_OF_THE_UNIVERSE, 0)
		MusicManager():UpdateVolume()
	end

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		local brimSwirl = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, -1)
		local techDot = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TECH_DOT, -1)
		
		if #brimSwirl > 0 then
			for i = 1, #brimSwirl do
				if brimSwirl[i].SpawnerType == EntityType.ENTITY_PLAYER then
					Functions.ChangeLaserColor(brimSwirl[i], player)
				end
			end
		end
		
		if #techDot > 0 then
			for i = 1, #techDot do
				if techDot[i].SpawnerType == EntityType.ENTITY_PLAYER then
					Functions.ChangeLaserColor(techDot[i], player)
				end
			end
		end
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
	local room = game:GetRoom()
	local sprite = effect:GetSprite()

	if effect.Variant == Enums.Effects.BLACK_HOLE then
		effect.Position = room:GetCenterPos() + Vector(0, -20)

		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			
			if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

			local skinColor = player:GetHeadColor()
			
			if not sprite:IsPlaying("IdleVoidBlood")
			and Functions.HasBloodTears(player)
			then
				sprite:Play("IdleVoidBlood")
			elseif not Functions.HasBloodTears(player) then
				if not sprite:IsPlaying(blackHoleAnims[skinColor + 2]) then
					sprite:Play(blackHoleAnims[skinColor + 2])
				end
			end
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
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			local tempEffects = player:GetEffects()
			
			if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	
			if effect.FrameCount == 1
			and not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_LEO)
			then
				tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_LEO, false, 1)
				tempEffects:AddNullEffect(NullItemID.ID_TOOTH_AND_NAIL, false, 1)
			end

			effect.Position = player.Position
			effect.TargetPosition = player.Position
		end
	end
end

function Character.postEntityRemove(entity)
	if entity.Type ~= EntityType.ENTITY_EFFECT then return end
	if entity.Variant ~= EffectVariant.BLACK_HOLE then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local tempEffects = player:GetEffects()
		
		if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end

		if entity.FrameCount == 206 then
			tempEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_LEO, 1)
			tempEffects:RemoveNullEffect(NullItemID.ID_TOOTH_AND_NAIL, 1)
			player:SetMinDamageCooldown(60)
		end
	end
end

function Character.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	if item ~= CollectibleType.COLLECTIBLE_CLICKER then return end
	
	player:TryRemoveNullCostume(headCostume)
	player:TryRemoveNullCostume(eyeCostume)
	player:TryRemoveNullCostume(bloodHeadCostume)
	player:TryRemoveNullCostume(bloodEyeCostume)
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