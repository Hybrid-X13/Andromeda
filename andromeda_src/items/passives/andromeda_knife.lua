local Enums = require("andromeda_src.enums")

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	if not player:HasCollectible(Enums.Collectibles.ANDROMEDA_KNIFE) then return end
		
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage / 2
	end
	
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * 1.8
	end
	
	if cacheFlag == CacheFlag.CACHE_TEARFLAG then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
	end
end

function Item.postFireTear(tear)
	local player = tear.Parent:ToPlayer()
	
	if player == nil then return end
	if tear.SpawnerType ~= EntityType.ENTITY_PLAYER then return end
	if not player:HasCollectible(Enums.Collectibles.ANDROMEDA_KNIFE) then return end
		
	local knife = player:FireKnife(tear, tear.Velocity:GetAngleDegrees(), false, 0, 0)
	
	knife.TearFlags = tear.TearFlags
	knife.Scale = tear.Scale
	knife.Color = player.TearColor
	knife:GetData().andromedaKnife = true
	tear.Visible = false
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
		tear.CollisionDamage = 0.1
	else
		tear.CollisionDamage = 0
	end
end

function Item.postKnifeUpdate(knife)
	if knife.SpawnerType == EntityType.ENTITY_PLAYER
	and knife:GetData().andromedaKnife
	then
		knife.RotationOffset = knife.Parent.Velocity:GetAngleDegrees()
	end
end

function Item.postPEffectUpdate(player)
	if player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA then return end
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE, true) then return end
		
	player:RemoveCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)
	player:AddCollectible(Enums.Collectibles.ANDROMEDA_KNIFE)
end

return Item