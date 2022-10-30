local Enums = require("andromeda_src.enums")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local map = {
	[RoomType.ROOM_TREASURE] = CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
	[RoomType.ROOM_SHOP] = CollectibleType.COLLECTIBLE_MAGIC_FINGERS,
	[RoomType.ROOM_BOSS] = CollectibleType.COLLECTIBLE_PLUM_FLUTE,
	[RoomType.ROOM_MINIBOSS] = CollectibleType.COLLECTIBLE_BOOK_OF_SIN, --Doesn't work
	[RoomType.ROOM_SECRET] = CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS,
	[RoomType.ROOM_SUPERSECRET] = CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS,
	[RoomType.ROOM_DEVIL] = CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
	[RoomType.ROOM_ANGEL] = CollectibleType.COLLECTIBLE_BIBLE,
	[RoomType.ROOM_CURSE] = CollectibleType.COLLECTIBLE_RAZOR_BLADE,
	[RoomType.ROOM_SACRIFICE] = CollectibleType.COLLECTIBLE_SATANIC_BIBLE,
	[RoomType.ROOM_PLANETARIUM] = CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
	[RoomType.ROOM_ULTRASECRET] = CollectibleType.COLLECTIBLE_RED_KEY,
	[RoomType.ROOM_ERROR] = CollectibleType.COLLECTIBLE_UNDEFINED,
	[RoomType.ROOM_ARCADE] = CollectibleType.COLLECTIBLE_PORTABLE_SLOT,
	[RoomType.ROOM_DUNGEON] = CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER,
	[RoomType.ROOM_ISAACS] = CollectibleType.COLLECTIBLE_PINKING_SHEARS,
	[RoomType.ROOM_BARREN] = CollectibleType.COLLECTIBLE_POOP,
	[RoomType.ROOM_BLACK_MARKET] = CollectibleType.COLLECTIBLE_MOMS_PAD,
	[RoomType.ROOM_DICE] = CollectibleType.COLLECTIBLE_D6,
	[RoomType.ROOM_CHEST] = CollectibleType.COLLECTIBLE_DADS_KEY,
	[RoomType.ROOM_BOSSRUSH] = CollectibleType.COLLECTIBLE_HOURGLASS,
}

local Card = {}

function Card.useCard(card, player, flag)
	if card ~= Enums.Cards.ALPHA_CENTAURI then return end
	
	local room = game:GetRoom()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1)
	local rng = player:GetCardRNG(Enums.Cards.ALPHA_CENTAURI)
	
	if #items == 0 then return end
	
	for i, j in pairs(items) do
		local pickup = j:ToPickup()
		
		if pickup.Price == 0 then
			if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
			and pickup.SubType > 0
			then
				for i = 1, 5 do
					if map[room:GetType()] then
						player:AddWisp(map[room:GetType()], pickup.Position, true, false)
					else
						player:AddWisp(0, pickup.Position, true, false)
					end
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
					pickup:Remove()
				end
			elseif pickup.Variant == PickupVariant.PICKUP_HEART
			or pickup.Variant == PickupVariant.PICKUP_COIN
			or pickup.Variant == PickupVariant.PICKUP_KEY
			or pickup.Variant == PickupVariant.PICKUP_BOMB
			or pickup.Variant == PickupVariant.PICKUP_GRAB_BAG
			or pickup.Variant == PickupVariant.PICKUP_PILL
			or pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
			or pickup.Variant == PickupVariant.PICKUP_TAROTCARD
			or pickup.Variant == PickupVariant.PICKUP_TRINKET
			or (((pickup.Variant >= PickupVariant.PICKUP_CHEST and pickup.Variant <= PickupVariant.PICKUP_LOCKEDCHEST) or pickup.Variant == PickupVariant.PICKUP_REDCHEST) and pickup.SubType == ChestSubType.CHEST_CLOSED)
			then
				local randNum = rng:RandomInt(2)
				
				if randNum == 0 then
					player:AddWisp(0, pickup.Position, true, false)
				end
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, pickup)
				pickup:Remove()
			end
		end
	end
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)

	local randNum = rng:RandomInt(2)

	if flag & UseFlag.USE_MIMIC ~= UseFlag.USE_MIMIC then
		if Options.AnnouncerVoiceMode == 2
		or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
		then
			sfx:Play(Enums.Voicelines.ALPHA_CENTAURI)
		end
	end
end

return Card