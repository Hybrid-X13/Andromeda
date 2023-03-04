if Encyclopedia then
	local Enums = require("andromeda_src.enums")
	local SaveData = require("andromeda_src.savedata")
	local Functions = require("andromeda_src.functions")

	local Wiki = {
		ANDROMEDA = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Pocket Active: Gravity Shift"},
				{str = "Smelted Trinkets: Telescope Lens, Friendship Necklace"},
				{str = "Stats", clr = 3, halign = 0},
				{str = "HP: 3 Soul Hearts"},
				{str = "Speed: 1.00"},
				{str = "Tears: 2.73"},
				{str = "Damage: 3.60"},
				{str = "Range: 7.50"},
				{str = "Shotspeed: 0.60"},
				{str = "Luck: 0"},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "Andromeda can get more planetariums than any other character. The key to getting them is Gravity Shift."},
				{str = "In treasure rooms you have a choice. You can either pick up the item like normal, or you can use Gravity Shift to convert the treasure room into a new room type, known as an Abandoned Planetarium."},
				{str = "This room has a chance of containing a Zodiac item or a random reward layout."},
				{str = "Even though you might miss out on an item that floor, turning the treasure room into an Abandoned Planetarium increases your planetarium chance for the next floor."},
				{str = "The Abandoned Planetarium is Andromeda's only source of Zodiac items."},
				{str = "Collecting 4 Zodiac/Planetarium items grants Andromeda a new transformation, known as Spode."},
				{str = "Andromeda's shot speed can't be increased."},
			},
			{ -- Gravity Shift
				{str = "Gravity Shift", fsize = 2, clr = 3, halign = 0},
				{str = "Gravity Shift is Andromeda's starting pocket active. It stops all tears and projectiles in midair, making them fall straight down after some time. Any enemy projectiles that linger in the air can't damage you."},
				{str = "The item is also Andromeda's ticket to getting more planetariums. Using it in a treasure room turns it into a new room type that potentially has a Zodiac item."},
				{str = "Basically, it lets you trade bad treasure rooms for other rewards + planetarium chance."},
				{str = "That's not all. Other special rooms can be shifted in order to gain benefits from them when you otherwise might've not gained anything."},
				{str = "Shops: Replaces all shop items with a 30 cent item from the treasure room pool if you haven't purchased anything."},
				{str = "Angel: Converts all items in the room into 2 Bible wisps if you didn't pick up any of the items."},
				{str = "Devil: Converts all items in room that cost hearts into 3 Book of Belial wisps, but also removes a full soul heart for each item converted. This can kill you."},
				{str = "Secret: Each pickup in the room has a 50% chance of being converted into a normal wisp. Pedestal items are guaranteed to be converted into 5 wisps."},
				{str = "Super Secret: Same as regular secret rooms but instead of normal wisps you gain random wisps."},
				{str = "Planetariums: Each item is converted into a random Lemegeton wisp. 4 treasure room items will also appear but only 1 can be taken."},
			},
			{ -- Transformation
				{str = "Spode", fsize = 2, clr = 3, halign = 0},
				{str = "Collecting 4 Zodiac/Planetarium items as Andromeda (or 3 for all other characters) grants the Spode transformation."},
				{str = "While your tears are in flight, they have a chance to spawn additional tears that deal one fourth of your damage."},
				{str = "The tears can fly over obstacles, home in on enemies, and retain any other tear effects you have."},
				{str = "The transformation also grants flight and -0.4 shot speed down."},
				{str = "It can be unlocked for all characters by getting full completion as normal Andromeda."},
				{str = "Spode is a reference to the game Spore, which is about creating a creature and bringing it from a single cell all the way to a sentient space-faring empire. In it there's a deity called Spode, which is thought to be the creator of all these creatures and everything in the universe."},
				{str = "The transformation's appearance is also a reference to the very first creation made in Spore, known as the debug squid."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Grants the Spode transformation if you don't have it already."},
				{str = "Using Gravity Shift in treasure rooms now turns it into a real Planetarium."},
				{str = "In Greed Mode, each shop has a Planetarium item for sale."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "The Andromeda galaxy is a barred spiral galaxy approximately 2.5 million light years from Earth and is the closest large galaxy to the Milky Way."},
				{str = "Andromeda is about 25%-50% larger than the Milky Way and contains about twice as many stars."},
				{str = "The Milky Way and Andromeda are expected to collide in about 4.5 billion years, merging into one giant elliptical galaxy."},
				{str = "The Andromeda galaxy is named after princess Andromeda, the daughter of king Cepheus and queen Cassiopeia in Greek mythology."},
				{str = "The myth goes that Cassiopeia angered Poseidon and the sea nymphs by claiming to be more beautiful than them. So as punishment, her daughter Andromeda was chained to a rock to be devoured by the sea monster Cetus. Perseus was on his way home after slaying Medusa when he saw this and saved Andromeda by killing the sea monster."},
				{str = "Andromeda's third eye never closes. They know all the secrets of the universe."},
			},
		},
		ANDROMEDA_B = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Pocket Active: Singularity"},
				{str = "Stats", clr = 3, halign = 0},
				{str = "HP: 3 Black Hearts"},
				{str = "Speed: 0.90"},
				{str = "Tear Rate: 3.33"},
				{str = "Damage: 4.20"},
				{str = "Range: 6.50"},
				{str = "Shot Speed: 1.60"},
				{str = "Luck: 0"},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "As Tainted Andromeda, items don't appear naturally in rooms. Instead, Singularity spawns an item from the current room's pool and is the character's main source of items. Items can still be found from chests, beggars, machines, etc."},
				{str = "Tainted Andromeda also has a unique way of shooting tears. They're shot out from the black hole in the center of the room and will curve towards where Tainted Andromeda is standing."},
				{str = "Taking damage has a 5% chance to absorb any held trinkets, similar to the Marbles effect. When this happens, 1 charge is also added to Singularity for each trinket consumed."},
			},
			{ -- Singularity
				{str = "Singularity", fsize = 2, clr = 3, halign = 0},
				{str = "Since items don't appear naturally in rooms, Singularity will be your main source of items."},
				{str = "It can only be charged by collecting pickups and using consumables, but is also fully charged past its maximum when clearing the floor's boss room, allowing you to use it in the boss room, an angel or devil room that appeared, or anywhere else on the floor."},
				{str = "Since Singularity spawns an item from the current room's pool, you have the ability to choose where to get your items from. There are some limitations however."},
				{str = "Each time you use Singularity in a secret room, the chance for it to spawn an item in there is cut in half. For example, the first time is 100%, the 2nd time is 50%, the 3rd use is 25%, etc. This decreasing chance is present throughout the whole run."},
				{str = "For Planetariums, using Singularity in there for the first time will spawn a Planetarium item, but it'll also transform the room into an abandoned planetarium. Further uses of Singularity in the room has a decreasing chance to spawn a zodiac item, similar to how secret rooms work. Otherwise it spawns a random pickup or chest."},
				{str = "All other rooms don't have restrictions."},
				{str = "Items spawned in devil rooms and shops won't cost hearts or coins."},
				{str = "Treasure rooms don't appear naturally for Tainted Andromeda, but Singularity will spawn a treasure room item when used in any default room."},
				{str = "After depths, Singularity will only be able to spawn items in certain special rooms. Using it anywhere else will instead spawn a random pickup or chest, but there's still a 10% chance for it to spawn an item from a random pool."},
				{str = "Beyond the womb, Singularity will no longer be recharged by clearing boss rooms and you won't be able to spawn boss items in them anymore."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Each tear fired creates an additional tear that starts from far away and is pulled in towards the black hole."},
				{str = "Enemies can also be pulled in."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "When a massive star dies, it collapses onto itself and becomes a black hole."},
				{str = "Supermassive black holes are also present at the center of most galaxies."},
				{str = "Even though nothing can escape a black hole's gravitational pull, Tainted Andromeda has the ability to eject light and matter from them."},
			},
		},
		GRAVITY_SHIFT = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Causes all tears and projectiles to stop in midair, falling down after some time."},
				{str = "Enemy projectiles that are stopped can't damage you and can damage other enemies."},
				{str = "This item has additional effects when used by Andromeda. See the character page for more info."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Car Battery", clr = 3, halign = 0},
				{str = "Tears/projectiles linger in the air for longer."},
				{str = "Book of Virtues", clr = 3, halign = 0},
				{str = "Spawns a stationary gravitational field that can't shoot but causes all enemy projectiles that get near it to stop in midair. Only one of these can exist at a time and it does not persist between rooms."},
			},
		},
		EXTINCTION_EVENT = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Causes meteors to fall from the sky for the duration of the current room."},
				{str = "The meteors explode on impact, can burn enemies, and vary in damage, dealing up to 2x your current damage."},
				{str = "Meteors and their explosions can't damage you."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Car Battery", clr = 3, halign = 0},
				{str = "Meteors fall more frequently."},
				{str = "Book of Virtues", clr = 3, halign = 0},
				{str = "Spawns a rock wisp that shoots fire mind tears which vary in damage."},
			},
		},
		CELESTIAL_CROWN = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Gives 4 star orbitals."},
				{str = "Tears that pass through a star gain a random tear effect depending on its color."},
				{str = "The color of each star changes per room."},
				{str = "Possible colors and effects:"},
				{str = "- Red: Rotten tomato, petrify, burstsplit (like Haemolacria)"},
				{str = "- Orange: Fire mind, knockout drops, the parasite"},
				{str = "- Yellow: Acid, confusion, coin tears"},
				{str = "- Blue: Ice, jacob's ladder, god's flesh"},
				{str = "- White: Spectral, slowing, rubber cement"},
				{str = "- Purple: Homing, fear, charm"},
				{str = "- Green: Poison, mysterious liquid, booger"},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Each tear can only gain up to 1 extra effect, even if it passes through multiple stars of different colors."},
				{str = "Has no effect on lasers, knives, or melee weapons."},
			},
		},
		BABY_PLUTO = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Orbiting familiar that blocks enemy projectiles."},
				{str = "Shoots Tiny Planet tears that deal 2 damage."},
				{str = "Does not deal contact damage."},
				{str = "Has a unique interaction with a peculiar stone."},
			},
		},
		HARMONIC_CONVERGENCE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Each tear fired creates 4 additional tears that start from far away and converge toward you."},
				{str = "The tears deal 1/4 of your damage but inherit any tear effects you have."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Lasers", clr = 3, halign = 0},
				{str = "Each tear deals your full damage when a laser is fired (excluding tech lasers)."},
				{str = "Epic Fetus", clr = 3, halign = 0},
				{str = "Each tear deals your full damage when a rocket explodes."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Overridden by the Ludovico Technique and Mom's Knife."},
			},
		},
		JUNO = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "+1 Soul heart."},
				{str = "Enemies have a chance to revive as perma-charmed friendlies upon death."},
				{str = "Chance to shoot charming tears (scales with luck)."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Juno is one of the 4 major asteroids in our solar system, named after the Roman goddess of marriage. Juno was the wife of Jupiter."},
				{str = "This item's description and effect are a reference to the wedding vow: Until death do us part."},
				{str = "The item's costume took some inspiration from the Rebekah mod."},
			},
		},
		PALLAS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Damage up for each new room explored."},
				{str = "Special rooms give higher damage."},
				{str = "10% of the damage gained becomes permanent when moving to the next floor."},
				{str = "Grants immunity to Curse of the Lost."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Pallas is the 3rd largest asteroid in our solar system and was named after the Roman goddess of wisdom, war, and art."},
			},
		},
		OPHIUCHUS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Chance to shoot a barrage of 5 tears that each deal a third of your damage."},
				{str = "Enemies killed by the barrage have a 5% chance to drop half a soul heart upon death."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Overridden by weapon types that aren't tears."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Ophiuchus is a constellation represented as a man grabbing a snake, and is sometimes considered to be the 13th Zodiac sign."},
				{str = "The name Ophiuchus comes from an ancient Greek word meaning serpent-bearer."},
				{str = "The purple shimenawa costume the item gives represents Orochimaru from Naruto, who always wears a purple shimenawa as his belt."},
			},
		},
		BOOK_OF_COSMOS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Summons a random Zodiac or Planetarium item wisp, granting you its effect."},
				{str = "The wisp is invincible and lasts for the current room."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Book of Virtues", clr = 3, halign = 0},
				{str = "Spawns a star wisp that shoots homing stars."},
			},
		},
		THE_SPOREPEDIA = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Spawn a random co-op baby for the room that has a random tear effect, similar to Buddy In a Box."},
				{str = "This item is an easter egg and has a 2.5% chance of replacing Book of Cosmos when it spawns, which is the only way it can be obtained."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Spode Transformation", clr = 3, halign = 0},
				{str = "Spawn an additional familiar."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Book of Virtues", clr = 3, halign = 0},
				{str = "Spawns a wisp that has a random tear effect. This is the same wisp spawned by Monster Manual."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item is a reference to the game Spore, which is a game that lets you create your own creatures, buildings, vehicles, and more."},
				{str = "The Sporepedia is a collection of every published Spore creation."},
				{str = "Each bookmark seen on the sprite represents the game's DLCs. The red one is for the Creepy & Cute parts pack and the orange one represents Galactic Adventures."},
			},
		},
		LUMINARY_FLARE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Grants a sun that appears in the center of every room."},
				{str = "Killing an enemy has a chance to make it shoot a powerful solar flare in a random direction."},
				{str = "Enemies that get near the sun are burned."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "A solar flare is an eruption of electromagnetic radiation in the sun's atmosphere."},
				{str = "Solar flares that are strong enough can sometimes cause radio frequencies to completely black out."},
			},
		},
		SINGULARITY = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Spawns a random pickup or chest."},
				{str = "All pickup variants and chests have an equal chance of spawning."},
				{str = "Has a 10% chance to spawn an item from a random pool instead."},
				{str = "Only charges by collecting pickups and using consumables."},
				{str = "This item can be overcharged by default."},
			},
			{ -- Charging Method
				{str = "Charging", fsize = 2, clr = 3, halign = 0},
				{str = "Clearing rooms and batteries don't charge Singularity. Instead, it charges by collecting pickups and using consumables. Here are the exact number of charges each type of pickup/conumable adds:"},
				{str = "Skeleton Key/Pyro/A Dollar", clr = 3, halign = 0},
				{str = "Overcharges Singularity on pickup."},
				{str = "A Quarter", clr = 3, halign = 0},
				{str = "Adds 12 charges on pickup."},
				{str = "Boom!", clr = 3, halign = 0},
				{str = "Adds 10 charges."},
				{str = "Void/Abyss", clr = 3, halign = 0},
				{str = "Adds 6 charges if any items were consumed."},
				{str = "Black Rune/Alpha Centauri", clr = 3, halign = 0},
				{str = "Adds 6 charges if any items/pickups were consumed."},
				{str = "Charged Keys/Giga Bombs/Horse 48 Hour Energy", clr = 3, halign = 0},
				{str = "Adds 4 charges."},
				{str = "Golden Keys and Bombs/Eternal Hearts/Dimes/Lucky Pennies", clr = 3, halign = 0},
				{str = "Adds 3 charges."},
				{str = "Horse Pills", clr = 3, halign = 0},
				{str = "Adds 2 charges on use."},
				{str = "Golden Horse Pill", clr = 3, halign = 0},
				{str = "50% chance to add 2 charges on use."},
				{str = "Nickels/Doublepacks/48 Hour Energy", clr = 3, halign = 0},
				{str = "Adds 2 charges."},
				{str = "Smelter/Gulp Pills", clr = 3, halign = 0},
				{str = "Adds 1 additional charge for each trinket consumed."},
				{str = "Golden Pills", clr = 3, halign = 0},
				{str = "50% chance to add 1 charge on use."},
				{str = "Golden Pennies", clr = 3, halign = 0},
				{str = "50% chance to add 1 charge."},
				{str = "All Other Pickups/Consumables", clr = 3, halign = 0},
				{str = "Adds 1 charge."},
				{str = "-Vurp pills, Ancient Recall, and golden hearts don't add any charges to Singularity."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Book of Virtues", clr = 3, halign = 0},
				{str = "Spawns a black wisp that has a 5% chance to shoot an occular rift tear. Also activates a weaker Singularity effect when destroyed, spawning a random pickup."},
				{str = "The following synergies only occur when Singularity spawns a pedestal item:"},
				{str = "There's Options", clr = 3, halign = 0},
				{str = "Spawns 2 items in the boss room but only one can be taken."},
				{str = "More Options", clr = 3, halign = 0},
				{str = "Spawns 2 items in treasure/default rooms but only one can be taken."},
				{str = "Car Battery/Damocles", clr = 3, halign = 0},
				{str = "Spawns 2 items and both can be taken."},
				{str = "Devil's Crown", clr = 3, halign = 0},
				{str = "Spawns a devil item in red treasure rooms that costs health. Golden versions/Mom's Box reduces the heart cost."},
				{str = "Adoption Papers", clr = 3, halign = 0},
				{str = "Spawns an item from the baby pool in shops. Dropping the trinket lets you spawn shop items again."},
				{str = "Golden Horse Shoe", clr = 3, halign = 0},
				{str = "15% chance to spawn 2 choice items in treasure/default rooms. The chance increases if you have a golden variant/Mom's Box."},
				{str = "Charging Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "PHD/False PHD", clr = 3, halign = 0},
				{str = "Good/bad pills add double the amount of charges."},
				{str = "Tarot Cloth", clr = 3, halign = 0},
				{str = "Cards that are buffed add an extra charge."},
				{str = "Apple of Sodom", clr = 3, halign = 0},
				{str = "Allows you to charge Singularity with red hearts even if you're full on health or you only have soul/black hearts."},
				{str = "Charged Penny", clr = 3, halign = 0},
				{str = "All coins have a chance to add an additional charge."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Battery Pickups", clr = 3, halign = 0},
				{str = "Batteries are the only pickups that don't add charges to Singularity."},
				{str = "4.5 Volt", clr = 3, halign = 0},
				{str = "Singularity will still charge by collecting pickups/using consumables rather than charging by damage dealt."},
				{str = "9 Volt", clr = 3, halign = 0},
				{str = "9 Volt won't fully charge Singularity on pickup."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "The singularity of a black hole is its center point, where density and gravity become infinite and the laws of physics as we know them cease to exist."},
			},
		},
		CERES = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "+1 coin, bomb, and key"},
				{str = "Pickups have a 20% chance to be upgraded into a better variant."},
				{str = "Chance to gain a holy mantle shield when taking damage based on the total number of pickups you have."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "Pickups sold in the shop can also be upgraded and they'll still sell for their original price."},
				{str = "Pickups can be upgraded more than once. For example, a penny can be upgraded into a nickel, but of course this has a much lower chance of happening."},
				{str = "The following shows what each pickup can be converted into:"},
				{str = "Hearts", clr = 3, halign = 0},
				{str = "Half red -> Full red -> Doublepack"},
				{str = "Half soul -> Soul -> Black"},
				{str = "Coins", clr = 3, halign = 0},
				{str = "Penny -> Doublepack -> Nickel -> Dime -> Lucky penny -> Golden penny"},
				{str = "Sticky nickel -> Nickel"},
				{str = "Bombs", clr = 3, halign = 0},
				{str = "Normal -> Doublepack -> Golden -> Giga (only if you currently have a golden bomb)"},
				{str = "Keys", clr = 3, halign = 0},
				{str = "Normal -> Doublepack -> Charged -> Golden -> Cracked key (only if you currently have a golden key)"},
				{str = "Batteries", clr = 3, halign = 0},
				{str = "Micro -> Normal -> Mega -> Golden"},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Ceres is the largest object in the asteroid belt, classified as a dwarf planet and asteroid."},
				{str = "It was named after the Roman goddess of agriculture and motherhood."},
				{str = "The symbol of Ceres resembles a sickle, which is typically used for harvesting crops."},
			},
		},
		VESTA = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Jets of fire emit from you every 10 seconds, dealing your damage + 10 and burning enemies."},
				{str = "The more enemies in the room, the more frequent the flames come out."},
				{str = "Grants immunity to fire."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "The 2nd largest asteroid in our solar system, Vesta was named after the Roman goddess of the hearth, home, and family."},
				{str = "She was often represented by the sacred fire of her temple."},
			},
		},
		CHIRON = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "+1 Empty heart container"},
				{str = "5% chance to heal for double the amount of damage taken."},
				{str = "Each hit increases the chance of healing by 4.5%."},
				{str = "When the effect triggers, the chance resets back to 5%."},
				{str = "Soul hearts are added if the amount healed exceeds your total red health or if you only have soul/black hearts."},
				{str = "Taking red heart damage no longer decreases angel/devil deal chance."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Chiron is a minor planet located in the asteroid belt."},
				{str = "In Greek mythology, Chiron was a centaur famous for his knowledge of medicine."},
				{str = "In astrology, Chiron represents a person's inner wounds and their ability to heal and overcome them."},
			},
		},
		CRYING_PEBBLE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "+0.35 Tears up for each astrological item you have."},
				{str = "The items that count are all Zodiac and Planetarium items, Baby Pluto, and Book of Cosmos."},
				{str = "Lemegeton wisps of the above items also grant a tears up."},
			},
		},
		METEORITE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Meteors will passively fall from the sky in uncleared rooms."},
				{str = "Each meteor falls at a random position in the room, explodes on impact, can burn enemies, and varies in damage."},
				{str = "Meteors and their explosions can't damage you."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "The difference between a meteor and a meteorite is that a meteor burns up in the Earth's atmosphere before it can reach the ground while meteorites successfully land on Earth."},
			},
		},
		STARDUST = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Killing an enemy has a chance to give a blue wisp."},
				{str = "Can be sold at a high price."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item's secondary effect is a reference to the stardust item from Pokemon."},
			},
		},
		ALIEN_TRANSMITTER = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Enemies have a chance to be abducted by aliens."},
			},
		},
		MOON_STONE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Chance for an extra rune or soul stone drop from opening chests, blowing up tinted rocks, and destroying slot machines."},
				{str = "Guarantees a rune/soul stone to appear in Planetariums and Abandoned Planetariums."},
				{str = "Has a unique interaction with a certain item."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "This item is a reference to moon stones from Pokemon."},
			},
		},
		POLARIS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "When a deal room doesn't appear after defeating the floor's boss, the boss item is turned into an angel item for sale or a devil deal."},
				{str = "Taking a devil item this way won't lock you into devil deals."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Mom's Box/Golden Variant", clr = 3, halign = 0},
				{str = "The item won't have a cost."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Polaris, also known as the North Star, is famous for appearing at roughly the same spot in the night sky at the north celestial pole."},
				{str = "It's often used for navigation since you'll always know that Polaris is due north and it's visible to the naked eye."},
				{str = "Polaris is a triple star system and is part of the Ursa Minor constellation, also known as the Little Dipper."},
			},
		},
		SEXTANT = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Entering a new room has a chance to reveal more rooms that are nearby on the map."},
				{str = "Can reveal Secret and Super Secret rooms."},
				{str = "Shows the location of the floor's Planetarium if there is one."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "A sextant is a tool used in navigation for measuring the angle between the horizon and a celestial body to determine latitude and longitude."},
			},
		},
		BETELGEUSE = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Creates a Mama Mega explosion in the current room."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Betelgeuse is a red supergiant and is one of the largest stars visible to the naked eye."},
				{str = "It's the 10th brightest star in the night sky."},
				{str = "It's possible that Betelgeuse is very close to the end of its life cycle, and it'll go supernova when it dies."},
			},
		},
		ALPHA_CENTAURI = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Consumes all items and pickups in the room."},
				{str = "Each pickup has a 50% chance of turning into a random wisp."},
				{str = "Pedestal items grant a permanent star wisp that has a unique effect based on the quality of the item consumed:"},
				{str = "- Quality 0: A white star wisp that blocks projectiles but can't shoot or deal contact damage."},
				{str = "- Quality 1: A red star wisp that blocks projectiles and deals contact damage but can't shoot."},
				{str = "- Quality 2: An orange star wisp that blocks projectiles, deals contact damage, and shoots tears that deal 3 damage."},
				{str = "- Quality 3: A blue star wisp that blocks projectiles, deals contact damage, and shoots homing tears that deal 3 damage."},
				{str = "- Quality 4: A yellow star wisp that blocks projectiles, deals contact damage, shoots homing star tears that deal 3 damage, and tears shot by the wisp have a chance to spawn additional homing star tears (similar to Spode)."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Alpha Centauri is a triple star system and is the closest solar system to ours, about 4.2 light years away."},
			},
		},
		SIRIUS = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Overcharges all your active items."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Sirius is a binary star and is the brightest star in the night sky."},
			},
		},
		SOUL_OF_ANDROMEDA = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Teleports you to an Abandoned Planetarium."},
			},
		},
		THE_UNKNOWN = {
			{ -- Effect
				{str = "Effect", fsize = 2, clr = 3, halign = 0},
				{str = "Activates a random tarot card effect, normal or reversed."},
			},
			{ -- Synergies
				{str = "Synergies", fsize = 2, clr = 3, halign = 0},
				{str = "Tarot Cloth", clr = 3, halign = 0},
				{str = "2 random tarot cards are activated instead of one."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "Some Major Arcana decks name the blank card."},
				{str = "It means that the answer is not known and has the same meaning whether it's upright or reversed."},
			},
		},
	}
	Encyclopedia.AddCharacter({
		ModName = "Andromeda",
		Name = "Andromeda",
		WikiDesc = Wiki.ANDROMEDA,
		ID = Enums.Characters.ANDROMEDA,
		Sprite = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/characterportraits.anm2", "Andromeda", 0),
	})
	Encyclopedia.AddCharacterTainted({
		ModName = "Andromeda",
		Name = "AndromedaB",
		Description = "The Abandoned",
		WikiDesc = Wiki.ANDROMEDA_B,
		ID = Enums.Characters.T_ANDROMEDA,
		Sprite = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/characterportraitsalt.anm2", "AndromedaB", 0),
	})
	--Unlocks
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.GRAVITY_SHIFT,
		WikiDesc = Wiki.GRAVITY_SHIFT,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.BlueBaby then
				self.Desc = "Defeat ??? as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.EXTINCTION_EVENT,
		WikiDesc = Wiki.EXTINCTION_EVENT,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_CRANE_GAME,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.TheLamb then
				self.Desc = "Defeat The Lamb as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.CELESTIAL_CROWN,
		WikiDesc = Wiki.CELESTIAL_CROWN,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Hush then
				self.Desc = "Defeat Hush as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.BABY_PLUTO,
		WikiDesc = Wiki.BABY_PLUTO,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_BABY_SHOP,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.MegaSatan then
				self.Desc = "Defeat Mega Satan as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.HARMONIC_CONVERGENCE,
		WikiDesc = Wiki.HARMONIC_CONVERGENCE,
		Pools = {
			Encyclopedia.ItemPools.POOL_ANGEL,
			Encyclopedia.ItemPools.POOL_GREED_ANGEL,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Delirium then
				self.Desc = "Beat The Void as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.JUNO,
		WikiDesc = Wiki.JUNO,
		Pools = {
			Encyclopedia.ItemPools.POOL_PLANETARIUM,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Mother then
				self.Desc = "Beat the Corpse as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.PALLAS,
		WikiDesc = Wiki.PALLAS,
		Pools = {
			Encyclopedia.ItemPools.POOL_PLANETARIUM,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Beast then
				self.Desc = "Beat the Final Chapter as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.OPHIUCHUS,
		WikiDesc = Wiki.OPHIUCHUS,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Greedier then
				self.Desc = "Beat Greedier Mode as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.BOOK_OF_COSMOS,
		WikiDesc = Wiki.BOOK_OF_COSMOS,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_LIBRARY,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.BlueBaby then
				self.Desc = "Defeat ??? as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.THE_SPOREPEDIA,
		WikiDesc = Wiki.THE_SPOREPEDIA,
		Pools = {},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.BlueBaby then
				self.Desc = "???"
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.LUMINARY_FLARE,
		WikiDesc = Wiki.LUMINARY_FLARE,
		Pools = {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.TheLamb then
				self.Desc = "Defeat The Lamb as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.SINGULARITY,
		WikiDesc = Wiki.SINGULARITY,
		Pools = {
			Encyclopedia.ItemPools.POOL_SECRET,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Delirium then
				self.Desc = "Beat The Void as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.CERES,
		WikiDesc = Wiki.CERES,
		Pools = {
			Encyclopedia.ItemPools.POOL_PLANETARIUM,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Mother then
				self.Desc = "Beat the Corpse as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.VESTA,
		WikiDesc = Wiki.VESTA,
		Pools = {
			Encyclopedia.ItemPools.POOL_PLANETARIUM,
		},
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Beast then
				self.Desc = "Beat the Final Chapter as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddItem({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Collectibles.CHIRON,
		WikiDesc = Wiki.CHIRON,
		Pools = {
			Encyclopedia.ItemPools.POOL_PLANETARIUM,
		},
		UnlockFunc = function(self)
			if not Functions.HasFullCompletion(Enums.Characters.T_ANDROMEDA) then
				self.Desc = "Get full completion marks as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.CRYING_PEBBLE,
		WikiDesc = Wiki.CRYING_PEBBLE,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Isaac then
				self.Desc = "Defeat Isaac as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.METEORITE,
		WikiDesc = Wiki.METEORITE,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Satan then
				self.Desc = "Defeat Satan as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.STARDUST,
		WikiDesc = Wiki.STARDUST,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.Greed then
				self.Desc = "Beat Greed Mode as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.ALIEN_TRANSMITTER,
		WikiDesc = Wiki.ALIEN_TRANSMITTER,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Isaac then
				self.Desc = "Defeat Isaac as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.MOON_STONE,
		WikiDesc = Wiki.MOON_STONE,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Satan then
				self.Desc = "Defeat Satan as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.POLARIS,
		WikiDesc = Wiki.POLARIS,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.BossRush then
				self.Desc = "Beat Boss Rush as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddTrinket({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Trinkets.SEXTANT,
		WikiDesc = Wiki.SEXTANT,
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Greed then
				self.Desc = "Beat Greed Mode as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddRune({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Cards.BETELGEUSE,
		WikiDesc = Wiki.BETELGEUSE,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "betelgeuse", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.BossRush then
				self.Desc = "Beat Boss Rush as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddRune({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Cards.ALPHA_CENTAURI,
		WikiDesc = Wiki.ALPHA_CENTAURI,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "alphacentauri", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.Andromeda.BossRush then
				self.Desc = "Beat Boss Rush as Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddRune({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Cards.SIRIUS,
		WikiDesc = Wiki.SIRIUS,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "sirius", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.BossRush then
				self.Desc = "Beat Boss Rush as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddSoul({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Cards.SOUL_OF_ANDROMEDA,
		WikiDesc = Wiki.SOUL_OF_ANDROMEDA,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "soulofandromeda", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Hush then
				self.Desc = "Defeat Hush as Tainted Andromeda."
				return self
			end
		end,
	})
	Encyclopedia.AddCard({
		Class = "Andromeda",
		ModName = "Andromeda",
		ID = Enums.Cards.THE_UNKNOWN,
		WikiDesc = Wiki.THE_UNKNOWN,
		Spr = Encyclopedia.RegisterSprite(Functions.GetCurrentModPath() .. "content/gfx/ui_cardfronts.anm2", "theunknown", 0),
		UnlockFunc = function(self)
			if not SaveData.UnlockData.T_Andromeda.Greedier then
				self.Desc = "Beat Greedier Mode as Tainted Andromeda."
				return self
			end
		end,
	})
end