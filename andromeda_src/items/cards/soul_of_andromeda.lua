local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.SOUL_OF_ANDROMEDA then return end
	
	local rng = player:GetCardRNG(Enums.Cards.SOUL_OF_ANDROMEDA)

	ANDROMEDA:GoToAbandonedPlanetarium(player, 0.333, false)
	Functions.PlayVoiceline(Enums.Voicelines.SOUL_OF_ANDROMEDA, flag, rng:RandomInt(2))
end

return Consumable