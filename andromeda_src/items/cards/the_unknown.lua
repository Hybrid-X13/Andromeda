local Enums = require("andromeda_src.enums")
local game = Game()
local rng = RNG()

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.THE_UNKNOWN then return end
	
	local rng = player:GetCardRNG(Enums.Cards.THE_UNKNOWN)
	local randNum = rng:RandomInt(20)
	
	if randNum == 0 then
		game:StartRoomTransition(GridRooms.ROOM_ERROR_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, -1)
	else
		local cardNum = rng:RandomInt(22) + 1
		randNum = rng:RandomInt(2)
		
		if randNum == 0 then
			--Reverse tarot card
			cardNum = cardNum + 55
		end
		player:UseCard(cardNum, UseFlag.USE_NOANIM)
	end
end

return Card