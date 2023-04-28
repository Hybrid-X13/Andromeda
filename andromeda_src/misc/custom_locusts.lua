local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()
local initSeeds = {}

local LocustState = {
	IDLE = 0,
	CHARGING = -1,
}

local colors = {
	"Red",
	"Orange",
	"Yellow",
	"Blue",
	"White",
	"Purple",
	"Green",
}

local colorVals = {
	Color(1, 0, 0, 1, 0, 0, 0),
	Color(1, 0.33, 0, 1, 0, 0, 0),
	Color(1, 1, 0, 1, 0, 0, 0),
	Color(0, 0, 1, 1, 0, 0, 0),
	Color(1, 1, 1, 1, 0, 0, 0),
	Color(1, 0, 1, 1, 0, 0, 0),
	Color(0, 1, 0, 1, 0, 0, 0),
}

local Locust = {}

local function ApplyStatus(familiar, enemy)
	local data = familiar:GetData().celestialCrownColor
	local player = familiar.Player

	if data == "Red"
	and not enemy:HasEntityFlags(EntityFlag.FLAG_FREEZE)
	then
		enemy:AddFreeze(EntityRef(familiar), 60)
	elseif data == "Orange"
	and not enemy:HasEntityFlags(EntityFlag.FLAG_BURN)
	then
		enemy:AddBurn(EntityRef(familiar), player.Damage, 60)
	elseif data == "Yellow"
	and not enemy:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
	then
		enemy:AddConfusion(EntityRef(familiar), 90, false)
	elseif data == "Blue" then
		enemy:AddEntityFlags(EntityFlag.FLAG_ICE)
	elseif data == "White"
	and not enemy:HasEntityFlags(EntityFlag.FLAG_SLOW)
	then
		enemy:AddSlowing(EntityRef(familiar), 75, 0.5, Color(1, 1, 1, 1, 0.196, 0.196, 0.196))
	elseif data == "Purple"
	and not enemy:HasEntityFlags(EntityFlag.FLAG_FEAR)
	then
		enemy:AddFear(EntityRef(familiar), 60)
	elseif data == "Green"
	and not enemy:HasEntityFlags(EntityFlag.FLAG_POISON)
	then
		enemy:AddPoison(EntityRef(familiar), 90, player.Damage)
	end
end

local function IsBlacklistedEnemy(npc)
	local blacklist = {
		EntityType.ENTITY_BISHOP,
		EntityType.ENTITY_SHOPKEEPER,
		EntityType.ENTITY_SHADY,
		EntityType.ENTITY_BEAST,
		EntityType.ENTITY_EVIS,
	}
	
	for i = 1, #blacklist do
		if npc.Type == blacklist[i]
		or (npc.Type == EntityType.ENTITY_MOLE and npc.Variant == 1)
		then
			return true
		end
	end
	return false
end

local function ShouldTriggerOnDeathEffect(npc)
	for i = 1, #initSeeds do
		if npc.InitSeed == initSeeds[i] then
			table.remove(initSeeds, i)

			return true
		end
	end

	return false
end

function Locust.familiarInit(familiar)
	if familiar.Variant ~= FamiliarVariant.ABYSS_LOCUST then return end
	if familiar.SubType ~= Enums.Collectibles.CELESTIAL_CROWN then return end
	
	local room = game:GetRoom()
	rng:SetSeed(room:GetDecorationSeed() + familiar.InitSeed, 35)

	local randNum = rng:RandomInt(#colors) + 1
	familiar.Color = colorVals[randNum]
	familiar:GetData().celestialCrownColor = colors[randNum]
end

function Locust.familiarUpdate(familiar)
	if familiar.Variant ~= FamiliarVariant.ABYSS_LOCUST then return end

	local room = game:GetRoom()
	local sprite = familiar:GetSprite()

	if familiar.SubType == Enums.Collectibles.GRAVITY_SHIFT
	and familiar.State == LocustState.CHARGING
	then
		local projectiles = Isaac.FindInRadius(familiar.Position, 13, EntityPartition.BULLET)

		if #projectiles == 0 then return end

		for _, projectile in pairs(projectiles) do
			local projectile = projectile:ToProjectile()
			local projectileSprite = projectile:GetSprite()

			projectile.Velocity = Vector.Zero
			projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
			projectileSprite:ReplaceSpritesheet(0, "gfx/tears/cosmic/tears_cosmic.png")
			projectileSprite:LoadGraphics()
		end
	elseif familiar.SubType == Enums.Collectibles.CELESTIAL_CROWN then
		if room:GetFrameCount() == 1 then
			rng:SetSeed(room:GetDecorationSeed() + familiar.InitSeed, 35)
			local randNum = rng:RandomInt(#colors) + 1
			familiar.Color = colorVals[randNum]
			familiar:GetData().celestialCrownColor = colors[randNum]
		end
		
		if familiar.State == LocustState.CHARGING then
			local enemies = Isaac.FindInRadius(familiar.Position, 13, EntityPartition.ENEMY)

			if #enemies == 0 then return end

			for _, enemy in pairs(enemies) do
				local enemy = enemy:ToNPC()

				if not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
				and enemy:IsActiveEnemy()
				and enemy:IsVulnerableEnemy()
				then
					ApplyStatus(familiar, enemy)
				end
			end
		end
	elseif familiar.SubType == Enums.Collectibles.BABY_PLUTO then
		familiar.SpriteScale = Vector(0.5, 0.5)
	end
end

function Locust.entityTakeDmg(target, amount, flags, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not enemy:IsActiveEnemy() then return end
	if source.Entity == nil then return end
	if source.Entity.Type ~= EntityType.ENTITY_FAMILIAR then return end
	if source.Variant ~= FamiliarVariant.ABYSS_LOCUST then return end

	local familiar = source.Entity:ToFamiliar()
	local player = familiar.Player
	local locust = source.Entity.SubType

	if locust == Enums.Collectibles.STARBURST then
		local rng = player:GetCollectibleRNG(Enums.Collectibles.STARBURST)

		if rng:RandomFloat() < 0.1 then
			Functions.StarBurst(player, enemy.Position)
		end
	elseif locust == Enums.Collectibles.JUNO
	and (enemy.HitPoints - amount) <= 0
	then
		table.insert(initSeeds, enemy.InitSeed)
	end
end

function Locust.postNPCDeath(npc)
	if npc:IsBoss() then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if Functions.IsInvulnerableEnemy(npc) then return end
	if IsBlacklistedEnemy(npc) then return end
	if not ShouldTriggerOnDeathEffect(npc) then return end

	local locusts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, Enums.Collectibles.JUNO)

	if #locusts == 0 then return end
	
	local familiar = locusts[1]:ToFamiliar()
	local player = familiar.Player
	rng:SetSeed(npc.InitSeed, 35)
			
	if rng:RandomFloat() < 0.2 then
		local revivedEnemy = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, Vector.Zero, player)
		revivedEnemy:AddCharmed(EntityRef(player), -1)
		
		if npc:IsChampion() then
			local champColor = npc:GetChampionColorIdx()
			revivedEnemy:ToNPC():MakeChampion(npc.InitSeed, champColor)
		end
		
		revivedEnemy:SetColor(Color(1, 1, 1, 0.4, 0.2, 0, 0.2), 99999, 1, false, false)
		revivedEnemy:GetData().junoFriendly = true
	end
end

return Locust