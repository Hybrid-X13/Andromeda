local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local rng = RNG()

local LocustState = {
	IDLE = 0,
	CHARGING = -1,
}

local Locust = {}

function Locust.familiarUpdate(familiar)
	if familiar.Variant ~= FamiliarVariant.ABYSS_LOCUST then return end

	if familiar.SubType == Enums.Collectibles.GRAVITY_SHIFT
	and familiar.State == LocustState.CHARGING
	then
		local projectiles = Isaac.FindInRadius(familiar.Position, 20, EntityPartition.BULLET)

		if #projectiles == 0 then return end

		for _, projectile in pairs(projectiles) do
			local projectile = projectile:ToProjectile()
			local sprite = projectile:GetSprite()

			projectile.Velocity = Vector.Zero
			projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
			sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
			sprite:LoadGraphics()
		end
	end
end

function Locust.entityTakeDmg(target, amount, flags, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not enemy:IsActiveEnemy() then return end
	if source.Entity == nil then return end
	if source.Entity.Type ~= EntityType.ENTITY_FAMILIAR then return end
	if source.Variant ~= FamiliarVariant.ABYSS_LOCUST then return end
	if source.Entity.SubType ~= Enums.Collectibles.STARBURST then return end

	local familiar = source.Entity:ToFamiliar()
	local player = familiar.Player
	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)

	if rng:RandomFloat() < 0.1 then
		Functions.StarBurst(player, enemy.Position)
	end
end

return Locust