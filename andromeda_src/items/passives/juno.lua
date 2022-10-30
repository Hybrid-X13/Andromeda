local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local game = Game()
local rng = RNG()

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

function Item.postNPCDeath(npc)
	if npc:IsBoss() then return end
	if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
	if Functions.IsInvulnerableEnemy(npc) then return end
	if IsBlacklistedEnemy(npc) then return end
	
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
			
			revivedEnemy:SetColor(Color(1, 1, 1, 0.5, 0.2, 0, 0.2), 99999, 1, false, false)
			revivedEnemy:GetData().isRevived = true
		end
	end
end

function Item.postProjectileUpdate(projectile)
	if projectile.Parent == nil then return end
	
	if projectile:GetData().colorSet == nil
	and projectile.Parent:GetData().isRevived
	then
		projectile:SetColor(Color(1, 1, 1, 1, 0.2, 0, 0.2), 99999, 1, false, false)
		projectile:GetData().colorSet = true
	end
end

function Item.postLaserUpdate(laser)
	if laser.Parent == nil then return end
	
	if laser:GetData().colorSet == nil
	and laser.Parent:GetData().isRevived
	then
		laser:SetColor(Color(0.5, 0, 0.5, 0.8, 0.5, 0, 0.5), 99999, 1, false, false)
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