local eeveeEncyclopedia = {}

local EeveePortrait
	
local CharactersWiki = {
	PlayerEevee = {
		{ -- Start Data
			{str = "Start Data", fsize = 2, clr = 3, halign = 0},
			{str = "HP: 2 Hearts."},
			{str = "- Speed: 1.00"},
			{str = "- Tear Rate: 2.73"},
			{str = "- Damage: 2.80"},
			{str = "- Range: 9.5"},
			{str = "- Shot Speed: 1.20"},
			{str = "- Luck: 0.00"},
		},
		{ --Traits
			{str = "Traits", fsize = 2, clr = 3, halign = 0},
			{str = "Eevee cannot fire normally, instead uses the move 'Swift'."},
			{str = "While holding the fire buttons, stars will be summoned and continuously orbit around Eevee at a rate determined by your firerate. After either letting go of the fire keys or after after 5 stars have been summoned, they will shoot forward in the direction you're firing."},
			{str = "Summoned stars inherintly have spectral, and once fired, are given homing."},
			{str = "The closest enemy within a 30 degree angle of the direction the stars will fire, and within a radius scaled with your range, once fired, will fire directly towards that enemy."},
			{str = "After any amount of stars have been fired, Eevee will have a small cooldown determined by your firerate before being able to use Swift again."},
			{str = "Outside of these listed attributes, stars behave identically to tears in every fashion."},
		},
		{ -- Birthright
			{str = "Birthright", fsize = 2, clr = 3, halign = 0},
			{str = "Gives Eevee the Tail Whip item in their consumeable slot, to knockback enemies and projectiles."},
			{str = "On use, extends a tail out that spins in a circle, knocking back enemies and projectiles."},
			{str = "Enemies hit are given a Weakness effect for 5 seconds, similar to that of XI - Strength?."},
			{str = "Projectiles hit are able to damage enemies."},
		},
		{ -- Notes
			{str = "Notes", fsize = 2, clr = 3, halign = 0},
			{str = "Tapping the fire key will shoot a single star in the direction you fired precisely in front of you. Use this to focus your firing if needed, such as fighting back Mega Troll Bombs."},
			{str = "The spectral and homing given to Swift's stars, as well as their auto-aim capabilities, are not transferred over to anything that utilizes the player's attacks, such as Incubus. However, any laser-based attacks do give these directly to the player, as this type of attack needs their attributes on the player in order to function correctly."},
			{str = "The longer Swift's stars stay up, the less range they'll have. Despite the increased range as part of Eevee's stats, a fully-charged Swift attack with their base stats will only cover the distance equivalent to Isaac's base range. This means that firerate ups or releasing Swift earlier will help counteract this."},
			{str = "Swift relies heavily on its range for homing attacks to have more time to focus on enemies, so range downs are usually a detriment to Eevee."},
			{str = "If Eevee is hit while Swift is still charging, Swift will be slowed down during i-frames."},
		},
		{ -- Interactions
			{str = "Interactions", fsize = 2, clr = 3, halign = 0},
			{str = "-- Positive"},
			{str = "20/20 and other multi-shot effects: Multiple stars orbit the initially spawned star continuously."},
			{str = "Apple! / Tough Love: Effect still triggers, but is not visually distinct from other stars."},
			{str = "A Lump of Coal: Stars will not grow in size and damage until fired."},
			{str = "Almond Milk / Soy Milk: Stars will continuously orbit the player until the fire buttons are let go, firing off additional stars at a rate equal to your firerate."},
			{str = "Analog Stick: Stars can be fired in 360 degrees."},
			{str = "Angelic Prism: Stars orbit slighty closer to the player to avoid being in the same orbit distance as the prism."},
			{str = "Angelic Prism + Fire Mind / Ipecac: Angelic Prism's orbit distance overrides Fire Mind's and Ipecac's."},
			{str = "Anti-Gravity: If the fire buttons are held, for each star that would fire, instead stays in place. The star will fire off in its originally fired direction after the fire buttons are released, or the star flashes a blue color a set amount of times."},
			{str = "Anti-Gravity + Brimstone / Technology: Swift's orbs will fire another orb, of which will function like their regular Anti-Gravity synergy."},
			{str = "Anti-Gravity + Mom's Knife: / Dr. Fetus: Functions with Anti-Gravity unlike normal characters."},
			{str = "Blood Clot / Chemical Peel / The Peeper / The Scooper / Stye: Each item's effect has a 50/50 chance per star to trigger, all able to stack."},
			{str = "Brimstone: Stars are replaced by Brimstone orbs. The orbs do continuous damage to anything that touches it, determined by the player's damage. Once Swift fires, all surrounding orbs simultaneously fire a Brimstone laser in the direction the player fired them in. The rate that these orbs appear are determined are equal to your firerate x 1.5."},
			{str = "Brimstone + Almond Milk / Soy Milk: Brimstone beams can be fired continuously after fully charging Swift as long as the fire buttons are held."},
			{str = "Brimstone + Mom's Knife: After firing, 1-5 knives will shoot out of the player in a star-formation, the amount equal to how many stars were summoned by Swift."},
			{str = "Chocolate Milk: Stars will scale in damage equal to how long Swift has been charged, going from 50% to 200% damage at the beginning and end of Swift's charge respecively."},
			{str = "Dr. Fetus: Stars are replaced by bombs. These bombs will not detonate until Swift fires them off."},
			{str = "Evil Eye: Stars have a chance to be replaced by an Evil Eye."},
			{str = "Evil Eye + Almond Milk / Soy Milk / Tiny Planet: Eye does not fire additional stars from Swift, as it already does so itself."},
			{str = "Esau Jr: Esau Jr. retains the Swift attack."},
			{str = "Eye of the Occult: Stars will stay in orbit until fired, allowing manual control."},
			{str = "Eye Sore: For each star being fired, it has a random chance to fire 1-3 additional stars in random directions. The direction is not influenced by Swift's auto-aim."},
			{str = "Fire Mind / Ipecac: Stars orbit further away from the player, out of explosion radius."},
			{str = "Flat Stone: Stars to not bounce on the ground until fired."},
			{str = "Godhead: Aura will remain on the stars while charging Swift"},
			{str = "Guillotine: Stars will continue to orbit the body, cancelling out the tear offset that Guillotine usually enacts. However, multiple head orbitals do not create more stars."},
			{str = "Head of the Keeper: Stars are replaced by Poke Dollar coins."},
			{str = "Hook Worm: Stars do not shift until fired."},
			{str = "Kidney Stone: Swift won't stop firing when the player's head turns red. The fired kidney stone still fires from the mouth. Once Kidney Stone is active, similar to Soy Milk, stars will continuously orbit the player, firing off additional stars at a rate equal to your firerate."},
			{str = "Loki's Horns: For each star being fired, it has a random chance to fire additional stars in the remaining 3 cardinal directions. The direction is not influenced by Swift's auto-aim."},
			{str = "Lost Conact: Stars orbit much closer to the player."},
			{str = "Lost Contact + Fire Mind / Ipecac: Lost Contact's orbit distance is overridden by Fire Mind's and Ipecac's."},
			{str = "Marked: Stars will fire directly at the target."},
			{str = "Mom's Eye: For each star being fired, it has a random chance to fire an additional star in the opposite direction. The direction is not influenced by Swift's auto-aim."},
			{str = "Mom's Knife: Stars are replaced by floating knives that deal 2x damage. They have a minimum lifetime of 2 seconds before the player's range stat can take effect, and all fire simultaneously. The rate that these knives appear are determined are equal to your firerate x 1.5."},
			{str = "Mom's Knife + Tech X: Tech X rings surround each knife, having a small radius and deals 25% of the player's damage."},
			{str = "Monstro's Lung: Acts as a multi-tear modifier, having 6 additional stars orbit every initially spawned star, with their distance from the star and size being randomized."},
			{str = "- Monstro's Lung + 20/20 and other multi-shot effects: The number of stars that these items would usually add are doubled, up to a maximum of 16."},
			{str = "- Monstro's Lung + Brimstone: Shoots 3-5 additional beams in random directions around the initial star."},
			{str = "- Monstro's Lung + Mom's Knife: Shoots 3-5 additional knives in random directions around the initial star."},
			{str = "- Monstro's Lung Copies: Adds 3 additional stars for each copy. For all other attack types, adds 4."},
			{str = "- Monstro's Lung + Dr. Fetus: Shoots 3-5 additional bombs within a 30 degree radius in the direction the star was fired."},
			{str = "- Monstro's Lung + Technology: Shoots 3-5 additional lasers within a 60 degree radius in the direction the star was fired."},
			{str = "- Monstro's Lung + Tech X: Shoots 3-5 addtional laser rings within a 180 degree radius in the direction the star was fired."},
			{str = "Number One: Range decrease is less severe."},
			{str = "Ouija Board: Spectral is granted to anything that would copy the player's attacks or tears."},
			{str = "Ourobourus Worm: Stars do not spiral until fired."}, 
			{str = "Pop!: Orbiting stars can hit stars still floating, resulting in a better chance of more stars remaining on screen."},
			{str = "Proptosis: Stars will not shrink in size and damage until fired."},
			{str = "R U A Wizard?: No effect."},
			{str = "Ring Worm: Stars do not spiral until fired."},
			{str = "Rubber Cement: Stars will not bounce until fired."},
			{str = "Scissors: Stars will continue to orbit the body. While this makes the head useless, you gain more power on your body due to the blood gushing from it."},
			{str = "Spoon Bender: Homing is granted to anything that would copy the player's attacks or tears."},
			{str = "Tech X: Stars are replaced by laser orbs. When fired, releases a laser ring. The ring scales in radius and damage equal to how long Swift has been charged, going from 25% to 100% damage at the beginning and end of Swift's charge respecively."},
			{str = "Tech.5: Functions normally with Eevee, bypassing their blindfold."},
			{str = "Technology: Stars are replaced by technology orbs. The orbs do continuous damage to anything that touches it, determined by the player's damage. Once Swift fires, all surrounding orbs simultaneously fire a Technology laser in the direction the player fired them in. The rate that these orbs appear are determined are equal to your firerate x 1.5."},
			{str = "Technology 2: Constant firing technology lasers are attached to each star, disappearing after the star has been fired."},
			{str = "Technology Zero: Orbiting stars are connected by a laser, fully encircling the player with the exception of one opening."},
			{str = "The Intruder: Eevee does not visually have the familiar in their head, but still fires the extra quad shot."},
			{str = "The Wiz: For each star being fired, it will shoot diagonally and shoot an additional star in the opposite diagonal direction. This additional shot is influenced by Swift's auto-aim, unlike Loki's Horns or Mom's Eye"},
			{str = "Tiny Planet: Similar to Soy Milk, stars will continuously orbit the player until the fire buttons are let go, firing off additional stars at a rate equal to your firerate."},
			{str = "Tractor Beam: Stars float directly in front of Eevee until fired."},
			{str = "-- Negative"},
			{str = "Aquarius: Creeps do not inherit Swift's homing effect."},
			{str = "Bird's Eye / Ghost Pepper: No effect."},
			{str = "Brain Worm: Stars do not turn to enemies until fired, although given Swift's auto aim and homing, this is nearly pointless."},
			{str = "C Section: Overrides Swift."},
			{str = "Compound Fracture / The Parasite: Combined with Swift's spectral, stars will continuously create split stars as long as they hover over an obstacle. However, most split stars may end up staying in place due to them copying the initial star's velocity, which isn't very fast while Swift is in orbit around the player."},
			{str = "Cursed Eye: Overridden by Swift."},
			{str = "Dead Onion: As Swift already has spectral and relies heavily on its range to have time to focus attacks, this item isn't recommended."},
			{str = "Dead Tooth: No effect on Eevee, because they brush their teeth regularly."},
			{str = "Decap Attack: Stars will continue to orbit the body, making the item effectively useless."},
			{str = "Epic Fetus: Overrides Swift."},
			{str = "Eye of Greed: No effect."},
			{str = "Incubus / Twisted Pair: Fires normally. Swift stars are purely cosmetic."},
			{str = "Lead Pencil: No effect."},
			{str = "Mom's Wig: No effect."},
			{str = "Neptunus: No effect."},	
			{str = "Spirit Sword: Overrides Swift."},
			{str = "The Ludovico Technique: Overrides Swift."},
		},
		{ -- Trivia
			{str = "Trivia", fsize = 2, clr = 3, halign = 0},
			{str = "-- General"},
			{str = "Eevee originates from the Pokemon series, known as the Evolution Pokemon. It's known most for having 8 different evolved forms, the most of any Pokemon to date."},
			{str = "Swift is a move Eevee can learn in the Pokemon games, and is associated most with this move."},
			{str = "Swift in the Pokemon games is a Normal-type move, described as a move that shoots star-shaped rays at the opposing Pokemon, and that the attack never misses."},
			{str = "Eevee's pronouns in this mod are they/them."},
			{str = "Eevee: Reunited has been in development ever since Repentance released, but Eevee as a character mod has worked on since July 19th, 2019, starting from the Afterbirth+ version's very simple beginnings."},
			{str = "Eevee's unique hairstyle originated from when their sprite was first being created, and Eevee's usual small hair bits didn't translate well, so the creator asked for feedback. Someone suggested very big, fluffy hair."},
			{str = "-- Costumes"},
			{str = "Eevee has just over 500 unique costumes, on top of a custom-built system that removes undesired costumes, usually those that would harm Eevee in some form."},
			{str = "120 Volt: A Light Ball rests on Eevee's head, an item in the Pokemon games that if held by a Pikachu, raises their Attack and Special Attack stats."},
			{str = "A Pony / White Pony: The pony's head is that of the Pokemon 'Rapidash' and their Galarian form respectively."},
			{str = "Aquarius: Gives Eevee a white fin encircling their neck, the same one worn by Vaporeon, one of Eevee's evolutions."},
			{str = "Azazel's Stump: Creates a fusion between Azazel and Eevee"},
			{str = "Bookworm / Dr. Fetus: The Bookworm transformation adds a mustache, and Dr. Fetus only adds the hat, but with an added gold band. Both of these costumes are in reference to Sanio's Pokesona, being the main creator of this mod."},
			{str = "Camo Undies: Undies become pants, and resemble that of the Pokemon 'Zoroark', a Pokemon known for creating illusions."},
			{str = "Ceremonial Robes: The robes are Pikachu-themed robes, referencing a real-life plush of Eevee wearing a Pikachu-themed hooded cape."},
			{str = "Chaos: Makes Eevee 'scrunge'. In this context, scrunge is a term used to describe when cats squint their eyes and pull their mouth back, slightly opening them and revealing their teeth."},
			{str = "Dead Eye / Epiphora / Tractor Beam / X-Ray Vision: All costumes resemble different glasses found within the Pokemon Mystery Dungeon series. They are Scope Lens, Heavy Rotation Specs, Lock-on Specs, and X-Ray Specs respectively."},
			{str = "Eye of Greed / Head of the Keeper / Pay to Play / Money = Power: All costumes make use of the Poke Dollar symbol, the symbol of the main currency used in the Pokemon games."},
			{str = "Godhead: Godhead's aura (the costume layered beneath the player) takes the shape of the ring worn by the Pokemon 'Arceus', whom is referred to as the god of all Pokemon. However, due to it being behind the player, this mostly goes unseen."},
			{str = "Host Hat is instead a mask, with the looks of the Pokemon 'Duskull'"},
			{str = "Infamy: The mask resembles the one carried by the Pokemon 'Yamask'."},
			{str = "Lost Curse / Spirit Shackles: Eevee gains a full unique spritesheet for either of these effects."},
			{str = "Libra: Instead of half of Eevee's entire body being grey-colored, it instead uses their 'shiny' color palette used in the Pokemon games."},
			{str = "Luna / Whore of Babylon: Where the symbol on Isaac's head would usually be, is replaced with an oval ring, the same worn by Umbreon, one of Eevee's evolutions, although it is normally yellow."},
			{str = "Maggy's Bow / 'Heart': Both costumes are replaced with a bow resembling those worn by Sylveon, one of Eevee's evolutions."},
			{str = "Magneto: The Pokemon 'Magnemite' rests on top of Eevee's head."},
			{str = "Mr. Mega: The helmet takes on the appearance of a Poke Ball."},
			{str = "Reverse Chariot: The alternate skin that would normally show Edith instead shows an 8-bit Eevee statue standing atop a stone pedestal. This references similar statues from the Pokemon Gold and Silver games, found in the Ruins of Alph, where the statues are that of an undefinable Pokemon."},
			{str = "Spoon Bender: Gives Eevee a red gem on its forehead, the same of that on Espeon, one of Eevee's evolutions."},
			{str = "Shade: Shaped to resemble Eevee."},
			{str = "Tech 0 / Tech 0.5 / Technology / Technology 2 / Tech X: All borrowing from Nintendo consoles over the years, they reference the Virtual Boy, GameBoy, GameCube, Wii, and a Nintendo Switch Labo VR Headset respectively."},
			{str = "The Mark's: Mark is a small Poke Ball."},
			{str = "Tooth and Nail: Eevee's head resembles the Pokemon 'Ferroseed'."},
			{str = "Uranus: Gives Eevee the same tassles worn by Glaceon, one of Eevee's evolutions."},
		},
	},
}

local ItemsWiki = {
	TailWhip = {
		{ -- Effects
			{str = "Effects", fsize = 2, clr = 3, halign = 0},
			{str = "On use, extends a tail out that spins in a circle, knocking back enemies and projectiles."},
			{str = "Enemies hit are given a Weakness effect for 5 seconds, similar to that of XI - Strength?."},
			{str = "Projectiles hit are able to damage enemies."},
		},
		{ -- Notes
			{str = "Notes", fsize = 2, clr = 3, halign = 0},
			{str = "Eevee gains this item in the consumable slot after getting Birthright."},
			{str = "Tail Whip can also knock back invincible enemies."},
		},
		{ -- Interactions
			{str = "Interactions", fsize = 2, clr = 3, halign = 0},
			{str = "Car Battery / 9 Volt / The Battery: Activating Tail Whip on an enemy that has already been weakened from it will have its duration reset, but they do not stack."},
		},
	},
}

function eeveeEncyclopedia.Init(mod)
	EeveePortrait = Encyclopedia.RegisterSprite(mod.path .. "content/gfx/characterportraits.anm2", "Eevee", 0)
	EeveeBPortrait = Encyclopedia.RegisterSprite(mod.path .. "content/gfx/characterportraitsalt.anm2", "Eevee", 0)
end

function eeveeEncyclopedia.AddEncyclopediaDescs()

	Encyclopedia.AddCharacter({
		ModName = EEVEEMOD.Name,
		Name = "Eevee",
		ID = EEVEEMOD.PlayerType.EEVEE,
		Sprite = EeveePortrait,
		WikiDesc = CharactersWiki.PlayerEevee,
	})
	
	Encyclopedia.AddCharacterTainted({
		ModName = EEVEEMOD.Name,
		Name = "Eevee",
		Description = "The Dithered",
		ID = EEVEEMOD.PlayerType.EEVEE_B,
		Sprite = EeveeBPortrait,
		UnlockFunc = function(self) -- Again this is in case your tainted is "unlockable"
			self.Spr = EeveeBPortrait
			self.Desc = "Coming soon."
			self.TargetColor = Encyclopedia.VanillaColor
			
			return self
		end,
	})

	Encyclopedia.AddItem({
		ModName = EEVEEMOD.Name,
		ID = EEVEEMOD.CollectibleType.TAIL_WHIP,
		Name = "Tail Whip",
		Desc = "Aggressive tail wagging",
		WikiDesc = ItemsWiki.TailWhip,
	})
	
end

return eeveeEncyclopedia
