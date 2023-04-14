local FFCompat = require("andromeda_src.compat.fiend_folio")
local HCCompat = require("andromeda_src.compat.heavens_call")
local BirthcakeCompat = require("andromeda_src.compat.birthcake")

local function MC_POST_GAME_STARTED(_, isContinue)
	FFCompat.postGameStarted(isContinue)
	HCCompat.postGameStarted(isContinue)
	BirthcakeCompat.postGameStarted(isContinue)
end

return MC_POST_GAME_STARTED