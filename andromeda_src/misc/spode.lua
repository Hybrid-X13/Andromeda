local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local SPODE_COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/transformation_cosmicgod.anm2")
local LAST_FRAME = 26

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
	TearFlags.TEAR_FETUS_TECH,
	TearFlags.TEAR_LUDOVICO,
}

local Spode = {}

local function CosmicTears(entity, player, pos)
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local velocity = Vector.Zero

	if entity.Type == EntityType.ENTITY_EFFECT
	or entity.Type == EntityType.ENTITY_BOMB
	then
		velocity = RandomVector() * rng:RandomFloat() * (rng:RandomInt(15) + 1)
	end
	
	local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, velocity, player):ToTear()
	local sprite = newTear:GetSprite()
	local randNum = rng:RandomInt(#colors) + 1
	
	if entity.Type == EntityType.ENTITY_EFFECT
	or entity.Type == EntityType.ENTITY_BOMB
	then
		newTear:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING | TearFlags.TEAR_DECELERATE)
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

		if entity:GetData().starburstTear then
			newTear:GetData().starburstTear = true
		end
	elseif entity.Type == EntityType.ENTITY_EFFECT
	or entity.Type == EntityType.ENTITY_BOMB
	then
		randNum = rng:RandomInt(LAST_FRAME) + 1
		
		for i = 1, randNum do
			sprite:Update()
		end

		newTear.FallingSpeed = newTear.FallingSpeed - (2 * rng:RandomFloat())
	else
		newTear.FallingAcceleration = 0
		newTear.FallingSpeed = -3
	end

	if entity.Type ~= EntityType.ENTITY_TEAR
	and player:HasCollectible(Enums.Collectibles.STARBURST)
	and rng:RandomFloat() < 0.06
	then
		newTear:GetData().starburstTear = true
	end
end

function Spode.postPlayerInit(player)
	player:GetData().hasSpode = false
end

function Spode.evaluateCache(player, cacheFlag)
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	if cacheFlag ~= CacheFlag.CACHE_SHOTSPEED then return end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then return end
	
	player.ShotSpeed = player.ShotSpeed - 0.4
end

function Spode.postTearUpdate(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = Functions.GetPlayerFromSpawnerEntity(tear)

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	if tear:GetData().isSpodeTear then return end
	
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(100)
	
	if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		randNum = rng:RandomInt(90)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
	then
		if player:GetPlayerType() == Enums.Characters.ANDROMEDA
		or tear:HasTearFlags(TearFlags.TEAR_ORBIT)
		then
			randNum = rng:RandomInt(300)
		else
			randNum = rng:RandomInt(200)
		end
	elseif player:GetPlayerType() == Enums.Characters.ANDROMEDA
	or tear:HasTearFlags(TearFlags.TEAR_ORBIT)
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
	if laser.SpawnerEntity == nil then return end
	if laser:GetData().isSolarFlare then return end
	if laser.Variant == LaserVariant.TRACTOR_BEAM then return end
	if laser.Variant == LaserVariant.LIGHT_RING then return end
	if laser.Variant == LaserVariant.ELECTRIC then return end

	local player = Functions.GetPlayerFromSpawnerEntity(laser)

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(6)
		
	if laser.Variant == LaserVariant.SHOOP
	and laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR
	then
		randNum = rng:RandomInt(1000)
	elseif laser:GetData().andromedaTechX then
		randNum = rng:RandomInt(200)
	elseif laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
		randNum = rng:RandomInt(50)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
	then
		if laser.SubType > LaserSubType.LASER_SUBTYPE_LINEAR then
			randNum = rng:RandomInt(30)
		else
			randNum = rng:RandomInt(25)
		end
	elseif laser.SubType > LaserSubType.LASER_SUBTYPE_LINEAR
	or player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA)
	then
		randNum = rng:RandomInt(25)
	elseif laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR then
		randNum = rng:RandomInt(8)
	end
	
	if randNum == 0 then
		local pos = player.Position + Vector.FromAngle(randNum):Resized(40)
		randNum = rng:RandomInt(360)
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)
		or player:HasCollectible(Enums.Collectibles.ANDROMEDA_TECHX)
		then
			pos = laser.Position
		end
		
		CosmicTears(laser, player, pos)
	end
end

function Spode.postKnifeUpdate(knife)
	if knife.SpawnerEntity == nil then return end

	local player = Functions.GetPlayerFromSpawnerEntity(knife)

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
	if bomb.SpawnerEntity == nil then return end

	local player = Functions.GetPlayerFromSpawnerEntity(bomb)

	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randFloat = rng:RandomFloat()
	
	if bomb:IsDead()
	and randFloat < 0.2
	then
		local numStars = rng:RandomInt(6) + 5

		for i = 1, numStars do
			CosmicTears(bomb, player, bomb.Position)
		end
	end
end

function Spode.postEffectUpdate(effect)
	if effect.Variant ~= EffectVariant.ROCKET then return end
	if effect.SpawnerEntity == nil then return end

	local player = Functions.GetPlayerFromSpawnerEntity(effect)

  	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randFloat = rng:RandomFloat()

	if effect:IsDead()
	and not effect:Exists()
	and randFloat < 0.2
	then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
		local numStars = rng:RandomInt(10) + 5

		for i = 1, numStars do
			CosmicTears(effect, player, effect.Position)
		end
	end
end

function Spode.postNewRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetData().hasSpode
		and not player:HasCurseMistEffect()
		and not player:IsCoopGhost()
		then
			local tempEffects = player:GetEffects()
		
			if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
				tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, false, 1)
			end
		end
	end
end

function Spode.postPEffectUpdate(player)
	local playerType = player:GetPlayerType()
	
	if playerType == Isaac.GetPlayerTypeByName("Sodom", false) then return end
	if playerType == Isaac.GetPlayerTypeByName("Sodom", true) then return end
	if playerType == Isaac.GetPlayerTypeByName("Gomorrah", false) then return end
	if playerType == Isaac.GetPlayerTypeByName("Gomorrah", true) then return end
	if player:IsCoopGhost() or (player.SubType == 59 and player.Parent ~= nil) then return end

	if Functions.HasFullCompletion(Enums.Characters.ANDROMEDA)
	or playerType == Enums.Characters.ANDROMEDA
	or playerType == Enums.Characters.T_ANDROMEDA
	then
		local itemCount = 0
		
		if not player:GetData().hasSpode
		or player:GetData().hasSpode == nil
		then
			for i = 1, #CustomData.SpodeList do
				if player:HasCollectible(CustomData.SpodeList[i], true) then
					itemCount = itemCount + player:GetCollectibleNum(CustomData.SpodeList[i], true)
				end
			end

			if ((itemCount >= 4 or player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) and playerType == Enums.Characters.ANDROMEDA)
			or (itemCount >= 3 and playerType ~= Enums.Characters.ANDROMEDA)
			then
				game:GetHUD():ShowItemText("Spode!")
				sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
				player:AddNullCostume(SPODE_COSTUME)
				player:GetData().hasSpode = true
			end
		elseif player:GetData().hasSpode then
			player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
			player:EvaluateItems()
			
			for i = 1, #CustomData.SpodeList do
				if player:HasCollectible(CustomData.SpodeList[i], true) then
					itemCount = itemCount + player:GetCollectibleNum(CustomData.SpodeList[i], true)
				end
			end

			if (itemCount < 4 and not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and playerType == Enums.Characters.ANDROMEDA)
			or (itemCount < 3 and playerType ~= Enums.Characters.ANDROMEDA)
			then
				player:GetData().hasSpode = false
				player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, 1)
				player:TryRemoveNullCostume(SPODE_COSTUME)
				player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
				player:EvaluateItems()
			end
		end
	end
end

function Spode.postPlayerUpdate(player)
	if player:GetData().hasSpode == nil or not player:GetData().hasSpode then return end
	if player:HasCurseMistEffect() then return end
	if player:IsCoopGhost() then return end

	local tempEffects = player:GetEffects()

	if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, false, 1)
	end
end

function Spode.preTearCollision(tear, collider, low)
	if collider.Type ~= EntityType.ENTITY_BOMB then return end
	if tear:GetData().isSpodeTear == nil or not tear:GetData().isSpodeTear then return end
	
	return true
end

return Spode
