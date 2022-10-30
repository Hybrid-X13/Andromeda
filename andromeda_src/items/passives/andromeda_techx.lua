local Enums = require("andromeda_src.enums")

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.ANDROMEDA_TECHX) then return end
	
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * 2
	end
	
	if cacheFlag == CacheFlag.CACHE_TEARFLAG then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
	end
end

function Item.postFireTear(tear)
	local player = tear.Parent:ToPlayer()
	
	if tear.SpawnerType ~= EntityType.ENTITY_PLAYER then return end
	if not player:HasCollectible(Enums.Collectibles.ANDROMEDA_TECHX) then return end
		
	local dmgMultiplier = 0.5
	
	if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
		dmgMultiplier = 0.33
	end
	
	if player:HasCollectible(Enums.Collectibles.ANDROMEDA_BRIMSTONE) then
		dmgMultiplier = dmgMultiplier + (0.25 * player:GetCollectibleNum(Enums.Collectibles.ANDROMEDA_BRIMSTONE))
	end
	
	if player:HasCollectible(Enums.Collectibles.ANDROMEDA_TECHNOLOGY) then
		dmgMultiplier = dmgMultiplier + (0.25 * player:GetCollectibleNum(Enums.Collectibles.ANDROMEDA_TECHNOLOGY))
	end
	
	local laser = player:FireTechXLaser(tear.Position, tear.Velocity, 40 * tear.Scale, nil, dmgMultiplier)
	--[[
	local spawnLaser
	
	if player:HasCollectible(ANDROMEDA_TECHNOLOGY)
	and player:HasCollectible(ANDROMEDA_BRIMSTONE)
	then
		if player:GetCollectibleNum(ANDROMEDA_BRIMSTONE) > 1 then
			spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 14, 3, tear.Position, tear.Velocity, player)
		else
			spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 9, 3, tear.Position, tear.Velocity, player)
		end
	elseif player:HasCollectible(ANDROMEDA_BRIMSTONE)
	and not player:HasCollectible(ANDROMEDA_TECHNOLOGY)
	then
		if player:GetCollectibleNum(ANDROMEDA_BRIMSTONE) > 1 then
			spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 11, 3, tear.Position, tear.Velocity, player)
		else
			spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 1, 3, tear.Position, tear.Velocity, player)
		end
	elseif player:HasCollectible(ANDROMEDA_TECHNOLOGY)
	and not player:HasCollectible(ANDROMEDA_BRIMSTONE)
	then
		spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 9, 3, tear.Position, tear.Velocity, player)
	else
		spawnLaser = Isaac.Spawn(EntityType.ENTITY_LASER, 2, 3, tear.Position, tear.Velocity, player)
	end
	
	local laser = spawnLaser:ToLaser()]]
	laser.Variant = 2
	laser.SubType = 3
	laser.Parent = tear
	laser.Radius = 40 * tear.Scale
	--laser.CollisionDamage = tear.CollisionDamage / 2
	laser.TearFlags = tear.TearFlags
	laser:GetData().andromedaTechX = true
	tear.Color = Color(1, 1, 1, 0, 0, 0, 0)
	tear.CollisionDamage = 0
end

function Item.postPEffectUpdate(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X, true)
	and (player:GetPlayerType() == Enums.Characters.ANDROMEDA or player:GetPlayerType() == Enums.Characters.T_ANDROMEDA)
	then
		local techX = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_TECH_X)
		
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_TECH_X)
		player:AddCollectible(Enums.Collectibles.ANDROMEDA_TECHX)
		player:AddCostume(techX)
	end
	
	if player:HasCollectible(Enums.Collectibles.ANDROMEDA_TECHX) then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY, true) then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY)
			player:AddCollectible(Enums.Collectibles.ANDROMEDA_TECHNOLOGY)
		end
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE, true) then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
			player:AddCollectible(Enums.Collectibles.ANDROMEDA_BRIMSTONE)
		end
	end
end

return Item