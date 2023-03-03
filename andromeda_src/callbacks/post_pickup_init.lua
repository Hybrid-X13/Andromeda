local UnlockManager = require("andromeda_src.unlock_manager")
local Andromeda = require("andromeda_src.characters.andromeda")
local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local TheSporepedia = require("andromeda_src.items.actives.the_sporepedia")
local Ceres = require("andromeda_src.items.passives.ceres")
local Stardust = require("andromeda_src.items.trinkets.stardust")
local Polaris = require("andromeda_src.items.trinkets.polaris")
local AbandonedPlanetarium = require("andromeda_src.misc.abandoned_planetarium")

local function MC_POST_PICKUP_INIT(_, pickup)
	UnlockManager.postPickupInit(pickup)
	
	Andromeda.postPickupInit(pickup)
	T_Andromeda.postPickupInit(pickup)

	TheSporepedia.postPickupInit(pickup)

	Ceres.postPickupInit(pickup)
	
	Stardust.postPickupInit(pickup)
	Polaris.postPickupInit(pickup)
	
	AbandonedPlanetarium.postPickupInit(pickup)
end

return MC_POST_PICKUP_INIT