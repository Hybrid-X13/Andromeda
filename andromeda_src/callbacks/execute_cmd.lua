local Commands = require("andromeda_src.commands")

local function MC_EXECUTE_CMD(_, cmd)
	Commands.executeCMD(cmd)
end

return MC_EXECUTE_CMD