local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local vestaCounter = 0

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
		if familiar:GetData().vestaColor ~= "white"
		and skinColor == SkinColor.SKIN_WHITE
		then
			sprite:Load("gfx/vesta_andromedab_white.anm2", true)
			familiar:GetData().vestaColor = "white"
		elseif familiar:GetData().vestaColor ~= "black"
		and skinColor == SkinColor.SKIN_BLACK
		then
			sprite:Load("gfx/vesta_andromedab_black.anm2", true)
			familiar:GetData().vestaColor = "black"
		elseif familiar:GetData().vestaColor ~= "blue"
		and skinColor == SkinColor.SKIN_BLUE
		then
			sprite:Load("gfx/vesta_andromedab_blue.anm2", true)
			familiar:GetData().vestaColor = "blue"
		elseif familiar:GetData().vestaColor ~= "red"
		and skinColor == SkinColor.SKIN_RED
		then
			sprite:Load("gfx/vesta_andromedab_red.anm2", true)
			familiar:GetData().vestaColor = "red"
		elseif familiar:GetData().vestaColor ~= "green"
		and skinColor == SkinColor.SKIN_GREEN
		then
			sprite:Load("gfx/vesta_andromedab_green.anm2", true)
			familiar:GetData().vestaColor = "green"
		elseif familiar:GetData().vestaColor ~= "grey"
		and skinColor == SkinColor.SKIN_GREY
		then
			sprite:Load("gfx/vesta_andromedab_grey.anm2", true)
			familiar:GetData().vestaColor = "grey"
		elseif familiar:GetData().vestaColor ~= "default"
		and skinColor == SkinColor.SKIN_PINK
		then
			sprite:Load("gfx/vesta_andromedab.anm2", true)
			familiar:GetData().vestaColor = "default"
		end
	end
end

function Item.familiarInit(familiar)
	if familiar.Variant ~= Enums.Familiars.VESTA_FLAME then return end
		
	local player = familiar.Player
	local sprite = familiar:GetSprite()
	
	familiar:AddToFollowers()
	
	if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
		sprite:Load("gfx/vesta_andromeda.anm2", true)
	elseif player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
		ChangeFamiliarColor(player, familiar, sprite)
	elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("MastemaB", true) then
		sprite:Load("gfx/vesta_mastemab.anm2", true)
	elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY then
		sprite:Load("gfx/vesta_bethany.anm2", true)
	elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
		sprite:Load("gfx/vesta_bethanyb.anm2", true)
	elseif player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS
	or player:GetPlayerType() == PlayerType.PLAYER_JUDAS_B
	then
		sprite:Load("gfx/vesta_shadow.anm2", true)
	elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST then
		sprite:Load("gfx/vesta_lost.anm2", true)
	elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
		sprite:Load("gfx/vesta_lostb.anm2", true)
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
			else
				sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_" .. colors[skinColor + 2] .. ".png")
			end
		elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY then
			sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_virtuewisp.png")
		elseif player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B then
			sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_lemegetonwisp.png")
		elseif player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS
		or player:GetPlayerType() == PlayerType.PLAYER_JUDAS_B
		then
			sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_shadowflame.png")
		elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST then
			sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_ghostflame.png")
		elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
			sprite:ReplaceSpritesheet(0, "gfx/effects/fire_jet_atticghostflame.png")
		end
		sprite:LoadGraphics()
	end
end

function Item.postPEffectUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.VESTA) then
		player:CheckFamiliar(Enums.Familiars.VESTA_FLAME, 0, player:GetCollectibleRNG(Enums.Collectibles.VESTA), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.VESTA))
	end
	
	if player:HasCollectible(Enums.Collectibles.VESTA) then
		local enemies = {}
		local frequency
		local divisor
		
		player:CheckFamiliar(Enums.Familiars.VESTA_FLAME, 1, player:GetCollectibleRNG(Enums.Collectibles.VESTA), Isaac.GetItemConfig():GetCollectible(Enums.Collectibles.VESTA))
		
		for i, entity in pairs(Isaac.GetRoomEntities()) do
			if not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			and entity:IsActiveEnemy()
			and entity:IsVulnerableEnemy()
			then
				table.insert(enemies, entity)
			end
		end
		
		if #enemies < 1 then
			divisor = 1
		else
			divisor = #enemies
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
			-- Fix the flames breaking holy mantle shields
			if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
				player:SetMinDamageCooldown(60)
				player:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
			end
			
			for i = 0, 3 do
				local effect
				
				if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
					local color = Color(0.464, 0.996, 1, 1, 0, 0, 0)
					effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 1, player.Position, Vector.Zero, player)
					local sprite = effect:GetSprite()
					color:SetColorize(4, 10, 14, 0.5)
					sprite.Color = color
				elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("MastemaB", true) then
					effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 1, player.Position, Vector.Zero, player)
				else
					effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0, player.Position, Vector.Zero, player)
				end
				
				local fire = effect:ToEffect()
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
	if (target.Type == EntityType.ENTITY_PLAYER or target.Type == EntityType.ENTITY_FAMILIAR)
	and Functions.AnyPlayerHasCollectible(Enums.Collectibles.VESTA)
	and flag & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE
	then
		return false
	else
		local enemy = target:ToNPC()
		
		if enemy == nil then return end
		
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			
			if player:HasCollectible(Enums.Collectibles.VESTA)
			and source.Type == EntityType.ENTITY_EFFECT
			and source.Variant == EffectVariant.FIRE_JET
			then
				target:AddBurn(EntityRef(player), 60, player.Damage)
			end
		end
	end
end

return Item