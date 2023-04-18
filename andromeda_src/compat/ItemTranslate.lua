return function(ModName,Modver)

local modname = ModName or "main"   
local ITver = Modver or 1.05

--if not ItemTranslate or ItemTranslate.Ver and ItemTranslate.Ver < ITver then
	local LocalDeleteCallback
	
	local ITrsl = RegisterMod("ItemTranslate" .. modname, 1)
	local IT = ItemTranslate 
	
	function ITrsl.GetTables()
		local ITT = ItemTranslate		
		ITT.CallbacksList = ITT.CallbacksList or {}
		ITT.CollTabl = ITT.CollTabl or {}
		ITT.TrinkTabl = ITT.TrinkTabl or {}		
		ITT.CardTabl = ITT.CardTabl or {}
		ITT.PillsTabl = ITT.PillsTabl or {}
		ITT.BirthrightTabl = ITT.BirthrightTabl or {}
		ITT.MenuData = ITT.MenuData or {empty = true}
		ITT.CheckedPills = ITT.CheckedPills or {}
		ITT.ModInfo = ITT.ModInfo or {}
		ITT.LangTabl = ITT.LangTabl or {"en","en","ru","es","de","fr","jp","kr","zh"}
	end

	local pickupanim_name = { PickupWalkDown = true, PickupWalkLeft = true, PickupWalkUp = true, PickupWalkRight = true }
	
	local PickupTouched = false
	local PickupTouchedID = 0
	local PickupIgnoreID = nil
	local PickupIgnore = false
	local PickupIgnoreFrame 

	local playerPickupTracker = {}
	local function GenPickupTrackerTabl(index)
		playerPickupTracker[index] = {
				["PickupTouched"] = PickupTouched,
				["PickupTouchedID"] = PickupTouchedID,
				["PickupIgnoreID"] = PickupIgnoreID,
				["PickupIgnore"] = PickupIgnore,
				["PickupIgnoreFrame"] = PickupIgnoreFrame ,
			}
	end

	local function GetLang()
		return IT.MenuData and IT.MenuData.Language ~= 1 
			and IT.LangTabl[IT.MenuData.Language] or Options.Language
	end

	local function CheckModEnable(item)
		if item and item.Mod then
			return not IT.MenuData['mod' .. item.Mod]
		end
		return true
	end

	local PostItemPickupCallbacks = {}
	local PostPickupPickupCallbacks = {}
	local QueuedItem = {}
	local QueuedPickup = {}

	function ITrsl.TranslatePickedItem(player,itemID,IsTrinket)
		if itemID then

			if IT.MenuData.CollTranslate ~= true and 
			not IsTrinket and IT.CollTabl[itemID] and
			CheckModEnable(IT.CollTabl[itemID]) == true then -- Options.Language
				if IT.CollTabl[itemID][GetLang()] then
					local hud = Game():GetHUD()
					local str = IT.CollTabl[itemID][GetLang()]
					hud:ShowItemText(str[1],str[2],false)
				end
			elseif not IT.MenuData.TrinkTranslate
			and IsTrinket and IT.TrinkTabl[itemID] and
			CheckModEnable(IT.TrinkTabl[itemID]) == true then
				if IT.TrinkTabl[itemID][GetLang()] then
					local hud = Game():GetHUD()
					local str = IT.TrinkTabl[itemID][GetLang()]
					hud:ShowItemText(str[1],str[2],false)
				end
			end
		end
	end

	local BirthrightDefaultName = {  
			en = 'Birthright',
			jp = 'バースライト',
			kr = '생득권',
			zh = '长子名分',
			ru = 'Право первородства',
			de = 'Geburtsrecht',
			es = 'Primogenitura',
			fr = 'Droit d\'Aînesse',
		}

	function ITrsl.TranslateBirthright(playerID)
		if IT.MenuData.CollTranslate ~= true then
			local BirthName = BirthrightDefaultName[GetLang()]

			if IT.CollTabl[CollectibleType.COLLECTIBLE_BIRTHRIGHT] then
				BirthName = IT.CollTabl[CollectibleType.COLLECTIBLE_BIRTHRIGHT][GetLang()][1]
			end
			
			if IT.BirthrightTabl[playerID] and CheckModEnable(IT.BirthrightTabl[playerID]) == true then
				if IT.BirthrightTabl[playerID][GetLang()] then
					local hud = Game():GetHUD()
					local str = IT.BirthrightTabl[playerID][GetLang()]
					if type(str) == "table" then
						hud:ShowItemText(BirthName,str[1],false)
					elseif type(str) == "string" then
						hud:ShowItemText(BirthName,str,false)
					end
				end
			end
		end
	end

	function ITrsl.TranslatePickedPickup(player,Pickup)
	    
	    if IT.MenuData.cardpickupTranslate ~= true then
		local PickupName = Isaac.GetItemConfig():GetCard(Pickup).Name
		
		if PickupName and IT.CardTabl[PickupName] and CheckModEnable(IT.CardTabl[PickupName]) then
			if IT.CardTabl[PickupName][GetLang()] then
				local hud = Game():GetHUD()
				local str = IT.CardTabl[PickupName][GetLang()]
				hud:ShowItemText(str[1],str[2],false)
			end
		end
	    end
	end
	
	function ITrsl.PostItemPickup(_,player)

		local que = player.QueuedItem
		if que.Item then
			if QueuedItem[player.Index] ~= que.Item.ID then
				if que.Item:IsCollectible() and que.Item.ID == CollectibleType.COLLECTIBLE_BIRTHRIGHT then
					ITrsl.TranslateBirthright(player:GetPlayerType())
				else
					ITrsl.TranslatePickedItem(player,que.Item.ID,que.Item:IsTrinket())
				end
			end
			QueuedItem[player.Index] = que.Item.ID
		elseif QueuedItem[player.Index] then  --GetPtrHash(player)
			QueuedItem[player.Index] = nil
		end
		
		if not playerPickupTracker[player.Index] then
			GenPickupTrackerTabl(player.Index) 
		end
		local PickData = playerPickupTracker[player.Index]
		            
		if PickData.PickupTouched and PickData.PickupTouched>0 then
			PickData.PickupTouched = PickData.PickupTouched - 1
			
			if PickData.PickupTouched == 0 and pickupanim_name[player:GetSprite():GetAnimation()] then
				ITrsl.TranslatePickedPickup(player,PickData.PickupTouchedID)
				PickData.PickupTouchedID = nil
			end
		end

		if PickData.PickupIgnoreFrame and PickData.PickupIgnoreFrame>0 then
			PickData.PickupIgnoreFrame = PickData.PickupIgnoreFrame - 1
			if PickData.PickupIgnoreFrame <= 0 then
				PickData.PickupIgnoreID = nil
				PickData.PickupIgnore = false
			end
		end
	end

	function ITrsl.PickupCollCheck(_,player,ent,bool)
		if ent.Type == EntityType.ENTITY_PICKUP then
			if not playerPickupTracker[player.Index] then
				GenPickupTrackerTabl(player.Index) 
			end
			local PickData = playerPickupTracker[player.Index]			
			
			if (not PickData.PickupTouched or PickData.PickupTouched <= 0) and PickData.PickupIgnoreID ~= ent.Index --нагромождение, но вроде работает
			and ent.Variant == 300 and not pickupanim_name[player:GetSprite():GetAnimation()] then
				PickData.PickupTouched = 3
				PickData.PickupTouchedID = ent.SubType
			elseif PickData.PickupTouched and PickData.PickupTouched > 0 and ent.Variant == 300 then
				PickData.PickupIgnoreID = ent.Index
				PickData.PickupIgnore = true
				PickData.PickupIgnoreFrame = 7
			end
			if PickData.PickupIgnoreID and PickData.PickupIgnoreID == ent.Index then
				PickData.PickupIgnoreFrame = 7
			end
		end
	end

	function ITrsl.TranslateUsedPill(_,ID, p, flag)
	   if IT.MenuData.cardpickupTranslate ~= true then
		local PillName = Isaac.GetItemConfig():GetPillEffect(ID).Name
		
		if PillName and IT.PillsTabl[PillName] and CheckModEnable(IT.PillsTabl[PillName]) == true then
			if IT.PillsTabl[PillName][GetLang()] then
				local hud = Game():GetHUD()
				local str = IT.PillsTabl[PillName][GetLang()]
				hud:ShowItemText(str[1],str[2],false)
			end
		end
	   end
	end

	local function CheckLazarusHologram(player)
		if player and player:ToPlayer() then
			if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) or
				(player:GetOtherTwin() and player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) then
					if player:GetMainTwin().Index ~= player.Index or player:GetMainTwin().InitSeed ~= player.InitSeed then
						return true
					end
				end
			end
		end
		return nil
	end

	local PocketItemStrings = {}
	function ITrsl.CheckHoldingCardPill() 
		PocketItemStrings = {}
		for i=0,Game().GetNumPlayers(Game())-1 do
			local player = Isaac.GetPlayer(i)
			local TrslName
			local lang = GetLang()
			
			if player:GetCard(0) ~= 0 then
				
				local name = Isaac.GetItemConfig():GetCard(player:GetCard(0)).Name
				if IT.CardTabl[name] and IT.CardTabl[name][lang] 
				and CheckModEnable(IT.CardTabl[name]) then
					local str =  IT.CardTabl[name][lang][1]
					if Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) 
					and IT.CardTabl[name][lang][2] then
						str =  IT.CardTabl[name][lang][2]
					end
					TrslName = str
				end

			elseif player:GetPill(0) ~= 0 and player:GetPill(0) ~= 14 then
				local pill = Game():GetItemPool():GetPillEffect(player:GetPill(0))
				local name = Isaac.GetItemConfig():GetPillEffect(pill).Name
				local check = IT.CheckedPills[name] or player:HasCollectible(CollectibleType.COLLECTIBLE_PHD,false)
				
				if check and IT.PillsTabl[name] and CheckModEnable(IT.PillsTabl[name])
				and IT.PillsTabl[name][lang] then
					local str = IT.PillsTabl[name][lang][1]
					if Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) 
					and IT.PillsTabl[name][lang][2] then
						str =  IT.PillsTabl[name][lang][2]
					end
					
					TrslName = str					
				end
			end
			
			local slot1 = player:GetPill(0) ~= 0 or player:GetCard(0) ~= 0
			local PocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
			local IsActiveItem = false

			if PocketItem and slot1 == false then
				if IT.CollTabl[PocketItem] and CheckModEnable(IT.CollTabl[PocketItem]) 
				and IT.CollTabl[PocketItem][lang] then
					local str = IT.CollTabl[PocketItem][lang][1]
					if Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) 
					and IT.CollTabl[PocketItem][lang][2] then
						str =  IT.CollTabl[PocketItem][lang][2]
					end
					TrslName = str	
					IsActiveItem = true
				end
			end

			if CheckLazarusHologram(player) or player.Parent == nil then
				local id = #PocketItemStrings+1
				if player:GetPlayerType() == PlayerType.PLAYER_ESAU then 
					id = -1
				end
				PocketItemStrings[id] = {Name = TrslName or "", player = player, IsActiveItem = IsActiveItem}
			end
		end
	end

	function ITrsl.UsedPillSave(_,ID, p, flag)
		if p:GetPill(0) ~= 14 then
			IT.CheckedPills[Isaac.GetItemConfig():GetPillEffect(ID).Name] = true
		end
	end

	local font = Font()
	font:Load("font/pftempestasevencondensed.fnt")

	local alpha = {}
	function ITrsl.RenderPocketItemName()
	    local hud = Game():GetHUD()
	    local shakeOffset = Game().ScreenShakeOffset
	    if hud:IsVisible() and IT.MenuData.pickup_renderTranslate ~= true then
		for i,k in pairs(PocketItemStrings) do
			local id = i-1
			if k.Name and k.player and k.player:ToPlayer() then
				local str = k.Name
				alpha[i] = alpha[i] or 1
				local pType = k.player:GetPlayerType()
				
				if (pType ~= PlayerType.PLAYER_ESAU and pType ~= PlayerType.PLAYER_JACOB) or
				((pType == PlayerType.PLAYER_ESAU or pType == PlayerType.PLAYER_JACOB) and
				Input.IsActionPressed(ButtonAction.ACTION_DROP, k.player.ControllerIndex)) then
					alpha[i] = alpha[i] * 0.8 + 0.2
				elseif (pType == PlayerType.PLAYER_ESAU or pType == PlayerType.PLAYER_JACOB) then
					alpha[i] = alpha[i] * 0.8 + 0.1
				end
				local ah = alpha[i]
				
				if i>1 and PocketItemStrings[1] and PocketItemStrings[1].player
				and PocketItemStrings[1].player:GetPlayerType() == PlayerType.PLAYER_ESAU then
					id = id - 1
				end
				if pType == PlayerType.PLAYER_ESAU then
					local Corner = Vector(Isaac.GetScreenWidth(),Isaac.GetScreenHeight())
					local Offset = -Vector(Options.HUDOffset*16+25.0,
						Options.HUDOffset*6+47)
					local Pos = Corner+Offset+shakeOffset

					font:DrawStringScaledUTF8(str,Pos.X,Pos.Y+5,0.5,0.5,KColor(ah,ah,ah,ah),1,false)
				else

				    if id == 0 then
					 if pType == PlayerType.PLAYER_JACOB then
						local Corner = Vector(0,0)  
						local Offset = 	Vector(Options.HUDOffset*20+24,
							Options.HUDOffset*11+30)
						local Pos = Corner+Offset+shakeOffset
						font:DrawStringScaledUTF8(str,Pos.X,Pos.Y+13,0.5,0.5,KColor(ah,ah,ah,ah),0,true)
					 else
						local ActiveItemOffset = k.IsActiveItem and Vector(-4,0) or Vector.Zero

						local Corner = Vector(Isaac.GetScreenWidth(),Isaac.GetScreenHeight())  
						local Offset = 	-Vector(Options.HUDOffset*16+30,
							Options.HUDOffset*6+22)
						local Pos = Corner+Offset+ActiveItemOffset+shakeOffset

						font:DrawStringScaledUTF8(str,Pos.X,Pos.Y+13,0.5,0.5,KColor(ah,ah,ah,ah),1,false)
					 end
				     elseif id == 1 then
					local ActiveItemOffset = k.IsActiveItem and Vector(-2,0) or Vector.Zero

					local heartoffset = k.player:GetMaxHearts() > 18 and 10*math.ceil((k.player:GetMaxHearts()-18)/6) or 0
					
					local Corner = Vector(Isaac.GetScreenWidth(),0)  --Vector(0,0)
					local Offset = -Vector(Options.HUDOffset*24.5+140.0,
						-Options.HUDOffset*12-39)
					local Pos = Corner+Offset+ActiveItemOffset+shakeOffset
				
					font:DrawStringScaledUTF8(str,Pos.X,Pos.Y+5+heartoffset,0.5,0.5,KColor(ah,ah,ah,ah),0,true)

				    elseif id == 2 then
					local ActiveItemOffset = k.IsActiveItem and Vector(-2.5,0) or Vector.Zero
					
					local heartoffset = k.player:GetMaxHearts() > 18 and 5*math.ceil((k.player:GetMaxHearts()-18)/6) or 0
					local Corner = Vector(0,Isaac.GetScreenHeight())  
					local Offset = Vector(Options.HUDOffset*22+28.0,
						-Options.HUDOffset*6-11) 
					local Pos = Corner+Offset+ActiveItemOffset+shakeOffset
				
					font:DrawStringScaledUTF8(str,Pos.X+1,Pos.Y+5+heartoffset,0.5,0.5,KColor(ah,ah,ah,ah),0,true)
					
				    elseif id == 3 then
					local ActiveItemOffset = k.IsActiveItem and Vector(-2.5,0) or Vector.Zero
					
					local heartoffset = k.player:GetMaxHearts() > 18 and 10*math.ceil((k.player:GetMaxHearts()-18)/6) or 0
					local Corner = Vector(Isaac.GetScreenWidth(),Isaac.GetScreenHeight())  
					local Offset = 	-Vector(Options.HUDOffset*16+149,
						Options.HUDOffset*6+11)
					local Pos = Corner+Offset+ActiveItemOffset+shakeOffset
				
					font:DrawStringScaledUTF8(str,Pos.X+1,Pos.Y+5+heartoffset,0.5,0.5,KColor(ah,ah,ah,ah),0,true)
				    end
				end
			end
		end
	    end
	end


	function ITrsl.UsePillCallbacks(_,ID, p, flag)
		ITrsl.TranslateUsedPill(nil,ID, p, flag)
		ITrsl.UsedPillSave(nil,ID, p, flag)
	end
	function ITrsl.NewRunClearData(_,IsContinued)
		if not IsContinued then
			IT.CheckedPills = {}
			PocketItemStrings = {}
		end 
	end

	function ITrsl.ExitRunClearData()
		PocketItemStrings = {}
	end

	ITrsl:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.GetTables)
	ITrsl:AddCallback(ModCallbacks.MC_USE_PILL, ITrsl.UsePillCallbacks)
	ITrsl:AddCallback(ModCallbacks.MC_POST_UPDATE, ITrsl.CheckHoldingCardPill)
	ITrsl:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ITrsl.PostItemPickup)
	ITrsl:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, ITrsl.PickupCollCheck)
	ITrsl:AddCallback(ModCallbacks.MC_POST_RENDER, ITrsl.RenderPocketItemName)
	ITrsl:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.NewRunClearData)
	ITrsl:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, ITrsl.ExitRunClearData)

	LocalDeleteCallback = function()
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.GetTables)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ITrsl.PostItemPickup)
		ITrsl:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, ITrsl.PickupCollCheck)
		ITrsl:RemoveCallback(ModCallbacks.MC_USE_PILL, ITrsl.UsePillCallbacks)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_UPDATE, ITrsl.CheckHoldingCardPill)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_RENDER, ITrsl.RenderPocketItemName)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.NewRunClearData)
		if ITrsl.UpdateDDSMenu then
			ITrsl:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.UpdateDDSMenu)
		end
		ITrsl:RemoveCallback(ModCallbacks.MC_PRE_GAME_EXIT, ITrsl.ExitRunClearData)
	end

	local function InitFunctions()
	   ITrsl.GetTables()

	   function IT.RemoveTSRLCallback()
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.GetTables)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ITrsl.PostItemPickup)
		ITrsl:RemoveCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, ITrsl.PickupCollCheck)
		ITrsl:RemoveCallback(ModCallbacks.MC_USE_PILL, ITrsl.UsePillCallbacks)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_UPDATE, ITrsl.CheckHoldingCardPill)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_RENDER, ITrsl.RenderPocketItemName)
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.NewRunClearData) 
		ITrsl:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ITrsl.UpdateDDSMenu)
	   end

	   function IT.GetLang()
		return IT.MenuData and IT.MenuData.Language ~= 1 
			and IT.LangTabl[IT.MenuData.Language] or Options.Language
	   end
	
	   function IT.AddCollectiblesTranslation(tabl) 
		if tabl and type(tabl) == "table" then
			for key,strs in pairs(tabl) do
				if not IT.CollTabl[key] then
					IT.CollTabl[key] = strs
				else
					for suffix,trsl in pairs(strs) do
						IT.CollTabl[key][suffix] = trsl
					end
				end
			end
		end
	   end

	   function IT.AddTrinketsTranslation(tabl) 
		if tabl and type(tabl) == "table" then
			for key,strs in pairs(tabl) do
				if not IT.TrinkTabl[key] then
					IT.TrinkTabl[key] = strs
				else
					for suffix,trsl in pairs(strs) do
						IT.TrinkTabl[key][suffix] = trsl
					end
				end
			end
		end
	   end
	
	   function IT.AddCardTranslation(tabl) 
		if tabl and type(tabl) == "table" then
			for key,strs in pairs(tabl) do
				if not IT.CardTabl[key] then
					IT.CardTabl[key] = strs
				else
					for suffix,trsl in pairs(strs) do
						IT.CardTabl[key][suffix] = trsl
					end
				end
			end
		end
	   end

	   function IT.AddPillsTranslation(tabl) 
		if tabl and type(tabl) == "table" then
			for key,strs in pairs(tabl) do
				if not IT.PillsTabl[key] then
					IT.PillsTabl[key] = strs
				else
					for suffix,trsl in pairs(strs) do
						IT.PillsTabl[key][suffix] = trsl
					end
				end
			end
		end
	   end
		
	   function IT.AddBirthrightsTranslation(tabl) 
		if tabl and type(tabl) == "table" then
			for key,strs in pairs(tabl) do
				if not IT.BirthrightTabl[key] then
					IT.BirthrightTabl[key] = strs
				else
					for suffix,trsl in pairs(strs) do
						IT.BirthrightTabl[key][suffix] = trsl
					end
				end
			end
		end
	   end	

	   function IT.NotSmartTRSLAdding(Modname,tabl) 
		if tabl and type(tabl) == "table" then
			if tabl.Collectibles then
				for key,strs in pairs(tabl.Collectibles) do
					if not IT.CollTabl[key] then
						IT.CollTabl[key] = strs
						IT.CollTabl[key].Mod = Modname
					else
						for suffix,trsl in pairs(strs) do
							IT.CollTabl[key][suffix] = trsl
						end
						IT.CollTabl[key].Mod = Modname
					end
				end
			end
			if tabl.Trinkets then
				for key,strs in pairs(tabl.Trinkets) do
					if not IT.TrinkTabl[key] then
						IT.TrinkTabl[key] = strs
						IT.TrinkTabl[key].Mod = Modname
					else
						for suffix,trsl in pairs(strs) do
							IT.TrinkTabl[key][suffix] = trsl
						end
						IT.TrinkTabl[key].Mod = Modname
					end
				end
			end
			if tabl.Cards then
				for key,strs in pairs(tabl.Cards) do
					if not IT.CardTabl[key] then
						IT.CardTabl[key] = strs
						IT.CardTabl[key].Mod = Modname
					else
						for suffix,trsl in pairs(strs) do
							IT.CardTabl[key][suffix] = trsl
						end
						IT.CardTabl[key].Mod = Modname
					end
				end
			end
			if tabl.Pills then
				for key,strs in pairs(tabl.Pills) do
					if not IT.PillsTabl[key] then
						IT.PillsTabl[key] = strs
						IT.PillsTabl[key].Mod = Modname
					else
						for suffix,trsl in pairs(strs) do
							IT.PillsTabl[key][suffix] = trsl
						end
						IT.PillsTabl[key].Mod = Modname
					end
				end
			end
			if tabl.Birthrights then
				for key,strs in pairs(tabl.Birthrights) do
					if not IT.BirthrightTabl[key] then
						IT.BirthrightTabl[key] = strs
						IT.BirthrightTabl[key].Mod = Modname
					else
						for suffix,trsl in pairs(strs) do
							IT.BirthrightTabl[key][suffix] = trsl
						end
						IT.BirthrightTabl[key].Mod = Modname
					end
				end
			end
		else
			error("[2] is not table",3)
		end
	   end
	
	   function IT.AddModTranslation(Modname,tabl,langs) 
		if not Modname or type(Modname) ~= "string" then
			error("[1] is not string",2)
		else
			if tabl and type(tabl) == "table" then
				if not IT.ModInfo[Modname] then
					IT.ModInfo[Modname] = tabl
					IT.ModInfo[Modname].Name = Modname
					IT.ModInfo[Modname].Enable = true
					IT.NotSmartTRSLAdding(Modname,tabl)
				else
					for i,k in pairs(tabl) do
						IT.ModInfo[Modname][i] = k
					end
					IT.NotSmartTRSLAdding(Modname,tabl)
				end
				if langs and type(langs) == "table" then
					IT.ModInfo[Modname].languages = IT.ModInfo[Modname].languages or {}
					for i,k in pairs(langs) do
						IT.ModInfo[Modname].languages[i] = true
					end
				end
			end
		end
	   end
	end
--end

if not IT or (IT.Ver < ITver) then
	if IT then
		IT.RemoveTSRLCallback()
	else
		IT = {}
	end
	
	modname = ModName or "main"
	IT.Ver = ITver
	IT.Core = ModName
	ItemTranslate = IT
else
	LocalDeleteCallback()
end

if ItemTranslate and ItemTranslate.Core == ModName then
	InitFunctions()
end

return ItemTranslate	
end


--[[         	Example
	Supported languages: en, de, es, fr, jp, kr, ru, zh


local Collectibles = {
		[ItemID] = {   -- or Isaac.GetItemIdByName("Item Name")
			es = {"Nombre en español", "Descripción en español"},
			ru = {"Имя на русском","Описание на русском"},
		},
	}


local Trinkets = {
		[TrinketID] = { 
			es = {"Nombre en español", "Descripción en español"},
			ru = {"Имя на русском","Описание на русском"},
		},
	}
 

local Cards = {
		[CardName] = { 		--description is optional
			es = {"Nombre en español", "Descripción en español"},
			ru = {"Имя на русском"},
		},
	}


local Pills = {
		[PillName] = { 
			es = {"Nombre en español", "Descripción en español"},
			ru = {"Имя на русском","Описание на русском"},
		},
	}

local Birthrights = {
		[PlayerID] = { 
			es = "Descripción en español",
			ru = "Описание на русском",
		},
	}

	For a small number of items:

ItemTranslate.AddCollectiblesTranslation(Collectibles)
ItemTranslate.AddTrinketsTranslation(Trinkets)
ItemTranslate.AddCardTranslation(Cards)
ItemTranslate.AddPillsTranslation(Pills)
ItemTranslate.AddBirthrightsTranslation(Birthrights)

	For a large number of items is better to use this:

local ModTranslate = {
	['Collectibles'] = Collectibles,
	['Trinkets'] = Trinkets,
	['Cards'] = Cards,
	['Pills'] = Pills,
	['Birthrights'] = Birthrights,
}
local languages = { --is optional
	es = true,
	ru = true,
}

	The mod name must use lowercase letters
ItemTranslate.AddModTranslation("modname",ModTranslate,languages)   
	
]]