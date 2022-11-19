local Enums = require("andromeda_src.enums")

local CustomData = {}

CustomData.SpodeList = {
	CollectibleType.COLLECTIBLE_TAURUS,
	CollectibleType.COLLECTIBLE_ARIES,
	CollectibleType.COLLECTIBLE_CANCER,
	CollectibleType.COLLECTIBLE_LEO,
	CollectibleType.COLLECTIBLE_VIRGO,
	CollectibleType.COLLECTIBLE_LIBRA,
	CollectibleType.COLLECTIBLE_SCORPIO,
	CollectibleType.COLLECTIBLE_SAGITTARIUS,
	CollectibleType.COLLECTIBLE_CAPRICORN,
	CollectibleType.COLLECTIBLE_AQUARIUS,
	CollectibleType.COLLECTIBLE_PISCES,
	CollectibleType.COLLECTIBLE_GEMINI,
	CollectibleType.COLLECTIBLE_SOL,
	CollectibleType.COLLECTIBLE_LUNA,
	CollectibleType.COLLECTIBLE_MERCURIUS,
	CollectibleType.COLLECTIBLE_VENUS,
	CollectibleType.COLLECTIBLE_TERRA,
	CollectibleType.COLLECTIBLE_MARS,
	CollectibleType.COLLECTIBLE_JUPITER,
	CollectibleType.COLLECTIBLE_SATURNUS,
	CollectibleType.COLLECTIBLE_URANUS,
	CollectibleType.COLLECTIBLE_NEPTUNUS,
	CollectibleType.COLLECTIBLE_PLUTO,
	Enums.Collectibles.CERES,
	Enums.Collectibles.JUNO,
	Enums.Collectibles.PALLAS,
	Enums.Collectibles.VESTA,
	Enums.Collectibles.CHIRON,
	Enums.Collectibles.OPHIUCHUS,
}

CustomData.AbandonedPlanetariumPool = {
	CollectibleType.COLLECTIBLE_TAURUS,
	CollectibleType.COLLECTIBLE_ARIES,
	CollectibleType.COLLECTIBLE_CANCER,
	CollectibleType.COLLECTIBLE_LEO,
	CollectibleType.COLLECTIBLE_VIRGO,
	CollectibleType.COLLECTIBLE_LIBRA,
	CollectibleType.COLLECTIBLE_SCORPIO,
	CollectibleType.COLLECTIBLE_SAGITTARIUS,
	CollectibleType.COLLECTIBLE_CAPRICORN,
	CollectibleType.COLLECTIBLE_AQUARIUS,
	CollectibleType.COLLECTIBLE_PISCES,
	CollectibleType.COLLECTIBLE_GEMINI,
	Enums.Collectibles.OPHIUCHUS,
}

CustomData.BookOfCosmosList = {
	CollectibleType.COLLECTIBLE_ARIES,
	CollectibleType.COLLECTIBLE_CANCER,
	CollectibleType.COLLECTIBLE_LEO,
	CollectibleType.COLLECTIBLE_VIRGO,
	CollectibleType.COLLECTIBLE_LIBRA,
	CollectibleType.COLLECTIBLE_SCORPIO,
	CollectibleType.COLLECTIBLE_SAGITTARIUS,
	CollectibleType.COLLECTIBLE_CAPRICORN,
	CollectibleType.COLLECTIBLE_AQUARIUS,
	CollectibleType.COLLECTIBLE_PISCES,
	CollectibleType.COLLECTIBLE_GEMINI,
	CollectibleType.COLLECTIBLE_MERCURIUS,
	CollectibleType.COLLECTIBLE_VENUS,
	CollectibleType.COLLECTIBLE_TERRA,
	CollectibleType.COLLECTIBLE_MARS,
	CollectibleType.COLLECTIBLE_JUPITER,
	CollectibleType.COLLECTIBLE_SATURNUS,
	CollectibleType.COLLECTIBLE_URANUS,
	CollectibleType.COLLECTIBLE_NEPTUNUS,
	CollectibleType.COLLECTIBLE_PLUTO,
	Enums.Collectibles.CERES,
	Enums.Collectibles.JUNO,
	Enums.Collectibles.VESTA,
	Enums.Collectibles.CHIRON,
	Enums.Collectibles.OPHIUCHUS,
}

CustomData.SingularityPickups = {
	{
		Variant = PickupVariant.PICKUP_COLLECTIBLE,
		SubType = CollectibleType.COLLECTIBLE_DOLLAR,
		NumCharges = 24,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COLLECTIBLE,
		SubType = CollectibleType.COLLECTIBLE_PYRO,
		NumCharges = 24,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COLLECTIBLE,
		SubType = CollectibleType.COLLECTIBLE_SKELETON_KEY,
		NumCharges = 24,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COLLECTIBLE,
		SubType = CollectibleType.COLLECTIBLE_QUARTER,
		NumCharges = 12,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COLLECTIBLE,
		SubType = CollectibleType.COLLECTIBLE_BOOM,
		NumCharges = 10,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_ETERNAL,
		NumCharges = 3,
		CanPickUp = function()
			local eternalHearts = ANDROMEDA.player:GetEternalHearts()
			local maxHearts = ANDROMEDA.player:GetMaxHearts()
			local heartLimit = ANDROMEDA.player:GetHeartLimit()

			if eternalHearts > 0
			and maxHearts == heartLimit
			then
				return false
			end

			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_DOUBLEPACK,
		NumCharges = 2,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_BLACK,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickBlackHearts()
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_BONE,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickBoneHearts()
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_ROTTEN,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickRottenHearts()
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_BLENDED,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:CanPickSoulHearts()
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_SOUL,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickSoulHearts()
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_HALF_SOUL,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickSoulHearts()
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_HALF,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_FULL,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
		end,
	},
	{
		Variant = PickupVariant.PICKUP_HEART,
		SubType = HeartSubType.HEART_SCARED,
		NumCharges = 1,
		CanPickUp = function()
			return ANDROMEDA.player:CanPickRedHearts() or ANDROMEDA.player:HasTrinket(TrinketType.TRINKET_APPLE_OF_SODOM)
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COIN,
		SubType = CoinSubType.COIN_DIME,
		NumCharges = 3,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COIN,
		SubType = CoinSubType.COIN_LUCKYPENNY,
		NumCharges = 3,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COIN,
		SubType = CoinSubType.COIN_NICKEL,
		NumCharges = 2,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COIN,
		SubType = CoinSubType.COIN_DOUBLEPACK,
		NumCharges = 2,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COIN,
		SubType = CoinSubType.COIN_GOLDEN,
		NumCharges = 1,
		CanPickUp = function()
			local rng = ANDROMEDA.player:GetCollectibleRNG(Enums.Collectibles.SINGULARITY)
			local randNum = rng:RandomInt(2)

			if randNum == 0 then
				return true
			end
			return false
		end,
	},
	{
		Variant = PickupVariant.PICKUP_COIN,
		SubType = CoinSubType.COIN_PENNY,
		NumCharges = 1,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_BOMB,
		SubType = BombSubType.BOMB_GIGA,
		NumCharges = 4,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_BOMB,
		SubType = BombSubType.BOMB_GOLDEN,
		NumCharges = 3,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_BOMB,
		SubType = BombSubType.BOMB_DOUBLEPACK,
		NumCharges = 2,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_BOMB,
		SubType = BombSubType.BOMB_NORMAL,
		NumCharges = 1,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_KEY,
		SubType = KeySubType.KEY_CHARGED,
		NumCharges = 4,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_KEY,
		SubType = KeySubType.KEY_GOLDEN,
		NumCharges = 3,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_KEY,
		SubType = KeySubType.KEY_DOUBLEPACK,
		NumCharges = 2,
		CanPickUp = function()
			return true
		end,
	},
	{
		Variant = PickupVariant.PICKUP_KEY,
		SubType = KeySubType.KEY_NORMAL,
		NumCharges = 1,
		CanPickUp = function()
			return true
		end,
	},
}

CustomData.AbPlPoolCopy = {}
CustomData.BookOfCosmosCopy = {}

for i = 1, #CustomData.AbandonedPlanetariumPool do
	CustomData.AbPlPoolCopy[i] = CustomData.AbandonedPlanetariumPool[i]
end
for i = 1, #CustomData.BookOfCosmosList do
	CustomData.BookOfCosmosCopy[i] = CustomData.BookOfCosmosList[i]
end

return CustomData