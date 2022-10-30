local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Juno = require("andromeda_src.items.passives.juno")
local Spode = require("andromeda_src.misc.spode")

local function MC_POST_LASER_UPDATE(_, laser)
	Andromeda.postLaserUpdate(laser)
	T_Andromeda.postLaserUpdate(laser)
	
	Juno.postLaserUpdate(laser)

	Spode.postLaserUpdate(laser)
end

return MC_POST_LASER_UPDATE