local Enums = require("andromeda_src.enums")
local Functions = require("andromeda_src.functions")
local birthcakeAdded = false

local BirthcakeCompat = {}

function BirthcakeCompat.postGameStarted(isContinue)
    if Birthcake
    and not birthcakeAdded
    then
        Birthcake.BirthcakeDescs[Enums.Characters.ANDROMEDA] = "Starry night"
        Birthcake.BirthcakeDescs[Enums.Characters.T_ANDROMEDA] = "Appetite up"
    
        Birthcake.TrinketDesc[Enums.Characters.ANDROMEDA] = {Normal = "{{Planetarium}} Planetariums have an extra choice item#Additionally, taking damage spawns a cluster of small damaging stars"}
        Birthcake.TrinketDesc[Enums.Characters.T_ANDROMEDA] = {Normal = "Your black hole deals damage to nearby enemies every second#Every 5 enemies killed by the black hole adds one charge to Singularity"}

        birthcakeAdded = true
    end
end

function BirthcakeCompat.postPickupInit(pickup)
    if Birthcake == nil then return end
    if pickup.Variant ~= PickupVariant.PICKUP_TRINKET then return end

    local birthcakeID = Isaac.GetTrinketIdByName("Birthcake")
    local goldenBirthcake = birthcakeID + TrinketType.TRINKET_GOLDEN_FLAG

    if pickup.SubType ~= birthcakeID and pickup.SubType ~= birthcakeID + TrinketType.TRINKET_GOLDEN_FLAG then return end

    if Functions.AnyPlayerIsType(Enums.Characters.T_ANDROMEDA) then
        if pickup.SubType == goldenBirthcake then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.T_ANDROMEDA_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG, true, false, false)
        elseif pickup.SubType == birthcakeID then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.T_ANDROMEDA_BIRTHCAKE, true, false, false)
        end
    elseif Functions.AnyPlayerIsType(Enums.Characters.ANDROMEDA) then
        if pickup.SubType == goldenBirthcake then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.ANDROMEDA_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG, true, false, false)
        elseif pickup.SubType == birthcakeID then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Enums.Trinkets.ANDROMEDA_BIRTHCAKE, true, false, false)
        end
    end
end

function BirthcakeCompat.postPlayerUpdate(player)
    if Birthcake == nil then return end

    local birthcakeID = Isaac.GetTrinketIdByName("Birthcake")
    local goldenBirthcake = birthcakeID + TrinketType.TRINKET_GOLDEN_FLAG
   
    if player:HasTrinket(birthcakeID) then
        if player:GetPlayerType() == Enums.Characters.ANDROMEDA then
            player:TryRemoveTrinket(birthcakeID)
            player:TryRemoveTrinket(goldenBirthcake)
            player:AddTrinket(Enums.Trinkets.ANDROMEDA_BIRTHCAKE)
        elseif player:GetPlayerType() == Enums.Characters.T_ANDROMEDA then
            player:TryRemoveTrinket(birthcakeID)
            player:TryRemoveTrinket(goldenBirthcake)
            player:AddTrinket(Enums.Trinkets.T_ANDROMEDA_BIRTHCAKE)
        end
    end
end

return BirthcakeCompat