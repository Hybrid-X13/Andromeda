local SaveData = require("andromeda_src.savedata")
local UnlockManager = require("andromeda_src.unlock_manager")
local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local GravityShift = require("andromeda_src.items.actives.gravity_shift")
local Spode = require("andromeda_src.misc.spode")

local function MC_POST_PLAYER_INIT(_, player)
	SaveData.postPlayerInit(player)
	UnlockManager.postPlayerInit(player)
	
	Andromeda.postPlayerInit(player)
	T_Andromeda.postPlayerInit(player)
	
	GravityShift.postPlayerInit(player)
	
	Spode.postPlayerInit(player)
end

return MC_POST_PLAYER_INIT