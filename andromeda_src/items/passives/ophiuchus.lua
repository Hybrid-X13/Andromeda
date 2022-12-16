local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

local Item = {}

function Item.postFireTear(tear)
	if not tear.Visible then return end
	if tear.SpawnerEntity == nil then return end
	
	local player = tear.SpawnerEntity:ToPlayer()

	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.OPHIUCHUS) then return end
	
	local rng = player:GetCollectibleRNG(Enums.Collectibles.OPHIUCHUS)
	local luck = player.Luck
	local randNum = rng:RandomInt(100 - math.floor(luck))
	
	if randNum < 15 then
		tear:GetData().isBarrageTear = true
		tear.CollisionDamage = tear.CollisionDamage / 3
		
		player:GetData().ophiuchusBarrage = {
			barrageNum = 4,
			parentTear = tear,
			position = tear.Position
		}
	end
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.OPHIUCHUS) then return end
		
	local health = enemy.HitPoints - amount
	local data

	if source.Entity then
		data = source.Entity:GetData().isBarrageTear
	end
	
	if health <= 0
	and data
	then
		enemy:GetData().killedByOphiuchus = true
	end
end

function Item.postEntityKill(npc)
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.OPHIUCHUS) then return end
	
	rng:SetSeed(npc.InitSeed, 35)
		
	local randNum = rng:RandomInt(20)
	
	if npc:GetData().killedByOphiuchus
	and randNum == 0
	then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, npc.Position, Vector.Zero, nil)
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.OPHIUCHUS) then return end
	
	local room = game:GetRoom()
	local data = player:GetData().ophiuchusBarrage
	
	if data == nil then return end
	
	local parentTear = data.parentTear
	
	if parentTear.FrameCount > 0
	and data.barrageNum > 0
	then
		local pos = data.position

		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
			pos = room:GetCenterPos()
		end

		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, parentTear.Variant, parentTear.SubType, pos, parentTear.Velocity, player)
		local barrageTear = tear:ToTear()

		Functions.ChangeTear(barrageTear, player)

		barrageTear:AddTearFlags(parentTear.TearFlags)
		tear:GetData().isBarrageTear = true
		barrageTear.CollisionDamage = parentTear.CollisionDamage
		barrageTear.Scale = parentTear.Scale
		barrageTear.Color = parentTear.Color
		barrageTear.FallingAcceleration = parentTear.FallingAcceleration
		barrageTear.FallingSpeed = parentTear.FallingSpeed
		barrageTear.Height = parentTear.FallingSpeed
		barrageTear.Height = parentTear.Height
		barrageTear.ParentOffset = parentTear.ParentOffset
		barrageTear.PositionOffset = parentTear.PositionOffset
		data.barrageNum = data.barrageNum - 1
	end
end

return Item