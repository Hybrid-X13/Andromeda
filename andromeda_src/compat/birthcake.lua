local Enums = require("andromeda_src.enums")
local birthcakeAdded = false

local  BirthcakeCompat = {}

function BirthcakeCompat.postGameStarted(isContinue)
    if Birthcake
    and not birthcakeAdded
    then
        Birthcake.BirthcakeDescs[Enums.Characters.ANDROMEDA] = "Starry night"
    
        Birthcake.TrinketDesc[Enums.Characters.ANDROMEDA] = {Normal = "Killing an enemy has a chance to spawn a cluster of small damaging stars#Taking damage also spawns stars"}

        birthcakeAdded = true
    end
end

return BirthcakeCompat