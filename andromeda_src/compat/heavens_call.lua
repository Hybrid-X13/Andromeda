local Enums = require("andromeda_src.enums")
local SaveData = require("andromeda_src.savedata")
local addedToPool = false

local  HCCompat = {}

function HCCompat.postGameStarted(isContinue)
    if HeavensCall
    and SaveData.UnlockData.Andromeda.Greedier
    and not addedToPool
    then
        HeavensCall:AddItemToPool(Enums.Collectibles.OPHIUCHUS)
        addedToPool = true
    end
end

return HCCompat