local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local sfx = SFXManager()
local rng = RNG()

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.SOUL_OF_ANDROMEDA then return end
	
	local rng = player:GetCardRNG(Enums.Cards.SOUL_OF_ANDROMEDA)
	local randNum = rng:RandomInt(2)

	Functions.GoToAbandonedPlanetarium(player, false)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.SOUL_OF_ANDROMEDA)
		end
	end
end

return Card