local Enums = require("andromeda_src.enums")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Trinket = {}

function Trinket.NPCUpdate(npc)
	if not npc:IsActiveEnemy() then return end
	if not npc:IsVulnerableEnemy() then return end
	if npc:IsBoss() then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FREEZE) then return end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if player:HasTrinket(Enums.Trinkets.ALIEN_TRANSMITTER) then
			local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.ALIEN_TRANSMITTER)
			local rng = player:GetTrinketRNG(Enums.Trinkets.ALIEN_TRANSMITTER)
			local rngMax = 3000 / trinketMultiplier
			local randNum = rng:RandomInt(rngMax)
			
			if randNum == 0 then
				npc:SetColor(Color(0, 1, 0, 1, 0, 0.2, 0), 99999, 1, false, false)
				npc:AddFreeze(EntityRef(player), 999)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc:GetData().isAbducted = true
				
				Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.ABDUCTION_BEAM, 0, npc.Position + Vector(0, -1), Vector.Zero, player)
			end
		end
	end
end

function Trinket.postUpdate()
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if entity:GetData().isAbducted then
			entity.SpriteOffset = entity.SpriteOffset + Vector(0, -3)

			if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
				entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			end
			
			if entity.SpriteOffset.Y < -250 then
				entity:Remove()
			end
		end
	end
end

function Trinket.postEffectInit(effect)
	if effect.Variant ~= Enums.Effects.ABDUCTION_BEAM then return end
	
	local sprite = effect:GetSprite()

	sprite:Play("Appear")
	effect.Timeout = 80
	sfx:Play(Enums.Sounds.ABDUCTION_BEAM, 4)
end

function Trinket.postEffectUpdate(effect)
	if effect.Variant ~= Enums.Effects.ABDUCTION_BEAM then return end
	
	local sprite = effect:GetSprite()

	if sprite:IsFinished("Disappear") then
		effect:Remove()
	end

	if sprite:IsFinished("Appear")
	and not sprite:IsPlaying("Disappear")
	then
		sprite:Play("Loop")
	end
	
	if effect.Timeout == 0 then
		sprite:Play("Disappear")
	end
end

return Trinket