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

function Familiar.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.CHARON then return end
	
	local sprite = familiar:GetSprite()
	local plutonium = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.PLUTONIUM)
	local megaPlutonium = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.MEGA_PLUTONIUM)
		
	for _, entity in pairs(plutonium) do
		familiar.Parent = entity
	end

	for _, entity in pairs(megaPlutonium) do
		familiar.Parent = entity
	end
	
	familiar.FireCooldown = 2
	familiar.OrbitLayer = 6543
	sprite:Play("FloatDown")
end

function Familiar.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.CHARON then return end
	
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local moveDir = player:GetMovementDirection()
	local fireDir = player:GetFireDirection()
	local megaPlutonium = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.MEGA_PLUTONIUM)
	
	familiar.OrbitDistance = Vector(40, 40)
	familiar.DepthOffset = -1
	familiar.OrbitLayer = 6543
	familiar.OrbitSpeed = 0.05
	
	if #megaPlutonium > 0
	and familiar.Parent == nil
	then
		familiar.Parent = megaPlutonium[1]
	end
	
	familiar.Velocity = familiar:GetOrbitPosition(familiar.Parent.Position + familiar.Parent.Velocity) - familiar.Position
	
	if fireDir == Direction.NO_DIRECTION then
		sprite:Play(floatDir[moveDir], false)
	else
		local animDirection = fireDir
		local tearVec = dirVector[fireDir]:Normalized()
		
		if familiar.FireCooldown <= 0 then
			local entity = familiar:FireProjectile(tearVec)
			local tear = entity:ToTear()
			
			tear.FallingSpeed = -3
			tear.Velocity = Vector.Zero
			tear:AddTearFlags(TearFlags.TEAR_ROCK)
			tear:ChangeVariant(TearVariant.ROCK)
			tear:GetData().babyPlutoTear = true
			
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				tear.CollisionDamage = 3
				tear.Scale = 0.9
			else
				tear.CollisionDamage = 1.5
				tear.Scale = 0.6
			end
			
			if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
				familiar.FireCooldown = 6
			else
				familiar.FireCooldown = 12
			end
		end
		sprite:Play(shootDir[animDirection], false)
	end
	familiar.FireCooldown = familiar.FireCooldown - 1
end

return Familiar