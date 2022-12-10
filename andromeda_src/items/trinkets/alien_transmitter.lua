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
		
		if not player:HasTrinket(Enums.Trinkets.ALIEN_TRANSMITTER) then return end
		
		local trinketMultiplier = player:GetTrinketMultiplier(Enums.Trinkets.ALIEN_TRANSMITTER)
		local rng = player:GetTrinketRNG(Enums.Trinkets.ALIEN_TRANSMITTER)
		local rngMax = 2400 / trinketMultiplier
		local randNum = rng:RandomInt(rngMax)
		
		if randNum == 0 then
			npc:SetColor(Color(0, 1, 0, 1, 0, 0.2, 0), 99999, 1, false, false)
			npc:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			sfx:Play(Enums.Sounds.ABDUCTION_BEAM, 4)
			
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOP_SPIKES, 0, npc.Position, Vector.Zero, player)
			local beam = effect:ToEffect()
			beam:GetData().isAbductionBeam = true
			beam:GetData().effectTimer = 80
			
			local sprite = beam:GetSprite()
			sprite:Load("gfx/transmitterbeam.anm2", true)
			sprite:ReplaceSpritesheet(0, "gfx/effects/kidnabtion.png")
			sprite:Play("Appear")
			npc:GetData().isAbducted = true
		end
	end
end

function Trinket.postUpdate()
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if entity:GetData().isAbducted then
			entity.SpriteOffset = entity.SpriteOffset + Vector(0, -3)
			
			if entity.SpriteOffset.Y < -250 then
				entity:Remove()
			end
		end
	end
end

function Trinket.postEffectUpdate(effect)
	if effect.Variant ~= EffectVariant.SHOP_SPIKES then return end
	if effect:GetData().isAbductionBeam == nil then return end
	
	local sprite = effect:GetSprite()

	if sprite:IsFinished("Appear")
	and not sprite:IsPlaying("Disappear")
	then
		sprite:Play("Loop")
	end
	
	if effect:GetData().effectTimer == 0 then
		sprite:Play("Disappear")
	else
		effect:GetData().effectTimer = effect:GetData().effectTimer - 1
	end
end

return Trinket