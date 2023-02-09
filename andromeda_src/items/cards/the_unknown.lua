local Enums = require("andromeda_src.enums")
local rng = RNG()

local Consumable = {}

function Consumable.useCard(card, player, flag)
	if card ~= Enums.Cards.THE_UNKNOWN then return end
	
	local rng = player:GetCardRNG(Enums.Cards.THE_UNKNOWN)
	local cardNum = rng:RandomInt(22) + 1
	local randNum = rng:RandomInt(2)
	
	if randNum == 0 then
		cardNum = cardNum + 55
	end

	player:UseCard(cardNum, UseFlag.USE_NOANIM)
end

return Consumable