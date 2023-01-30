local Enums = require("andromeda_src.enums")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.BETELGEUSE then return end
	
	local room = game:GetRoom()
	local rng = player:GetCardRNG(Enums.Cards.BETELGEUSE)
	local randNum = rng:RandomInt(2)

	room:MamaMegaExplosion(player.Position)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.BETELGEUSE)
		end
	end
end

return Consumable