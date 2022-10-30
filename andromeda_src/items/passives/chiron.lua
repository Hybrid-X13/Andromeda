local Enums = require("andromeda_src.enums")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local Item = {}

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()
	local room = game:GetRoom()
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.CHIRON) then return end
	if player:GetPlayerType() == PlayerType.PLAYER_EDEN_B then return end
	if flag & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE then return end
	if flag & DamageFlag.DAMAGE_BOOGER == DamageFlag.DAMAGE_BOOGER then return end

	if (flag & DamageFlag.DAMAGE_RED_HEARTS ~= DamageFlag.DAMAGE_RED_HEARTS
		and flag & DamageFlag.DAMAGE_CURSED_DOOR ~= DamageFlag.DAMAGE_CURSED_DOOR
		and flag & DamageFlag.DAMAGE_IV_BAG ~= DamageFlag.DAMAGE_IV_BAG
		and flag & DamageFlag.DAMAGE_NO_PENALTIES ~= DamageFlag.DAMAGE_NO_PENALTIES)
	or (flag & DamageFlag.DAMAGE_SPIKES == DamageFlag.DAMAGE_SPIKES and room:GetType() ~= RoomType.ROOM_SACRIFICE and room:GetType() ~= RoomType.ROOM_DEVIL)
	then
		game:SetStateFlag(GameStateFlag.STATE_PERFECTION_SPAWNED, true)

		if player:HasTrinket(TrinketType.TRINKET_PERFECTION) then
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
			player:TryRemoveTrinket(TrinketType.TRINKET_PERFECTION)
			player:TryRemoveTrinket(TrinketType.TRINKET_PERFECTION + TrinketType.TRINKET_GOLDEN_FLAG)
		end
	end

	if flag & DamageFlag.DAMAGE_INVINCIBLE == DamageFlag.DAMAGE_INVINCIBLE
	or (flag & DamageFlag.DAMAGE_SPIKES == DamageFlag.DAMAGE_SPIKES and (room:GetType() == RoomType.ROOM_SACRIFICE or room:GetType() == RoomType.ROOM_DEVIL))
	then
		SaveData.ItemData.Chiron.Chance = SaveData.ItemData.Chiron.Chance + 4.5
	else
		local rng = player:GetCollectibleRNG(Enums.Collectibles.CHIRON)
		local randNum = rng:RandomInt(100)
		
		if randNum <= SaveData.ItemData.Chiron.Chance then
			for i = 1, ((amount * 2) + amount) do
				if player:GetEffectiveMaxHearts() < 1
				or (player:GetEffectiveMaxHearts() > 0 and player:HasFullHearts())
				then
					player:AddSoulHearts(1)
				else
					player:AddHearts(1)
				end
			end
			
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector.Zero, player)
			
			if (amount * 2) > 2 then
				sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE)
			else
				sfx:Play(SoundEffect.SOUND_VAMP_GULP)
			end
			SaveData.ItemData.Chiron.Chance = 4
		else
			SaveData.ItemData.Chiron.Chance = SaveData.ItemData.Chiron.Chance + 4.5
		end

		player:TakeDamage(amount, flag | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_BOOGER, EntityRef(player), 0)
		return false
	end
end

return Item