local ccp = {}
local vee = require("src_eevee.veeHelper")

local baseCostumePath = "gfx/characters/"
local baseCharacterPath = "gfx/characters/costumes/"
local baseCostumeSuffixPath = "gfx/characters/costumes_"
local Outfit = {
	NONE = "",
	CHRISTMAS = "christmas"
}
local curOutfit = Outfit.NONE
local NUM_NULL_COSTUMES = 43

---@type table<PlayerType, boolean>
local playerToProtect = {
	[EEVEEMOD.PlayerType.EEVEE] = true,
}
---@type table<PlayerType, string>
local playerCostume = {
	[EEVEEMOD.PlayerType.EEVEE] = "gfx/characters/costume_eevee",
}
---@type table<PlayerType, string>
local playerSpritesheet = {
	[EEVEEMOD.PlayerType.EEVEE] = baseCharacterPath .. "character_eevee",
}
---@type table<CollectibleType, boolean>
local costumeList = {
	[CollectibleType.COLLECTIBLE_SAD_ONION] = false,
	[CollectibleType.COLLECTIBLE_INNER_EYE] = false,
	[CollectibleType.COLLECTIBLE_SPOON_BENDER] = true,
	[CollectibleType.COLLECTIBLE_CRICKETS_HEAD] = true,
	[CollectibleType.COLLECTIBLE_MY_REFLECTION] = true,
	[CollectibleType.COLLECTIBLE_NUMBER_ONE] = true,
	[CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR] = true,
	[CollectibleType.COLLECTIBLE_SKATOLE] = false,
	[CollectibleType.COLLECTIBLE_VIRUS] = false,
	[CollectibleType.COLLECTIBLE_ROID_RAGE] = true,
	[CollectibleType.COLLECTIBLE_HEART] = true,
	[CollectibleType.COLLECTIBLE_SKELETON_KEY] = true,
	[CollectibleType.COLLECTIBLE_BOOM] = false,
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
	[CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = false,
	[CollectibleType.COLLECTIBLE_STEVEN] = false,
	[CollectibleType.COLLECTIBLE_PENTAGRAM] = true,
	[CollectibleType.COLLECTIBLE_DR_FETUS] = true,
	[CollectibleType.COLLECTIBLE_MAGNETO] = true,
	[CollectibleType.COLLECTIBLE_MOMS_EYE] = false,
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = true,
	[CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = true,
	[CollectibleType.COLLECTIBLE_BATTERY] = true,
	[CollectibleType.COLLECTIBLE_STEAM_SALE] = true,
	[CollectibleType.COLLECTIBLE_TECHNOLOGY] = true,
	[CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = true,
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
	[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = true,
	[CollectibleType.COLLECTIBLE_SPIDER_BITE] = true,
	[CollectibleType.COLLECTIBLE_SMALL_ROCK] = false,
	[CollectibleType.COLLECTIBLE_SPELUNKER_HAT] = true,
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
	[CollectibleType.COLLECTIBLE_RAZOR_BLADE] = false,
	[CollectibleType.COLLECTIBLE_BUCKET_OF_LARD] = true,
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
	[CollectibleType.COLLECTIBLE_PYRO] = false,
	[CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = true,
	[CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = true,
	[CollectibleType.COLLECTIBLE_MEAT] = true,
	[CollectibleType.COLLECTIBLE_MAGIC_8_BALL] = true,
	[CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE] = true,
	[CollectibleType.COLLECTIBLE_SQUEEZY] = false,
	[CollectibleType.COLLECTIBLE_JESUS_JUICE] = true,
	[CollectibleType.COLLECTIBLE_BOX] = true,
	[CollectibleType.COLLECTIBLE_MOMS_KEY] = true,
	[CollectibleType.COLLECTIBLE_MOMS_EYESHADOW] = true,
	[CollectibleType.COLLECTIBLE_IRON_BAR] = true,
	[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = true,
	[CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE] = true,
	[CollectibleType.COLLECTIBLE_FANNY_PACK] = true,
	[CollectibleType.COLLECTIBLE_SHARP_PLUG] = false,
	[CollectibleType.COLLECTIBLE_GUILLOTINE] = true,
	[CollectibleType.COLLECTIBLE_CHAMPION_BELT] = true,
	[CollectibleType.COLLECTIBLE_BUTT_BOMBS] = false,
	[CollectibleType.COLLECTIBLE_GNAWED_LEAF] = false,
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
	[CollectibleType.COLLECTIBLE_BLACK_LOTUS] = true,
	[CollectibleType.COLLECTIBLE_PIGGY_BANK] = true,
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
	[CollectibleType.COLLECTIBLE_BOGO_BOMBS] = true,
	[CollectibleType.COLLECTIBLE_STARTER_DECK] = true,
	[CollectibleType.COLLECTIBLE_LITTLE_BAGGY] = true,
	[CollectibleType.COLLECTIBLE_MAGIC_SCAB] = false,
	[CollectibleType.COLLECTIBLE_BLOOD_CLOT] = false,
	[CollectibleType.COLLECTIBLE_SCREW] = false,
	[CollectibleType.COLLECTIBLE_HOT_BOMBS] = true,
	[CollectibleType.COLLECTIBLE_FIRE_MIND] = false,
	[CollectibleType.COLLECTIBLE_MISSING_NO] = true,
	[CollectibleType.COLLECTIBLE_DARK_MATTER] = true,
	[CollectibleType.COLLECTIBLE_BLACK_CANDLE] = true,
	[CollectibleType.COLLECTIBLE_PROPTOSIS] = false,
	[CollectibleType.COLLECTIBLE_MISSING_PAGE_2] = true,
	[CollectibleType.COLLECTIBLE_ROBO_BABY_2] = true,
	[CollectibleType.COLLECTIBLE_TAURUS] = true,
	[CollectibleType.COLLECTIBLE_ARIES] = true,
	[CollectibleType.COLLECTIBLE_CANCER] = true,
	[CollectibleType.COLLECTIBLE_LEO] = false,
	[CollectibleType.COLLECTIBLE_VIRGO] = true,
	[CollectibleType.COLLECTIBLE_LIBRA] = true,
	[CollectibleType.COLLECTIBLE_SCORPIO] = true,
	[CollectibleType.COLLECTIBLE_SAGITTARIUS] = false,
	[CollectibleType.COLLECTIBLE_CAPRICORN] = false,
	[CollectibleType.COLLECTIBLE_AQUARIUS] = true,
	[CollectibleType.COLLECTIBLE_PISCES] = true,
	[CollectibleType.COLLECTIBLE_EVES_MASCARA] = true,
	[CollectibleType.COLLECTIBLE_MAGGYS_BOW] = true,
	[CollectibleType.COLLECTIBLE_HOLY_MANTLE] = true,
	[CollectibleType.COLLECTIBLE_THUNDER_THIGHS] = true,
	[CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR] = true,
	[CollectibleType.COLLECTIBLE_CURSED_EYE] = true,
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
	[CollectibleType.COLLECTIBLE_BOOMERANG] = false,
	[CollectibleType.COLLECTIBLE_SAFETY_PIN] = false,
	[CollectibleType.COLLECTIBLE_CAFFEINE_PILL] = true,
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
	[CollectibleType.COLLECTIBLE_BURSTING_SACK] = true,
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
	[CollectibleType.COLLECTIBLE_GODS_FLESH] = true,
	[CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = false,
	[CollectibleType.COLLECTIBLE_CHAOS] = true,
	[CollectibleType.COLLECTIBLE_PURITY] = true,
	[CollectibleType.COLLECTIBLE_ATHAME] = false,
	[CollectibleType.COLLECTIBLE_EMPTY_VESSEL] = true,
	[CollectibleType.COLLECTIBLE_EVIL_EYE] = true,
	[CollectibleType.COLLECTIBLE_LUSTY_BLOOD] = true,
	[CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION] = true,
	[CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION] = true,
	[CollectibleType.COLLECTIBLE_MORE_OPTIONS] = true,
	[CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = true,
	[CollectibleType.COLLECTIBLE_FRUIT_CAKE] = true,
	[CollectibleType.COLLECTIBLE_BLACK_POWDER] = true,
	[CollectibleType.COLLECTIBLE_SACK_HEAD] = true,
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
	[CollectibleType.COLLECTIBLE_DOG_TOOTH] = true,
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
	[CollectibleType.COLLECTIBLE_SINUS_INFECTION] = true,
	[CollectibleType.COLLECTIBLE_GLAUCOMA] = true,
	[CollectibleType.COLLECTIBLE_PARASITOID] = false,
	[CollectibleType.COLLECTIBLE_EYE_OF_BELIAL] = true,
	[CollectibleType.COLLECTIBLE_SULFURIC_ACID] = false,
	[CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE] = true,
	[CollectibleType.COLLECTIBLE_ANALOG_STICK] = false,
	[CollectibleType.COLLECTIBLE_CONTAGION] = false,
	[CollectibleType.COLLECTIBLE_METRONOME] = false,
	[CollectibleType.COLLECTIBLE_JACOBS_LADDER] = true,
	[CollectibleType.COLLECTIBLE_GHOST_PEPPER] = true,
	[CollectibleType.COLLECTIBLE_EUTHANASIA] = true,
	[CollectibleType.COLLECTIBLE_CAMO_UNDIES] = true,
	[CollectibleType.COLLECTIBLE_DUALITY] = true,
	[CollectibleType.COLLECTIBLE_EUCHARIST] = true,
	[CollectibleType.COLLECTIBLE_GREEDS_GULLET] = false,
	[CollectibleType.COLLECTIBLE_LARGE_ZIT] = false,
	[CollectibleType.COLLECTIBLE_LITTLE_HORN] = true,
	[CollectibleType.COLLECTIBLE_SHARP_STRAW] = true,
	[CollectibleType.COLLECTIBLE_BACKSTABBER] = false,
	[CollectibleType.COLLECTIBLE_DELIRIOUS] = true,
	-- Booster Pack #1
	[CollectibleType.COLLECTIBLE_BOZO] = true,
	[CollectibleType.COLLECTIBLE_BROKEN_MODEM] = true,
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
	[CollectibleType.COLLECTIBLE_SCHOOLBAG] = true,
	-- Booster Pack #5
	[CollectibleType.COLLECTIBLE_BLANKET] = true,
	[CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR] = false,
	[CollectibleType.COLLECTIBLE_FLAT_STONE] = false,
	[CollectibleType.COLLECTIBLE_MARROW] = true,
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
	[CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT] = true,
	[CollectibleType.COLLECTIBLE_IMMACULATE_HEART] = false, --TODO
	[CollectibleType.COLLECTIBLE_MONSTRANCE] = true,
	[CollectibleType.COLLECTIBLE_INTRUDER] = false,
	[CollectibleType.COLLECTIBLE_DIRTY_MIND] = false,
	[CollectibleType.COLLECTIBLE_WAVY_CAP] = true,
	[CollectibleType.COLLECTIBLE_SOL] = true,
	[CollectibleType.COLLECTIBLE_LUNA] = true,
	[CollectibleType.COLLECTIBLE_MERCURIUS] = true,
	[CollectibleType.COLLECTIBLE_VENUS] = true,
	[CollectibleType.COLLECTIBLE_TERRA] = true,
	[CollectibleType.COLLECTIBLE_MARS] = true,
	[CollectibleType.COLLECTIBLE_JUPITER] = true,
	[CollectibleType.COLLECTIBLE_URANUS] = true,
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = true,
	[CollectibleType.COLLECTIBLE_PLUTO] = false,
	[CollectibleType.COLLECTIBLE_VOODOO_HEAD] = true,
	[CollectibleType.COLLECTIBLE_EYE_DROPS] = false,
	[CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION] = true,
	[CollectibleType.COLLECTIBLE_MEMBER_CARD] = true,
	[CollectibleType.COLLECTIBLE_BATTERY_PACK] = false,
	[CollectibleType.COLLECTIBLE_SCOOPER] = false,
	[CollectibleType.COLLECTIBLE_OCULAR_RIFT] = false,
	[CollectibleType.COLLECTIBLE_BIRD_CAGE] = true,
	[CollectibleType.COLLECTIBLE_LARYNX] = true,
	[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = false,
	[CollectibleType.COLLECTIBLE_BIRDS_EYE] = true,
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
	[CollectibleType.COLLECTIBLE_CARD_READING] = true,
	[CollectibleType.COLLECTIBLE_TOOTH_AND_NAIL] = true,
	[CollectibleType.COLLECTIBLE_BINGE_EATER] = true,
	[CollectibleType.COLLECTIBLE_GUPPYS_EYE] = true,
	[CollectibleType.COLLECTIBLE_SAUSAGE] = true,
	[CollectibleType.COLLECTIBLE_OPTIONS] = true,
	[CollectibleType.COLLECTIBLE_CANDY_HEART] = false,
	[CollectibleType.COLLECTIBLE_POUND_OF_FLESH] = false,
	[CollectibleType.COLLECTIBLE_REDEMPTION] = true,
	[CollectibleType.COLLECTIBLE_SPIRIT_SHACKLES] = true,
	[CollectibleType.COLLECTIBLE_CRACKED_ORB] = true,
	[CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION] = true,
	[CollectibleType.COLLECTIBLE_C_SECTION] = true,
	[CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE] = false,
	[CollectibleType.COLLECTIBLE_SOUL_LOCKET] = true,
	[CollectibleType.COLLECTIBLE_INNER_CHILD] = true,
	[CollectibleType.COLLECTIBLE_JELLY_BELLY] = true,
	[CollectibleType.COLLECTIBLE_AZAZELS_RAGE] = true,
	[CollectibleType.COLLECTIBLE_ESAU_JR] = true,
	[CollectibleType.COLLECTIBLE_BERSERK] = true,
	[CollectibleType.COLLECTIBLE_STAPLER] = false,
	[CollectibleType.COLLECTIBLE_LEMEGETON] = false,
	[CollectibleType.COLLECTIBLE_HEMOPTYSIS] = true,
	[CollectibleType.COLLECTIBLE_GLASS_EYE] = true,
	[CollectibleType.COLLECTIBLE_STYE] = false,
	[CollectibleType.COLLECTIBLE_MOMS_RING] = true
}
---@type table<NullItemID, boolean>
local nullEffectsList = {
	[NullItemID.ID_PUBERTY] = false,
	[NullItemID.ID_I_FOUND_PILLS] = true,
	[NullItemID.ID_LORD_OF_THE_FLIES] = true,
	[NullItemID.ID_GUPPY] = true,
	[NullItemID.ID_WIZARD] = true,
	[NullItemID.ID_BLINDFOLD] = true,
	[NullItemID.ID_BLANKFACE] = true,
	[NullItemID.ID_CHRISTMAS] = true,
	[NullItemID.ID_PURITY_GLOW] = true,
	[NullItemID.ID_EMPTY_VESSEL] = true,
	[NullItemID.ID_MUSHROOM] = false,
	[NullItemID.ID_ANGEL] = true,
	[NullItemID.ID_BOB] = false,
	[NullItemID.ID_DRUGS] = false,
	[NullItemID.ID_MOM] = true,
	[NullItemID.ID_BABY] = false,
	[NullItemID.ID_EVIL_ANGEL] = true,
	[NullItemID.ID_POOP] = false,
	[NullItemID.ID_OVERDOSE] = false,
	[NullItemID.ID_IWATA] = false,
	[NullItemID.ID_BOOKWORM] = true,
	[NullItemID.ID_ADULTHOOD] = false,
	[NullItemID.ID_SPIDERBABY] = false, --?
	[NullItemID.ID_BATWING_WINGS] = true,
	[NullItemID.ID_SACRIFICIAL_ALTAR] = false,
	-- Repentance
	[NullItemID.ID_BRIMSTONE2] = true,
	[NullItemID.ID_HOLY_CARD] = true,
	[NullItemID.ID_INTRUDER] = false, --Idk what happens here
	[NullItemID.ID_SOL] = true,
	[NullItemID.ID_IT_HURTS] = false,
	[NullItemID.ID_TOOTH_AND_NAIL] = true,
	[NullItemID.ID_REVERSE_MAGICIAN] = true,
	[NullItemID.ID_REVERSE_EMPRESS] = true,
	[NullItemID.ID_REVERSE_CHARIOT] = true,
	[NullItemID.ID_REVERSE_HANGED_MAN] = true,
	[NullItemID.ID_REVERSE_SUN] = true,
	[NullItemID.ID_REVERSE_CHARIOT_ALT] = true,
	[NullItemID.ID_WAVY_CAP_1] = true,
	[NullItemID.ID_WAVY_CAP_2] = true,
	[NullItemID.ID_WAVY_CAP_3] = true,
	[NullItemID.ID_LUNA] = true,
	[NullItemID.ID_JUPITER_BODY] = true,
	[NullItemID.ID_JUPITER_BODY_ANGEL] = true,
	[NullItemID.ID_JUPITER_BODY_PONY] = true,
	[NullItemID.ID_JUPITER_BODY_WHITEPONY] = true,
	[NullItemID.ID_AZAZELS_RAGE_1] = true,
	[NullItemID.ID_AZAZELS_RAGE_2] = true,
	[NullItemID.ID_AZAZELS_RAGE_3] = true,
	[NullItemID.ID_AZAZELS_RAGE_4] = true,
	[NullItemID.ID_ESAU_JR] = true,
	[NullItemID.ID_SPIRIT_SHACKLES_SOUL] = true,
	[NullItemID.ID_SPIRIT_SHACKLES_DISABLED] = true,
	[NullItemID.ID_LOST_CURSE] = true,
	[NullItemID.ID_I_FOUND_HORSE_PILLS] = true,
	[NullItemID.ID_HORSE_PUBERTY] = false,
	[NullItemID.ID_DOUBLE_GUPPYS_EYE] = true,
	[NullItemID.ID_DOUBLE_GLASS_EYE] = true
}
---@type table<TrinketType, boolean>
local trinketCostumeList = {
	[TrinketType.TRINKET_RED_PATCH] = false,
	[TrinketType.TRINKET_TICK] = false,
	[TrinketType.TRINKET_AZAZELS_STUMP] = true,
}
---@type table<CollectibleType, boolean>
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
	[CollectibleType.COLLECTIBLE_METRONOME] = true,
	[CollectibleType.COLLECTIBLE_SHARP_STRAW] = true,
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
---@type table<PillEffect, NullItemID>
local pillCostumes = {
	[PillEffect.PILLEFFECT_I_FOUND_PILLS] = NullItemID.ID_I_FOUND_PILLS,
	[PillEffect.PILLEFFECT_PUBERTY] = NullItemID.ID_PUBERTY,
	[PillEffect.PILLEFFECT_WIZARD] = NullItemID.ID_WIZARD,
}
---@type table<PlayerForm, NullItemID>
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
---@type string[]
local costumeTypeList = {
	"",
	"_azazel",
	"_balloftar",
	"_brimstone",
	"_brimstone2",
	"_delirious",
	"_libra",
	"_lostcurse",
	"_pog",
	"_whoreofbabylon",
	"_berserk",
	"_terra",
	"_toothandnail",
	"_uranus",
	"_neptunus"
}

--------------
--  LOCALS  --
--------------

---@param player EntityPlayer
---@param nullID NullItemID
---@param costumePath string
function ccp:TryAddNullCostume(player, nullID, costumePath)
	if nullID ~= nil and nullID ~= -1 then
		player:AddNullCostume(nullID)
	else
		error("Custom Costume Error: itemCostume going to path " .. costumePath .. " is nil")
	end
end

---@param player EntityPlayer
---@param itemID CollectibleType
function ccp:CanRemoveCollectibleCostume(player, itemID)
	if (player:HasCollectible(itemID) or player:GetEffects():HasCollectibleEffect(itemID))
		and not activeItemCostumes[itemID]
	then
		return true
	else
		return false
	end
end

---@param player EntityPlayer
local function RemoveBlacklistedCostumes(player)
	local playerEffects = player:GetEffects()
	local data = player:GetData()

	--Item Costumes
	for itemID, _ in pairs(costumeList) do
		local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
		if ccp:CanRemoveCollectibleCostume(player, itemID)
			and not costumeList[itemID] then
			player:RemoveCostume(itemCostume)
		end
	end

	--Active Items
	for itemID, boolean in pairs(activeItemCostumes) do
		if playerEffects:HasCollectibleEffect(itemID)
			and costumeList[itemID] == false
		then
			local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
			player:RemoveCostume(itemCostume)
		end
		if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_D4) then
			ccp:ReapplyBaseCostume(player)
		end
	end

	--Null Costumes
	for nullItemID, boolean in pairs(nullEffectsList) do
		if playerEffects:HasNullEffect(nullItemID)
			and nullEffectsList[nullItemID] == false
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
			and trinketCostumeList[trinketID] == false then
			local trinketCostume = Isaac.GetItemConfig():GetTrinket(trinketID)
			player:RemoveCostume(trinketCostume)
		end
	end

	--Transformations
	for playerForm, nullItemID in pairs(playerFormToNullItemID) do
		if player:HasPlayerForm(playerForm)
			and nullEffectsList[nullItemID] == false
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
		if costumeList[CollectibleType.COLLECTIBLE_GLASS_EYE] == false then
			player:TryRemoveNullCostume(CollectibleType.COLLECTIBLE_GLASS_EYE)
		end
	end
end

local uniqueHairCostumes = {
	[CollectibleType.COLLECTIBLE_BALL_OF_TAR] = "balloftar",
	[CollectibleType.COLLECTIBLE_LIBRA] = "libra",
	[CollectibleType.COLLECTIBLE_TERRA] = "terra",
	[CollectibleType.COLLECTIBLE_URANUS] = "uranus",
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = "neptunus",
	[CollectibleType.COLLECTIBLE_BRIMSTONE] = "brimstone",
}

local editedCostumes = {
	[CollectibleType.COLLECTIBLE_BOOMERANG] = false,
	[CollectibleType.COLLECTIBLE_BELT] = true,
	[CollectibleType.COLLECTIBLE_MOMS_HEELS] = true,
	[CollectibleType.COLLECTIBLE_LUCKY_FOOT] = true,
	[CollectibleType.COLLECTIBLE_BUCKET_OF_LARD] = true,
	[CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = false,
	[CollectibleType.COLLECTIBLE_MOMS_PURSE] = true,
	[CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = true,
	[CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = true,
	[CollectibleType.COLLECTIBLE_GNAWED_LEAF] = false,
	[CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES] = true,
	[CollectibleType.COLLECTIBLE_ANTI_GRAVITY] = true,
	[CollectibleType.COLLECTIBLE_BALL_OF_TAR] = true,
	[CollectibleType.COLLECTIBLE_BLACK_CANDLE] = true,
	[CollectibleType.COLLECTIBLE_CAFFEINE_PILL] = true,
	[CollectibleType.COLLECTIBLE_BLACK_POWDER] = true,
	[CollectibleType.COLLECTIBLE_PJS] = true,
	[CollectibleType.COLLECTIBLE_CAMO_UNDIES] = true,
	[CollectibleType.COLLECTIBLE_TERRA] = true,
	--[CollectibleType.COLLECTIBLE_MARS] = true,
	[CollectibleType.COLLECTIBLE_URANUS] = true,
	--[CollectibleType.COLLECTIBLE_PLUTO] = true,
	[CollectibleType.COLLECTIBLE_BINGE_EATER] = true,
	[CollectibleType.COLLECTIBLE_JELLY_BELLY] = true
}

---@param player EntityPlayer
local function AddItemSpecificCostumes(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local basePath = playerCostume[playerType] .. "_"

	if data.CCP
		and data.CCP.editedCostumesActive
		and data.CCP.uniqueHairCostumesActive then
		for itemID, costumePath in pairs(uniqueHairCostumes) do
			local itemCostume = Isaac.GetCostumeIdByPath(basePath .. costumePath .. ".anm2")

			if player:HasCollectible(itemID) and data.CCP.uniqueHairCostumesActive[itemID] == false then
				data.CCP.uniqueHairCostumesActive[itemID] = true
				--if not vee.GameContinuedOnPlayerInit() then
				ccp:TryAddNullCostume(player, itemCostume, basePath .. costumePath .. ".anm2")
				--end
			elseif not player:HasCollectible(itemID) and data.CCP.uniqueHairCostumesActive[itemID] == true then
				player:TryRemoveNullCostume(itemCostume)
				data.CCP.uniqueHairCostumesActive[itemID] = false
			end
		end

		for itemID, bool in pairs(editedCostumes) do
			if bool == true then
				local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
				local costumePath = itemConfig.Costume.Anm2Path
				costumePath = baseCostumePath .. string.gsub(costumePath, baseCostumePath, "edited_")
				costumePath = string.lower(costumePath)
				local itemCostume = Isaac.GetCostumeIdByPath(costumePath)

				if player:HasCollectible(itemID) and data.CCP.editedCostumesActive[itemID] == false then
					data.CCP.editedCostumesActive[itemID] = true
					--if not vee.GameContinuedOnPlayerInit() then
					ccp:TryAddNullCostume(player, itemCostume, costumePath)
					player:RemoveCostume(itemConfig)
					--end
				elseif not player:HasCollectible(itemID) and data.CCP.editedCostumesActive[itemID] == true then
					player:TryRemoveNullCostume(itemCostume)
					data.CCP.editedCostumesActive[itemID] = false
				end
			end
		end
	end

	--Azazel's Stump
	local azyPath = basePath .. "azazel.anm2"
	local azyCustomCostume = Isaac.GetCostumeIdByPath(azyPath)
	local azyTrinketCostume = Isaac.GetItemConfig():GetTrinket(TrinketType.TRINKET_AZAZELS_STUMP)
	if playerEffects:HasTrinketEffect(TrinketType.TRINKET_AZAZELS_STUMP) then
		ccp:TryAddNullCostume(player, azyCustomCostume, azyPath)
		player:AddCostume(azyTrinketCostume, false)
	else
		player:TryRemoveNullCostume(azyCustomCostume)
		player:RemoveCostume(azyTrinketCostume)
	end

	--Delirious
	local deliPath = basePath .. "delirious.anm2"
	local deliCustomCostume = Isaac.GetCostumeIdByPath(deliPath)
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_DELIRIOUS) then
		ccp:TryAddNullCostume(player, deliCustomCostume, deliPath)
	else
		player:TryRemoveNullCostume(deliCustomCostume)
	end

	--Whore of Babylon
	local babylonPath = basePath .. "whoreofbabylon.anm2"
	local babylonCustomCostume = Isaac.GetCostumeIdByPath(babylonPath)
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
		ccp:TryAddNullCostume(player, babylonCustomCostume, babylonPath)
	else
		player:TryRemoveNullCostume(babylonCustomCostume)
	end

	--Berserk
	local berserkPath = basePath .. "berserk.anm2"
	local berserkCustomCostume = Isaac.GetCostumeIdByPath(berserkPath)
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
		ccp:TryAddNullCostume(player, berserkCustomCostume, berserkPath)
	else
		player:TryRemoveNullCostume(berserkCustomCostume)
	end

	--Brimstone 2
	local brim2Path = basePath .. "brimstone2.anm2"
	local brim2CustomCostume = Isaac.GetCostumeIdByPath(brim2Path)
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) >= 2 then
		ccp:TryAddNullCostume(player, brim2CustomCostume, brim2Path)
	else
		player:TryRemoveNullCostume(brim2CustomCostume)
	end

	--Lost Curse
	local cursePath = basePath .. "lostcurse.anm2"
	local curseCustomCostume = Isaac.GetCostumeIdByPath(cursePath)
	if playerEffects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
		ccp:TryAddNullCostume(player, curseCustomCostume, cursePath)
	else
		player:TryRemoveNullCostume(curseCustomCostume)
	end

	--Tooth and Nail
	local toothPath = basePath .. "toothandnail.anm2"
	local toothCustomCostume = Isaac.GetCostumeIdByPath(toothPath)
	if playerEffects:HasNullEffect(NullItemID.ID_TOOTH_AND_NAIL) then
		ccp:TryAddNullCostume(player, toothCustomCostume, toothPath)
	else
		player:TryRemoveNullCostume(toothCustomCostume)
	end

	--Mushroom transformation
	local mushroomPath = basePath .. "mushroomhat.anm2"
	local mushroomCustomCostume = Isaac.GetCostumeIdByPath(mushroomPath)
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_MUSHROOM) and not data.CCP.MushroomCostume then
		data.CCP.MushroomCostume = true
		--if not vee.GameContinuedOnPlayerInit() then
		ccp:TryAddNullCostume(player, mushroomCustomCostume, mushroomPath)
		--end
	elseif not player:HasPlayerForm(PlayerForm.PLAYERFORM_MUSHROOM) and data.CCP.MushroomCostume then
		player:TryRemoveNullCostume(mushroomCustomCostume)
		data.CCP.MushroomCostume = nil
	end
end

---@param player EntityPlayer
local function RemoveModdedCostumes(player)
	local ModdedNullCostumeIDStart = NullItemID.NUM_NULLITEMS + 1
	local ModdedCollectibleCostumeIDStart = CollectibleType.NUM_COLLECTIBLES + 1
	local MaxNullItemIDs = #Isaac.GetItemConfig():GetNullItems() - 1
	local MaxCollectibles = #Isaac.GetItemConfig():GetCollectibles() - 1

	for id = ModdedNullCostumeIDStart, MaxNullItemIDs do
		local notSupported = true
		local startingSupportedID = Isaac.GetCostumeIdByPath(baseCostumePath .. "costume_eevee.anm2")
		if (id >= startingSupportedID and id <= startingSupportedID + NUM_NULL_COSTUMES) or id == Isaac.GetCostumeIdByPath("the/specialist_isaac.anm2") then
			notSupported = false
		end
		if notSupported == true then
			player:TryRemoveNullCostume(id)
		end
	end
	for id = ModdedCollectibleCostumeIDStart, MaxCollectibles do
		local itemConfigID = Isaac.GetItemConfig():GetCollectible(id)
		if player:HasCollectible(id)
			and ItemConfig.Config.ShouldAddCostumeOnPickup(itemConfigID)
			and not EEVEEMOD.CollectiblesWithCostumes[id]
		then
			player:RemoveCostume(itemConfigID)
		end
	end
end

---@param player EntityPlayer
---@param playerType PlayerType
local function TryRemoveOldCostume(player, playerType)
	local basePath = playerCostume[playerType]
	if basePath ~= nil then
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(basePath .. ".anm2"))
	end
end

------------------
--  MAIN STUFF  --
------------------

---@param player EntityPlayer
---@param sprite Sprite
---@param spritesheetPath string
function ccp:UpdatePlayerSpritesheet(player, sprite, spritesheetPath)
	local playerType = player:GetPlayerType()
	local spritesheetPath = spritesheetPath or playerSpritesheet[playerType] .. vee.GetSkinColorName(player) .. ".png"

	sprite:ReplaceSpritesheet(12, spritesheetPath)
	sprite:ReplaceSpritesheet(4, spritesheetPath)
	sprite:ReplaceSpritesheet(2, spritesheetPath)
	sprite:ReplaceSpritesheet(1, spritesheetPath)
	sprite:LoadGraphics()
end

---@param player EntityPlayer
function ccp:ReapplyBaseCostume(player)
	local playerType = player:GetPlayerType()

	if playerToProtect[playerType] == true
		and playerCostume[playerType] ~= nil then
		player:AddNullCostume(Isaac.GetCostumeIdByPath(playerCostume[playerType] .. ".anm2"))
	end
end

---@param player EntityPlayer
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

---@param player EntityPlayer
function ccp:ResetPlayerCostumes(player)
	local data = player:GetData()
	local playerEffects = player:GetEffects()

	for playerType, _ in pairs(data.CCP.HasCostumeInitialized) do --Triggers once, just used to grab the playerType inside their player data
		local basePath = playerCostume[playerType]

		for _, costumeString in pairs(costumeTypeList) do
			local itemCostume = Isaac.GetCostumeIdByPath(basePath .. costumeString .. ".anm2")
			if itemCostume ~= -1 or itemCostume ~= nil then
				player:TryRemoveNullCostume(itemCostume)
			end
		end

		--Item Costumes
		for itemID, _ in pairs(costumeList) do
			local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
			if ccp:CanRemoveCollectibleCostume(player, itemID)
				and costumeList[itemID] == false then
				player:AddCostume(itemCostume, false)
			end
		end

		--Active Items
		for itemID, boolean in pairs(activeItemCostumes) do
			if playerEffects:HasCollectibleEffect(itemID)
				and costumeList[itemID] == false
			then
				local itemCostume = Isaac.GetItemConfig():GetCollectible(itemID)
				player:AddCostume(itemCostume, false)
			end
		end

		--Null Costumes
		for nullItemID = 1, NullItemID.NUM_NULLITEMS do
			if playerEffects:HasNullEffect(nullItemID)
				and nullEffectsList[nullItemID] == false
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
				and trinketCostumeList[trinketID] == false then
				local trinketCostume = Isaac.GetItemConfig():GetTrinket(trinketID)
				player:AddCostume(trinketCostume, false)
			end
		end

		--Transformations
		for playerForm, nullItemID in pairs(playerFormToNullItemID) do
			if player:HasPlayerForm(playerForm)
				and nullEffectsList[nullItemID] == false
			then
				player:AddNullCostume(nullItemID)
			end
		end
	end
	data.CCP = nil
end

---@param player EntityPlayer
local function OutfitAdjustments(player)
	if curOutfit == Outfit.NONE then
		playerSpritesheet[EEVEEMOD.PlayerType.EEVEE] = baseCharacterPath .. "character_eevee"
	elseif curOutfit == Outfit.CHRISTMAS then
		ccp:TryAddNullCostume(player, EEVEEMOD.NullCostume.CHRISTMAS_HAT,
			baseCostumePath .. "costume_eevee_christmashat.anm2")
		playerSpritesheet[EEVEEMOD.PlayerType.EEVEE] = baseCharacterPath .. "outfits/character_eevee_christmas"
		ccp:UpdatePlayerSpritesheet(player, player:GetSprite(), playerSpritesheet[EEVEEMOD.PlayerType.EEVEE] .. ".png")
	end
end

---@param player EntityPlayer
function ccp:InitPlayerCostume(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if playerToProtect[playerType] == true
		and not player:IsCoopGhost() then
		if not data.CCP then
			data.CCP = {}
		end
		if not data.CCP.HasCostumeInitialized
			or (data.CCP.HasCostumeInitialized and not data.CCP.HasCostumeInitialized[playerType]) then
			data.CCP.NumCollectibles = player:GetCollectibleCount()
			data.CCP.NumTemporaryEffects = #player:GetEffects():GetEffectsList()
			data.CCP.QueueCostumeRemove = {}
			data.CCP.TrinketActive = {
				[TrinketType.TRINKET_TICK] = false,
				[TrinketType.TRINKET_AZAZELS_STUMP] = false,
				[TrinketType.TRINKET_RED_PATCH] = false
			}
			data.CCP.HasCostumeInitialized = {
				[playerType] = true
			}
			data.CCP.editedCostumesActive = {}
			for itemID, _ in pairs(editedCostumes) do
				data.CCP.editedCostumesActive[itemID] = false
			end
			data.CCP.uniqueHairCostumesActive = {}
			for itemID, _ in pairs(uniqueHairCostumes) do
				data.CCP.uniqueHairCostumesActive[itemID] = false
			end
			local basePath = playerCostume[playerType]
			local charCostume = Isaac.GetCostumeIdByPath(basePath .. ".anm2")
			player:AddNullCostume(charCostume)
			OutfitAdjustments(player)
		end
	end
end

---@param player EntityPlayer
function ccp:DeinitPlayerCostume(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if not data.CCP or not data.CCP.HasCostumeInitialized or data.CCP.HasCostumeInitialized[playerType] then return end

	for dataPlayerType, _ in pairs(data.CCP.HasCostumeInitialized) do
		if playerToProtect[playerType] then --Your current player is within the library's protection! Initialize them with their new data.
			TryRemoveOldCostume(player, dataPlayerType)
			data.CCP.HasCostumeInitialized[dataPlayerType] = nil
			ccp:InitPlayerCostume(player)
		elseif playerToProtect[dataPlayerType] then --You current player isn't protected, but previously was within this library's protection.
			ccp:ResetPlayerCostumes(player)
		end
	end
end

---@param player EntityPlayer
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
		and data.CCP.NumTemporaryEffects ~= #player:GetEffects():GetEffectsList()
		and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HEMOPTYSIS)
	then
		data.CCP.NumTemporaryEffects = #player:GetEffects():GetEffectsList()
		ccp:MainResetPlayerCostumes(player)
	end

	for trinketID, _ in pairs(trinketCostumeList) do
		if ((trinketID == TrinketType.TRINKET_TICK
					and player:HasTrinket(trinketID))
				or playerEffects:HasTrinketEffect(trinketID))
		then
			if not data.CCP.TrinketActive[trinketID] then
				if not trinketCostumeList[trinketID] then
					local trinketCostume = Isaac.GetItemConfig():GetTrinket(trinketID)
					if trinketID == TrinketType.TRINKET_TICK then
						if player.QueuedItem.Item then
							if player.QueuedItem.Item.ID == TrinketType.TRINKET_TICK then
								data.CCP.DelayTick = true
							end
						else
							if data.CCP.DelayTick then
								player:RemoveCostume(trinketCostume)
								data.CCP.DelayTick = false
								data.CCP.TrinketActive[trinketID] = true
							end
						end
					else
						player:RemoveCostume(trinketCostume)
					end
				end
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

---@param player EntityPlayer
function ccp:CanAstralProjectionTrigger(player)
	local data = player:GetData()
	local room = EEVEEMOD.game:GetRoom()

	if player:HasCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) then
		data.CCP.AP_CanTrigger = not room:IsClear()
	end
end

---@param player EntityPlayer
function ccp:AstralProjectionUpdate(player)
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local hasProjectionEffect = playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)

	if data.CCP.AP_CanTrigger then
		if hasProjectionEffect then
			if vee.RoomCleared == true and not data.CCP.LostCurse then
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

---@param player EntityPlayer
function ccp:AstralProjectionOnHit(player, _, _, _, _)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local hasProjectionEffect = playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)

	if playerToProtect[playerType] == true
		and data.CCP
		and data.CCP.AP_CanTrigger then
		if not hasProjectionEffect and not data.CCP.AP_Disabled then
			data.CCP.DelaySpritesheetChange = baseCostumeSuffixPath ..
				EEVEEMOD.PlayerTypeToString[playerType] .. "/character_012_thelost.png"
			data.CCP.AP_Disabled = true
		elseif hasProjectionEffect and data.CCP.AP_Disabled then
			data.CCP.DelaySpritesheetChange = ""
		end
	end
end

---@param player EntityPlayer
function ccp:OnLostCurse(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local hasLostCurse = playerEffects:HasNullEffect(NullItemID.ID_LOST_CURSE)

	if hasLostCurse and not data.CCP.LostCurse then
		data.CCP.DelaySpritesheetChange = baseCostumeSuffixPath ..
			EEVEEMOD.PlayerTypeToString[playerType] .. "/character_012_thelost.png"
		data.CCP.LostCurse = true
	elseif not hasLostCurse and data.CCP.LostCurse then
		data.CCP.DelaySpritesheetChange = ""
		data.CCP.LostCurse = nil
	end
end

---@param player EntityPlayer
function ccp:OnSpiritShackles(player)
	local playerType = player:GetPlayerType()
	local playerEffects = player:GetEffects()
	local data = player:GetData()
	local isShacklesSoul = playerEffects:HasNullEffect(NullItemID.ID_SPIRIT_SHACKLES_SOUL)

	if isShacklesSoul and not data.CCP.ShacklesGhost then
		data.CCP.DelaySpritesheetChange = baseCostumeSuffixPath ..
			EEVEEMOD.PlayerTypeToString[playerType] .. "/character_018_thesoul.png"
		data.CCP.ShacklesGhost = true
	elseif not isShacklesSoul and data.CCP.ShacklesGhost then
		data.CCP.DelaySpritesheetChange = ""
		data.CCP.ShacklesGhost = nil
	end
end

----------------------------------------------
--  RESETTING COSTUME ON SPECIFIC TRIGGERS  --
----------------------------------------------

---@param itemID CollectibleType
---@param player EntityPlayer
function ccp:ResetCostumeOnItem(itemID, _, player, _, _, _)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local playerUsedItem = activeItemCostumes[itemID] == true

	if playerToProtect[playerType]
		and data.CCP
		and data.CCP.HasCostumeInitialized
		and playerUsedItem then
		if costumeList
			and costumeList[itemID] == false
		then
			data.CCP.DelayCostumeReset = true
		end

		if itemID == CollectibleType.COLLECTIBLE_D4
			or itemID == CollectibleType.COLLECTIBLE_D100 then
			data.CCP.DelayRunReroll = true
		end
	end
end

---@param pillID PillEffect
---@param player EntityPlayer
function ccp:ResetCostumeOnPill(pillID, player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local playerUsedPill = pillCostumes[pillID] ~= nil

	if playerToProtect[playerType]
		and data.CCP
		and data.CCP.HasCostumeInitialized
		and playerUsedPill
		and nullEffectsList
		and nullEffectsList[pillCostumes[pillID]] == false
	then
		data.CCP.DelayPillCostumeRemove = pillID
	end
end

---@param player EntityPlayer
function ccp:ReapplyHairOnCoopRevive(player)
	local data = player:GetData()
	if player:IsCoopGhost() and not data.CCP.WaitOnCoopRevive then
		data.CCP.WaitOnCoopRevive = true
	elseif not player:IsCoopGhost() and data.CCP.WaitOnCoopRevive then
		ccp:ReapplyBaseCostume(player)
		data.CCP.WaitOnCoopRevive = false
	end
end

---@param player EntityPlayer
local function LoadPlayerAndCostumeSprites(player)
	local playerType = player:GetPlayerType()
	local pSprite = player:GetSprite():GetFilename()
	local data = player:GetData()
	local spritesheetPath = playerSpritesheet[playerType] .. ".png"
	local costumePath = playerCostume[playerType] .. ".anm2"

	data.CCP.MineshaftHeadCostume = Sprite()
	data.CCP.MineshaftBodyCostume = Sprite()
	data.CCP.MineshaftHead = Sprite()
	data.CCP.MineshaftBody = Sprite()
	data.CCP.MineshaftHead:Load(pSprite, true)
	data.CCP.MineshaftBody:Load(pSprite, true)
	data.CCP.MineshaftHeadCostume:Load(costumePath, true)
	data.CCP.MineshaftBodyCostume:Load(costumePath, true)
	data.CCP.MineshaftHead:Play("HeadUp", true)
	data.CCP.MineshaftBody:Play("WalkUp", true)
	data.CCP.MineshaftHeadCostume:Play("HeadUp", true)
	data.CCP.MineshaftBodyCostume:Play("WalkUp", true)
	ccp:UpdatePlayerSpritesheet(player, data.CCP.MineshaftHead, spritesheetPath)
	ccp:UpdatePlayerSpritesheet(player, data.CCP.MineshaftBody, spritesheetPath)
end

---@param player EntityPlayer
function ccp:RestoreCostumeInMineshaft(player)
	local playerType = player:GetPlayerType()
	local pSprite = player:GetSprite()
	local data = player:GetData()
	local room = EEVEEMOD.game:GetRoom()

	if playerToProtect[playerType] == true and data.CCP then
		if room:HasCurseMist() and playerCostume[playerType] then
			if not data.CCP.MineshaftHeadCostume then
				LoadPlayerAndCostumeSprites(player)
			elseif data.CCP.MineshaftHeadCostume:IsLoaded() then
				local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(player.Position)

				if vee.IsSpritePlayingAnims(player:GetSprite(), vee.WalkAnimations) then
					local spriteToUse = {
						data.CCP.MineshaftBody,
						data.CCP.MineshaftBodyCostume,
						data.CCP.MineshaftHead,
						data.CCP.MineshaftHeadCostume
					}
					for i = 1, #spriteToUse do
						local animToUse = pSprite:GetAnimation()
						local frameToUse = pSprite:GetFrame()
						if i > 2 then
							animToUse = pSprite:GetOverlayAnimation()
							frameToUse = pSprite:GetOverlayFrame()
						end
						spriteToUse[i].Color = pSprite.Color
						spriteToUse[i]:SetFrame(animToUse, frameToUse)
						spriteToUse[i]:Render(screenpos - EEVEEMOD.game.ScreenShakeOffset, Vector.Zero, Vector.Zero)
					end
				end
			end
		elseif data.CCP.MineshaftHeadCostume
			and data.CCP.MineshaftBodyCostume then
			data.CCP.MineshaftHeadCostume = nil
			data.CCP.MineshaftBodyCostume = nil
			data.CCP.MineshaftHead = nil
			data.CCP.MineshaftBody = nil
		end
	end
end

---@param player EntityPlayer
function ccp:ResetOnMissingNoNewFloor(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_NO) then
		ccp:MainResetPlayerCostumes(player)
		ccp:ReapplyBaseCostume(player)
	end
end

---@param player EntityPlayer
function ccp:ModelingClay(player)
	local data = player:GetData()
	local itemID = player:GetModelingClayEffect()

	if data.CCP.CheckForModelingClay then
		if player:HasTrinket(TrinketType.TRINKET_MODELING_CLAY)
			and itemID ~= 0
			and not costumeList[itemID]
		then
			table.insert(data.CCP.QueueCostumeRemove, itemID)
		end
		data.CCP.CheckForModelingClay = false
	end
end

---@param player EntityPlayer
function ccp:DelayInCostumeReset(player)
	local data = player:GetData()

	if data.CCP.DelayCostumeReset then
		ccp:MainResetPlayerCostumes(player)
		data.CCP.DelayCostumeReset = nil
	end

	if data.CCP.DelayRunReroll then
		ccp:MainResetPlayerCostumes(player)
		ccp:ReapplyBaseCostume(player)
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
			ccp:UpdatePlayerSpritesheet(player, player:GetSprite(),
				baseCharacterPath .. "character_" .. EEVEEMOD.PlayerTypeToString[player:GetPlayerType()] .. ".png")
		else
			ccp:UpdatePlayerSpritesheet(player, player:GetSprite(), data.CCP.DelaySpritesheetChange)
		end
		data.CCP.DelaySpritesheetChange = nil
	end

	if data.CCP.DelayBabylonCheck then
		local effects = player:GetEffects()
		if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
			ccp:MainResetPlayerCostumes(player)
			data.CCP.DelayBabylonCheck = false
		end
	end
end

---------------------
--  COSTUME HACKS  --
---------------------

local TimeTillGnawed = 60
local ShoopDuration = 60

---@param player EntityPlayer
function ccp:GnawedLeaf(player)
	local data = player:GetData()

	if not data.CCP or not player:HasCollectible(CollectibleType.COLLECTIBLE_GNAWED_LEAF) then return end

	if vee.IsNotUsingMoveControls(player) and player:GetFireDirection() == Direction.NO_DIRECTION and
		not data.CCP.EeveeGnawed then
		if not data.CCP.GnawedTimer then
			data.CCP.GnawedTimer = TimeTillGnawed
		elseif data.CCP.GnawedTimer > 0 then
			data.CCP.GnawedTimer = data.CCP.GnawedTimer - 1
		elseif not data.CCP.Gnawed then
			player:TryRemoveNullCostume(NullItemID.ID_STATUE)
			player:AddNullCostume(EEVEEMOD.NullCostume.CUSTOM_GNAWED)
			data.CCP.Gnawed = true
		end
	else
		if data.CCP.Gnawed then
			player:TryRemoveNullCostume(EEVEEMOD.NullCostume.CUSTOM_GNAWED)
			data.CCP.Gnawed = false
		end

		if data.CCP.GnawedTimer then
			data.CCP.GnawedTimer = nil
		end
	end
end

function ccp:GnawedOnLoad()
	local players = vee.GetAllPlayers()

	for i = 1, #players do
		local player = players[i]
		local playerType = player:GetPlayerType()
		if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and player:HasCollectible(CollectibleType.COLLECTIBLE_GNAWED_LEAF) then
			local data = player:GetData()
			data.CCP.GnawedTimer = 0
		end
	end
end

---@param player EntityPlayer
function ccp:ToggleShoop(player)
	local data = player:GetData()

	if data.CCP.EquipShoopDelay then
		if not data.CCP.EquipShoop then
			data.CCP.EquipShoop = true
			local shoopConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP)
			player:RemoveCostume(shoopConfig)
			player:AddNullCostume(EEVEEMOD.NullCostume.CUSTOM_SHOOP)
		else
			data.CCP.EquipShoop = false
			player:TryRemoveNullCostume(EEVEEMOD.NullCostume.CUSTOM_SHOOP)
		end
		data.CCP.EquipShoopDelay = false
	end
	if data.CCP.EquipShoop and player:GetFireDirection() ~= Direction.NO_DIRECTION and not data.ShoopTimer then
		data.ShoopTimer = ShoopDuration
	end
	if data.ShoopTimer then
		if data.ShoopTimer > 0 then
			data.ShoopTimer = data.ShoopTimer - 1
		else
			data.CCP.EquipShoopDelay = true
			data.ShoopTimer = nil
		end
	end
end

---@param player EntityPlayer
function ccp:ToggleBoomerang(player)
	local data = player:GetData()

	if data.CCP.EquipBoomerangDelay then
		if not data.CCP.EquipBoomerang then
			data.CCP.EquipBoomerang = true
			local boomerangConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOMERANG)
			player:RemoveCostume(boomerangConfig)
			player:AddNullCostume(EEVEEMOD.NullCostume.CUSTOM_BOOMERANG)
		else
			data.CCP.EquipBoomerang = false
			player:TryRemoveNullCostume(EEVEEMOD.NullCostume.CUSTOM_BOOMERANG)
		end
		data.CCP.EquipBoomerangDelay = false
	end
	for _, boomerang in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOOMERANG)) do
		if vee.IsEntitySpawnedByPlayer(boomerang)
			and vee.DoPlayerIdentifiersMatch(boomerang.SpawnerEntity:ToPlayer(), player)
			and not data.CCP.MyBoomerang
		then
			data.CCP.MyBoomerang = boomerang
			data.CCP.EquipBoomerangDelay = true
		end
	end
	if data.CCP.MyBoomerang and not data.CCP.MyBoomerang:Exists() then
		data.CCP.MyBoomerang = nil
	end
end

---@param player EntityPlayer
function ccp:OnShoop(_, _, player, _, _, _)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and data.CCP then
		data.CCP.EquipShoopDelay = true
	end
end

---@param player EntityPlayer
function ccp:OnBoomerang(_, _, player, _, _, _)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and data.CCP then
		data.CCP.EquipBoomerangDelay = true
	end
end

---@param player EntityPlayer
function ccp:StopBoomerangShoopOnNewRoom(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and data.CCP then
		if data.CCP.EquipShoop then
			data.CCP.EquipShoopDelay = true
			ccp:ToggleShoop(player)
		end
		if data.CCP.EquipBoomerang then
			data.CCP.EquipBoomerangDelay = true
			ccp:ToggleBoomerang(player)
		end
	end
end

---@param player EntityPlayer
function ccp:ReapplyBabylonBodyOnNewRoom(player)
	local data = player:GetData()

	if player:HasCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
		data.CCP.DelayBabylonCheck = true
	end
end

---@param player EntityPlayer
function ccp:AntiBrimPogBaldness(player)
	if not Poglite then return end
	local data = player:GetData()
	local costumePath = "gfx/characters/costume_eevee_brimstone_pogginghair.anm2"
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
		if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) >= 2 then
			string.gsub(costumePath, "brimstone", "brimstone2")
		end

		if not data.EeveeBrimPog and Poglite.WePoggin then
			data.EeveeBrimPog = true
			ccp:TryAddNullCostume(player, Isaac.GetCostumeIdByPath(costumePath), costumePath)
		elseif data.EeveeBrimPog and not Poglite.WePoggin then
			player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(costumePath))
			data.EeveeBrimPog = false
		end
	elseif data.EeveeBrimPog then
		data.EeveeBrimPog = nil
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(costumePath))
		player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath(string.gsub(costumePath, "brimstone", "brimstone2")))
	end
end

----------------------------
--  INITIATING CALLBACKS  --
----------------------------

---@param player EntityPlayer
function ccp:OnPlayerInit(player)
	ccp:InitPlayerCostume(player)
end

---@param player EntityPlayer
function ccp:OnPeffectUpdate(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if EEVEEMOD.game:GetFrameCount() > 1 then
		ccp:DeinitPlayerCostume(player)
	end
	if playerToProtect[playerType] and not data.CCP then
		ccp:InitPlayerCostume(player)
	end
	if playerToProtect[playerType] ~= true or not data.CCP then return end

	ccp:MiscCostumeResets(player)
	ccp:DelayInCostumeReset(player)
	ccp:ReapplyHairOnCoopRevive(player)
	ccp:ModelingClay(player)
	ccp:AstralProjectionUpdate(player)
	ccp:OnLostCurse(player)
	ccp:OnSpiritShackles(player)
end

---@param player EntityPlayer
function ccp:OnPlayerUpdate(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if playerToProtect[playerType] ~= true or not data.CCP then return end

	ccp:ToggleShoop(player)
	ccp:ToggleBoomerang(player)
	ccp:GnawedLeaf(player)
	ccp:AntiBrimPogBaldness(player)
end

---@param player EntityPlayer
function ccp:OnNewRoom(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if playerToProtect[playerType] ~= true or not data.CCP then return end

	ccp:CanAstralProjectionTrigger(player)
	ccp:StopBoomerangShoopOnNewRoom(player)
	ccp:ReapplyBabylonBodyOnNewRoom(player)

	if player:HasTrinket(TrinketType.TRINKET_MODELING_CLAY) then
		local data = player:GetData()
		data.CCP.CheckForModelingClay = true
	end
end

---@param player EntityPlayer
function ccp:OnNewLevel(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if playerToProtect[playerType] ~= true or not data.CCP then return end

	ccp:ResetOnMissingNoNewFloor(player)
end

return ccp
