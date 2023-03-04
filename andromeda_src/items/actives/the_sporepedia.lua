local Enums = require("andromeda_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Item = {}

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.THE_SPOREPEDIA then return end
	
	Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BUDDY_IN_A_BOX, 0, player.Position, Vector.Zero, player)

	if player:GetData().hasSpode
	and flags & UseFlag.USE_CARBATTERY ~= UseFlag.USE_CARBATTERY
	then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BUDDY_IN_A_BOX, 0, player.Position, Vector.Zero, player)
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, player.Position, false)
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
	end
	
	return true
end

function Item.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
	if pickup.SubType ~= Enums.Collectibles.BOOK_OF_COSMOS then return end

	rng:SetSeed(pickup.InitSeed, 35)
	local randFloat = rng:RandomFloat()

	if randFloat < 0.025 then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Enums.Collectibles.THE_SPOREPEDIA, true, false, false)
	end
end

return Item