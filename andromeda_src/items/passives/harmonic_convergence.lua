local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local rng = RNG()
local convergence = 0

local Item = {}

local function SpawnConvergingTears(entity, player, dmgDivider)
	local angle = 0

	if convergence % 2 ~= 0 then
		angle = 45
	end

	if entity.Type == EntityType.ENTITY_LASER
	and (entity.Variant == LaserVariant.THIN_RED or entity.Variant == LaserVariant.SHOOP)
	then
		dmgDivider = 4
	end

	for i = 0, 3 do
		angle = angle + (90 * i)
		Functions.ConvergingTears(entity, player, player.Position, angle, dmgDivider, false)
	end
	convergence = convergence + 1
end

function Item.postFireTear(tear)
	if not tear.Visible then return end
	if tear.SpawnerEntity == nil then return end

	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end

	SpawnConvergingTears(tear, player, 4)
end

function Item.postLaserInit(laser)
	if laser.SpawnerEntity == nil then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end
	
	if laser.Variant ~= LaserVariant.TRACTOR_BEAM
	and laser.Variant ~= LaserVariant.LIGHT_RING
	and laser.Variant ~= LaserVariant.ELECTRIC
	then
		SpawnConvergingTears(laser, player, 1)
	end
end

function Item.postBombUpdate(bomb)
	if bomb.FrameCount ~= 1 then return end
	if not bomb.IsFetus then return end
	if bomb.SpawnerEntity == nil then return end

	local player = bomb.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end

	SpawnConvergingTears(bomb, player, 4)
end

function Item.postEffectUpdate(effect)
	if effect.Variant ~= EffectVariant.ROCKET then return end
	if effect.SpawnerEntity == nil then return end

	local player = effect.SpawnerEntity:ToPlayer()

  	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end

	if effect:IsDead()
	and not effect:Exists()
	then
		SpawnConvergingTears(effect, player, 4)
	end
end

function Item.preTearCollision(tear, collider, low)
	if tear:GetData().convergingTear
	and collider.Type == EntityType.ENTITY_BOMB
	then
		return true
	end
end

return Item