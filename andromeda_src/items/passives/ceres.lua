local Enums = require("andromeda_src.enums")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local CellHeart = {
	HALF = 120,
	FULL = 121,
	DOUBLE = 122,
}

local map = {
	[PickupVariant.PICKUP_HEART] = {
		[HeartSubType.HEART_HALF] = HeartSubType.HEART_FULL,
		[HeartSubType.HEART_SCARED] = HeartSubType.HEART_FULL,
		[HeartSubType.HEART_FULL] = HeartSubType.HEART_DOUBLEPACK,
		[HeartSubType.HEART_HALF_SOUL] = HeartSubType.HEART_SOUL,
		[HeartSubType.HEART_SOUL] = HeartSubType.HEART_BLACK,
		[CellHeart.HALF] = CellHeart.FULL,
		[CellHeart.FULL] = CellHeart.DOUBLE,
	},
	[PickupVariant.PICKUP_COIN] = {
		[CoinSubType.COIN_PENNY] = CoinSubType.COIN_DOUBLEPACK,
		[CoinSubType.COIN_DOUBLEPACK] = CoinSubType.COIN_NICKEL,
		[CoinSubType.COIN_STICKYNICKEL] = CoinSubType.COIN_NICKEL,
		[CoinSubType.COIN_NICKEL] = CoinSubType.COIN_DIME,
		[CoinSubType.COIN_DIME] = CoinSubType.COIN_LUCKYPENNY,
		[CoinSubType.COIN_LUCKYPENNY] = CoinSubType.COIN_GOLDEN,
	},
	[PickupVariant.PICKUP_BOMB] = {
		[BombSubType.BOMB_NORMAL] = BombSubType.BOMB_DOUBLEPACK,
		[BombSubType.BOMB_DOUBLEPACK] = BombSubType.BOMB_GOLDEN,
	},
	[PickupVariant.PICKUP_KEY] = {
		[KeySubType.KEY_NORMAL] = KeySubType.KEY_DOUBLEPACK,
		[KeySubType.KEY_DOUBLEPACK] = KeySubType.KEY_CHARGED,
		[KeySubType.KEY_CHARGED] = KeySubType.KEY_GOLDEN,
	},
	[PickupVariant.PICKUP_LIL_BATTERY] = {
		[BatterySubType.BATTERY_MICRO] = BatterySubType.BATTERY_NORMAL,
		[BatterySubType.BATTERY_NORMAL] = BatterySubType.BATTERY_MEGA,
		[BatterySubType.BATTERY_MEGA] = BatterySubType.BATTERY_GOLDEN,
	},
}

local Item = {}

local function SpawnIcon(pickup)
	local ceresIcon = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.PLANETARIUM_ICON, 0, pickup.Position, Vector.Zero, nil)
	local sprite = ceresIcon:GetSprite()
	sprite:Play("Ceres")
end

function Item.postPickupInit(pickup)
	rng:SetSeed(pickup.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.CERES) then return end
		
		local randNum = rng:RandomInt(5)
		
		if randNum == 0 then
			if pickup.Variant == PickupVariant.PICKUP_BOMB
			and pickup.SubType == BombSubType.BOMB_GOLDEN
			and player:HasGoldenBomb()
			then
				SpawnIcon(pickup)
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GIGA, true, false, false)
			elseif pickup.Variant == PickupVariant.PICKUP_KEY
			and pickup.SubType == KeySubType.KEY_GOLDEN
			and player:HasGoldenKey()
			then
				SpawnIcon(pickup)
				pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, true, false, false)
			elseif map[pickup.Variant]
			and map[pickup.Variant][pickup.SubType]
			then
				SpawnIcon(pickup)
				pickup:Morph(EntityType.ENTITY_PICKUP, pickup.Variant, map[pickup.Variant][pickup.SubType], true, false, false)
			end
		end
	end
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local player = target:ToPlayer()
	
	if player == nil then return end
	if not player:HasCollectible(Enums.Collectibles.CERES) then return end
	if flag & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE then return end
	if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then return end

	local pickupCount = player:GetNumCoins() + player:GetNumBombs() + player:GetNumKeys() + 103
	local rng = player:GetCollectibleRNG(Enums.Collectibles.CERES)
	local randNum = rng:RandomInt(1000)
	
	if randNum < pickupCount then
		player:UseCard(Card.CARD_HOLY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
		sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION, 1.3, 2, false, 1.2)
	end
end

function Item.postEffectUpdate(effect)
	if effect.Variant ~= Enums.Effects.PLANETARIUM_ICON then return end
	
	local sprite = effect:GetSprite()

	if not sprite:IsFinished("Ceres") then return end
	
	effect:Remove()
end

return Item