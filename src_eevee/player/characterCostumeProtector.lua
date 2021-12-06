local ccp = {}

--TODO: Once finished with all the costumes, make a system for the ear/fluff/head costumes.
--Tie a costume to an item/effect, and because it can't be detected, create a custom priority list.

local baseCostumePath = "gfx/characters/costume_"
local baseCostumeSuffixPath = "gfx/characters/costumes_"

local playerToProtect = {
	[EEVEEMOD.PlayerType.EEVEE] = true,
}
local playerCostume = {
	[EEVEEMOD.PlayerType.EEVEE] = "gfx/characters/costume_eevee"
}
local playerSpritesheet = {
	[EEVEEMOD.PlayerType.EEVEE] = "gfx/characters/costumes/character_eevee",
}
local playerItemCostumeWhitelist = {}
local playerNullItemCostumeWhitelist = {}
local playerTrinketCostumeWhitelist = {}
local costumeList = {
	[CollectibleType.COLLECTIBLE_SAD_ONION] = false,
	[CollectibleType.COLLECTIBLE_INNER_EYE] = false,
	[CollectibleType.COLLECTIBLE_SPOON_BENDER] = true,
	[CollectibleType.COLLECTIBLE_CRICKETS_HEAD] = true,
	[CollectibleType.COLLECTIBLE_MY_REFLECTION] = true,
	[CollectibleType.COLLECTIBLE_NUMBER_ONE] = false,
	[CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR] = true,
	[CollectibleType.COLLECTIBLE_SKATOLE] = false,
	[CollectibleType.COLLECTIBLE_VIRUS] = false,
	[CollectibleType.COLLECTIBLE_ROID_RAGE] = true,
	[CollectibleType.COLLECTIBLE_HEART] = true,
	[CollectibleType.COLLECTIBLE_SKELETON_KEY] = true,
	[CollectibleType.COLLECTIBLE_BOOM] = false, --TODO: Maybe
	[CollectibleType.COLLECTIBLE_TRANSCENDENCE] = true,
	[CollectibleType.COLLECTIBLE_WOODEN_SPOON] = false,
	[CollectibleType.COLLECTIBLE_BELT] = true,
	[CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR] = false,
	[CollectibleType.COLLECTIBLE_MOMS_HEELS] = true,
	[CollectibleType.COLLECTIBLE_MOMS_LIPSTICK] = true,
	[CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER] = false,
	[CollectibleType.COLLECTIBLE_BIBLE] = true,
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = true,
	[CollectibleType.COLLECTIBLE_KAMIKAZE] = false,
	[CollectibleType.COLLECTIBLE_LUCKY_FOOT] = true,
	[CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = true,
	[CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = true,
	[CollectibleType.COLLECTIBLE_STEVEN] = false,
	[CollectibleType.COLLECTIBLE_PENTAGRAM] = false,
	[CollectibleType.COLLECTIBLE_DR_FETUS] = true,
	[CollectibleType.COLLECTIBLE_MAGNETO] = true,
	[CollectibleType.COLLECTIBLE_MOMS_EYE] = false,
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = true,
	[CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = true,
	[CollectibleType.COLLECTIBLE_BATTERY] = false,
	[CollectibleType.COLLECTIBLE_STEAM_SALE] = true,
	[CollectibleType.COLLECTIBLE_TECHNOLOGY] = true,
	[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = false,
	[CollectibleType.COLLECTIBLE_GROWTH_HORMONES] = false,
	[CollectibleType.COLLECTIBLE_ROSARY] = true,
	[CollectibleType.COLLECTIBLE_PHD] = true,
	[CollectibleType.COLLECTIBLE_XRAY_VISION] = true,
	[CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = true,
	[CollectibleType.COLLECTIBLE_MARK] = true,
	[CollectibleType.COLLECTIBLE_PACT] = true,
	[CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT] = true,
	[CollectibleType.COLLECTIBLE_THE_NAIL] = false,
	[CollectibleType.COLLECTIBLE_MONSTROS_TOOTH] = true,
	[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = false,
	[CollectibleType.COLLECTIBLE_SPIDER_BITE] = false,
	[CollectibleType.COLLECTIBLE_SMALL_ROCK] = false,
	[CollectibleType.COLLECTIBLE_SPELUNKER_HAT] = false,
	[CollectibleType.COLLECTIBLE_SUPER_BANDAGE] = true,
	[CollectibleType.COLLECTIBLE_GAMEKID] = false,
	[CollectibleType.COLLECTIBLE_HALO] = true,
	[CollectibleType.COLLECTIBLE_COMMON_COLD] = false,
	[CollectibleType.COLLECTIBLE_PARASITE] = false,
	[CollectibleType.COLLECTIBLE_PINKING_SHEARS] = true,
	[CollectibleType.COLLECTIBLE_WAFER] = true,
	[CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = true,
	[CollectibleType.COLLECTIBLE_MOMS_CONTACTS] = false,
	[CollectibleType.COLLECTIBLE_OUIJA_BOARD] = false,
	[CollectibleType.COLLECTIBLE_9_VOLT] = false,
	[CollectibleType.COLLECTIBLE_DEAD_BIRD] = true,
	[CollectibleType.COLLECTIBLE_BRIMSTONE] = true,
	[CollectibleType.COLLECTIBLE_BLOOD_BAG] = false,
	[CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON] = true,
	[CollectibleType.COLLECTIBLE_RAZOR_BLADE] = true,
	[CollectibleType.COLLECTIBLE_BUCKET_OF_LARD] = true, --TODO
	[CollectibleType.COLLECTIBLE_PONY] = true,
	[CollectibleType.COLLECTIBLE_LUMP_OF_COAL] = true,
	[CollectibleType.COLLECTIBLE_GUPPYS_TAIL] = true,
	[CollectibleType.COLLECTIBLE_STIGMATA] = false,
	[CollectibleType.COLLECTIBLE_MOMS_PURSE] = true,
	[CollectibleType.COLLECTIBLE_BOBS_CURSE] = false,
	[CollectibleType.COLLECTIBLE_PAGEANT_BOY] = true,
	[CollectibleType.COLLECTIBLE_SCAPULAR] = true,
	[CollectibleType.COLLECTIBLE_SPEED_BALL] = true,
	[CollectibleType.COLLECTIBLE_INFESTATION] = false,
	[CollectibleType.COLLECTIBLE_IPECAC] = false,
	[CollectibleType.COLLECTIBLE_TOUGH_LOVE] = false,
	[CollectibleType.COLLECTIBLE_MULLIGAN] = false,
	[CollectibleType.COLLECTIBLE_TECHNOLOGY_2] = true,
	[CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = false,
	[CollectibleType.COLLECTIBLE_CHEMICAL_PEEL] = false,
	[CollectibleType.COLLECTIBLE_PEEPER] = false,
	[CollectibleType.COLLECTIBLE_HABIT] = true,
	[CollectibleType.COLLECTIBLE_BLOODY_LUST] = true,
	[CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT] = true,
	[CollectibleType.COLLECTIBLE_ANKH] = true,
	[CollectibleType.COLLECTIBLE_CELTIC_CROSS] = true,
	[CollectibleType.COLLECTIBLE_CAT_O_NINE_TAILS] = false,
	[CollectibleType.COLLECTIBLE_EPIC_FETUS] = true,
	[CollectibleType.COLLECTIBLE_POLYPHEMUS] = false,
	[CollectibleType.COLLECTIBLE_MITRE] = true,
	[CollectibleType.COLLECTIBLE_STEM_CELLS] = false,
	[CollectibleType.COLLECTIBLE_FATE] = true,
	[CollectibleType.COLLECTIBLE_WHITE_PONY] = true,
	[CollectibleType.COLLECTIBLE_SACRED_HEART] = true,
	[CollectibleType.COLLECTIBLE_TOOTH_PICKS] = false,
	[CollectibleType.COLLECTIBLE_HOLY_GRAIL] = true,
	[CollectibleType.COLLECTIBLE_DEAD_DOVE] = true,
	[CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = true,
	[CollectibleType.COLLECTIBLE_PYRO] = false, --TODO: Maybe
	[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = true,
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = true,
	[CollectibleType.COLLECTIBLE_MEAT] = true,
	[CollectibleType.COLLECTIBLE_MAGIC_8_BALL] = false,
	[CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE] = true,
	[CollectibleType.COLLECTIBLE_SQUEEZY] = false,
	[CollectibleType.COLLECTIBLE_JESUS_JUICE] = true,
	[CollectibleType.COLLECTIBLE_BOX] = false,
	[CollectibleType.COLLECTIBLE_MOMS_KEY] = true,
	[CollectibleType.COLLECTIBLE_MOMS_EYESHADOW] = true,
	[CollectibleType.COLLECTIBLE_IRON_BAR] = false,
	[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = true,
	[CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE] = true,
	[CollectibleType.COLLECTIBLE_FANNY_PACK] = true,
	[CollectibleType.COLLECTIBLE_SHARP_PLUG] = false,
	[CollectibleType.COLLECTIBLE_GUILLOTINE] = true,
	[CollectibleType.COLLECTIBLE_CHAMPION_BELT] = false,
	[CollectibleType.COLLECTIBLE_BUTT_BOMBS] = false,
	[CollectibleType.COLLECTIBLE_GNAWED_LEAF] = true,
	[CollectibleType.COLLECTIBLE_SPIDERBABY] = false,
	[CollectibleType.COLLECTIBLE_GUPPYS_COLLAR] = true,
	[CollectibleType.COLLECTIBLE_LOST_CONTACT] = true,
	[CollectibleType.COLLECTIBLE_ANEMIC] = false,
	[CollectibleType.COLLECTIBLE_GOAT_HEAD] = false,
	[CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES] = true,
	[CollectibleType.COLLECTIBLE_MOMS_WIG] = true,
	[CollectibleType.COLLECTIBLE_PLACENTA] = false,
	[CollectibleType.COLLECTIBLE_OLD_BANDAGE] = true,
	[CollectibleType.COLLECTIBLE_RUBBER_CEMENT] = false,
	[CollectibleType.COLLECTIBLE_ANTI_GRAVITY] = true,
	[CollectibleType.COLLECTIBLE_PYROMANIAC] = false,
	[CollectibleType.COLLECTIBLE_CRICKETS_BODY] = false,
	[CollectibleType.COLLECTIBLE_GIMPY] = false,
	[CollectibleType.COLLECTIBLE_BLACK_LOTUS] = false,
	[CollectibleType.COLLECTIBLE_PIGGY_BANK] = false, --TODO: Maybe
	[CollectibleType.COLLECTIBLE_MOMS_PERFUME] = false,
	[CollectibleType.COLLECTIBLE_MONSTROS_LUNG] = false,
	[CollectibleType.COLLECTIBLE_ABADDON] = false,
	[CollectibleType.COLLECTIBLE_BALL_OF_TAR] = true,
	[CollectibleType.COLLECTIBLE_STOP_WATCH] = true,
	[CollectibleType.COLLECTIBLE_TINY_PLANET] = false,
	[CollectibleType.COLLECTIBLE_INFESTATION_2] = false,
	[CollectibleType.COLLECTIBLE_E_COLI] = false,
	[CollectibleType.COLLECTIBLE_DEATHS_TOUCH] = false,
	[CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT] = false,
	[CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW] = true,
	[CollectibleType.COLLECTIBLE_INFAMY] = true,
	[CollectibleType.COLLECTIBLE_TECH_5] = true,
	[CollectibleType.COLLECTIBLE_20_20] = true,
	[CollectibleType.COLLECTIBLE_BFFS] = true,
	[CollectibleType.COLLECTIBLE_THERES_OPTIONS] = true,
	[CollectibleType.COLLECTIBLE_BOGO_BOMBS] = false, --TODO: Maybe
	[CollectibleType.COLLECTIBLE_STARTER_DECK] = true,
	[CollectibleType.COLLECTIBLE_LITTLE_BAGGY] = false, --TODO: Maybe
	[CollectibleType.COLLECTIBLE_MAGIC_SCAB] = false,
	[CollectibleType.COLLECTIBLE_BLOOD_CLOT] = false,
	[CollectibleType.COLLECTIBLE_SCREW] = false,
	[CollectibleType.COLLECTIBLE_HOT_BOMBS] = true,
	[CollectibleType.COLLECTIBLE_FIRE_MIND] = false,
	[CollectibleType.COLLECTIBLE_DARK_MATTER] = false,
	[CollectibleType.COLLECTIBLE_BLACK_CANDLE] = false,
	[CollectibleType.COLLECTIBLE_PROPTOSIS] = false,
	[CollectibleType.COLLECTIBLE_MISSING_PAGE_2] = true,
	[CollectibleType.COLLECTIBLE_ROBO_BABY_2] = true,
	[CollectibleType.COLLECTIBLE_TAURUS] = true, --Technically yes, but is removed per room.
	[CollectibleType.COLLECTIBLE_ARIES] = false,
	[CollectibleType.COLLECTIBLE_CANCER] = false,
	[CollectibleType.COLLECTIBLE_LEO] = false,
	[CollectibleType.COLLECTIBLE_VIRGO] = true,
	[CollectibleType.COLLECTIBLE_LIBRA] = true,
	[CollectibleType.COLLECTIBLE_SCORPIO] = true,
	[CollectibleType.COLLECTIBLE_SAGITTARIUS] = false,
	[CollectibleType.COLLECTIBLE_CAPRICORN] = false,
	[CollectibleType.COLLECTIBLE_AQUARIUS] = true,
	[CollectibleType.COLLECTIBLE_PISCES] = false, --TODO: Maybe, but annoying
	[CollectibleType.COLLECTIBLE_EVES_MASCARA] = true,
	[CollectibleType.COLLECTIBLE_MAGGYS_BOW] = true,
	[CollectibleType.COLLECTIBLE_HOLY_MANTLE] = true,
	[CollectibleType.COLLECTIBLE_THUNDER_THIGHS] = false, --...maybe.
	[CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR] = false,
	[CollectibleType.COLLECTIBLE_CURSED_EYE] = false,
	[CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID] = true,
	[CollectibleType.COLLECTIBLE_SCISSORS] = true,
	[CollectibleType.COLLECTIBLE_POLAROID] = true,
	[CollectibleType.COLLECTIBLE_NEGATIVE] = true,
	[CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE] = false,
	[CollectibleType.COLLECTIBLE_SOY_MILK] = true,
	[CollectibleType.COLLECTIBLE_GODHEAD] = true,
	[CollectibleType.COLLECTIBLE_LAZARUS_RAGS] = false,
	[CollectibleType.COLLECTIBLE_MIND] = false,
	[CollectibleType.COLLECTIBLE_BODY] = false,
	[CollectibleType.COLLECTIBLE_SOUL] = true,
	[CollectibleType.COLLECTIBLE_DEAD_ONION] = false,
	[CollectibleType.COLLECTIBLE_BROKEN_WATCH] = true,
	[CollectibleType.COLLECTIBLE_BOOMERANG] = true,
	[CollectibleType.COLLECTIBLE_SAFETY_PIN] = false,
	[CollectibleType.COLLECTIBLE_CAFFEINE_PILL] = false,
	[CollectibleType.COLLECTIBLE_TORN_PHOTO] = true,
	[CollectibleType.COLLECTIBLE_BLUE_CAP] = true,
	[CollectibleType.COLLECTIBLE_LATCH_KEY] = true,
	[CollectibleType.COLLECTIBLE_MATCH_BOOK] = true,
	[CollectibleType.COLLECTIBLE_SYNTHOIL] = false,
	[CollectibleType.COLLECTIBLE_TOXIC_SHOCK] = true,
	[CollectibleType.COLLECTIBLE_BOMBER_BOY] = true,
	[CollectibleType.COLLECTIBLE_CRACK_JACKS] = true,
	[CollectibleType.COLLECTIBLE_MOMS_PEARLS] = true,
	[CollectibleType.COLLECTIBLE_CAR_BATTERY] = false,
	[CollectibleType.COLLECTIBLE_THE_WIZ] = true,
	[CollectibleType.COLLECTIBLE_8_INCH_NAILS] = false,
	[CollectibleType.COLLECTIBLE_SCATTER_BOMBS] = false,
	[CollectibleType.COLLECTIBLE_STICKY_BOMBS] = false,
	[CollectibleType.COLLECTIBLE_EPIPHORA] = true,
	[CollectibleType.COLLECTIBLE_CONTINUUM] = false,
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = true,
	[CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER] = false,
	[CollectibleType.COLLECTIBLE_DEAD_EYE] = true,
	[CollectibleType.COLLECTIBLE_HOLY_LIGHT] = true,
	[CollectibleType.COLLECTIBLE_HOST_HAT] = true,
	[CollectibleType.COLLECTIBLE_BURSTING_SACK] = false, --TODO: Maybe
	[CollectibleType.COLLECTIBLE_NUMBER_TWO] = false,
	[CollectibleType.COLLECTIBLE_PUPULA_DUPLEX] = false,
	[CollectibleType.COLLECTIBLE_PAY_TO_PLAY] = true,
	[CollectibleType.COLLECTIBLE_EDENS_BLESSING] = true,
	[CollectibleType.COLLECTIBLE_BETRAYAL] = false,
	[CollectibleType.COLLECTIBLE_ZODIAC] = true,
	[CollectibleType.COLLECTIBLE_SERPENTS_KISS] = true,
	[CollectibleType.COLLECTIBLE_MARKED] = true,
	[CollectibleType.COLLECTIBLE_TECH_X] = true,
	[CollectibleType.COLLECTIBLE_TRACTOR_BEAM] = true,
	[CollectibleType.COLLECTIBLE_GODS_FLESH] = false,
	[CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = false,
	[CollectibleType.COLLECTIBLE_CHAOS] = true,
	[CollectibleType.COLLECTIBLE_PURITY] = true,
	[CollectibleType.COLLECTIBLE_ATHAME] = false,
	[CollectibleType.COLLECTIBLE_EMPTY_VESSEL] = true,
	[CollectibleType.COLLECTIBLE_EVIL_EYE] = false,
	[CollectibleType.COLLECTIBLE_LUSTY_BLOOD] = false,
	[CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION] = false, --TODO: Should be given support anyway as they actually tell information.
	[CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION] = false, --TODO: Should be given support anyway as they actually tell information.
	[CollectibleType.COLLECTIBLE_MORE_OPTIONS] = true,
	[CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = true,
	[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = true,
	[CollectibleType.COLLECTIBLE_BLACK_POWDER] = true,
	[CollectibleType.COLLECTIBLE_SACK_HEAD] = false,
	[CollectibleType.COLLECTIBLE_NIGHT_LIGHT] = true,
	[CollectibleType.COLLECTIBLE_PJS] = true,
	[CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = true,
	[CollectibleType.COLLECTIBLE_GLITTER_BOMBS] = true,
	[CollectibleType.COLLECTIBLE_MY_SHADOW] = true,
	[CollectibleType.COLLECTIBLE_BINKY] = true,
	[CollectibleType.COLLECTIBLE_MEGA_BLAST] = true,
	[CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN] = true,
	[CollectibleType.COLLECTIBLE_APPLE] = false,
	[CollectibleType.COLLECTIBLE_LEAD_PENCIL] = false,
	[CollectibleType.COLLECTIBLE_DOG_TOOTH] = false,
	[CollectibleType.COLLECTIBLE_DEAD_TOOTH] = false,
	[CollectibleType.COLLECTIBLE_LINGER_BEAN] = false,
	[CollectibleType.COLLECTIBLE_SHARD_OF_GLASS] = false,
	[CollectibleType.COLLECTIBLE_METAL_PLATE] = false,
	[CollectibleType.COLLECTIBLE_EYE_OF_GREED] = true,
	[CollectibleType.COLLECTIBLE_TAROT_CLOTH] = false,
	[CollectibleType.COLLECTIBLE_VARICOSE_VEINS] = false,
	[CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE] = false,
	[CollectibleType.COLLECTIBLE_POLYDACTYLY] = false,
	[CollectibleType.COLLECTIBLE_DADS_LOST_COIN] = true,
	[CollectibleType.COLLECTIBLE_CONE_HEAD] = false,
	[CollectibleType.COLLECTIBLE_BELLY_BUTTON] = false,
	[CollectibleType.COLLECTIBLE_SINUS_INFECTION] = false,
	[CollectibleType.COLLECTIBLE_GLAUCOMA] = true,
	[CollectibleType.COLLECTIBLE_PARASITOID] = false,
	[CollectibleType.COLLECTIBLE_EYE_OF_BELIAL] = false,
	[CollectibleType.COLLECTIBLE_SULFURIC_ACID] = false,
	[CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE] = true,
	[CollectibleType.COLLECTIBLE_ANALOG_STICK] = false,
	[CollectibleType.COLLECTIBLE_CONTAGION] = false,
	[CollectibleType.COLLECTIBLE_JACOBS_LADDER] = true,
	[CollectibleType.COLLECTIBLE_GHOST_PEPPER] = false,
	[CollectibleType.COLLECTIBLE_EUTHANASIA] = true,
	[CollectibleType.COLLECTIBLE_CAMO_UNDIES] = true, --TODO: Zoroark pants, not just undies.
	[CollectibleType.COLLECTIBLE_DUALITY] = true,
	[CollectibleType.COLLECTIBLE_EUCHARIST] = true, --TODO: Maybe?
	[CollectibleType.COLLECTIBLE_GREEDS_GULLET] = false,
	[CollectibleType.COLLECTIBLE_LARGE_ZIT] = false,
	[CollectibleType.COLLECTIBLE_LITTLE_HORN] = false,
	[CollectibleType.COLLECTIBLE_BACKSTABBER] = false,
	[CollectibleType.COLLECTIBLE_DELIRIOUS] = true,
	
	-- Booster Pack #1
	[CollectibleType.COLLECTIBLE_BOZO] = true,
	[CollectibleType.COLLECTIBLE_BROKEN_MODEM] = false,
	[CollectibleType.COLLECTIBLE_FAST_BOMBS] = true,

	-- Booster Pack #2
	[CollectibleType.COLLECTIBLE_JUMPER_CABLES] = false,
	[CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO] = true,
	[CollectibleType.COLLECTIBLE_LEPROSY] = false,
	
	-- Booster Pack #3
	[CollectibleType.COLLECTIBLE_POP] = false,

	-- Booster Pack #4
	[CollectibleType.COLLECTIBLE_DEATHS_LIST] = true,
	[CollectibleType.COLLECTIBLE_HAEMOLACRIA] = false,
	[CollectibleType.COLLECTIBLE_LACHRYPHAGY] = false,
	[CollectibleType.COLLECTIBLE_TRISAGION] = true,
	[CollectibleType.COLLECTIBLE_SCHOOLBAG] = false, --TODO: Maybe
	
	-- Booster Pack #5
	[CollectibleType.COLLECTIBLE_BLANKET] = true,
	[CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR] = true,
	[CollectibleType.COLLECTIBLE_FLAT_STONE] = false,

	[CollectibleType.COLLECTIBLE_MARROW] = false,
	[CollectibleType.COLLECTIBLE_DADS_RING] = true,
	[CollectibleType.COLLECTIBLE_DIVORCE_PAPERS] = false,
	[CollectibleType.COLLECTIBLE_BRITTLE_BONES] = false,
	
	-- Repentance
	[CollectibleType.COLLECTIBLE_MUCORMYCOSIS] = false,
	[CollectibleType.COLLECTIBLE_2SPOOKY] = false,
	[CollectibleType.COLLECTIBLE_SULFUR] = true,
	[CollectibleType.COLLECTIBLE_EYE_SORE] = false,
	[CollectibleType.COLLECTIBLE_120_VOLT] = true,
	[CollectibleType.COLLECTIBLE_IT_HURTS] = false,
	[CollectibleType.COLLECTIBLE_ALMOND_MILK] = true,
	[CollectibleType.COLLECTIBLE_ROCK_BOTTOM] = true,
	[CollectibleType.COLLECTIBLE_BAR_OF_SOAP] = true,
	[CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE] = true,
	[CollectibleType.COLLECTIBLE_SOCKS] = true,
	[CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT] = false,
	[CollectibleType.COLLECTIBLE_IMMACULATE_HEART] = false, --TODO
	[CollectibleType.COLLECTIBLE_MONSTRANCE] = true,
	[CollectibleType.COLLECTIBLE_INTRUDER] = false,
	[CollectibleType.COLLECTIBLE_DIRTY_MIND] = false,
	[CollectibleType.COLLECTIBLE_WAVY_CAP] = false,
	[CollectibleType.COLLECTIBLE_SOL] = true,
	[CollectibleType.COLLECTIBLE_LUNA] = true,
	[CollectibleType.COLLECTIBLE_MERCURIUS] = true,
	[CollectibleType.COLLECTIBLE_VENUS] = false,
	[CollectibleType.COLLECTIBLE_TERRA] = true,
	[CollectibleType.COLLECTIBLE_MARS] = true,
	[CollectibleType.COLLECTIBLE_JUPITER] = false, --TODO
	[CollectibleType.COLLECTIBLE_URANUS] = true,
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = false, --TODO
	[CollectibleType.COLLECTIBLE_PLUTO] = true,
	[CollectibleType.COLLECTIBLE_VOODOO_HEAD] = false,
	[CollectibleType.COLLECTIBLE_EYE_DROPS] = false,
	[CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION] = true,
	[CollectibleType.COLLECTIBLE_MEMBER_CARD] = true,
	[CollectibleType.COLLECTIBLE_BATTERY_PACK] = false,
	[CollectibleType.COLLECTIBLE_SCOOPER] = false,
	[CollectibleType.COLLECTIBLE_OCULAR_RIFT] = false,
	[CollectibleType.COLLECTIBLE_LARYNX] = true,
	[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = false,
	[CollectibleType.COLLECTIBLE_BIRDS_EYE] = false,
	[CollectibleType.COLLECTIBLE_LODESTONE] = false,
	[CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = false,
	[CollectibleType.COLLECTIBLE_RED_STEW] = true,
	[CollectibleType.COLLECTIBLE_MEGA_MUSH] = true,
	[CollectibleType.COLLECTIBLE_EVIL_CHARM] = true,
	[CollectibleType.COLLECTIBLE_DOGMA] = true,
	[CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = true,
	[CollectibleType.COLLECTIBLE_AKELDAMA] = false,
	[CollectibleType.COLLECTIBLE_REVELATION] = true,
	[CollectibleType.COLLECTIBLE_CONSOLATION_PRIZE] = true,
	[CollectibleType.COLLECTIBLE_4_5_VOLT] = false,
	[CollectibleType.COLLECTIBLE_FALSE_PHD] = true,
	[CollectibleType.COLLECTIBLE_VASCULITIS] = false,
	[CollectibleType.COLLECTIBLE_GIANT_CELL] = true,
	[CollectibleType.COLLECTIBLE_TROPICAMIDE] = false,
	[CollectibleType.COLLECTIBLE_CARD_READING] = false,
	[CollectibleType.COLLECTIBLE_TOOTH_AND_NAIL] = true,
	[CollectibleType.COLLECTIBLE_BINGE_EATER] = false, --TODO
	[CollectibleType.COLLECTIBLE_GUPPYS_EYE] = true,
	[CollectibleType.COLLECTIBLE_SAUSAGE] = true,
	[CollectibleType.COLLECTIBLE_OPTIONS] = true, --TODO: Done!
	[CollectibleType.COLLECTIBLE_CANDY_HEART] = false,
	[CollectibleType.COLLECTIBLE_POUND_OF_FLESH] = false,
	[CollectibleType.COLLECTIBLE_REDEMPTION] = true,
	[CollectibleType.COLLECTIBLE_SPIRIT_SHACKLES] = true,
	[CollectibleType.COLLECTIBLE_CRACKED_ORB] = true,
	[CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION] = true,
	[CollectibleType.COLLECTIBLE_C_SECTION] = false, --TODO??
	[CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE] = false,
	[CollectibleType.COLLECTIBLE_SOUL_LOCKET] = true,
	[CollectibleType.COLLECTIBLE_INNER_CHILD] = true,
	[CollectibleType.COLLECTIBLE_JELLY_BELLY] = false, --TODO
	[CollectibleType.COLLECTIBLE_AZAZELS_RAGE] = true,
	[CollectibleType.COLLECTIBLE_ESAU_JR] = true,
	[CollectibleType.COLLECTIBLE_BERSERK] = true,
	[CollectibleType.COLLECTIBLE_STAPLER] = false,
	[CollectibleType.COLLECTIBLE_LEMEGETON] = false,
	[CollectibleType.COLLECTIBLE_HEMOPTYSIS] = true,
	[CollectibleType.COLLECTIBLE_GLASS_EYE] = false,
	[CollectibleType.COLLECTIBLE_STYE] = false,
	[CollectibleType.COLLECTIBLE_MOMS_RING] = false --TODO
}
local nullEffectsList = { --Null effects that are detectable that have costumes.
	[NullItemID.ID_PUBERTY] = false,
	[NullItemID.ID_I_FOUND_PILLS] = false,
	[NullItemID.ID_LORD_OF_THE_FLIES] = true,
	[NullItemID.ID_GUPPY] = true,
	[NullItemID.ID_WIZARD] = true,
	[NullItemID.ID_BLINDFOLD] = true,
	[NullItemID.ID_BLANKFACE] = true,
	[NullItemID.ID_CHRISTMAS] = true,
	[NullItemID.ID_PURITY_GLOW] = true,
	[NullItemID.ID_EMPTY_VESSEL] = true,
	[NullItemID.ID_MUSHROOM] = false,
	[NullItemID.ID_ANGEL] = false,
	[NullItemID.ID_BOB] = false,
	[NullItemID.ID_DRUGS] = false,
	[NullItemID.ID_MOM] = false,
	[NullItemID.ID_BABY] = false,
	[NullItemID.ID_EVIL_ANGEL] = true,
	[NullItemID.ID_POOP] = false,
	[NullItemID.ID_OVERDOSE] = false,
	[NullItemID.ID_IWATA] = false,
	[NullItemID.ID_BOOKWORM] = true,
	[NullItemID.ID_ADULTHOOD] = false,
	[NullItemID.ID_SPIDERBABY] = false,
	[NullItemID.ID_BATWING_WINGS] = true,
	[NullItemID.ID_SACRIFICIAL_ALTAR] = true,
	
	-- Repentance
	[NullItemID.ID_BRIMSTONE2] = true,
	[NullItemID.ID_HOLY_CARD] = true,
	[NullItemID.ID_INTRUDER] = false, --TODO: Idk what happens here
	[NullItemID.ID_SOL] = true,
	[NullItemID.ID_IT_HURTS] = false,
	[NullItemID.ID_TOOTH_AND_NAIL] = true,
	[NullItemID.ID_REVERSE_MAGICIAN] = true,
	[NullItemID.ID_REVERSE_EMPRESS] = true,
	[NullItemID.ID_REVERSE_CHARIOT] = true,
	[NullItemID.ID_REVERSE_STRENGTH] = false,
	[NullItemID.ID_REVERSE_HANGED_MAN] = true,
	[NullItemID.ID_REVERSE_SUN] = true,
	[NullItemID.ID_REVERSE_CHARIOT_ALT] = true,
	[NullItemID.ID_WAVY_CAP_1] = false,
	[NullItemID.ID_WAVY_CAP_2] = false,
	[NullItemID.ID_WAVY_CAP_3] = false,
	[NullItemID.ID_LUNA] = true,
	[NullItemID.ID_JUPITER_BODY] = false, --TODO
	[NullItemID.ID_JUPITER_BODY_ANGEL] = false,
	[NullItemID.ID_JUPITER_BODY_PONY] = false,
	[NullItemID.ID_JUPITER_BODY_WHITEPONY] = false,
	[NullItemID.ID_AZAZELS_RAGE_1] = true,
	[NullItemID.ID_AZAZELS_RAGE_2] = true,
	[NullItemID.ID_AZAZELS_RAGE_3] = true,
	[NullItemID.ID_AZAZELS_RAGE_4] = true,
	[NullItemID.ID_ESAU_JR] = true,
	[NullItemID.ID_SPIRIT_SHACKLES_SOUL] = true,
	[NullItemID.ID_SPIRIT_SHACKLES_DISABLED] = true,
	[NullItemID.ID_LOST_CURSE] = true,
	[NullItemID.ID_I_FOUND_HORSE_PILLS] = false,
	[NullItemID.ID_HORSE_PUBERTY] = false,
	[125] = true, --Double Guppy's Eye
	[126] = false --Double Glass Eye
}
local trinketCostumeList = {
	[TrinketType.TRINKET_RED_PATCH] = false,
	[TrinketType.TRINKET_TICK] = false,
	[TrinketType.TRINKET_AZAZELS_STUMP] = true
}
local activeItemCostumes = {
	[CollectibleType.COLLECTIBLE_BIBLE] = true,
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = true,
	[CollectibleType.COLLECTIBLE_MOMS_BRA] = true,
	[CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = true,
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = true,
	[CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = true,
	[CollectibleType.COLLECTIBLE_THE_NAIL] = true,
	[CollectibleType.COLLECTIBLE_GAMEKID] = true,
	[CollectibleType.COLLECTIBLE_RAZOR_BLADE] = true,
	[CollectibleType.COLLECTIBLE_PONY] = true,
	[CollectibleType.COLLECTIBLE_WHITE_PONY] = true,
	[CollectibleType.COLLECTIBLE_D100] = true,
	[CollectibleType.COLLECTIBLE_D4] = true,
	[CollectibleType.COLLECTIBLE_MEGA_BLAST] = true,
	[CollectibleType.COLLECTIBLE_DELIRIOUS] = true,
	[CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR] = true,
	[CollectibleType.COLLECTIBLE_SULFUR] = true,
	[CollectibleType.COLLECTIBLE_WAVY_CAP] = true,
	[CollectibleType.COLLECTIBLE_SCOOPER] = true,
	[CollectibleType.COLLECTIBLE_LARYNX] = true,
	[CollectibleType.COLLECTIBLE_MEGA_MUSH] = true,
	[CollectibleType.COLLECTIBLE_ESAU_JR] = true,
	[CollectibleType.COLLECTIBLE_BERSERK] = true,
	[CollectibleType.COLLECTIBLE_LEMEGETON] = true
}
local pillCostumes = {
	[PillEffect.PILLEFFECT_I_FOUND_PILLS] = NullItemID.ID_I_FOUND_PILLS,
	[PillEffect.PILLEFFECT_PUBERTY] = NullItemID.ID_PUBERTY,
	[PillEffect.PILLEFFECT_WIZARD] = NullItemID.ID_WIZARD,
}
local playerFormToNullItemID = {
	[PlayerForm.PLAYERFORM_GUPPY] = NullItemID.ID_GUPPY,
	[PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = NullItemID.ID_LORD_OF_THE_FLIES,
	[PlayerForm.PLAYERFORM_MUSHROOM] = NullItemID.ID_MUSHROOM,
	[PlayerForm.PLAYERFORM_ANGEL] = NullItemID.ID_ANGEL,
	[PlayerForm.PLAYERFORM_BOB] = NullItemID.ID_BOB,
	[PlayerForm.PLAYERFORM_DRUGS] = NullItemID.ID_DRUGS,
	[PlayerForm.PLAYERFORM_MOM] = NullItemID.ID_MOM,
	[PlayerForm.PLAYERFORM_BABY] = NullItemID.ID_BABY,
	[PlayerForm.PLAYERFORM_EVIL_ANGEL] = NullItemID.ID_EVIL_ANGEL,
	[PlayerForm.PLAYERFORM_POOP] = NullItemID.ID_POOP,
	[PlayerForm.PLAYERFORM_BOOK_WORM] = NullItemID.ID_BOOKWORM,
	[PlayerForm.PLAYERFORM_ADULTHOOD] = NullItemID.ID_ADULTHOOD,
	[PlayerForm.PLAYERFORM_SPIDERBABY] = NullItemID.ID_SPIDERBABY,
}
local supportedNullCostumes = {
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_azazel.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_balloftar.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_brimstone.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_brimstone2.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_delirious.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_libra.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_lostcurse.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_pog.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_whoreofbabylon.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_berserk.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_terra.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_toothandnail.anm2")] = true,
	[Isaac.GetCostumeIdByPath(baseCostumePath.."eevee_uranus.anm2")] = true,
	[Isaac.GetCostumeIdByPath("the/specialist_isaac.anm2")] = true, --One day...specialist Eevee dance.
}

--------------
--  LOCALS  --
--------------

function ccp:AddCustomNullCostume(player, nullID, costumePath)
	if nullID ~= nil and nullID ~= -1 then
		player:AddNullCostume(nullID)
	else
		error("Custom Costume Error: itemCostume going to path "..costumePath.." is nil")
	end
end

function ccp:CanRemoveCollectibleCostume(player, itemID)
	if (player:HasCollectible(itemID) or player:GetEffects():HasCollectibleEffect(itemID)) 
	and not activeItemCostumes[itemID]
	then
		return true
	else
		return false
	end
end

local function RemoveBlacklistedCostumes(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()

	--Item Costumes
	if playerItemCostumeWhitelist[playerType] then
		for itemID, _ in pairs(playerItemCostumeWhitelist[playerType]) do
			local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
			if ccp:CanRemoveCollectibleCostume(player, itemID)
			and playerItemCostumeWhitelist[playerType][itemID] == false then
				player:RemoveCostume(itemCostume, false)
			end
		end
	end

	--Active Items
	for itemID, boolean in pairs(activeItemCostumes) do
		if playerEffects:HasCollectibleEffect(itemID)
		and playerItemCostumeWhitelist[playerType][itemID] == false
		then
			local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
			player:RemoveCostume(itemCostume)
		end
		if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_D4) then
			ccp:ReAddBaseCosutme(player)
		end
	end
	
	--Null Costumes
	for nullItemID = 1, NullItemID.NUM_NULLITEMS do
		if playerEffects:HasNullEffect(nullItemID)
		and playerNullItemCostumeWhitelist[playerType][nullItemID] == false
		then
			player:TryRemoveNullCostume(nullItemID)
		end
	end
	
	--Trinkets
	for trinketID, _ in pairs(trinketCostumeList) do
		if ((trinketID == TrinketType.TRINKET_TICK
		and player:HasTrinket(trinketID))
		or playerEffects:HasTrinketEffect(trinketID))
		and data.CCP.TrinketActive[trinketID]
		and playerTrinketCostumeWhitelist[playerType][trinketID] == true then
			local trinketCostume = Isaac.GetItemConfig():GetTrinket(trinketID)
			player:RemoveCostume(trinketCostume)
		end
	end
	
	--Transformations
	for playerForm, nullItemID in pairs(playerFormToNullItemID) do
		if player:HasPlayerForm(playerForm)
		and playerNullItemCostumeWhitelist[playerType][nullItemID] == false
		then
			player:TryRemoveNullCostume(nullItemID)
		end
	end
	
	--Wavy Cap
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_WAVY_CAP) then
		local WavyCaps = {
			NullItemID.ID_WAVY_CAP_1,
			NullItemID.ID_WAVY_CAP_2,
			NullItemID.ID_WAVY_CAP_3,
		}
		for i = 1, #WavyCaps do
			player:TryRemoveNullCostume(WavyCaps[i])
		end
	end
	
	--Double Glass Eye
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GLASS_EYE) >= 2 then
		if playerItemCostumeWhitelist[CollectibleType.COLLECTIBLE_GLASS_EYE] == false then
			player:TryRemoveNullCostume(126)
		end
	end
end

local ItemToCostume = {
	[CollectibleType.COLLECTIBLE_BALL_OF_TAR] = "balloftar", --1
	[CollectibleType.COLLECTIBLE_LIBRA] = "libra", --1
	[CollectibleType.COLLECTIBLE_TERRA] = "terra", --2
	[CollectibleType.COLLECTIBLE_URANUS] = "uranus", --2
	[CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON] = "whoreofbabylon", --24
	[CollectibleType.COLLECTIBLE_BRIMSTONE] = "brimstone", --24
	[CollectibleType.COLLECTIBLE_TOOTH_AND_NAIL] = "toothandnail", --52
}

local function AddItemSpecificCostumes(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local basePath = "gfx/characters/costume_"..EEVEEMOD.PlayerTypeToString[playerType].."_"
	for itemID, costumePath in pairs(ItemToCostume) do
		
		local itemCostume = Isaac.GetCostumeIdByPath(basePath..ItemToCostume[itemID]..".anm2")
		if ccp:CanRemoveCollectibleCostume(player, itemID) then
			ccp:AddCustomNullCostume(player, itemCostume, basePath..ItemToCostume[itemID]..".anm2")
		else
			player:TryRemoveNullCostume(itemCostume)
		end
	end		
		
	--Azazel's Stump
	local azyPath = basePath.."azazel.anm2"
	local azyCustomCostume = Isaac.GetCostumeIdByPath(azyPath)
	local azyTrinketCostume = Isaac.GetItemConfig():GetTrinket(TrinketType.TRINKET_AZAZELS_STUMP)
	if playerEffects:HasTrinketEffect(TrinketType.TRINKET_AZAZELS_STUMP) then
		ccp:AddCustomNullCostume(player, azyCustomCostume, azyPath)
		player:AddCostume(azyTrinketCostume, false)
	else
		player:TryRemoveNullCostume(azyCustomCostume)
		player:RemoveCostume(azyTrinketCostume, false)
	end
	
	--Delirious
	local deliPath = basePath.."delirious.anm2"
	local deliCustomCostume = Isaac.GetCostumeIdByPath(deliPath)
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_DELIRIOUS) then
		ccp:AddCustomNullCostume(player, deliCustomCostume, deliPath)
	else
		player:TryRemoveNullCostume(deliCustomCostume)
	end
	
	--Berserk
	local berserkPath = basePath.."berserk.anm2"
	local berserkCustomCostume = Isaac.GetCostumeIdByPath(berserkPath)
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
		ccp:AddCustomNullCostume(player, berserkCustomCostume, berserkPath)
	else
		player:TryRemoveNullCostume(berserkCustomCostume)
	end

	--Brimstone 2 (Might make cool horns later)
	local brim2Path = basePath.."brimstone2.anm2"
	local brim2CustomCostume = Isaac.GetCostumeIdByPath(brim2Path)
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) >= 2 then
		ccp:AddCustomNullCostume(player, brim2CustomCostume, brim2Path)
	else
		player:TryRemoveNullCostume(brim2CustomCostume)
	end
	
	--Lost Curse
	local cursePath = basePath.."lostcurse.anm2"
	local curseCustomCostume = Isaac.GetCostumeIdByPath(cursePath)
	if playerEffects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
		ccp:AddCustomNullCostume(player, curseCustomCostume, cursePath)
	else
		player:TryRemoveNullCostume(curseCustomCostume)
	end
end

local function RemoveModdedCostumes(player)
	local ModdedNullCostumeIDStart = 132 --Apparently there are null costumes after NullItemID.NUM_NULLITEMS, that ends at 131.
	local ModdedCollectibleCostumeIDStart = CollectibleType.NUM_COLLECTIBLES + 1
	local MaxNullItemIDs = Isaac.GetItemConfig():GetNullItems().Size
	local MaxCollectibles = Isaac.GetItemConfig():GetCollectibles().Size
	for id = ModdedNullCostumeIDStart, MaxNullItemIDs do
		if supportedNullCostumes[id] == nil then
			player:TryRemoveNullCostume(id)
		end
	end
	for id = ModdedCollectibleCostumeIDStart, MaxCollectibles do
		local itemConfigID = Isaac.GetItemConfig():GetCollectible(id)
		if player:HasCollectible(id) and ItemConfig.Config.ShouldAddCostumeOnPickup(itemConfigID) then
			player:RemoveCostume(itemConfigID)
		end
	end
end

local function InitiateItemWhitelist(playerType)
	playerItemCostumeWhitelist[playerType] = {}
	for itemID, boolean in pairs(costumeList) do
		playerItemCostumeWhitelist[playerType][itemID] = boolean
	end
end

local function InitiateNullItemWhitelist(playerType)
	playerNullItemCostumeWhitelist[playerType] = {}
	for nullItemID, boolean in pairs(nullEffectsList) do
		playerNullItemCostumeWhitelist[playerType][nullItemID] = boolean
	end
end

local function InitiateTrinketWhitelist(playerType)
	playerTrinketCostumeWhitelist[playerType] = {}
	for trinketID, boolean in pairs(trinketCostumeList) do
		playerTrinketCostumeWhitelist[playerType][trinketID] = boolean
	end
end

local function InitiateWhitelists()
	for playerType, boolean in pairs(playerToProtect) do
		InitiateItemWhitelist(playerType)
		InitiateNullItemWhitelist(playerType)
		InitiateTrinketWhitelist(playerType)
	end
end

------------------
--  MAIN STUFF  --
------------------

function ccp:UpdatePlayerSpritesheet(player, spritesheetPath)
	local playerType = player:GetPlayerType()
	local sprite = player:GetSprite()
	local spritesheetPath = spritesheetPath or playerSpritesheet[playerType]..EEVEEMOD.API.SkinColor(player)..".png"

	sprite:ReplaceSpritesheet(12, spritesheetPath)
	sprite:ReplaceSpritesheet(4, spritesheetPath)
	sprite:ReplaceSpritesheet(2, spritesheetPath)
	sprite:ReplaceSpritesheet(1, spritesheetPath)
	
	sprite:LoadGraphics()
end

function ccp:ReAddBaseCosutme(player)
	local playerType = player:GetPlayerType()
	
	if playerToProtect[playerType] == true
	and playerCostume[playerType] ~= nil then
		player:AddNullCostume(Isaac.GetCostumeIdByPath(playerCostume[playerType]..".anm2"))
	end
end

function ccp:MainResetPlayerCostumes(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	
	if playerToProtect[playerType] == true
	and data.CCP
	and not player:IsCoopGhost()
	then		
		RemoveBlacklistedCostumes(player)
		AddItemSpecificCostumes(player)
		RemoveModdedCostumes(player)
	end
end

function ccp:ResetPlayerCostumes(player)
	local data = player:GetData()
	local playerEffects = player:GetEffects()
	
	for playerType, _ in pairs(data.CCP.HasCostumeInitialized) do --Triggers once, just used to grab the playerType inside their player data
		local basePath = playerCostume[playerType]
		
		for itemID, costumePath in pairs(ItemToCostume) do
			local itemCostume = Isaac.GetCostumeIdByPath(basePath.."_"..ItemToCostume[itemID]..".anm2")
			player:TryRemoveNullCostume(itemCostume)
		end
		
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(basePath..".anm2"))
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(basePath.."azazel.anm2"))
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(basePath.."delirious.anm2"))
	
		--Item Costumes
		for itemID, _ in pairs(playerItemCostumeWhitelist[playerType]) do
			local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
			if ccp:CanRemoveCollectibleCostume(player, itemID)
			and playerItemCostumeWhitelist[playerType][itemID] == false then
				player:AddCostume(itemCostume, false)
			end
		end
		
		--Active Items
		for itemID, boolean in pairs(activeItemCostumes) do
			if playerEffects:HasCollectibleEffect(itemID)
			and playerItemCostumeWhitelist[playerType][itemID] == false
			then
				local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
				player:AddCostume(itemCostume)
			end
		end
		
		--Null Costumes
		for nullItemID = 1, NullItemID.NUM_NULLITEMS do
			if playerEffects:HasNullEffect(nullItemID)
			and playerNullItemCostumeWhitelist[playerType][nullItemID] == false
			and not nullEffectsList[nullItemID] then
				player:AddNullCostume(nullItemID)
			end
		end
		
		--Trinkets
		for trinketID, _ in pairs(trinketCostumeList) do
			if ((trinketID == TrinketType.TRINKET_TICK
			and player:HasTrinket(trinketID))
			or playerEffects:HasTrinketEffect(trinketID))
			and data.CCP.TrinketActive[trinketID]
			and playerTrinketCostumeWhitelist[playerType][trinketID] == false then
				local trinketCostume = Isaac.GetItemConfig():GetTrinket(trinketID)
				player:AddCostume(trinketCostume)
			end
		end
		
		--Transformations
		for playerForm, nullItemID in pairs(playerFormToNullItemID) do
			if player:HasPlayerForm(playerForm)
			and playerNullItemCostumeWhitelist[playerType][nullItemID] == false
			then
				player:AddNullCostume(nullItemID)
			end
		end
	end
end

function ccp:InitPlayerCostume(player)
  local data = player:GetData()
  local playerType = player:GetPlayerType()
	
	if playerToProtect[playerType] == true
	and data.CCP
	and not player:IsCoopGhost() then
	
		if not data.CCP.HasCostumeInitialized then

			InitiateWhitelists()
			ccp:MainResetPlayerCostumes(player)
			data.CCP.NumCollectibles = player:GetCollectibleCount()
			data.CCP.NumTemporaryEffects = player:GetEffects():GetEffectsList().Size
			data.CCP.QueueCostumeRemove = {}
			data.CCP.TrinketActive = {}
			data.CCP.HasCostumeInitialized = {
				[playerType] = true
			}
			if player:HasCollectible(CollectibleType.COLLECTIBLE_GNAWED_LEAF) then
				data.CCP.GnawedStatueActive = false
				data.CCP.GnawedStatueTimer = 0
			end
		end
	end
end

function ccp:DeinitPlayerCostume(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	
	if data.CCP
	and data.CCP.HasCostumeInitialized --Has the protection data
	and not data.CCP.HasCostumeInitialized[playerType] --For other characters given protection in their own copy of the library
	and not playerToProtect[playerType] --PlayerType isn't in local protection system
	then
		ccp:ResetPlayerCostumes(player)
		data.CCP = nil
	end
end

function ccp:MiscCostumeResets(player)
	local data = player:GetData()
	local playerEffects = player:GetEffects()
	
	if data.CCP.NumCollectibles
	and data.CCP.NumCollectibles ~= player:GetCollectibleCount()
	then
		data.CCP.NumCollectibles = player:GetCollectibleCount()
		ccp:MainResetPlayerCostumes(player)
	end
	
	if data.CCP.NumTemporaryEffects
	and data.CCP.NumTemporaryEffects ~= player:GetEffects():GetEffectsList().Size
	and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HEMOPTYSIS)
	then
		data.CCP.NumTemporaryEffects = player:GetEffects():GetEffectsList().Size
		ccp:MainResetPlayerCostumes(player)
	end
	
	for trinketID, _ in pairs(trinketCostumeList) do
		if ((trinketID == TrinketType.TRINKET_TICK
		and player:HasTrinket(trinketID))
		or playerEffects:HasTrinketEffect(trinketID))
		then
			if not data.CCP.TrinketActive[trinketID] then
				if not playerTrinketCostumeWhitelist[playerType][trinketID] then
					local trinketCostume = Isaac.GetItemConfig():GetTrinket(trinketID)
					player:RemoveCostume(trinketCostume)
				end	
				data.CCP.TrinketActive[trinketID] = true
			end
		elseif (trinketID == TrinketType.TRINKET_TICK
		and not player:HasTrinket(trinketID))
		or not playerEffects:HasTrinketEffect(trinketID)
		then
			if data.CCP.TrinketActive[trinketID] then
				data.CCP.TrinketActive[trinketID] = false
			end
		end
	end
end

-----------------------
--  da spooky ghost  --
-----------------------

function ccp:CanAstralProjectionTrigger(player)
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local room = EEVEEMOD.game:GetRoom()
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) then
		data.CCP.AP_CanTrigger = not room:IsClear()
	end
end

function ccp:AstralProjectionUpdate(player)
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local hasProjectionEffect = playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)
	
	if data.CCP.AP_CanTrigger then
		if hasProjectionEffect then
			if EEVEEMOD.API.RoomClearTriggered(player) and not data.CCP.LostCurse then
				data.CCP.DelaySpritesheetChange = ""
			end
		end
	else
		if data.CCP.AP_Disabled then
			data.CCP.DelaySpritesheetChange = ""
			data.CCP.AP_Disabled = nil
		end
	end
end

function ccp:AstralProjectionOnHit(ent, amount, flags, source, countdown)
	local player = ent:ToPlayer()
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local hasProjectionEffect = playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)

	if playerToProtect[playerType] == true
	and data.CCP
	and data.CCP.AP_CanTrigger then
		if not hasProjectionEffect and not data.CCP.AP_Disabled then
			data.CCP.DelaySpritesheetChange = baseCostumeSuffixPath..EEVEEMOD.PlayerTypeToString[playerType].."/character_012_thelost.png"
			data.CCP.AP_Disabled = true
		elseif hasProjectionEffect and data.CCP.AP_Disabled then
			data.CCP.DelaySpritesheetChange = ""
		end
	end
end

function ccp:OnLostCurse(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local hasLostCurse = playerEffects:HasNullEffect(NullItemID.ID_LOST_CURSE)
	
	if hasLostCurse and not data.CCP.LostCurse then
		data.CCP.DelaySpritesheetChange = baseCostumeSuffixPath..EEVEEMOD.PlayerTypeToString[playerType].."/character_012_thelost.png"
		data.CCP.LostCurse = true
	elseif not hasLostCurse and data.CCP.LostCurse then
		data.CCP.DelaySpritesheetChange = ""
		data.CCP.LostCurse = nil
	end
end

function ccp:OnSpiritShackles(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local isShacklesSoul = playerEffects:HasNullEffect(NullItemID.ID_SPIRIT_SHACKLES_SOUL)
	
	if isShacklesSoul and not data.CCP.ShacklesGhost then
		data.CCP.DelaySpritesheetChange = baseCostumeSuffixPath..EEVEEMOD.PlayerTypeToString[playerType].."/character_018_thesoul.png"
		data.CCP.ShacklesGhost = true
	elseif not isShacklesSoul and data.CCP.ShacklesGhost then
		data.CCP.DelaySpritesheetChange = ""
		data.CCP.ShacklesGhost = nil
	end
end

----------------------------------------------
--  RESETTING COSTUME ON SPECIFIC TRIGGERS  --
----------------------------------------------

function ccp:ResetCostumeOnItem(itemID, rng, player, useFlags, activeSlot, customVarData)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local playerUsedItem = activeItemCostumes[itemID] == true

	if playerToProtect[playerType]
	and data.CCP
	and data.CCP.HasCostumeInitialized
	and playerUsedItem then
		if playerItemCostumeWhitelist[playerType]
		and (playerItemCostumeWhitelist[playerType][itemID] == false
		or itemID == CollectibleType.COLLECTIBLE_LEMEGETON)
		then
			data.CCP.DelayCostumeReset = true
		end
		
		if itemID == CollectibleType.COLLECTIBLE_D4
		or itemID == CollectibleType.COLLECTIBLE_D100 then
			data.CCP.DelayRunReroll = true
		end
	end

	return false
end

function ccp:ResetCostumeOnPill(pillID, player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local playerUsedPill = pillCostumes[pillID] ~= nil

	if playerToProtect[playerType]
	and data.CCP
	and data.CCP.HasCostumeInitialized
	and playerUsedPill
	and playerNullItemCostumeWhitelist[playerType]
	and playerNullItemCostumeWhitelist[playerType][pillCostumes[pillID]] == false
	then
		data.CCP.DelayPillCostumeRemove = pillID
	end
end

function ccp:ReapplyHairOnCoopRevive(player)
	local data = player:GetData()
	if player:IsCoopGhost() and not data.CCP.WaitOnCoopRevive then
		data.CCP.WaitOnCoopRevive = true
	elseif not player:IsCoopGhost() and data.CCP.WaitOnCoopRevive then
		ccp:ReAddBaseCosutme(player)
		data.CCP.WaitOnCoopRevive = false
	end
end

function ccp:RestoreCostumeInMineshaft(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local room = EEVEEMOD.game:GetRoom()
	
	if playerToProtect[playerType] == true and data.CCP then
		if room:HasCurseMist() then
			if not data.MineshaftCostumeHair
			and not data.MineshaftCostumeBody then
				data.MineshaftCostumeHair = Sprite()
				data.MineshaftCostumeHair:Load("gfx/render_eevee_mineshaft_hair.anm2")
				data.MineshaftCostumeHair:Play("HeadUp", true)
				data.MineshaftCostumeBody = Sprite()
				data.MineshaftCostumeBody:Load("gfx/render_eevee_mineshaft_body.anm2")
				data.MineshaftCostumeBody:Play("WalkUp", true)
			else
				local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(player.Position)
				local pSprite = player:GetSprite()

				data.MineshaftCostumeHair:SetFrame(pSprite:GetOverlayAnimation(), pSprite:GetOverlayFrame())
				data.MineshaftCostumeHair.Color = player:GetSprite().Color
				data.MineshaftCostumeBody:SetFrame(pSprite:GetAnimation(), pSprite:GetFrame())
				data.MineshaftCostumeBody.Color = player:GetSprite().Color
				if EEVEEMOD.API.IsPlayerWalking(player) then
					data.MineshaftCostumeHair:Render(screenpos - EEVEEMOD.game.ScreenShakeOffset, Vector.Zero, Vector.Zero)
					data.MineshaftCostumeBody:Render(screenpos - EEVEEMOD.game.ScreenShakeOffset, Vector.Zero, Vector.Zero)
				end
			end
		elseif data.MineshaftCostumeHair
			and data.MineshaftCostumeBody then
			data.MineshaftCostumeHair:Stop()
			data.MineshaftCostumeBody:Stop()
		end
	end
end

function ccp:StopNewRoomCostumes(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TAURUS) then
		table.insert(data.CCP.QueueCostumeRemove, CollectibleType.COLLECTIBLE_TAURUS)
	end
end

function ccp:ResetOnMissingNoNewFloor(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_NO) then
		ccp:MainResetPlayerCostumes(player)
		ccp:ReAddBaseCosutme(player)
	end
end

function ccp:ModelingClay(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local itemID = player:GetModelingClayEffect()
	
	if data.CCP.CheckForModelingClay then
		if player:HasTrinket(TrinketType.TRINKET_MODELING_CLAY)
		and itemID ~= 0
		and not playerItemCostumeWhitelist[playerType][itemID]
		then
			table.insert(data.CCP.QueueCostumeRemove, itemID)
		end
		data.CCP.CheckForModelingClay = false
	end
end

function ccp:DelayInCostumeReset(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if data.CCP.DelayCostumeReset then
		ccp:MainResetPlayerCostumes(player)
		data.CCP.DelayCostumeReset = nil
	end
	
	if data.CCP.DelayRunReroll then
		ccp:MainResetPlayerCostumes(player)
		ccp:ReAddBaseCosutme(player)
		data.CCP.DelayRunReroll = nil
	end
	
	if data.CCP.DelayPillCostumeRemove then
		local pillEffect = data.CCP.DelayPillCostumeRemove

		if pillEffect == PillEffect.PILLEFFECT_I_FOUND_PILLS then
			player:TryRemoveNullCostume(NullItemID.ID_I_FOUND_PILLS)
			player:TryRemoveNullCostume(NullItemID.ID_I_FOUND_HORSE_PILLS)
		elseif pillEffect == PillEffect.PILLEFFECT_PUBERTY then
			player:TryRemoveNullCostume(NullItemID.ID_PUBERTY)
			player:TryRemoveNullCostume(NullItemID.ID_HORSE_PUBERTY)
		elseif pillEffect == PillEffect.PILLEFFECT_WIZARD then
			player:TryRemoveNullCostume(NullItemID.ID_WIZARD)
		end
		data.CCP.DelayPillCostumeRemove = nil
	end
	
	if data.CCP.QueueCostumeRemove and data.CCP.QueueCostumeRemove[1] ~= nil then
		while #data.CCP.QueueCostumeRemove > 0 do
			local itemCostume = Isaac.GetItemConfig():GetCollectible(data.CCP.QueueCostumeRemove[1])
			player:RemoveCostume(itemCostume)
			table.remove(data.CCP.QueueCostumeRemove, 1)
		end
	end
	
	if data.CCP.DelaySpritesheetChange then
		if data.CCP.DelaySpritesheetChange == "" then
			ccp:UpdatePlayerSpritesheet(player)
		else
			ccp:UpdatePlayerSpritesheet(player, data.CCP.DelaySpritesheetChange)
		end
		data.CCP.DelaySpritesheetChange = nil
	end
end

----------------------------
--  INITIATING CALLBACKS  --
----------------------------

function ccp:OnPlayerInit(player)
	ccp:InitPlayerCostume(player)
end

function ccp:OnPeffectUpdate(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	
	ccp:DeinitPlayerCostume(player)
	
	if playerToProtect[playerType] == true and data.CCP then
		ccp:MiscCostumeResets(player)
		ccp:DelayInCostumeReset(player)
		ccp:ReapplyHairOnCoopRevive(player)
		ccp:ModelingClay(player)
		ccp:AstralProjectionUpdate(player)
		ccp:OnLostCurse(player)
		ccp:OnSpiritShackles(player)
	end
end

function ccp:OnNewRoom(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local room = EEVEEMOD.game:GetRoom()

	if playerToProtect[playerType] == true and data.CCP then
		ccp:StopNewRoomCostumes(player)
		ccp:CanAstralProjectionTrigger(player)
		if player:HasTrinket(TrinketType.TRINKET_MODELING_CLAY) then
			local data = player:GetData()
			data.CCP.CheckForModelingClay = true
		end
	end
end
	
function ccp:OnNewLevel(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if playerToProtect[playerType] == true and data.CCP then
		ccp:ResetOnMissingNoNewFloor(player)
	end
end

InitiateWhitelists()

return ccp
