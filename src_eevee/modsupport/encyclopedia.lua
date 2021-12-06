local eeveeEncyclopedia = {}

local EeveePortrait

if Encyclopedia then
	
	local CharactersWiki = {
		PlayerEevee = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "HP: 2 Hearts."},
				{str = "- Speed: 1.00"},
				{str = "- Tear Rate: 2.73"},
				{str = "- Damage: 2.80"},
				{str = "- Range: 11.00"},
				{str = "- Shot Speed: 1.20"},
				{str = "- Luck: 0.00"},
			},
			{ --Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "Eevee does not fire tears directly, instead using the move 'Swift'. When firing, up to 5 stars form around Eevee over time before they are automatically shot forward, or when Eevee stops firing."},
				{str = "There is a cooldown between forming the next volley of Swift stars dependent on your firerate."},
				{str = "Swift stars are inherently given spectral, and after firing, are given homing."},
				{str = "Swift stars retain the exact same effects as tears would."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Gives Eevee the Tail Whip item to knockback enemies and projectiles."},
			},
			{ -- Notes
				{str = "Notes", fsize = 2, clr = 3, halign = 0},
				{str = "Having a similar issue to Lilith with not being able to attack directly in front of their character, Eevee has trouble defending themselves with enemies up-close. Take advantage of Swift's high range and homing by keeping your distance."},
				{str = "Swift does not respawn stars that are lost in the middle of charging its attack. Piercing can help remedy this issue."},
				{str = "Items that give homing or spectral, such as Spoon Bender and Ouija Board, are not entirely useless, as the effects are applied to Swift's stars directly instead of adding to the player's tear effects. Homing can allow Swift's starts to home during its charge-up attack, and spectral will apply to other attacks."},
				{str = "If Eevee has any laser attacks, homing and spectral will given directly to Eevee, affecting all attacks."},
				{str = "Range downs are extremely detrimental to Eevee, as the homing effect has less time to take effect, having less control over Swift's stars."},
				{str = "Technology Zero connects each star with a technology laser, creating a full circle when Swift has fully charged."},
				{str = "Lost Contact is a great item for Swift as the stars will block shots as they constantly surround you, and faster firerates allow you to block projectiles in a wider spread."},
				{str = "Items that can deal damage in close proximity such as Maw of the Void, Salvation, any orbitals, familiars, and so on, are highly recommended defensive options for Eevee."},
				{str = "Eevee's inherent blindfold is toggled on and off for tear modifiers that Swift is overridden by, such as Ludovico Technique or Spirit Sword. When these are obtained, effects that are disabled from a blindfold may be re-enabled."},
			},
			{ -- Interactions
				{str = "Interactions", fsize = 2, clr = 3, halign = 0},
				{str = "20/20 / The Inner Eye / Mutant Spider: Adds 1, 2, or 3 smaller-sized stars to each initially spawned star respectively, similar to that of Ludovico Technique, up to 16."},
				{str = "Almond Milk: Swift changes to a rapid-fire attack mode. Stars orbit around Eevee at a fixed rate, and once all 5 stars form, begin shooting additional stars based on your firerate."},
				{str = "Analog Stick: Allows stars to be fired in any direcion."},
				{str = "Anti-Gravity: Continuing to hold the fire buttons after Swift has fired causes the stars to float midair. The stars will all shoot in the direction they were originally fired when either the fire buttons are released or after it has flashed 5 times indicated by a blue tint. Their original firing direction will be overwritten if the star is moved by other means."},
				{str = "Anti-Gravity + Dr. Fetus: Due to Swift's nature, bombs fired will also stay in place. Bombs will not countdown their detonation when in place."},
				{str = "Anti-Gravity + Tech X: Due to Swift's nature, rings fired will also stay in place. Homing does not move the ring itself, so it will always fire in the direction it was originally fired in."},
				{str = "Birds Eye: Spawns fire from Eevee's mouth."},
				{str = "Brimstone: Stars are replaced by damaging Brimstone orbs. When fired, releases a Brimstone laser."},
				{str = "Brimstone + Almond Milk / Soy Milk: Beam can be fired continuously after charging."},
				{str = "Brimstone + Mom's Knife: Shoots out 1-5 additional knives outwards from Eevee, distrubuted evenly. The number of knives that shoot out are dependent on your charge time."},
				{str = "C Section: Overrides Swift. Proper synergy coming soon."},
				{str = "Conjoined: Each star fires 2 additional stars diagonally outward. These additional stars are not active until the initial star has fired."},
				{str = "Chocolate Milk: Damage of all stars is linked to how long Swift is charged, starting at 50% of their damage at the beginning of the charge and ending at 200%."},
				{str = "Cursed Eye: No effect, due to Eevee's inherent blindfold."},
				{str = "Dead Tooth: No effect, due to Eevee's inherent blindfold."},
				{str = "Dr. Fetus: Stars are replaced with bombs. They do not start their detonation countdown until fired."},
				{str = "Epic Fetus: Overrides Swift"},
				{str = "Eye Drops: Benefits directly from the firerate up. No other changes."},
				{str = "Eye of the Occult: Stars are controllable mid-flight after being fired from Swift."},
				{str = "Eye Sore: Each star has a chance to fire 1-3 additional stars in random directions. These additional stars are not active until the initial star has fired."},
				{str = "Flat Stone: Effect does not trigger until after Swift has fired."},
				{str = "Ghost Pepper: Spawns fire from Eevee's mouth."},
				{str = "Giant Cell: Causes Eevee to spawn micro-Eevees when they take damage, which chase and shoot at nearby enemies. Their stars change to look like Swift's stars, but otherwise their usual functionality remains the same."},
				{str = "Guillotine: Stars still summon in the same orbit, ignoring the head."},
				{str = "Hook Worm: Effect does not trigger until after Swift has fired."},
				{str = "Immaculate Heart: No effect, due to Eevee's inherent blindfold."},
				{str = "Incubus: Familiar fires normally."},
				{str = "Ipecac: Stars orbit further away from Eevee to avoid self-damage as the attack is being charged up. Once fired, however, are very dangerous, as stars behind Eevee will shoot forward and can explode if coming into contact with an enemy."},
				{str = "Lead Pencil: No effect, as Eevee is inherently blindfolded."},
				{str = "Loki's Horns: Each star has a chance to fire 3 additional stars in the other cardinal directions. These additional stars are not active until the initial tear has fired."},
				{str = "Lost Contact: Orbit distance of stars is reduced."},
				{str = "Lost Contact + Ipecac: Ipecac's orbit distance overwrites Lost Contact's."},
				{str = "Marked: Eevee will automatically fire Swift. The stars do not converge to the target, simply firing in its direction."},
				{str = "Mom's Eye: Each star has a chance to fire an additional star behind it. This additional star is not active until the initial star has fired."},
				{str = "- Mom's Eye + Loki's Horns: Both items still retain their separate chances of firing. If both would activate at the same time, only Loki's Horns will activate."},
				{str = "Mom's Knife: Stars are replaced by floating knives that deal 2x Eevee's damage. They have a minimum lifetime of 2 seconds before Eevee's range stat can take effect."},
				{str = "- Mom's Knife + Anti-Gravity: Has a 0/1 chance to activate XXI - The World."},
				{str = "Monstro's Lung: Acts as a multi-tear modifier, adding 6 stars to every shot, with their distance from the initial star and size being randomized."},
				{str = "- Monstro's Lung + 20/20 / The Inner Eye / Mutant Spider: The number of stars that these items would usually add are doubled, to give 2, 4, and 6 additional stars respectively, up to a maximum of 16."},
				{str = "- Monstro's Lung + Brimstone: Shoots 3-5 additional beams in random directions around the initial shot."},
				{str = "- Monstro's Lung + Mom's Knife: Shoots 3-5 additional knives in random directions around the initial shot."},
				{str = "- Monstro's Lung Copies: Adds 3 additional stars for each copy. For all other attack types, adds 4."},
				{str = "- Monstro's Lung + Dr. Fetus: Shoots 3-5 additional bombs within a 30 degree radius in the direction the shot was fired."},
				{str = "- Monstro's Lung + Technology: Shoots 3-5 additional lasers within a 60 degree radius in the direction the shot was fired."},
				{str = "- Monstro's Lung + Tech X: Shoots 3-5 addtional laser rings within a 180 degree radius in the direction the shot was fired."},
				{str = "Neptunus: No effect, as Eevee is inherently blindfolded."},
				{str = "Ouroborus Worm: Effect does not trigger until after Swift has fired."},
				{str = "Ouija Board: Grants spectral stars to other forms of player attacks."},
				{str = "Proptosis: Effect does not trigger until after Swift has fired."},
				{str = "Ring Worm: Effect does not trigger until after Swift has fired."},
				{str = "R U a Wizard?: Each star is fired diagonally, flipping between shooting at a 45 and -45 degree angle per star."},
				{str = "Soy Milk: Swift changes to a rapid-fire attack mode. Stars orbit around Eevee at a fixed rate, and once all 5 stars form, begin shooting additional stars based on your firerate."},
				{str = "Spirit Sword: Overrides Swift."},
				{str = "Spoon Bender: Swift's stars can home in on enemies before they are fired."},
				{str = "Tech X: Stars are replaced by damaging laser orbs. When fired, releases a laser ring. The damage and radius of all rings are linked to the duration of the Swift attack, starting at 25% of their damage at the beginning of the attack and ending at 100%."},
				{str = "- Tech X + Brimstone: Stars are replaced by Brimstone orbs."},
				{str = "Tech.5: Functions normally, bypassing Eevee's inherent blindfold."},
				{str = "Technology: Stars are replaced by damaging laser orbs. When fired, releases a technology laser."},
				{str = "Technology 2: Constant firing technology lasers are attached to each star. The lasers will continuously fire until the star it is attached to has been fired off."},
				{str = "The Intruder: The Intruder's tears come from Eevee, despite their inherent blindfold."},
				{str = "The Ludovico Technique: Overrides Swift."},
				{str = "The Wiz: Each star splits into two stars when fired, firing off diagonally. The second split star is not active until the initial star has fired."},
				{str = "- The Wiz Copies: An additional copy of The Wiz fires another star firing forward while keeping the diagonal-shot stars, similar to that of Conjoined. Further copies of the Wiz will count as a multi-tear, equivalent to that of 20/20."},
				{str = "Tiny Planet: Swift's stars orbit at twice the distance they normally would from Eevee, and rotate at a fixed rate. This orbit shrinks the longer Swift is charged, returning to its normal orbit by the end of the charge."},
				{str = "Tractor Beam: All stars stay at their orbit distance inside the beam until fired."},
				{str = "Twisted Pair: Familiar fires normally."},
			},
			{ -- Trivia
				{str = "Trivia", fsize = 2, clr = 3, halign = 0},
				{str = "-- General"},
				{str = "Eevee originates from the Pokemon series, known as the Evolution Pokemon. It's known most for having 8 different evolved forms, the most of any Pokemon to date."},
				{str = "Swift is a move Eevee can learn in the Pokemon games, and is associated most with this move."},
				{str = "Swift in the Pokemon games is a Normal-type move, described as a move that shoots star-shaped rays at the opposing Pokemon, and that the attack never misses."},
				{str = "The Eevee in this mod is "},
				{str = "-- Costumes"},
				{str = "Eevee has just over 500 unique costumes, on top of a custom-built system that removes undesired costumes, usually those that would harm Eevee in some form."},
				{str = "Tech 0, Tech 0.5, Technology, Technology 2, and Tech X all borrow from Nintendo consoles over the years. They reference the Virtual Boy, GameBoy, GameCube, Wii, and a Nintendo Switch Labo VR Headset respectively."},
				{str = "120 Volt takes on the appearance of a Light Ball, an item in the Pokemon games that if held by a Pikachu, raises their Attack and Special Attack stats."},
				{str = "Mr. Mega takes on the appearance of a Poke Ball"},
				{str = "Eevee is the only known character to give a unique costume for Azazel's Stump and Reverse Hanged Man. Both create a fusion between Eevee and their respective character."},
				{str = "Ceremonial Robes turns into Pikachu Robes, referencing a real-life plush of Eevee wearing a Pikachu-themed hooded cape."},
				{str = "A Pony turns the pony's head into that of the Pokemon 'Rapidash', while White Pony turns the head into Rapidash's Galarian form."},
				{str = "There are several costumes that take on the look of different glasses found within the Pokemon Mystery Dungeon series. X-Ray Vision is 'X-Ray Specs', Deadeye is 'Scope Lens', Epiphora is 'Heavy Rotation Specs', and Tractor Beam is 'Lock-on Specs'."},
				{str = "Dr. Fetus only adds the hat, but with an added gold band. The Bookworm transformation adds a mustache. Both of these costumes are in reference to Sanio's Pokesona, the main creator of this mod."},
				{str = "Both Maggy's Bow and <3 are replaced with a bow worn on Sylveon, one of Eevee's evolutions."},
				{str = "Chaos makes Eevee 'scrunge'. In this context, scrunge is a term used to describe when cats squint their eyes and pull their mouth back, slightly opening them and revealing their teeth."},
				{str = "Infamy is replaced with the mask carried by the Pokemon 'Yamask'."},
				{str = "With Whore of Babylon and Luna, where the appropriate symbol on Isaac's head would usually be, is replaced with an oval ring. This ring references the same one attached to Umbreon, one of Eevee's evolutions, although it is normally yellow."},
				{str = "Instead of half of Eevee's entire body being grey-colored, it instead uses their 'shiny' color palette used in the Pokemon games."},
				{str = "Magneto has the Pokemon 'Magnemite' resting on top of the middle of Eevee's head"},
				{str = "Camo Undies resemble that of the Pokemon 'Zoroark', a Pokemon known for creating illusions."},
				{str = "Uranus gives Eevee the same tassles worn by Glaceon, one of Eevee's evolutions."},
				{str = "Godhead's aura (the costume layered beneath the player) takes the shape of the ring worn by the Pokemon 'Arceus', whom is referred to as the god of all Pokemon. However, due to it being behind the player, this mostly goes unseen."},
				{str = "The alternate skin for Reverse Chariot that would normally show Edith instead shows an 8-bit Eevee statue standing atop a stone pedestal. This references similar statues from the Pokemon Gold and Silver games, found in the Ruins of Alph, which the statue is that of an undefinable Pokemon."},
				{str = "The Mark's mark is a small Poke Ball"},
				{str = "Head of the Keeper, Eye of Greed, Pay to Play, and Money = Power all make use of the Poke Dollar symbol, the symbol of the main currency used in the Pokemon games."},
				{str = "Spoon Bender gives Eevee a red gem on its forehead, the same of that on Espeon, one of Eevee's evolutions."},
				{str = "Aquarius gives Eevee a white fin encircling their neck, belonging to Vaporeon, one of Eevee's evolutions."},
				{str = "Shade is uniquely resprited for Eevee to have more likeness."},
				{str = "Host Hat is instead a mask, with the looks of the Pokemon 'Duskull'"},
				{str = "Tooth and Nail has Eevee's head resemble the Pokemon 'Ferroseed'."},
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
	end
	
	function eeveeEncyclopedia.AddEncyclopediaDescs()
	
		Encyclopedia.AddCharacter({
			ModName = EEVEEMOD.Name,
			Name = "Eevee",
			ID = EEVEEMOD.PlayerType.EEVEE,
			Sprite = EeveePortrait,
			WikiDesc = CharactersWiki.PlayerEevee,
		})

		Encyclopedia.AddItem({
			ModName = EEVEEMOD.Name,
			ID = EEVEEMOD.CollectibleType.TAIL_WHIP,
			Name = "Tail Whip",
			Desc = "Aggressive tail wagging",
			WikiDesc = ItemsWiki.TailWhip,
		})
		
	end

end

return eeveeEncyclopedia
