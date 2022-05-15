local eeveeEncyclopedia = {}

if not Encyclopedia then return eeveeEncyclopedia end

local EeveePortrait = nil
local EeveeBPortrait = nil

local CharactersWiki = {
	PlayerEevee = {
		{ -- Start Data
			{ str = "Start Data", fsize = 2, clr = 3, halign = 0 },
			{ str = "HP: 2 Hearts." },
			{ str = "- Speed: 1.00" },
			{ str = "- Tear Rate: 2.73" },
			{ str = "- Damage: 2.80" },
			{ str = "- Range: 9.5" },
			{ str = "- Shot Speed: 1.20" },
			{ str = "- Luck: 0.00" },
		},
		{ --Traits
			{ str = "Traits", fsize = 2, clr = 3, halign = 0 },
			{ str = "Eevee cannot fire normally, instead uses the move 'Swift'." },
			{ str = "While holding the fire buttons, stars will be summoned and continuously orbit around Eevee at a rate determined by your firerate. After either letting go of the fire keys or after after 5 stars have been summoned, they will shoot forward in the direction you're firing." },
			{ str = "Summoned stars inherintly have spectral, and once fired, are given homing." },
			{ str = "The closest enemy within a 30 degree angle of the direction the stars will fire, and within a radius scaled with your range, once fired, will fire directly towards that enemy." },
			{ str = "After any amount of stars have been fired, Eevee will have a small cooldown determined by your firerate before being able to use Swift again." },
			{ str = "Outside of these listed attributes, stars behave identically to tears in every fashion." },
		},
		{ -- Birthright
			{ str = "Birthright", fsize = 2, clr = 3, halign = 0 },
			{ str = "Gives Eevee the Tail Whip item in their consumeable slot, to knockback enemies and projectiles." },
			{ str = "On use, extends a tail out that spins in a circle, knocking back enemies and projectiles." },
			{ str = "Enemies hit are given a Weakness effect for 5 seconds, similarly to XI - Strength?." },
			{ str = "Projectiles hit are able to damage enemies." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Tapping the fire key will shoot a single star in the direction you're facing. Use this to focus your firing if needed, such as fighting back Mega Troll Bombs." },
			{ str = "The spectral and homing given to Swift's stars, as well as their auto-aim capabilities, are not transferred over to anything that utilizes the player's attacks, such as Incubus. However, any laser-based attacks do give these directly to the player, as this type of attack needs their attributes on the player in order to function correctly." },
			{ str = "The longer Swift's stars stay up, the less range they'll have. Despite the increased range as part of Eevee's stats, a fully-charged Swift attack with their base stats will only cover the distance equivalent to Isaac's base range. This means that firerate ups or releasing Swift earlier will help counteract this." },
			{ str = "Swift relies heavily on its range for homing attacks to have more time to focus on enemies, so range downs are a detriment to Eevee." },
			{ str = "Swift has a long cooldown after firing, no matter how many stars are fired. Be careful not to put yourself in a situation where you can't defend yourself!" },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Almond Milk / Soy Milk: Stars will continuously orbit the player until the fire buttons are let go, firing off additional stars at a rate equal to your firerate." },
			{ str = "Angelic Prism: Stars orbit slighty closer to the player to avoid being in the same orbit distance as the prism." },
			{ str = "Angelic Prism + Fire Mind / Ipecac: Angelic Prism's orbit distance overrides Fire Mind's and Ipecac's." },
			{ str = "Brimstone: Stars are replaced by Brimstone orbs. The orbs do continuous damage to anything that touches it, determined by the player's damage. Once Swift fires, all surrounding orbs simultaneously fire a Brimstone laser in the direction the player fired them in. The rate that these orbs appear are determined are equal to your firerate x 1.5." },
			{ str = "Brimstone + Mom's Knife: After firing, 1-5 knives will shoot out of the player in a star-formation, the amount equal to how many stars were summoned by Swift." },
			{ str = "Dr. Fetus: Stars are replaced by bombs. These bombs will not detonate until Swift fires them off." },
			{ str = "Eye Sore: For each star being fired, it has a random chance to fire 1-3 additional stars in random directions. The direction is not influenced by Swift's auto-aim." },
			{ str = "Fire Mind / Ipecac: Stars orbit further away from the player, out of explosion radius." },
			{ str = "Loki's Horns: For each star being fired, it has a random chance to fire additional stars in the remaining 3 cardinal directions. The direction is not influenced by Swift's auto-aim." },
			{ str = "Lost Contact: Stars orbit much closer to the player." },
			{ str = "Mom's Eye: For each star being fired, it has a random chance to fire an additional star in the opposite direction. The direction is not influenced by Swift's auto-aim." },
			{ str = "Mom's Knife: Stars are replaced by floating knives that deal the player's damage. They have a minimum lifetime of 2 seconds before the player's range stat can take effect, and all fire simultaneously. The rate that these knives appear are determined are equal to your firerate x 1.5." },
			{ str = "Mom's Knife + Tech X: Tech X rings surround each knife, having a small radius and deals 25% of the player's damage." },
			{ str = "Monstro's Lung: Acts as a multi-tear modifier, having 6 additional stars orbit every initially spawned star, with their distance from the star and size being randomized." },
			{ str = "Spirit Sword: Swift stars quickly spawn around Eevee during a spin attack, launching forward when the swing completes. However, you lose your beam projectiles." },
			{ str = "Tech X: Stars are replaced by laser orbs. When fired, releases a laser ring. The ring scales in radius and damage equal to how long Swift has been charged, going from 25% to 100% damage at the beginning and end of Swift's charge respecively." },
			{ str = "Technology: Stars are replaced by technology orbs. The orbs do continuous damage to anything that touches it, determined by the player's damage. Once Swift fires, all surrounding orbs simultaneously fire a Technology laser in the direction the player fired them in. The rate that these orbs appear are determined are equal to your firerate x 1.5." },
			{ str = "Technology 2: Constant firing technology lasers are attached to each star, disappearing after the star has been fired." },
			{ str = "The Ludovico Technique: Replaces the single large tear with a spinning ring of Swift stars." },
			{ str = "Tiny Planet: Similar to Soy Milk, stars will continuously orbit the player until the fire buttons are let go, firing off additional stars at a rate equal to your firerate." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "-- Positive" },
			{ str = "20/20 and other multi-shot effects: Multiple stars orbit the initially spawned star continuously." },
			{ str = "Apple! / Tough Love: Effect still triggers, but is not visually distinct from other stars." },
			{ str = "A Lump of Coal: Stars will not grow in size and damage until fired." },
			{ str = "Analog Stick: Stars can be fired in 360 degrees." },
			{ str = "Anti-Gravity: Only orbit in place after being fired from Swift" },
			{ str = "Anti-Gravity + Brimstone / Technology: Swift's orbs will fire another orb, of which will function like their regular Anti-Gravity synergy." },
			{ str = "Anti-Gravity + Mom's Knife / Dr. Fetus: Functions with Anti-Gravity unlike other characters." },
			{ str = "Blood Clot / Chemical Peel / The Peeper / The Scooper / Stye: Each item's effect has a 50/50 chance per star to trigger, all able to stack." },
			{ str = "Brimstone + Almond Milk / Soy Milk: Brimstone beams can be fired continuously after fully charging Swift as long as the fire buttons are held." },
			{ str = "Chocolate Milk: Stars will scale in damage equal to how long Swift has been charged, going from 50% to 200% damage at the beginning and end of Swift's charge respecively." },
			{ str = "Evil Eye: Stars have a chance to be replaced by an Evil Eye, continuing to stay in orbit around Eevee until fired." },
			{ str = "Evil Eye + Almond Milk / Soy Milk / Tiny Planet: Eye does not fire additional stars from Swift, as it already does so itself." },
			{ str = "Esau Jr: Esau Jr. retains the Swift attack." },
			{ str = "Eye of the Occult: Stars will stay in orbit until fired, and can then be controlled as normal." },
			{ str = "Flat Stone: Stars to not bounce on the ground until fired." },
			{ str = "Godhead: Aura will remain on the stars while charging Swift." },
			{ str = "Guillotine: Stars will continue to orbit the body, cancelling out the tear offset that Guillotine usually enacts. Multiple head orbitals do not create more stars." },
			{ str = "Head of the Keeper: Stars are replaced by Poke Dollar coins." },
			{ str = "Hook Worm: Stars do not shift until fired." },
			{ str = "Kidney Stone: Swift won't stop firing when the player's head turns red. The fired kidney stone still fires from the mouth. Once Kidney Stone is active, similarly to Soy Milk, stars will continuously orbit the player, firing off additional stars at a rate equal to your firerate." },
			{ str = "Lost Contact + Fire Mind / Ipecac: Lost Contact's orbit distance is overridden by Fire Mind's and Ipecac's." },
			{ str = "Marked: Stars will fire directly at the target, overriding its auto-aim." },
			{ str = "Monstro's Lung:" },
			{ str = "- + Additional copies: Adds 3 additional stars for each copy. For all other attack types, adds 4." },
			{ str = "- + 20/20 and other multi-shot effects: The number of stars that these items would usually add are doubled, up to a maximum of 16." },
			{ str = "- + Brimstone: Shoots 3-5 additional beams in random directions around the initial star." },
			{ str = "- + Mom's Knife: Shoots 3-5 additional knives in random directions around the initial star." },
			{ str = "- + Dr. Fetus: Shoots 3-5 additional bombs within a 30 degree radius in the direction the star was fired." },
			{ str = "- + Technology: Shoots 3-5 additional lasers within a 60 degree radius in the direction the star was fired." },
			{ str = "- + Tech X: Shoots 3-5 addtional laser rings within a 180 degree radius in the direction the star was fired." },
			{ str = "Number One: Range decrease is less severe." },
			{ str = "Ouija Board: Spectral is granted to anything that would copy the player's attacks or tears." },
			{ str = "Ourobourus Worm: Stars do not spiral until fired." },
			{ str = "Pop!: Orbiting stars can hit stars still floating, resulting in a better chance of more stars remaining on screen." },
			{ str = "Proptosis: Stars will not shrink in size and damage until fired." },
			{ str = "R U A Wizard?: No effect." },
			{ str = "Ring Worm: Stars do not spiral until fired." },
			{ str = "Rubber Cement: Stars will not bounce until fired." },
			{ str = "Scissors: Stars will continue to orbit the body. While this makes the head useless, you gain more power on your body due to the blood gushing from it." },
			{ str = "Spoon Bender: Homing is granted to anything that would copy the player's attacks or tears." },
			{ str = "Technology Zero: Orbiting stars are connected by a laser, fully encircling the player with the exception of one opening." },
			{ str = "The Intruder: Eevee does not visually have the familiar in their head, but still fires the extra quad shot." },
			{ str = "The Wiz: For each star being fired, it will shoot diagonally and shoot an additional star in the opposite diagonal direction. This additional shot is influenced by Swift's auto-aim, unlike Loki's Horns or Mom's Eye" },
			{ str = "Tractor Beam: Stars float directly in front of Eevee until fired." },
			{ str = "-- Negative" },
			{ str = "Aquarius: Creeps do not inherit Swift's homing effect." },
			{ str = "Brain Worm: Stars do not turn to enemies until fired, although given Swift's auto aim and homing, this is nearly pointless." },
			{ str = "C Section: Overrides Swift." },
			{ str = "Compound Fracture / The Parasite: Combined with Swift's spectral, stars will continuously create split stars as long as they hover over an obstacle. However, most split stars may end up staying in place due to them copying the initial star's velocity, which isn't very fast while Swift is in orbit around the player." },
			{ str = "Cursed Eye: Overridden by Swift." },
			{ str = "Dead Onion: As Swift already has spectral and relies heavily on its range, this item isn't recommended." },
			{ str = "Decap Attack: Stars will continue to orbit the body, making the item effectively useless." },
			{ str = "Epic Fetus: Overrides Swift." },
			{ str = "Incubus / Twisted Pair / Sprinkler / Sumptorium / Gello: Fires normally. Swift stars are purely cosmetic." },
			{ str = "Neptunus: No effect." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "-- General" },
			{ str = "Eevee originates from the Pokemon series, known as the Evolution Pokemon. It's known most for having 8 different evolved forms, the most of any Pokemon to date." },
			{ str = "Swift is a move Eevee can learn in the Pokemon games, and is associated most with this move." },
			{ str = "Swift in the Pokemon games is a Normal-type move, described as a move that shoots star-shaped rays at the opposing Pokemon, and that the attack never misses." },
			{ str = "Eevee's pronouns in this mod are they/them." },
			{ str = "Eevee: Reunited has been in development ever since Repentance released, but Eevee as a character mod has worked on since July 19th, 2019, starting from the Afterbirth+ version's very simple beginnings." },
			{ str = "Eevee's unique hairstyle originated from when their sprite was first being created, and Eevee's usual small hair bits didn't translate well, so the creator asked for feedback. Someone suggested very big, fluffy hair." },
			{ str = "-- Costumes" },
			{ str = "Eevee has just over 500 unique costumes, on top of a custom-built system that removes undesired costumes, usually those that would harm Eevee in some form." },
			{ str = "120 Volt: A Light Ball rests on Eevee's head, an item in the Pokemon games that if held by a Pikachu, raises their Attack and Special Attack stats." },
			{ str = "A Pony / White Pony: The pony's head is that of the Pokemon 'Rapidash' and their Galarian form respectively." },
			{ str = "Aquarius: Gives Eevee a white fin encircling their neck, the same one worn by Vaporeon, one of Eevee's evolutions." },
			{ str = "Azazel's Stump: Creates a fusion between Azazel and Eevee" },
			{ str = "Bookworm / Epic Fetus: The Bookworm transformation adds a mustache, and Epic Fetus only adds the hat, but with an added gold band. Both of these costumes are in reference to Sanio, the Pokesona of the mod creator." },
			{ str = "Camo Undies: Undies become pants, and resemble that of the Pokemon 'Zoroark', a Pokemon known for creating illusions." },
			{ str = "Ceremonial Robes: The robes are Pikachu-themed robes, referencing a real-life plush of Eevee wearing a Pikachu-themed hooded cape." },
			{ str = "Chaos: Makes Eevee 'scrunge'. In this context, scrunge is a term used to describe when cats squint their eyes and pull their mouth back, slightly opening them and revealing their teeth." },
			{ str = "Dead Eye / Epiphora / Tractor Beam / X-Ray Vision: All costumes resemble different glasses found within the Pokemon Mystery Dungeon series. They are Scope Lens, Heavy Rotation Specs, Lock-on Specs, and X-Ray Specs respectively." },
			{ str = "Eye of Greed / Head of the Keeper / Pay to Play / Money = Power: All costumes make use of the Poke Dollar symbol, the symbol of the main currency used in the Pokemon games." },
			{ str = "Godhead: Godhead's eye and aura (the costume layered beneath the player) takes the shape of the eye and ring respectively on the Pokemon 'Arceus', whom is referred to as the god of all Pokemon. Due to the aura specifically being behind the player, it mostly goes unseen." },
			{ str = "Host Hat: The hat is replaced by the Pokemon 'Duskull'" },
			{ str = "Infamy: The mask resembles the one carried by the Pokemon 'Yamask'." },
			{ str = "Iron Bar: An iron plate is stuck to Eevee's forehead, being an item of the same name from the Pokemon games that represent Steel-Type Pokemon." },
			{ str = "Lost Curse / Spirit Shackles: Eevee gains a full unique spritesheet for either of these effects." },
			{ str = "Libra: Instead of half of Eevee's entire body being grey-colored, it instead uses their 'shiny' color palette used in the Pokemon games." },
			{ str = "Luna / Whore of Babylon: Where the symbol on Isaac's head would usually be, is replaced with an oval ring, the same worn by Umbreon, one of Eevee's evolutions, although it is normally yellow." },
			{ str = "Maggy's Bow / 'Heart': Both costumes are replaced with a bow resembling those worn by Sylveon, one of Eevee's evolutions." },
			{ str = "Magneto: The Pokemon 'Magnemite' rests on top of Eevee's head." },
			{ str = "Mr. Mega: The helmet takes on the appearance of a Poke Ball." },
			{ str = "Reverse Chariot: The alternate skin that would normally show Edith instead shows an 8-bit Eevee statue standing atop a stone pedestal. This references similar statues from the Pokemon Gold and Silver games, found in the Ruins of Alph, where the statues are that of an undefinable Pokemon." },
			{ str = "Spider Bite: The item is taken literally with a small spider biting Eevee's head, resembling the Pokemon 'Spinarak'." },
			{ str = "Spoon Bender: Gives Eevee a red gem on its forehead, the same of that on Espeon, one of Eevee's evolutions." },
			{ str = "Shade: Shaped to resemble Eevee." },
			{ str = "Tech 0 / Tech 0.5 / Technology / Technology 2 / Tech X: All borrowing from Nintendo consoles over the years, they reference the Virtual Boy, GameBoy, GameCube, Wii, and a Nintendo Switch Labo VR Headset respectively." },
			{ str = "The Mark's: Mark is a small Poke Ball." },
			{ str = "Tooth and Nail: Eevee's head resembles the Pokemon 'Ferroseed'." },
			{ str = "Uranus: Gives Eevee the same tassles worn by Glaceon, one of Eevee's evolutions." },
		},
	},
}

local ItemsWiki = {
	BadEgg = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Familiar that follows Isaac around and can block projectiles, but only up to 32 times. Upon reaching the limit, the egg will 'break'." },
			{ str = "Breaking the egg will consume a random non-quest familiar Isaac owns and turn it into a duplicate of Bad EGG named that loses its familiar-consuming properties, can only block 8 shots, and will disappear." },
			{ str = "If Bad EGG breaks while you own no familiars and no other Bad EGGs created from consuming familiars, spawns Strange Egg if unlocked." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Bad EGG and its duplicates have twice the collision size of Dry Baby." },
			{ str = "Similarly to Missing No., Bad EGG can be rerolled into using a run-reroll, but cannot not be rerolled itself." },
			{ str = "Familiar items that also count as a quest item are not selected for the removal process, excluding both itself and the Key/Knife pieces." },
			{ str = "Does not target familiars that are not connected to an item or are inherintly part of the player. As such, familiars gained through Immaculate Conception or Cambion Conception, Lilith's Incibus, Tainted Lilith's Gello, etc., are not included in the removal process." },
			{ str = "Many items may involve familiars, but are not necessarily familiar items as defined in their code. Active items are excluded, and items such as Trinty Shield spawn a familiar, but are counted as a normal passive item." },
			{ str = "As familiar items specifically are targeted, if the player happens to have the Conjoined transformation but is disadvantageous to them, Bad EGG can remove familiars to help remove the transformation." },
			{ str = "While most famliiars may be fine to give up to Bad EGG, powerful familiars such as Incubus, Twisted Pair, Seraphim, and others will be consumed as well. The quality of the familiar is never taken into account through any of Bad EGG's effects, so it can result as a loss depending on the familiar." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "Box of Friends: Does not duplicate Bad EGG." },
			{ str = "Friendship Necklace: Causes all Bad EGGs to orbit around Isaac, making for an extremely effective orbital shield." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "BFFS!: Size is increased, but does not affect its collision size. Has a 50% chance of spawning a random item of Quality 2 or below, ignoring item pools. This includes items that are typically normally granted under specific circumstances or are entirely hidden from appearing, similarly to Death Certificate." },
			{ str = "- As it ignores item pools, the spawned item may be found normally later on or can be an item Isaac already owns." },
			{ str = "GB Bug: If chosen as the familiar selected to be removed, will instead spawn a glitch item, similarly to TMTRAINER." },
			{ str = "No!: Prevents active items from being generated as both the random item through BFFS! and consuming GB Bug." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Bad EGG originates from the Pokemon games in Generation III, which is a 'Bad EGG' is created in place of a Pokemon who's data had been corrupted." },
			{ str = "The act of replacing familiars Isaac owns with Bad EGGs ." },
			{ str = "Bad EGGs in the Pokemon games rarely hatch and cannot be removed, taking up a Pokemon slot in your party or PC Box. In Generation IV, Bad EGGs can sometimes be hatched into another Bad EGG. This is mimmicked by this item by being unable to be rerolled once obtained and the only instance that it will ever 'hatch' is if you own no other familiars. As to not be redundant and hatch into another Bad EGG, it spawns Strange Egg instead." },
		},
	},
	DupedEgg = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "The result of a familiar corrupted from Bad EGG." },
			{ str = "Familiar that follows Isaac around and can block projectiles, but only up to 8 times. Upon reaching the limit, the egg will disappear." },
			{ str = "The egg only respawns if the original Bad EGG 'breaks', restoring all Duped Bad EGGs Isaac owns." },

		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Duped Bad EGG cannot be found in any item pools and is only obtainable through the original Bad EGG or Death Certificate." },
			{ str = "While Duped Bad EGG does not share most qualities with the original Bad EGG, it still has the same collision size, being twice the size of Dry Baby." },

		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "BFFS!: Size is increased, but otherwise has no effect." },
			{ str = "Box of Friends: Does not duplicate Duped Bad EGG." },
			{ str = "Friendship Necklace: Causes all Bad EGGs to orbit around Isaac, making for an extremely effective orbital shield." },
		},
	},
	BagOfPokeballs = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Spawns a familiar that drops a Poke Ball pickup every 12 rooms." },
			{ str = "- The Poke Ball dropped can be a Great Ball or Ultra Ball." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "The chance for a normal Poke Ball to drop is a 50% chance. The chance for a Great Ball is 30%, and an Ultra Ball is 20%" },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "BFFS!: The familiar drops Poke Balls every 8 rooms." },
		},
	},
	BlackGlasses = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "+1 flat damage." },
			{ str = "+0.1 damage multiplier for every Devil Deal Isaac takes based on the price of the deal without modifiers. Tracks previously taken deals as well." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Items simply from the Devil Deal pool do not count towards the damage multiplier. It must happen through the action of taking a Devil Deal." },
			{ str = "1-heart deals add a +0.1 damage multiplier, while 2-heart deals add +0.2. Pound of Flesh and deals with modified health costs do not affect how much is gained, only counting how much the item itself costs normally." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "Pound of Flesh: Still counts Devil Deals, not counting Shop items that cost health." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Black Glasses' sprite references a Squirtle in the original Pokemon anime, who was the leader of a group called the Squirtle Squad." },
		},
	},
	CookieJar = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Heals 1 heart of health." },
			{ str = "Temporary debuff of -0.2 speed per use. Decays slowly over time." },
			{ str = "Upon the 6th use, consumes the item and grants two full Red Heart containers and heals 1 additional heart of health." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "It's not recommended to repeatedly use the item in quick succession, as the speed down stacks and can take a long time to return Isaac back to their normal speed." },
			{ str = "If used at or below 0.2 speed, it does not add more debuffs." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Bucket of Lard, Jupiter, Binge Eater, Immaculate Conception, or Cambion Conception: Removes speed debuff from using Cookie Jar. If a speed debuff from Cookie Jar is still active, it will remain until speed is returned to normal." },
			{ str = "Book of Virtues: Summons a single cookie-shaped wisp. Shoots slowing tears at a slow rate of fire." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "This is the only non-Pokemon related item in the mod, being added in reference to this mod creator's Pokesona, with their favorite food being cookies." },
		},
	},
	LilEevee = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Spawns a familiar that follows Isaac and shoots different types of tears." },
			{ str = "The familiar and their tears change randomly when Isaac uses a rune." },
			{ str = "- Eevee: Homing, star-shaped projectiles with low damage." },
			{ str = "- Flareon: Fire Mind tears with slightly higher damage, but slightly slower firerate." },
			{ str = "- Jolteon: Jacob's Ladder tears with very low damage, but very high firerate." },
			{ str = "- Vaporeon: Bubble-like tears with default stats that leave behind a small damaging puddle." },
			{ str = "- Espeon: Homing tears with high damage, but slow firerate." },
			{ str = "- Umbreon: Dark Matter tears with high damage, but slow firerate" },
			{ str = "- Glaceon: Uranus tears with default stats." },
			{ str = "- Leafeon: Green tears with default stats that spawn a vine when hitting an enemy, clinging onto and trapping them, dealing damage for a few moments." },
			{ str = "- Sylveon: Charming tears with default stats." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "This item is normally unobtainable through normal means. It can only be found if Isaac uses Strange Egg when fully charged or through Modeling Clay, Lemegeton, Monster Manual, and the Baby Shop (Adoption Papers)." },
			{ str = "The vine spawned by Lil Eevee's Leafeon form is a familiar, and is affected by some familiar-related effects." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "BFFS!: Damage is doubled." },
			{ str = "- Double damage is also applied to the vine spawned by Lil Eevee's Leafeon form." },
			{ str = "Forgotten Lullaby: Firerate is doubled." },
		},
		{ --Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Using runes to change Lil Eevee's form derives from how Eevee may evolve in the Pokemon games, such as using the Fire Stone to evolve into Flareon." }
		}
	},
	MasterBall = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Once thrown, the Master Ball will instantly capture any normal enemy or non-major boss enemy it hits, removing them from the room." },
			{ str = "Shortly after capture, the Master Ball will release the previously captured enemy as a friendly enemy. Isaac's Master Ball item will disappear afterwards." },
			{ str = "- Normal enemies released have their total health multiplied by x10." },
			{ str = "- Bosses released are fully healed." },
			{ str = "After releasing any kind of enemy, the ball and item will destroy itself." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Walking over a Master Ball if does not capture an enemy or leaving the room will instantly recharge the item." },
			{ str = "For additional notes on interaction with enemies, see the Notes section on Friend Ball." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "Car Battery: No effect." },
			{ str = "The Battery: Extra charges have no effect, as the item is discharged entirely when thrown." },
			{ str = "Hive Mind: No effect on captured flies or spiders." },
			{ str = "Skatole or Bursting Sack: Friendly Fly/Spider enemies will be unable able to shoot, slowed down, and/or reverted to a weaker form, hindering this item's effectiveness on those enemies." },
			{ str = "Void: Walking over a thrown Master Ball or leaving the room will not recharge Void." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Book of Virtues: Summons six Master Ball-like wisps on the outer-most layer only after releasing an enemy. Has a slight increase in all stats compared to a normal wisp. Upon death, spawns a random charmed enemy. The enemies that may spawn are the same from that of Poke Go." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "The item is taken from the Master Ball in the Pokemon franchise. It guarentees the capture of any Pokemon, and in most games, only one can be obtained per save file." },
		},
	},
	PokeStop = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Every floor, a Poke Stop will appear in a randomly selected special (non-basic) room." },
			{ str = "Interacting with the Poke Stop with have it drop 5 random pickups and a special pickup. The 5 random pickups are a random assortment of coins, keys, and bombs. The special pickup is based on the room type." },
			{ str = "After dispensing all of the pickups, the Poke Stop will disappear." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "The pickups that are chosen at random from the 5 random pickups are weighted. Each pickup spawned has a 10/15 chance to be a penny, 3/15 chance to be a bomb, and 2/15 chance to be a key." },
			{ str = "The randomly spawned pickups do not have a chance to be a variant of the pickup (Double Bombs, Charged Key, Nickel, etc) unless forced by other means such as Humbling Bundle." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "The 6th pickup dropped from Poke Stop is a set pickup determined by the type of room its in. The room and their pickup is as follows:" },
			{ str = "- Shop: Sack." },
			{ str = "- Treasure: Key Ring." },
			{ str = "- Boss: Soul Heart." },
			{ str = "- Miniboss: Random Tarot Card/Rune." },
			{ str = "- Secret: Bone Heart." },
			{ str = "- Super Secret: Golden Chest." },
			{ str = "- Arcade: Dime." },
			{ str = "- Curse: Black Heart." },
			{ str = "- Challenge: Random Trinket." },
			{ str = "- Library: Wooden Chest." },
			{ str = "- Sacrifice: Double Red Hearts." },
			{ str = "- Clean Bedroom: Chest." },
			{ str = "- Dirty Bedroom: Old Chest." },
			{ str = "- Dice Room: Dice Shard." },
			{ str = "- Planetarium: Telescope Lens." },
			{ str = "- Ultra Secret: Red Chest." },
			{ str = "The Ascent: As all 'on new floor' effects are triggered every time you go up a floor, and with only a Boss or Treasure room being available, Poke Stop is extremely easy to locate and can help accumulate lots of pickups, and Soul Hearts if located in the Boss room." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Poke Stop copies: Each copy of Poke Stop will spawn another Poke Stop in a different special room. No special rooms can have more than one Poke Stop. If all special rooms somehow have a Poke Stop already occupying them, then additional Poke Stops will not spawn." },
			{ str = "Devil's Crown: Instead of a Key Ring, Treasure Rooms transformed by Devil's Crown will change Poke Stop's unique room reward into a Cracked Key." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "The Poke Stop is a feature in the mobile app Pokemon Go, which are set in landmarks all around the real-world. Approaching a Poke Stop's location will allow the user to interact with it, spinning the disc in the middle and recieve a variety of items before going into a cooldown state for 5 minutes." },
			{ str = "The challenge you unlock Poke Stop from is named 'Pokey Mans: Crystal'. Pokemon: Crystal is part of the second generation of Pokemon games, a sort of sequeal to the original generation one Pokemon games. 'Pokey Mans: Crystal' plays off of this same relationship with the 'Pokey Mans' challenge." },
			{ str = "Poke Go's pickup quote is 'Gotta catch em...' which is the Pokemon franchise's famous tagline, while Poke Stop is 'Gotta find em...', both coming from Poke Go's pickup quote and relating to how users must find Poke Stops in Pokemon Go." },
		},
	},
	ShinyCharm = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Gives enemies a 1/2048 to become 'shiny'." },
			{ str = "Shiny enemies have a unique color per enemy type, 5 times their regular health, have the fear status effect, and will disappear after 10 seconds." },
			{ str = "Shiny enemies will drop a random Golden Trinket on death." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Bosses, Champions, or enemies marked as invincible when spawned cannot become shiny." },
			{ str = "- This causes enemies that cannot be immediately attacked when spawned, such as Hosts or Wizoobs, to not be capable of becoming shiny." },
			{ str = "Leaving a room with a shiny enemy and re-entering it does not guarentee that the shiny enemy will remain shiny, as enemies are entirely respawned each time when entering a room." },
			{ str = "- Constantly reentering and exiting the same room for this same reason may cause a previously non-shiny enemy to become shiny. This makes items like Doorstop and Mercurius especially useful if you're willing to wait long enough." },
			{ str = "Capturing a shiny enemy with a Poke Ball rather than killing it can prove equally useful, as it will multiply the health on top of the enemy's already 5x health, making for a powerful friendly enemy." },
			{ str = "Shiny enemies can appear without the need of Shiny Charm, but at half the encounter rate, sitting at 1/4096." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "Shiny Charm: Each copy of Shiny Charm further halves the encounter rate." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Shiny enemies take from the Pokemon franchise's term for Pokemon that rarely appear with a unique color palette, being 'shiny' Pokemon." },
			{ str = "The exact encounter chance without needing Shiny Charm is the same ones used in the Pokemon games for encountering shiny Pokemon." },
			{ str = "Shiny Pokemon in the Pokemon games are a purely cosmetic, but were given a gimmick that affected gameplay to be adapted into Isaac." },
		},
	},
	SneakScarf = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "+0.3 speed." },
			{ str = "Enemies outside of a radius around the player will be inflicted with the Confusion status. The radius is roughly half a normal 1x1 room." },
			{ str = "Once an enemy if freed of its confusion when coming too close, they cannot be confused by Sneak Scarf again." },
			{ str = "Sneak Scarf has no effect on bosses." }
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "If playing co-op, players without Sneak Scarf can safely approach confused enemies." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Sneak Scarf comes from the Pokemon Mystery Dungeon series as a hold-item, introduced in Generation III. It's effect wouldn't wake up sleeping Pokemon if they were doing so when entering the floor." },
		},
	},
	StrangeEgg = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Can only charge by entering a new floor." },
			{ str = "Can be used at any charge above zero, giving different effects depending on the charge." },
			{ str = "1 charge: Heals up to 3 full red hearts." },
			{ str = "2 charge: Spawns Breakfast and 2 full red hearts." },
			{ str = "3 charge: Spawns Lil' Eevee." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Strange Egg can be kept for defensive or offensive purposes, for health or for the Lil' Eevee familiar. Keep the item with you if you're lacking in one or the other and don't mind having it take up your active slot." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "Car Battery: No effect." },
			{ str = "The Battery: Grants rewards based on its extra charge count, independent of the normal charges." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Fire Mind, Hot Bombs, or Match Book: Doubles the charge gained from entering a new floor." },
			{ str = "Book of Virtues: Summons an egg-shaped wisp for every charge. Has higher than average health and a 10% chance to shoot a charm tear. Spawns a full Red Heart when destroyed." },
			{ str = "Judas' Birthright: Replaces dropped hearts with Black Hearts." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Strange Egg's method of charging resembles how eggs are hatched in the Pokemon games. It requires you to walk a certain number of steps, the amount of steps required increased based on the Pokemon." },
			{ str = "Fire Mind / Hot Bombs doubling charges gained references how Pokemon with the ability 'Magma Armor' or 'Flame Body' in the Pokemon games can half the amount of time it takes to hatch an egg." },
		},
	},
	TailWhip = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "On use, extends a tail out that spins in a circle, knocking back enemies and projectiles." },
			{ str = "Enemies hit are given a Weakness effect for 5 seconds, similarly to XI - Strength?." },
			{ str = "Projectiles hit are able to damage enemies." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Eevee gains this item in the consumable slot after getting Birthright." },
			{ str = "Tail Whip can also knock back invincible enemies." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "Car Battery / 9 Volt / The Battery: Activating Tail Whip on an enemy that has already been weakened from it will have its duration reset, but they do not stack." },
		},
	},
	WonderousLauncher = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Shoots projectiles depending on the selected pickup. Selection is changed by using the DROP key." },
			{ str = "Coins: Shoots a coin projectile. The amount of coins consumed and the type of the coin projectile is dependent on Isaac's overall coin count." },
			{ str = "- Coins projectiles base their damage from Isaac's damage. Pennies deal x2 damage, Nickels x5, and Dimes x10" },
			{ str = "Bombs: Shoots a bomb forward. Retains all bomb effects as if it were dropped directly by Isaac." },
			{ str = "Keys: Shoots a Sharp Key projectile." },
			{ str = "." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "The type of pickup selected by the launcher can be changed independently per player." },
			{ str = "Urn of Souls and Notched Axe will hide the launcher, but not vice versa." },
			{ str = "The currently selected pickup is noted by the sprite inside of the launcher. If Isaac does not have any of the selected pickup, the launcher will remain empty." },
			{ str = "Picking up a pickup type that corresponds to the selected pickup on the launcher, if empty, will refill it." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Tainted ???: Allows poop pickups to be selected. Consumes the next available poop spell in queue, shooting a poop ball projectile that drops that poop spell upon contact" },
			{ str = "- Can throw Butt Bombs, but not the Explosive Diarrhea spell." },
			{ str = "- Non-throwable poop spells (Ones Tainted ??? would not throw normally) next in queue will cause the launcher to remain empty." },
			{ str = "Book of Virtues: Summons a wisp for every pickup shot, up to a maximum of 6. The type of the spawned wisp depends on the type of pickup shot." },
			{ str = "- All wisps are taken from existing active items' wisps. Coins, Bombs, Keys, and Poops all spawn wisps as if used from Wooden Nickel, Mr. Boom, Sharp Key, and The Poop respectively." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "The item derives from a launcher in a special type of Pokemon battle in the Pokemon Black and Pokemon White games, named Wonder Launcher battles. Players could select discs to fire from the launcher at their Pokemon that mirrored many in-game items, such as ones that healed or buffed their Pokemon." },
		},
	},
}

local TrinketsWiki = {
	AlertSpecs = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Prevents coins from dropping if hit by greed-type enemies or projectiles." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "The only enemies that this makes use out of is the Greed miniboss, Keeper heads, Ultra Greed/Ultra Greedier, and the spinning Ultra Greed coins." },
			{ str = "Does not prevent coins dropping from other methods, such as Piggy Bank, Fanny Pack, and Torn Pocket." },
			{ str = "Due to its nature, this trinket shines most in Greed Mode, most prominently when fighting Ultra Greed, as none of his attacks can cause you to drop coins that he can heal from." }
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Mom's Box/Golden Trinket: No effect." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Alert Specs comes from the Pokemon Mystery Dungeon series as a hold-item, introduced in Generation III. It's effect would prevent the Pokemon wearing it from having their held-item snatched away or swatted down." },
		},
	},
	Eviolite = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "+0.2 speed." },
			{ str = "x1.1 tears multiplier." },
			{ str = "x1.2 damage multiplier." },
			{ str = "+2 range." },
			{ str = "+0.2 shot speed." },
			{ str = "If Isaac has gained any transformations, no stats are given." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "Keep in mind which items contribute to a transformation when coming across this trinket. Conjoined being the most common, you may want to avoid picking up too many familiars and lose your stat ups." },
			{ str = "The stats given outweigh most of the benefits given from other transformations. Seraphim, Leviathan, and Guppy however are all transformations that grant flight and require some desirable items to obtain, so whether the stats are worth keeping are up to you." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Eevee: Multiplies stats by x2, but are also lost if Eevee evolves." },
			{ str = "Mom's Box/Golden Trinket: Multiplies stats by x1.5 and x2 respectively." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Eviolite is taken directly from a held-item of the same name from the Pokemon games, introduced in Generation V. If held by a Pokemon that has not fully evolved, raises its Defense and Special Defense by +50%" },
		},
	},
	LockOnSpecs = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "x2 damage multiplier." },
			{ str = "+3 range." },
			{ str = "+0.3 shot speed." },
			{ str = "This trinket has a chance to be destroyed each time Isaac takes non-self damage while holding it." },
			{ str = "For each time the trinket is not destroyed, it will increase the chances of being destroyed the next time Isaac is hit by 10%." },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "The chance for the trinket being destroyed always starts at a 0%, so Isaac is always guarenteed one hit of damage without losing the trinket." },
			{ str = "The chance for the trinket being destroyed is not made per trinket, instead being linked to the player." },
			{ str = "Once the trinket is destroyed, the chance of destroying it resets to 0%. This makes it handy to have duplicate trinkets if possible to increase the chances of retaining the trinket." },
			{ str = "Carrying duplicates of the trinket will not increase the stats gained from it, but only one trinket can be destroyed at a time." },
		},
		{ -- Synergies
			{ str = "Synergies", fsize = 2, clr = 3, halign = 0 },
			{ str = "Mom's Box/Golden Trinket: Doubles and triples stats respectively, including the added drop chance for each time Isaac takes non-self damage." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "Lock-On Specs comes from the Pokemon Mystery Dungeon series as a hold-item, introduced in Generation III. It's effect would boost the Pokemon wearer's accuracy when it throws items at enemies." },
		},
	},
}

local PickupsWiki = {
	PokeBall = {
		{ -- Effects
			{ str = "Effects", fsize = 2, clr = 3, halign = 0 },
			{ str = "Holds the ball above Isaac's ahead. Press any directional keys to throw, or use again to return the pickup." },
			{ str = "Once thrown, will instantly capture any normal enemy or non-major boss enemy it hits, removing them from the room." },
			{ str = "Upon capture, the ball may release the previously captured enemy as a friendly enemy." },
			{ str = "- Normal enemies will always be released as friendly enemies. Bosses have a chance to turn friendly. Chances are increased based on the type of ball used, its current health percentage, status effects, and Isaac's luck." },
			{ str = "- Normal enemies released have their total health multiplied dependent on the type of ball used, and are fully healed." },
			{ str = "- Bosses released, if successfully captured and become friendly, will heal a percentage of their health dependent on the type of ball used." },
			{ str = "The ball may destroy itself after releasing a normal enemy, dependent on Isaac's luck. It will always be destroyed if releasing a boss" },
		},
		{ -- Notes
			{ str = "Notes", fsize = 2, clr = 3, halign = 0 },
			{ str = "The ball can be picked up again if it reaches the floor without capturing an enemy. It also stays in pickup form when leaving the room if an enemy hadn't been captured and released." },
			{ str = "The status effects that contribute to the chance of capturing a boss are split into two categories: Weak and Strong. Weak effects have a small influence on capture rate, Strong effects having a bigger influence." },
			{ str = "- Weak: Poison, Slowness, Fear, Burn, Shrunk, Bleeding, and Weakness." },
			{ str = "- Strong: Charmed, Petrified by Midas Touch, Frozen." },
			{ str = "- Normal Petrification is not accounted for due to how the pickup is coded, freezing and hiding the enemy to keep it alive in the room." },
			{ str = "Although bosses can be captured, the chances of successfully capturing one even at the best chances are not guarenteed. Don't be afraid to use it on a powerful enemy such as a Bishop or Vis, as the ball may continue to stick around, and more powerful balls increase their maximum health further." },
			{ str = "For additional notes, see the Notes section on Friend Ball." },
		},
		{ -- Interactions
			{ str = "Interactions", fsize = 2, clr = 3, halign = 0 },
			{ str = "." },
		},
		{ -- Trivia
			{ str = "Trivia", fsize = 2, clr = 3, halign = 0 },
			{ str = "The Poke Ball is a staple of the Pokemon franchise, with the main functionality being the capturing and taming of wild Pokemon. It's main appeal and usage in most media is using the Pokemon in battle against other Pokemon." },
		},
	},
}

local UnlocksTable = {
	SneakScarf = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.BossRush.Unlock then
			self.Desc = "Beat Boss Rush as Eevee."

			return self
		end
	end,
	LockOnSpecs = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Hush.Unlock then
			self.Desc = "Defeat Hush as Eevee."

			return self
		end
	end,
	ShinyCharm = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Isaac.Unlock then
			self.Desc = "Defeat Isaac as Eevee."

			return self
		end
	end,
	BlackGlasses = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Satan.Unlock then
			self.Desc = "Defeat Satan as Eevee."

			return self
		end
	end,
	CookieJar = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.BlueBaby.Unlock then
			self.Desc = "Defeat ??? as Eevee."

			return self
		end
	end,
	Eviolite = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Lamb.Unlock then
			self.Desc = "Defeat The Lamb as Eevee."

			return self
		end
	end,
	StrangeEgg = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.MegaSatan.Unlock then
			self.Desc = "Defeat Mega Satan as Eevee."

			return self
		end
	end,
	LilEevee = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.MegaSatan.Unlock then
			self.Desc = "Defeat Mega Satan as Eevee."

			return self
		end
	end,
	BadEgg = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Delirium.Unlock then
			self.Desc = "Defeat Delirium as Eevee."

			return self
		end
	end,
	AlertSpecs = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.GreedMode.Unlock then
			self.Desc = "Beat Greed Mode as Eevee."

			return self
		end
	end,
	WonderousLauncher = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.GreedMode.Unlock
			and not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.GreedMode.Hard
		then
			self.Desc = "Beat Greedier Mode as Eevee."

			return self
		end
	end,
	BagOfPokeballs = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Mother.Unlock then
			self.Desc = "Beat the Corpse as Eevee."

			return self
		end
	end,
	MasterBall = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Beast.Unlock then
			self.Desc = "Beat the Final Chapter as Eevee."

			return self
		end
	end,
	TailWhip = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.FullCompletion.Unlock then
			self.Desc = "Complete all marks as Eevee."

			return self
		end
	end,
	PokeStop = function(self)
		if not EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal then
			self.Desc = "Beat challenge: Pokey Mans Crystal"

			return self
		end
	end
}

local ItemPoolsTable = {
	BadEgg = {
		Encyclopedia.ItemPools.POOL_SECRET,
		Encyclopedia.ItemPools.POOL_GREED_SECRET,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		Encyclopedia.ItemPools.POOL_BABY_SHOP,
	},
	BagOfPokeballs = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_SHOP,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_SHOP,
	},
	BlackGlasses = {
		Encyclopedia.ItemPools.POOL_DEVIL,
		Encyclopedia.ItemPools.POOL_GREED_DEVIL,
		Encyclopedia.ItemPools.POOL_RED_CHEST,
		Encyclopedia.ItemPools.POOL_DEMON_BEGGAR,
		Encyclopedia.ItemPools.POOL_GREED_SHOP,
	},
	CookieJar = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_SHOP,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_SHOP,
	},
	LilEevee = {
		Encyclopedia.ItemPools.POOL_BABY_SHOP,
	},
	MasterBall = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		Encyclopedia.ItemPools.POOL_CRANE_GAME,
	},
	PokeStop = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_SHOP,
		Encyclopedia.ItemPools.POOL_BOSS,
		Encyclopedia.ItemPools.POOL_SECRET,
		Encyclopedia.ItemPools.POOL_LIBRARY,
		Encyclopedia.ItemPools.POOL_CURSE,
	},
	ShinyCharm = {
		Encyclopedia.ItemPools.POOL_SECRET,
		Encyclopedia.ItemPools.POOL_GREED_SECRET,
		Encyclopedia.ItemPools.POOL_KEY_MASTER,
	},
	SneakScarf = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_SHOP,
	},
	StrangeEgg = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_BABY_SHOP,
	},
	TailWhip = {
		Encyclopedia.ItemPools.POOL_TREASURE,
		Encyclopedia.ItemPools.POOL_GREED_SHOP,
		Encyclopedia.ItemPools.POOL_GREED_TREASURE,
	},
	WonderousLauncher = {
		Encyclopedia.ItemPools.POOL_SHOP,
		Encyclopedia.ItemPools.POOL_BEGGAR,
		Encyclopedia.ItemPools.POOL_BOMB_BUM,
		Encyclopedia.ItemPools.POOL_KEY_MASTER,
	},
}

function eeveeEncyclopedia.Init(mod)
	EeveePortrait = Encyclopedia.RegisterSprite(mod.path .. "content/gfx/characterportraits.anm2", "Eevee", 1)
	EeveeBPortrait = Encyclopedia.RegisterSprite(mod.path .. "content/gfx/characterportraitsalt.anm2", "Eevee", 1)
end

function eeveeEncyclopedia.AddEncyclopediaDescs()

	Encyclopedia.AddCharacter({
		ModName = EEVEEMOD.Name,
		Name = "Eevee",
		ID = EEVEEMOD.PlayerType.EEVEE,
		Sprite = EeveePortrait,
		WikiDesc = CharactersWiki.PlayerEevee,
		CompletionTrackerFuncs = {
			function()
				local UnlocksTab = {}

				for boss, tab in pairs(EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee) do
					if type(tab) == "table" then
						UnlocksTab[boss] = EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee[boss]
					end
				end

				return UnlocksTab
			end
		},
	})
	Encyclopedia.AddCharacterTainted({
		ModName = EEVEEMOD.Name,
		Name = "Eevee",
		Description = "The Dithered",
		ID = EEVEEMOD.PlayerType.EEVEE_B,
		Sprite = EeveeBPortrait,
		UnlockFunc = function(self)
			self.Spr = EeveeBPortrait
			self.Desc = "Coming soon."
			self.TargetColor = Encyclopedia.VanillaColor

			return self
		end,
	})

	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.SNEAK_SCARF,
		Name = "Sneak Scarf",
		Desc = "Be careful not to make a sound!",
		WikiDesc = ItemsWiki.SneakScarf,
		Pools = ItemPoolsTable.SneakScarf,
		UnlockFunc = UnlocksTable.SneakScarf
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.SHINY_CHARM,
		Name = "Shiny Charm",
		Desc = "Luck up",
		WikiDesc = ItemsWiki.ShinyCharm,
		Pools = ItemPoolsTable.ShinyCharm,
		UnlockFunc = UnlocksTable.ShinyCharm
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.BLACK_GLASSES,
		Name = "Black Glasses",
		Desc = "Be a part of the cool kids",
		WikiDesc = ItemsWiki.BlackGlasses,
		Pools = ItemPoolsTable.BlackGlasses,
		UnlockFunc = UnlocksTable.BlackGlasses
	})
	for i = 1, 6 do
		local shouldHide = i < 6 and true or false
		Encyclopedia.AddItem({
			ModName = EEVEEMOD.Name,
			ID = EEVEEMOD.CollectibleType.COOKIE_JAR[i],
			Name = "Cookie Jar",
			Desc = "One at a time please",
			WikiDesc = ItemsWiki.CookieJar,
			Hide = shouldHide,
			Pools = ItemPoolsTable.CookieJar,
			UnlockFunc = UnlocksTable.CookieJar
		})
	end
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.STRANGE_EGG,
		Name = "Strange Egg",
		Desc = "Should I take care of it?",
		WikiDesc = ItemsWiki.StrangeEgg,
		Pools = ItemPoolsTable.StrangeEgg,
		UnlockFunc = UnlocksTable.StrangeEgg
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.LIL_EEVEE,
		Name = "Lil Eevee",
		Desc = "Protect the child",
		WikiDesc = ItemsWiki.LilEevee,
		Pools = ItemPoolsTable.LilEevee,
		UnlockFunc = UnlocksTable.LilEevee
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.BAD_EGG,
		Name = "Bad EGG",
		Desc = "Sounds can be heard coming from inside",
		WikiDesc = ItemsWiki.BadEgg,
		Pools = ItemPoolsTable.BadEgg,
		UnlockFunc = UnlocksTable.BadEgg
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.BAD_EGG_DUPE,
		Name = "Duped Bad EGG",
		Desc = "It won't last long",
		WikiDesc = ItemsWiki.DupedEgg,
		Hide = true
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER,
		Name = "Wonderous Launcher",
		Desc = "It's time to duel!",
		WikiDesc = ItemsWiki.WonderousLauncher,
		Pools = ItemPoolsTable.WonderousLauncher,
		UnlockFunc = UnlocksTable.WonderousLauncher
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS,
		Name = "Bag of Pokeballs",
		Desc = "Gives balls",
		WikiDesc = ItemsWiki.BagOfPokeballs,
		Pools = ItemPoolsTable.BagOfPokeballs,
		UnlockFunc = UnlocksTable.BagOfPokeballs
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.MASTER_BALL,
		Name = "Master Ball",
		Desc = "Guarenteed capture",
		WikiDesc = ItemsWiki.MasterBall,
		Pools = ItemPoolsTable.MasterBall,
		UnlockFunc = UnlocksTable.MasterBall
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.POKE_STOP,
		Name = "Poke Stop",
		Desc = "Gotta find em...",
		WikiDesc = ItemsWiki.PokeStop,
		Pools = ItemPoolsTable.PokeStop,
		UnlockFunc = UnlocksTable.PokeStop
	})
	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.Birthright.TAIL_WHIP,
		Name = "Tail Whip",
		Desc = "Aggressive tail wagging",
		WikiDesc = ItemsWiki.TailWhip,
		Pools = ItemPoolsTable.TailWhip,
		UnlockFunc = UnlocksTable.TailWhip
	})

	Encyclopedia.AddTrinket({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.TrinketType.ALERT_SPECS,
		Name = "Alert Specs",
		Desc = "Paws off!",
		WikiDesc = TrinketsWiki.AlertSpecs,
		UnlockFunc = UnlocksTable.AlertSpecs
	})
	Encyclopedia.AddTrinket({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.TrinketType.EVIOLITE,
		Name = "Eviolite",
		Desc = "Stay true to your origin",
		WikiDesc = TrinketsWiki.Eviolite,
		UnlockFunc = UnlocksTable.Eviolite
	})
	Encyclopedia.AddTrinket({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.TrinketType.LOCKON_SPECS,
		Name = "Lock-On Specs",
		Desc = "Keep your focus!",
		WikiDesc = TrinketsWiki.LockOnSpecs,
		UnlockFunc = UnlocksTable.LockOnSpecs
	})

	Encyclopedia.AddCard({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.PokeballType.POKEBALL,
		Name = "Poke Ball",
		Desc = "You already know the catchphrase",
		WikiDesc = PickupsWiki.PokeBall,
	})
	Encyclopedia.AddCard({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.PokeballType.GREATBALL,
		Name = "Great Ball",
		Desc = "For the above average",
		WikiDesc = PickupsWiki.PokeBall,
	})
	Encyclopedia.AddCard({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.PokeballType.ULTRABALL,
		Name = "Ultra Ball",
		Desc = "'Ol reliable",
		WikiDesc = PickupsWiki.PokeBall,
	})
end

return eeveeEncyclopedia
