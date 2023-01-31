local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local sfx = SFXManager()
local rng = RNG()

local wisps = {
	Enums.Collectibles.JUNO,
	Enums.Collectibles.PALLAS,
	Enums.Collectibles.CERES,
	Enums.Collectibles.VESTA,
	Enums.Collectibles.CHIRON,
}

local Consumable = {}

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

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.ALPHA_CENTAURI then return end

	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
	local rng = player:GetCardRNG(Enums.Cards.ALPHA_CENTAURI)

	Functions.PlayVoiceline(Enums.Voicelines.ALPHA_CENTAURI, flag, rng:RandomInt(2))
	
	if #items == 0 then return end
	
	for _, j in pairs(items) do
		local pickup = j:ToPickup()
		
		if pickup.Price == 0 then
			if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
			and pickup.SubType > 0
			then
				local itemConfig = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
				local quality = itemConfig.Quality + 1

				player:AddWisp(wisps[quality], pickup.Position, true, false)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
				pickup:Remove()
			elseif IsValidPickup(pickup) then
				local randNum = rng:RandomInt(2)
				
				if randNum == 0 then
					randNum = rng:RandomInt(100)

					if randNum < 35 then
						Functions.GetRandomWisp(player, pickup.Position, rng)
					else
						player:AddWisp(0, pickup.Position, true, false)
					end
				end

				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
				pickup:Remove()
			end
		end
	end
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
end

return Consumable