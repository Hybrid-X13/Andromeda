local Enums = require("andromeda_src.enums")
local SaveData = require("andromeda_src.savedata")
local referenceItemsAdded = false

local referenceItems = {
    Actives = {
        {ID = Enums.Collectibles.THE_SPOREPEDIA, Reference = "Spore"},
    },
    Passives = {
        {ID = Enums.Collectibles.OPHIUCHUS, Reference = "Naruto", Partial = true}
    },
    Trinkets = {
        {ID = Enums.Trinkets.MOON_STONE, Reference = "Pokemon"},
        {ID = Enums.Trinkets.STARDUST, Reference = "Pokemon"},
        {ID = Enums.Trinkets.ALIEN_TRANSMITTER, Reference = "Spore"},
        {ID = Enums.Trinkets.EYE_OF_SPODE, Reference = "Spore"},
    }
}

local FFCompat = {}

function FFCompat.postGameStarted(isContinue)
    if FiendFolio then
        if SaveData.UnlockData.Andromeda.Isaac
        and FiendFolio.GolemTrinketWhitelist[Enums.Trinkets.CRYING_PEBBLE] == nil
        then
            FiendFolio.GolemTrinketWhitelist[Enums.Trinkets.CRYING_PEBBLE] = 1
        end

        if SaveData.UnlockData.Andromeda.Satan
        and FiendFolio.GolemTrinketWhitelist[Enums.Trinkets.METEORITE] == nil
        then
            FiendFolio.GolemTrinketWhitelist[Enums.Trinkets.METEORITE] = 1
        end

        if SaveData.UnlockData.T_Andromeda.Satan
        and FiendFolio.GolemTrinketWhitelist[Enums.Trinkets.MOON_STONE] == nil
        then
            FiendFolio.GolemTrinketWhitelist[Enums.Trinkets.MOON_STONE] = 1
        end

        if not referenceItemsAdded then
            table.insert(FiendFolio.ReferenceItems.Actives, referenceItems.Actives[1])
            table.insert(FiendFolio.ReferenceItems.Passives, referenceItems.Passives[1])

            for i = 1, #referenceItems.Trinkets do
                table.insert(FiendFolio.ReferenceItems.Trinkets, referenceItems.Trinkets[i])
            end

            referenceItemsAdded = true
        end
    end
end

return FFCompat