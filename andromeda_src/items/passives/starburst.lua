local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

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

function Item.postFireTear(tear)
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.STARBURST) then return end
	
	local sprite = tear:GetSprite()
	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local randFloat = rng:RandomFloat()
	
	if randFloat < 0.06 then
		sprite:ReplaceSpritesheet(0, "gfx/tears/tears_starburst.png")
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

	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local randNum = rng:RandomInt(5) + 8
	
	if game:GetFrameCount() % randNum == 0 then
		local starTrail = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.STARBURST_STAR_TRAIL, 0, tear.Position, tear.Velocity * Vector(0.3, 0.3), tear)
		local sprite = starTrail:GetSprite()
		randNum = rng:RandomInt(5) + 1

		sprite:Play("Shiny " .. randNum)
		starTrail.PositionOffset = tear.PositionOffset
		starTrail.Parent = tear
		starTrail.Color = Color(rng:RandomFloat(), rng:RandomFloat(), rng:RandomFloat(), 1, 0, 0, 0)
	end

	randNum = rng:RandomInt(4) + 3

	if game:GetFrameCount() % 5 == 0 then
		local trailEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.STARBURST_TRAIL, 0, tear.Position, Vector.Zero, tear)
		local sprite = trailEffect:GetSprite()

		sprite:Play(tear:GetSprite():GetAnimation())
		trailEffect.PositionOffset = tear.PositionOffset
		trailEffect.Parent = tear
	end

	if tear:CollidesWithGrid() then
		Functions.StarBurst(player, tear.Position)
	end
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

	Functions.StarBurst(player, tear.Position)
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
		Functions.StarBurst(player, bomb.Position)
	end
end

function Item.postEffectUpdate(effect)
	local sprite = effect:GetSprite()
	
	if effect.Variant == EffectVariant.ROCKET then
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
			Functions.StarBurst(player, effect.Position)
		end
	elseif (effect.Variant == Enums.Effects.STARBURST_TRAIL or effect.Variant == Enums.Effects.STARBURST_STAR_TRAIL)
	and sprite:IsFinished(sprite:GetAnimation())
	then
		effect:Remove()
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
		
		if player:HasCollectible(Enums.Collectibles.STARBURST)
		and rng:RandomFloat() < 0.06
		then
			Functions.StarBurst(player, enemy.Position)
		end
	elseif source.Entity.SpawnerEntity then
		local player = source.Entity.SpawnerEntity:ToPlayer()
	
		if player
		and player:HasCollectible(Enums.Collectibles.STARBURST)
		then
			local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)

			if rng:RandomFloat() < 0.06 then
				if (source.Entity.Type == EntityType.ENTITY_TEAR and source.Entity:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO))
				or source.Entity.Type == EntityType.ENTITY_KNIFE
				then
					Functions.StarBurst(player, enemy.Position)
				end
			end
		end
	end
end

function Item.useCard(card, player, flag)
	if not player:HasCollectible(Enums.Collectibles.STARBURST) then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end

	if card == Enums.Cards.ALPHA_CENTAURI
	or card == Enums.Cards.BETELGEUSE
	or card == Enums.Cards.SIRIUS
	then
		Functions.StarBurst(player, player.Position)
	end
end

return Item