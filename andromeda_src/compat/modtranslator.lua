local Enums = require("andromeda_src.enums")
local ItemTrsl = include("andromeda_src.compat.ItemTranslate")
ItemTrsl("Andromeda") --Оригинальные переводы описаний: Goganidze

local C = {
	[Enums.Collectibles.GRAVITY_SHIFT] = {ru = {"Грави-Сдвиг", "Что поднимается, то и опускается"}},
	[Enums.Collectibles.SINGULARITY] = {ru = {"Сингулярность", "Бесконечные возможности"}},
	[Enums.Collectibles.EXTINCTION_EVENT] = {ru = {"Массовое Вымирание", "Небо падает!"}},
	[Enums.Collectibles.BOOK_OF_COSMOS] = {ru = {"Книга Вселенной", "Вселенная знаний"}},
	[Enums.Collectibles.THE_SPOREPEDIA] = {ru = {"Споропедия", "Вселенная существ"}},

	[Enums.Collectibles.JUNO] = {ru = {"Юнона", "Пока смерть не разлучит нас"}},
	[Enums.Collectibles.PALLAS] = {ru = {"Паллада", "Мудрость это сила"}},
	[Enums.Collectibles.CERES] = {ru = {"Церера", "Воспитывать и защищать"}},
	[Enums.Collectibles.VESTA] = {ru = {"Веста", "Вечный огонь"}},
	[Enums.Collectibles.CHIRON] = {ru = {"Хирон", "Раненый целитель"}},
	[Enums.Collectibles.OPHIUCHUS] = {ru = {"Змееносец", "Змеиные слёзы"}},
	[Enums.Collectibles.HARMONIC_CONVERGENCE] = {ru = {"Гармоничное Сближение", "Всё сходится"}},
	[Enums.Collectibles.LUMINARY_FLARE] = {ru = {"Вспышка Светила", "Палящее солнце"}},
	[Enums.Collectibles.BABY_PLUTO] = {ru = {"Плутоныш", "Вращается вокруг твоего сердца"}},
	[Enums.Collectibles.PLUTONIUM] = {ru = {"Плутоний", "Кто это не планета теперь?"}},
	[Enums.Collectibles.MEGA_PLUTONIUM] = {ru = {"Мега Плутоний", "???"}},
	[Enums.Collectibles.CELESTIAL_CROWN] = {ru = {"Корона Небосвода", "Повелитель вселенной"}},
	[Enums.Collectibles.STARBURST] = {ru = {"Звёздообразие", "Пуф!"}},
	--[Enums.Collectibles.CETUS] = {ru = {"Кит", "Скованные одной цепью, связанные одной целью"}},

	[Enums.Collectibles.ANDROMEDA_TECHNOLOGY] = {ru = {"Технология", "Лазерные слёзы"}},
	[Enums.Collectibles.ANDROMEDA_BRIMSTONE] = {ru = {"Сера", "Поток кровавого лазера"}},
	[Enums.Collectibles.ANDROMEDA_KNIFE] = {ru = {"Нож", "Режь Режь Режь"}},
	[Enums.Collectibles.ANDROMEDA_TECHX] = {ru = {"Технология X", "Кольцевые лазерные слёзы"}},
}

local T = {
	[Enums.Trinkets.STARDUST] = {ru = {"Звёздная Пыль", "Мерцает, как ясное ночное небо"}},
	[Enums.Trinkets.METEORITE] = {ru = {"Метеорит", "Откуда это взялось?"}},
	[Enums.Trinkets.CRYING_PEBBLE] = {ru = {"Плачущая Галька", "Судьба карликов"}},
	[Enums.Trinkets.MOON_STONE] = {ru = {"Лунный Камень", "Люминесцентная мудрость"}},
	[Enums.Trinkets.POLARIS] = {ru = {"Полярис", "Сияет в самый тёмный час"}},
	[Enums.Trinkets.SEXTANT] = {ru = {"Секстант", "Навигация в неизвестном"}},
	[Enums.Trinkets.ALIEN_TRANSMITTER] = {ru = {"Внеземной Передатчик", "Разработан не под вашу руку"}},
	[Enums.Trinkets.EYE_OF_SPODE] = {ru = {"Глаз Спория", "42"}},
}

local K = {
	[Enums.Cards.THE_UNKNOWN] = {ru = {"XXII - Неизвестен", "Безназванные ответы"}},
	[Enums.Cards.SOUL_OF_ANDROMEDA] = {ru = {"Душа Андромеды", "Дотянись до звёзд"}},
	[Enums.Cards.BETELGEUSE] = {ru = {"Бетельгейзе", "Супернова!"}},
	[Enums.Cards.SIRIUS] = {ru = {"Сириус", "Вечно яркий"}},
	[Enums.Cards.ALPHA_CENTAURI] = {ru = {"Альфа Центавра", "Звёздообразование"}},
}

local B = {
	[Enums.Characters.ANDROMEDA] = {ru = "Не-такое-уж-пустое Пространство"},
	[Enums.Characters.T_ANDROMEDA] = {ru = "Падая в пустоту"},
}

local ModTranslate = {
	['Collectibles'] = C,
	['Trinkets'] = T,
	['Cards'] = K,
	['Birthrights'] = B,
}
ItemTranslate.AddModTranslation("andromeda", ModTranslate, {ru = true})