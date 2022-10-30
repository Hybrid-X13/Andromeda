local Andromeda = require("andromeda_src.characters.andromeda")
local Singularity = require("andromeda_src.items.actives.singularity")
local TheUnknown = require("andromeda_src.items.cards.the_unknown")
local SoulOfAndromeda = require("andromeda_src.items.cards.soul_of_andromeda")
local Betelgeuse = require("andromeda_src.items.cards.betelgeuse")
local Sirius = require("andromeda_src.items.cards.sirius")
local AlphaCentauri = require("andromeda_src.items.cards.alpha_centauri")

local function MC_USE_CARD(_, card, player, flags)
	Andromeda.useCard(card, player, flags)
	
	Singularity.useCard(card, player, flags)
	
	TheUnknown.useCard(card, player, flags)
	SoulOfAndromeda.useCard(card, player, flags)
	Betelgeuse.useCard(card, player, flags)
	Sirius.useCard(card, player, flags)
	AlphaCentauri.useCard(card, player, flags)
end

return MC_USE_CARD