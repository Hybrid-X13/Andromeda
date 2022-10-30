local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local spodeCostume = Isaac.GetCostumeIdByPath("gfx/characters/transformation_cosmicgod.anm2")

local colors = {
	"red",
	"lightred",
	"orange",
	"yellow",
	"blue",
	"white",
}

local tearBlacklist = {
	TearFlags.TEAR_ORBIT,
	TearFlags.TEAR_ORBIT_ADVANCED,
	TearFlags.TEAR_LASERSHOT,
	TearFlags.TEAR_SPLIT,
	TearFlags.TEAR_QUADSPLIT,
	TearFlags.TEAR_BURSTSPLIT,
	TearFlags.TEAR_EXPLOSIVE,
	TearFlags.TEAR_LASER,
	TearFlags.TEAR_STICKY,
}

local Spode = {}

local function CosmicTears(entity, player, pos)
	local spawnTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, Vector.Zero, player)
	local newTear = spawnTear:ToTear()
	local sprite = newTear:GetSprite()
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(6) + 1
	
	if entity.Type == EntityType.ENTITY_BOMBDROP then
		newTear:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	else
		newTear:AddTearFlags(entity.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	end
	
	for i = 1, #tearBlacklist do
		newTear:ClearTearFlags(tearBlacklist[i])
	end
	
	sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
	newTear.CollisionDamage = player.Damage / 4
	newTear.Scale = 0.5345 * math.sqrt(newTear.CollisionDamage)
	newTear.WaitFrames = 0
	newTear.HomingFriction = 0.8
	newTear:GetData().isSpodeTear = true
	
	if entity.Type == EntityType.ENTITY_TEAR then
		newTear.FallingAcceleration = entity.FallingAcceleration
		newTear.FallingSpeed = entity.FallingSpeed
	else
		newTear.FallingAcceleration = 0
		newTear.FallingSpeed = -3
	end
end

function Spode.postPlayerInit(player)
	player:GetData().hasSpode = false
end

function Spode.evaluateCache(player, cacheFlag)
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	
	if cacheFlag == CacheFlag.CACHE_FLYING then
		player.CanFly = true
	end
	
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed - 0.4
	end
end

function Spode.postTearUpdate(tear)
	if tear.Parent == nil then return end
	if tear.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = tear.Parent:ToPlayer()

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(100)
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
		randNum = rng:RandomInt(200)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
	then
		if player:GetPlayerType() == Enums.Characters.ANDROMEDA
		or player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
		then
			randNum = rng:RandomInt(300)
		else
			randNum = rng:RandomInt(200)
		end
	elseif player:GetPlayerType() == Enums.Characters.ANDROMEDA
	or player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
	then
		if tear:HasTearFlags(TearFlags.TEAR_SPLIT) then
			randNum = rng:RandomInt(800)
		else
			randNum = rng:RandomInt(200)
		end
	end
	
	if randNum == 0 then
		CosmicTears(tear, player, tear.Position)
	end
end

function Spode.postLaserUpdate(laser)
	if laser.Parent == nil then return end
	if laser.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = laser.Parent:ToPlayer()

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(6)
			
	if laser.Variant ~= 7
	and laser.Variant ~= 8
	and laser.Variant ~= 10
	and (not laser:GetData().isSolarFlare or laser:GetData().isSolarFlare == nil)
	then
		if laser.Variant == 3 and laser.SubType == 0 then --Trisagion
			randNum = rng:RandomInt(1000)
		elseif laser.Variant == 2 and laser.SubType == 2 then --Tech X
			randNum = rng:RandomInt(50)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
		then
			randNum = rng:RandomInt(30)
		elseif laser.SubType > 0 --Ring lasers
		or player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA)
		then
			if player:GetPlayerType() == Enums.Characters.ANDROMEDA
			and laser.Variant == 2
			and laser.SubType == 3
			then
				randNum = rng:RandomInt(225)
			else
				randNum = rng:RandomInt(25)
			end
		elseif laser.Variant == 2
		and laser.SubType == 0
		then
			randNum = rng:RandomInt(10)
		end
		
		if randNum == 0 then
			local pos
			randNum = rng:RandomInt(360)
			
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
				pos = laser.Position
			else
				pos = player.Position + Vector.FromAngle(randNum):Resized(40)
			end
			
			CosmicTears(laser, player, pos)
		end
	end
end

function Spode.postKnifeUpdate(knife)
	if knife.Parent == nil then return end
	if knife.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = knife.Parent:ToPlayer()

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(30)
	
	if randNum == 0 then
		CosmicTears(knife, player, knife.Position)
	end
end

function Spode.postBombUpdate(bomb)
	if not bomb.IsFetus then return end
	if bomb.Parent == nil then return end
	if bomb.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = bomb.Parent:ToPlayer()

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(25)
	
	if randNum == 0 then
		randNum = rng:RandomInt(360)
		local pos = player.Position + Vector.FromAngle(randNum):Resized(40)
		CosmicTears(bomb, player, pos)
	end
end

function Spode.postPEffectUpdate(player)
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	if player:IsCoopGhost() then return end

	if Functions.HasFullCompletion(Enums.Characters.ANDROMEDA)
	or player:GetPlayerType() == Enums.Characters.ANDROMEDA
	or player:GetPlayerType() == Enums.Characters.T_ANDROMEDA
	then
		local itemCount = 0
		local cassiopeia = Isaac.GetItemIdByName("Cassiopeia")
		
		if not player:GetData().hasSpode
		or player:GetData().hasSpode == nil
		then
			for i = 1, #CustomData.SpodeList do
				if player:HasCollectible(CustomData.SpodeList[i], true) then
					itemCount = itemCount + player:GetCollectibleNum(CustomData.SpodeList[i], true)
				end
			end
			
			if cassiopeia > 0 then
				if player:HasCollectible(cassiopeia, true) then
					itemCount = itemCount + player:GetCollectibleNum(cassiopeia, true)
				end
			end

			if ((itemCount >= 4 or player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) and player:GetPlayerType() == Enums.Characters.ANDROMEDA)
			or (itemCount >= 3 and player:GetPlayerType() ~= Enums.Characters.ANDROMEDA)
			then
				game:GetHUD():ShowItemText("Spode!")
				sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
				player:AddNullCostume(spodeCostume)
				player:GetData().hasSpode = true
			end
		elseif player:GetData().hasSpode then
			player:AddCacheFlags(CacheFlag.CACHE_FLYING | CacheFlag.CACHE_SHOTSPEED)
			player:EvaluateItems()
			
			for i = 1, #CustomData.SpodeList do
				if player:HasCollectible(CustomData.SpodeList[i], true) then
					itemCount = itemCount + player:GetCollectibleNum(CustomData.SpodeList[i], true)
				end
			end
			
			if cassiopeia > 0 then
				if player:HasCollectible(cassiopeia, true) then
					itemCount = itemCount + player:GetCollectibleNum(cassiopeia, true)
				end
			end

			if (itemCount < 4 and not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetPlayerType() == Enums.Characters.ANDROMEDA)
			or (itemCount < 3 and player:GetPlayerType() ~= Enums.Characters.ANDROMEDA)
			then
				player:GetData().hasSpode = false
				player:TryRemoveNullCostume(spodeCostume)
				player:AddCacheFlags(CacheFlag.CACHE_FLYING | CacheFlag.CACHE_SHOTSPEED)
				player:EvaluateItems()
			end
		end
	end
end

function Spode.preTearCollision(tear, collider, low)
	if collider.Type ~= EntityType.ENTITY_BOMBDROP then return end
	if tear:GetData().isSpodeTear == nil or not tear:GetData().isSpodeTear then return end
	
	return true
end

return Spode