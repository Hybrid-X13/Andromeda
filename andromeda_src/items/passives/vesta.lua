local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local vestaCounter = 0

local familiarSpriteMap = {
	[Enums.Characters.ANDROMEDA] = "andromeda",
	[PlayerType.PLAYER_BETHANY] = "bethany",
	[PlayerType.PLAYER_BETHANY_B] = "bethanyb",
	[PlayerType.PLAYER_BLACKJUDAS] = "shadow",
	[PlayerType.PLAYER_JUDAS_B] = "shadow",
	[PlayerType.PLAYER_THELOST] = "lost",
	[PlayerType.PLAYER_THELOST_B] = "lostb",
}

local flameSpriteMap = {
	[PlayerType.PLAYER_BETHANY] = "virtuewisp",
	[PlayerType.PLAYER_BETHANY_B] = "lemegetonwisp",
	[PlayerType.PLAYER_BLACKJUDAS] = "shadowflame",
	[PlayerType.PLAYER_JUDAS_B] = "shadowflame",
	[PlayerType.PLAYER_THELOST] = "ghostflame",
	[PlayerType.PLAYER_THELOST_B] = "atticghostflame",
}

local andromedaBMap = {
	[SkinColor.SKIN_PINK] = "default",
	[SkinColor.SKIN_WHITE] = "white",
	[SkinColor.SKIN_BLACK] = "black",
	[SkinColor.SKIN_BLUE] = "blue",
	[SkinColor.SKIN_RED] = "red",
	[SkinColor.SKIN_GREEN] = "green",
	[SkinColor.SKIN_GREY] = "grey",
}

local Item = {}

--Adjusts the familiar's color to match T Andromeda's current color
local function ChangeFamiliarColor(player, familiar, sprite)
	local skinColor = player:GetHeadColor()

	if familiar:GetData().vestaColor ~= "blood"
	and Functions.HasBloodTears(player)
	then
		sprite:Load("gfx/vesta_andromedab_blood.anm2", true)
		familiar:GetData().vestaColor = "blood"
	elseif not Functions.HasBloodTears(player) then
		if skinColor == SkinColor.SKIN_PINK
		and familiar:GetData().vestaColor ~= "default"
		then
			sprite:Load("gfx/vesta_andromedab.anm2", true)
		elseif andromedaBMap[skinColor]
		and familiar:GetData().vestaColor ~= andromedaBMap[skinColor]
		then
			sprite:Load("gfx/vesta_andromedab_" .. andromedaBMap[skinColor] .. ".anm2", true)
		end
		familiar:GetData().vestaColor = andromedaBMap[skinColor]
	end
end

function Item.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.VESTA_FLAME then return end
		
	local player = familiar.Player
	local playerType = player:GetPlayerType()
	local sprite = familiar:GetSprite()
	
	familiar:AddToFollowers()

	if playerType == Enums.Characters.T_ANDROMEDA then
		ChangeFamiliarColor(player, familiar, sprite)
	elseif playerType == Isaac.GetPlayerTypeByName("MastemaB", true) then
		sprite:Load("gfx/vesta_mastemab.anm2", true)
	elseif familiarSpriteMap[playerType] then
		sprite:Load("gfx/vesta_" .. familiarSpriteMap[playerType] .. ".anm2", true)
	end
	sprite:Play("Float")
end

function Item.familiarUpdate(familiar)
	if familiar.Variant ~= Enums.Familiars.VESTA_FLAME then return end
		
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	
	familiar:FollowParent()

	if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
		ChangeFamiliarColor(player, familiar, sprite)
		sprite:Play("Float")
	end
end

function Item.postEffectInit(effect)
	if effect.Variant ~= EffectVariant.FIRE_JET then return end
	
	local sprite = effect:GetSprite()
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		
		if not player:HasCollectible(Enums.Collectibles.VESTA) then return end

		if player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
			local skinColor = player:GetHeadColor()
			local colors = {
				"bugnanga",
				"white",
				"blackberry",
				"blueberry",
				"strawberry",
				"grass",
				"grey",
			}
			
			if Functions.HasBloodTears(player) then
				sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_shadowflame.png")
			elseif not Functions.HasBloodTears(player) then
				sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_" .. colors[skinColor + 2] .. ".png")
			end
		elseif flameSpriteMap[playerType] then
			sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_" .. flameSpriteMap[playerType] .. ".png")
		end
		sprite:LoadGraphics()
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.VESTA) then
		player:CheckFamiliar(Enums.Familiars.VESTA_FLAME, 0, player:GetCollectibleRNG(Enums.Collectibles.VESTA), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.VESTA))
	end
	
	if player:HasCollectible(Enums.Collectibles.VESTA) then
		local numEnemies = Isaac.CountEnemies()
		local frequency
		local divisor
		
		player:CheckFamiliar(Enums.Familiars.VESTA_FLAME, 1, player:GetCollectibleRNG(Enums.Collectibles.VESTA), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.VESTA))
		
		if numEnemies < 1 then
			divisor = 1
		else
			divisor = numEnemies
		end
		frequency = math.ceil(300 / divisor)
		
		--Cap the frequency of the flames spawning
		if frequency < 15 then
			frequency = 15
		end
		
		--Prevents vestaCounter from going over the frequency when more enemies are spawned
		if vestaCounter > frequency then
			vestaCounter = frequency
		else
			vestaCounter = vestaCounter + 1
		end
		
		if vestaCounter == frequency then
			for i = 0, 3 do
				local effect
				
				if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
					effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 1, player.Position, Vector.Zero, player)

					local sprite = effect:GetSprite()
					local color = Color(0.464, 0.996, 1, 1, 0, 0, 0)
					color:SetColorize(4, 10, 14, 0.5)
					sprite.Color = color
				elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("MastemaB", true) then
					effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 1, player.Position, Vector.Zero, player)
				else
					effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0, player.Position, Vector.Zero, player)
				end
				
				local fire = effect:ToEffect()
				fire:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				fire.Rotation = 90 * i
				local velocity
				
				if i == 0 then
					velocity = Vector(15, 0)
				elseif i == 1 then
					velocity = Vector(0, 15)
				elseif i == 2 then
					velocity = Vector(-15, 0)
				elseif i == 3 then
					velocity = Vector(0, -15)
				end
				
				--Can't change flame damage, so shoot invisible tears as a workaround
				local spawnTear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, velocity, nil)
				local newTear = spawnTear:ToTear()
				newTear.Color = Color(0, 0, 0, 0, 0, 0, 0)
				newTear:AddTearFlags(TearFlags.TEAR_PIERCING)
				newTear.CollisionDamage = player.Damage
				newTear:GetData().vestaTear = true
			end
			vestaCounter = 0
		end
	end
end

function Item.preTearCollision(tear, collider, low)
	if tear:GetData().vestaTear
	and collider.Type == EntityType.ENTITY_BOMBDROP
	then
		return true
	end
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	if target.Type == EntityType.ENTITY_PLAYER
	and flag & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE
	then
		return false
	else
		local enemy = target:ToNPC()
		
		if enemy == nil then return end
		if source.Type ~= EntityType.ENTITY_EFFECT then return end
		if source.Variant ~= EffectVariant.FIRE_JET then return end

		local spawner = source.Entity.SpawnerEntity

		if spawner == nil then return end

		local player = spawner:ToPlayer()

		if player == nil then return end
		if not player:HasCollectible(Enums.Collectibles.VESTA) then return end

		target:AddBurn(EntityRef(player), 60, player.Damage)
	end
end

return Item