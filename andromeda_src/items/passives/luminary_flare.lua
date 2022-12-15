local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

local idleFaces = {
	"IdleFace",
	"IdleFace2",
	"IdleFace3",
}

local Item = {}

local function PlayRandomOverlay(player, sprite)
	local rng = player:GetCollectibleRNG(Enums.Collectibles.LUMINARY_FLARE)
	local randNum = rng:RandomInt(#idleFaces) + 1
	sprite:PlayOverlay(idleFaces[randNum], false)
end

function Item.postNewRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local room = game:GetRoom()
		
		if not player:HasCollectible(Enums.Collectibles.LUMINARY_FLARE) then return end
		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then return end
		
		Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.LUMINARY_SUN, 0, room:GetCenterPos() + Vector(0, -20), Vector.Zero, player)
	end
end

function Item.postNPCDeath(npc)
	if Functions.IsInvulnerableEnemy(npc) then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	
	rng:SetSeed(npc.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local room = game:GetRoom()
		
		if not player:HasCollectible(Enums.Collectibles.LUMINARY_FLARE) then return end
		
		local randNum = rng:RandomInt(5)
		
		if randNum == 0 then
			local spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 11, 0, room:GetCenterPos(), Vector.Zero, player)
			local laser = spawnLaser:ToLaser()
			local sprite = laser:GetSprite()
			local sun = Isaac.FindByType(EntityType.ENTITY_EFFECT, Enums.Effects.LUMINARY_SUN)
			
			if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
				local color = Color(1, 1, 0.36, 1, 1, 1, 0.76)
				color:SetColorize(1, 1, 0, 1)
				sprite.Color = color
			else
				local color = Color(0.9, 0.3, 0.08, 1, 0, 0, 0)
				color:SetColorize(9, 3, 0.1, 1)
				sprite.Color = color

				for i = 1, #sun do
					local sunSprite = sun[i]:GetSprite()
					sunSprite:Play("BodyFire")
					sunSprite:PlayOverlay("FaceFire", false)
				end
			end
			randNum = rng:RandomInt(360)
		
			laser:AddTearFlags(TearFlags.TEAR_BURN)
			laser.Angle = randNum
			laser.Timeout = 16
			laser:GetData().isSolarFlare = true
		end
	end
end

function Item.postEffectInit(effect)
	if effect.Variant ~= Enums.Effects.LUMINARY_SUN then return end
	if effect.SpawnerEntity == nil then return end

	local player = effect.SpawnerEntity:ToPlayer()

  	if player == nil then return end

	local sprite = effect:GetSprite()
	sprite:Play("IdleBody")
	PlayRandomOverlay(player, sprite)
end

function Item.postEffectUpdate(effect)
	if effect.Variant ~= Enums.Effects.LUMINARY_SUN then return end
	if effect.SpawnerEntity == nil then return end

	local player = effect.SpawnerEntity:ToPlayer()

  	if player == nil then return end
		
	local room = game:GetRoom()
	local sprite = effect:GetSprite()

	effect.Position = room:GetCenterPos() + Vector(0, -20)

	if sprite:IsFinished("BodyFire") then
		sprite:Play("IdleBody")
	end

	if sprite:IsOverlayFinished("FaceFire") then
		PlayRandomOverlay(player, sprite)
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
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.LUMINARY_FLARE) then return end
	
	local room = game:GetRoom()
	local enemies = Isaac.FindInRadius(room:GetCenterPos(), 50, EntityPartition.ENEMY)
	local luminarySun = Isaac.FindByType(EntityType.ENTITY_EFFECT, Enums.Effects.LUMINARY_SUN)
	
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			and not enemy:HasEntityFlags(EntityFlag.FLAG_BURN)
			and enemy:IsActiveEnemy()
			and enemy:IsVulnerableEnemy()
			then
				local dmg = 3.15 + (player.Damage / 10)
				enemy:AddBurn(EntityRef(player), 60, dmg)
			end
		end
	end

	if #luminarySun > 0 then return end
	if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then return end

	Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.LUMINARY_SUN, 0, room:GetCenterPos() + Vector(0, -20), Vector.Zero, player)
end

return Item