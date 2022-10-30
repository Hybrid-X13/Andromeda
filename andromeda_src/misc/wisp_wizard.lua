local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemPool = game:GetItemPool()

local Beggar = {}

function Beggar.preRoomEntitySpawn(entity, variant, subType, gIndex, seed)
	if entity ~= EntityType.ENTITY_SLOT then return end
	if variant ~= 7 then return end
	if not SaveData.UnlockData.T_Andromeda.MegaSatan then return end
	
	--20% chance to turn a key beggar into a wisp wizard
	rng:SetSeed(seed, 35)
	local randNum = rng:RandomInt(5)
	
	if randNum == 0 then
		return {EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD, 0}
	end
end

function Beggar.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data
	local player = Isaac.GetPlayer(0)

	if (room:GetType() == RoomType.ROOM_SUPERSECRET and (roomConfig.Variant == 9429 or roomConfig.Variant == 9439))
	or (room:GetType() == RoomType.ROOM_PLANETARIUM and roomConfig.Variant == 9429)
	then
		if roomConfig.Variant == 9439 then
			Functions.SetAbandonedPlanetarium(player, false)
		end
		
		if not SaveData.UnlockData.T_Andromeda.MegaSatan then
			local wispWizards = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD)
			
			if #wispWizards > 0 then
				for i = 1, #wispWizards do
					local pos = wispWizards[i].Position
					wispWizards[i]:Remove()
					Isaac.Spawn(EntityType.ENTITY_SLOT, 7, 0, pos, Vector.Zero, nil)
				end
			end
		end
	end
end

--Special thanks to KingBobson's Harlot Beggar mod, which much of the code here was used from: https://steamcommunity.com/sharedfiles/filedetails/?id=2543617819
function Beggar.postPEffectUpdate(player)
	local wispWizards = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD)
	
	if #wispWizards == 0 then return end
	
	local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
	local mamaMega = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION)
	
	for i = 1, #wispWizards do
		local beggar = wispWizards[i]
		local sprite = beggar:GetSprite()
		rng:SetSeed(beggar:GetDropRNG():Next(), 35)
		local randNum = rng:RandomInt(100)
		
		if sprite:IsFinished("PayNothing") then sprite:Play("Idle")	end
		if sprite:IsFinished("PayPrize") then sprite:Play("Prize") end
		
		if sprite:IsFinished("Prize") then
			if randNum < 5 then --Spawn zodiac item
				local spawnpos = Isaac.GetFreeNearPosition(beggar.Position, 40)
				sprite:Play("Teleport")
				
				if #CustomData.AbPlPoolCopy == 0 then
					local rng = player:GetCollectibleRNG(Enums.Collectibles.CHIRON)
					local seed = game:GetSeeds():GetStartSeed()
					local itemID = game:GetItemPool():GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, seed)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnpos, Vector.Zero, beggar)
				else
					local zodiac = rng:RandomInt(#CustomData.AbPlPoolCopy) + 1
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CustomData.AbPlPoolCopy[zodiac], spawnpos, Vector.Zero, beggar)
					itemPool:RemoveCollectible(CustomData.AbPlPoolCopy[zodiac])
					table.remove(CustomData.AbPlPoolCopy, zodiac)
				end
				sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
			elseif randNum < 10 then --Spawn trinket
				local spawnpos = Isaac.GetFreeNearPosition(beggar.Position, 40)
				local trinkets = {}
				local trinketID
				
				if not player:HasTrinket(TrinketType.TRINKET_TELESCOPE_LENS) then
					table.insert(trinkets, TrinketType.TRINKET_TELESCOPE_LENS)
				end
				
				if SaveData.UnlockData.Andromeda.Satan then
					table.insert(trinkets, Enums.Trinkets.METEORITE)
				end
				
				if SaveData.UnlockData.Andromeda.Greed then
					table.insert(trinkets, Enums.Trinkets.STARDUST)
				end
				
				if SaveData.UnlockData.T_Andromeda.Satan then
					table.insert(trinkets, Enums.Trinkets.MOONSTONE)
				end
				
				if SaveData.UnlockData.T_Andromeda.BossRush then
					table.insert(trinkets, Enums.Trinkets.POLARIS)
				end
				
				if SaveData.UnlockData.T_Andromeda.Greed then
					table.insert(trinkets, Enums.Trinkets.SEXTANT)
				end
				
				if #trinkets == 0 then
					trinketID = 0
				else
					randNum = rng:RandomInt(#trinkets) + 1
					trinketID = trinkets[randNum]
					itemPool:RemoveTrinket(trinketID)
				end
				
				sprite:Play("Teleport")
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketID, spawnpos, Vector(1, 1), beggar)
				sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
			elseif randNum < 43 then --Give random wisp
				if player:GetData().isPayoutTarget then
					Functions.GetRandomWisp(player, beggar.Position, player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES))
					sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
					sprite:Play("Idle")
				end
			else -- Give normal wisp
				if player:GetData().isPayoutTarget then
					player:AddWisp(0, beggar.Position, true, false)
					sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
					sprite:Play("Idle")
				end
			end
			player:GetData().isPayoutTarget = false
		end
		
		if sprite:IsFinished("Teleport") then
			beggar:Remove()
		end
		
		if (beggar.Position - player.Position):Length() <= 20 then
			randNum = rng:RandomInt(3)
			
			if sprite:IsPlaying("Idle")
			and player:GetNumCoins() > 0
			then
				player:AddCoins(-1)
				sfx:Play(SoundEffect.SOUND_SCAMPER)
				
				if randNum == 0 then
					sprite:Play("PayPrize")
					player:GetData().isPayoutTarget = true
				else
					sprite:Play("PayNothing")
				end
			end
		end
		
		for _, splosion in pairs(explosions) do
			local frame = splosion:GetSprite():GetFrame()

			if frame < 3 then
				local size = splosion.SpriteScale.X
				local nearby = Isaac.FindInRadius(splosion.Position, 75 * size)

				for _, ent in pairs(nearby) do
					if ent.Type == EntityType.ENTITY_SLOT
					and ent.Variant == Enums.Slots.WISP_WIZARD
					then
						beggar:Kill()
						beggar:Remove()
						game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
					end
				end
			end
		end
		
		if #mamaMega > 0 then
			beggar:Kill()
			beggar:Remove()
			game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
		end
	end
end

return Beggar