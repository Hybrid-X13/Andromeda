local Juno = require("andromeda_src.items.passives.juno")

local function MC_POST_PROJECTILE_UPDATE(_, projectile)
	Juno.postProjectileUpdate(projectile)
end

return MC_POST_PROJECTILE_UPDATE