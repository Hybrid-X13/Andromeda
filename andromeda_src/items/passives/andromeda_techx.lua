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
	if tear.SpawnerEntity == nil then return end
	if tear.SpawnerType ~= EntityType.ENTITY_PLAYER then return end

	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
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

	laser.Variant = LaserVariant.THIN_RED
	laser.SubType = 3
	laser.Parent = tear
	laser.SpawnerEntity = player
	laser.Radius = 40 * tear.Scale
	laser.TearFlags = tear.TearFlags
	laser:GetData().andromedaTechX = true
	tear.Color = Color(1, 1, 1, 0, 0, 0, 0)
	tear.Visible = false
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