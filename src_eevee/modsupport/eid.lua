local eid = {}

if not EID then return eid end

local eeveeIcons = Sprite()
eeveeIcons:Load("gfx/ui/eid_eevee_icons.anm2", true)
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

EID:setModIndicatorName(EEVEEMOD.Name.." ")
EID:setModIndicatorIcon(Player.Eevee)

--English descriptions
local CollectibleDescs_EN = {
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = { "Sneak Scarf", "↑ {{Speed}} +0.3 Speed up#All enemies in the room are permanently confused#Coming within close proximity of a confused enemy this way clears it of its confusion status. Getting out of range will not re-confuse it#Does not affect bosses" },
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = { "Shiny Charm", "↑ {{Luck}} +2 Luck up#Highly increases the chance for normal enemies to become shiny#Shiny enemies have increased health, will run away from the player, and disappear after some time#Shiny enemies drop a Golden Trinket on death" },
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = { "Black Glasses", "↑ {{Damage}} +0.5 Flat Damage up#{{Damage}} Gain a small Damage multiplier for each Devil Deal taken based on the cost of the item without modifiers#Works retroactively with deals taken before picking up the item" },
	[EEVEEMOD.CollectibleType.COOKIE_JAR] = { "Cookie Jar", "{{Heart}} Upon use, heals 1 full Red Heart, up to 6 times#{{Speed}} -0.2 Speed down on every use, but goes away slowly over time#{{Heart}} On the final use, is consumed and grants +2 Red Heart containers" },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = { "Strange Egg", "Charges +1 bar per floor#Can be used when not fully charged, with different effects based on its charge:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: Heals 3 {{Heart}} Red Hearts#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: Spawns {{Collectible" .. CollectibleType.COLLECTIBLE_BREAKFAST .. "}} Breakfast and 2 {{Heart}} Red Hearts#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: Spawns {{Collectible" .. EEVEEMOD.CollectibleType.LIL_EEVEE .. "}} Lil Eevee and 2 {{Heart}} Red Hearts" },
	[EEVEEMOD.CollectibleType.LIL_EEVEE] = { "Lil Eevee", "Normal tear familiar#The familiar's form changes randomly when Isaac uses a rune, having different tears for each form#Possible tears are similar to that of {{" .. Player.Eevee .. "}} Eevee and their Eeveelutions" },
	[EEVEEMOD.CollectibleType.BAD_EGG] = { "Bad EGG", "Blocks projectiles, up to 32 before breaking#{{Warning}} Upon breaking, replaces a random owned famliiar with a duplicate {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG_DUPE .. "}} Bad EGG, and restores Bad EGG#Duplicates block less projectiles and disappear when breaking, respawning when Bad EGG breaks#If no other familiars are owned when broken, outside of duped Bad EGGs, removes Bad EGG and Spawns {{Collectible" .. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} Strange Egg" },
	[EEVEEMOD.CollectibleType.BAD_EGG_DUPE] = { "Duped Bad EGG", "Blocks projectiles, up to 8 before disappearing#{{Warning}} Can only be respawned if {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG .. "}} Bad EGG is owned and that familiar 'breaks'" },
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = { "Wonderous Launcher", "Uses your pickups as ammunition and launches them:#{{Coin}} Amount consumed and damage dealt depends on coin count#{{Key}} Behaves like {{Collectible" .. CollectibleType.COLLECTIBLE_SHARP_KEY .. "}} Sharp Key#{{Bomb}} Fires a bomb with all the player's bomb effects#{{PoopPickup}} If throwable, consumes your next spell in queue. Spawns its respective poop on contact." },
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = { "Bag of Poké Balls", "Every 12 rooms, spawns a random type of Poké Ball#50% {{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} Poké Ball#30% {{Card" .. EEVEEMOD.PokeballType.GREATBALL .. "}} Great Ball#20% {{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} Ultra Ball" },
	[EEVEEMOD.CollectibleType.MASTER_BALL] = { "Master Ball - {{Throwable}}", "Can be thrown at an enemy or boss to capture them, turning them into a friendly companion#{{Warning}} Successful capture results in this item being destroyed#Walking over the ball or leaving the room instantly recharges the item#Has an extreme effect on the captured enemy's health" },
	[EEVEEMOD.CollectibleType.POKE_STOP] = { "Poke Stop", "Spawns a Poke Stop on first pickup. Every floor a Poke Stop appears in a random special room#Interacting with it has it drop a random assortment of {{Coin}} Coins, {{Key}} Keys, and {{Bomb}} Bombs, and a special pickup based on the type of room it's in" },
	[EEVEEMOD.Birthright.TAIL_WHIP] = { "Tail Whip", "Extends a tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a {{Weakness}} Weakness effect for 5 seconds#Projectiles hit can damage enemies" },
}
local TrinketDescs_EN = {
	[EEVEEMOD.TrinketType.EVIOLITE] = { "Eviolite", "Grants the following stats if you don't have a transformation:#↑ {{Speed}} +0.2 Speed up#↑ +10% {{Tears}} Tears Up#↑ {{Damage}} +10% Damage Multiplier#↑ {{Range}} +2 Range up#↑ {{Shotspeed}} +0.2 Shot Speed up" },
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = { "Lock-On Specs", "↑ {{Damage}} +100% Damage Multiplier#↑ {{Range}} +3 Range up#↑ {{Shotspeed}} +0.3 Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +10%" },
	[EEVEEMOD.TrinketType.ALERT_SPECS] = { "Alert Specs", "Prevents Isaac from dropping coins caused by taking damage from Greed enemies and projectiles" },
}
local TrinketDescs_Golden_EN = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		[2] = "Grants the following stats if you don't have a transformation:#↑ {{Speed}} +{{ColorGold}}0.3{{ColorWhite}} Speed up#↑ {{Tears}} +{{ColorGold}}15%{{ColorWhite}} Tears Up#↑ {{Damage}} +{{ColorGold}}15%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}4{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.4{{ColorWhite}} Shot Speed up",
		[3] = "Grants the following stats if you don't have a transformation:#↑ {{Speed}} +{{ColorGold}}0.4{{ColorWhite}} Speed up#↑ {{Tears}} +{{ColorGold}}40%{{ColorWhite}} Tears Up#↑ {{Damage}} +{{ColorGold}}40%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}6{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.4{{ColorWhite}} Shot Speed up",
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		[2] = "↑ {{Damage}} +{{ColorGold}}200%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}6{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.6{{ColorWhite}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +{{ColorGold}}20%{{ColorWhite}}",
		[3] = "↑ {{Damage}} +{{ColorGold}}300%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}9{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.9{{ColorWhite}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +{{ColorGold}}30%{{ColorWhite}}",
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
	[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "Swift stars spawn around you during the spin attack, shooting forward when finishing the spin#↓ Can no longer fire projectiles",
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
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = { "Bufanda de escape", "↑ {{Speed}} Velocidad +0.3#{{Confusion}} Todos los enemigos en la sala quedarán confundidos#Acercarse a un anemigo revertirá su estado de confusión. Alejarse no lo volverá a confundir#No afecta a los jefes" },
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = { "Amuleto Iris", "↑ {{Luck}} Suerte +2#Aumenta demasiado la posibilidad de que los enemigos sean {{ColorRainbow}}Variocolor{{CR}}#Estos enemigos tienen más salud, correrán lejos del jugador y desaparecerán tras un tiempo#Estos pueden soltar una baratija dorada al morir" },
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = { "Lentes oscuros", "↑ Daño +0.5{{Damage}}#{{DevilRoom}} Recibes un pequeño multiplicador de daño por cada trato con el Diablo que hayas hecho#Trabaja de forma retroactiva con los tratos hechos antes de tomar el objeto" },
	[EEVEEMOD.CollectibleType.COOKIE_JAR] = { "Tarro de galletas", "{{Heart}} Cura un corazón rojo en cada uso hasta 6 veces#{{Speed}} Velocidad -0.2 por cada uso, pero se reestablece tras un tiempo#{{Heart}} Tras su último uso, es consumido y otorga 2 contenedores de corazón" },
	[EEVEEMOD.CollectibleType.BAD_EGG] = { "Huevo malo", "Bloquea hasta 32 proyectiles antes de romperse#{{Warning}} al momento de romperse, reemplaza uno de tus familiares con {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG_DUPE .. "}} un Huevo Malo#Los duplicados bloquean menos proyectiles y desaparecen al romperse, reapareciendo cuando el huevo malo se rompe#Si no hay otro familiar al romperse, a parte de los huevos malos duplicados, remueve un Huevo Malo y lo reemplaza con un {{Collectible" .. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} Huevo extraño" },
	[EEVEEMOD.CollectibleType.BAD_EGG_DUPE] = { "Huevo malo duplicado", "Bloquea hasta 8 proyectiles antes de desaparecer#{{Warning}} Sólo se puede regenerar si es que se tiene al {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG .. "}} Huevo Malo y ese familiar se 'rompe'" },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = { "Strange Egg", "Recibe +1 carga por piso#Puede ser usado sin estar completamente cargado, con distintos efectos en base a sus cargas:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: {{Heart}} Cura 3 corazones rojos#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: Genera {{Collectible" .. CollectibleType.COLLECTIBLE_BREAKFAST .. "}} Desayuno y {{Heart}} 2 corazones rojos#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: Spawns {{Collectible" .. EEVEEMOD.CollectibleType.LIL_EEVEE .. "}} Lil Eevee and 2 {{Heart}} Red Hearts" },
	[EEVEEMOD.CollectibleType.LIL_EEVEE] = { "Pequeño Eevee", "Familiar de disparo regular#{{Rune}} El aspecto del familiar cambiará cada vez que se use una runa, teniendo distintos efectos de lágrimas#{{" .. Player.Eevee .. "}} Las lágrimas pueden ser similares a las de Eevee y sus Eeveeluciones" },
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = { "Lanzador", "Utiliza tus recolectables como munición:#{{Coin}} La cantidad consumida y daño dependerá de tu cantidad de monedas#{{Key}} Es igual que la {{Collectible" .. CollectibleType.COLLECTIBLE_SHARP_KEY .. "}} Llave afilada(¿Así se llama?)#{{Bomb}} Dispara una bomba con todos los efectos de bomba que tenga el jugador#{{PoopPickup}} Si se puede lanzar, consumirá el siguiente efecto en la lista. Genera su respectiva popó al contacto" },
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = { "Bolsa de Pokébolas", "Cada 12 salas, genera una Pokébola aleatoria#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} 50% de posibilidad de una Pokébola #{{Card" .. EEVEEMOD.PokeballType.GREATBALL .. "}} 30% de posibilidad de una Superbola#{{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} 20% de posibilidad de una Ultrabola" },
	[EEVEEMOD.CollectibleType.MASTER_BALL] = { "Master Ball - {{Throwable}}", "Puede ser lanzado a un enemigo o un jefe para capturarlo, Convirtíendolo en un compañero#{{Warning}} Una captura exitosa destruirá el objeto#Caminar sobre la bola o dejar la sala recargará el objeto#Tiene un efecto extremo en la salud del capturado" },
	[EEVEEMOD.CollectibleType.POKE_STOP] = { "Poképarada", "Se generará una Poképarada al momento de tomarlo. En cada piso aparecerá una Poképarada en una sala especial aleatoria#Interactuar con esta soltará una cierta cantidad de {{Coin}} Monedas, {{Key}} Llaves, y {{Bomb}} Bombas, junto a un recolectable especial basado en la sala" },
	[EEVEEMOD.Birthright.TAIL_WHIP] = { "Látigo", "Extiende una cola que hace un ataque giratorio, aplicando retroceso a los enemigos y reflectando disparos#{{Weakness}} Los enemigos golpeados reciben un efecto de debilidad por 5 segundos#Los proyectiles pueden dañar a los enemigos" },
}
local TrinketDescs_SPA = {
	[EEVEEMOD.TrinketType.EVIOLITE] = { "Mineral Evolutivo", "Otorga los siguientes aumentos de estadísticas si no te has transformado:#↑ {{Speed}} Velocidad +0.2#↑ {{Tears}} Lágrimas +10% #↑ {{Damage}} Multiplicador de daño +10% #↑ {{Range}} Alcance +2#↑ {{Shotspeed}} Vel. de lágrimas +0.2" },
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = { "Lock-On Specs", "↑ {{Damage}} Multiplicador de daño +100% #↑ {{Range}} Alcance +3#↑ {{Shotspeed}} Vel. de lágrimas +0.3#{{Warning}} Recibir daño puede destruir el trinket. Si no, la posibilidad de que ocurra aumenta en +10%" },
	[EEVEEMOD.TrinketType.ALERT_SPECS] = { "Alert Specs", "Evita que el jugador pierda monedas por los ataques de Ultra Codicia" },
}
local TrinketDescs_Golden_SPA = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		[2] = "Otorga los siguientes aumentos de stats si no tienes una transformación:#↑ {{Speed}} Velocidad +{{ColorGold}}0.3{{CR}}#↑ {{Tears}} Lágrimas +{{ColorGold}}15%{{CR}}#↑ +{{ColorGold}}15%{{CR}} {{Damage}} Multiplicador de daño +{{ColorGold}}15%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}4{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.4{{CR}}",
		[3] = "Otorga los siguientes aumentos de stats si no tienes una transformación:#↑ {{Speed}} Velocidad +{{ColorGold}}0.4{{CR}}#↑ {{Tears}} Lágrimas +{{ColorGold}}40%{{CR}}#↑ +{{ColorGold}}40%{{CR}} {{Damage}} Multiplicador de daño +{{ColorGold}}15%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.4{{CR}}",
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		[2] = "↑ {{Damage}} Multiplicador de daño +{{ColorGold}}200%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.6{{CR}}#{{Warning}} Redibir daño puede destruir la baratija. Si no, esta posibilidad aumentará en un +{{ColorGold}}20%{{ColorWhite}}",
		[3] = "↑ {{Damage}} Multiplicador de daño +{{ColorGold}}300%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}9{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.9{{CR}}#{{Warning}} Redibir daño puede destruir la baratija. Si no, esta posibilidad aumentará en un +{{ColorGold}}30%{{ColorWhite}}",
	},
}
local CardDescs_SPA = {
	[EEVEEMOD.PokeballType.POKEBALL] = { "Poké Ball - {{Throwable}}", "Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} Posibilidad de captura x1, efecto reducido en los PV" },
	[EEVEEMOD.PokeballType.GREATBALL] = { "Great Ball - {{Throwable}}", "Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} Posibilidad de captura x2, efecto moderado en los PV" },
	[EEVEEMOD.PokeballType.ULTRABALL] = { "Ultra Ball - {{Throwable}}", "Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} Posibilidad de captura x3, efecto amplio en los PV" },
}
local BirthrightDescs_SPA = {
	[EEVEEMOD.PlayerType.EEVEE] = { "Eevee", "{{Collectible" .. EEVEEMOD.Birthright.TAIL_WHIP .. "}} Da a Eevee la habilidad Látigo#Gira la cola de Eevee, haciendo retroceder enemigos y rechazando disparos" },
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
	[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "Las estrellas de Rapidez se generarán durante el ataque giratorio, disparándose en cuanto termine el ataque#↓ Ya no puedes disparar",
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

-- Korean Descriptions
local CollectibleDescs_KR = {
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = { "살짝스카프", "↑ {{Speed}}이동속도 +0.3#{{Confusion}} 방 안의 모든 적들이 혼란에 빠집니다.#캐릭터가 적에게 다가갈 경우 그 적의 혼란 상태가 풀립니다.#!!! (보스에게는 무효과)" },
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = { "빛나는부적", "↑ {{Luck}}운 +2#!!! 적들이 '색이 다른 챔피언'이 될 확률 증가#'색이 다른 챔피언'은 체력이 5배이며 캐릭터에게서 멀어지며 10초 후 사라집니다.#'색이 다른 챔피언' 처치 시 100%의 확률로 황금 장신구를 드랍합니다." },
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = { "검은안경", "↑ {{Damage}}최종 공격력 +0.5#{{Damage}} 현재 게임에서 {{ColorOrange}}악마 거래로 획득한 아이템의 원래 가격{{CR}}만큼 공격력 배율이 +10%p만큼 증가합니다." },
	[EEVEEMOD.CollectibleType.COOKIE_JAR[6]] = { "쿠키가 담긴 병", "{{Heart}} 사용 시 체력 1칸을 회복합니다.#↓ {{Speed}}사용 시 이동속도 -0.2#감소한 이동속도는 시간이 지날수록 서서히 돌아옵니다.#↑ 6회 사용 시 최대 체력이 2칸 증가하며 병이 사라집니다." },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = { "이상한 알", "!!! 스테이지 진입 시에만 1칸 충전#사용 시 현재 충전량에 따라 다른 효과를 발동합니다:#{{Battery}} {{ColorYellow}}1{{CR}}: {{Heart}}체력 3칸 회복#{{Battery}} {{ColorYellow}}2{{CR}}: {{Collectible" .. CollectibleType.COLLECTIBLE_BREAKFAST .. "}}Breakfast + {{Heart}}빨간하트 2개 드랍#{{Battery}} {{ColorYellow}}3{{CR}}: {{Collectible" .. EEVEEMOD.CollectibleType.LIL_EEVEE .. "}}Lil Eevee + {{Heart}}빨간하트 2개 드랍" },
	[EEVEEMOD.CollectibleType.LIL_EEVEE] = { "리틀 이브이", "공격하는 방향으로 공격력 3.5의 눈물을 발사합니다.#룬을 사용할 때마다 형태가 바뀌며 각 형태마다 다른 눈물을 발사합니다.#{{" .. Player.Eevee .. "}} 눈물효과는 이브이 캐릭터 및 진화형태 중에서 정해집니다." },
	[EEVEEMOD.CollectibleType.BAD_EGG] = { "오류투성이 알", "적의 탄환을 막아주며 최대 32회 막아줄 시 알이 깨집니다.#!!! 알이 깨질 시 소지 중인 패밀리어 중 하나를 감염시켜 복제된 {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG_DUPE .. "}}Bad EGG 패밀리어로 바꾼 후 Bad EGG를 다시 소환합니다.#복제된 Bad EGG는 최대 8회까지만 막아주며 원본 Bad EGG 파괴 시 다시 소환됩니다.#알이 깨질 시 감염시킬 패밀리어 및 복제된 Bad EGG가 하나도 없을 경우 {{Collectible" .. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}}Strange Egg를 소환하며 사라집니다." },
	[EEVEEMOD.CollectibleType.BAD_EGG_DUPE] = { "오류투성이 알(복제)", "적의 탄환을 막아주며 최대 8회 막아줄 시 알이 깨집니다.#!!! 원본 {{Collectible" .. EEVEEMOD.CollectibleType.BAD_EGG .. "}}Bad EGG를 소지한 상태에서 해당 알이 깨지면 다시 소환됩니다." },
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = { "미라클슈터", "사용 시 픽업을 소모하여 발사합니다.#{{ButtonRT}}버튼을 사용하여 소모할 픽업을 선택할 수 있으며 소모한 픽업에 따라 투사체의 효과가 달라집니다:#{{Coin}} 소모한 동전의 개수에 비례하여 명중한 적에게 피해를 줍니다.#{{Key}} {{Collectible" .. CollectibleType.COLLECTIBLE_SHARP_KEY .. "}}Sharp Key 아이템과 동일#{{Bomb}} 폭탄을 투척합니다.#{{PoopPickup}} 적 명중 시 현재 선택된 종류의 똥을 소환합니다." },
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = { "몬스터볼 가방", "!!! 방 12개 클리어 시 랜덤 몬스터볼을 드랍합니다:#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} 몬스터볼: 50%#{{Card" .. EEVEEMOD.PokeballType.GREATBALL .. "}} 슈퍼볼: 30% #{{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} 하이퍼볼: 20%" },
	[EEVEEMOD.CollectibleType.MASTER_BALL] = { "마스터볼", "!!! 일회용#{{Throwable}} 사용 시 공격하는 방향으로 몬스터볼을 던집니다.#몬스터볼에 맞은 적 및 보스는 100%의 확률로 포획되며 잠시 후 아군 상태로 소환되며 체력을 대폭 회복합니다.#방 이동시 혹은 포획 시도에 실패한 마스터볼 획득 시 즉시 재충전됩니다." },
	[EEVEEMOD.CollectibleType.POKE_STOP] = { "포켓스톱", "획득 시 포켓스톱 하나를 배치합니다.#매 스테이지마다 랜덤 특수방에서 포켓스톱이 배치됩니다.#배치된 포켓스톱 위치로 이동 시 {{Coin}}/{{Key}}/{{Bomb}} 픽업과 소환된 특수방에 따라 다른 픽업 아이템을 드랍합니다." },
	[EEVEEMOD.Birthright.TAIL_WHIP] = { "꼬리흔들기", "사용 시 꼬리를 한 바퀴 흔들며 근처의 적을 밀쳐내며 탄환을 반사합니다.#{{Weakness}} 밀친 적을 5초동안 약화시킵니다." },
}
local TrinketDescs_KR = {
	[EEVEEMOD.TrinketType.EVIOLITE] = { "진화의휘석", "!!! 완성된 변신 세트가 없을 경우:#↑ {{Speed}}이동속도 +0.2#↑ {{Tears}}연사 배율 x1.1#↑ {{Damage}}공격력 배율 x1.1#↑ {{Range}}사거리 +2#↑ {{Shotspeed}}탄속 +0.2" },
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = { "록온안경", "↑ {{Damage}}공격력 배율 x2.0#↑ {{Range}}사거리 +3#↑ {{Shotspeed}}탄속 +0.3#!!! 패널티 피격 시 일정 확률로 사라지며 사라지지 않았을 경우 사라질 확률 +10%" },
	[EEVEEMOD.TrinketType.ALERT_SPECS] = { "경계안경", "Greed류 공격 피격 시에도 동전을 잃지 않습니다." },
}
local TrinketDescs_Golden_KR = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		[2] = "!!! 완성된 변신 세트가 없을 경우:#↑ {{Speed}}이동속도 +{{ColorGold}}0.3{{CR}}#↑ {{Tears}}연사 배율 x{{ColorGold}}1.15{{CR}}#↑ {{Damage}}공격력 배율 x{{ColorGold}}1.15{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}4{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.4{{CR}}",
		[3] = "!!! 완성된 변신 세트가 없을 경우:#↑ {{Speed}}이동속도 +{{ColorGold}}0.4{{CR}}#↑ {{Tears}}연사 배율 x{{ColorGold}}1.4{{CR}}#↑ {{Damage}}공격력 배율 x{{ColorGold}}1.4{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.4{{CR}}",
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		[2] = "↑ {{Damage}}공격력 배율 x{{ColorGold}}3.0{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.6{{CR}}#!!! 패널티 피격 시 일정 확률로 사라지며 사라지지 않았을 경우 사라질 확률 +{{ColorGold}}20%{{CR}}",
		[3] = "↑ {{Damage}}공격력 배율 x{{ColorGold}}4.0{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}9{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.9{{CR}}#!!! 패널티 피격 시 일정 확률로 사라지며 사라지지 않았을 경우 사라질 확률 +{{ColorGold}}30%{{CR}}",
	},
}
local CardDescs_KR = {
	[EEVEEMOD.PokeballType.POKEBALL] = { "몬스터볼", "{{Throwable}} 공격하는 방향으로 던질 수 있으며 일정 확률로 포획한 적 및 보스를 아군으로 만들 수 있습니다.#일정 확률로 재사용 가능#보스 포획 시도 시 체력 및 상태이상에 따라 포획에 실패할 수 있으며 재사용할 수 없습니다.#{{Card" .. EEVEEMOD.PokeballType.POKEBALL .. "}} 포획률 x1, 포획한 몬스터의 체력 소량 회복" },
	[EEVEEMOD.PokeballType.GREATBALL] = { "슈퍼볼", "{{Throwable}} 공격하는 방향으로 던질 수 있으며 일정 확률로 포획한 적 및 보스를 아군으로 만들 수 있습니다.#일정 확률로 재사용 가능#보스 포획 시도 시 체력 및 상태이상에 따라 포획에 실패할 수 있으며 재사용할 수 없습니다.#{{Card" .. EEVEEMOD.PokeballType.GREATBALL .. "}} 포획률 x2, 포획한 몬스터의 체력 중량 회복" },
	[EEVEEMOD.PokeballType.ULTRABALL] = { "하이퍼볼", "{{Throwable}} 공격하는 방향으로 던질 수 있으며 일정 확률로 포획한 적 및 보스를 아군으로 만들 수 있습니다.#일정 확률로 재사용 가능#보스 포획 시도 시 체력 및 상태이상에 따라 포획에 실패할 수 있으며 재사용할 수 없습니다.#{{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} 포획률 x3, 포획한 몬스터의 체력 대량 회복" },
}
local BirthrightDescs_KR = {
	[EEVEEMOD.PlayerType.EEVEE] = { "이브이", "{{Collectible" .. EEVEEMOD.Birthright.TAIL_WHIP .. "}} 이브이가 꼬리흔들기를 배웁니다.#사용 시 꼬리를 한 바퀴 흔들며 근처의 적을 밀쳐내며 탄환을 반사합니다." },
}
local CollectiblesDescs_Modified_KR = {
	[CollectibleType.COLLECTIBLE_ALMOND_MILK] = "공격키를 뗄 때까지 별을 계속 발사합니다.",
	[CollectibleType.COLLECTIBLE_ANGELIC_PRISM] = "별이 더 가까운 위치에서 회전합니다.",
	[CollectibleType.COLLECTIBLE_BRIMSTONE] = "별이 혈사 고리로 바뀌며 공격 키를 떼면 혈사를 한번에 발사합니다.",
	[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = "별이 모여 있는 정도에 따라 공격력 배율이 x0.5 ~ x2로 증감합니다.",
	[CollectibleType.COLLECTIBLE_CURSED_EYE] = "!!! {{ColorRed}}무효과",
	[CollectibleType.COLLECTIBLE_DR_FETUS] = "별이 폭탄으로 바뀌며 발사되기 전까지 폭탄이 설치되지 않습니다.",
	[CollectibleType.COLLECTIBLE_EPIC_FETUS] = "!!! Swift의 효과가 무효화됨: 이브이가 더 이상 별을 발사할 수 없음",
	[CollectibleType.COLLECTIBLE_EYE_SORE] = "별이 발사될 때 각 별마다 랜덤 방향으로 다른 별을 추가로 발사합니다.",
	[CollectibleType.COLLECTIBLE_FIRE_MIND] = "별이 더 먼 위치에서 회전합니다.",
	[CollectibleType.COLLECTIBLE_INCUBUS] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
	[CollectibleType.COLLECTIBLE_IPECAC] = "별이 곡선형으로 발사되지 않음#별이 더 먼 위치에서 회전합니다.",
	[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = "별이 발사될 때 각 별마다 다른 별을 추가로 발사합니다.",
	[CollectibleType.COLLECTIBLE_LOST_CONTACT] = "별이 더 가까운 위치에서 회전합니다.",
	[CollectibleType.COLLECTIBLE_MOMS_EYE] = "별이 발사될 때 각 별마다 다른 별을 추가로 발사합니다.",
	[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = "별 대신 칼을 발사하며 사거리에 따라 투사체가 더 멀리 날아갑니다.",
	[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] = "각 별마다 주위를 도는 6개의 작은 별이 추가로 발사됩니다.",
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = "!!! {{ColorRed}}무효과",
	[CollectibleType.COLLECTIBLE_SOY_MILK] = "공격키를 뗄 때까지 별을 계속 발사합니다.",
	[CollectibleType.COLLECTIBLE_SPRINKLER] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
	[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = "완충 시에만 별을 발사할 수 있으며 별은 최대 충전 상태로 발사됩니다.",
	[CollectibleType.COLLECTIBLE_SUMPTORIUM] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
	[CollectibleType.COLLECTIBLE_TECH_X] = "별이 레이저 구슬로 바뀌며 공격 키를 떼면 레이저 고리를 한번에 발사합니다.",
	[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "별이 레이저 구슬로 바뀌며 공격 키를 떼면 레이저를 한번에 발사합니다.",
	[CollectibleType.COLLECTIBLE_TECHNOLOGY_2] = "발사되지 않은 별에서 레이저를 발사합니다.",
	[CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE] = "하나의 커다란 눈물이 5개의 작은 별로 바뀝니다.",
	[CollectibleType.COLLECTIBLE_TINY_PLANET] = "공격키를 뗄 때까지 별을 계속 발사합니다.",
	[CollectibleType.COLLECTIBLE_TWISTED_PAIR] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
}
local TrinketDescs_Modified_KR = {
	[EEVEEMOD.TrinketType.EVIOLITE] = "!!! 현재 적용 안됨#↑ 모든 능력치 배울 x2.0# 진화 시 사라집니다."
}


local Descriptions = {
	["en_us"] = {
		Collectibles = CollectibleDescs_EN,
		Trinkets = TrinketDescs_EN,
		Trinkets_Golden = TrinketDescs_Golden_EN,
		Cards = CardDescs_EN,
		Birthrights = BirthrightDescs_EN,
		Collectibles_Modified = CollectiblesDescs_Modified_EN,
		Trinkets_Modified = TrinketDescs_Modified_EN,
		Eevee = "Eevee"
	},
	["spa"] = {
		Collectibles = CollectibleDescs_SPA,
		Trinkets = TrinketDescs_SPA,
		Trinkets_Golden = TrinketDescs_Golden_SPA,
		Cards = CardDescs_SPA,
		Birthrights = BirthrightDescs_SPA,
		Collectibles_Modified = CollectiblesDescs_Modified_SPA,
		Trinkets_Modified = TrinketDescs_Modified_SPA,
		Eevee = "Eevee"
	},
	["ko_kr"] = {
		Collectibles = CollectibleDescs_KR,
		Trinkets = TrinketDescs_KR,
		Trinkets_Golden = TrinketDescs_Golden_KR,
		Cards = CardDescs_KR,
		Birthrights = BirthrightDescs_KR,
		Collectibles_Modified = CollectiblesDescs_Modified_KR,
		Trinkets_Modified = TrinketDescs_Modified_KR,
		Eevee = "이브이"
	}
}

local function EIDDesc()
	return Descriptions[EID:getLanguage()] or Descriptions["en_us"]
end

for language, descs in pairs(Descriptions) do
	for itemID, desc in pairs(descs.Collectibles) do
		EID:addCollectible(itemID, desc[2], desc[1], language)
	end
	for trinketID, desc in pairs(descs.Trinkets) do
		EID:addTrinket(trinketID, desc[2], desc[1], language)
	end
	for cardID, desc in pairs(descs.Cards) do
		EID:addCard(cardID, desc[2], desc[1], language)
	end
	for playerType, desc in pairs(descs.Birthrights) do
		EID:addBirthright(playerType, desc[2], desc[1], language)
	end
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
		local iconStr = "#{{" .. Player.Eevee .. "}} {{ColorGray}}"..EIDDesc().Eevee.."#"
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
