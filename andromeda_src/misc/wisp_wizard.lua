local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local itemPool = game:GetItemPool()

local Beggar = {}

if MinimapAPI then
	local WiWiIcon = Sprite()
	WiWiIcon:Load("gfx/ui/minimapapi/andromeda_minimapapi.anm2", true)
	WiWiIcon:SetFrame("KingGizzardAndTheWispWizard", 0)
	MinimapAPI:AddIcon("KingGizzardAndTheWispWizard", WiWiIcon)
  	MinimapAPI:AddPickup("WispWizard", "KingGizzardAndTheWispWizard", EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD, nil, MinimapAPI.PickupSlotMachineNotBroken, "slots")
end

function Beggar.preRoomEntitySpawn(entity, variant, subType, gIndex, seed)
	if entity ~= EntityType.ENTITY_SLOT then return end
	if variant ~= Enums.Slots.KEY_MASTER then return end
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
				for _, beggar in pairs(wispWizards) do
					local pos = beggar.Position
					beggar:Remove()
					Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.KEY_MASTER, 0, pos, Vector.Zero, nil)
				end
			end
		end
	end
end

function Beggar.prePlayerCollision(player, collider, low)
	if collider.Type ~= EntityType.ENTITY_SLOT then return end
	if collider.Variant ~= Enums.Slots.WISP_WIZARD then return end
	
	local sprite = collider:GetSprite()
	
	if not sprite:IsPlaying("Idle") then return end
	if player:GetNumCoins() == 0 then return end

	rng:SetSeed(collider:GetDropRNG():Next(), 35)
	local randNum = rng:RandomInt(100)

	player:AddCoins(-1)
	sfx:Play(SoundEffect.SOUND_SCAMPER)
	
	if randNum < 35 then
		sprite:Play("PayPrize")
		player:GetData().isPayoutTarget = true

		if tmmc then
			tmmc:find_slot()
			sprite.PlaybackSpeed = 1.5
		end
	else
		sprite:Play("PayNothing")
	end
end

--Special thanks to KingBobson's Harlot Beggar mod, which much of the code here was used from: https://steamcommunity.com/sharedfiles/filedetails/?id=2543617819
function Beggar.postPEffectUpdate(player)
	local wispWizards = Isaac.FindByType(EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD)
	
	if #wispWizards == 0 then return end
	
	local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
	local mamaMega = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION)
	
	for _, beggar in pairs (wispWizards) do
		local sprite = beggar:GetSprite()
		rng:SetSeed(beggar:GetDropRNG():Next(), 35)
		local randNum = rng:RandomInt(100)
		
		if tmmc
		and (beggar.Position - player.Position):Length() >= 22
		then
			tmmc.enable[Enums.Slots.WISP_WIZARD] = true
			tmmc:find_slot()
			beggar:GetSprite().PlaybackSpeed = 1
		end

		if sprite:IsFinished("PayNothing") then sprite:Play("Idle")	end
		if sprite:IsFinished("PayPrize") then sprite:Play("Prize") end
		
		if sprite:IsFinished("Prize") then
			if randNum < 5 then --Spawn zodiac item
				local spawnpos = Isaac.GetFreeNearPosition(beggar.Position, 40)
				sprite:Play("Teleport")
				
				if #CustomData.AbPlPoolCopy == 0 then
					local seed = game:GetSeeds():GetStartSeed()
					local itemID = game:GetItemPool():GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, seed)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnpos, Vector.Zero, beggar)
				else
					local itemID = ANDROMEDA:PullFromAbandonedPlanetariumPool(rng)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, spawnpos, Vector.Zero, beggar)
				end
				sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
			elseif randNum < 10 then --Spawn trinket
				local spawnpos = Isaac.GetFreeNearPosition(beggar.Position, 40)
				local trinketID = 0
				local trinkets = {
					{TrinketType.TRINKET_TELESCOPE_LENS, true},
					{Enums.Trinkets.METEORITE, SaveData.UnlockData.Andromeda.Satan},
					{Enums.Trinkets.STARDUST, SaveData.UnlockData.Andromeda.Greed},
					{Enums.Trinkets.MOON_STONE, SaveData.UnlockData.T_Andromeda.Satan},
					{Enums.Trinkets.POLARIS, SaveData.UnlockData.T_Andromeda.BossRush},
					{Enums.Trinkets.SEXTANT, SaveData.UnlockData.T_Andromeda.Greed},
					--{Enums.Trinkets.EYE_OF_SPODE, },
				}
				local trinketPool = {}
				
				for i = 1, #trinkets do
					local trinketType = trinkets[i][1]
					local isUnlocked = trinkets[i][2]
					local itemConfig = Isaac.GetItemConfig():GetTrinket(trinketType)
					
					if not player:HasTrinket(trinketType)
					and itemConfig:IsAvailable()
					and isUnlocked
					then
						table.insert(trinketPool, trinketType)
					end
				end
				
				if #trinketPool > 0 then
					randNum = rng:RandomInt(#trinketPool) + 1
					trinketID = trinketPool[randNum]
					itemPool:RemoveTrinket(trinketID)
				end
				
				sprite:Play("Teleport")
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketID, spawnpos, Vector(1, 1), beggar)
				sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
			elseif randNum < 45 then --Give random wisp
				if player:GetData().isPayoutTarget then
					Functions.GetRandomWisp(player, beggar.Position, player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES))
					sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
					sprite:Play("Idle")
				end
			else --Give normal wisp
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
