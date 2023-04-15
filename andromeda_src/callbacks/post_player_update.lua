local UnlockManager = require("andromeda_src.unlock_manager")
local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Juno = require("andromeda_src.items.passives.juno")
local Spode = require("andromeda_src.misc.spode")
local BirthcakeCompat = require("andromeda_src.compat.birthcake")

local function MC_POST_PLAYER_UPDATE(_, player)
	UnlockManager.postPlayerUpdate(player)

	Andromeda.postPlayerUpdate(player)
	T_Andromeda.postPlayerUpdate(player)
	
	Juno.postPlayerUpdate(player)

	Spode.postPlayerUpdate(player)

	BirthcakeCompat.postPlayerUpdate(player)
end

return MC_POST_PLAYER_UPDATE