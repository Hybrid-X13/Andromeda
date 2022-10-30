local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local HarmonicConvergence = require("andromeda_src.items.passives.harmonic_convergence")
local Vesta = require("andromeda_src.items.passives.vesta")
local Spode = require("andromeda_src.misc.spode")

local function MC_PRE_TEAR_COLLISION(_, entity, collider, low)
	local returned = Andromeda.preTearCollision(entity, collider, low)
	if returned ~= nil then return returned end
	
	local returned = T_Andromeda.preTearCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = BabyPluto.preTearCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = HarmonicConvergence.preTearCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = Vesta.preTearCollision(entity, collider, low)
	if returned ~= nil then return returned end

	local returned = Spode.preTearCollision(entity, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_TEAR_COLLISION