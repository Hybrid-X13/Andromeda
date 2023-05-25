local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local TheSporepedia = require("andromeda_src.items.actives.the_sporepedia")
local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local Plutonium = require("andromeda_src.items.familiars.plutonium")
local MegaPlutonium = require("andromeda_src.items.familiars.mega_plutonium")
local Pallas = require("andromeda_src.items.passives.pallas")
local CelestialCrown = require("andromeda_src.items.passives.celestial_crown")
local AndromedaKnife = require("andromeda_src.items.passives.andromeda_knife")
local AndromedaTechX = require("andromeda_src.items.passives.andromeda_techx")
local CryingPebble = require("andromeda_src.items.trinkets.crying_pebble")
local Spode = require("andromeda_src.misc.spode")

local function MC_EVALUATE_CACHE(_, player, cacheFlag)
	Andromeda.evaluateCache(player, cacheFlag)
	T_Andromeda.evaluateCache(player, cacheFlag)
	
	TheSporepedia.evaluateCache(player, cacheFlag)

	BabyPluto.evaluateCache(player, cacheFlag)
	Plutonium.evaluateCache(player, cacheFlag)
	MegaPlutonium.evaluateCache(player, cacheFlag)
	
	Pallas.evaluateCache(player, cacheFlag)
	CelestialCrown.evaluateCache(player, cacheFlag)
	AndromedaKnife.evaluateCache(player, cacheFlag)
	AndromedaTechX.evaluateCache(player, cacheFlag)

	CryingPebble.evaluateCache(player, cacheFlag)
	
	Spode.evaluateCache(player, cacheFlag)
end

return MC_EVALUATE_CACHE