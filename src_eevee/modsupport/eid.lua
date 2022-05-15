local eid = {}

if not EID then return eid end

local eeveeIcons = Sprite()
eeveeIcons:Load("gfx/ui/eid_eevee_icons.anm2")
local Player = {
	Eevee = "Player" .. EEVEEMOD.PlayerType.EEVEE,
	--[[ Flareon = "Player"..EEVEEMOD.PlayerType.FLAREON,
	Jolteon = "Player"..EEVEEMOD.PlayerType.JOLTEON,
	Vaporeon = "Player"..EEVEEMOD.PlayerType.VAPOREON,
	Espeon = "Player"..EEVEEMOD.PlayerType.EEVEE,
	Umbreon = "Player"..EEVEEMOD.PlayerType.EEVEE,
	Glaceon = "Player"..EEVEEMOD.PlayerType.EEVEE,
	Leafeon = "Player"..EEVEEMOD.PlayerType.EEVEE,
	Sylveon = "Player"..EEVEEMOD.PlayerType.EEVEE ]]
}
EID:addIcon(Player.Eevee, "Players", 0, 12, 12, -1, 1, eeveeIcons)
--[[
EID:addIcon(Player.Flareon, "Players", 1, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Jolteon, "Players", 2, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Vaporeon, "Players", 3, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Espeon, "Players", 4, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Umbreon, "Players", 5, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Glaceon, "Players", 6, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Leafeon, "Players", 7, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.Sylveon, "Players", 8, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.EeveeB, "Players", 9, 12, 12, -1, 1, eeveeIcons)
]]

EID:addIcon("Card" .. EEVEEMOD.PokeballType.POKEBALL, "Poke Balls", 0, 9, 9, -1, 0, eeveeIcons)
EID:addIcon("Card" .. EEVEEMOD.PokeballType.GREATBALL, "Poke Balls", 1, 9, 9, -1, 0, eeveeIcons)
EID:addIcon("Card" .. EEVEEMOD.PokeballType.ULTRABALL, "Poke Balls", 2, 9, 9, -1, 0, eeveeIcons)

EID:setModIndicatorIcon(Player.Eevee)

--English descriptions
local CollectibleDescs_EN = {
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = { "Sneak Scarf", "{{ArrowUp}} +0.3 {{Speed}} Speed up#All enemies in the room are permanently confused#Coming within close proximity of a confused enemy this way clears it of its confusion status. Getting out of range will not re-confuse it#Does not affect bosses" },
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = { "Shiny Charm", "{{ArrowUp}} +1 {{Luck}} Luck up#Highly increases the chance for normal enemies to become shiny#Shiny enemies have increased health, will run away from the player, and disappear after some time#Shiny enemies drop a Golden Trinket on death" },
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = { "Black Glasses", "{{ArrowUp}} +0.5 Flat Damage up#{{Damage}} Gain a small Damage multiplier for each Devil Deal taken based on the cost of the item without modifiers#Works retroactively with deals taken before picking up the item" },
	[EEVEEMOD.CollectibleType.COOKIE_JAR[6]] = { "Cookie Jar", "Upon use, heals 1 full {{Heart}} Red Heart, up to 6 times#{{ArrowDown}} -0.2 {{Speed}} Speed down on every use, but goes away slowly over time#{{ArrowUp}} On the final use, is consumed and grants +2 {{Heart}} Red Heart containers" },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = { "Strange Egg", "Charges +1 bar per floor#Can be used when not fully charged, with different effects based on its charge:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: Heals 3 {{Heart}} Red Hearts#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: Spawns {{Collectible" .. CollectibleType.COLLECTIBLE_BREAKFAST .. "}} Breakfast and 2 {{Heart}} Red Hearts#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: Spawns {{Collectible" .. EEVEEMOD.CollectibleType.LIL_EEVEE .. "}} Lil Eevee and 2 {{Heart}} Red Hearts" },
	[EEVEEMOD.CollectibleType.LIL_EEVEE] = { "Lil Eevee", "Normal tear familiar#The familiar's form changes randomly when Isaac uses a rune, having different tears for each form#Possible tears are similar to that of {{" .. Player.Eevee .. "}} Eevee and their Eeveelutions" },
	[EEVEEMOD.CollectibleType.BAD_EGG] = { "Bad EGG", "Blocks projectiles, up to 32 before breaking#{{Warning}} Upon breaking, replaces a random owned famliiar with a duplicate {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG_DUPE .. "}} Bad EGG, and restores Bad EGG#Duplicates block less projectiles and disappear when breaking, respawning when Bad EGG breaks#If no other familiars are owned when broken, outside of duped Bad EGGs, removes Bad EGG and Spawns {{Collectible" .. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} Strange Egg" },
	[EEVEEMOD.CollectibleType.BAD_EGG_DUPE] = { "Duped Bad EGG", "Blocks projectiles, up to 8 before disappearing#{{Warning}} Can only be respawned if {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG .. "}} Bad EGG is owned and that familiar 'breaks'" },
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = { "Wonderous Launcher", "Uses your pickups as ammunition and launches them:#{{Coin}} Amount consumed and damage dealt depends on coin count#{{Key}} Behaves like {{Collectible" .. CollectibleType.COLLECTIBLE_SHARP_KEY .. "}} Sharp Key#{{Bomb}} Fires a bomb with all the player's bomb effects#{{PoopPickup}} If throwable, consumes your next spell in queue. Spawns its respective poop on contact." },
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = { "Bag of Poké Balls", "Every 12 rooms, spawns a random type of Poké Ball#50% {{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} Poké Ball #30% {{Card" .. EEVEEMOD.PokeballType.GREATBALL .. "}} Great Ball #20% {{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} Ultra Ball" },
	[EEVEEMOD.CollectibleType.MASTER_BALL] = { "Master Ball - {{Throwable}}", "Can be thrown at an enemy or boss to capture them, turning them into a friendly companion#{{Warning}} Successful capture results in this item being destroyed#Walking over the ball or leaving the room instantly recharges the item#Has an extreme effect on the captured enemy's health" },
	[EEVEEMOD.CollectibleType.POKE_STOP] = { "Poke Stop", "Spawns a Poke Stop on first pickup. Every floor a Poke Stop appears in a random special room#Interacting with it has it drop a random assortment of {{Coin}} Coins, {{Key}} Keys, and {{Bomb}} Bombs, and a special pickup based on the type of room it's in" },
	[EEVEEMOD.Birthright.TAIL_WHIP] = { "Tail Whip", "Extends a tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a {{Weakness}} Weakness effect for 5 seconds#Projectiles hit can damage enemies" },
}
local TrinketDescs_EN = {
	[EEVEEMOD.TrinketType.EVIOLITE] = { "Eviolite", "Grants the following stats if you don't have a transformation:#{{ArrowUp}} +0.2 {{Speed}} Speed up#{{ArrowUp}} +10% {{Tears}} Tears Up#{{ArrowUp}} +10% {{Damage}} Damage Multiplier#{{ArrowUp}} +2 {{Range}} Range up#{{ArrowUp}} +0.2 {{Shotspeed}} Shot Speed up" },
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = { "Lock-On Specs", "{{ArrowUp}} +100% {{Damage}} Damage Multiplier#{{ArrowUp}} +3 {{Range}} Range up#{{ArrowUp}} +0.3 {{Shotspeed}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +10%" },
	[EEVEEMOD.TrinketType.ALERT_SPECS] = { "Alert Specs", "Prevents Isaac from dropping coins caused by taking damage from Greed enemies and projectiles" },
}
local TrinketDescs_Golden_EN = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		[2] = "Grants the following stats if you don't have a transformation:#{{ArrowUp}} +{{ColorGold}}0.3{{ColorWhite}} {{Speed}} Speed up#{{ArrowUp}} +{{ColorGold}}15%{{ColorWhite}} {{Tears}} Tears Up#{{ArrowUp}} +{{ColorGold}}15%{{ColorWhite}} {{Damage}} Damage Multiplier#{{ArrowUp}} +{{ColorGold}}4{{ColorWhite}} {{Range}} Range up#{{ArrowUp}} +{{ColorGold}}0.4{{ColorWhite}} {{Shotspeed}} Shot Speed up",
		[3] = "Grants the following stats if you don't have a transformation:#{{ArrowUp}} +{{ColorGold}}0.4{{ColorWhite}} {{Speed}} Speed up#{{ArrowUp}} +{{ColorGold}}40%{{ColorWhite}} {{Tears}} Tears Up#{{ArrowUp}} +{{ColorGold}}40%{{ColorWhite}} {{Damage}} Damage Multiplier#{{ArrowUp}} +{{ColorGold}}6{{ColorWhite}} {{Range}} Range up#{{ArrowUp}} +{{ColorGold}}0.4{{ColorWhite}} {{Shotspeed}} Shot Speed up",
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		[2] = "{{ArrowUp}} +{{ColorGold}}200%{{ColorWhite}} {{Damage}} Damage Multiplier#{{ArrowUp}} +{{ColorGold}}6{{ColorWhite}} {{Range}} Range up#{{ArrowUp}} +{{ColorGold}}0.6{{ColorWhite}} {{Shotspeed}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +{{ColorGold}}20%{{ColorWhite}}",
		[3] = "{{ArrowUp}} +{{ColorGold}}300%{{ColorWhite}} {{Damage}} Damage Multiplier#{{ArrowUp}} +{{ColorGold}}9{{ColorWhite}} {{Range}} Range up#{{ArrowUp}} +{{ColorGold}}0.9{{ColorWhite}} {{Shotspeed}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +{{ColorGold}}30%{{ColorWhite}}",
	},
}
local CardDescs_EN = {
	[EEVEEMOD.PokeballType.POKEBALL] = { "Poké Ball - {{Throwable}}", "Throw at enemies and bosses to capture them#Captured enemies become permanently charmed#Ball may break after capture#On bosses, may resist capture depending on HP and status effects, will always break regardless of capture#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} x1 Capture Rate, small effect on health" },
	[EEVEEMOD.PokeballType.GREATBALL] = { "Great Ball - {{Throwable}}", "Throw at enemies and bosses to capture them#Captured enemies become permanently charmed#Ball may break after capture#On bosses, may resist capture depending on HP and status effects, will always break regardless of capture#{{Card" .. EEVEEMOD.PokeballType.GREATBALL .. "}} x2 Capture Rate, moderate effect on health" },
	[EEVEEMOD.PokeballType.ULTRABALL] = { "Ultra Ball - {{Throwable}}", "Throw at enemies and bosses to capture them#Captured enemies become permanently charmed#Ball may break after capture#On bosses, may resist capture depending on HP and status effects, will always break regardless of capture#{{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} x3 Capture Rate, large effect on health" },
}
local BirthrightDescs_EN = {
	[EEVEEMOD.PlayerType.EEVEE] = { "Eevee", "Gives Eevee the {{Collectible" .. EEVEEMOD.Birthright.TAIL_WHIP .. "}} Tail Whip ability#Spins Eevee's tail in a circle, knocking back enemies and projectiles" },
}
local CollectiblesDescs_Modified_EN = {
	[CollectibleType.COLLECTIBLE_ALMOND_MILK] = "Stars continuously orbit Eevee and fire additional stars based on firerate, releasing once Eevee stops firing",
	[CollectibleType.COLLECTIBLE_ANGELIC_PRISM] = "Stars orbit closer to Eevee",
	[CollectibleType.COLLECTIBLE_BRIMSTONE] = "Stars are replaced with large blood orbs, firing lasers on release",
	[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = "Stars scale in damage according to how long Swift has been charged, from 50% to 200% damage",
	[CollectibleType.COLLECTIBLE_CURSED_EYE] = "{{ColorRed}}No effect",
	[CollectibleType.COLLECTIBLE_DR_FETUS] = "Stars are repalced with bombs and do not start detonating until fired from Swift",
	[CollectibleType.COLLECTIBLE_EPIC_FETUS] = "{{Warning}} Overrides Swift",
	[CollectibleType.COLLECTIBLE_EYE_SORE] = "Extra shots will originate from your stars when fired from Swift",
	[CollectibleType.COLLECTIBLE_FIRE_MIND] = "Stars orbit outside of explosion radius from Eevee",
	[CollectibleType.COLLECTIBLE_INCUBUS] = "{{Warning}} Does not copy Swift's homing, spectral, or auto-aim",
	[CollectibleType.COLLECTIBLE_IPECAC] = "Stars do not arc#Stars orbit outside of explosion radius from Eevee",
	[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = "Extra shots will originate from your stars when fired from Swift",
	[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "Stars orbit closer to Eevee",
	[CollectibleType.COLLECTIBLE_MOMS_EYE] = "Extra shots will originate from your stars when fired from Swift",
	[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "Stars are replaced with knives and have a limited lifetime dependent on range once fired",
	[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] = "6 additional stars orbit each star at random distances",
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = "{{ColorRed}}No effect",
	[CollectibleType.COLLECTIBLE_SOY_MILK] = "Stars continuously orbit Eevee and fire additional stars based on firerate, releasing once Eevee stops firing",
	[CollectibleType.COLLECTIBLE_SPRINKLER] = "{{Warning}} Does not copy Swift's homing, spectral, or auto-aim",
	[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "Swift stars spawn around you during the spin attack, shooting forward when finishing the spin#{{ArrowDown}} Can no longer fire projectiles",
	[CollectibleType.COLLECTIBLE_SUMPTORIUM] = "{{Warning}} Clots do not copy Swift's homing, spectral, or auto-aim",
	[CollectibleType.COLLECTIBLE_TECH_X] = "Stars are replaced with technology orbs, firing laser rings on release",
	[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "Stars are replaced with technology orbs, firing lasers on release",
	[CollectibleType.COLLECTIBLE_TECHNOLOGY_2] = "Stars let out a continuous laser before they are fired from Swift",
	[CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE] = "Replaces the giant tear with a spinning ring of 5 Swift stars",
	[CollectibleType.COLLECTIBLE_TINY_PLANET] = "Stars continuously orbit Eevee and fire additional stars based on firerate, releasing once Eevee stops firing",
	[CollectibleType.COLLECTIBLE_TWISTED_PAIR] = "{{Warning}} Does not copy Swift's homing, spectral, or auto-aim",
}
local TrinketDescs_Modified_EN = {
	[EEVEEMOD.TrinketType.EVIOLITE] = "Increases all stats by +100%, but are also lost upon evolving#{{Warning}} As evolutions are not yet implemented, these bonus stats are disabled"
}

--Spanish descriptions
local CollectibleDescs_SPA = {
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = {"Bufanda de escape", "{{ArrowUp}} {{Speed}} Velocidad +0.3#{{Confusion}} Todos los enemigos en la sala quedarán confundidos#Acercarse a un anemigo revertirá su estado de confusión. Alejarse no lo volverá a confundir#No afecta a los jefes"},
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = {"Amuleto Iris", "{{ArrowUp}} {{Luck}} Suerte +1#Aumenta demasiado la posibilidad de que los enemigos sean {{ColorRainbow}}Variocolor{{CR}}#Estos enemigos tienen más salud, correrán lejos del jugador y desaparecerán tras un tiempo#Estos pueden soltar una baratija dorada al morir"},
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = {"Lentes oscuros", "{{ArrowUp}} Daño +0.5{{Damage}}#{{DevilRoom}} Recibes un pequeño multiplicador de daño por cada trato con el Diablo que hayas hecho#Trabaja de forma retroactiva con los tratos hechos antes de tomar el objeto"},
	[EEVEEMOD.CollectibleType.COOKIE_JAR[6]] = {"Tarro de galletas", "{{Heart}} Cura un corazón rojo en cada uso hasta 6 veces#{{ArrowDown}} {{Speed}} Velocidad -0.2 por cada uso, pero se reestablece tras un tiempo#{{Heart}} Tras su último uso, es consumido y otorga 2 contenedores de corazón"},
	[EEVEEMOD.CollectibleType.BAD_EGG] = { "Huevo malo", "Bloquea hasta 32 proyectiles antes de romperse#{{Warning}} al momento de romperse, reemplaza uno de tus familiares con {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG_DUPE .. "}} un Huevo Malo#Los duplicados bloquean menos proyectiles y desaparecen al romperse, reapareciendo cuando el huevo malo se rompe#Si no hay otro familiar al romperse, a parte de los huevos malos duplicados, remueve un Huevo Malo y lo reemplaza con un {{Collectible" .. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} Huevo extraño" },
	[EEVEEMOD.CollectibleType.BAD_EGG_DUPE] = { "Huevo malo duplicado", "Bloquea hasta 8 proyectiles antes de desaparecer#{{Warning}} Sólo se puede regenerar si es que se tiene al {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG .. "}} Huevo Malo y ese familiar se 'rompe'" },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = {"Strange Egg", "Recibe +1 carga por piso#Puede ser usado sin estar completamente cargado, con distintos efectos en base a sus cargas:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: {{Heart}} Cura 3 corazones rojos#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: Genera {{Collectible"..CollectibleType.COLLECTIBLE_BREAKFAST.."}} Desayuno y {{Heart}} 2 corazones rojos#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: Spawns {{Collectible"..EEVEEMOD.CollectibleType.LIL_EEVEE.."}} Lil Eevee and 2 {{Heart}} Red Hearts"},
	[EEVEEMOD.CollectibleType.LIL_EEVEE] = {"Pequeño Eevee", "Familiar de disparo regular#{{Rune}} El aspecto del familiar cambiará cada vez que se use una runa, teniendo distintos efectos de lágrimas#{{"..Player.Eevee.."}} Las lágrimas pueden ser similares a las de Eevee y sus Eeveeluciones"},
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = {"Lanzador", "Utiliza tus recolectables como munición:#{{Coin}} La cantidad consumida y daño dependerá de tu cantidad de monedas#{{Key}} Es igual que la {{Collectible"..CollectibleType.COLLECTIBLE_SHARP_KEY.."}} Llave afilada(¿Así se llama?)#{{Bomb}} Dispara una bomba con todos los efectos de bomba que tenga el jugador#{{PoopPickup}} Si se puede lanzar, consumirá el siguiente efecto en la lista. Genera su respectiva popó al contacto"},
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = {"Bolsa de Pokébolas", "Cada 12 salas, genera una Pokébola aleatoria#{{Card"..EEVEEMOD.PokeballType.POKEBALL.."}} 50% de posibilidad de una Pokébola #{{Card"..EEVEEMOD.PokeballType.GREATBALL.."}} 30% de posibilidad de una Superbola#{{Card"..EEVEEMOD.PokeballType.ULTRABALL.."}} 20% de posibilidad de una Ultrabola"},
	[EEVEEMOD.CollectibleType.MASTER_BALL] = {"Master Ball - {{Throwable}}", "Puede ser lanzado a un enemigo o un jefe para capturarlo, Convirtíendolo en un compañero#{{Warning}} Una captura exitosa destruirá el objeto#Caminar sobre la bola o dejar la sala recargará el objeto#Tiene un efecto extremo en la salud del capturado"},
	[EEVEEMOD.CollectibleType.POKE_STOP] = {"Poképarada", "Se generará una Poképarada al momento de tomarlo. En cada piso aparecerá una Poképarada en una sala especial aleatoria#Interactuar con esta soltará una cierta cantidad de {{Coin}} Monedas, {{Key}} Llaves, y {{Bomb}} Bombas, junto a un recolectable especial basado en la sala"},
	[EEVEEMOD.Birthright.TAIL_WHIP] = {"Látigo", "Extiende una cola que ace un ataque giratorio, aplicando retroceso a los enemigos y reflectando disparos#{{Weakness}} Los enemigos golpeados reciben un efecto de debilidad por 5 segundos#Los proyectiles pueden dañar a los enemigos"},
}
local TrinketDescs_SPA = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {"Mineral Evolutivo", "Otorga los siguientes aumentos de estadísticas si no te has transformado:#{{ArrowUp}} {{Speed}} Velocidad +0.2#{{ArrowUp}} {{Tears}} Lágrimas +10% #{{ArrowUp}} {{Damage}} Multiplicador de daño +10% #{{ArrowUp}} {{Range}} Alcance +2#{{ArrowUp}} {{Shotspeed}} Vel. de tiro +0.2"},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {"Lock-On Specs", "{{ArrowUp}} {{Damage}} Multiplicador de daño +100% #{{ArrowUp}} {{Range}} Alcance +3#{{ArrowUp}} {{Shotspeed}} Vel. de tiro +0.3#{{Warning}} Recibir daño puede destruir el trinket. Si no, la posibilidad de que ocurra aumenta en +10%"},
	[EEVEEMOD.TrinketType.ALERT_SPECS] = {"Alert Specs", "Evita que el jugador pierda monedas por los ataques de Ultra Codicia"},
}
local TrinketDescs_Golden_SPA = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		[2] = "Otorga los siguientes aumentos de stats si no tienes una transformación:#{{ArrowUp}} {{Speed}} Velocidad +{{ColorGold}}0.3{{CR}}#{{ArrowUp}} {{Tears}} Lágrimas +{{ColorGold}}15%{{CR}}#{{ArrowUp}} +{{ColorGold}}15%{{CR}} {{Damage}} Multiplicador de daño +{{ColorGold}}15%{{CR}}#{{ArrowUp}} {{Range}} Alcance +{{ColorGold}}4{{CR}}#{{ArrowUp}} {{Shotspeed}} Vel. de tiro +{{ColorGold}}0.4{{CR}}",
		[3] = "Otorga los siguientes aumentos de stats si no tienes una transformación:#{{ArrowUp}} {{Speed}} Velocidad +{{ColorGold}}0.4{{CR}}#{{ArrowUp}} {{Tears}} Lágrimas +{{ColorGold}}40%{{CR}}#{{ArrowUp}} +{{ColorGold}}40%{{CR}} {{Damage}} Multiplicador de daño +{{ColorGold}}15%{{CR}}#{{ArrowUp}} {{Range}} Alcance +{{ColorGold}}6{{CR}}#{{ArrowUp}} {{Shotspeed}} Vel. de tiro +{{ColorGold}}0.4{{CR}}",
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		[2] = "{{ArrowUp}} {{Damage}} Multiplicador de daño +{{ColorGold}}200%{{CR}}#{{ArrowUp}} {{Range}} Alcance +{{ColorGold}}6{{CR}}#{{ArrowUp}} {{Shotspeed}} Vel. de tiro +{{ColorGold}}0.6{{CR}}#{{Warning}} Redibir daño puede destruir la baratija. Si no, esta posibilidad aumentará en un +{{ColorGold}}20%{{ColorWhite}}",
		[3] = "{{ArrowUp}} {{Damage}} Multiplicador de daño +{{ColorGold}}300%{{CR}}#{{ArrowUp}} {{Range}} Alcance +{{ColorGold}}9{{CR}}#{{ArrowUp}} {{Shotspeed}} Vel. de tiro +{{ColorGold}}0.9{{CR}}#{{Warning}} Redibir daño puede destruir la baratija. Si no, esta posibilidad aumentará en un +{{ColorGold}}30%{{ColorWhite}}",
	},
}
local CardDescs_SPA = {
	[EEVEEMOD.PokeballType.POKEBALL] = {"Poké Ball - {{Throwable}}", "Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card"..EEVEEMOD.PokeballType.POKEBALL.."}} Posibilidad de captura x1, efecto reducido en los PV"},
	[EEVEEMOD.PokeballType.GREATBALL] = { "Great Ball - {{Throwable}}", "Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card"..EEVEEMOD.PokeballType.POKEBALL.."}} Posibilidad de captura x2, efecto moderado en los PV" },
	[EEVEEMOD.PokeballType.ULTRABALL] = { "Ultra Ball - {{Throwable}}", "Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card"..EEVEEMOD.PokeballType.POKEBALL.."}} Posibilidad de captura x3, efecto amplio en los PV" },
}
local BirthrightDescs_SPA = {
	[EEVEEMOD.PlayerType.EEVEE] = { "Eevee", "{{Collectible" .. EEVEEMOD.Birthright.TAIL_WHIP .. "}} Da a Eevee la habilidad Tail Whip#Gira la cola de Eevee, haciendo retroceder enemigos y rechazando disparos" },
}
local CollectiblesDescs_Modified_SPA = {
	[CollectibleType.COLLECTIBLE_ALMOND_MILK] = "Las estrellas orbitarán constantemente sobre Eevee y dispararán estrellas adicionales basadas en la cadencia de fuego additional#Soltar hará que Eevee deje de disparar",
	[CollectibleType.COLLECTIBLE_ANGELIC_PRISM] = "Las estrellas orbitan más cerca de Eevee",
	[CollectibleType.COLLECTIBLE_BRIMSTONE] = "Las estrellas son reemplazadas con orbes sangrientos, disparan láseres al soltarlas",
	[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = "El daño de las estrellas escala de acuerdo en qué tanto se haya cargado Rapidez, de 50% a 200% de daño",
	[CollectibleType.COLLECTIBLE_CURSED_EYE] = "{{ColorRed}} Sin efecto",
	[CollectibleType.COLLECTIBLE_DR_FETUS] = "Las estrellas son reemplazadas con bombas que no explotarán hasta que sean disparadas",
	[CollectibleType.COLLECTIBLE_EPIC_FETUS] = "{{Warning}} Sobreescribe a Rapidez",
	[CollectibleType.COLLECTIBLE_EYE_SORE] = "Se lanzarán disparos extra de las estrellas al ser disparadas",
	[CollectibleType.COLLECTIBLE_FIRE_MIND] = "Las estrellas orbitan fuera del radio de explosión que dañe a Eevee",
	[CollectibleType.COLLECTIBLE_INCUBUS] = "{{Warning}} No copia ninguno de los efectos especiales de Rapidez",
	[CollectibleType.COLLECTIBLE_IPECAC] = "Las estrellas no serán arqueadas#Las estrellas orbitan fuera del radio de explosión que dañe a Eevee",
	[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = "Se lanzarán disparos extra de las estrellas al ser disparadas",
	[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "Las estrellas orbitan más cerca de Eevee",
	[CollectibleType.COLLECTIBLE_MOMS_EYE] = "Se lanzarán disparos extra de las estrellas al ser disparadas",
	[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "Las estrellas serán reemplazadas con cuchillos, tendrán un tiempo de vida limitado en base al alcance una vez disparadas",
	[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] = "Otras 6 estrellas orbitarán de forma adicional sobre cada estrella en distancias aleatorias",
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = "{{ColorRed}} Sin efecto",
	[CollectibleType.COLLECTIBLE_SOY_MILK] = "Las estrellas orbitarán constantemente sobre Eevee y dispararán estrellas adicionales basadas en la cadencia de fuego additional#Soltar hará que Eevee deje de disparar",
	[CollectibleType.COLLECTIBLE_SPRINKLER] = "{{Warning}} No copia ninguno de los efectos especiales de Rapidez",
	[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "Las estrellas de Rapidez se generarán durante el ataque giratorio, disparándose en cuanto termine el ataque#{{ArrowDown}} Ya no puedes disparar",
	[CollectibleType.COLLECTIBLE_SUMPTORIUM] = "{{Warning}} Los coágulos no copian ninguno de los efectos especiales de Rapidez ",
	[CollectibleType.COLLECTIBLE_TECH_X] = "Las estrellas se reemplazan con orbes de Tecnología, disparan anillos láser al ser soltados",
	[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "Las estrellas se reemplazan con orbes de Tecnología, disparan láseres al ser soltados",
	[CollectibleType.COLLECTIBLE_TECHNOLOGY_2] = "Las estrellas disparan un rayo láser constante antes de ser disparadas",
	[CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE] = "La gran lágrima es reemplazada por 5 estrellas de Rapidez orbitantes",
	[CollectibleType.COLLECTIBLE_TINY_PLANET] = "Las estrellas orbitarán constantemente sobre Eevee y dispararán estrellas adicionales basadas en la cadencia de fuego additional#Soltar hará que Eevee deje de disparar",
	[CollectibleType.COLLECTIBLE_TWISTED_PAIR] = "{{Warning}} No copia ninguno de los efectos especiales de Rapidez",
}
local TrinketDescs_Modified_SPA = {
	[EEVEEMOD.TrinketType.EVIOLITE] = "Aumenta todas las estadísticas al 100%, el efecto se pierde al evolucionar#{{Warning}} Como las evoluciones no se han implementado, esta bonificación no está disponible"
}

local Descriptions = {
	["en_us"] = {
		Collectibles = CollectibleDescs_EN,
		Trinkets = TrinketDescs_EN,
		Trinkets_Golden = TrinketDescs_Golden_EN,
		Cards = CardDescs_EN,
		Birthrights = BirthrightDescs_EN,
		Collectibles_Modified = CollectiblesDescs_Modified_EN,
		Trinkets_Modified = TrinketDescs_Modified_EN
	},
	["spa"] = {
		Collectibles = CollectibleDescs_SPA,
		Trinkets = TrinketDescs_SPA,
		Trinkets_Golden = TrinketDescs_Golden_SPA,
		Cards = CardDescs_SPA,
		Birthrights = BirthrightDescs_SPA,
		Collectibles_Modified = CollectiblesDescs_Modified_SPA,
		Trinkets_Modified = TrinketDescs_Modified_SPA
	}
}

local function EIDDesc()
	return Descriptions[EID:getLanguage()] or Descriptions["en_us"]
end

for itemID, desc in pairs(EIDDesc().Collectibles) do
	EID:addCollectible(itemID, desc[2], desc[1], "en_us")
	if itemID == EEVEEMOD.CollectibleType.COOKIE_JAR[6] then
		for i = 1, 5 do
			EID:addCollectible(EEVEEMOD.CollectibleType.COOKIE_JAR[i], desc[2], desc[1], "en_us")
		end
	end
end
for trinketID, desc in pairs(EIDDesc().Trinkets) do
	EID:addTrinket(trinketID, desc[2], desc[1], "en_us")
end
for cardID, desc in pairs(EIDDesc().Cards) do
	EID:addCard(cardID, desc[2], desc[1], "en_us")
end
for playerType, desc in pairs(EIDDesc().Birthrights) do
	EID:addBirthright(playerType, desc[2], desc[1], "en_us")
end

--Unique descriptions for Eevee
local function AddEeveeText(descObj)
	local itemDesc = nil
	if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
		itemDesc = EIDDesc().Collectibles_Modified[descObj.ObjSubType]
	elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
		itemDesc = EIDDesc().Trinkets_Modified[descObj.ObjSubType]
	end
	if itemDesc ~= nil then
		local iconStr = "#{{" .. Player.Eevee .. "}} {{ColorGray}}Eevee#"
		EID:appendToDescription(descObj, iconStr .. itemDesc)
	end
	return descObj
end

local function IfEeveeActive(descObj)
	local players = VeeHelper.GetAllPlayers()
	local eeveeIsHere = false

	for i = 1, #players do
		local player = players[i]
		local playerType = player:GetPlayerType()

		if playerType == EEVEEMOD.PlayerType.EEVEE then
			if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE
				and EIDDesc().Collectibles_Modified[descObj.ObjSubType] then
				eeveeIsHere = true
			elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET
				and EIDDesc().Trinkets_Modified[descObj.ObjSubType] then
				eeveeIsHere = true
			end
		end
	end
	return eeveeIsHere
end

EID:addDescriptionModifier("Eevee Description", IfEeveeActive, AddEeveeText)

local hasBox = false
local isGolden = false

local function GoldenTrinketCallback(descObj)
	local trinketID = EID:getAdjustedSubtype(descObj.ObjType, descObj.ObjVariant, descObj.ObjSubType)
	local multiplier = 2
	if isGolden and hasBox then
		multiplier = 3
	end
	descObj.Description = EIDDesc().Trinkets_Golden[trinketID][multiplier]
	return descObj
end

local function IfMultipliedTrinket(descObj)
	local isStatBoosted = false
	local trinketID = EID:getAdjustedSubtype(descObj.ObjType, descObj.ObjVariant, descObj.ObjSubType)
	isGolden = (descObj.ObjSubType > TrinketType.TRINKET_GOLDEN_FLAG)
	hasBox = EID.collectiblesOwned[439]
	if EIDDesc().Trinkets_Golden[trinketID] and (isGolden or hasBox) then
		isStatBoosted = true
	end
	return isStatBoosted
end

EID:addDescriptionModifier("Eevee Multiplied Trinkets", IfMultipliedTrinket, GoldenTrinketCallback)

return eid
