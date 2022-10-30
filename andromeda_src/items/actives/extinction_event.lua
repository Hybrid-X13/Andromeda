local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()
local meteorShower = false

local Item = {}

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.EXTINCTION_EVENT then return end
	
	meteorShower = true
	return true
end

function Item.postNewRoom()
	if meteorShower then
		meteorShower = false
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
		game:BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, player, radius)
	end
end

function Item.postPEffectUpdate(player)
	if not meteorShower then return end
	
	local rng = player:GetCollectibleRNG(Enums.Collectibles.EXTINCTION_EVENT)
	local fire = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME)
	local randNum = rng:RandomInt(16)
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		randNum = rng:RandomInt(8)
	end

	if randNum == 0 then
		Functions.SpawnMeteor(player, rng)
	end
	
	if #fire == 0 then return end
	
	for i = 1, #fire do
		if fire[i].SpawnerType == EntityType.ENTITY_TEAR then
			fire[i]:Remove()
		end
	end
end

return Item