local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

local Item = {}

function Item.evaluateCache(player, cacheFlag)
	local tempEffects = player:GetEffects()
	
	if not tempEffects:HasCollectibleEffect(Enums.Collectibles.THE_SPOREPEDIA) then return end
	if cacheFlag ~= CacheFlag.CACHE_FAMILIARS then return end

	local effectCount = tempEffects:GetCollectibleEffectNum(Enums.Collectibles.THE_SPOREPEDIA)

	if player:GetData().hasSpode then
		effectCount = effectCount + 1
	end

	for i = 1, effectCount do
		local pos = Isaac.GetFreeNearPosition(player.Position, 40)
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BUDDY_IN_A_BOX, 0, pos, Vector.Zero, player)
	end
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.THE_SPOREPEDIA then return end
	
	return true
end

function Item.familiarInit(familiar)
	if familiar.Variant ~= FamiliarVariant.WISP then return end
	if familiar.SubType ~= Enums.Collectibles.THE_SPOREPEDIA then return end

	familiar.SubType = CollectibleType.COLLECTIBLE_MONSTER_MANUAL
end

function Item.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType ~= Enums.Collectibles.BOOK_OF_COSMOS then return end

	rng:SetSeed(pickup.InitSeed, 35)
	local randFloat = rng:RandomFloat()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()

	if Functions.GetDimension(roomDesc) == Enums.Dimensions.DEATH_CERTIFICATE then return end

	if randFloat < 0.025 then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Enums.Collectibles.THE_SPOREPEDIA, true, false, false)
	end
end

return Item