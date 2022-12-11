local SaveData = require("andromeda_src.savedata")

local Commands = {}

function Commands.executeCMD(cmd)
	local string = string.lower(cmd)
	
	if string == "andromedahelp" then
		print("Andromeda Commands:")
		print("andromedamarks: Check progress for Andromeda's completion marks")
		print("tandromedamarks: Check progress for Tainted Andromeda's completion marks")
		print("andromedaunlockall: Unlocks all items for both characters")
		print("andromedareset: Resets item progress for both characters")
	elseif string == "andromedamarks"
	or string == "tandromedamarks"
	then
		local completionCount = 0
		local boss = {
			Isaac = "Isaac          : ",
			BlueBaby = "Blue Baby      : ",
			Satan = "Satan          : ",
			TheLamb = "The Lamb       : ",
			BossRush = "Boss Rush      : ",
			Hush = "Hush           : ",
			MegaSatan = "Mega Satan     : ",
			Delirium = "Delirium       : ",
			Mother = "Mother         : ",
			Beast = "The Beast      : ",
			Greed = "Greed Mode     : ",
			Greedier = "Greedier       : ",
			FullCompletion = "Full Completion: ",
		}
		local completion = {
			Isaac = "Unlocked Crying Pebble",
			BlueBaby = "Unlocked Gravity Shift",
			Satan = "Unlocked Meteorite",
			TheLamb = "Unlocked Extinction Event",
			BossRush = "Unlocked Betelgeuse & Alpha Centauri",
			Hush = "Unlocked Celestial Crown",
			MegaSatan = "Unlocked Baby Pluto",
			Delirium = "Unlocked Harmonic Convergence",
			Mother = "Unlocked Juno",
			Beast = "Unlocked Pallas",
			Greed = "Unlocked Stardust",
			Greedier = "Unlocked Ophiuchus",
			FullCompletion = "Unlocked Spode Transformation",
		}
		local completionB = {
			Isaac = "Unlocked Alien Transmitter",
			BlueBaby = "Unlocked Book of Cosmos",
			Satan = "Unlocked Moon Stone",
			TheLamb = "Unlocked Luminary Flare",
			BossRush = "Unlocked Sirius & Polaris",
			Hush = "Unlocked Soul of Andromeda",
			MegaSatan = "Unlocked Wisp Wizards",
			Delirium = "Unlocked Singularity",
			Mother = "Unlocked Ceres",
			Beast = "Unlocked Vesta",
			Greed = "Unlocked Sextant",
			Greedier = "Unlocked XXII - The Unknown",
			FullCompletion = "Unlocked Chiron",
		}
		
		if string == "andromedamarks" then
			print("Andromeda Completion Mark Progress:")

			for key, val in pairs(SaveData.UnlockData.Andromeda) do
				if not val then
					completion[key] = "???"
				end
				if completion[key] ~= "???" then
					completionCount = completionCount + 1
				end
				print(boss[key] .. completion[key])
			end
	
			if completionCount < 12 then
				completion.FullCompletion = "???"
			end
			print(boss.FullCompletion .. completion.FullCompletion)
		elseif string == "tandromedamarks" then
			print("Tainted Andromeda Completion Mark Progress:")

			for key, val in pairs(SaveData.UnlockData.T_Andromeda) do
				if not val then
					completionB[key] = "???"
				end
				if completionB[key] ~= "???" then
					completionCount = completionCount + 1
				end
				print(boss[key] .. completionB[key])
			end
	
			if completionCount < 12 then
				completionB.FullCompletion = "???"
			end
			print(boss.FullCompletion .. completionB.FullCompletion)
		end
	elseif string == "andromedaunlockall" then
		for key, val in pairs(SaveData.UnlockData.Andromeda) do
			if not val then
				SaveData.UnlockData.Andromeda[key] = true
			end
		end
		for key, val in pairs(SaveData.UnlockData.T_Andromeda) do
			if not val then
				SaveData.UnlockData.T_Andromeda[key] = true
			end
		end
		SaveData.SaveModData()
		print("Hope you enjoy the items... cheater")
	elseif string == "andromedareset" then
		for key, val in pairs(SaveData.UnlockData.Andromeda) do
			if val then
				SaveData.UnlockData.Andromeda[key] = false
			end
		end
		for key, val in pairs(SaveData.UnlockData.T_Andromeda) do
			if val then
				SaveData.UnlockData.T_Andromeda[key] = false
			end
		end
		SaveData.SaveModData()
		print("Completion mark progress for both characters has been reset")
	end
end

return Commands