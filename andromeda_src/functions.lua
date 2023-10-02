local Enums = require("andromeda_src.enums")
local SaveData = require("andromeda_src.savedata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local KnownFilePathsByName = {
	["resources/scripts/"] = true
}

local KnownFilePathsByIndex = {
	"resources/scripts/"
}

local Functions = {}

--Lemegeton wisp functions originally made by Aevilok, tweaked by me
function Functions.AddInnateItem(player, collectibleID, removeCostume)
	if removeCostume == nil then
		removeCostume = false
	end
	
	local itemWisp = player:AddItemWisp(collectibleID, Vector.Zero, true)

    itemWisp:RemoveFromOrbit()
    itemWisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    itemWisp.Visible = false
    itemWisp.CollisionDamage = 0
	itemWisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	itemWisp:GetData().tAndromedaWisp = true

	if removeCostume then
		local itemConfig = Isaac.GetItemConfig():GetCollectible(collectibleID)
		player:RemoveCostume(itemConfig)
	end

    return itemWisp
end

function Functions.HasInnateItem(collectibleID)
	local itemWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, collectibleID)

	if #itemWisps == 0 then return false end
	
	for _, wisp in pairs(itemWisps) do
		if wisp:GetData().tAndromedaWisp then
            return true
        end
    end
	return false
end

function Functions.RemoveInnateItem(collectibleID)
    local itemWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, collectibleID)
   
	if #itemWisps == 0 then return end
	
	for _, wisp in pairs(itemWisps) do
		if wisp:GetData().tAndromedaWisp then
			wisp:Remove()
			wisp:Kill()
		end
	end
end

function Functions.AddSmeltedTrinket(player, trinket, firstTimePickingUp)
	if firstTimePickingUp == nil then
		firstTimePickingUp = false
	end
	
	local trinket0 = player:GetTrinket(0)
    local trinket1 = player:GetTrinket(1)

	if trinket0 ~= 0 then
        player:TryRemoveTrinket(trinket0)
    end
    if trinket1 ~= 0 then
        player:TryRemoveTrinket(trinket1)
    end

	player:AddTrinket(trinket, firstTimePickingUp)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)

	if trinket0 ~= 0 then
        player:AddTrinket(trinket0, false)
    end
    if trinket1 ~= 0 then
        player:AddTrinket(trinket1, false)
    end
end

function Functions.AnyPlayerHasCollectible(itemID, ignoreModifiers)
	if ignoreModifiers == nil then
		ignoreModifiers = false
	end
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:HasCollectible(itemID, ignoreModifiers) then
			return true
		end
	end

	return false
end

function Functions.AddLightToTear(player, tear)
	local skinColor = player:GetHeadColor()
	local lightEffects = {
		Enums.Effects.TEAR_GLOW,
		Enums.Effects.TEAR_GLOW_WHITE,
		Enums.Effects.TEAR_GLOW_BLACK,
		Enums.Effects.TEAR_GLOW_BLUE,
		Enums.Effects.TEAR_GLOW_RED,
		Enums.Effects.TEAR_GLOW_GREEN,
		Enums.Effects.TEAR_GLOW_GRAY,
	}
	local light

	if Functions.HasBloodTears(player) then
		light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Enums.Effects.TEAR_GLOW_BLOOD, 0, tear.Position, tear.Velocity, player)
	else
		light = Isaac.Spawn(EntityType.ENTITY_EFFECT, lightEffects[skinColor + 2], 0, tear.Position, tear.Velocity, player)
	end

	light.Parent = tear

	local sprite = light:GetSprite()
	sprite:Play(tear:GetSprite():GetAnimation(), true)
	sprite:ReplaceSpritesheet(0, "nothinglol.png")
	sprite:LoadGraphics()
end

function Functions.AnyPlayerIsType(playerType)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if player:GetPlayerType() == playerType then
			return true
		end
	end

	return false
end

--Function provided by KingBobson. Prevents PRE_PICKUP_COLLISION from being executed multiple times when colliding with a pedestal item
function Functions.CanPickUpItem(player, pickup)
    if pickup.SubType == CollectibleType.COLLECTIBLE_NULL then return false end
    if player.ItemHoldCooldown > 0 then return false end
    if player:IsHoldingItem() then return false end
    if pickup.Wait > 0 then return false end
	if not player:IsExtraAnimationFinished() then return false end
	
	if pickup.Price > 0 and player:GetNumCoins() < pickup.Price then return false end
	if pickup.Price == PickupPrice.PRICE_ONE_HEART and player:GetEffectiveMaxHearts() < 2 then return false end
    if pickup.Price == PickupPrice.PRICE_TWO_HEARTS and player:GetEffectiveMaxHearts() < 2 then return false end
    if pickup.Price == PickupPrice.PRICE_THREE_SOULHEARTS and player:GetSoulHearts() < 1 then return false end
	if pickup.Price == PickupPrice.PRICE_TWO_SOUL_HEARTS and player:GetSoulHearts() < 1 then return false end
    if pickup.Price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART and player:GetSoulHearts() < 1 then return false end
    if pickup.Price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS and player:GetEffectiveMaxHearts() < 2 then return false end

	return true
end

function Functions.ChangeLaserColor(laser, player)
	local sprite = laser:GetSprite()
	local color = laser.Color
	local transparency = 1

	if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
		if laser.Variant == LaserVariant.LIGHT_BEAM
		or laser.Variant == LaserVariant.TRACTOR_BEAM
		or laser.Variant == LaserVariant.LIGHT_RING
		or laser.Variant == LaserVariant.THICK_BROWN
		then
			transparency = 0.1
		end
		color = Color(0.464, 0.996, 1, transparency, 0, 0, 0)
		color:SetColorize(4, 11, 14, 1)
	elseif player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
		if laser.Variant == LaserVariant.TRACTOR_BEAM
		or laser.Variant == LaserVariant.LIGHT_RING
		then
			if SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] == 1 then
				transparency = 0.45
			else
				transparency = 0.15
			end
		end

		if SaveData.PlayerData.T_Andromeda.Costumes["DEFAULT"] == 1 then
			if laser.Variant == LaserVariant.SHOOP
			or laser.Variant == LaserVariant.LIGHT_BEAM
			or laser.Variant == LaserVariant.TRACTOR_BEAM
			or laser.Variant == LaserVariant.LIGHT_RING
			or laser.Variant == LaserVariant.ELECTRIC
			or laser.Variant == LaserVariant.THICK_BROWN
			then
				color = Color(1, 0, 0, transparency, 0, 0, 0)
				color:SetColorize(5, 0, 0, 1)
			end
		elseif player:GetHeadColor() == SkinColor.SKIN_WHITE then
			color = Color(1, 1, 1, transparency, 1, 1, 1)
			color:SetColorize(1, 1, 1, 1)
		elseif player:GetHeadColor() == SkinColor.SKIN_BLACK then
			color = Color(0, 0, 0, transparency, 0, 0, 0)
		elseif player:GetHeadColor() == SkinColor.SKIN_BLUE then
			color = Color(0.464, 0.5, 1, transparency, 0, 0, 0)
			color:SetColorize(4, 7, 14, 1)
		elseif player:GetHeadColor() == SkinColor.SKIN_RED then
			color = Color(1, 0.5, 0.4, transparency, 0, 0, 0)
			color:SetColorize(14, 4, 4, 1)
		elseif player:GetHeadColor() == SkinColor.SKIN_GREEN then
			color = Color(0.5, 1, 0.4, transparency, 0, 0, 0)
			color:SetColorize(4, 10, 4, 1)
		elseif player:GetHeadColor() == SkinColor.SKIN_GREY then
			color = Color(1, 1, 1, transparency, 0, 0, 0)
			color:SetColorize(4, 4, 4, 1)
		else
			color = Color(1, 1, 0.36, transparency, 1, 1, 0.76)
			color:SetColorize(1, 1, 0, 1)
		end
	end
	sprite.Color = color

	if laser.Child then
		local impactSprite = laser.Child:GetSprite()
		impactSprite.Color = color
	end
end

function Functions.ChangeTear(tear, player)
	local sprite = tear:GetSprite()
	
	if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
		local andromedaMap = {
			[TearVariant.BLUE] = "tears_cosmic",
			[TearVariant.BLOOD] = "tears_cosmic",
			[TearVariant.CUPID_BLUE] = "cupids_arrow_tears_cosmic",
			[TearVariant.CUPID_BLOOD] = "cupids_arrow_tears_cosmic",
			[TearVariant.PUPULA] = "pupula_tears_cosmic",
			[TearVariant.PUPULA_BLOOD] = "pupula_tears_cosmic",
			[TearVariant.GODS_FLESH] = "godsflesh_tears_cosmic",
			[TearVariant.GODS_FLESH_BLOOD] = "godsflesh_tears_cosmic",
			[TearVariant.GLAUCOMA] = "glaucoma_tears_cosmic",
			[TearVariant.EYE] = "tears_pop_cosmic",
			[TearVariant.EYE_BLOOD] = "tears_pop_cosmic",
			[TearVariant.DIAMOND] = "diamond_tears_cosmic",
			[TearVariant.LOST_CONTACT] = "lost_contact_tears_cosmic",
			[TearVariant.HUNGRY] = "tears_hungry_cosmic",
			[TearVariant.EXPLOSIVO] = "tears_explosivo_cosmic",
			[TearVariant.BALLOON] = "tears_balloon_cosmic",
			[TearVariant.BALLOON_BRIMSTONE] = "tears_balloon_brimstone_cosmic",
			[TearVariant.FIRE_MIND] = "fire_mind_tears_cosmic",
		}

		if andromedaMap[tear.Variant] then
			sprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/" .. andromedaMap[tear.Variant] .. ".png")
		end
	elseif player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
		local skinColor = player:GetHeadColor()
		local colors = {
			"basic",
			"white",
			"black",
			"blue",
			"strawberry",
			"green",
			"gray",
		}
		local tAndromedaMap = {
			[TearVariant.BLUE] = "tears_solar",
			[TearVariant.BLOOD] = "tears_solar",
			[TearVariant.CUPID_BLUE] = "cupids_arrow_tears_solar",
			[TearVariant.CUPID_BLOOD] = "cupids_arrow_tears_solar",
			[TearVariant.PUPULA] = "pupula_tears_solar",
			[TearVariant.PUPULA_BLOOD] = "pupula_tears_solar",
			[TearVariant.GODS_FLESH] = "godsflesh_tears_solar",
			[TearVariant.GODS_FLESH_BLOOD] = "godsflesh_tears_solar",
			[TearVariant.GLAUCOMA] = "glaucoma_tears_solar",
			[TearVariant.EYE] = "tears_pop_solar",
			[TearVariant.EYE_BLOOD] = "tears_pop_solar",
			[TearVariant.DIAMOND] = "diamond_tears_solar",
			[TearVariant.LOST_CONTACT] = "lost_contact_tears_solar",
			[TearVariant.HUNGRY] = "tears_hungry_solar",
			[TearVariant.EXPLOSIVO] = "tears_explosivo_solar",
			[TearVariant.BALLOON] = "tears_balloon_solar",
			[TearVariant.BALLOON_BRIMSTONE] = "tears_balloon_brimstone_solar",
			[TearVariant.FIRE_MIND] = "fire_mind_tears_solar",
		}

		if tAndromedaMap[tear.Variant] then
			sprite:ReplaceSpritesheet(0, "gfx/tears/solar/" .. colors[skinColor + 2] .. "/" .. tAndromedaMap[tear.Variant] .. ".png")
		end
	end
	sprite:LoadGraphics()
end

function Functions.ChargeSingularity(player, numCharges)
	if numCharges == 0 then return end
	
	local singularityMax = 12
	local activeSlot
	local curCharge
	local newCharge
	
	for i = 0, 2 do
		if player:GetActiveItem(i) == Enums.Collectibles.SINGULARITY then
			activeSlot = i
		end
	end
	
	if activeSlot == nil then return end

	curCharge = player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot)
	
	if --[[curCharge < singularityMax
	or (player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and]] curCharge < singularityMax * 2
	then
		newCharge = curCharge + numCharges
		
		if --[[player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
		and]] newCharge > singularityMax * 2
		then
			newCharge = singularityMax * 2
		--[[elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
		and newCharge > singularityMax
		then
			newCharge = singularityMax]]
		end
		
		player:SetActiveCharge(newCharge, activeSlot)
		game:GetHUD():FlashChargeBar(player, activeSlot)

		if (curCharge < singularityMax and newCharge >= singularityMax)
		or (curCharge < singularityMax * 2 and curCharge >= singularityMax and newCharge == singularityMax * 2)
		then
			sfx:Play(SoundEffect.SOUND_ITEMRECHARGE)
		else
			sfx:Play(SoundEffect.SOUND_BEEP)
		end
	end
end

function Functions.CheckAbandonedPlanetarium(roomIndex)
	local data = SaveData.PlayerData.Andromeda.GravShift.Treasure
	
	if #data > 0 then
		for i = 1, #data do
			if data[i][1] == roomIndex
			and not data[i][3]
			then
				return false
			end
		end
	end
	return true
end

function Functions.CheckTreasureRoom(roomIndex)
	local data = SaveData.PlayerData.Andromeda.GravShift.Treasure
	
	if #data > 0 then
		for i = 1, #data do
			if data[i][1] == roomIndex then
				return false
			end
		end
	end
	return true
end

function Functions.CheckTreasureTaken(roomIndex)
	local data = SaveData.PlayerData.Andromeda.GravShift.Treasure

	if #data > 0 then
		for i = 1, #data do
			if data[i][1] == roomIndex
			and not data[i][2]
			then
				return false
			end
		end
	end
	return true
end

function Functions.ContainsQuestItem()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
	
	if #items == 0 then return false end
	
	for i = 1, #items do
		if items[i].SubType > 0 then
			local itemConfig = Isaac.GetItemConfig():GetCollectible(items[i].SubType)
			
			if itemConfig.Tags & ItemConfig.TAG_QUEST == ItemConfig.TAG_QUEST then
				return true
			end
		end
	end
	return false
end

function Functions.ConvergingTears(entity, player, convergePos, convergeAngle, dmgDivider, tAndromedaBR)
	local tearVariant = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, 1, nil).TearVariant
	local pos = convergePos + Vector.FromAngle(convergeAngle):Resized(player.TearRange)
	
	if tAndromedaBR then
		pos = pos + Vector(0, -20)
	end
	
	local velocity = -Vector.FromAngle(convergeAngle) * player.TearRange * 0.035
	local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, velocity, player):ToTear()
	
	if entity.Type == EntityType.ENTITY_TEAR then
		newTear:AddTearFlags(entity.TearFlags | TearFlags.TEAR_SPECTRAL)
		tearVariant = entity.Variant
		newTear.CollisionDamage = entity.CollisionDamage / dmgDivider
	else
		newTear:AddTearFlags(player.TearFlags | TearFlags.TEAR_SPECTRAL)
		newTear.CollisionDamage = player.Damage / dmgDivider

		if entity.Type == EntityType.ENTITY_LASER then
			newTear:ClearTearFlags(TearFlags.TEAR_LASERSHOT)
			newTear:AddTearFlags(TearFlags.TEAR_PIERCING)
		end
	end
	
	if tAndromedaBR then
		newTear:ClearTearFlags(TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_ORBIT)
	end

	if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA
	and not player:HasCollectible(CollectibleType.COLLECTIBLE_MY_REFLECTION)
	and not tAndromedaBR
	then
		newTear:ClearTearFlags(TearFlags.TEAR_BOOMERANG)
	end
	
	newTear:ChangeVariant(tearVariant)
	newTear.Scale = 0.5345 * math.sqrt(newTear.CollisionDamage)
	newTear.Color = entity.Color
	newTear.WaitFrames = 0
	newTear:GetData().convergingTear = true
	newTear:GetData().starburstTear = entity:GetData().starburstTear

	if entity:GetData().starburstTear then
		local sprite = newTear:GetSprite()
		sprite:ReplaceSpritesheet(0, "gfx/tears/tears_starburst.png")
		sprite:LoadGraphics()
		newTear:GetData().starburstTear = true
	end
	
	if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
		Functions.ChangeTear(newTear, player)
	elseif player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
		Functions.ChangeTear(newTear, player)
		Functions.AddLightToTear(player, newTear)
	elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("Mastema", false) then
		local variant = {
			[TearVariant.BLUE] = TearVariant.BLOOD,
			[TearVariant.CUPID_BLUE] = TearVariant.CUPID_BLOOD,
			[TearVariant.PUPULA] = TearVariant.PUPULA_BLOOD,
			[TearVariant.GODS_FLESH] = TearVariant.GODS_FLESH_BLOOD,
			[TearVariant.NAIL] = TearVariant.NAIL_BLOOD,
			[TearVariant.GLAUCOMA] = TearVariant.GLAUCOMA_BLOOD,
			[TearVariant.EYE] = TearVariant.EYE_BLOOD,
			[TearVariant.KEY] = TearVariant.KEY_BLOOD,
		}
	
		if variant[newTear.Variant] then
			newTear:ChangeVariant(variant[newTear.Variant])
		end
	end
	
	if newTear:HasTearFlags(TearFlags.TEAR_ORBIT) then
		if entity.Type == EntityType.ENTITY_TEAR then
			newTear.Height = entity.Height
			newTear.FallingSpeed = entity.FallingSpeed / 3
			newTear.FallingAcceleration = entity.FallingAcceleration
		else
			newTear.Height = -30
			newTear.FallingSpeed = -2
			newTear.FallingAcceleration = 0
		end
	end
end

--returns the path to the current mod
function Functions.GetCurrentModPath()
	--use some very hacky trickery to get the path to this mod
	local _, err = pcall(require, "")
	local _, basePathStart = string.find(err, "no file '", 1)
	local _, modPathStart = string.find(err, "no file '", basePathStart)
	local modPathEnd, _ = string.find(err, ".lua'", modPathStart)
	local modPath = string.sub(err, modPathStart+1, modPathEnd-1)
	modPath = string.gsub(modPath, "\\", "/")
	
	if not KnownFilePathsByName[modPath] then
		KnownFilePathsByName[modPath] = true
		table.insert(KnownFilePathsByIndex, 2, modPath)
	end
	
	return modPath
end

--By DeadInfinity
function Functions.GetDimension(roomDesc)
	local level = game:GetLevel()
    local desc = roomDesc or level:GetCurrentRoomDesc()
    local hash = GetPtrHash(desc)
    for dimension = 0, 2 do
        local dimensionDesc = level:GetRoomByIdx(desc.SafeGridIndex, dimension)
        if GetPtrHash(dimensionDesc) == hash then
            return dimension
        end
    end
end

function Functions.GetRandomChest(spawnpos, randNum)
	local variant = PickupVariant.PICKUP_CHEST

	if randNum == 0 then
		variant = PickupVariant.PICKUP_OLDCHEST
	elseif randNum < 5 then
		variant = PickupVariant.PICKUP_ETERNALCHEST
	elseif randNum < 14 then
		variant = PickupVariant.PICKUP_SPIKEDCHEST
	elseif randNum < 26 then
		variant = PickupVariant.PICKUP_REDCHEST
	elseif randNum < 38 then
		variant = PickupVariant.PICKUP_BOMBCHEST
	elseif randNum < 50 then
		variant = PickupVariant.PICKUP_LOCKEDCHEST
	end

	Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, 0, spawnpos, Vector.Zero, nil)
end

function Functions.GetRandomWisp(player, pos, rng)
	local actives = {
		CollectibleType.COLLECTIBLE_ABYSS,
		CollectibleType.COLLECTIBLE_PONY,
		CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK,
		CollectibleType.COLLECTIBLE_BERSERK,
		CollectibleType.COLLECTIBLE_BEST_FRIEND,
		CollectibleType.COLLECTIBLE_BIBLE,
		CollectibleType.COLLECTIBLE_BLACK_HOLE,
		CollectibleType.COLLECTIBLE_BLANK_CARD,
		CollectibleType.COLLECTIBLE_BLOOD_RIGHTS,
		CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
		CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
		CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD,
		CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS,
		CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS,
		CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS,
		CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS,
		CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1,
		CollectibleType.COLLECTIBLE_CLEAR_RUNE,
		CollectibleType.COLLECTIBLE_CONVERTER,
		CollectibleType.COLLECTIBLE_CROOKED_PENNY,
		CollectibleType.COLLECTIBLE_COUPON,
		CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
		CollectibleType.COLLECTIBLE_D1,
		CollectibleType.COLLECTIBLE_D6,
		CollectibleType.COLLECTIBLE_D7,
		CollectibleType.COLLECTIBLE_D8,
		CollectibleType.COLLECTIBLE_D10,
		CollectibleType.COLLECTIBLE_D12,
		CollectibleType.COLLECTIBLE_D20,
		CollectibleType.COLLECTIBLE_DADS_KEY,
		CollectibleType.COLLECTIBLE_DAMOCLES,
		CollectibleType.COLLECTIBLE_DATAMINER,
		CollectibleType.COLLECTIBLE_DECK_OF_CARDS,
		CollectibleType.COLLECTIBLE_DIPLOPIA,
		CollectibleType.COLLECTIBLE_DOCTORS_REMOTE,
		CollectibleType.COLLECTIBLE_DULL_RAZOR,
		CollectibleType.COLLECTIBLE_ERASER,
		CollectibleType.COLLECTIBLE_FLIP,
		CollectibleType.COLLECTIBLE_FLUSH,
		CollectibleType.COLLECTIBLE_FORTUNE_COOKIE,
		CollectibleType.COLLECTIBLE_FREE_LEMONADE,
		CollectibleType.COLLECTIBLE_GAMEKID,
		CollectibleType.COLLECTIBLE_GELLO,
		CollectibleType.COLLECTIBLE_GLASS_CANNON,
		CollectibleType.COLLECTIBLE_GOLDEN_RAZOR,
		CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
		CollectibleType.COLLECTIBLE_GUPPYS_PAW,
		CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS,
		CollectibleType.COLLECTIBLE_HOURGLASS,
		CollectibleType.COLLECTIBLE_IV_BAG,
		CollectibleType.COLLECTIBLE_KAMIKAZE,
		CollectibleType.COLLECTIBLE_KEEPERS_BOX,
		CollectibleType.COLLECTIBLE_KIDNEY_BEAN,
		CollectibleType.COLLECTIBLE_LEMON_MISHAP,
		CollectibleType.COLLECTIBLE_MAGIC_FINGERS,
		CollectibleType.COLLECTIBLE_MAGIC_SKIN,
		CollectibleType.COLLECTIBLE_MAMA_MEGA,
		CollectibleType.COLLECTIBLE_MEAT_CLEAVER,
		CollectibleType.COLLECTIBLE_MEGA_BEAN,
		CollectibleType.COLLECTIBLE_MEGA_BLAST,
		CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS,
		CollectibleType.COLLECTIBLE_MOMS_BRA,
		CollectibleType.COLLECTIBLE_MOMS_PAD,
		CollectibleType.COLLECTIBLE_MOMS_SHOVEL,
		CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
		CollectibleType.COLLECTIBLE_MONSTROS_TOOTH,
		CollectibleType.COLLECTIBLE_MR_ME,
		CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN,
		CollectibleType.COLLECTIBLE_NECRONOMICON,
		CollectibleType.COLLECTIBLE_THE_NAIL,
		CollectibleType.COLLECTIBLE_PAUSE,
		CollectibleType.COLLECTIBLE_PINKING_SHEARS,
		CollectibleType.COLLECTIBLE_PLACEBO,
		CollectibleType.COLLECTIBLE_PLAN_C,
		CollectibleType.COLLECTIBLE_PLUM_FLUTE,
		CollectibleType.COLLECTIBLE_POOP,
		CollectibleType.COLLECTIBLE_PRAYER_CARD,
		CollectibleType.COLLECTIBLE_RAZOR_BLADE,
		CollectibleType.COLLECTIBLE_RED_KEY,
		CollectibleType.COLLECTIBLE_SATANIC_BIBLE,
		CollectibleType.COLLECTIBLE_SCOOPER,
		CollectibleType.COLLECTIBLE_SHARP_KEY,
		CollectibleType.COLLECTIBLE_SMELTER,
		CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP,
		CollectibleType.COLLECTIBLE_SPIDER_BITE,
		CollectibleType.COLLECTIBLE_SPRINKLER,
		CollectibleType.COLLECTIBLE_SULFUR,
		CollectibleType.COLLECTIBLE_TAMMYS_HEAD,
		CollectibleType.COLLECTIBLE_TEAR_DETONATOR,
		CollectibleType.COLLECTIBLE_TELEPATHY_BOOK,
		CollectibleType.COLLECTIBLE_TELEPORT,
		CollectibleType.COLLECTIBLE_TELEPORT_2,
		CollectibleType.COLLECTIBLE_UNDEFINED,
		CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER,
		CollectibleType.COLLECTIBLE_WAVY_CAP,
		CollectibleType.COLLECTIBLE_WHITE_PONY,
		CollectibleType.COLLECTIBLE_WOODEN_NICKEL,
		CollectibleType.COLLECTIBLE_YUCK_HEART,
		CollectibleType.COLLECTIBLE_YUM_HEART,
		Enums.Wisps.NOTCHED_AXE_COAL,
		Enums.Wisps.NOTCHED_AXE_IRON,
		Enums.Wisps.NOTCHED_AXE_DIAMOND,
		Enums.Wisps.NOTCHED_AXE_REDSTONE,
		Enums.Wisps.JAR_OF_FLIES,
		Enums.Wisps.FRIENDLY_BALL_EXPLOSIVE,
		Enums.Wisps.FRIENDLY_BALL_BRIMSTONE,
		Enums.Wisps.DELIRIOUS_MONSTRO,
		Enums.Wisps.DELIRIOUS_DUKE_OF_FLIES,
		Enums.Wisps.DELIRIOUS_LOKI,
		Enums.Wisps.DELIRIOUS_HAUNT,
		Enums.Collectibles.SINGULARITY,
		Enums.Collectibles.EXTINCTION_EVENT,
		Enums.Collectibles.BOOK_OF_COSMOS,
	}

	if MASTEMA then
		table.insert(actives, Isaac.GetItemIdByName("Bloody Harvest"))
		table.insert(actives, Isaac.GetItemIdByName("Raven Beak"))
		table.insert(actives, Isaac.GetItemIdByName("Broken Dice"))
		table.insert(actives, Isaac.GetItemIdByName("Devil's Bargain"))
	end

	local randNum = rng:RandomInt(#actives) + 1
	local wisp = player:AddWisp(actives[randNum], pos, true, false)
	return wisp
end

function Functions.GetPlayerFromSpawnerEntity(entity)
	local player = entity.SpawnerEntity:ToPlayer()

	if entity.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR then
		local familiar = entity.SpawnerEntity:ToFamiliar()
		player = familiar.Player
	end

	return player
end

function Functions.HasBloodTears(player)
	local tearVariant = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, 1, nil).TearVariant

	if tearVariant == TearVariant.BLOOD
	or tearVariant == TearVariant.CUPID_BLOOD
	or tearVariant == TearVariant.PUPULA_BLOOD
	or tearVariant == TearVariant.GODS_FLESH_BLOOD
	or tearVariant == TearVariant.NAIL_BLOOD
	or tearVariant == TearVariant.GLAUCOMA_BLOOD
	or tearVariant == TearVariant.EYE_BLOOD
	or tearVariant == TearVariant.KEY_BLOOD
	or player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_APPLE)
	then
		return true
	end
	return false
end

function Functions.HasFullCompletion(andromeda)
	local marks
	
	if andromeda == Enums.Characters.ANDROMEDA then
		marks = SaveData.UnlockData.Andromeda
	elseif andromeda == Enums.Characters.T_ANDROMEDA then
		marks = SaveData.UnlockData.T_Andromeda
	end
	
	for _, val in pairs(marks) do
		if not val then
			return false
		end
	end
	
	return true
end

function Functions.IsGreedTreasureRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomIdx = level:GetCurrentRoomIndex()

	return game:IsGreedMode() and room:GetType() == RoomType.ROOM_TREASURE and roomIdx == 98
end

function Functions.IsInvulnerableEnemy(npc)
	local blacklist = {
		EntityType.ENTITY_STONEY,
		EntityType.ENTITY_STONEHEAD,
		EntityType.ENTITY_CONSTANT_STONE_SHOOTER,
		EntityType.ENTITY_BROKEN_GAPING_MAW,
		EntityType.ENTITY_DEATHS_HEAD,
		EntityType.ENTITY_DUSTY_DEATHS_HEAD,
		EntityType.ENTITY_POKY,
		EntityType.ENTITY_WALL_HUGGER,
		EntityType.ENTITY_GRUDGE,
		EntityType.ENTITY_FROZEN_ENEMY,
	}
	
	for i = 1, #blacklist do
		if npc.Type == blacklist[i] then
			return true
		end
	end
	return false
end

function Functions.IsKeeper(player)
	return player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
end

function Functions.IsSoulHeartCharacter(player)
	local chars = {
		PlayerType.PLAYER_BLUEBABY,
		PlayerType.PLAYER_BLUEBABY_B,
		PlayerType.PLAYER_BLACKJUDAS,
		PlayerType.PLAYER_JUDAS_B,
		PlayerType.PLAYER_THESOUL,
		PlayerType.PLAYER_BETHANY_B,
		PlayerType.PLAYER_THEFORGOTTEN_B,
		PlayerType.PLAYER_THESOUL_B,
	}

	for i = 1, #chars do
		if player:GetPlayerType() == chars[i] then
			return true
		end
	end
	
	return false
end

function Functions.PlayVoiceline(voiceline, flag, randNum)
	if flag & UseFlag.USE_MIMIC == UseFlag.USE_MIMIC then return end

	if Options.AnnouncerVoiceMode == 2
	or (Options.AnnouncerVoiceMode == 0 and randNum == 0)
	then
		sfx:Play(voiceline)
	end
end

function Functions.RemoveAllCollectibles()
	local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)

	if #items == 0 then return end
	
	for i = 1, #items do
		if items[i].SubType > 0
		and items[i]:GetData().dontRemove == nil
		then
			local itemConfig = Isaac.GetItemConfig():GetCollectible(items[i].SubType)
			
			if itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
				items[i]:Remove()
			end
		end
	end
end

function Functions.SetAbandonedPlanetarium(player, setDoor)
	local room = game:GetRoom()
	local level = game:GetLevel()
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WOMB_TELEPORT, 0, Vector(-20, 60), Vector.Zero, nil) --We do a little hacking
	local sprite = effect:GetSprite()

	game:ShowHallucination(0, BackdropType.DUNGEON_GIDEON)
	sfx:Stop(SoundEffect.SOUND_DEATH_CARD)

	if room:GetRoomShape() == RoomShape.ROOMSHAPE_IH then
		sprite:Load("gfx/backdrop/abandonedplanetarium_ih.anm2", true)
		sprite:ReplaceSpritesheet(0, "gfx/backdrop/abandonedplanetarium_ih.png")
	elseif room:GetRoomShape() == RoomShape.ROOMSHAPE_IV then
		sprite:Load("gfx/backdrop/abandonedplanetarium_iv.anm2", true)
		sprite:ReplaceSpritesheet(0, "gfx/backdrop/abandonedplanetarium_iv.png")
	else
		sprite:Load("gfx/backdrop/abandonedplanetarium.anm2", true)
		sprite:ReplaceSpritesheet(0, "gfx/backdrop/abandonedplanetarium.png")
	end

	sprite:Play("Idle")

	if setDoor then
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			
			if door
			and door.TargetRoomType ~= RoomType.ROOM_SECRET
			and door.TargetRoomType ~= RoomType.ROOM_SUPERSECRET
			then
				local doorSprite = door:GetSprite()
				local currentAnim = doorSprite:GetAnimation()
				local png = "gfx/grid/andromeda_abandonedplanetariumdoor_in.png"

				if door.TargetRoomType == RoomType.ROOM_DICE then
					local roomIndex = door.TargetRoomIndex
					local roomDesc = level:GetRoomByIdx(roomIndex, 0)
					local roomConfig = roomDesc.Data

					if roomConfig.Variant >= 4242
					and roomConfig.Variant < 4900
					then
						png = "gfx/grid/andromeda_abandonedplanetariumdoor_out.png"
					end

					for i = 0, 4 do
						doorSprite:ReplaceSpritesheet(i, png)
					end
					
					doorSprite:LoadGraphics()
				else
					doorSprite:Load("gfx/grid/andromeda_abplanetariumdoor.anm2", true)
					doorSprite:Play(currentAnim)
				end

				--Fix for the room infinitely looping when using joker or similar cards
				if door.TargetRoomIndex == GridRooms.ROOM_DEBUG_IDX then
					local startRoomIndex = level:GetStartingRoomIndex()
					game:StartRoomTransition(startRoomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.FADE, player)
				end
			end
		end
	end
end

function Functions.SetTreasureRoom(roomIndex, setParam)
	if #SaveData.PlayerData.Andromeda.GravShift.Treasure > 0 then
		for i = 1, #SaveData.PlayerData.Andromeda.GravShift.Treasure do
			if SaveData.PlayerData.Andromeda.GravShift.Treasure[i][1] == roomIndex then
				if setParam == "treasure taken" then
					SaveData.PlayerData.Andromeda.GravShift.Treasure[i][2] = true
				elseif setParam == "abandoned planetarium" then
					SaveData.PlayerData.Andromeda.GravShift.Treasure[i][3] = true
				end
			end
		end
	end
end

function Functions.SpawnMeteor(player, rng)
	local room = game:GetRoom()
	local randNum = rng:RandomInt(4) + rng:RandomFloat()
	local meteor = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, room:GetRandomPosition(0), RandomVector() * randNum, player):ToTear()
	local sprite = meteor:GetSprite()
	local randFloat = rng:RandomFloat() + rng:RandomFloat()
	local easterEggChance = 0.05
	
	meteor:GetData().isMeteor = true
	meteor:AddTearFlags(TearFlags.TEAR_BURN | TearFlags.TEAR_SPECTRAL)
	meteor:ChangeVariant(TearVariant.ROCK)
	meteor.CollisionDamage = player.Damage * randFloat
	meteor.Scale = 0.5345 * math.sqrt(meteor.CollisionDamage)
	meteor.Height = -1000
	meteor.FallingSpeed = 100
	meteor.FallingAcceleration = 1
	meteor.SpawnerEntity = player

	if player:HasCollectible(Isaac.GetItemIdByName("Emoji Glasses")) then
		easterEggChance = 0.75
	end

	if rng:RandomFloat() < easterEggChance then
		sprite:ReplaceSpritesheet(0, "gfx/tears/meteorite_rocks2.png")
	else
		sprite:ReplaceSpritesheet(0, "gfx/tears/meteorite_rocks.png")
	end
	
	sprite:LoadGraphics()
end

function Functions.StarBurst(player, pos)
	local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)
	local numStars = rng:RandomInt(7) + 5
	local LAST_FRAME = 26
	local colors = {
		"red",
		"lightred",
		"orange",
		"yellow",
		"blue",
		"white",
	}

	for i = 1, numStars do
		local velocity = RandomVector() * rng:RandomFloat() * (rng:RandomInt(15) + 1)
		local starTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, velocity, player):ToTear()
		local sprite = starTear:GetSprite()
		local randNum = rng:RandomInt(#colors) + 1

		sprite:Load("gfx/tears/tears_spode_" .. colors[randNum] .. ".anm2", true)
		randNum = rng:RandomInt(LAST_FRAME) + 1
			
		for i = 1, randNum do
			sprite:Update()
		end

		randNum = rng:RandomInt(30)  * rng:RandomFloat()
		starTear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_DECELERATE)
		starTear.CollisionDamage = (player.Damage / 2) * rng:RandomFloat()

		if starTear.CollisionDamage < (player.Damage / 10) then
			starTear.CollisionDamage = player.Damage / 10
		end

		starTear.Scale = 0.5345 * math.sqrt(starTear.CollisionDamage)
		starTear.FallingSpeed = starTear.FallingSpeed - randNum
		starTear:GetData().isSpodeTear = true
	end

	sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.7, 2, false, 1.7)
end

function Functions.TearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.9999)
end

return Functions
