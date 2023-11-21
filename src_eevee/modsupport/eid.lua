local eid = {}
local vee = require("src_eevee.veeHelper")

if not EID then return eid end

local eeveeIcons = Sprite()
eeveeIcons:Load("gfx/ui/eid_eevee_icons.anm2", true)
local Player = {
	Eevee = "Player" .. EEVEEMOD.PlayerType.EEVEE,
	EeveeB = "Player" .. EEVEEMOD.PlayerType.EEVEE_B
}
EID:addIcon(Player.Eevee, "Players", 0, 12, 12, -1, 1, eeveeIcons)
EID:addIcon(Player.EeveeB, "Players", 9, 12, 12, -1, 1, eeveeIcons)

EID:addIcon("Card" .. EEVEEMOD.PokeballType.POKEBALL, "Poke Balls", 0, 9, 9, -1, 0, eeveeIcons)
EID:addIcon("Card" .. EEVEEMOD.PokeballType.GREATBALL, "Poke Balls", 1, 9, 9, -1, 0, eeveeIcons)
EID:addIcon("Card" .. EEVEEMOD.PokeballType.ULTRABALL, "Poke Balls", 2, 9, 9, -1, 0, eeveeIcons)

EID:setModIndicatorName(EEVEEMOD.Name .. " ")
EID:setModIndicatorIcon(Player.Eevee)

local CollectibleDescriptions = {
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = {
		["en_us"] = {
			{ "Sneak Scarf",
				"↑ {{Speed}} +0.3 Speed up#All enemies in the room are permanently confused#Coming within close proximity of a confused enemy this way clears it of its confusion status. Getting out of range will not re-confuse it#Does not affect bosses" },
		},
		["spa"] = {
			{ "Bufanda de escape",
				"↑ {{Speed}} Velocidad +0.3#{{Confusion}} Todos los enemigos en la sala quedarán confundidos#Acercarse a un anemigo revertirá su estado de confusión. Alejarse no lo volverá a confundir#No afecta a los jefes" },
		},
		["ko_kr"] = {
			{ "살짝스카프",
				"↑ {{Speed}}이동속도 +0.3#{{Confusion}} 방 안의 모든 적들이 혼란에 빠집니다.#캐릭터가 적에게 다가갈 경우 그 적의 혼란 상태가 풀립니다.#!!! (보스에게는 무효과)" },
		},
		["zh_cn"] = {
			{ "潜行围巾",
				"↑ {{Speed}} 速度+0.3#{{Confusion}} 房间内所有敌人获得永久混乱效果.#若角色靠敌人太近,则敌人有概率摆脱混乱状态。远离敌人并不会再次使敌人混乱。#!!! boss除外" },
		},
	},
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = {
		["en_us"] = {
			{ "Shiny Charm",
				"↑ {{Luck}} +2 Luck up#Highly increases the chance for normal enemies to become shiny#Shiny enemies have increased health, will run away from the player, and disappear after some time#Shiny enemies drop a Golden Trinket on death" },
		},
		["spa"] = {
			{ "Amuleto Iris",
				"↑ {{Luck}} Suerte +2#Aumenta demasiado la posibilidad de que los enemigos sean {{ColorRainbow}}Variocolor{{CR}}#Estos enemigos tienen más salud, correrán lejos del jugador y desaparecerán tras un tiempo#Estos pueden soltar una baratija dorada al morir" },
		},
		["ko_kr"] = {
			{ "빛나는부적",
				"↑ {{Luck}}운 +2#!!! 적들이 '색이 다른 챔피언'이 될 확률 증가#'색이 다른 챔피언'은 체력이 5배이며 캐릭터에게서 멀어지며 10초 후 사라집니다.#'색이 다른 챔피언' 처치 시 100%의 확률로 황금 장신구를 드랍합니다." },
		},
		["zh_cn"] = {
			{ "闪耀护符",
				"↑ {{Luck}} 幸运+2#大幅提高闪光敌人的出现概率#闪光敌人血量更高，会逃离角色，一段时间后消失#闪光敌人死后掉落金饰品" },
		},
	},
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = {
		["en_us"] = {
			{ "Black Glasses",
				"↑ {{Damage}} +0.5 Flat Damage up#{{Damage}} Gain a small Damage multiplier for each Devil Deal taken based on the cost of the item without modifiers#Works retroactively with deals taken before picking up the item" },
		},
		["spa"] = {
			{ "Lentes oscuros",
				"↑ Daño +0.5{{Damage}}#{{DevilRoom}} Recibes un pequeño multiplicador de daño por cada trato con el Diablo que hayas hecho#Trabaja de forma retroactiva con los tratos hechos antes de tomar el objeto" },
		},
		["ko_kr"] = {
			{ "검은안경",
				"↑ {{Damage}}최종 공격력 +0.5#{{Damage}} 현재 게임에서 {{ColorOrange}}악마 거래로 획득한 아이템의 원래 가격{{CR}}만큼 공격력 배율이 +10%p만큼 증가합니다." },
		},
		["zh_cn"] = {
			{ "黑色眼镜",
				"↑ {{Damage}} 伤害+0.5#{{Damage}} 角色每进行一次恶魔交易，将基于恶魔交易的价格获得伤害倍率修正。该效果无视价格变动#拾取该道具前进行的恶魔交易也会给予角色伤害倍率修正" },
		},
	},
	[EEVEEMOD.CollectibleType.COOKIE_JAR] = {
		["en_us"] = {
			{ "Cookie Jar",
				"{{Heart}} Upon use, heals 1 full Red Heart, up to 6 times#{{Speed}} -0.2 Speed down on every use, but goes away slowly over time#{{Heart}} On the final use, is consumed and grants +2 Red Heart containers" },
		},
		["spa"] = {
			{ "Tarro de galletas",
				"{{Heart}} Cura un corazón rojo en cada uso hasta 6 veces#{{Speed}} Velocidad -0.2 por cada uso, pero se reestablece tras un tiempo#{{Heart}} Tras su último uso, es consumido y otorga 2 contenedores de corazón" },
		},
		["ko_kr"] = {
			{ "쿠키가 담긴 병",
				"{{Heart}} 사용 시 체력 1칸을 회복합니다.#↓ {{Speed}}사용 시 이동속도 -0.2#감소한 이동속도는 시간이 지날수록 서서히 돌아옵니다.#↑ 6회 사용 시 최대 체력이 2칸 증가하며 병이 사라집니다." },
		},
		["zh_cn"] = {
			{ "饼干罐",
				"{{Heart}}使用时，治疗一红心，最多使用六次#{{Speed}}每次使用速度-0.2，该效果随着时间缓慢消失#{{Heart}} 最后一次使用时，心之容器+2，该道具用尽" },
		},
	},
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = {
		["en_us"] = {
			{ "Strange Egg",
				"Charges +1 bar per floor#Can be used when not fully charged, with different effects based on its charge:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: Heals 3 {{Heart}} Red Hearts#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: Spawns {{Collectible"
				..
				CollectibleType.COLLECTIBLE_BREAKFAST ..
				"}} Breakfast and 2 {{Heart}} Red Hearts#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: Spawns {{Collectible" ..
				EEVEEMOD.CollectibleType.LIL_EEVEE .. "}} Lil Eevee and 2 {{Heart}} Red Hearts" },
		},
		["spa"] = {
			{ "Strange Egg",
				"Recibe +1 carga por piso#Puede ser usado sin estar completamente cargado, con distintos efectos en base a sus cargas:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: {{Heart}} Cura 3 corazones rojos#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: Genera {{Collectible"
				..
				CollectibleType.COLLECTIBLE_BREAKFAST ..
				"}} Desayuno y {{Heart}} 2 corazones rojos#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: Spawns {{Collectible" ..
				EEVEEMOD.CollectibleType.LIL_EEVEE .. "}} Lil Eevee and 2 {{Heart}} Red Hearts" },
		},
		["ko_kr"] = {
			{ "이상한 알",
				"!!! 스테이지 진입 시에만 1칸 충전#사용 시 현재 충전량에 따라 다른 효과를 발동합니다:#{{Battery}} {{ColorYellow}}1{{CR}}: {{Heart}}체력 3칸 회복#{{Battery}} {{ColorYellow}}2{{CR}}: {{Collectible"
				..
				CollectibleType.COLLECTIBLE_BREAKFAST ..
				"}}Breakfast + {{Heart}}빨간하트 2개 드랍#{{Battery}} {{ColorYellow}}3{{CR}}: {{Collectible" ..
				EEVEEMOD.CollectibleType.LIL_EEVEE .. "}}Lil Eevee + {{Heart}}빨간하트 2개 드랍" },
		},
		["zh_cn"] = {
			{ "奇怪的蛋",
				"每进入新的一层，充能+1#未完全充能时可以使用，基于充能数触发不同效果:#{{Battery}} {{ColorYellow}}1{{ColorWhite}}: 治疗3{Heart}}红心#{{Battery}} {{ColorYellow}}2{{ColorWhite}}: 生成{{Collectible"
				..
				CollectibleType.COLLECTIBLE_BREAKFAST ..
				"}} 早餐和2{{Heart}} 红心#{{Battery}} {{ColorYellow}}3{{ColorWhite}}: 生成 {{Collectible" ..
				EEVEEMOD.CollectibleType.LIL_EEVEE .. "}} 小伊布和2 {{Heart}}红心" },
		},
	},
	[EEVEEMOD.CollectibleType.LIL_EEVEE] = {
		["en_us"] = {
			{ "Lil Eevee",
				"Normal tear familiar#The familiar's form changes randomly when Isaac uses a rune, having different tears for each form#Possible tears are similar to that of {{"
				.. Player.Eevee .. "}} Eevee and their Eeveelutions" },
		},
		["spa"] = {
			{ "Pequeño Eevee",
				"Familiar de disparo regular#{{Rune}} El aspecto del familiar cambiará cada vez que se use una runa, teniendo distintos efectos de lágrimas#{{"
				.. Player.Eevee .. "}} Las lágrimas pueden ser similares a las de Eevee y sus Eeveeluciones" },
		},
		["ko_kr"] = {
			{ "리틀 이브이",
				"공격하는 방향으로 공격력 3.5의 눈물을 발사합니다.#룬을 사용할 때마다 형태가 바뀌며 각 형태마다 다른 눈물을 발사합니다.#{{"
				.. Player.Eevee .. "}} 눈물효과는 이브이 캐릭터 및 진화형태 중에서 정해집니다." },
		},
		["zh_cn"] = {
			{ "小伊布",
				"正常的发射泪弹的跟班#角色每使用一次符文，小伊布随机变换一次形态，每个形态拥有不同效果的泪弹#可能的泪弹与 {{"
				.. Player.Eevee .. "}} 伊布和伊布家族类似" },
		},
	},
	[EEVEEMOD.CollectibleType.BAD_EGG] = {
		["en_us"] = {
			{ "Bad EGG",
				"Blocks projectiles, up to 32 before breaking#{{Warning}} Upon breaking, replaces a random owned famliiar with a duplicate {{Collectible"
				..
				EEVEEMOD.CollectibleType.BAD_EGG_DUPE ..
				"}} Bad EGG, and restores Bad EGG#Duplicates block less projectiles and disappear when breaking, respawning when Bad EGG breaks#If no other familiars are owned when broken, outside of duped Bad EGGs, removes Bad EGG and Spawns {{Collectible"
				.. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} Strange Egg" },
		},
		["spa"] = {
			{ "Huevo malo",
				"Bloquea hasta 32 proyectiles antes de romperse#{{Warning}} al momento de romperse, reemplaza uno de tus familiares con {{Collectible"
				..
				EEVEEMOD.CollectibleType.BAD_EGG_DUPE ..
				"}} un Huevo Malo#Los duplicados bloquean menos proyectiles y desaparecen al romperse, reapareciendo cuando el huevo malo se rompe#Si no hay otro familiar al romperse, a parte de los huevos malos duplicados, remueve un Huevo Malo y lo reemplaza con un {{Collectible"
				.. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} Huevo extraño" },
		},
		["ko_kr"] = {
			{ "오류투성이 알",
				"적의 탄환을 막아주며 최대 32회 막아줄 시 알이 깨집니다.#!!! 알이 깨질 시 소지 중인 패밀리어 중 하나를 감염시켜 복제된 {{Collectible"
				..
				EEVEEMOD.CollectibleType.BAD_EGG_DUPE ..
				"}}Bad EGG 패밀리어로 바꾼 후 Bad EGG를 다시 소환합니다.#복제된 Bad EGG는 최대 8회까지만 막아주며 원본 Bad EGG 파괴 시 다시 소환됩니다.#알이 깨질 시 감염시킬 패밀리어 및 복제된 Bad EGG가 하나도 없을 경우 {{Collectible"
				.. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}}Strange Egg를 소환하며 사라집니다." },
		},

		["zh_cn"] = {
			{ "坏蛋",
				"阻挡32颗泪弹后碎裂#{{Warning}} 碎裂时，替换一个随机跟班为坏蛋{{Collectible"
				..
				EEVEEMOD.CollectibleType.BAD_EGG_DUPE ..
				"}} 的复制品，并修复自身#复制的坏蛋可阻挡的泪弹更少，碎裂时消失，若坏蛋碎裂，将重新生成#若碎裂时角色没有复制的坏蛋之外的其它跟班, 则移除自身并生成 {{Collectible"
				.. EEVEEMOD.CollectibleType.STRANGE_EGG .. "}} 奇怪的蛋" },
		},
	},
	[EEVEEMOD.CollectibleType.BAD_EGG_DUPE] = {
		["en_us"] = {
			{ "Duped Bad EGG",
				"Blocks projectiles, up to 8 before disappearing#{{Warning}} Can only be respawned if {{Collectible" ..
				EEVEEMOD.CollectibleType.BAD_EGG .. "}} Bad EGG is owned and that familiar 'breaks'" },
		},
		["spa"] = {
			{ "Huevo malo duplicado",
				"Bloquea hasta 8 proyectiles antes de desaparecer#{{Warning}} Sólo se puede regenerar si es que se tiene al {{Collectible"
				.. EEVEEMOD.CollectibleType.BAD_EGG .. "}} Huevo Malo y ese familiar se 'rompe'" },
		},
		["ko_kr"] = {
			{ "오류투성이 알(복제)",
				"적의 탄환을 막아주며 최대 8회 막아줄 시 알이 깨집니다.#!!! 원본 {{Collectible" ..
				EEVEEMOD.CollectibleType.BAD_EGG .. "}}Bad EGG를 소지한 상태에서 해당 알이 깨지면 다시 소환됩니다." },
		},
		["zh_cn"] = {
			{ "复制的坏蛋",
				"阻挡8颗泪弹后消失,#{{Warning}} 只能在拥有{{Collectible" ..
				EEVEEMOD.CollectibleType.BAD_EGG .. "}} 坏蛋且其碎裂时生成" },
		},
	},
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = {
		["en_us"] = {
			{ "Wonderous Launcher",
				"Uses your pickups as ammunition and launches them:#{{Coin}} Amount consumed and damage dealt depends on coin count#{{Key}} Behaves like {{Collectible"
				..
				CollectibleType.COLLECTIBLE_SHARP_KEY ..
				"}} Sharp Key#{{Bomb}} Fires a bomb with all the player's bomb effects#{{PoopPickup}} If throwable, consumes your next spell in queue. Spawns its respective poop on contact." },
		},
		["spa"] = {
			{ "Lanzador",
				"Utiliza tus recolectables como munición:#{{Coin}} La cantidad consumida y daño dependerá de tu cantidad de monedas#{{Key}} Es igual que la {{Collectible"
				..
				CollectibleType.COLLECTIBLE_SHARP_KEY ..
				"}} Llave afilada(¿Así se llama?)#{{Bomb}} Dispara una bomba con todos los efectos de bomba que tenga el jugador#{{PoopPickup}} Si se puede lanzar, consumirá el siguiente efecto en la lista. Genera su respectiva popó al contacto" },
		},
		["ko_kr"] = {
			{ "미라클슈터",
				"사용 시 픽업을 소모하여 발사합니다.#{{ButtonRT}}버튼을 사용하여 소모할 픽업을 선택할 수 있으며 소모한 픽업에 따라 투사체의 효과가 달라집니다:#{{Coin}} 소모한 동전의 개수에 비례하여 명중한 적에게 피해를 줍니다.#{{Key}} {{Collectible"
				..
				CollectibleType.COLLECTIBLE_SHARP_KEY ..
				"}}Sharp Key 아이템과 동일#{{Bomb}} 폭탄을 투척합니다.#{{PoopPickup}} 적 명중 시 현재 선택된 종류의 똥을 소환합니다." },
		},
		["zh_cn"] = {
			{ "奇迹发射器",
				"将角色的掉落物像炮弹一样发射:#{{Coin}} 消耗的硬币数和造成的伤害取决于角色持有的硬币数#{{Key}} 行为模式可视作 {{Collectible"
				..
				CollectibleType.COLLECTIBLE_SHARP_KEY ..
				"}} 尖头钥匙#{{Bomb}} 发射一个具有角色所有炸弹特效的炸弹#{{PoopPickup}} 若可扔出，则按顺序消耗角色的下一个便便。接触时各自生成便便。" },
		},
	},
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = {
		["en_us"] = {
			{ "Bag of Poke Balls",
				"Every 12 rooms, spawns a random type of Poké Ball#50% {{Card" ..
				EEVEEMOD.PokeballType.POKEBALL ..
				"}} Poké Ball#30% {{Card" ..
				EEVEEMOD.PokeballType.GREATBALL ..
				"}} Great Ball#20% {{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} Ultra Ball" },
		},
		["spa"] = {
			{ "Bolsa de Pokébolas",
				"Cada 12 salas, genera una Pokébola aleatoria#{{Card" ..
				EEVEEMOD.PokeballType.POKEBALL ..
				"}} 50% de posibilidad de una Pokébola #{{Card" ..
				EEVEEMOD.PokeballType.GREATBALL ..
				"}} 30% de posibilidad de una Superbola#{{Card" ..
				EEVEEMOD.PokeballType.ULTRABALL .. "}} 20% de posibilidad de una Ultrabola" },
		},
		["ko_kr"] = {
			{ "몬스터볼 가방",
				"!!! 방 12개 클리어 시 랜덤 몬스터볼을 드랍합니다:#{{Card" ..
				EEVEEMOD.PokeballType.POKEBALL ..
				"}} 몬스터볼: 50%#{{Card" ..
				EEVEEMOD.PokeballType.GREATBALL .. "}} 슈퍼볼: 30% #{{Card" ..
				EEVEEMOD.PokeballType.ULTRABALL .. "}} 하이퍼볼: 20%" },
		},
		["zh_cn"] = {
			{ "一袋精灵球",
				"每清理12个房间，生成一个随机精灵球#50% {{Card" ..
				EEVEEMOD.PokeballType.POKEBALL ..
				"}} 精灵球#30% {{Card" ..
				EEVEEMOD.PokeballType.GREATBALL ..
				"}} 超级球#20% {{Card" .. EEVEEMOD.PokeballType.ULTRABALL .. "}} 高级球" },
		},
	},
	[EEVEEMOD.CollectibleType.MASTER_BALL] = {
		["en_us"] = {
			{ "Master Ball - {{Throwable}}",
				"Can be thrown at an enemy or boss to capture them, turning them into a friendly companion#{{Warning}} Successful capture results in this item being destroyed#Walking over the ball or leaving the room instantly recharges the item#Has an extreme effect on the captured enemy's health" },
		},
		["spa"] = {
			{ "Master Ball - {{Throwable}}",
				"Puede ser lanzado a un enemigo o un jefe para capturarlo, Convirtíendolo en un compañero#{{Warning}} Una captura exitosa destruirá el objeto#Caminar sobre la bola o dejar la sala recargará el objeto#Tiene un efecto extremo en la salud del capturado" },
		},
		["ko_kr"] = {
			{ "마스터볼",
				"!!! 일회용#{{Throwable}} 사용 시 공격하는 방향으로 몬스터볼을 던집니다.#몬스터볼에 맞은 적 및 보스는 100%의 확률로 포획되며 잠시 후 아군 상태로 소환되며 체력을 대폭 회복합니다.#방 이동시 혹은 포획 시도에 실패한 마스터볼 획득 시 즉시 재충전됩니다." },
		},
		["zh_cn"] = {
			{ "大师球- {{Throwable}}",
				"可朝敌人或头目扔出以捕捉它们, 将其变为友好的跟班#{{Warning}} 成功捕捉后该道具损毁#使用后该道具充能归零，角色可以跨过它或离开房间为其充能#成功捕捉后，该敌人血量大幅提升" },
		},
	},
	[EEVEEMOD.CollectibleType.POKE_STOP] = {
		["en_us"] = {
			{ "Poke Stop",
				"Spawns a Poke Stop on first pickup. Every floor a Poke Stop appears in a random special room#Interacting with it has it drop a random assortment of {{Coin}} Coins, {{Key}} Keys, and {{Bomb}} Bombs, and a special pickup based on the type of room it's in" },
		},
		["spa"] = {
			{ "Poképarada",
				"Se generará una Poképarada al momento de tomarlo. En cada piso aparecerá una Poképarada en una sala especial aleatoria#Interactuar con esta soltará una cierta cantidad de {{Coin}} Monedas, {{Key}} Llaves, y {{Bomb}} Bombas, junto a un recolectable especial basado en la sala" },
		},
		["ko_kr"] = {
			{ "포켓스톱",
				"획득 시 포켓스톱 하나를 배치합니다.#매 스테이지마다 랜덤 특수방에서 포켓스톱이 배치됩니다.#배치된 포켓스톱 위치로 이동 시 {{Coin}}/{{Key}}/{{Bomb}} 픽업과 소환된 특수방에 따라 다른 픽업 아이템을 드랍합니다." },
		},
		["zh_cn"] = {
			{ "精灵驿站",
				"拾取首个掉落物时，生成一个精灵驿站（实体）（译者注：下文皆指代同名实体）。精灵驿站出现在每层的一个随机特殊房间内#若与其交互，则会掉落各种掉落物{{Coin}}硬币， {{Key}} 钥匙和 {{Bomb}} 炸弹，以及基于所在的房间的类型生成的特殊掉落物" },
		},
	},
	[EEVEEMOD.CollectibleType.TAIL_WHIP] = {
		["en_us"] = {
			{ "Tail Whip",
				"Extends a tail out that spins in a circle, knocking back enemies and projectiles#Enemies hit are given a {{Weakness}} Weakness effect for 5 seconds#Projectiles hit can damage enemies" },
		},
		["spa"] = {
			{ "Látigo",
				"Extiende una cola que hace un ataque giratorio, aplicando retroceso a los enemigos y reflectando disparos#{{Weakness}} Los enemigos golpeados reciben un efecto de debilidad por 5 segundos#Los proyectiles pueden dañar a los enemigos" },
		},
		["ko_kr"] = {
			{ "꼬리흔들기",
				"사용 시 꼬리를 한 바퀴 흔들며 근처의 적을 밀쳐내며 탄환을 반사합니다.#{{Weakness}} 밀친 적을 5초동안 약화시킵니다." },
		},
		["zh_cn"] = {
			{ "摆尾",
				"伸出一条围成圈的尾巴, 尾巴可以击退敌人反弹泪弹#敌人被击退后获得5秒 {{Weakness}}虚弱效果#泪弹被反弹后可对敌人造成伤害" },
		},
	},
}
local TrinketDescriptions = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		["en_us"] = {
			{ "Eviolite",
				"Grants the following stats if you don't have a transformation:#↑ {{Speed}} +0.2 Speed up#↑ +10% {{Tears}} Tears Up#↑ {{Damage}} +10% Damage Multiplier#↑ {{Range}} +2 Range up#↑ {{Shotspeed}} +0.2 Shot Speed up" },
		},
		["spa"] = {
			{ "Mineral Evolutivo",
				"Otorga los siguientes aumentos de estadísticas si no te has transformado:#↑ {{Speed}} Velocidad +0.2#↑ {{Tears}} Lágrimas +10% #↑ {{Damage}} Multiplicador de daño +10% #↑ {{Range}} Alcance +2#↑ {{Shotspeed}} Vel. de lágrimas +0.2" },
		},
		["ko_kr"] = {
			{ "진화의휘석",
				"!!! 완성된 변신 세트가 없을 경우:#↑ {{Speed}}이동속도 +0.2#↑ {{Tears}}연사 배율 x1.1#↑ {{Damage}}공격력 배율 x1.1#↑ {{Range}}사거리 +2#↑ {{Shotspeed}}탄속 +0.2" },
		},
		["zh_cn"] = {
			{ "进化奇石",
				"若角色未获得套装，则提升以下属性:#↑ {{Speed}}速度+0.2#↑ {{Tears}} 射速+10%#↑ {{Damage}}伤害倍率+10%#↑ {{Range}}射程+2#↑ {{Shotspeed}}弹速+0.2" },
		},
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		["en_us"] = {
			{ "Lock-On Specs",
				"↑ {{Damage}} +100% Damage Multiplier#↑ {{Range}} +3 Range up#↑ {{Shotspeed}} +0.3 Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +10%" },
		},
		["spa"] = {
			{ "Lock-On Specs",
				"↑ {{Damage}} Multiplicador de daño +100% #↑ {{Range}} Alcance +3#↑ {{Shotspeed}} Vel. de lágrimas +0.3#{{Warning}} Recibir daño puede destruir el trinket. Si no, la posibilidad de que ocurra aumenta en +10%" },
		},
		["ko_kr"] = {
			{ "록온안경",
				"↑ {{Damage}}공격력 배율 x2.0#↑ {{Range}}사거리 +3#↑ {{Shotspeed}}탄속 +0.3#!!! 패널티 피격 시 일정 확률로 사라지며 사라지지 않았을 경우 사라질 확률 +10%" },
		},
		["zh_cn"] = {
			{ "锁定眼镜",
				"↑ {{Damage}}伤害倍率+100%#↑ {{Range}}射程+3#↑ {{Shotspeed}}弹速+0.3#{{Warning}} 受伤可能导致该饰品消失，反之则消失的概率+10%" },
		},
	},
	[EEVEEMOD.TrinketType.ALERT_SPECS] = {
		["en_us"] = {
			{ "Alert Specs",
				"Prevents Isaac from dropping coins caused by taking damage from Greed enemies and projectiles" },
		},
		["spa"] = {
			{ "Alert Specs",
				"Evita que el jugador pierda monedas por los ataques de Ultra Codicia" },
		},
		["ko_kr"] = {
			{ "경계안경", "Greed류 공격 피격 시에도 동전을 잃지 않습니다." },
		},
		["zh_cn"] = {
			{ "警戒眼镜",
				"防止角色被贪婪类敌人和敌方泪弹打掉硬币" },
		},
	},
}
local TrinketDescriptions_Golden = {
	[EEVEEMOD.TrinketType.EVIOLITE] = {
		["en_us"] = {
			[2] = "Grants the following stats if you don't have a transformation:#↑ {{Speed}} +{{ColorGold}}0.3{{ColorWhite}} Speed up#↑ {{Tears}} +{{ColorGold}}15%{{ColorWhite}} Tears Up#↑ {{Damage}} +{{ColorGold}}15%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}4{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.4{{ColorWhite}} Shot Speed up",
			[3] = "Grants the following stats if you don't have a transformation:#↑ {{Speed}} +{{ColorGold}}0.4{{ColorWhite}} Speed up#↑ {{Tears}} +{{ColorGold}}40%{{ColorWhite}} Tears Up#↑ {{Damage}} +{{ColorGold}}40%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}6{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.4{{ColorWhite}} Shot Speed up",
		},
		["spa"] = {
			[2] = "Otorga los siguientes aumentos de stats si no tienes una transformación:#↑ {{Speed}} Velocidad +{{ColorGold}}0.3{{CR}}#↑ {{Tears}} Lágrimas +{{ColorGold}}15%{{CR}}#↑ +{{ColorGold}}15%{{CR}} {{Damage}} Multiplicador de daño +{{ColorGold}}15%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}4{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.4{{CR}}",
			[3] = "Otorga los siguientes aumentos de stats si no tienes una transformación:#↑ {{Speed}} Velocidad +{{ColorGold}}0.4{{CR}}#↑ {{Tears}} Lágrimas +{{ColorGold}}40%{{CR}}#↑ +{{ColorGold}}40%{{CR}} {{Damage}} Multiplicador de daño +{{ColorGold}}15%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.4{{CR}}",
		},
		["ko_kr"] = {
			[2] = "!!! 완성된 변신 세트가 없을 경우:#↑ {{Speed}}이동속도 +{{ColorGold}}0.3{{CR}}#↑ {{Tears}}연사 배율 x{{ColorGold}}1.15{{CR}}#↑ {{Damage}}공격력 배율 x{{ColorGold}}1.15{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}4{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.4{{CR}}",
			[3] = "!!! 완성된 변신 세트가 없을 경우:#↑ {{Speed}}이동속도 +{{ColorGold}}0.4{{CR}}#↑ {{Tears}}연사 배율 x{{ColorGold}}1.4{{CR}}#↑ {{Damage}}공격력 배율 x{{ColorGold}}1.4{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.4{{CR}}",
		},
		["zh_cn"] = {
			[2] = "若角色未获得套装，则提升以下属性:#↑ {{Speed}}速度+{{ColorGold}}0.3{{CR}}#↑ {{Tears}} 射速+{{ColorGold}}15%{{CR}}#↑ {{Damage}} 伤害倍率+{{ColorGold}}15%{{CR}}#↑ {{Range}} 射程+{{ColorGold}}4{{CR}}#↑ {{Shotspeed}} 弹速+{{ColorGold}}0.4{{CR}}",
			[3] = "若角色未获得套装，则提升以下属性:#↑ {{Speed}}速度+{{ColorGold}}0.4{{CR}}#↑ {{Tears}} 射速+{{ColorGold}}40%{{CR}}#↑ {{Damage}} 伤害倍率+{{ColorGold}}40%{{CR}}#↑ {{Range}} 射程+{{ColorGold}}6{{CR}}#↑ {{Shotspeed}} 弹速+{{ColorGold}}0.4{{CR}}",
		},
	},
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = {
		["en_us"] = {
			[2] = "↑ {{Damage}} +{{ColorGold}}200%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}6{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.6{{ColorWhite}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +{{ColorGold}}20%{{ColorWhite}}",
			[3] = "↑ {{Damage}} +{{ColorGold}}300%{{ColorWhite}} Damage Multiplier#↑ {{Range}} +{{ColorGold}}9{{ColorWhite}} Range up#↑ {{Shotspeed}} +{{ColorGold}}0.9{{ColorWhite}} Shot Speed up#{{Warning}} Taking damage may destroy the trinket. If not, chance of destroying it increases by +{{ColorGold}}30%{{ColorWhite}}",
		},
		["spa"] = {
			[2] = "↑ {{Damage}} Multiplicador de daño +{{ColorGold}}200%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.6{{CR}}#{{Warning}} Redibir daño puede destruir la baratija. Si no, esta posibilidad aumentará en un +{{ColorGold}}20%{{ColorWhite}}",
			[3] = "↑ {{Damage}} Multiplicador de daño +{{ColorGold}}300%{{CR}}#↑ {{Range}} Alcance +{{ColorGold}}9{{CR}}#↑ {{Shotspeed}} Vel. de lágrimas +{{ColorGold}}0.9{{CR}}#{{Warning}} Redibir daño puede destruir la baratija. Si no, esta posibilidad aumentará en un +{{ColorGold}}30%{{ColorWhite}}",
		},
		["ko_kr"] = {
			[2] = "↑ {{Damage}}공격력 배율 x{{ColorGold}}3.0{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.6{{CR}}#!!! 패널티 피격 시 일정 확률로 사라지며 사라지지 않았을 경우 사라질 확률 +{{ColorGold}}20%{{CR}}",
			[3] = "↑ {{Damage}}공격력 배율 x{{ColorGold}}4.0{{CR}}#↑ {{Range}}사거리 +{{ColorGold}}9{{CR}}#↑ {{Shotspeed}}탄속 +{{ColorGold}}0.9{{CR}}#!!! 패널티 피격 시 일정 확률로 사라지며 사라지지 않았을 경우 사라질 확률 +{{ColorGold}}30%{{CR}}",
		},
		["zh_cn"] = {
			[2] = "↑ {{Damage}} 伤害倍率+{{ColorGold}}200%{{CR}}#↑ {{Range}}射程 +{{ColorGold}}6{{CR}}#↑ {{Shotspeed}}弹速 +{{ColorGold}}0.6{{CR}}#{{Warning}}受伤可能导致该饰品消失，反之则消失概率+{{ColorGold}}20%{{ColorWhite}}",
			[3] = "↑ {{Damage}} 伤害倍率+{{ColorGold}}300%{{CR}}#↑ {{Range}}射程 +{{ColorGold}}9{{CR}}#↑ {{Shotspeed}} 弹速+{{ColorGold}}0.9{{CR}}#{{Warning}}受伤可能导致该饰品消失，反之则消失概率+{{ColorGold}}20%{{ColorWhite}}",
		},
	}
}
local CardDescriptions = {
	[EEVEEMOD.PokeballType.POKEBALL] = {
		["en_us"] = {
			{ "Poke Ball - {{Throwable}}",
				"Throw at enemies and bosses to capture them#Captured enemies become permanently charmed#Ball may break after capture#On bosses, may resist capture depending on HP and status effects, will always break regardless of capture#{{Card"
				.. EEVEEMOD.PokeballType.POKEBALL .. "}} x1 Capture Rate, small effect on health" },
		},
		["spa"] = {
			{ "Poké Ball - {{Throwable}}",
				"Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card"
				.. EEVEEMOD.PokeballType.POKEBALL .. "}} Posibilidad de captura x1, efecto reducido en los PV" },
		},
		["ko_kr"] = {
			{ "몬스터볼",
				"{{Throwable}} 공격하는 방향으로 던질 수 있으며 일정 확률로 포획한 적 및 보스를 아군으로 만들 수 있습니다.#일정 확률로 재사용 가능#보스 포획 시도 시 체력 및 상태이상에 따라 포획에 실패할 수 있으며 재사용할 수 없습니다.#{{Card"
				.. EEVEEMOD.PokeballType.POKEBALL .. "}} 포획률 x1, 포획한 몬스터의 체력 소량 회복" },
		},
		["zh_cn"] = {
			{ "精灵球 - {{Throwable}}",
				"朝敌人扔出精灵球从而将其捕捉#被捕的敌人获得永久魅惑效果#使用后可能报废#头目战中，受血量和状态影响，捕捉可能会失败。不论是否成功使用后都将报废#{{Card"
				.. EEVEEMOD.PokeballType.POKEBALL .. "}}捕捉成功率 x1, 小幅提升被捕敌人的血量" },
		},
	},
	[EEVEEMOD.PokeballType.GREATBALL] = {
		["en_us"] = {
			{ "Great Ball - {{Throwable}}",
				"Throw at enemies and bosses to capture them#Captured enemies become permanently charmed#Ball may break after capture#On bosses, may resist capture depending on HP and status effects, will always break regardless of capture#{{Card"
				.. EEVEEMOD.PokeballType.GREATBALL .. "}} x2 Capture Rate, moderate effect on health" },
		},
		["spa"] = {
			{ "Great Ball - {{Throwable}}",
				"Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card"
				.. EEVEEMOD.PokeballType.POKEBALL .. "}} Posibilidad de captura x2, efecto moderado en los PV" },
		},
		["ko_kr"] = {
			{ "슈퍼볼",
				"{{Throwable}} 공격하는 방향으로 던질 수 있으며 일정 확률로 포획한 적 및 보스를 아군으로 만들 수 있습니다.#일정 확률로 재사용 가능#보스 포획 시도 시 체력 및 상태이상에 따라 포획에 실패할 수 있으며 재사용할 수 없습니다.#{{Card"
				.. EEVEEMOD.PokeballType.GREATBALL .. "}} 포획률 x2, 포획한 몬스터의 체력 중량 회복" },
		},
		["zh_cn"] = {
			{ "大师球 - {{Throwable}}",
				"朝敌人扔出大师球从而将其捕捉#被捕的敌人获得永久魅惑效果#使用后可能报废#头目战中，受血量和状态影响，捕捉可能会失败。不论是否成功使用后都将报废#{{Card"
				.. EEVEEMOD.PokeballType.GREATBALL .. "}} 捕捉成功率x2，中幅提升被捕敌人的血量" },
		},
	},
	[EEVEEMOD.PokeballType.ULTRABALL] = {
		["en_us"] = {
			{ "Ultra Ball - {{Throwable}}",
				"Throw at enemies and bosses to capture them#Captured enemies become permanently charmed#Ball may break after capture#On bosses, may resist capture depending on HP and status effects, will always break regardless of capture#{{Card"
				.. EEVEEMOD.PokeballType.ULTRABALL .. "}} x3 Capture Rate, large effect on health" },
		},
		["spa"] = {
			{ "Ultra Ball - {{Throwable}}",
				"Lánzalo a un enemigo o jefe para capturarlo#{{Charm}} Los enemigos capturados tendrán un encanto permantente#La bola se puede romper después de la captura#Los jefes pueden resistirse a la captura en base a sus efectos de estado y su PV, la bola siempre se romperá tras la captura#{{Card"
				.. EEVEEMOD.PokeballType.POKEBALL .. "}} Posibilidad de captura x3, efecto amplio en los PV" },
		},
		["ko_kr"] = {
			{ "하이퍼볼",
				"{{Throwable}} 공격하는 방향으로 던질 수 있으며 일정 확률로 포획한 적 및 보스를 아군으로 만들 수 있습니다.#일정 확률로 재사용 가능#보스 포획 시도 시 체력 및 상태이상에 따라 포획에 실패할 수 있으며 재사용할 수 없습니다.#{{Card"
				.. EEVEEMOD.PokeballType.ULTRABALL .. "}} 포획률 x3, 포획한 몬스터의 체력 대량 회복" },
		},
		["zh_cn"] = {
			{ "高级球 - {{Throwable}}",
				"朝敌人扔出高级球从而将其捕捉#被捕的敌人获得永久魅惑效果#使用后可能报废#头目战中，受血量和状态影响，捕捉可能会失败。不论是否成功使用后都将报废#{{Card"
				.. EEVEEMOD.PokeballType.ULTRABALL .. "}} 捕捉成功率x3，大幅提升被捕敌人的血量" },
		},
	},
}
local BirthrightDescriptions = {
	[EEVEEMOD.PlayerType.EEVEE] = {
		["en_us"] = {
			{ "Eevee",
				"Gives Eevee the {{Collectible" ..
				EEVEEMOD.CollectibleType.TAIL_WHIP ..
				"}} Tail Whip ability#Spins Eevee's tail in a circle, knocking back enemies and projectiles" },
		},
		["spa"] = {
			{ "Eevee",
				"{{Collectible" ..
				EEVEEMOD.CollectibleType.TAIL_WHIP ..
				"}} Da a Eevee la habilidad Látigo#Gira la cola de Eevee, haciendo retroceder enemigos y rechazando disparos" },
		},
		["ko_kr"] = {
			{ "이브이",
				"{{Collectible" ..
				EEVEEMOD.CollectibleType.TAIL_WHIP .. "}} 이브이가 꼬리흔들기를 배웁니다.#사용 시 꼬리를 한 바퀴 흔들며 근처의 적을 밀쳐내며 탄환을 반사합니다." },
		},
		["zh_cn"] = {
			{ "伊布",
				"伊布获得{{Collectible" ..
				EEVEEMOD.CollectibleType.TAIL_WHIP ..
				"}} 摆尾#伊布的尾巴围成圈，击退敌人和泪弹" },
		},
	},
}
local CollectiblesDescriptions_Modified = {
	[EEVEEMOD.PlayerType.EEVEE] = {
		[CollectibleType.COLLECTIBLE_ANGELIC_PRISM] = {
			["en_us"] = "Stars orbit closer to Eevee",
			["spa"] = "Las estrellas orbitan más cerca de Eevee",
			["ko_kr"] = "별이 더 가까운 위치에서 회전합니다.",
			["zh_cn"] = "迅星的环绕半径更小，离伊布更近",
		},
		[CollectibleType.COLLECTIBLE_BRIMSTONE] = {
			["en_us"] = "Stars are replaced with large blood orbs, firing lasers on release",
			["spa"] = "Las estrellas son reemplazadas con orbes sangrientos, disparan láseres al soltarlas",
			["ko_kr"] = "별이 혈사 고리로 바뀌며 공격 키를 떼면 혈사를 한번에 발사합니다.",
			["zh_cn"] = "大硫磺火团替换迅星，松开时发射硫磺火",
		},
		[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = {
			["en_us"] = "Stars scale in damage according to how long Swift has been charged, from 50% to 200% damage",
			["spa"] = "El daño de las estrellas escala de acuerdo en qué tanto se haya cargado Rapidez, de 50% a 200% de daño",
			["ko_kr"] = "별이 모여 있는 정도에 따라 공격력 배율이 x0.5 ~ x2로 증감합니다.",
			["zh_cn"] = "蓄力越久，迅星造成的伤害更高，造成50%到200%点角色伤害",
		},
		[CollectibleType.COLLECTIBLE_CURSED_EYE] = {
			["en_us"] = "{{ColorRed}}No effect",
			["spa"] = "{{ColorRed}} Sin efecto",
			["ko_kr"] = "!!! {{ColorRed}}무효과",
			["zh_cn"] = "{{ColorRed}}无效果",
		},
		[CollectibleType.COLLECTIBLE_DR_FETUS] = {
			["en_us"] = "Stars are repalced with bombs and do not start detonating until fired from Swift",
			["spa"] = "Las estrellas son reemplazadas con bombas que no explotarán hasta que sean disparadas",
			["ko_kr"] = "별이 폭탄으로 바뀌며 발사되기 전까지 폭탄이 설치되지 않습니다.",
			["zh_cn"] = "炸弹替换迅星，发射后爆炸",
		},
		[CollectibleType.COLLECTIBLE_EPIC_FETUS] = {
			["en_us"] = "{{Warning}} Overrides Swift",
			["spa"] = "{{Warning}} Sobreescribe a Rapidez",
			["ko_kr"] = "!!! Swift의 효과가 무효화됨: 이브이가 더 이상 별을 발사할 수 없음",
			["zh_cn"] = "{{Warning}} 覆盖迅星",
		},
		[CollectibleType.COLLECTIBLE_EYE_SORE] = {
			["en_us"] = "Extra shots will originate from your stars when fired from Swift",
			["spa"] = "Se lanzarán disparos extra de las estrellas al ser disparadas",
			["ko_kr"] = "별이 발사될 때 각 별마다 랜덤 방향으로 다른 별을 추가로 발사합니다.",
			["zh_cn"] = "若攻击方式为迅星，则额外的泪弹由迅星发射",
		},
		[CollectibleType.COLLECTIBLE_FIRE_MIND] = {
			["en_us"] = "Stars orbit outside of explosion radius from Eevee",
			["spa"] = "Las estrellas orbitan fuera del radio de explosión que dañe a Eevee",
			["ko_kr"] = "별이 더 먼 위치에서 회전합니다.",
			["zh_cn"] = "迅星发射后在伊布的爆炸范围之外运动",
		},
		[CollectibleType.COLLECTIBLE_INCUBUS] = {
			["en_us"] = "{{Warning}} Does not copy Swift's homing, spectral, or auto-aim",
			["spa"] = "{{Warning}} No copia ninguno de los efectos especiales de Rapidez",
			["ko_kr"] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
			["zh_cn"] = "{{Warning}} 泪弹不具有追踪，幽灵或自动瞄准等泪弹效果",
		},
		[CollectibleType.COLLECTIBLE_IPECAC] = {
			["en_us"] = "Stars do not arc#Stars orbit outside of explosion radius from Eevee",
			["spa"] = "Las estrellas no serán arqueadas#Las estrellas orbitan fuera del radio de explosión que dañe a Eevee",
			["ko_kr"] = "별이 곡선형으로 발사되지 않음#별이 더 먼 위치에서 회전합니다.",
			["zh_cn"] = "正常发射迅星而不是抛射#迅星发射后在伊布的爆炸范围之外运动",
		},
		[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = {
			["en_us"] = "Extra shots will originate from your stars when fired from Swift",
			["spa"] = "Se lanzarán disparos extra de las estrellas al ser disparadas",
			["ko_kr"] = "별이 발사될 때 각 별마다 다른 별을 추가로 발사합니다.",
			["zh_cn"] = "若攻击方式为迅星，则额外的泪弹由迅星发射",
		},
		[CollectibleType.COLLECTIBLE_LOST_CONTACT] = {
			["en_us"] = "Stars orbit closer to Eevee",
			["spa"] = "Las estrellas orbitan más cerca de Eevee",
			["ko_kr"] = "별이 더 가까운 위치에서 회전합니다.",
			["zh_cn"] = "迅星的环绕半径更小，离伊布更近",
		},
		[CollectibleType.COLLECTIBLE_MOMS_EYE] = {
			["en_us"] = "Extra shots will originate from your stars when fired from Swift",
			["spa"] = "Se lanzarán disparos extra de las estrellas al ser disparadas",
			["ko_kr"] = "별이 발사될 때 각 별마다 다른 별을 추가로 발사합니다.",
			["zh_cn"] = "若攻击方式为迅星，则额外的泪弹由星星发射"
		},
		[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = {
			["en_us"] = "Stars are replaced with knives and have a limited lifetime dependent on range once fired",
			["spa"] = "Las estrellas serán reemplazadas con cuchillos, tendrán un tiempo de vida limitado en base al alcance una vez disparadas",
			["ko_kr"] = "별 대신 칼을 발사하며 사거리에 따라 투사체가 더 멀리 날아갑니다.",
			["zh_cn"] = "刀替代迅星。发射时，射程越高，刀存在的时间越久",
		},
		[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] = {
			["en_us"] = "6 additional stars orbit each star at random distances",
			["spa"] = "Otras 6 estrellas orbitarán de forma adicional sobre cada estrella en distancias aleatorias",
			["ko_kr"] = "각 별마다 주위를 도는 6개의 작은 별이 추가로 발사됩니다.",
			["zh_cn"] = "每颗迅星周围都有6颗额外的迅星以随机距离围绕其运动",
		},
		[CollectibleType.COLLECTIBLE_NEPTUNUS] = {
			["en_us"] = "Stars automatically spawn around Eevee when not firing#Grants a second orbit of stars#Stars fire rapidly when firing",
			["spa"] = "Stars automatically spawn around Eevee when not firing#Grants a second orbit of stars#Stars fire rapidly when firing",
			["ko_kr"] = "Stars automatically spawn around Eevee when not firing#Grants a second orbit of stars#Stars fire rapidly when firing",
			["zh_cn"] = "不攻击时，迅星自动围绕伊布生成#额外生成一圈迅星#发射时，快速发射迅星",
		},
		[CollectibleType.COLLECTIBLE_SPRINKLER] = {
			["en_us"] = "{{Warning}} Does not copy Swift's homing, spectral, or auto-aim",
			["spa"] = "{{Warning}} No copia ninguno de los efectos especiales de Rapidez",
			["ko_kr"] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
			["zh_cn"] = "{{Warning}} 泪弹不具有追踪，幽灵或自动瞄准等泪弹效果",
		},
		[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = {
			["en_us"] = "Swift stars spawn around you during the spin attack, shooting forward when finishing the spin#↓ Can no longer fire projectiles",
			["spa"] = "Las estrellas de Rapidez se generarán durante el ataque giratorio, disparándose en cuanto termine el ataque#↓ Ya no puedes disparar",
			["ko_kr"] = "완충 시에만 별을 발사할 수 있으며 별은 최대 충전 상태로 발사됩니다.",
			["zh_cn"] = "挥舞时，迅星在角色周围生成。释放剑气时迅星向前发射#↓不再发射泪弹"
		},
		[CollectibleType.COLLECTIBLE_SUMPTORIUM] = {
			["en_us"] = "{{Warning}} Clots do not copy Swift's homing, spectral, or auto-aim",
			["spa"] = "{{Warning}} Los coágulos no copian ninguno de los efectos especiales de Rapidez ",
			["ko_kr"] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
			["zh_cn"] = "{{Warning}} 血团宝宝发射的泪弹不具有追踪，幽灵或自动瞄准等泪弹效果",
		},
		[CollectibleType.COLLECTIBLE_TECH_X] = {
			["en_us"] = "Stars are replaced with technology orbs, firing laser rings on release",
			["spa"] = "Las estrellas se reemplazan con orbes de Tecnología, disparan anillos láser al ser soltados",
			["ko_kr"] = "별이 레이저 구슬로 바뀌며 공격 키를 떼면 레이저 고리를 한번에 발사합니다.",
			["zh_cn"] = "激光环替换迅星，松开时发射激光",
		},
		[CollectibleType.COLLECTIBLE_TECHNOLOGY] = {
			["en_us"] = "Stars are replaced with technology orbs, firing lasers on release",
			["spa"] = "Las estrellas se reemplazan con orbes de Tecnología, disparan láseres al ser soltados",
			["ko_kr"] = "별이 레이저 구슬로 바뀌며 공격 키를 떼면 레이저를 한번에 발사합니다.",
			["zh_cn"] = "激光环替换星星，松开时发射激光",
		},
		[CollectibleType.COLLECTIBLE_TECHNOLOGY_2] = {
			["en_us"] = "Stars let out a continuous laser before they are fired from Swift",
			["spa"] = "Las estrellas disparan un rayo láser constante antes de ser disparadas",
			["ko_kr"] = "발사되지 않은 별에서 레이저를 발사합니다.",
			["zh_cn"] = "发射星星前，星星将发射一道持续不断的激光",
		},
		[CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE] = {
			["en_us"] = "Replaces the giant tear with a spinning ring of Swift stars",
			["spa"] = "La gran lágrima es reemplazada por estrellas de Rapidez orbitantes",
			["ko_kr"] = "하나의 커다란 눈물이 5개의 작은 별로 바뀝니다.",
			["zh_cn"] = "迅星替换巨大的泪弹，悬浮迅星环不停旋转",
		},
		[CollectibleType.COLLECTIBLE_TINY_PLANET] = {
			["en_us"] = "Stars continuously orbit Eevee and fire additional stars based on firerate, releasing once Eevee stops firing",
			["spa"] = "Las estrellas orbitarán constantemente sobre Eevee y dispararán estrellas adicionales basadas en la cadencia de fuego additional#Soltar hará que Eevee deje de disparar",
			["ko_kr"] = "공격키를 뗄 때까지 별을 계속 발사합니다.",
			["zh_cn"] = "迅星持续围绕伊布运动。发射时，基于射速发射额外的迅星, 停止射击时立刻发射",
		},
		[CollectibleType.COLLECTIBLE_TWISTED_PAIR] = {
			["en_us"] = "{{Warning}} Does not copy Swift's homing, spectral, or auto-aim",
			["spa"] = "{{Warning}} No copia ninguno de los efectos especiales de Rapidez",
			["ko_kr"] = "!!! 이브이의 Swift 능력을 복사하지 않으며 일반 눈물을 발사합니다.",
			["zh_cn"] = "{{Warning}} 泪弹不具有追踪，幽灵或自动瞄准等泪弹效果",
		},
	}
}
local TrinketDescriptions_Modified = {
	[EEVEEMOD.PlayerType.EEVEE] = {
		[EEVEEMOD.TrinketType.EVIOLITE] = {
			["en_us"] = "Increases all stats by +100%, but are also lost upon evolving#{{Warning}} As evolutions are not yet implemented, these bonus stats are disabled",
			["spa"] = "Aumenta todas las estadísticas al 100%, el efecto se pierde al evolucionar#{{Warning}} Como las evoluciones no se han implementado, esta bonificación no está disponible",
			["ko_kr"] = "!!! 현재 적용 안됨#↑ 모든 능력치 배울 x2.0# 진화 시 사라집니다.",
			["zh_cn"] = "全属性提升的效果翻倍，但进化后失效#{{Warning}} 进化尚未实装，该效果无效",
		}
	}
}
--For Eevee/Eeveelution display names on the "_Modified" item descriptions
local SynergyDisplayName = {
	["en_us"] = {
		Eevee = "Eevee",
		Eevee_B = "Tainted Eevee",
	},
	["spa"] = {
		Eevee = "Eevee",
		Eevee_B = "Tainted Eevee"
	},
	["ko_kr"] = {
		Eevee = "이브이",
		Eevee_B = "Tainted 이브이"
	},
	["zh_cn"] = {
		Eevee = "伊布",
		Eevee_B = "Tainted 伊布"
	}
}

local function getDescription(table)
	return table[EID:getLanguage()] or table["en_us"]
end

for itemID, languages in pairs(CollectibleDescriptions) do
	for language, desc in pairs(languages) do
		EID:addCollectible(itemID, desc[2], desc[1], language)
	end
end
for trinketID, languages in pairs(TrinketDescriptions) do
	for language, desc in pairs(languages) do
		EID:addTrinket(trinketID, desc[2], desc[1], language)
	end
end
for cardID, languages in pairs(CardDescriptions) do
	for language, desc in pairs(languages) do
		EID:addCard(cardID, desc[2], desc[1], language)
	end
end
for playerType, languages in pairs(BirthrightDescriptions) do
	for language, desc in pairs(languages) do
		EID:addBirthright(playerType, desc[2], desc[1], language)
	end
end

--Unique descriptions for Eevee
local function AddEeveeText(descObj)
	local itemDesc = nil
	if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
		itemDesc = getDescription(CollectiblesDescriptions_Modified[EEVEEMOD.PlayerType.EEVEE][descObj.ObjSubType])
	elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
		itemDesc = getDescription(TrinketDescriptions_Modified[EEVEEMOD.PlayerType.EEVEE][descObj.ObjSubType])
	end
	if itemDesc ~= nil then
		local iconStr = "#{{" .. Player.Eevee .. "}} {{ColorGray}}" .. getDescription(SynergyDisplayName).Eevee .. "#"
		EID:appendToDescription(descObj, iconStr .. itemDesc)
	end
	return descObj
end

local function IfEeveeActive(descObj)
	local players = vee.GetAllPlayers()
	local eeveeIsHere = false

	for i = 1, #players do
		local player = players[i]
		local playerType = player:GetPlayerType()

		if playerType == EEVEEMOD.PlayerType.EEVEE then
			if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
				local table = CollectiblesDescriptions_Modified[playerType][descObj.ObjSubType]
				if table then
					eeveeIsHere = true
				end
			elseif descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
				local table = TrinketDescriptions_Modified[playerType][descObj.ObjSubType]
				if table then
					eeveeIsHere = true
				end
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
	descObj.Description = getDescription(TrinketDescriptions_Golden[trinketID])[multiplier]
	return descObj
end

local function IfMultipliedTrinket(descObj)
	local isStatBoosted = false
	local trinketID = EID:getAdjustedSubtype(descObj.ObjType, descObj.ObjVariant, descObj.ObjSubType)
	isGolden = (descObj.ObjSubType > TrinketType.TRINKET_GOLDEN_FLAG)
	hasBox = EID.collectiblesOwned[439]
	if TrinketDescriptions_Golden[trinketID] and (isGolden or hasBox) then
		isStatBoosted = true
	end
	return isStatBoosted
end

EID:addDescriptionModifier("Eevee Multiplied Trinkets", IfMultipliedTrinket, GoldenTrinketCallback)

return eid
