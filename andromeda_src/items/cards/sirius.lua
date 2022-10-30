local Enums = require("andromeda_src.enums")
local sfx = SFXManager()
local rng = RNG()

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.SIRIUS then return end
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end
	
	local rng = player:GetCardRNG(Enums.Cards.SIRIUS)
	local randNum = rng:RandomInt(2)

	player:AddCollectible(CollectibleType.COLLECTIBLE_BATTERY)
	player:FullCharge(ActiveSlot.SLOT_PRIMARY, true)
	player:FullCharge(ActiveSlot.SLOT_SECONDARY, true)
	player:FullCharge(ActiveSlot.SLOT_POCKET, true)
	player:RemoveCollectible(CollectibleType.COLLECTIBLE_BATTERY)

	if Options.AnnouncerVoiceMode == 2
	or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
	then
		sfx:Play(Enums.Voicelines.SIRIUS)
	end
end

return Card