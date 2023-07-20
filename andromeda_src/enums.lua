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
	THE_SPOREPEDIA = Isaac.GetItemIdByName("The Sporepedia"),
	--Passives
	OPHIUCHUS = Isaac.GetItemIdByName("​Ophiuchus"),
	CERES = Isaac.GetItemIdByName("Ceres"),
	JUNO = Isaac.GetItemIdByName("Juno"),
	PALLAS = Isaac.GetItemIdByName("Pallas"),
	VESTA = Isaac.GetItemIdByName("Vesta"),
	CHIRON = Isaac.GetItemIdByName("Chiron"),
	BABY_PLUTO = Isaac.GetItemIdByName("Baby Pluto"),
	PLUTONIUM = Isaac.GetItemIdByName("Plutonium"),
	MEGA_PLUTONIUM = Isaac.GetItemIdByName("Mega Plutonium"),
	HARMONIC_CONVERGENCE = Isaac.GetItemIdByName("Harmonic Convergence"),
	CELESTIAL_CROWN = Isaac.GetItemIdByName("Celestial Crown"),
	LUMINARY_FLARE = Isaac.GetItemIdByName("Luminary Flare"),
	STARBURST = Isaac.GetItemIdByName("Starburst"),
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
	MOONSTONE = Isaac.GetTrinketIdByName("Moon Stone"),  -- Legacy
	MOON_STONE = Isaac.GetTrinketIdByName("Moon Stone"),
	SEXTANT = Isaac.GetTrinketIdByName("Sextant"),
	ALIEN_TRANSMITTER = Isaac.GetTrinketIdByName("Alien Transmitter"),
	POLARIS = Isaac.GetTrinketIdByName("Polaris"),
	EYE_OF_SPODE = Isaac.GetTrinketIdByName("Eye of Spode"),
	ANDROMEDA_BIRTHCAKE = Isaac.GetTrinketIdByName("Andromeda's Cake"),
	T_ANDROMEDA_BIRTHCAKE = Isaac.GetTrinketIdByName("Tainted Andromeda's Cake"),
}

Enums.Cards = {
	THE_UNKNOWN = Isaac.GetCardIdByName("theunknown"),
	SOUL_OF_ANDROMEDA = Isaac.GetCardIdByName("soulofandromeda"),
	BETELGEUSE = Isaac.GetCardIdByName("betelgeuse"),
	SIRIUS = Isaac.GetCardIdByName("sirius"),
	ALPHA_CENTAURI = Isaac.GetCardIdByName("alphacentauri"),
}

Enums.Slots = {
	KEY_MASTER = 7,
	DONATION = 8,
	BOMB_BUM = 9,
	RESTOCK = 10,
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

Enums.Wisps = {
	NOTCHED_AXE_COAL = 65536,
	NOTCHED_AXE_IRON = 65537,
	NOTCHED_AXE_GOLD = 65538,
	NOTCHED_AXE_DIAMOND = 65539,
	NOTCHED_AXE_REDSTONE = 65540,
	JAR_OF_FLIES = 65545,
	FRIENDLY_BALL_EXPLOSIVE = 65547,
	FRIENDLY_BALL_BRIMSTONE = 65549,
	DELIRIOUS_MONSTRO = 655450,
	DELIRIOUS_DUKE_OF_FLIES = 655451,
	DELIRIOUS_LOKI = 655452,
	DELIRIOUS_HAUNT = 655453,
}

Enums.Effects = {
	GRAV_SHIFT_INDICATOR = Isaac.GetEntityVariantByName("Grav Shift Indicator"),
	BLACK_HOLE = Isaac.GetEntityVariantByName("Andromeda Black Hole"),
	LUMINARY_SUN = Isaac.GetEntityVariantByName("Luminary Flare"),
	PLANETARIUM_ICON = Isaac.GetEntityVariantByName("Planetarium Asteroid Icon"),
	ABDUCTION_BEAM = Isaac.GetEntityVariantByName("Abduction Beam"),
	STARBURST_TRAIL = Isaac.GetEntityVariantByName("Starburst Trail"),
	STARBURST_STAR_TRAIL = Isaac.GetEntityVariantByName("Starburst Star Trail"),
	TEAR_GLOW = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow"),
	TEAR_GLOW_WHITE = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (White)"),
	TEAR_GLOW_BLACK = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (Black)"),
	TEAR_GLOW_BLUE = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (Blue)"),
	TEAR_GLOW_RED = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (Strawberry)"),
	TEAR_GLOW_GREEN = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (Green)"),
	TEAR_GLOW_GRAY = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (Gray)"),
	TEAR_GLOW_BLOOD = Isaac.GetEntityVariantByName("Tainted Andromeda Tear Glow (Blood)"),
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

Enums.Dimensions = {
	DEATH_CERTIFICATE = 2,
}

return Enums
