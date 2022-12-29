local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

local Item = {}

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.EXTINCTION_EVENT then return end
	
	return true
end

function Item.preTearCollision(tear, collider, low)
	if tear:GetData().isMeteor
	and collider.Type == EntityType.ENTITY_BOMBDROP
	then
		return true
	end
end

function Item.postEntityRemove(entity)
	if entity.Type ~= EntityType.ENTITY_TEAR then return end
	
	local tear = entity

	if tear:GetData().isMeteor
	and tear.SpawnerEntity
	then
		local player = tear.SpawnerEntity:ToPlayer()
		local radius = (0.5345 * math.sqrt(tear.CollisionDamage)) / 2
		game:BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, Color(1, 1, 1, 1, 0, 0, 0), player, radius)
	end
end

function Item.postPEffectUpdate(player)
	local tempEffects = player:GetEffects()
	
	if not tempEffects:HasCollectibleEffect(Enums.Collectibles.EXTINCTION_EVENT) then return end
	
	local rng = player:GetCollectibleRNG(Enums.Collectibles.EXTINCTION_EVENT)
	local fireEffect = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME)
	local randNum = rng:RandomInt(16)
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
	or tempEffects:GetCollectibleEffectNum(Enums.Collectibles.EXTINCTION_EVENT) > 1
	then
		randNum = rng:RandomInt(8)
	end

	if randNum == 0 then
		Functions.SpawnMeteor(player, rng)
	end
	
	if #fireEffect == 0 then return end
	
	for _, fire in pairs(fireEffect) do
		if fire.SpawnerType == EntityType.ENTITY_TEAR then
			fire:Remove()
		end
	end
end

return Item