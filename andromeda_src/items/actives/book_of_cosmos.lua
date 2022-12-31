local Enums = require("andromeda_src.enums")
local CustomData = require("andromeda_src.customdata")
local game = Game()
local sfx = SFXManager()
local rng = RNG()

local list = CustomData.BookOfCosmosCopy

local names = {
	"Aries",
	"Cancer",
	"Leo",
	"Virgo",
	"Libra",
	"Scorpio",
	"Sagittarius",
	"Capricorn",
	"Aquarius",
	"Pisces",
	"Gemini",
	"Mercurius",
	"Venus",
	"Terra",
	"Mars",
	"Jupiter",
	"Saturnus",
	"Uranus",
	"Neptunus",
	"Pluto",
}

local Item = {}

local function ResetList()
	for i = 1, #CustomData.BookOfCosmosList do
		list[i] = CustomData.BookOfCosmosList[i]
	end
	
	names = {
		"Aries",
		"Cancer",
		"Leo",
		"Virgo",
		"Libra",
		"Scorpio",
		"Sagittarius",
		"Capricorn",
		"Aquarius",
		"Pisces",
		"Gemini",
		"Mercurius",
		"Venus",
		"Terra",
		"Mars",
		"Jupiter",
		"Saturnus",
		"Uranus",
		"Neptunus",
		"Pluto",
	}
end

function Item.useItem(item, rng, player, flags, activeSlot, customVarData)
	if item ~= Enums.Collectibles.BOOK_OF_COSMOS then return end
	
	if #list == 0 then
		ResetList()
	end

	local randNum = rng:RandomInt(#list) + 1
	local wisp = player:AddItemWisp(list[randNum], player.Position, true)
	wisp:GetData().isCosmoWisp = true
	
	if randNum > #names then
		local itemName = Isaac.GetItemConfig():GetCollectible(list[randNum]).Name
		game:GetHUD():ShowItemText(itemName)
	else
		game:GetHUD():ShowItemText(names[randNum])
		table.remove(names, randNum)
	end

	table.remove(list, randNum)
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
	
	return true
end

function Item.postNewRoom()
	local lemegetonWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)

	if #lemegetonWisps == 0 then return end

	for _, wisp in pairs(lemegetonWisps) do
		if wisp:GetData().isCosmoWisp then
			wisp:Kill()
			wisp:Remove()
		end
	end

	ResetList()
end

function Item.entityTakeDmg(target, amount, flags, source, countdown)
	local familiar = target:ToFamiliar()
		
	if familiar == nil then return end
	
	if familiar.Variant == FamiliarVariant.ITEM_WISP
	and familiar:GetData().isCosmoWisp
	then
		return false
	end
end

return Item