--[[
	Achievement Display API made by AgentCucco
]]

local AchievementDisplayAPIVersion = 1.2
CCO = CCO or {}

if CCO.AchievementDisplayAPI then
	if not CCO.AchievementDisplayAPI.VERSION
	or CCO.AchievementDisplayAPI.VERSION < AchievementDisplayAPIVersion
	then
		Isaac.DebugString("Achievement Display API: [WARNING] A mod (or more) above this message has an outdated version of Achievement Display API, make sure to check which mod(s) do and notify their developer(s) to avoid errors.")
		Isaac.DebugString("Achievement Display API: [WARNING] Most up to date version: [" .. tostring(AchievementDisplayAPIVersion) .. "] (mods with an older version than this should be disabled or updated)")
		Isaac.DebugString("Achievement Display API: [WARNING] Current loaded version: [" .. tostring(CCO.AchievementDisplayAPI.VERSION or "UNKNOWN") .. "]")
		print("Achievement Display API: [WARNING] Outdated Achievement Display API version, check the log.txt file for more information.")
		print("Achievement Display API: [WARNING] C:/Users/[username]/Documents/My Games/Binding of Isaac Repentance/log.txt")
	end
	
	return CCO.AchievementDisplayAPI.API
end

--= IMPORTANT =--
-- In order for the library to work, you're required to copy 
-- the [ gfx/ui/achievement display api ] folder into your
-- project, under the same root, to have the necessary assets.
CCO.AchievementDisplayAPI = RegisterMod("Achievement Display API", 1)
CCO.AchievementDisplayAPI.VERSION = AchievementDisplayAPIVersion
local game = Game()
local sound = SFXManager()

local script = {}

local ACHIEVEMENT_SPRITE = Sprite()
ACHIEVEMENT_SPRITE:Load("gfx/ui/achievement display api/achievements.anm2")
ACHIEVEMENT_SPRITE.PlaybackSpeed = 0.5

local achievementQueue = {}
local oldTimer
local overwritePause = false
local overrideControls = false

function script.playAchievement(gfxroot, duration)
	table.insert(achievementQueue, {GfxRoot = gfxroot, Duration = duration or 90})
end

function script.isPlaying()
	return oldTimer and true or false
end

local function getScreenSize()
	local width = Isaac.GetScreenWidth()
	local height = Isaac.GetScreenHeight()
	
	return width, height
end

local inputAction_actionValue = function() end
local function inputAction_actionValue(_, entity, hook, action)
	if not overwritePause then
		return
	end
	
	if action == ButtonAction.ACTION_SHOOTDOWN then
		overwritePause = false
		
		for _, ember in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.FALLING_EMBER, -1)) do
			if ember:Exists() then
				ember:Remove()
			end
		end
		if REPENTANCE then
			for _, rain in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.RAIN_DROP, -1)) do
				if rain:Exists() then
					rain:Remove()
				end
			end
		end
		
		local player = entity:ToPlayer()
		
		if player then
			OverwrittenPause = true
			player.FireDelay = player.FireDelay + 1
			
			CCO.AchievementDisplayAPI:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, inputAction_actionValue)
		end
		
		return 1
	end
end

local function inputAction_actionTriggered(_, entity, hook, action)
	if not overwritePause then
		return nil
	end
	
	if action >= ButtonAction.ACTION_BOMB
	and action <= ButtonAction.ACTION_MENUTAB
	then
		return false
	end
end

local function freezeGame(unfreeze)
	if unfreeze then
		oldTimer = nil
		overwritePause = true
		
		CCO.AchievementDisplayAPI:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, inputAction_actionTriggered)
	else
		if not oldTimer then
			oldTimer = game.TimeCounter
			CCO.AchievementDisplayAPI:AddCallback(ModCallbacks.MC_INPUT_ACTION, inputAction_actionValue, InputHook.GET_ACTION_VALUE)
			CCO.AchievementDisplayAPI:AddCallback(ModCallbacks.MC_INPUT_ACTION, inputAction_actionTriggered, InputHook.IS_ACTION_TRIGGERED)
		end
			
		if Isaac.GetFrameCount() % 2 == 0 then -- Is an update frame
			if REPENTANCE then
				Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)
			else
				Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, false, false, true, false, 0)
			end
		end
		
		game.TimeCounter = oldTimer
	end
end

local function postRender()
	if FiendFolio
	and FiendFolio.IsPlayingAchievementNote()
	then
		return
	end

	if achievementQueue[1] then
		if not game:IsPaused() then
			if (ModConfigMenu and ModConfigMenu.IsVisible) then
				ModConfigMenu.CloseConfigMenu()
			end
			if (DeadSeaScrollsMenu and DeadSeaScrollsMenu.OpenedMenu) then
				DeadSeaScrollsMenu:CloseMenu(true, true)
			end
		
			freezeGame()
			if not overrideControls then
				overrideControls = true
				
				for p = 0, game:GetNumPlayers() - 1 do
					local player = Isaac.GetPlayer(p)
					local data = player:GetData()
					
					if not data.AchievementDisplayAPIControls then
						data.AchievementDisplayAPIControls = player.Velocity
						data.MenuDisabledControls = nil
						player.ControlsEnabled = false
						player.Velocity = Vector.Zero
					end
				end
			end
		
			if not achievementQueue[1].Appear then
				ACHIEVEMENT_SPRITE:Play("Appear", true)
				achievementQueue[1].Appear = true
				
				if achievementQueue[1].GfxRoot then
					ACHIEVEMENT_SPRITE:ReplaceSpritesheet(3, achievementQueue[1].GfxRoot)
					ACHIEVEMENT_SPRITE:LoadGraphics()
				end
			end
			
			if ACHIEVEMENT_SPRITE:IsFinished("Appear") then
				if not achievementQueue[1].SoundPlayed then
					sound:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 1, 0, false, 1)
					achievementQueue[1].SoundPlayed = true
				end
			
				if achievementQueue[1].Duration <= 0 then
					ACHIEVEMENT_SPRITE:Play("Dissapear", true)
				else
					achievementQueue[1].Duration = achievementQueue[1].Duration - 1
				end
			end
		
			if ACHIEVEMENT_SPRITE:IsFinished("Dissapear") then
				table.remove(achievementQueue, 1)
				
				if (not achievementQueue[1]) and overrideControls then
					overrideControls = false
					
					for p = 0, game:GetNumPlayers() - 1 do
						local player = Isaac.GetPlayer(p)
						local data = player:GetData()
						
						if data.AchievementDisplayAPIControls then
							player.ControlsEnabled = true
							player.Velocity = data.AchievementDisplayAPIControls
							data.AchievementDisplayAPIControls = nil
						end
					end
					
					freezeGame(true)
				end
				
				return
			end
		end
		
		local CenterX, CenterY = getScreenSize()
		ACHIEVEMENT_SPRITE:Render(Vector(CenterX / 2, CenterY / 2), Vector.Zero, Vector.Zero)
		ACHIEVEMENT_SPRITE:Update()
	end
end
CCO.AchievementDisplayAPI:AddCallback(ModCallbacks.MC_POST_RENDER, postRender)

CCO.AchievementDisplayAPI.API = script

CCO.AchievementDisplayAPI.PlayAchievement = script.playAchievement -- backwards compat

Isaac.DebugString("Achievement Display API: Loaded Successfully! Version: " .. CCO.AchievementDisplayAPI.VERSION)
print("Achievement Display API: Loaded Successfully! Version: " .. CCO.AchievementDisplayAPI.VERSION)

return script
