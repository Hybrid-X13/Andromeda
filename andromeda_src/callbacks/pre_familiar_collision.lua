local BabyPluto = require("andromeda_src.items.familiars.baby_pluto")
local Plutonium = require("andromeda_src.items.familiars.plutonium")
local MegaPlutonium = require("andromeda_src.items.familiars.mega_plutonium")
local Nix = require("andromeda_src.items.familiars.nix")

local function MC_PRE_FAMILIAR_COLLISION(_, familiar, collider, low)
	local returned = BabyPluto.preFamiliarCollision(familiar, collider, low)
	if returned ~= nil then return returned end

	local returned = Plutonium.preFamiliarCollision(familiar, collider, low)
	if returned ~= nil then return returned end

	local returned = MegaPlutonium.preFamiliarCollision(familiar, collider, low)
	if returned ~= nil then return returned end

	local returned = Nix.preFamiliarCollision(familiar, collider, low)
	if returned ~= nil then return returned end
end

return MC_PRE_FAMILIAR_COLLISION