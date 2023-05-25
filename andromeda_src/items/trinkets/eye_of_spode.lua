local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()
local rewinding = false
local shiftIndex = 0

local Trinket = {}

function Trinket.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.EYE_OF_SPODE)
		and not (room:IsMirrorWorld() or (StageAPI and StageAPI:IsMirrorDimension()))
		then
			if room:IsFirstVisit()
			and room:GetType() == RoomType.ROOM_TREASURE
			and not Functions.ContainsQuestItem()
			then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false)
				local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, Vector(320, 400), Vector.Zero, nil)
				blackHole.SpriteScale = Vector(50, 50)
				rewinding = true
				shiftIndex = roomIndex
			end

			for i = 0, DoorSlot.NUM_DOOR_SLOTS do
				local door = room:GetDoor(i)
		
				if door
				and door.TargetRoomType == RoomType.ROOM_TREASURE
				and room:GetType() ~= RoomType.ROOM_SECRET
				and room:GetType() ~= RoomType.ROOM_SUPERSECRET
				then
					local roomIdx = door.TargetRoomIndex
					local roomDesc = level:GetRoomByIdx(roomIdx, 0)

					if roomDesc.VisitedCount == 0 then
						local doorSprite = door:GetSprite()
		
						for i = 0, 4 do
							doorSprite:ReplaceSpritesheet(i, "gfx/grid/andromeda_abandonedplanetariumdoor_out.png")
						end
						
						doorSprite:LoadGraphics()
					end
				end
			end
		end
	end
end

function Trinket.postPEffectUpdate(player)
	if not player:HasTrinket(Enums.Trinkets.EYE_OF_SPODE) then return end
	
	local level = game:GetLevel()
	local roomIndex = level:GetCurrentRoomIndex()
	local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.EYE_OF_SPODE)
	
	if rewinding
	and roomIndex ~= shiftIndex
	then
		player:StopExtraAnimation()
		local blackHole = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.BLACK_HOLE, 0, Vector(320, 400), Vector.Zero, nil)
		blackHole.SpriteScale = Vector(50, 50)
		
		if (level:GetStage() ~= LevelStage.STAGE1_1 and not game:IsGreedMode())
		or (game:IsGreedMode() and shiftIndex ~= 98)
		then
			local hasStars = false
			
			for i = 0, 3 do
				if player:GetCard(i) == Card.CARD_STARS then
					player:SetCard(i, 0)
					hasStars = true
				end
			end

			if not hasStars then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY)
				and player:GetNumCoins() > 0
				then
					player:AddCoins(-1)
				elseif player:GetNumKeys() > 0
				and not player:HasGoldenKey()
				then
					player:AddKeys(-1)
				end
			end
		end

		if trinketMultiplier > 2 then
			ANDROMEDA:GoToAbandonedPlanetarium(player, 0.333, true, true, shiftIndex)
		elseif trinketMultiplier == 2 then
			ANDROMEDA:GoToAbandonedPlanetarium(player, 0.333, true, false, shiftIndex)
		else
			ANDROMEDA:GoToAbandonedPlanetarium(player, 0.333, false, false, shiftIndex)
		end

		local data = level:GetRoomByIdx(GridRooms.ROOM_DEBUG_IDX, 0).Data
		local treasureDesc = level:GetRoomByIdx(shiftIndex, 0)
		treasureDesc.Data = data
		game:StartRoomTransition(shiftIndex, Direction.NO_DIRECTION, RoomTransitionAnim.FADE_MIRROR, player)

		rewinding = false
		shiftIndex = 0
	end
end

return Trinket