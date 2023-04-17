local Enums = require("andromeda_src.enums")
local game = Game()
local rng = RNG()
local options = {-1, -13, 1, 13}

local Trinket = {}

--Originally by Xalum, taken from Retribution: https://steamcommunity.com/sharedfiles/filedetails/?id=2881008017
local function RevealNearbyRooms()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local tab = {}

	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)

		if door
		and door.TargetRoomType ~= RoomType.ROOM_SECRET
		and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET
		and door.TargetRoomType ~= RoomType.ROOM_ULTRASECRET
		then
			local roomIdx = level:GetRoomByIdx(door.TargetRoomIndex)
			local shape = roomIdx.Data.Shape
			tab[#tab + 1] = roomIdx.SafeGridIndex
			
			if shape == RoomShape.ROOMSHAPE_1x2
			or shape == RoomShape.ROOMSHAPE_IIV
			then
				table.insert(tab, roomIdx.SafeGridIndex + 13)
			elseif shape == RoomShape.ROOMSHAPE_2x1
			or shape == RoomShape.ROOMSHAPE_IIH
			then
				table.insert(tab, roomIdx.SafeGridIndex + 1)
			elseif shape == RoomShape.ROOMSHAPE_2x2 then
				table.insert(tab, roomIdx.SafeGridIndex + 1)
				table.insert(tab, roomIdx.SafeGridIndex + 13)
				table.insert(tab, roomIdx.SafeGridIndex + 14)
			elseif shape == RoomShape.ROOMSHAPE_LTL then
				table.insert(tab, roomIdx.SafeGridIndex + 12)
				table.insert(tab, roomIdx.SafeGridIndex + 13)
			elseif shape == RoomShape.ROOMSHAPE_LTR then
				table.insert(tab, roomIdx.SafeGridIndex + 13)
				table.insert(tab, roomIdx.SafeGridIndex + 14)
			elseif shape == RoomShape.ROOMSHAPE_LBL then
				table.insert(tab, roomIdx.SafeGridIndex + 1)
				table.insert(tab, roomIdx.SafeGridIndex + 14)
			elseif shape == RoomShape.ROOMSHAPE_LBR then
				table.insert(tab, roomIdx.SafeGridIndex + 1)
				table.insert(tab, roomIdx.SafeGridIndex + 13)
			end
		end
	end

	for _, index in pairs(tab) do
		for _, offset in pairs(options) do
			local desc = level:GetRoomByIdx(index + offset)

			if desc
			and desc.Data
			and desc.Data.Type ~= RoomType.ROOM_SECRET
			and desc.Data.Type ~= RoomType.ROOM_SUPERSECRET
			and desc.Data.Type ~= RoomType.ROOM_ULTRASECRET
			then
				desc.DisplayFlags = desc.DisplayFlags | 5
			end
		end
	end

	level:UpdateVisibility()
end

function Trinket.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.SEXTANT) then
			local findRoom = level:QueryRoomTypeIndex(RoomType.ROOM_PLANETARIUM, true, rng, true)
			local planetarium = level:GetRoomByIdx(findRoom)
			local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.SEXTANT)
			local rng = player:GetTrinketRNG(Enums.Trinkets.SEXTANT)
			rng:SetSeed(room:GetDecorationSeed(), 35)
			local randFloat = rng:RandomFloat() / trinketMultiplier
			
			if planetarium.Data
			and planetarium.Data.Type == RoomType.ROOM_PLANETARIUM
			and planetarium.DisplayFlags & 5 == 0
			then
				planetarium.DisplayFlags = planetarium.DisplayFlags | 5
				level:UpdateVisibility()
			end
			
			if room:IsFirstVisit()
			and randFloat < 0.15
			then
				RevealNearbyRooms()
			end
		end
	end
end

return Trinket