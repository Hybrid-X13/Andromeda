local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Trinket = {}

function Trinket.postNPCDeath(npc)
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if Functions.IsInvulnerableEnemy(npc) then return end
	
	rng:SetSeed(npc.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.STARDUST) then
			local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.STARDUST)
			local rngMax = 60 / trinketMultiplier
			local randNum = rng:RandomInt(rngMax)
			
			if randNum < 6 then
				player:AddWisp(0, npc.Position, true, false)
				sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
			end
		end
	end
end

function Trinket.postPickupInit(pickup)
	if pickup.Variant ~= PickupVariant.PICKUP_TRINKET then return end
	if pickup.Price ~= 0 then return end
	
	local room = game:GetRoom()
	
	if room:GetType() ~= RoomType.ROOM_SHOP then return end
	
	if pickup.SubType == (Enums.Trinkets.STARDUST + TrinketType.TRINKET_GOLDEN_FLAG) then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME, true, false, false)
	elseif pickup.SubType == Enums.Trinkets.STARDUST then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, true, false, false)
	end
end

return Trinket