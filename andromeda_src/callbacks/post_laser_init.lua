local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local HarmonicConvergence = require("andromeda_src.items.passives.harmonic_convergence")

local function MC_POST_LASER_INIT(_, laser)
	T_Andromeda.postLaserInit(laser)
	
	HarmonicConvergence.postLaserInit(laser)
end

return MC_POST_LASER_INIT