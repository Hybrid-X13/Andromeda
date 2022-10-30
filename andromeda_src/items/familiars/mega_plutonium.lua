local Enums = require("andromeda_src.enums")
local sfx = SFXManager()

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
	
	local boxUses = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
	
	if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then
		local plutoniumNum = player:GetCollectibleNum(Enums.Collectibles.MEGA_PLUTONIUM)
		local numMega = (plutoniumNum > 0 and (plutoniumNum + boxUses) or 0)
		
		player:CheckFamiliar(Enums.Familiars.MEGA_PLUTONIUM, numMega, player:GetCollectibleRNG(Enums.Collectibles.MEGA_PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.MEGA_PLUTONIUM))
		player:CheckFamiliar(Enums.Familiars.CHARON, numMega, player:GetCollectibleRNG(Enums.Collectibles.MEGA_PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.MEGA_PLUTONIUM))
		player:CheckFamiliar(Enums.Familiars.NIX, numMega, player:GetCollectibleRNG(Enums.Collectibles.MEGA_PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.MEGA_PLUTONIUM))
	end
end

function Familiar.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.MEGA_PLUTONIUM then return end
	
	local sprite = familiar:GetSprite()
	familiar:AddToOrbit(2)
	familiar.FireCooldown = 2
	sprite:Play("Transformer")
end

function Familiar.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.MEGA_PLUTONIUM then return end
	
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local moveDir = player:GetMovementDirection()
	local fireDir = player:GetFireDirection()
	
	familiar.OrbitDistance = Vector(40, 40)
	familiar.DepthOffset = -1
	familiar.Velocity = familiar:GetOrbitPosition(player.Position + player.Velocity) - familiar.Position
	
	if sprite:IsPlaying("Transformer")
	and sprite:IsEventTriggered("beast_vocal_grumble3")
	then
		sfx:Play(SoundEffect.SOUND_BEAST_GRUMBLE, 1, 2, false, 1.3)
	end
	
	if not sprite:IsPlaying("Transformer") then
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
				tear:AddTearFlags(TearFlags.TEAR_ROCK)
				tear:ChangeVariant(TearVariant.ROCK)
				tear:GetData().babyPlutoTear = true
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					tear.CollisionDamage = 10
					tear.Scale = 1.6
				else
					tear.CollisionDamage = 5
					tear.Scale = 1.2
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
	if familiar.Variant ~= Enums.Familiars.MEGA_PLUTONIUM then return end
	if collider.Type ~= EntityType.ENTITY_PROJECTILE then return end
		
	collider:Die()
end

function Familiar.postPEffectUpdate(player)
	if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then return end
	
	player:CheckFamiliar(Enums.Familiars.MEGA_PLUTONIUM, 0, player:GetCollectibleRNG(Enums.Collectibles.MEGA_PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.MEGA_PLUTONIUM))
end

return Familiar