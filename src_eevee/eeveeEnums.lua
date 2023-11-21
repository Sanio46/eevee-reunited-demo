EEVEEMOD = EEVEEMOD or {}

EEVEEMOD.game = Game()
EEVEEMOD.ItemConfig = Isaac.GetItemConfig()
EEVEEMOD.sfx = SFXManager()
EEVEEMOD.shouldSaveData = false
EEVEEMOD.Name = "Eevee: Reunited Demo"

EEVEEMOD.RunSeededRNG = RNG()
EEVEEMOD.PERSISTENT_DATA = EEVEEMOD.PERSISTENT_DATA or { --As to not reset while I'm testing lol
	CustomDolly = false,
	ClassicVoice = false,
	UniqueBirthright = false,
	PassiveShiny = true,
	UnlockData = {
		Eevee = {},
		Eevee_B = {},
		PokeyMansCrystal = false
	},
	PlayerData = {},
	LilEeveeData = {},
}

EEVEEMOD.AchievementGraphics = {
	Eevee = {
		MomsHeart = "achievement_momsheart",
		Isaac = "achievement_shinycharm",
		Satan = "achievement_blackglasses",
		BlueBaby = "achievement_cookiejar",
		Lamb = "achievement_eviolite",
		BossRush = "achievement_sneakscarf",
		Hush = "achievement_lockonspecs",
		MegaSatan = "achievement_strangeegg",
		Delirium = "achievement_badegg",
		Mother = "achievement_bagofpokeballs",
		Beast = "achievement_masterball",
		GreedMode = "achievement_alertspecs",
		Greedier = "achievement_wonderouslauncher",
		Tainted = "achievement_woodencross",
		FullCompletion = "achievement_tailwhip",
	},
	Eevee_B = {
		PolNegPath = "achievement_woodencross",
		SoulPath = "achievement_woodencross",
		MegaSatan = "achievement_woodencross",
		Delirium = "achievement_woodencross",
		Mother = "achievement_woodencross",
		Beast = "achievement_woodencross",
		Greedier = "achievement_woodencross",
		FullCompletion = "achievement_woodencross",
	},
	PokeyMansCrystal = "achievement_pokestop",
	TrueFullCompletion = "achievement_woodencross"
}

---@enum EeveeChallenge
EEVEEMOD.Challenge = {
	POKEY_MANS_CRYSTAL = Isaac.GetChallengeIdByName("Pokey Mans: Crystal")
}

---@enum EeveeCollectibleType
EEVEEMOD.CollectibleType = {
	SNEAK_SCARF = Isaac.GetItemIdByName("Sneak Scarf"),
	SHINY_CHARM = Isaac.GetItemIdByName("Shiny Charm"),
	BLACK_GLASSES = Isaac.GetItemIdByName("Black Glasses"),
	COOKIE_JAR = Isaac.GetItemIdByName("Cookie Jar"),
	STRANGE_EGG = Isaac.GetItemIdByName("Strange Egg"),
	LIL_EEVEE = Isaac.GetItemIdByName("Lil Eevee"),
	BAD_EGG = Isaac.GetItemIdByName("Bad EGG"),
	BAD_EGG_DUPE = Isaac.GetItemIdByName("Duped Bad EGG"),
	WONDEROUS_LAUNCHER = Isaac.GetItemIdByName("Wonderous Launcher"),
	BAG_OF_POKEBALLS = Isaac.GetItemIdByName("Bag of Poke Balls"),
	MASTER_BALL = Isaac.GetItemIdByName("Master Ball"),
	POKE_STOP = Isaac.GetItemIdByName("Poke Stop"),
	TAIL_WHIP = Isaac.GetItemIdByName("Tail Whip"),
}

EEVEEMOD.CollectiblesWithCostumes = {
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = true,
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = true,
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = true,
}

---@enum ColorCycle
EEVEEMOD.ColorCycle = {
	RGB = 0,
	CONTINUUM = 1
}

---@enum EeveeEffectVariant
EEVEEMOD.EffectVariant = {
	CUSTOM_BRIMSTONE_SWIRL = Isaac.GetEntityVariantByName("Custom Brimstone Swirl"),
	CUSTOM_TECH_DOT = Isaac.GetEntityVariantByName("Custom Tech Dot"),
	EEVEE_GHOST = Isaac.GetEntityVariantByName("Eevee Ghost"),
	TAIL_WHIP = Isaac.GetEntityVariantByName("Tail Whip"),
	POKEBALL = Isaac.GetEntityVariantByName("Poke Ball"),
	LOCKON_SPECS_DROP = Isaac.GetEntityVariantByName("Lockon Specs Drop"),
	WONDEROUS_LAUNCHER = Isaac.GetEntityVariantByName("Wonderous Launcher"),
	BAD_EGG_GLITCH = Isaac.GetEntityVariantByName("Bad Egg Glitch"),
	SHINY_APPEAR = Isaac.GetEntityVariantByName("Shiny Appear"),
	SHINY_SPARKLE = Isaac.GetEntityVariantByName("Shiny Sparkle"),
	ANTI_GRAV_PARENT = Isaac.GetEntityVariantByName("Anti-Grav Parent Placeholder"),
	CUSTOM_TEAR_HALO = Isaac.GetEntityVariantByName("Custom Tear Halo"),
}

---@enum EeveeFamiliarVariant
EEVEEMOD.FamiliarVariant = {
	LIL_EEVEE = Isaac.GetEntityVariantByName("Lil Eevee"),
	BAG_OF_POKEBALLS = Isaac.GetEntityVariantByName("Bag of Pokeballs"),
	VINE = Isaac.GetEntityVariantByName("Lil Leafeon Vine"),
	BAD_EGG = Isaac.GetEntityVariantByName("Bad EGG"),
	BAD_EGG_DUPE = Isaac.GetEntityVariantByName("Bad EGG Dupe"),
}

---@type table<CollectibleType, FamiliarVariant>
EEVEEMOD.ItemToFamiliarVariant = {
	{ EEVEEMOD.CollectibleType.LIL_EEVEE, EEVEEMOD.FamiliarVariant.LIL_EEVEE },
	{ EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS, EEVEEMOD.FamiliarVariant.BAG_OF_POKEBALLS },
	{ EEVEEMOD.CollectibleType.BAD_EGG, EEVEEMOD.FamiliarVariant.BAD_EGG },
	{ EEVEEMOD.CollectibleType.BAD_EGG_DUPE, EEVEEMOD.FamiliarVariant.BAD_EGG_DUPE },
}

---@enum EeveeNullCostume
EEVEEMOD.NullCostume = {
	TRAINER_CAP = Isaac.GetCostumeIdByPath("gfx/characters/costume_trainer_cap.anm2"),
	CUSTOM_SHOOP = Isaac.GetCostumeIdByPath("gfx/characters/edited_049_shoop da whoop.anm2"),
	CUSTOM_GNAWED = Isaac.GetCostumeIdByPath("gfx/characters/edited_210_gnawedleaf_statue.anm2"),
	CUSTOM_BOOMERANG = Isaac.GetCostumeIdByPath("gfx/characters/edited_n030_boomerang.anm2"),
	TAIL_WHIP = Isaac.GetCostumeIdByPath("gfx/characters/costume_collectible_tailwhip.anm2"),
	CHRISTMAS_HAT = Isaac.GetCostumeIdByPath("gfx/characters/costume_eevee_christmashat.anm2"),
}

---@enum EeveePlayerType
EEVEEMOD.PlayerType = {
	EEVEE = Isaac.GetPlayerTypeByName("Eevee", false),
	EEVEE_B = Isaac.GetPlayerTypeByName("Eevee", true),
}

---@type table<PlayerType, string>
EEVEEMOD.PlayerTypeToString = {
	[EEVEEMOD.PlayerType.EEVEE] = "eevee",
}

---@type table<CollectibleType, PlayerType>
EEVEEMOD.BirthrightToPlayerType = {
	[EEVEEMOD.CollectibleType.TAIL_WHIP] = EEVEEMOD.PlayerType.EEVEE
}

---@type table<PlayerType, table<SoundEffect, SoundEffect>>
EEVEEMOD.PlayerSounds = {
	[EEVEEMOD.PlayerType.EEVEE] = {
		[SoundEffect.SOUND_ISAAC_HURT_GRUNT] = Isaac.GetSoundIdByName("Eevee Hurt"),
		[SoundEffect.SOUND_ISAACDIES] = Isaac.GetSoundIdByName("Eevee Death"),
		[SoundEffect.SOUND_ISAAC_ROAR] = Isaac.GetSoundIdByName("Eevee Roar"),
		[SoundEffect.SOUND_LARYNX_SCREAM_LO] = Isaac.GetSoundIdByName("Eevee Scream Low"),
		[SoundEffect.SOUND_LARYNX_SCREAM_MED] = Isaac.GetSoundIdByName("Eevee Scream Med"),
		[SoundEffect.SOUND_LARYNX_SCREAM_HI] = Isaac.GetSoundIdByName("Eevee Scream High"),
	}
}

---@type table<PlayerType, boolean>
EEVEEMOD.IsPlayerEeveeOrEvolved = {
	[EEVEEMOD.PlayerType.EEVEE] = true,
}

---@enum EeveePokeballType
EEVEEMOD.PokeballType = {
	POKEBALL = Isaac.GetCardIdByName("Poke Ball"),
	GREATBALL = Isaac.GetCardIdByName("Great Ball"),
	ULTRABALL = Isaac.GetCardIdByName("Ultra Ball")
}

---@type table<Card | CollectibleType, string>
EEVEEMOD.PokeballTypeToString = {
	[EEVEEMOD.PokeballType.POKEBALL] = "r",
	[EEVEEMOD.PokeballType.GREATBALL] = "g",
	[EEVEEMOD.PokeballType.ULTRABALL] = "u",
	[EEVEEMOD.CollectibleType.MASTER_BALL] = "m"
}

---@enum EeveeSlotVariant
EEVEEMOD.SlotVariant = {
	POKE_STOP = Isaac.GetEntityVariantByName("Poke Stop")
}

---@enum EeveeSoundEffect
EEVEEMOD.SoundEffect = {
	SWIFT_FIRE = Isaac.GetSoundIdByName("Swift Fire"),
	SWIFT_HIT = Isaac.GetSoundIdByName("Swift Hit"),
	POKEBALL_CLICK = Isaac.GetSoundIdByName("Poke Ball Click"),
	POKEBALL_ROLL = Isaac.GetSoundIdByName("Poke Ball Roll"),
	POKEBALL_OPEN = Isaac.GetSoundIdByName("Poke Ball Open"),
	EXP_GAIN = Isaac.GetSoundIdByName("EXP Gain"),
	EXP_LEVELUP = Isaac.GetSoundIdByName("EXP Level Up"),
	SHINY_APPEAR = Isaac.GetSoundIdByName("Shiny Appear"),
	EEVEE_SQUEAK = Isaac.GetSoundIdByName("Eevee Squeak")
}

---@type Sprite[]
EEVEEMOD.Sprite = {
	EggOutline = Sprite(),
	LevelBar = Sprite(),
	CookieJar = Sprite(),
}

---@type table<TearVariant, boolean>
EEVEEMOD.KeepTearVariants = {
	[TearVariant.COIN] = true,
	[TearVariant.BELIAL] = true,
	[TearVariant.ICE] = true,
	[TearVariant.ROCK] = true,
	[TearVariant.FETUS] = true,
}

---@enum EeveeTrinketType
EEVEEMOD.TrinketType = {
	ALERT_SPECS = Isaac.GetTrinketIdByName("Alert Specs"),
	LOCKON_SPECS = Isaac.GetTrinketIdByName("Lock-On Specs"),
	EVIOLITE = Isaac.GetTrinketIdByName("Eviolite"),
	--[[ MOSSY_ROCK = {
		STAGE_1 = Isaac.GetTrinketIdByName("Small Mossy Rock"),
		STAGE_2 = Isaac.GetTrinketIdByName("Sizeable Mossy Rock"),
		STAGE_MAX = Isaac.GetTrinketIdByName("Mossy Rock")
	},
	ICY_ROCK = {
		STAGE_1 = Isaac.GetTrinketIdByName("Small Icy Rock"),
		STAGE_2 = Isaac.GetTrinketIdByName("Sizeable Icy Rock"),
		STAGE_MAX = Isaac.GetTrinketIdByName("Icy Rock")
	}, ]]
}

---@enum EeveeTearVariant
EEVEEMOD.TearVariant = {
	SWIFT = Isaac.GetEntityVariantByName("Swift Tear"),
	SWIFT_BLOOD = Isaac.GetEntityVariantByName("Swift Blood Tear"),
	WONDERCOIN = Isaac.GetEntityVariantByName("Wonder Coin Tear"),
	WONDERPOOP = Isaac.GetEntityVariantByName("Wonder Poop Tear"),
}

---@type table<TearVariant, Color>
EEVEEMOD.TrailColor = {
	[EEVEEMOD.TearVariant.SWIFT] = Color(1, 1, 0.5, 1, 0.176, 0.05, 0),
	[EEVEEMOD.TearVariant.SWIFT_BLOOD] = Color(1, 0, 0, 1, 0, 0, 0),
	[TearVariant.BELIAL] = Color(1, 0, 0, 1, 0, 0, 0),
	[TearVariant.ROCK] = Color(0.5, 0.5, 0.5, 1, 0, 0, 0),
	[TearVariant.ICE] = Color(0.4, 0.5, 0.9, 1, 0, 0.3, 0),
	[TearVariant.FETUS] = Color(1, 1, 1, 1, 0, 0, 0),
}

return EEVEEMOD
