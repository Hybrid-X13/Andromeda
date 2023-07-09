local SaveData = require("andromeda_src.savedata")
local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")

local function MC_POST_NEW_LEVEL()
	SaveData.postNewLevel()

	Andromeda.postNewLevel()
	T_Andromeda.postNewLevel()
end

return MC_POST_NEW_LEVEL