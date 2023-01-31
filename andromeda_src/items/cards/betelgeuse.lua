local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.BETELGEUSE then return end
	
	local room = game:GetRoom()
	local rng = player:GetCardRNG(Enums.Cards.BETELGEUSE)

	room:MamaMegaExplosion(player.Position)

	Functions.PlayVoiceline(Enums.Voicelines.BETELGEUSE, flag, rng:RandomInt(2))
end

return Consumable