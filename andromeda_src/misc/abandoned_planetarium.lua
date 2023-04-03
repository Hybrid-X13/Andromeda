local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local rng = RNG()

if MinimapAPI then
	local AbPlIcon = Sprite()
	AbPlIcon:Load("gfx/ui/minimapapi/andromeda_minimapapi.anm2", true)
	AbPlIcon:SetFrame("AbandonedPlanetarium", 0)
	MinimapAPI:AddIcon("AbandonedPlanetarium", AbPlIcon)
end

local Room = {}

function Room.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)

		if door
		and door.TargetRoomType == RoomType.ROOM_DICE
		and room:GetType() ~= RoomType.ROOM_SECRET
		and room:GetType() ~= RoomType.ROOM_SUPERSECRET
		then
			local roomIndex = door.TargetRoomIndex
			local roomDesc = level:GetRoomByIdx(roomIndex, 0)
			local roomConfig = roomDesc.Data

			if roomConfig.Variant >= 4242
			and roomConfig.Variant < 4900
			then
				local doorSprite = door:GetSprite()

				for i = 0, 4 do
					doorSprite:ReplaceSpritesheet(i, "gfx/grid/andromeda_abandonedplanetariumdoor_out.png")
				end
				
				doorSprite:LoadGraphics()
			end
		end
	end

	if not ANDROMEDA:IsAbandonedPlanetarium() then return end

	if MinimapAPI then
		local roomidx = level:GetCurrentRoomIndex()

		if roomidx ~= GridRooms.ROOM_DEBUG_IDX then
			local roomIndex = MinimapAPI:GetRoomByIdx(roomidx)
			roomIndex.PermanentIcons = {"AbandonedPlanetarium"}
		end
	end

	if StageAPI then
		for _, customGrid in ipairs(StageAPI.GetCustomGrids()) do
			customGrid:Remove(false)
		end
	end
	
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data

	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local rng = player:GetCollectibleRNG(Enums.Collectibles.GRAVITY_SHIFT)
		local useD20 = rng:RandomInt(20) + 1
		local randNum
		
		Functions.SetAbandonedPlanetarium(player, true)

		if not room:IsFirstVisit() then return end

		if (roomConfig.Variant > 4241 and roomConfig.Variant < 4400)
		or (roomConfig.Variant > 4841 and roomConfig.Variant < 4900)
		then
			local dollar = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DOLLAR)
			
			--Celestial shop
			if roomConfig.Variant == 4281
			or roomConfig.Variant == 4849
			then
				local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)

				for _, j in pairs(pickups) do
					local pickup = j:ToPickup()
					
					if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
						pickup.Price = 15
					else
						pickup.Price = 5
					end
					pickup.ShopItemId = -1
				end

				if roomConfig.Variant == 4849
				and SaveData.UnlockData.T_Andromeda.MegaSatan
				then
					local shopkeeper = Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER, -1)
					local pos = shopkeeper[1].Position
					shopkeeper[1]:Remove()
					Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD, 0, pos, Vector.Zero, nil)
				end
			end
			
			for i = 1, #dollar do
				local item = dollar[i]:ToPickup()
				
				local itemID = ANDROMEDA:PullFromAbandonedPlanetariumPool(rng)
				item:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID, true, false, false)
				
				if player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
					item.Price = 15
				end

				if #dollar > 1
				and roomConfig.Variant ~= 4281
				and roomConfig.Variant ~= 4849
				then
					item.OptionsPickupIndex = 42
				end
			end
		elseif (roomConfig.Variant > 4400 and roomConfig.Variant < 4600)
		or (roomConfig.Variant > 4600 and roomConfig.Variant < 4800)
		then
			if roomConfig.Variant == 4443
			or roomConfig.Variant == 4459
			or roomConfig.Variant == 4642
			or roomConfig.Variant == 4654
			then
				room:TurnGold()
			elseif (
				roomConfig.Variant == 4444
				or roomConfig.Variant == 4445
				or roomConfig.Variant == 4471
				or roomConfig.Variant == 4487
				or roomConfig.Variant == 4545
				or roomConfig.Variant == 4649
			)
			and SaveData.UnlockData.T_Andromeda.MegaSatan
			then
				local slot = Isaac.FindByType(EntityType.ENTITY_SLOT, -1)
				randNum = rng:RandomInt(2)
				
				if randNum == 0 then
					slot[1]:Remove()
					Isaac.Spawn(EntityType.ENTITY_SLOT, Enums.Slots.WISP_WIZARD, 0, room:GetCenterPos(), Vector.Zero, nil)
				end
			elseif roomConfig.Variant == 4451
			or roomConfig.Variant == 4452
			or roomConfig.Variant == 4465
			or roomConfig.Variant == 4648
			then
				local lightWisp = rng:RandomInt(20) + 1
				
				for i = 1, lightWisp do
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, room:GetRandomPosition(0), Vector.Zero, nil)
				end
				
				if roomConfig.Variant == 4451 then
					for i = 1, 6 do
						player:AddWisp(0, room:GetCenterPos(), true, false)
					end
				elseif roomConfig.Variant == 4452 then
					for i = 1, 3 do
						player:AddWisp(0, Vector(400, 280), true, false)
					end
					
					for i = 1, 3 do
						player:AddWisp(0, Vector(240, 280), true, false)
					end
				elseif roomConfig.Variant == 4465 then
					local pos = {Vector(560, 400), Vector(80, 400), Vector(80, 160), Vector(560, 160)}
					
					for i = 1, #pos do
						player:AddWisp(0, pos[i], true, false)
					end
					player:AddWisp(CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, room:GetCenterPos(), true, false)
				elseif roomConfig.Variant == 4648 then
					local pos = {Vector(560, 400), Vector(80, 400), Vector(80, 160), Vector(560, 160)}
					
					for i = 1, #pos do
						player:AddWisp(0, pos[i], true, false)
					end
					player:AddWisp(CollectibleType.COLLECTIBLE_BIBLE, Vector(400, 280), true, false)
					player:AddWisp(CollectibleType.COLLECTIBLE_BIBLE, Vector(240, 280), true, false)
				end
			elseif roomConfig.Variant == 4652
			and player:GetPlayerType() ~= Enums.Characters.T_ANDROMEDA
			then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, room:GetCenterPos() + Vector(0, -20), Vector.Zero, player)
			end
			
			--True random layout
			if useD20 == 20
			and roomConfig.Variant ~= 4281
			and roomConfig.Variant ~= 4849
			then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_D20, false)
			end
		end
	end
end

--Any red hearts are converted into soul hearts in the Abandoned Planetarium
function Room.postPickupInit(pickup)
	if not ANDROMEDA:IsAbandonedPlanetarium() then return end
	if pickup.Variant ~= PickupVariant.PICKUP_HEART then return end
	
	rng:SetSeed(pickup.InitSeed, 35)

	if pickup.SubType == HeartSubType.HEART_FULL
	or pickup.SubType == HeartSubType.HEART_SCARED
	or pickup.SubType == HeartSubType.HEART_DOUBLEPACK
	or pickup.SubType == HeartSubType.HEART_ROTTEN
	or pickup.SubType == HeartSubType.HEART_BLENDED
	then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, true, false, false)
	elseif pickup.SubType == HeartSubType.HEART_HALF then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, true, false, false)
	end
end

function Room.getTrinket(trinket)
	if not ANDROMEDA:IsAbandonedPlanetarium() then return end
	if trinket > TrinketType.TRINKET_GOLDEN_FLAG then return end

	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data

	if roomConfig.Variant ~= 4642 then return end

	return trinket + TrinketType.TRINKET_GOLDEN_FLAG
end

function Room.postUpdate()
	if not ANDROMEDA:IsAbandonedPlanetarium() then return end
	
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stageType = level:GetStageType()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data
	
	if roomConfig.Variant == 4652 then
		game:UpdateStrangeAttractor(room:GetCenterPos(), 7, 9999)
	end

	--Fix music conflict with StageAPI
	if StageAPI
	and (level:GetStage() == LevelStage.STAGE2_1 or level:GetStage() == LevelStage.STAGE2_2)
	and stageType == StageType.STAGETYPE_WOTL
	then
		return
	end

	if MusicManager():GetCurrentMusicID() ~= Enums.Music.EDGE_OF_THE_UNIVERSE then
		MusicManager():Play(Enums.Music.EDGE_OF_THE_UNIVERSE, 0)
		MusicManager():UpdateVolume()
	end
end

function Room.postEffectUpdate(effect)
	if not ANDROMEDA:IsAbandonedPlanetarium() then return end
	
	local FFEffects = {
		"D12 Room Floor",
		"D12 Room Floor (Activated)",
		"D12 Pal",
	}
	
	if effect.Variant == EffectVariant.DICE_FLOOR then
		effect:Remove()
	end

	for i = 1, #FFEffects do
		if effect.Variant == Isaac.GetEntityVariantByName(FFEffects[i]) then
			effect:Remove()
		end
	end
end

function Room.preUseItem(item, rng, player, flags, activeSlot, customVarData)
	if not ANDROMEDA:IsAbandonedPlanetarium() then return end
	if item ~= CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR then return end

	return true
end

return Room