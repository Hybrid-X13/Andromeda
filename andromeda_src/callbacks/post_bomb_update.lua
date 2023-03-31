local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local HarmonicConvergence = require("andromeda_src.items.passives.harmonic_convergence")
local Starburst = require("andromeda_src.items.passives.starburst")
local Spode = require("andromeda_src.misc.spode")

local function MC_POST_BOMB_UPDATE(_, bomb)
	T_Andromeda.postBombUpdate(bomb)

	HarmonicConvergence.postBombUpdate(bomb)
	Starburst.postBombUpdate(bomb)
	
	Spode.postBombUpdate(bomb)
end

return MC_POST_BOMB_UPDATE