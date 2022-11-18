local Enums = require("andromeda_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Card = {}

local function IsValidPickup(pickup)
	if pickup.Variant == PickupVariant.PICKUP_HEART
	or pickup.Variant == PickupVariant.PICKUP_COIN
	or pickup.Variant == PickupVariant.PICKUP_KEY
	or pickup.Variant == PickupVariant.PICKUP_BOMB
	or pickup.Variant == PickupVariant.PICKUP_GRAB_BAG
	or pickup.Variant == PickupVariant.PICKUP_PILL
	or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
	or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
	or pickup.Variant == PickupVariant.PICKUP_TRINKET
	or (((pickup.Variant >= PickupVariant.PICKUP_CHEST and pickup.Variant <= PickupVariant.PICKUP_LOCKEDCHEST) or pickup.Variant == PickupVariant.PICKUP_REDCHEST) and pickup.SubType == ChestSubType.CHEST_CLOSED)
	then
		return true
	end

	return false
end

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.ALPHA_CENTAURI then return end

	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
	local rng = player:GetCardRNG(Enums.Cards.ALPHA_CENTAURI)
	
	if #items == 0 then return end
	
	for i, j in pairs(items) do
		local pickup = j:ToPickup()
		
		if pickup.Price == 0 then
			if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
			and pickup.SubType > 0
			then
				player:AddWisp(CollectibleType.COLLECTIBLE_MYSTERY_GIFT, pickup.Position, true, false)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
				pickup:Remove()
			elseif IsValidPickup(pickup) then
				local randNum = rng:RandomInt(2)
				
				if randNum == 0 then
					player:AddWisp(0, pickup.Position, true, false)
				end

				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
				pickup:Remove()
			end
		end
	end
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)

	local randNum = rng:RandomInt(2)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.ALPHA_CENTAURI)
		end
	end
end

return Card