local Enums = require("andromeda_src.enums")
local rng = RNG()
local sfx = SFXManager()

local colors = {
	"red",
	"lightred",
	"orange",
	"yellow",
	"blue",
	"white",
}

local pickups = {
	PickupVariant.PICKUP_COIN,
	PickupVariant.PICKUP_KEY,
	PickupVariant.PICKUP_BOMB,
	PickupVariant.PICKUP_HEART,
	PickupVariant.PICKUP_TAROTCARD,
	PickupVariant.PICKUP_PILL,
	PickupVariant.PICKUP_TRINKET,
}

local Wisp = {}

local function RemoveWisps(wispSubType)
	local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, wispSubType)

	if #wisps == 0 then return end

	for _, wisp in pairs(wisps) do
		wisp:Remove()
		wisp:Kill()
	end
end

function Wisp.familiarInit(familiar)
	if familiar.Variant ~= FamiliarVariant.WISP then return end

	local sprite = familiar:GetSprite()

	if familiar.SubType == Enums.Collectibles.GRAVITY_SHIFT then
		RemoveWisps(Enums.Collectibles.GRAVITY_SHIFT)

		sprite:Load("gfx/familiar/wisps/wisp_gravity.anm2", true)
		sprite:Play("Idle")
	elseif familiar.SubType == Enums.Collectibles.SINGULARITY then
		sprite:Load("gfx/familiar/wisps/singularity_wisp.anm2", true)
		sprite:Play("Idle")
	end
end

function Wisp.familiarUpdate(familiar)
	if familiar.Variant ~= FamiliarVariant.WISP then return end

	local player = familiar.Player

	if familiar.SubType == Enums.Collectibles.JUNO then
		familiar.CollisionDamage = 0
	elseif familiar.SubType == Enums.Collectibles.GRAVITY_SHIFT then
		local projectiles = Isaac.FindInRadius(familiar.Position, 40, EntityPartition.BULLET)

		if #projectiles == 0 then return end

		for _, projectile in pairs(projectiles) do
			local projectile = projectile:ToProjectile()
			local sprite = projectile:GetSprite()

			projectile.Velocity = Vector.Zero
			projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
			sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
			sprite:LoadGraphics()

			if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
				projectile.FallingSpeed = projectile.FallingSpeed - 1.5
			end
		end
	end
end

function Wisp.postNewRoom()
	RemoveWisps(Enums.Collectibles.GRAVITY_SHIFT)
end

function Wisp.postTearInit(tear)
	if tear.SpawnerEntity == nil then return end

	local familiar = tear.SpawnerEntity:ToFamiliar()

	if familiar == nil then return end
	if familiar.Variant ~= FamiliarVariant.WISP then return end

	local sprite = tear:GetSprite()
	
	if familiar.SubType == Enums.Collectibles.SINGULARITY then
		sprite:ReplaceSpritesheet(0, "gfx/tears/solar/basic/tears_solar.png")
		sprite:LoadGraphics()
	elseif familiar.SubType == Enums.Collectibles.BOOK_OF_COSMOS
	or familiar.SubType == Enums.Collectibles.CHIRON
	then
		rng:SetSeed(tear.InitSeed, 35)
		local randNum = rng:RandomInt(#colors) + 1
		sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
		tear:GetData().isSpodeTear = true
	end
end

function Wisp.postTearUpdate(tear)
	if tear.SpawnerEntity == nil then return end

	local familiar = tear.SpawnerEntity:ToFamiliar()

	if familiar == nil then return end
	if familiar.Variant ~= FamiliarVariant.WISP then return end

	local player = familiar.Player
	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TINY_PLANET)
	local randNum = rng:RandomInt(25)
	
	if familiar.SubType == Enums.Collectibles.EXTINCTION_EVENT
	and tear.FrameCount == 1
	then
		rng:SetSeed(tear.InitSeed, 35)
		local randFloat = rng:RandomFloat() + rng:RandomFloat()

		tear.CollisionDamage = 3 * randFloat
		tear.Scale = 0.4 * math.sqrt(tear.CollisionDamage)
	elseif familiar.SubType == Enums.Collectibles.CHIRON
	and randNum == 0
	then
		local starTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, tear.Position, Vector.Zero, nil):ToTear()
		local sprite = starTear:GetSprite()
		randNum = rng:RandomInt(#colors) + 1

		sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
		starTear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
		starTear.CollisionDamage = 3
		starTear.Scale = tear.Scale
		starTear.FallingSpeed = starTear.FallingSpeed - 1
		starTear:GetData().isSpodeTear = true
	end
end

function Wisp.postEntityKill(entity)
	if entity.Type ~= EntityType.ENTITY_FAMILIAR then return end
	if entity.Variant ~= FamiliarVariant.WISP then return end
	if entity.SubType ~= Enums.Collectibles.SINGULARITY then return end

	rng:SetSeed(entity.InitSeed, 35)
	local randNum = rng:RandomInt(#pickups) + 1

	Isaac.Spawn(EntityType.ENTITY_PICKUP, pickups[randNum], 0, entity.Position, Vector.Zero, nil)

	local portal = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, 0, entity.Position, Vector.Zero, nil)
	local sprite = portal:GetSprite()
	portal.SpriteScale = Vector(0.8, 0.8)
	sprite.Color = Color(0, 0, 0, 1, 0, 0, 0)
	sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 1.3, 2, false, 0.5)
end

function Wisp.entityTakeDmg(target, amount, flags, source, countdown)
	local familiar = target:ToFamiliar()
		
	if familiar == nil then return end
	if familiar.Variant ~= FamiliarVariant.WISP then return end

	if familiar.SubType == Enums.Collectibles.JUNO
	or familiar.SubType == Enums.Collectibles.PALLAS
	or familiar.SubType == Enums.Collectibles.CERES
	or familiar.SubType == Enums.Collectibles.VESTA
	or familiar.SubType == Enums.Collectibles.CHIRON
	then
		return false
	end
end

return Wisp