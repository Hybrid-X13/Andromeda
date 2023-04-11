local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()
local initSeeds = {}

local Item = {}

local function ShouldDropHeart(npc)
	for i = 1, #initSeeds do
		if npc.InitSeed == initSeeds[i] then
			table.remove(initSeeds, i)

			return true
		end
	end

	return false
end

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
		table.insert(initSeeds, enemy.InitSeed)
	end
end

function Item.postNPCDeath(npc)
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.OPHIUCHUS) then return end
	if not ShouldDropHeart(npc) then return end
	
	rng:SetSeed(npc.InitSeed, 35)
		
	local randNum = rng:RandomInt(20)
	
	if randNum == 0 then
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

		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, parentTear.Variant, parentTear.SubType, pos, parentTear.Velocity, player):ToTear()

		Functions.ChangeTear(tear, player)

		tear:AddTearFlags(parentTear.TearFlags)
		tear:GetData().isBarrageTear = true
		tear.CollisionDamage = parentTear.CollisionDamage
		tear.Scale = parentTear.Scale
		tear.Color = parentTear.Color
		tear.FallingAcceleration = parentTear.FallingAcceleration
		tear.FallingSpeed = parentTear.FallingSpeed
		tear.Height = parentTear.Height
		tear.ParentOffset = parentTear.ParentOffset
		tear.PositionOffset = parentTear.PositionOffset
		data.barrageNum = data.barrageNum - 1

		if parentTear:GetData().starburstTear then
			local sprite = tear:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
			sprite:LoadGraphics()
			tear:GetData().starburstTear = true
		end
	end
end

return Item