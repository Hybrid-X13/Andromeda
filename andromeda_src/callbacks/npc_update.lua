local T_Andromeda = require("andromeda_src.characters.t_andromeda")
local Juno = require("andromeda_src.items.passives.juno")
local AlienTransmitter = require("andromeda_src.items.trinkets.alien_transmitter")

local function MC_NPC_UPDATE(_, npc)
	T_Andromeda.NPCUpdate(npc)
	
	Juno.NPCUpdate(npc)

	AlienTransmitter.NPCUpdate(npc)
end

return MC_NPC_UPDATE