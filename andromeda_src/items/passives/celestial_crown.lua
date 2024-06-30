local Enums = require("andromeda_src.enums")
local game = Game()
local rng = RNG()

local starColors = {
	"IdleRed",
	"IdleOrange",
	"IdleYellow",
	"IdleWhite",
	"IdleGreen",
	"IdleBlue",
	"IdlePurple",
}

local StarEffects = {
	["IdleRed"] = {
		Flag = {
			TearFlags.TEAR_BAIT,
			TearFlags.TEAR_BURSTSPLIT,
			TearFlags.TEAR_FREEZE,
		},
		Variant = {
			Color(0.7, 0.14, 0.1, 1, 0.3, 0, 0),
			TearVariant.BLOOD,
			Color(1.25, 0.05, 0.15, 1, 0, 0, 0),
		},
	},
	["IdleOrange"] = {
		Flag = {
			TearFlags.TEAR_BURN,
			TearFlags.TEAR_PUNCH,
			TearFlags.TEAR_SPLIT,
		},
		Variant = {
			TearVariant.FIRE_MIND,
			TearVariant.FIST,
			Color(0.9, 0.3, 0.08, 1, 0, 0, 0),
		},
	},
	["IdleYellow"] = {
		Flag = {
			TearFlags.TEAR_GREED_COIN,
			TearFlags.TEAR_ACID,
			TearFlags.TEAR_CONFUSION,
		},
		Variant = {
			TearVariant.COIN,
			Color(1, 1, 0.1, 1, 0, 0, 0),
			Color(1, 1, 0, 1, 0.17, 0.05, 0),
		},
	},
	["IdleWhite"] = {
		Flag = {
			TearFlags.TEAR_SPECTRAL,
			TearFlags.TEAR_SLOW,
			TearFlags.TEAR_BOUNCE,
		},
		Variant = {
			Color(1.5, 2, 2, 0.5, 0, 0, 0),
			Color(2, 2, 2, 1, 0.196, 0.196, 0.196),
			Color(1, 1, 0.8, 1, 0.1, 0.1, 0.1),
		},
	},
	["IdleGreen"] = {
		Flag = {
			TearFlags.TEAR_POISON,
			TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
			TearFlags.TEAR_BOOGER,
		},
		Variant = {
			Color(0.4, 0.97, 0.5, 1, 0, 0, 0),
			Color(1, 1, 1, 1, 0, 0.2, 0),
			TearVariant.BOOGER,
		},
	},
	["IdleBlue"] = {
		Flag = {
			TearFlags.TEAR_ICE,
			TearFlags.TEAR_GODS_FLESH,
			TearFlags.TEAR_JACOBS,
		},
		Variant = {
			TearVariant.ICE,
			TearVariant.GODS_FLESH,
		},
	},
	["IdlePurple"] = {
		Flag = {
			TearFlags.TEAR_HOMING,
			TearFlags.TEAR_FEAR,
			TearFlags.TEAR_CHARM,
		},
		Variant = {
			Color(1, 0, 1, 1, 0, 0, 0),
			{TearVariant.BLOOD, Color(0.4, 0.4, 0.4, 1, 0, 0, 0)},
			Color(1, 0, 1, 1, 0.196, 0, 0),
		},
	},
}

local Item = {}

local function AddEffect(familiar, entity, rng)
	if not entity then return end
	if entity:GetData().addedEffect then return end
	if not entity.Visible then return end

	local sprite = familiar:GetSprite()
	local curAnim = sprite:GetAnimation()
	local randNum = rng:RandomInt(3) + 1
	
	entity:AddTearFlags(StarEffects[curAnim].Flag[randNum])

	if StarEffects[curAnim].Variant[randNum] then
		local varType = type(StarEffects[curAnim].Variant[randNum])

		if entity.Type == EntityType.ENTITY_TEAR then
			if varType == "table" then
				if entity.Variant ~= StarEffects[curAnim].Variant[randNum][1]
				and entity:GetData().isSpodeTear == nil
				then
					entity:ChangeVariant(StarEffects[curAnim].Variant[randNum][1])
				end
				entity.Color = StarEffects[curAnim].Variant[randNum][2]
			elseif varType == "number" then
				if entity.Variant ~= StarEffects[curAnim].Variant[randNum]
				and entity:GetData().isSpodeTear == nil
				then
					entity:ChangeVariant(StarEffects[curAnim].Variant[randNum])
				end
			else
				entity.Color = StarEffects[curAnim].Variant[randNum]
			end
		else
			if varType == "table" then
				entity.Color = StarEffects[curAnim].Variant[randNum][2]
			elseif varType ~= "number" then
				entity.Color = StarEffects[curAnim].Variant[randNum]
			end
		end
	end

	entity:GetData().addedEffect = true
end

function Item.evaluateCache(player, cacheFlag)
	if cacheFlag ~= CacheFlag.CACHE_FAMILIARS then return end
	
	local numStars = player:GetCollectibleNum(Enums.Collectibles.CELESTIAL_CROWN) + player:GetEffects():GetCollectibleEffectNum(Enums.Collectibles.CELESTIAL_CROWN)
	player:CheckFamiliar(Enums.Familiars.CELESTIAL_CROWN_STAR, numStars * 4, player:GetCollectibleRNG(Enums.Collectibles.CELESTIAL_CROWN), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.CELESTIAL_CROWN))
end

function Item.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.CELESTIAL_CROWN_STAR then return end
	
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local rng = player:GetCollectibleRNG(Enums.Collectibles.CELESTIAL_CROWN)
	rng:SetSeed(game:GetRoom():GetDecorationSeed() + familiar.InitSeed, 35)
	local randNum = rng:RandomInt(#starColors) + 1
	
	familiar:AddToOrbit(3)
	familiar.OrbitLayer = 7545
	sprite:Play(starColors[randNum])
end

function Item.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.CELESTIAL_CROWN_STAR then return end
		
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	local room = game:GetRoom()
	local radius = 20

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		radius = 25
	end

	local tears = Isaac.FindInRadius(familiar.Position, radius, EntityPartition.TEAR)
	local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
	local lasers = Isaac.FindByType(EntityType.ENTITY_LASER)
	local rng = player:GetCollectibleRNG(Enums.Collectibles.CELESTIAL_CROWN)
	local randNum
	
	familiar.Velocity = familiar:GetOrbitPosition(player.Position + player.Velocity) - familiar.Position
	familiar.OrbitDistance = Vector(80, 80)
	familiar.OrbitSpeed = 0.02
	familiar.OrbitLayer = 7545
	familiar.DepthOffset = -1
	
	if room:GetFrameCount() == 1 then
		rng:SetSeed(room:GetDecorationSeed() + familiar.InitSeed, 35)
		randNum = rng:RandomInt(#starColors) + 1
		sprite:Play(starColors[randNum])
	end
	
	for _, tear in ipairs(tears) do
		local tear = tear:ToTear()

		AddEffect(familiar, tear, rng)
	end

	for _, bomb in ipairs(bombs) do
		local bomb = bomb:ToBomb()

		if bomb.IsFetus
		and bomb.Position:Distance(familiar.Position) < radius
		then
			AddEffect(familiar, bomb, rng)
		end
	end

	for _, laser in ipairs(lasers) do
		local laser = laser:ToLaser()

		if laser.SpawnerType
		and laser.SpawnerType == EntityType.ENTITY_PLAYER
		and laser.Position:Distance(familiar.Position) < radius
		then
			AddEffect(familiar, laser, rng)
		end
	end
end

return Item
