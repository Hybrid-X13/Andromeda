local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local rng = RNG()
local convergence = 0

local Item = {}

function Item.postFireTear(tear)
	local player = tear.Parent:ToPlayer()
	
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end
	if player:HasCollectible(Enums.Collectibles.ANDROMEDA_TECHX) then return end
	
	local angle = 0
	
	if convergence % 2 ~= 0 then
		angle = 45
	end
	
	for i = 0, 3 do
		angle = angle + (90 * i)
		Functions.ConvergingTears(tear, player, player.Position, angle, 4, false)
	end
	convergence = convergence + 1
end

function Item.postLaserInit(laser)
	if laser.SpawnerEntity == nil then return end
	if laser.SpawnerType ~= EntityType.ENTITY_PLAYER then return end

	local player = laser.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end
	
	if laser.Variant ~= LaserVariant.SHOOP
	and laser.Variant ~= LaserVariant.TRACTOR_BEAM
	and laser.Variant ~= LaserVariant.LIGHT_RING
	and laser.Variant ~= LaserVariant.ELECTRIC
	then
		local angle = 0
	
		if convergence % 2 ~= 0 then
			angle = 45
		end
		
		for i = 0, 3 do
			local dmgDivider = 1
			angle = angle + (90 * i)
			
			if laser.Variant == LaserVariant.THIN_RED then
				dmgDivider = 4
			end
			
			Functions.ConvergingTears(laser, player, player.Position, angle, dmgDivider, false)
		end
		convergence = convergence + 1
	end
end

function Item.postBombUpdate(bomb)
	if bomb.FrameCount ~= 1 then return end
	if not bomb.IsFetus then return end
	if bomb.Parent == nil then return end
	if bomb.Parent.Type ~= EntityType.ENTITY_PLAYER then return end

	local player = bomb.Parent:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end

	local angle = 0
	
	if convergence % 2 ~= 0 then
		angle = 45
	end
	
	for i = 0, 3 do
		angle = angle + (90 * i)
		Functions.ConvergingTears(bomb, player, player.Position, angle, 4, false)
	end
	convergence = convergence + 1
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
		local angle = 0
		
		if convergence % 2 ~= 0 then
			angle = 45
		end
		
		for i = 0, 3 do
			local dmgDivider = 1
			angle = angle + (90 * i)
			
			Functions.ConvergingTears(effect, player, player.Position, angle, dmgDivider, false)
		end
		convergence = convergence + 1
	end
end

function Item.preTearCollision(tear, collider, low)
	if tear:GetData().convergingTear
	and collider.Type == EntityType.ENTITY_BOMBDROP
	then
		return true
	end
end

return Item