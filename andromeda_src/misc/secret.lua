local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()

local Room = {}

function Room.postNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data
	local player = Isaac.GetPlayer(0)

	if room:GetType() ~= RoomType.ROOM_SECRET then return end
	if roomConfig.Variant ~= 9440 then return end

	Functions.SetAbandonedPlanetarium(player, false)

	if room:IsFirstVisit() then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT, 3, room:GetCenterPos(), Vector.Zero, nil)
	end
end

function Room.postUpdate()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stageType = level:GetStageType()
	local roomDesc = level:GetCurrentRoomDesc()
	local roomConfig = roomDesc.Data
	
	if room:GetType() ~= RoomType.ROOM_SECRET then return end
	if roomConfig.Variant ~= 9440 then return end

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

return Room