if Poglite then
	local Enums = require("andromeda_src.enums")

	local playerType = Enums.Characters.ANDROMEDA
	local pogCostume = Isaac.GetCostumeIdByPath("gfx/characters/andromedapog.anm2")
	Poglite:AddPogCostume("AndromedaPog", playerType, pogCostume)
	
	local playerTypeB = Enums.Characters.T_ANDROMEDA
	local pogCostumeB = Isaac.GetCostumeIdByPath("gfx/characters/andromedabpog.anm2")
	Poglite:AddPogCostume("AndromedaBPog", playerTypeB, pogCostumeB)
end