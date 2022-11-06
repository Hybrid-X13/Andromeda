local Enums = {}

Enums.Characters = {
	ANDROMEDA = Isaac.GetPlayerTypeByName("Andromeda", false),
	T_ANDROMEDA = Isaac.GetPlayerTypeByName("AndromedaB", true),
}

Enums.Collectibles = {
	--Actives
	GRAVITY_SHIFT = Isaac.GetItemIdByName("Gravity Shift"),
	SINGULARITY = Isaac.GetItemIdByName("Singularity"),
	EXTINCTION_EVENT = Isaac.GetItemIdByName("Extinction Event"),
	BOOK_OF_COSMOS = Isaac.GetItemIdByName("Book of Cosmos"),
	--Passives
	OPHIUCHUS = Isaac.GetItemIdByName("​Ophiuchus"),
	CERES = Isaac.GetItemIdByName("Ceres"),
	JUNO = Isaac.GetItemIdByName("Juno"),
	PALLAS = Isaac.GetItemIdByName("Pallas"),
	VESTA = Isaac.GetItemIdByName("Vesta"),
	CHIRON = Isaac.GetItemIdByName("Chiron"),
	BABY_PLUTO = Isaac.GetItemIdByName("Baby Pluto"),
	PLUTONIUM = Isaac.GetItemIdByName("Planet 10"),
	MEGA_PLUTONIUM = Isaac.GetItemIdByName("Planet 11"),
	HARMONIC_CONVERGENCE = Isaac.GetItemIdByName("Harmonic Convergence"),
	CELESTIAL_CROWN = Isaac.GetItemIdByName("Celestial Crown"),
	LUMINARY_FLARE = Isaac.GetItemIdByName("Luminary Flare"),
	--Andromeda Synergies
	ANDROMEDA_TECHX = Isaac.GetItemIdByName("Andromeda TechX"),
	ANDROMEDA_BRIMSTONE = Isaac.GetItemIdByName("Andromeda Brimstone"),
	ANDROMEDA_TECHNOLOGY = Isaac.GetItemIdByName("Andromeda Technology"),
	ANDROMEDA_KNIFE = Isaac.GetItemIdByName("Andromeda Knife"),
}

Enums.Trinkets = {
	STARDUST = Isaac.GetTrinketIdByName("Stardust"),
	METEORITE = Isaac.GetTrinketIdByName("Meteorite"),
	CRYING_PEBBLE = Isaac.GetTrinketIdByName("Crying Pebble"),
	MOONSTONE = Isaac.GetTrinketIdByName("Moonstone"),
	SEXTANT = Isaac.GetTrinketIdByName("Sextant"),
	ALIEN_TRANSMITTER = Isaac.GetTrinketIdByName("Alien Transmitter"),
	POLARIS = Isaac.GetTrinketIdByName("Polaris"),
}

Enums.Cards = {
	THE_UNKNOWN = Isaac.GetCardIdByName("theunknown"),
	SOUL_OF_ANDROMEDA = Isaac.GetCardIdByName("soulofandromeda"),
	BETELGEUSE = Isaac.GetCardIdByName("betelgeuse"),
	SIRIUS = Isaac.GetCardIdByName("sirius"),
	ALPHA_CENTAURI = Isaac.GetCardIdByName("alphacentauri"),
}

Enums.Slots = {
	WISP_WIZARD = Isaac.GetEntityVariantByName("Wisp Wizard"),
}

Enums.Familiars = {
	BABY_PLUTO = Isaac.GetEntityVariantByName("Baby Pluto"),
	PLUTONIUM = Isaac.GetEntityVariantByName("Plutonium"),
	MEGA_PLUTONIUM = Isaac.GetEntityVariantByName("Mega Plutonium"),
	CHARON = Isaac.GetEntityVariantByName("Charon"),
	NIX = Isaac.GetEntityVariantByName("Nix"),
	CELESTIAL_CROWN_STAR = Isaac.GetEntityVariantByName("Celestial Crown Star"),
	VESTA_FLAME = Isaac.GetEntityVariantByName("Vesta Flame"),
}

Enums.Effects = {
	GRAV_SHIFT_INDICATOR = Isaac.GetEntityVariantByName("Grav Shift Indicator"),
	BLACK_HOLE = Isaac.GetEntityVariantByName("Andromeda Black Hole"),
	LUMINARY_SUN = Isaac.GetEntityVariantByName("Luminary Flare"),
	PLANETARIUM_ICON = Isaac.GetEntityVariantByName("Planetarium Icon"),
}

Enums.Sounds = {
	ABDUCTION_BEAM = Isaac.GetSoundIdByName("AbductionBeam"),
	PLUTO_POWERUP = Isaac.GetSoundIdByName("PlutoPowerup"),
}

Enums.Voicelines = {
	SOUL_OF_ANDROMEDA = Isaac.GetSoundIdByName("SoulOfAndromeda"),
	BETELGEUSE = Isaac.GetSoundIdByName("Betelgeuse"),
	SIRIUS = Isaac.GetSoundIdByName("Sirius"),
	ALPHA_CENTAURI = Isaac.GetSoundIdByName("AlphaCentauri"),
}

Enums.Music = {
	EDGE_OF_THE_UNIVERSE = Isaac.GetMusicIdByName("AbandonedPlanetarium"),
}

return Enums