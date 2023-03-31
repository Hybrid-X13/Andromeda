local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local sfx = SFXManager()
local rng = RNG()
local LAST_FRAME = 26

local colors = {
	"red",
	"lightred",
	"orange",
	"yellow",
	"blue",
	"white",
}

local Item = {}

local function HasTearCollided(tearTable, tear)
	if #tearTable == 0 then return false end
	
	for i = 1, #tearTable do
		if tear.InitSeed == tearTable[i] then
			return true
		end
	end

	return false
end

local function StarBurst(player, pos)
	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local numStars = rng:RandomInt(7) + 5

	for i = 1, numStars do
		local velocity = RandomVector() * rng:RandomFloat() * (rng:RandomInt(15) + 1)
		local starTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, velocity, player):ToTear()
		local sprite = starTear:GetSprite()
		local randNum = rng:RandomInt(#colors) + 1

		sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
		randNum = rng:RandomInt(LAST_FRAME) + 1
			
		for i = 1, randNum do
			sprite:Update()
		end

		randNum = rng:RandomInt(30)  * rng:RandomFloat()
		starTear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_DECELERATE)
		starTear.CollisionDamage = (player.Damage / 2) * rng:RandomFloat()
		starTear.Scale = 0.5345 * math.sqrt(starTear.CollisionDamage)
		starTear.FallingSpeed = starTear.FallingSpeed - randNum
		starTear:GetData().isSpodeTear = true
	end

	sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.7, 2, false, 1.7)
end

function Item.postFireTear(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.STARBURST) then return end
	
	local sprite = tear:GetSprite()
	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local randFloat = rng:RandomFloat()
	
	if randFloat < 0.06 then
		sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
		sprite:LoadGraphics()
		tear:GetData().starburstTear = true
	end
end

function Item.postTearUpdate(tear)
	if tear:GetData().starburstTear == nil then return end
	if tear.SpawnerEntity == nil then return end
	
	local player = Functions.GetPlayerFromSpawnerEntity(tear)
	
	if player == nil then return end
	if player:HasCurseMistEffect() then return end
	if not tear:CollidesWithGrid() then return end
	
	StarBurst(player, tear.Position)
end

function Item.preTearCollision(tear, collider, low)
	if tear:GetData().starburstTear == nil then return end
	if tear.SpawnerEntity == nil then return end
	if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then return end
	if not collider:IsActiveEnemy() then return end
	if collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	
	local player = Functions.GetPlayerFromSpawnerEntity(tear)
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.STARBURST) then return end

	if collider:GetData().starburstTable == nil then
		collider:GetData().starburstTable = {}
	end
	
	if HasTearCollided(collider:GetData().starburstTable, tear) then return end

	StarBurst(player, tear.Position)
	table.insert(collider:GetData().starburstTable, tear.InitSeed)
end

function Item.postBombUpdate(bomb)
	if not bomb.IsFetus then return end
	if bomb.SpawnerEntity == nil then return end

	local player = Functions.GetPlayerFromSpawnerEntity(bomb)

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.STARBURST) then return end

	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local randFloat = rng:RandomFloat()
	
	if bomb:IsDead()
	and randFloat < 0.06
	then
		StarBurst(player, bomb.Position)
	end
end

function Item.postEffectUpdate(effect)
	if effect.Variant ~= EffectVariant.ROCKET then return end
	if effect.SpawnerEntity == nil then return end

	local player = Functions.GetPlayerFromSpawnerEntity(effect)

  	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.STARBURST) then return end

	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local randFloat = rng:RandomFloat()

	if effect:IsDead()
	and not effect:Exists()
	and randFloat < 0.06
	then
		StarBurst(player, effect.Position)
	end
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not enemy:IsActiveEnemy() then return end
	if source.Entity == nil then return end

	if flag & DamageFlag.DAMAGE_LASER == DamageFlag.DAMAGE_LASER
	and source.Entity.Type == EntityType.ENTITY_PLAYER
	then
		local player = source.Entity:ToPlayer()
		local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
		
		if rng:RandomFloat() < 0.06 then
			StarBurst(player, enemy.Position)
		end
	elseif source.Entity.SpawnerEntity then
		local player = source.Entity.SpawnerEntity:ToPlayer()
	
		if player then
			local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)

			if rng:RandomFloat() < 0.06 then
				if (source.Entity.Type == EntityType.ENTITY_TEAR and source.Entity:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO))
				or source.Entity.Type == EntityType.ENTITY_KNIFE
				then
					StarBurst(player, enemy.Position)
				end
			end
		end
	end
end

return Item