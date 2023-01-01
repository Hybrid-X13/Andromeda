local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()
local initSeeds = {}

local Item = {}

local function IsBlacklistedEnemy(npc)
	local blacklist = {
		EntityType.ENTITY_BISHOP,
		EntityType.ENTITY_SHOPKEEPER,
		EntityType.ENTITY_SHADY,
		EntityType.ENTITY_BEAST,
		EntityType.ENTITY_EVIS,
	}
	
	for i = 1, #blacklist do
		if npc.Type == blacklist[i] then
			return true
		end
	end
	return false
end

local function CanBeRevived(npc)
	for i = 1, #initSeeds do
		if npc.InitSeed == initSeeds[i] then
			table.remove(initSeeds, i)

			return true
		end
	end

	return false
end

function Item.postNewRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)

		if not player:HasCollectible(Enums.Collectibles.JUNO) then return end
		if player:HasCurseMistEffect() then return end
		if player:IsCoopGhost() then return end
	
		local tempEffects = player:GetEffects()
	
		if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) then
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW, false, 1)
		end
	end
end

function Item.entityTakeDmg(target, amount, flag, source, countdown)
	local enemy = target:ToNPC()
	
	if enemy == nil then return end
	if not Functions.AnyPlayerHasCollectible(Enums.Collectibles.JUNO) then return end
		
	local health = enemy.HitPoints - amount
	local data

	if source.Entity then
		if (source.Type == EntityType.ENTITY_PROJECTILE or source.Type == EntityType.ENTITY_LASER)
		and source.Entity.SpawnerEntity
		then
			data = source.Entity.SpawnerEntity:GetData().junoFriendly
		else
			data = source.Entity:GetData().junoFriendly
		end
	end
	
	if health <= 0
	and data == nil
	then
		table.insert(initSeeds, enemy.InitSeed)
	end
end

function Item.postNPCDeath(npc)
	if npc:IsBoss() then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if Functions.IsInvulnerableEnemy(npc) then return end
	if IsBlacklistedEnemy(npc) then return end
	if not CanBeRevived(npc) then return end
	
	rng:SetSeed(npc.InitSeed, 35)
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		
		if not player:HasCollectible(Enums.Collectibles.JUNO) then return end
		
		local randNum = rng:RandomInt(100)
		
		if randNum < (20 * player:GetCollectibleNum(Enums.Collectibles.JUNO)) then
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
end

function Item.NPCUpdate(npc)
	if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if npc.SpawnerEntity == nil then return end
	if npc.SpawnerEntity:GetData().junoFriendly == nil then return end
	if npc:GetData().junoFriendly then return end

	npc:SetColor(Color(1, 1, 1, 0.4, 0.2, 0, 0.2), 99999, 1, false, false)
	npc:GetData().junoFriendly = true
end

function Item.postProjectileUpdate(projectile)
	if projectile.SpawnerEntity == nil then return end
	
	if projectile:GetData().colorSet == nil
	and projectile.SpawnerEntity:GetData().junoFriendly
	then
		projectile:SetColor(Color(1, 1, 1, 0.4, 0.2, 0, 0.2), 99999, 1, false, false)
		projectile:GetData().colorSet = true
	end
end

function Item.postLaserUpdate(laser)
	if laser.SpawnerEntity == nil then return end
	
	if laser:GetData().colorSet == nil
	and laser.SpawnerEntity:GetData().junoFriendly
	then
		laser:SetColor(Color(0.5, 0, 0.5, 0.4, 0.5, 0, 0.5), 99999, 1, false, false)
		laser:GetData().colorSet = true
	end
end

function Item.postPlayerUpdate(player)
	if not player:HasCollectible(Enums.Collectibles.JUNO) then return end
	if player:HasCurseMistEffect() then return end
	if player:IsCoopGhost() then return end

	local tempEffects = player:GetEffects()

	if not tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) then
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW, false, 1)
	end
end

return Item