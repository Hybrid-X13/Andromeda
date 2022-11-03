local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Ophiuchus = require("andromeda_src.items.passives.ophiuchus")
local HarmonicConvergence = require("andromeda_src.items.passives.harmonic_convergence")
local AndromedaKnife = require("andromeda_src.items.passives.andromeda_knife")
local AndromedaTechX = require("andromeda_src.items.passives.andromeda_techx")

local function MC_POST_FIRE_TEAR(_, tear)
	T_Andromeda.postFireTear(tear)
	
	Ophiuchus.postFireTear(tear)
	HarmonicConvergence.postFireTear(tear)
	AndromedaKnife.postFireTear(tear)
	AndromedaTechX.postFireTear(tear)
end

return MC_POST_FIRE_TEAR