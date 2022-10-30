local Enums = require("andromeda_src.enums")
local game = Game()

local Familiar = {}

function Familiar.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.NIX then return end
	
	local sprite = familiar:GetSprite()
	local megaPlutonium = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Enums.Familiars.MEGA_PLUTONIUM)
	
	for i, entity in pairs(megaPlutonium) do
		familiar.Parent = entity
	end
	
	familiar.OrbitLayer = 6544
	sprite:Play("FloatDown")
end

function Familiar.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.NIX then return end
	
	familiar.OrbitDistance = Vector(40, 40)
	familiar.DepthOffset = -1
	familiar.OrbitLayer = 6544
	familiar.OrbitSpeed = 0.02
	familiar.Velocity = familiar:GetOrbitPosition(familiar.Parent.Position + familiar.Parent.Velocity) - familiar.Position

	if familiar:GetData().shotsBlocked == nil then
		familiar:GetData().shotsBlocked = 0
	end
end

function Familiar.preFamiliarCollision(familiar, collider, low)
	if familiar.Variant ~= Enums.Familiars.NIX then return end
	if collider.Type ~= EntityType.ENTITY_PROJECTILE then return end
	
	collider:Die()
	familiar:GetData().shotsBlocked = familiar:GetData().shotsBlocked + 1

	if familiar:GetData().shotsBlocked == 5 then
		local itemPool = game:GetItemPool()
		local rune = itemPool:GetCard(collider.InitSeed, false, true, true)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, familiar.Position, Vector.Zero, familiar)
		familiar:GetData().shotsBlocked = 0
	end
end

function Familiar.postPEffectUpdate(player)
	if player:HasCollectible(Enums.Collectibles.MEGA_PLUTONIUM) then return end
	
	player:CheckFamiliar(Enums.Familiars.NIX, 0, player:GetCollectibleRNG(Enums.Collectibles.MEGA_PLUTONIUM), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.MEGA_PLUTONIUM))
end

return Familiar