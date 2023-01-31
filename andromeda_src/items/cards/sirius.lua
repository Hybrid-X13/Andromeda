local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.SIRIUS then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end
	
	local rng = player:GetCardRNG(Enums.Cards.SIRIUS)

	player:AddCollectible(CollectibleType.COLLECTIBLE_BATTERY)
	player:FullCharge(ActiveSlot.SLOT_PRIMARY, true)
	player:FullCharge(ActiveSlot.SLOT_SECONDARY, true)
	player:FullCharge(ActiveSlot.SLOT_POCKET, true)
	player:RemoveCollectible(CollectibleType.COLLECTIBLE_BATTERY)

	Functions.PlayVoiceline(Enums.Voicelines.SIRIUS, flag, rng:RandomInt(2))
end

return Consumable