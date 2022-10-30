local Enums = require("andromeda_src.enums")
local game = Game()
local rng = RNG()

local Trinket = {}

function Trinket.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	if not room:IsFirstVisit() then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasTrinket(Enums.Trinkets.SEXTANT) then return end
		
		local findRoom = level:QueryRoomTypeIndex(RoomType.ROOM_PLANETARIUM, true, rng, true)
		local planetarium = level:GetRoomByIdx(findRoom)
		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.SEXTANT)
		local rng = player:GetTrinketRNG(Enums.Trinkets.SEXTANT)
		local rngMax = 60 / trinketMultiplier
		local randNum = rng:RandomInt(rngMax)
		
		if planetarium.Data
		and planetarium.Data.Type == RoomType.ROOM_PLANETARIUM
		and planetarium.DisplayFlags & 1 << 2 == 0
		then
			planetarium.DisplayFlags = planetarium.DisplayFlags | 1 << 2
			level:UpdateVisibility()
		end
		
		if randNum < 8 then
			player:AddCollectible(CollectibleType.COLLECTIBLE_SPELUNKER_HAT)
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_SPELUNKER_HAT)
		end
	end
end

return Trinket