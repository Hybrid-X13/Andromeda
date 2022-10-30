local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
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
	if laser.SpawnerType ~= EntityType.ENTITY_PLAYER then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE) then return end

		if laser.Variant ~= 3
		and laser.Variant ~= 7
		and laser.Variant ~= 8
		and laser.Variant ~= 10
		then
			local angle = 0
		
			if convergence % 2 ~= 0 then
				angle = 45
			end
			
			for i = 0, 3 do
				local dmgDivider = 1
				angle = angle + (90 * i)
				
				if laser.Variant == 2 then
					dmgDivider = 4
				end
				
				Functions.ConvergingTears(laser, player, player.Position, angle, dmgDivider, false)
			end
			convergence = convergence + 1
		end
	end
end

function Item.postBombUpdate(bomb)
	if bomb.SpawnerType ~= EntityType.ENTITY_PLAYER then return end
	if not bomb.IsFetus then return end
	if bomb.FrameCount ~= 1 then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
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
end

function Item.preTearCollision(tear, collider, low)
	if tear:GetData().convergingTear
	and collider.Type == EntityType.ENTITY_BOMBDROP
	then
		return true
	end
end

return Item