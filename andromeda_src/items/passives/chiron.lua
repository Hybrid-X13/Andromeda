local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()
local tookDamage = false
local data = {}

local Item = {}

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.CHIRON) then return end
	if flag & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE then return end

	data = {
		Player = target,
		Amount = amount,
	}
	tookDamage = true
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.CHIRON) then return end
	if not tookDamage then return end
	if GetPtrHash(player) ~= GetPtrHash(data.Player) then return end

	local level = game:GetLevel()
	local rng = player:GetCollectibleRNG(Enums.Collectibles.CHIRON)
	local randNum = rng:RandomInt(100)

	level:SetStateFlag(LevelStateFlag.STATE_REDHEART_DAMAGED, false)

	if randNum <= SaveData.ItemData.Chiron.Chance then
		for i = 1, ((data.Amount * 2) + data.Amount) do
			if player:GetEffectiveMaxHearts() < 1
			or Functions.IsSoulHeartCharacter(player)
			or (player:GetEffectiveMaxHearts() > 0 and player:HasFullHearts())
			then
				player:AddSoulHearts(1)
			else
				player:AddHearts(1)
			end
		end
		
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector.Zero, player)
		
		if (data.Amount * 2) > 2 then
			sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE)
		else
			sfx:Play(SoundEffect.SOUND_VAMP_GULP)
		end
		SaveData.ItemData.Chiron.Chance = 4
	else
		SaveData.ItemData.Chiron.Chance = SaveData.ItemData.Chiron.Chance + 4.5
	end

	tookDamage = false
	data = {}
end

return Item