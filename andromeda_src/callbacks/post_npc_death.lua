local UnlockManager = require("andromeda_src.unlock_manager")
local Juno = require("andromeda_src.items.passives.juno")
local Ophiuchus = require("andromeda_src.items.passives.ophiuchus")
local LuminaryFlare = require("andromeda_src.items.passives.luminary_flare")
local Stardust = require("andromeda_src.items.trinkets.stardust")

local function MC_POST_NPC_DEATH(_, npc)
	UnlockManager.postNPCDeath(npc)
	
	Juno.postNPCDeath(npc)
	Ophiuchus.postNPCDeath(npc)
	LuminaryFlare.postNPCDeath(npc)
	
	Stardust.postNPCDeath(npc)
end

return MC_POST_NPC_DEATH