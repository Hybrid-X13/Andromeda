if EID then
	local Enums = require("andromeda_src.enums")

	EID:setModIndicatorName("Andromeda")
    EID:createTransformation("Spode", "Спорий", "ru")
    local SpodeIcon = Sprite()
    SpodeIcon:Load("gfx/ui/andromeda_eid.anm2", true)
    EID:addIcon("Spode", "ZealotIsaac", 42, 16, 16, -1, -3, SpodeIcon)
    local AbPlanIcon = Sprite()
    AbPlanIcon:Load("gfx/ui/andromeda_eid.anm2", true)
    EID:addIcon("AbPlanetarium", "Abandoned", 201216, 8, 9, 0, 2, AbPlanIcon)
    local WarningIcon = Sprite()
    WarningIcon:Load("gfx/ui/andromeda_eid.anm2", true)
    EID:addIcon("Warneeng", "Warning", 404, 8, 9, 3, 2, WarningIcon)
    local WarnengIcon = Sprite()
    WarnengIcon:Load("gfx/ui/andromeda_eid.anm2", true)
    EID:addIcon("Warneeng!", "SuperWarning", 404404404, 8, 9, 0, 2, WarnengIcon)
	local AndromedaIcon = Sprite()
    AndromedaIcon:Load("gfx/ui/andromeda_eid.anm2", true)
    EID:addIcon("Andromeda Mod", "ModName", 42, 0, 0, 3.5, 2, AndromedaIcon)
	local BetelgeuseFront = Sprite()
	BetelgeuseFront:Load("gfx/ui/andromeda_eid.anm2", true)
	local ACentauriFront = Sprite()
	ACentauriFront:Load("gfx/ui/andromeda_eid.anm2", true)
	local SiriusFront = Sprite()
	SiriusFront:Load("gfx/ui/andromeda_eid.anm2", true)
	local SoulAFront = Sprite()
	SoulAFront:Load("gfx/ui/andromeda_eid.anm2", true)
	local UnknownFront = Sprite()
	UnknownFront:Load("gfx/ui/andromeda_eid.anm2", true)
	EID:setModIndicatorIcon("Andromeda Mod")
    --[[for i = 1, #transformList do
        EID:assignTransformation("collectible", transformList[i], "Spode")
    end]]
	EID:addIcon("Card" .. Enums.Cards.BETELGEUSE, "Betelgeuse", -1, 9, 9, 0.5, 1.5, BetelgeuseFront)
	EID:addIcon("Card" .. Enums.Cards.ALPHA_CENTAURI, "Alpha Centauri", -1, 9, 9, 0.5, 1.5, ACentauriFront)
	EID:addIcon("Card" .. Enums.Cards.SIRIUS, "Sirius", -1, 9, 9, 0.5, 1.5, SiriusFront)
	EID:addIcon("Card" .. Enums.Cards.SOUL_OF_ANDROMEDA, "TheAbandoned", -1, 9, 9, 0.25, 2.5, SoulAFront)
	EID:addIcon("Card" .. Enums.Cards.THE_UNKNOWN, "TheUnknown", -1, 9, 9, 0.5, 1.5, UnknownFront)
	
	--Mimic charge info for cards/runes
	EID:addCardMetadata(Enums.Cards.THE_UNKNOWN, 3, false)
	EID:addCardMetadata(Enums.Cards.SOUL_OF_ANDROMEDA, 6, true)
	EID:addCardMetadata(Enums.Cards.BETELGEUSE, 12, true)
	EID:addCardMetadata(Enums.Cards.SIRIUS, 1, true)
	EID:addCardMetadata(Enums.Cards.ALPHA_CENTAURI, 6, true)

	--English EID
	EID:addBirthright(Enums.Characters.ANDROMEDA, "Grants the {{Spode}}{{ColorTransform}} Spode transformation{{ColorEIDText}} if you don't have it already#Using Gravity Shift in {{TreasureRoom}} Treasure rooms now turns it into a real#{{Blank}} {{Planetarium}} Planetarium#In Greed Mode, each shop has a Planetarium item for sale", "Andromeda")
	EID:addBirthright(Enums.Characters.T_ANDROMEDA, "Each tear fired creates an additional tear that starts from far away and is pulled in towards the black hole#Enemies can also be pulled in", "Tainted Andromeda")
	--Actives
	EID:addCollectible(Enums.Collectibles.SINGULARITY, "Upon use, spawns a random pickup or chest#All pickup variants and chests have an equal chance of spawning#10% chance to spawn an item from a random pool instead#{{Warneeng}} {{ColorYellow}}Only charges by collecting pickups and using consumables", "Singularity")
	EID:addCollectible(Enums.Collectibles.GRAVITY_SHIFT, "Upon use, causes all tears and projectiles to stop in midair, falling down after some time#Enemy projectiles that are stopped can't damage you and can damage other enemies", "Gravity Shift")
	EID:addCollectible(Enums.Collectibles.EXTINCTION_EVENT, "Upon use, causes meteors to fall from the sky for the duration of the current room#The meteors explode on impact, can burn enemies, and vary in damage, dealing up to 2x your current damage#Meteors and their explosions can't damage you", "Extinction Event")
	EID:addCollectible(Enums.Collectibles.BOOK_OF_COSMOS, "Summons a random Zodiac or Planetarium item wisp, granting you its effect#The wisp lasts for the current room", "Book of Cosmos")
	--Passives
	EID:addCollectible(Enums.Collectibles.OPHIUCHUS, "Chance to shoot a barrage of 5 tears that each deal a third of your damage#{{HalfSoulHeart}} Enemies killed by the barrage have a 5% chance to drop half a soul heart", "Ophiuchus")
	EID:addCollectible(Enums.Collectibles.CERES, "+1 coin, bomb, and key#Pickups have a 20% chance to be upgraded into a better variant#{{Collectible313}} Chance to gain a Holy Mantle shield when taking damage based on the total number of pickups you have", "Ceres")
	EID:addCollectible(Enums.Collectibles.PALLAS, "↑ Damage up for each new room explored#Special rooms give higher damage#10% of the damage gained becomes permanent when moving to the next floor#{{CurseLost}} Grants immunity to Curse of the Lost", "Pallas")
	EID:addCollectible(Enums.Collectibles.JUNO, "{{SoulHeart}} +1 Soul heart#{{Charm}} Enemies have a chance to revive as perma-charmed friendlies upon death#{{Charm}} Chance to shoot charming tears", "Juno")
	EID:addCollectible(Enums.Collectibles.VESTA, "{{Burning}} Jets of fire emit from you every 10 seconds, dealing your damage + 10 and burning enemies#The more enemies in the room, the more frequent the flames come out#Grants immunity to fire", "Vesta")
	EID:addCollectible(Enums.Collectibles.CHIRON, "{{EmptyHeart}} +1 Empty heart container#5% chance to heal for double the amount of damage taken#Each hit increases the chance of healing, after which resets back#{{SoulHeart}} Heals soul hearts as well#{{AngelDevilChance}} Taking red heart damage no longer decreases Angel/Devil deal chance", "Chiron")
	EID:addCollectible(Enums.Collectibles.BABY_PLUTO, "Orbiting familiar that blocks enemy projectiles#{{Collectible233}} Shoots Tiny Planet tears that deal 2 damage#Has a unique interaction with a peculiar stone", "Baby Pluto")
	EID:addCollectible(Enums.Collectibles.PLUTONIUM, "Familiar that orbits around you and shoots {{Collectible233}} Tiny Planet tears#Has a chance to also shoot rock tears#Blocks enemy projectiles#Passively gives a higher chance of finding runes and soul stones", "Plutonium")
	EID:addCollectible(Enums.Collectibles.MEGA_PLUTONIUM, "Familiar that orbits around you and shoots {{Collectible233}} Tiny Planet and {{Collectible592}} Terra tears#Blocks enemy projectiles#Passively gives an increased chance of finding runes and soul stones", "Mega Plutonium")
	EID:addCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE, "Each tear fired creates 4 additional tears that start from far away and converge toward you#The tears deal 1/4 of your damage but inherit any tear effects you have", "Harmonic Convergence")
	EID:addCollectible(Enums.Collectibles.CELESTIAL_CROWN, "Gives 4 star orbitals#Tears that pass through a star gain a random tear effect depending on its color#The color of each star changes per room", "Celestial Crown")
	EID:addCollectible(Enums.Collectibles.LUMINARY_FLARE, "Grants a sun that appears in the center of every room#Killing an enemy has a chance to make it shoot a powerful solar flare in a random direction#{{Burning}} Enemies that get near the sun are burned", "Luminary Flare")
	--Transformation contributions
	EID:assignTransformation("collectible", Enums.Collectibles.BOOK_OF_COSMOS, EID.TRANSFORMATION["BOOKWORM"])
	EID:assignTransformation("collectible", Enums.Collectibles.BABY_PLUTO, EID.TRANSFORMATION["CONJOINED"])
	EID:assignTransformation("collectible", Enums.Collectibles.PLUTONIUM, EID.TRANSFORMATION["CONJOINED"])
	EID:assignTransformation("collectible", Enums.Collectibles.MEGA_PLUTONIUM, EID.TRANSFORMATION["CONJOINED"])
	--Trinkets
	EID:addTrinket(Enums.Trinkets.STARDUST, "Killing an enemy has a chance to give a blue wisp#{{Shop}} Can be sold at a high price", "Stardust")
	EID:addTrinket(Enums.Trinkets.METEORITE, "Meteors will passively fall from the sky in uncleared rooms#Each meteor falls at a random position in the room, explodes on impact, can burn enemies, and varies in damage#Meteors and their explosions can't damage you", "Meteorite")
	EID:addTrinket(Enums.Trinkets.CRYING_PEBBLE, "↑ +0.35 Tears up for each astrological item you have", "Crying Pebble")
	EID:addTrinket(Enums.Trinkets.MOON_STONE, "{{Rune}} Chance for an extra rune or soul stone drop from opening chests, blowing up tinted rocks, and destroying slot machines#{{Rune}} Guarantees a rune/soul stone to appear in {{Planetarium}} Planetariums and {{AbPlanetarium}} Abandoned Planetariums#Has a unique interaction with a certain item", "Moon Stone")
	EID:addTrinket(Enums.Trinkets.SEXTANT, "{{Room}} Entering a new room has a chance to reveal more rooms that are nearby on the map#{{SecretRoom}} Can reveal Secret and Super Secret rooms#{{Planetarium}} Shows the location of the floor's Planetarium if there is one", "Sextant")
	EID:addTrinket(Enums.Trinkets.ALIEN_TRANSMITTER, "Enemies have a chance to be abducted by aliens", "Alien Transmitter")
	EID:addTrinket(Enums.Trinkets.POLARIS, "When a deal room doesn't appear after defeating the floor's boss, the boss item is turned into an angel item for sale or a devil deal#Taking a devil item this way won't lock you into devil deals", "Polaris")
	--Cards/runes
	EID:addCard(Enums.Cards.SOUL_OF_ANDROMEDA, "{{AbPlanetarium}} Teleports you to an Abandoned Planetarium", "Soul of Andromeda")
	EID:addCard(Enums.Cards.THE_UNKNOWN, "{{Card}} Activates a random tarot card effect, normal or reversed", "XXII - The Unknown")
	EID:addCard(Enums.Cards.BETELGEUSE, "{{Collectible483}} Creates a Mama Mega explosion in the current room", "Betelgeuse")
	EID:addCard(Enums.Cards.SIRIUS, "{{Battery}} Overcharges all your active items", "Sirius")
	EID:addCard(Enums.Cards.ALPHA_CENTAURI, "Consumes all items and pickups in the room#Each pickup has a 50% chance of turning into a random wisp#Pedestal items grant a permanent, unique wisp based on the quality of the item consumed", "Alpha Centauri")
	--Golden trinket effects
	EID:addGoldenTrinketMetadata(Enums.Trinkets.CRYING_PEBBLE, nil, 0.35, 3)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.METEORITE)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.MOON_STONE)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.SEXTANT)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.STARDUST)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.ALIEN_TRANSMITTER)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.POLARIS, "The item won't have a cost", 0, 2)

	--Русский EID
	EID:addBirthright(Enums.Characters.ANDROMEDA, "Даёт {{ColorTransform}}трансформацию#{{Blank}} {{ColorTransform}}Спория{{ColorEIDText}} {{Spode}}, если её нет#Использование Грави-Сдвига в#{{Blank}} {{TreasureRoom}} Сокровищницах теперь переносит вас в настоящий#{{Blank}} {{Planetarium}} Планетарий#В режиме Жадности, предмет Планетария всегда есть на продажу", "Андромеда", "ru")
	EID:addBirthright(Enums.Characters.T_ANDROMEDA, "Каждая выпущенная слеза создаёт еще одну, которая летит издалека прямо в Чёрную Дыру#Чёрная Дыра теперь засасывает врагов", "Порченый Андромеда", "ru")
	--Активки
	EID:addCollectible(Enums.Collectibles.SINGULARITY, "При активации создаёт случайный пикап, расходник или сундук#Имеет маленький шанс заспавнить предмет случайного пула#{{Warneeng}} {{ColorYellow}}Заряжается только подбирая пикапы или используя расходники", "Сингулярность", "ru")
	EID:addCollectible(Enums.Collectibles.GRAVITY_SHIFT, "При активации заставляет все выстрелы и слёзы замереть в воздухе, после падающие через несколько секунд#Остановленные вражеские выстрелы не наносят урон", "Грави-Сдвиг", "ru")
	EID:addCollectible(Enums.Collectibles.EXTINCTION_EVENT, "При активации, до конца текущей комнаты с неба начинают падать метеоры#Метеоры взрываются при падении, могут поджечь врагов, а также варьируются в уроне, максимум нанося двойной урон персонажа#Взрывы от метеоров не могут нанести урон персонажу#Метеоры и их взрывы не наносят урон игрокам", "Массовое Вымирание", "ru")
	EID:addCollectible(Enums.Collectibles.BOOK_OF_COSMOS, "Призывает случайный предметный огонёк Зодиака или Планетария, даруя его эффект#Огонёк пропадает после выхода из комнаты или по его уничтожению", "Книга Вселенной", "ru")
	--Пассивки
	EID:addCollectible(Enums.Collectibles.OPHIUCHUS, "Шанс стрельнуть рядом из 5 слёз#Каждая слеза в ряду наносит треть урона игрока#Враги убитые рядом слез имеют 5% шанс оставить {{HalfSoulHeart}} половину сердца души после смерти", "Змееносец", "ru")
	EID:addCollectible(Enums.Collectibles.CERES, "+1 монета, бомба, и ключ#Все сердца, монеты, бомбы, и ключи имеют 25% шанс заспавниться улучшенной версией себя#{{Collectible313}} Имеет шанс выдать единичную святую мантию после получения урона, основываясь на количестве пикапов", "Церера", "ru")
	EID:addCollectible(Enums.Collectibles.PALLAS, "↑ + Урон за каждую посещённую комнату#Особые комнаты дают больше урона#10% полученного урона остаётся навсегда при переходе на след. этаж#Бонус сбрасывается при переходе на следующий этаж#{{CurseLost}} Даёт иммунитет к Проклятию Потерянного", "Паллада", "ru")
	EID:addCollectible(Enums.Collectibles.JUNO, "{{SoulHeart}} +1 Сердце души#{{Charm}} Враги имеют шанс возродиться очарованными после смерти#{{Charm}} Шанс выстрелить чарующими слезами", "Юнона", "ru")
	EID:addCollectible(Enums.Collectibles.VESTA, "{{Burning}} Каждые 10 секунд персонаж выпускает струи огня, нанося урон персонажа + 10 и поджигая врагов#Чем больше врагов в комнате, тем чаще испускаются огни#Даёт иммунитет к огню", "Веста", "ru")
	EID:addCollectible(Enums.Collectibles.CHIRON, "{{EmptyHeart}} +1 Пустой контейнер сердца#5% шанс вылечиться на удвоенное кол-во полученного урона#Каждый полученный урон увеличивает шанс лечения, после чего сбрасывается#{{SoulHeart}} Также лечит сердца души #{{AngelDevilChance}} Урон в красные сердца больше не понижает сделку с ангелом/дьяволом", "Хирон", "ru")
	EID:addCollectible(Enums.Collectibles.BABY_PLUTO, "Фамильяр, который крутится вокруг вас и стреляет слёзы #{{Blank}} {{Collectible233}} Крошечной Планеты#Блокирует вражеские снаряды#Имеет особое взаимодействие со своеобразным камнем", "Плутоныш", "ru")
	EID:addCollectible(Enums.Collectibles.PLUTONIUM, "Фамильяр, который крутится вокруг вас и стреляет слёзы #{{Blank}} {{Collectible233}} Крошечной Планеты#Имеет шанс выстрелить каменными слезами#Блокирует вражеские снаряды#Пассивно увеличивает шанс на нахождение рун и камней душ", "Плутоний", "ru")
	EID:addCollectible(Enums.Collectibles.MEGA_PLUTONIUM, "Фамильяр, который крутится вокруг вас и стреляет слёзы #{{Blank}} {{Collectible233}} Крошечной Планеты и #{{Blank}} {{Collectible592}} Терры#Блокирует вражеские снаряды#Пассивно увеличивает шанс на нахождение рун и камней душ", "Мега Плутоний", "ru")
	EID:addCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE, "Каждая слеза создаёт 4 дополнительные слезы, которые летят издалека и сближаются к игроку#Слёзы наносят 1/4 урона персонажа и сохраняют эффекты слёз", "Гармоничное Сближение", "ru")
	EID:addCollectible(Enums.Collectibles.CELESTIAL_CROWN, "Даёт 4 звезды-орбитала#Слёзы, прошедшие через звёзды, получают случайный эффект, зависящий от цвета звезды#Цвет звёзд меняется при входе в комнату", "Корона Небосвода", "ru")
	EID:addCollectible(Enums.Collectibles.LUMINARY_FLARE, "Дарует светило в центре каждой комнаты#Убийство врага даёт шанс светилу выстрелить громадный луч в случайном направлении#{{Burning}} Враги проходящие возле светила загораются", "Вспышка Светила", "ru")
	--Брелоки
	EID:addTrinket(Enums.Trinkets.STARDUST, "После убийства врага есть шанс получить огонёк#{{Shop}} Может быть продана по высокой цене", "Звёздная Пыль", "ru")
	EID:addTrinket(Enums.Trinkets.METEORITE, "С каждой выстреленной слезой есть шанс призвать падающий метеор#Метеор падает в случайное место в комнате, взрывается при падении, может поджечь врагов, а также варьируется в уроне#Метеоры и их взрывы не наносят урон игрокам", "Метеорит", "ru")
	EID:addTrinket(Enums.Trinkets.CRYING_PEBBLE, "↑ + Скорострельность за каждый астрологический предмет", "Плачущая Галька", "ru")
	EID:addTrinket(Enums.Trinkets.MOON_STONE, "{{Rune}} Шанс на дополнительную руну или камень душ с сундуков, меченых камней и разрушения игровых автоматов#{{Rune}} Гарантирует доп. руну/камень души в {{Planetarium}} планетариях и {{AbPlanetarium}} заброшенных планетариях#Есть уникальный эффект с определённым предметом", "Лунный Камень", "ru")
	EID:addTrinket(Enums.Trinkets.SEXTANT, "При входе в комнату есть шанс показать ближайшие неизвестные комнаты на мини-карте#Может показать {{SecretRoom}} Секретные и {{SuperSecretRoom}} Супер Секретные комнаты#Показывает местоположение#{{Blank}} {{Planetarium}} Планетария, если он есть", "Секстант", "ru")
	EID:addTrinket(Enums.Trinkets.ALIEN_TRANSMITTER, "С некоторым шансом враги могут быть утащенны пришельцами", "Внеземной Передатчик", "ru")
	EID:addTrinket(Enums.Trinkets.POLARIS, "Если комната сделки после победы над боссом этажа не появляется, предмет босса заменяется либо на предмет ангела за деньги либо на сделку дьявола#Беря сделку дьявола таким образом вы не теряете шанс ангела", "Полярис", "ru")
	--Карты/руны
	EID:addCard(Enums.Cards.SOUL_OF_ANDROMEDA, "{{AbPlanetarium}} Телепортирует игрока в Заброшенный Планетарий", "Душа Андромеды", "ru")
	EID:addCard(Enums.Cards.THE_UNKNOWN, "{{Card}} Активирует эффект случайной карты таро (обычной или перевёрнутой)", "XXII - Неизвестен", "ru")
	EID:addCard(Enums.Cards.BETELGEUSE, "{{Collectible483}} Создаёт взрыв Мамы Меги в текущей комнате", "Бетельгейзе", "ru")
	EID:addCard(Enums.Cards.SIRIUS, "{{Battery}} Заряжает все ваши активные предметы на два заряда", "Сириус", "ru")
	EID:addCard(Enums.Cards.ALPHA_CENTAURI, "Поглощает все предметы и пикапы в комнате#Каждый поглощённый пикап имеет 50% шанс превратиться в огонёк#Поглощённые предметы гарантированно дают 5 случайных огоньков, основываясь на текущей комнате", "Альфа Центавра", "ru")

	--Chinese EID by 汐何/Saurtya
	EID:addBirthright(Enums.Characters.ANDROMEDA, "若角色未触发{{Spode}}{{ColorTransform}} Spode套装{{ColorEIDText}}效果，将获得{{Spode}}{{ColorTransform}} Spode套装{{ColorEIDText}}效果 #在 {{TreasureRoom}} 道具房使用第二主动将不再传送到 {{AbPlanetarium}} 遗弃星象房，而是传送到 {{Planetarium}} 星象房当中 #贪婪模式中，商店必定贩卖一个星象房道具", "Andromeda","zh_cn")
	EID:addBirthright(Enums.Characters.T_ANDROMEDA, "屏幕外将会额外生成眼泪往黑洞内部前进 #黑洞本身也可以将敌人拖入其中", "Tainted Andromeda","zh_cn")
	--Actives
	EID:addCollectible(Enums.Collectibles.SINGULARITY, "使用后，生成一个随机掉落物或箱子 #小概率从随机道具池中生成一个道具#{{Warning}} {{ColorYellow}}只能通过拾取掉落物获或使用卡牌等消耗品获得充能【掉落物仍能使用】#{{Warning}}{{Warning}}{{Warning}}若角色为堕化Andromeda，则会触发额外的特殊效果", "奇点","zh_cn")
	EID:addCollectible(Enums.Collectibles.GRAVITY_SHIFT, "使用后将会使房间里【自身】与【敌方】的眼泪悬停在半空中，然后原地缓缓降落 #受此影响的敌方眼泪不会伤害到你 #{{Warning}}{{Warning}}{{Warning}}若角色为Andromeda，则会触发额外的特殊效果", "斗转星移","zh_cn")
	EID:addCollectible(Enums.Collectibles.EXTINCTION_EVENT, "使用后，本房间内将会不断落下陨石 #陨石掉落时将会产生小范围爆炸，爆炸将会对敌人造成伤害并对敌人造成引燃效果，爆炸可摧毁房间内的石头 #陨石与其爆炸不会对角色造成伤害", "灭绝时刻","zh_cn")
	EID:addCollectible(Enums.Collectibles.BOOK_OF_COSMOS, "当前房间内获得一个星座道具或天体道具的 {{Collectible712}} 所罗门魔典火焰 #离开房间后消失", "宇宙之书","zh_cn")
	--Passives
	EID:addCollectible(Enums.Collectibles.OPHIUCHUS, "概率发射 5 颗连在一起的眼泪 #每颗眼泪都会造成你 1/3 的伤害 #被眼泪杀死的敌人有 5% 的几率掉落一个 {{HalfSoulHeart}} 半颗魂心", "蛇夫座","zh_cn")
	EID:addCollectible(Enums.Collectibles.CERES, "+1 {{Coin}}硬币，+1 {{Bomb}}炸弹，+1 {{Key}}钥匙 #所有的掉落物均有 25% 概率掉落更好的版本 #根据硬币，炸弹，钥匙的总数量，有概率在受伤的时候获得一层{{Collectible313}}神圣斗篷效果", "谷神星-色列斯","zh_cn")
	EID:addCollectible(Enums.Collectibles.PALLAS, "↑ 在每层中每清理一个房间攻击上升 # 特殊房间会上升更多 #进入到新的一层时，之前一层的10%加成将会永久保留 #{{CurseLost}}免疫迷途诅咒", "智神星-帕拉斯","zh_cn")
	EID:addCollectible(Enums.Collectibles.JUNO, "{{SoulHeart}} +1 魂心 #{{Charm}} 敌人死后有概率复活成为友方 #{{Charm}} 有概率发射魅惑眼泪", "婚神星-朱诺","zh_cn")
	EID:addCollectible(Enums.Collectibles.VESTA, "{{Burning}} 生成一个火焰跟班，进入房间后每10秒发射一次十字火焰对敌人造成伤害并灼烧敌人，伤害为角色伤害 +10 #房间内敌人越多，发射的间隔时间越短 #获得火焰免疫", "灶神星-维斯塔","zh_cn")
	EID:addCollectible(Enums.Collectibles.CHIRON, "{{EmptyHeart}} +1 空的心之容器 #受到伤害时 5% 概率获得双倍的治疗效果 #每受到一次伤害都会增加这个概率，触发效果后概率回到 5% #如果角色只有{{SoulHeart}}魂心/{{BlackHeart}}黑心或者血量恢复到{{Heart}}心之容器上限则转化为 {{SoulHeart}} 魂心 #{{Heart}}红心受到伤害减少时不再减少恶魔/天使房概率", "喀戎星-喀戎","zh_cn")
	EID:addCollectible(Enums.Collectibles.BABY_PLUTO, "在角色周围生成一个冥王星宝宝环绕物，发射 {{Collectible233}} 小小星球环绕眼泪 #阻挡敌人弹幕 #与{{Trinket" .. Enums.Trinkets.MOON_STONE .."}}\"月之石\"有特殊联动效果", "冥王星宝宝","zh_cn")
	EID:addCollectible(Enums.Collectibles.PLUTONIUM, "在角色周围生成一个Plant-10环绕物，发射 {{Collectible233}} 小小星球环绕眼泪 #有几率发射 {{Collectible592}} 地球岩石眼泪 #阻挡敌人弹幕 {{Blank}}【被动效果】增加找到符文和灵魂石的几率", "Plant-10","zh_cn")
	EID:addCollectible(Enums.Collectibles.MEGA_PLUTONIUM, "在角色周围生成一个超级Plant-10环绕物，发射 {{Collectible233}} 小小星球环绕眼泪和 {{Collectible592}} 地球岩石眼泪 #阻挡敌人弹幕 {{Blank}}【被动效果】增加找到符文和灵魂石的几率", "超级Plant-10","zh_cn")
	EID:addCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE, "发射眼泪时。屏幕外将会从4个方向额外以角色为中心发射眼泪【会以“+”形4方向和“x”形4方向进行循环】 #这些每个方向上的额外眼泪只会造成你 1/4 的伤害，但拥有你所有的眼泪特效", "谐波会聚","zh_cn")
	EID:addCollectible(Enums.Collectibles.CELESTIAL_CROWN, "在角色周围生成 4 个天体环绕物 #眼泪穿过不同颜色的环绕物时获得不同的随机效果 #每进入一个新房间时改变环绕物的颜色", "天神冠冕","zh_cn")
	EID:addCollectible(Enums.Collectibles.LUMINARY_FLARE, "房间中心生成一个太阳 #杀死敌人有一定几率使其向任意方向发射强大的太阳耀斑 #{{Burning}} 靠近太阳的敌人将会燃烧", "耀斑","zh_cn")
	--Trinkets
	EID:addTrinket(Enums.Trinkets.STARDUST, "携带该饰品时击杀敌人时有概率获得 {{Collectible584}} 美德之书火焰 #{{Shop}} 可以被高价卖出", "星尘","zh_cn")
	EID:addTrinket(Enums.Trinkets.METEORITE, "携带该饰品时发射眼泪时有概率召唤陨石", "陨石","zh_cn")
	EID:addTrinket(Enums.Trinkets.CRYING_PEBBLE, "↑ 携带该饰品时每有一个星象相关道具或者星座道具，{{Tears}} 射速都获得一次提升", "哭泣的鹅卵石","zh_cn")
	EID:addTrinket(Enums.Trinkets.MOON_STONE, "{{Rune}}携带该饰品时遇见符文与灵魂石的概率增加 #{{Rune}} 保证 {{Planetarium}} 星象房和 {{AbPlanetarium}} 遗弃星象房中必定出现一个符文或灵魂石 #与{{Collectible" .. Enums.Collectibles.BABY_PLUTO .."}} \"冥王星宝宝\"有特殊联动效果", "月之石","zh_cn")
	EID:addTrinket(Enums.Trinkets.SEXTANT, "携带该饰品时，进入房间后有概率揭露其周围的房间#可揭露 {{SecretRoom}} 隐藏房和 {{SuperSecretRoom}} 超级隐藏房 #显示当前层 {{Planetarium}} 星象房的位置，如果已经生成的话", "六分仪","zh_cn")
	EID:addTrinket(Enums.Trinkets.ALIEN_TRANSMITTER, "携带该饰品时敌人有概率被外星人捕捉", "外星通讯器","zh_cn")
	EID:addTrinket(Enums.Trinkets.POLARIS, "携带该饰品时清理完Boss房后若没有开启恶魔房与天使房，Boss道具将变成天使道具出售或恶魔交易 #以这种方式获得恶魔道具并不会让你陷入恶魔交易中", "北极星","zh_cn")
	--Cards/runes
	EID:addCard(Enums.Cards.SOUL_OF_ANDROMEDA, "{{AbPlanetarium}} 传送到当前层的 遗弃星象房", "Andromeda的灵魂石","zh_cn")
	EID:addCard(Enums.Cards.THE_UNKNOWN, "{{Card}} 触发随机一张塔罗牌或逆位塔罗牌的效果", "XXII-未知","zh_cn")
	EID:addCard(Enums.Cards.BETELGEUSE, "{{Collectible483}} 使用该符文后在当前房间触发一次 妈妈炸弹的大爆炸", "参宿四","zh_cn")
	EID:addCard(Enums.Cards.SIRIUS, "{{Battery}} 使用该符文后使当前主动处于额外充满的状态（即主动道具可以使用2次）", "天狼星","zh_cn")
	EID:addCard(Enums.Cards.ALPHA_CENTAURI, "使用该符文后消耗当前房间的所有掉落物和道具 #掉落物有 50% 概率转化为 {{Collectible584}} 美德之书火焰 #底座道具必定会被转化为 5 个 {{Collectible584}} 美德之书火焰", "阿尔法半人马座","zh_cn")

	--Korean EID by 미카/코하시와카바(kohashiwakaba)
	EID:addBirthright(Enums.Characters.ANDROMEDA, "{{Spode}} {{" .. EID.Config["TransformationColor"] .. "}}Spode 변신세트{{" .. EID.Config["TextColor"] .. "}}를 즉시 획득합니다.#{{TreasureRoom}}보물방에서의 {{Collectible" .. Enums.Collectibles.GRAVITY_SHIFT .. "}}Gravity Shift 사용 조건 만족 시 버려진 천체관이 아닌 {{Planetarium}}특수한 천체관으로 순간이동 합니다.#{{GreedModeSmall}} Greed 모드에서는 상점에 천체관 아이템을 판매합니다.", "Andromeda", "ko_kr")
	EID:addBirthright(Enums.Characters.T_ANDROMEDA, "공격할 때마다 랜덤 방향에서 블랙홀을 향해 추가 눈물을 발사합니다.#블랙홀이 적을 빨아들입니다.", "Tainted Andromeda", "ko_kr")
	--Actives
	EID:addCollectible(Enums.Collectibles.SINGULARITY, "사용 시 랜덤 픽업 및 상자를 소환합니다.#10% 의 확률로 랜덤 배열의 아이템을 소환합니다.#{{Warneeng}} {{ColorYellow}}방 클리어로 충전되지 않으며 픽업을 줍거나 카드/알약 사용 시에만 충전됩니다.", "특이점", "ko_kr")
	EID:addCollectible(Enums.Collectibles.GRAVITY_SHIFT, "사용 시 모든 캐릭터 및 적의 탄막을 멈춥니다.#멈춘 탄환은 잠시 후에 떨어지며 캐릭터에 피해를 주지 않습니다.", "중력 변화", "ko_kr")
	EID:addCollectible(Enums.Collectibles.EXTINCTION_EVENT, "사용 시 그 방에서 메테오를 떨어트립니다.#{{Burning}} 메테오가 땅에 충돌하면 폭발하며 공격력 x0~x2의 피해를 주며 화상을 입힙니다.#캐릭터는 메테오와 충돌 시 폭발의 피해를 받지 않습니다.", "대멸종", "ko_kr")
	EID:addCollectible(Enums.Collectibles.BOOK_OF_COSMOS, "사용 시 그 방에서 랜덤 별자리 혹은 천체관 아이템 불꽃을 소환합니다.#소환한 불꽃은 무적이나 방을 나가면 사라집니다.", "우주의 서", "ko_kr")
	--Passives
	EID:addCollectible(Enums.Collectibles.OPHIUCHUS, "15%의 확률로 5발의 공격력 x0.33의 눈물을 일렬로 발사합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 85 이상일 때 100% 확률#{{HalfSoulHeart}} 일렬로 발사한 눈물로 적 처치 시 5%의 확률로 소울하트 반칸을 드랍합니다.", "뱀주인자리", "ko_kr")
	EID:addCollectible(Enums.Collectibles.CERES, "{{Coin}}동전, {{Bomb}}폭탄, {{Key}}열쇠 +1#{{Heart}}/{{Coin}}/{{Bomb}}/{{Key}} 종류의 픽업 드랍 시 25%의 확률로 업그레이드됩니다.#{{HolyMantleSmall}} 피격 시 소지 중인 픽업의 양에 비례한 확률로 피해를 무시하는 보호막을 1회 제공합니다.", "케레스", "ko_kr")
	EID:addCollectible(Enums.Collectibles.PALLAS, "{{CurseLostSmall}} Lost 저주에 걸리지 않습니다.#↑ 새로운 방 입장 시마다 {{DamageSmall}}공격력 +0.2#↑ 새로운 특수방 입장 시마다 {{DamageSmall}}공격력 +0.4#↑ 새로운 {{Planetarium}}/{{SecretRoom}}/{{SuperSecretRoom}}/{{Library}} 입장 시마다 {{DamageSmall}}공격력 +0.6#스테이지 진입 시 이전 스테이지에서 올라간 공격력의 10%만 보존됩니다.", "팔라스", "ko_kr")
	EID:addCollectible(Enums.Collectibles.JUNO, "↑ {{SoulHeart}}소울하트 +1#{{Charm}} 10%의 확률로 적을 매혹시키는 공격이 나갑니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 27 이상일 때 100% 확률#{{Charm}} 적 처치 시 20%의 확률로 그 적을 아군으로 부활시킵니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 80 이상일 때 100% 확률", "주노", "ko_kr")
	EID:addCollectible(Enums.Collectibles.VESTA, "{{Burning}} 10초마다 십자 모양으로 캐릭터의 공격력 +10의 불길을 내뿜습니다.#적이 많을수록 불이 나오는 시간이 짧아집니다.#불에 피해를 입지 않습니다.", "베스타", "ko_kr")
	EID:addCollectible(Enums.Collectibles.CHIRON, "↑ {{EmptyHeart}}빈 최대 체력 +1#5%의 확률로 피해를 무시하며 피해를 입은 체력의 2배만큼 회복합니다.#체력이 꽉 찼을 경우 소울하트를 회복합니다.#회복되지 않을 경우 4.5%p의 확률이 추가로 증가하며 회복 시 초기화됩니다.#모든 피격에 대한 패널티에 면역#!!! {{Trinket" .. TrinketType.TRINKET_PERFECTION .. "}}Perfection 장신구를 보호해주지 않음#!!! {{Player30}}Tainted Eden : 무효과", "카이론", "ko_kr")
	EID:addCollectible(Enums.Collectibles.BABY_PLUTO, "캐릭터의 주위를 돌며 적의 탄환을 막아줍니다.#{{Collectible233}} 명왕성 주위를 도는 공격력 2의 눈물을 빠르게 발사합니다.#{{Trinket" .. Enums.Trinkets.MOON_STONE .. "}} 특정 장신구와 숨겨진 시너지가 있습니다.", "꼬마 명왕성", "ko_kr")
	EID:addCollectible(Enums.Collectibles.PLUTONIUM, "캐릭터의 주위를 돌며 적의 탄환을 막아줍니다.#{{Collectible233}} 플루토늄 주위를 도는 공격력 4의 눈물을 빠르게 발사하며 확률적으로 {{Collectible592}}돌덩이를 발사합니다.#{{Rune}} 상자를 열거나 색돌/기계류를 부술 때 확률적으로 룬/영혼석을 추가로 드랍합니다.#{{Planetarium}}천체관/{{AbPlanetarium}}버려진 천체관 최초 입장 시 {{Rune}}룬/영혼석을 반드시 드랍합니다.", "플루토늄", "ko_kr")
	EID:addCollectible(Enums.Collectibles.MEGA_PLUTONIUM, "캐릭터의 주위를 돌며 적의 탄환을 막아줍니다.#{{Collectible233}} 메가 플루토늄 주위를 도는 공격력 5의 {{Collectible592}}돌덩이을 빠르게 발사합니다.#{{Rune}} 연보라색 위성이 탄환을 막을 때마다 확률적으로 룬/영혼석을 드랍합니다.#{{Rune}} 상자를 열거나 색돌/기계류를 부술 때 확률적으로 룬/영혼석을 추가로 드랍합니다.#{{Planetarium}}천체관/{{AbPlanetarium}}버려진 천체관 최초 입장 시 {{Rune}}룬/영혼석을 반드시 드랍합니다.", "메가 플루토늄", "ko_kr")
	EID:addCollectible(Enums.Collectibles.HARMONIC_CONVERGENCE, "공격할 때마다 캐릭터를 향해 십자/X자 모양으로 공격력 x0.25의 눈물 4개를 추가로 발사합니다.", "조화로운 정렬", "ko_kr")
	EID:addCollectible(Enums.Collectibles.CELESTIAL_CROWN, "방 입장 시마다 랜덤한 4개의 색상의 별이 캐릭터의 주위를 돕니다.#공격이 통과하면 별의 색상에 따라 공격에 3종류의 특수 효과가 적용됩니다.", "천체 왕관", "ko_kr")
	EID:addCollectible(Enums.Collectibles.LUMINARY_FLARE, "방 중앙에 태양이 뜨게 됩니다.#적 처치 시 일정 확률로 태양이 랜덤 방향으로 최대 220의 피해를 주는 거대 빔을 발사합니다.#{{Burning}} 태양과 접촉한 적은 화상을 입습니다.", "발광체", "ko_kr")
	--Trinkets
	EID:addTrinket(Enums.Trinkets.STARDUST, "적 처치 시 10%의 확률로 Book of Virtues의 불꽃을 소환합니다.#!!! {{Shop}}상점에 해당 장신구를 드랍할 경우 니켈로 바뀝니다.", "우주진", "ko_kr")--Golden Trinket modifier for EID is required : (10/20/30)% chance, Nickel/Dime/Dime
	EID:addTrinket(Enums.Trinkets.METEORITE, "{{Collectible" .. Enums.Collectibles.EXTINCTION_EVENT .. "}} 주기적으로 메테오를 랜덤한 위치에 떨어트립니다.#{{Burning}} 메테오가 땅에 충돌하면 폭발하며 공격력 x0~x2의 피해를 주며 화상을 입힙니다.#캐릭터는 메테오와 충돌 시 폭발의 피해를 받지 않습니다.", "운석", "ko_kr")
	EID:addTrinket(Enums.Trinkets.CRYING_PEBBLE, "Spode 변신세트 아이템 소지 시 개당 {{TearsSmall}}연사가 0.35 증가합니다.", "슬픈 조약돌", "ko_kr")-- Marked as 'items that counts towards spode transformations', as crying pebble does not use 'stars' tag / Golden Trinket modifier for EID is required : (0.35/0.7/1.05) tears up
	EID:addTrinket(Enums.Trinkets.MOON_STONE, "{{Rune}} 상자를 열거나 색돌/기계류를 부술 때 10%의 확률로 룬/영혼석을 추가로 드랍합니다.#{{Planetarium}}천체관/{{AbPlanetarium}}버려진 천체관 최초 입장 시 {{Rune}}룬/영혼석을 반드시 드랍합니다.#{{Collectible" .. Enums.Collectibles.BABY_PLUTO .. "}} 특정 아이템과의 숨겨진 시너지가 있습니다.", "월석 조각", "ko_kr")
	EID:addTrinket(Enums.Trinkets.SEXTANT, "맵에 {{Planetarium}}천체관의 위치가 표시됩니다.#새로운 방 진입 시 10%의 확률로 캐릭터가 있는 방에서 2칸 이내에 있는 스테이지 구조 및 특수방/{{SecretRoom}}비밀방/{{SuperSecretRoom}}일급비밀방 맵에 표시합니다.", "육분의", "ko_kr")
	EID:addTrinket(Enums.Trinkets.ALIEN_TRANSMITTER, "적이 확률적으로 외계인에게 납치됩니다.", "외계 송신기", "ko_kr")
	EID:addTrinket(Enums.Trinkets.POLARIS, "!!! 보스방의 보스 처치 후 악마방/천사방의 문이 등장하지 않았을 경우:#그 층의 {{BossRoom}}보스방 보상이 동전 거래가 필요한 {{AngelRoom}}천사방 아이템이나 체력 거래가 필요한 {{DevilRoom}}악마방 아이템으로 대체됩니다.#해당 거래는 악마 거래로 취급되지 않습니다.", "폴라리스", "ko_kr")
	--Cards/runes
	EID:addCard(Enums.Cards.SOUL_OF_ANDROMEDA, "{{AbPlanetarium}} 버려진 천체관으로 순간이동합니다.", "안드로메다의 영혼", "ko_kr")
	EID:addCard(Enums.Cards.THE_UNKNOWN, "랜덤 타로 카드의 효과를 발동합니다.", "XXII - 알 수 없음", "ko_kr")
	EID:addCard(Enums.Cards.BETELGEUSE, "{{Collectible483}} 그 방에서 Mama Mega의 폭발을 일으킵니다.", "베텔게우스", "ko_kr")
	EID:addCard(Enums.Cards.SIRIUS, "액티브 아이템 충전량을 초과분까지 모두 충전합니다.#일반적인 충전이 불가능한 아이템도 강제로 충전할 수 있습니다.", "시리우스", "ko_kr")
	EID:addCard(Enums.Cards.ALPHA_CENTAURI, "방 안의 아이템 및 픽업 아이템을 제거합니다.#제거한 픽업 아이템 당 50%의 확률로 Book of Virtues의 기본 불꽃을 소환합니다.#제거한 아이템 당 현재 방에 따라 특수 불꽃을 5개씩 소환합니다.", "센타우루스자리 알파", "ko_kr")
	-- Golden Trinket modifiers. Korean data only, because English descriptions did not have exact effect or chance
	EID:addGoldenTrinketMetadata(Enums.Trinkets.METEORITE, "메테오 소환 빈도 증가", 0, 3, "ko_kr")
	EID:addGoldenTrinketMetadata(Enums.Trinkets.CRYING_PEBBLE, nil, {0.35}, 3, "ko_kr")
	EID:addGoldenTrinketMetadata(Enums.Trinkets.MOON_STONE, "특정 아이템과의 숨겨진 시너지가 강화됩니다.", {10}, 3, "ko_kr")
	EID:addGoldenTrinketMetadata(Enums.Trinkets.POLARIS, "바뀐 거래 아이템을 무료로 획득할 수 있습니다", 0, 2, "ko_kr") --Polaris (max 2x)
	EID:addGoldenTrinketMetadata(Enums.Trinkets.SEXTANT, nil, {10}, 3, "ko_kr")
	EID:addGoldenTrinketMetadata(Enums.Trinkets.STARDUST, "{{Shop}}상점에서 해당 장신구를 드랍할 경우 니켈 대신 다임으로 바뀝니다.", {10}, 3, "ko_kr")
	EID:addGoldenTrinketMetadata(Enums.Trinkets.ALIEN_TRANSMITTER, {"확률 2배", "확률 3배"}, 0, 3, "ko_kr")
end