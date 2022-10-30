local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

local Trinket = {}

function Trinket.postPEffectUpdate(player)
	if not player:HasTrinket(Enums.Trinkets.METEORITE) then return end
	
	local room = game:GetRoom()

	if not room:IsClear()
	or room:IsAmbushActive()
	then
		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.METEORITE)
		local rng = player:GetTrinketRNG(Enums.Trinkets.METEORITE)
		local rngMax = 60 / trinketMultiplier
		local randNum = rng:RandomInt(rngMax)

		if randNum == 0 then
			Functions.SpawnMeteor(player, rng)
		end
	end
end

return Trinket