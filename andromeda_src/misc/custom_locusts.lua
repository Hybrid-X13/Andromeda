local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local rng = RNG()

local Locust = {}

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