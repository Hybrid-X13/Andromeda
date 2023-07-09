local CustomData = require("andromeda_src.customdata")
local mod = ANDROMEDA
local json = require("json")
local game = Game()

local SaveData = {}
local SAVE_STATE = {}

SaveData.UnlockData ={
	Andromeda = {
		Isaac = false,
		BlueBaby = false,
		Satan = false,
		TheLamb = false,
		BossRush = false,
		Hush = false,
		MegaSatan = false,
		Delirium = false,
		Mother = false,
		Beast = false,
		Greed = false,
		Greedier = false,
	},
	T_Andromeda ={
		Isaac = false,
		BlueBaby = false,
		Satan = false,
		TheLamb = false,
		BossRush = false,
		Hush = false,
		MegaSatan = false,
		Delirium = false,
		Mother = false,
		Beast = false,
		Greed = false,
		Greedier = false,
	},
	Secrets = {
		Cetus = false,
		Starburst = false,
		EyeOfSpode = false,
	},
}

SaveData.PlayerData = {
	Andromeda = {
		GravShift = {
			Treasure = {},
			Shop = 0,
			Secret = 0,
			SuperSecret = 0,
			Angel = 0,
			Devil = 0,
			Planetarium = 0,
		},
	},
	T_Andromeda = {
		Costumes = {},
		SecretChance = 100,
		PlanetariumChance = 100,
	},
}

SaveData.ItemData = {
	Chiron = {
		Chance = 4,
	},
	Pallas = {
		newRoomDMG = 0,
	},
}

function SaveData.SaveModData()
	SAVE_STATE.UnlockData = SaveData.UnlockData
	SAVE_STATE.PlayerData = SaveData.PlayerData
	SAVE_STATE.ItemData = SaveData.ItemData
	SAVE_STATE.AbPlPool = CustomData.AbPlPoolCopy

	mod:SaveData(json.encode(SAVE_STATE))
end

function SaveData.postPlayerInit(player)
	if mod:HasData() then
		SAVE_STATE = json.decode(mod:LoadData())

		--Cleanse my old sins
		if SAVE_STATE.UnlockData == nil
		and type(SAVE_STATE[1]) == "table"
		then
			local copy1 = SAVE_STATE[1]
			local copy2 = SAVE_STATE[2]
			local oldData1 = {
				Isaac = copy1[1],
				BlueBaby = copy1[2],
				Satan = copy1[3],
				TheLamb = copy1[4],
				BossRush = copy1[5],
				Hush = copy1[6],
				MegaSatan = copy1[7],
				Delirium = copy1[8],
				Mother = copy1[9],
				Beast = copy1[10],
				Greed = copy1[11],
				Greedier = copy1[12],
			}
			local oldData2 = {
				Isaac = copy2[1],
				BlueBaby = copy2[2],
				Satan = copy2[3],
				TheLamb = copy2[4],
				BossRush = copy2[5],
				Hush = copy2[6],
				MegaSatan = copy2[7],
				Delirium = copy2[8],
				Mother = copy2[9],
				Beast = copy2[10],
				Greed = copy2[11],
				Greedier = copy2[12],
			}

			for key, val in pairs(oldData1) do
				if oldData1[key] == 1 then
					SaveData.UnlockData.Andromeda[key] = true
				end
			end

			for key, val in pairs(oldData2) do
				if oldData2[key] == 1 then
					SaveData.UnlockData.T_Andromeda[key] = true
				end
			end
			
			SAVE_STATE.UnlockData = SaveData.UnlockData
		else
			SaveData.UnlockData.Andromeda = SAVE_STATE.UnlockData.Andromeda
			SaveData.UnlockData.T_Andromeda = SAVE_STATE.UnlockData.T_Andromeda

			if SAVE_STATE.UnlockData.Secrets == nil then
				SaveData.UnlockData.Secrets = {
					Cetus = false,
					Starburst = false,
					EyeOfSpode = false,
				}
			else
				for key, val in pairs(SaveData.UnlockData.Secrets) do
					if SAVE_STATE.UnlockData.Secrets[key] == nil then
						SAVE_STATE.UnlockData.Secrets[key] = false
					end
				end
				SaveData.UnlockData.Secrets = SAVE_STATE.UnlockData.Secrets
			end
		end

		if game:GetFrameCount() == 0 then
			SaveData.PlayerData = {
				Andromeda = {
					GravShift = {
						Treasure = {},
						Shop = 0,
						Secret = 0,
						SuperSecret = 0,
						Angel = 0,
						Devil = 0,
						Planetarium = 0,
					},
				},
				T_Andromeda = {
					Costumes = {},
					SecretChance = 100,
					PlanetariumChance = 100,
				},
			}
			
			SaveData.ItemData = {
				Chiron = {
					Chance = 4,
				},
				Pallas = {
					newRoomDMG = 0,
				},
			}
			
			for i = 1, #CustomData.AbandonedPlanetariumPool do
				CustomData.AbPlPoolCopy[i] = CustomData.AbandonedPlanetariumPool[i]
			end
			for i = 1, #CustomData.BookOfCosmosList do
				CustomData.BookOfCosmosCopy[i] = CustomData.BookOfCosmosList[i]
			end

			player:AddCacheFlags(CacheFlag.CACHE_ALL)

			SaveData.SaveModData()
		else
			SaveData.PlayerData.Andromeda = SAVE_STATE.PlayerData.Andromeda
			SaveData.PlayerData.T_Andromeda = SAVE_STATE.PlayerData.T_Andromeda
			SaveData.ItemData.Chiron = SAVE_STATE.ItemData.Chiron
			SaveData.ItemData.Pallas = SAVE_STATE.ItemData.Pallas
			CustomData.AbPlPoolCopy = SAVE_STATE.AbPlPool
		end
	end
end

function SaveData.postNewLevel()
	SaveData.SaveModData()
end

function SaveData.preGameExit()
	SaveData.SaveModData()
end

return SaveData