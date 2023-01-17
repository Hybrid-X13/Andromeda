local Enums = require("andromeda_src.enums")

local floatDir = {
	[Direction.NO_DIRECTION] = "FloatDown", 
	[Direction.LEFT] = "FloatLeft",
	[Direction.UP] = "FloatUp",
	[Direction.RIGHT] = "FloatRight",
	[Direction.DOWN] = "FloatDown"
}

local shootDir = {
	[Direction.NO_DIRECTION] = "FloatDown",
	[Direction.LEFT] = "FloatShootLeft",
	[Direction.UP] = "FloatShootUp",
	[Direction.RIGHT] = "FloatShootRight",
	[Direction.DOWN] = "FloatShootDown"
}

local dirVector = {
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.UP] = Vector(0, -1),
	[Direction.RIGHT] = Vector(1, 0),
	[Direction.DOWN] = Vector(0, 1)
}

local Familiar = {}

function Familiar.evaluateCache(player, cacheFlag)
	if cacheFlag ~= CacheFlag.CACHE_FAMILIARS then return end
	
	local numBabyPlutos = player:GetCollectibleNum(Enums.Collectibles.BABY_PLUTO) + player:GetEffects():GetCollectibleEffectNum(Enums.Collectibles.BABY_PLUTO)
	player:CheckFamiliar(Enums.Familiars.BABY_PLUTO, numBabyPlutos, player:GetCollectibleRNG(Enums.Collectibles.BABY_PLUTO), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.BABY_PLUTO))
end

function Familiar.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.BABY_PLUTO then return end
	
	local sprite = familiar:GetSprite()
	familiar:AddToOrbit(2)
	familiar.FireCooldown = 2
	sprite:Play("FloatDown")
end

function Familiar.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.BABY_PLUTO then return end

	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local moveDir = player:GetMovementDirection()
	local fireDir = player:GetFireDirection()
	
	familiar.OrbitDistance = Vector(40, 40)
	familiar.DepthOffset = -1
	familiar.Velocity = familiar:GetOrbitPosition(player.Position + player.Velocity) - familiar.Position
	
	if fireDir == Direction.NO_DIRECTION then
		sprite:Play(floatDir[moveDir], false)
	else
		local animDirection = fireDir
		local tearVec = dirVector[fireDir]:Normalized()
		
		if familiar.FireCooldown <= 0 then
			local entity = familiar:FireProjectile(tearVec)
			local tear = entity:ToTear()
			
			tear.FallingSpeed = -3
			tear:AddTearFlags(TearFlags.TEAR_ORBIT | TearFlags.TEAR_SPECTRAL)
			tear:GetData().babyPlutoTear = true
			
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				tear.CollisionDamage = 4
				tear.Scale = 1.1
			else
				tear.CollisionDamage = 2
				tear.Scale = 0.7
			end
			
			if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
				familiar.FireCooldown = 4
			else
				familiar.FireCooldown = 8
			end
		end
		sprite:Play(shootDir[animDirection], false)
	end
	familiar.FireCooldown = familiar.FireCooldown - 1
end

function Familiar.preFamiliarCollision(familiar, collider, low)
	if familiar.Variant ~= Enums.Familiars.BABY_PLUTO then return end
	if collider.Type ~= EntityType.ENTITY_PROJECTILE then return end
	if collider:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end

	collider:Die()
end

function Familiar.preTearCollision(tear, collider, low)
	if tear:GetData().babyPlutoTear
	and collider.Type == EntityType.ENTITY_BOMBDROP
	then
		return true
	end
end

return Familiar