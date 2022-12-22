local Enums = require("andromeda_src.enums")
local SaveData = require("andromeda_src.savedata")

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
    end
end

return FFCompat