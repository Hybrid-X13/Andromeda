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

local function DestroyWisps(wispSubType)
	local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, wispSubType)

	if #wisps == 0 then return end

	for _, wisp in pairs(wisps) do
		wisp:Kill()
	end
end

function Wisp.familiarInit(familiar)
	if familiar.Variant ~= FamiliarVariant.WISP then return end
	if familiar.SubType ~= Enums.Collectibles.GRAVITY_SHIFT then return end

	DestroyWisps(Enums.Collectibles.GRAVITY_SHIFT)
end

function Wisp.familiarUpdate(familiar)
	if familiar.Variant ~= FamiliarVariant.WISP then return end
	if familiar.SubType ~= Enums.Collectibles.GRAVITY_SHIFT then return end

	local player = familiar.Player
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

function Wisp.postNewRoom()
	DestroyWisps(Enums.Collectibles.GRAVITY_SHIFT)
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
	elseif familiar.SubType == Enums.Collectibles.BOOK_OF_COSMOS then
		rng:SetSeed(tear.InitSeed, 35)
		local randNum = rng:RandomInt(#colors) + 1
		sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
	end
end

function Wisp.postTearUpdate(tear)
	if tear.FrameCount ~= 1 then return end
	if tear.SpawnerEntity == nil then return end

	local familiar = tear.SpawnerEntity:ToFamiliar()

	if familiar == nil then return end
	if familiar.Variant ~= FamiliarVariant.WISP then return end
	
	if familiar.SubType == Enums.Collectibles.EXTINCTION_EVENT then
		rng:SetSeed(tear.InitSeed, 35)
		local randFloat = rng:RandomFloat() + rng:RandomFloat()

		tear.CollisionDamage = 3 * randFloat
		tear.Scale = 0.4 * math.sqrt(tear.CollisionDamage)
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

return Wisp