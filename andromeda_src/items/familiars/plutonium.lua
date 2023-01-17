local Enums = require("andromeda_src.enums")
local sfx = SFXManager()
local rng = RNG()

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
	
	local numPlutoniums = player:GetCollectibleNum(Enums.Collectibles.PLUTONIUM) + player:GetEffects():GetCollectibleEffectNum(Enums.Collectibles.PLUTONIUM)
	local numMega = player:GetCollectibleNum(Enums.Collectibles.MEGA_PLUTONIUM) + player:GetEffects():GetCollectibleEffectNum(Enums.Collectibles.MEGA_PLUTONIUM)
	
	player:CheckFamiliar(Enums.Familiars.PLUTONIUM, numPlutoniums, player:GetCollectibleRNG(Enums.Collectibles.PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.PLUTONIUM))
	player:CheckFamiliar(Enums.Familiars.CHARON, numPlutoniums + numMega, player:GetCollectibleRNG(Enums.Collectibles.PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.PLUTONIUM))
end

function Familiar.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.PLUTONIUM then return end
	
	local sprite = familiar:GetSprite()
	familiar:AddToOrbit(2)
	familiar.FireCooldown = 2
	sprite:Play("Transformer")
end

function Familiar.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.PLUTONIUM then return end
	
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local moveDir = player:GetMovementDirection()
	local fireDir = player:GetFireDirection()
	
	familiar.OrbitDistance = Vector(40, 40)
	familiar.DepthOffset = -1
	familiar.Velocity = familiar:GetOrbitPosition(player.Position + player.Velocity) - familiar.Position
	
	if sprite:IsPlaying("Transformer")
	and sprite:IsEventTriggered("powerup4")
	then
		sfx:Play(Enums.Sounds.PLUTO_POWERUP)
	end
	
	if not sprite:IsPlaying("Transformer") then
		if fireDir == Direction.NO_DIRECTION then
			sprite:Play(floatDir[moveDir], false)
		else
			local animDirection = fireDir
			local tearVec = dirVector[fireDir]:Normalized()
			local rng = player:GetCollectibleRNG(Enums.Collectibles.PLUTONIUM)
			local randNum = rng:RandomInt(100)
			
			if familiar.FireCooldown <= 0 then
				local entity = familiar:FireProjectile(tearVec)
				local tear = entity:ToTear()
				
				tear.FallingSpeed = -3
				tear:AddTearFlags(TearFlags.TEAR_ORBIT | TearFlags.TEAR_SPECTRAL)
				tear:GetData().babyPlutoTear = true
					
				if randNum < 20 then
					tear:AddTearFlags(TearFlags.TEAR_ROCK)
					tear:ChangeVariant(TearVariant.ROCK)
				end
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					tear.CollisionDamage = 8
					tear.Scale = 1.4
				else
					tear.CollisionDamage = 4
					tear.Scale = 1.1
				end
				
				if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
					familiar.FireCooldown = 4
				else
					familiar.FireCooldown = 8
				end
			end
			sprite:Play(shootDir[animDirection], false)
		end
	end
	familiar.FireCooldown = familiar.FireCooldown - 1
end

function Familiar.preFamiliarCollision(familiar, collider, low)
	if familiar.Variant ~= Enums.Familiars.PLUTONIUM then return end
	if collider.Type ~= EntityType.ENTITY_PROJECTILE then return end
	if collider:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end
	
	collider:Die()
end

return Familiar