local SaveData = require("andromeda_src.savedata")

local function MC_PRE_GAME_EXIT(_, continue)
	SaveData.preGameExit(continue)
end

return MC_PRE_GAME_EXIT