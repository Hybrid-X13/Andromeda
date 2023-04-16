local mod = ANDROMEDA

function mod:AddTrAndromeda()
	if not Epiphany or not Epiphany.API then return end

	Epiphany.API.AddCharacter({
		charName = "Tarnished Andromeda",
		charID = 1,
		costume = "no.anm2",
		menuGraphics = "gfx/ui/tarnished/menu_theeldritch.anm2",
		coopMenuSprite = "no.anm2",
		unlockChecker = function() return false end
	})
	mod:RemoveCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.AddTrAndromeda)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.AddTrAndromeda)