local FFCompat = require("andromeda_src.compat.fiend_folio")

local function MC_POST_GAME_STARTED(_, isContinue)
	FFCompat.postGameStarted(isContinue)
end

return MC_POST_GAME_STARTED