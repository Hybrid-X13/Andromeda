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
		local randFloat = rng:RandomFloat() / trinketMultiplier

		if randFloat < 0.0167 then
			Functions.SpawnMeteor(player, rng)
		end
	end
end

return Trinket