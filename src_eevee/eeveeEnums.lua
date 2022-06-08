EEVEEMOD = EEVEEMOD or {}

EEVEEMOD.game = Game()
EEVEEMOD.ItemConfig = Isaac.GetItemConfig()
EEVEEMOD.sfx = SFXManager()
EEVEEMOD.shouldSaveData = false
EEVEEMOD.Name = "Eevee: Reunited Demo"

EEVEEMOD.RandomRNG = RNG()
EEVEEMOD.RunSeededRNG = RNG()
EEVEEMOD.RandomRNG:SetSeed(Random() + 1, 35)
function EEVEEMOD.RandomNum(lower, upper)
	if upper then
		return EEVEEMOD.RandomRNG:RandomInt((upper - lower) + 1) + lower
	elseif lower then
		return EEVEEMOD.RandomRNG:RandomInt(lower) + 1
	else
		return EEVEEMOD.RandomRNG:RandomFloat()
	end
end

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
		MomsHeart = "achievement_whoops",
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

---@type CollectibleType
EEVEEMOD.Birthright = {
	TAIL_WHIP = Isaac.GetItemIdByName("Tail Whip"),
	--[[ OVERHEAT = Isaac.GetItemIdByName("Overheat"),
	THUNDER = Isaac.GetItemIdByName("Thunder"),
	DIVE = Isaac.GetItemIdByName("Dive"),
	FUTURE_SIGHT = Isaac.GetItemIdByName("Future Sight"),
	BRE = Isaac.GetItemIdByName("Umbreon's Birthright"),
	GLACE = Isaac.GetItemIdByName("Glaceon's Birthright"),
	SWORDS_DANCE = Isaac.GetItemIdByName("Swords Dance"),
	SYLV = Isaac.GetItemIdByName("Sylveon's Birthright") ]]
}

---@type Challenge[]
EEVEEMOD.Challenge = {
	POKEY_MANS_CRYSTAL = Isaac.GetChallengeIdByName("Pokey Mans: Crystal")
}

---@type CollectibleType[]
EEVEEMOD.CollectibleType = {
	SNEAK_SCARF = Isaac.GetItemIdByName("Sneak Scarf"),
	SHINY_CHARM = Isaac.GetItemIdByName("Shiny Charm"),
	BLACK_GLASSES = Isaac.GetItemIdByName("Black Glasses"),
	--[[ COOKIE_JAR = {
		Isaac.GetItemIdByName("Cookie Jar"),
		Isaac.GetItemIdByName(" Cookie Jar "),
		Isaac.GetItemIdByName("  Cookie Jar  "),
		Isaac.GetItemIdByName("   Cookie Jar   "),
		Isaac.GetItemIdByName("    Cookie Jar    "),
		Isaac.GetItemIdByName("     Cookie Jar     ")
	}, ]]
	COOKIE_JAR = Isaac.GetItemIdByName("Cookie Jar"),
	STRANGE_EGG = Isaac.GetItemIdByName("Strange Egg"),
	LIL_EEVEE = Isaac.GetItemIdByName("Lil Eevee"),
	BAD_EGG = Isaac.GetItemIdByName("Bad EGG"),
	BAD_EGG_DUPE = Isaac.GetItemIdByName("Duped Bad EGG"),
	WONDEROUS_LAUNCHER = Isaac.GetItemIdByName("Wonderous Launcher"),
	BAG_OF_POKEBALLS = Isaac.GetItemIdByName("Bag of Poke Balls"),
	MASTER_BALL = Isaac.GetItemIdByName("Master Ball"),
	--GIGANTAFLUFF = Isaac.GetItemIdByName("Gigantafluff"),
	--LEAF_BLADE = Isaac.GetItemIdByName("Leaf Blade"),
	POKE_STOP = Isaac.GetItemIdByName("Poke Stop"),
	--HI_TECH_EARBUDS = Isaac.GetItemIdByName("Hi-tech Earbuds"),
}

---@type EffectVariant[]
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
	ANTI_GRAV_PARENT = Isaac.GetEntityVariantByName("Anti-Grav Parent Placeholder")
}

---@type FamiliarVariant[]
EEVEEMOD.FamiliarVariant = {
	LIL_EEVEE = Isaac.GetEntityVariantByName("Lil Eevee"),
	BAG_OF_POKEBALLS = Isaac.GetEntityVariantByName("Bag of Pokeballs"),
	VINE = Isaac.GetEntityVariantByName("Lil Leafeon Vine"),
	BAD_EGG = Isaac.GetEntityVariantByName("Bad EGG"),
	BAD_EGG_DUPE = Isaac.GetEntityVariantByName("Bad EGG Dupe"),
}

--TODO: Kidnap someone and tell me how to see if an item is unlocked or not
EEVEEMOD.ItemPool = {
	POOL_GLITCH = {
		CollectibleType.COLLECTIBLE_GB_BUG,
		CollectibleType.COLLECTIBLE_TMTRAINER,
		CollectibleType.COLLECTIBLE_GLITCHED_CROWN,
		CollectibleType.COLLECTIBLE_MISSING_NO,
		CollectibleType.COLLECTIBLE_UNDEFINED,
		CollectibleType.COLLECTIBLE_DATAMINER,
		EEVEEMOD.CollectibleType.BAD_EGG,
	}
}

---@type table<CollectibleType, FamiliarVariant>
EEVEEMOD.ItemToFamiliarVariant = {
	{ EEVEEMOD.CollectibleType.LIL_EEVEE, EEVEEMOD.FamiliarVariant.LIL_EEVEE },
	{ EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS, EEVEEMOD.FamiliarVariant.BAG_OF_POKEBALLS },
	{ EEVEEMOD.CollectibleType.BAD_EGG, EEVEEMOD.FamiliarVariant.BAD_EGG },
	{ EEVEEMOD.CollectibleType.BAD_EGG_DUPE, EEVEEMOD.FamiliarVariant.BAD_EGG_DUPE },
}

---@type NullItemID[]
EEVEEMOD.NullCostume = {
	--POKEMON_MASTER = Isaac.GetCostumeIdByPath("gfx/characters/costume_pokemon_master.anm2"),
	CUSTOM_SHOOP = Isaac.GetCostumeIdByPath("gfx/characters/edited_049_shoop da whoop.anm2"),
	CUSTOM_GNAWED = Isaac.GetCostumeIdByPath("gfx/characters/edited_210_gnawedleaf_statue.anm2"),
	CUSTOM_BOOMERANG = Isaac.GetCostumeIdByPath("gfx/characters/edited_n030_boomerang.anm2"),
}

---@type PlayerType[]
EEVEEMOD.PlayerType = {
	EEVEE = Isaac.GetPlayerTypeByName("Eevee", false),
	EEVEE_B = Isaac.GetPlayerTypeByName("Eevee", true),
	--[[ FLAREON = Isaac.GetPlayerTypeByName("Flareon"),
	JOLTEON = Isaac.GetPlayerTypeByName("Jolteon"),
	VAPOREON = Isaac.GetPlayerTypeByName("Vaporeon"),
	ESPEON = Isaac.GetPlayerTypeByName("Espeon"),
	UMBREON = Isaac.GetPlayerTypeByName("Umbreon"),
	GLACEON = Isaac.GetPlayerTypeByName("Glaceon"),
	LEAFEON = Isaac.GetPlayerTypeByName("Leafeon"),
	SYLVEON = Isaac.GetPlayerTypeByName("Sylveon") ]]
}

---@type table<PlayerType, string>
EEVEEMOD.PlayerTypeToString = {
	[EEVEEMOD.PlayerType.EEVEE] = "eevee",
	--[[ [EEVEEMOD.PlayerType.FLAREON] = "flareon",
	[EEVEEMOD.PlayerType.JOLTEON] = "jolteon",
	[EEVEEMOD.PlayerType.VAPOREON] = "vaporeon",
	[EEVEEMOD.PlayerType.ESPEON] = "espeon",
	[EEVEEMOD.PlayerType.UMBREON] = "umbreon",
	[EEVEEMOD.PlayerType.GLACEON] = "glaceon",
	[EEVEEMOD.PlayerType.LEAFEON] = "leafeon",
	[EEVEEMOD.PlayerType.SYLVEON] = "sylveon", ]]
}

---@type table<CollectibleType, PlayerType>
EEVEEMOD.BirthrightToPlayerType = {
	[EEVEEMOD.Birthright.TAIL_WHIP] = EEVEEMOD.PlayerType.EEVEE
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
	--[[ [EEVEEMOD.PlayerType.FLAREON] = true,
	[EEVEEMOD.PlayerType.JOLTEON] = true,
	[EEVEEMOD.PlayerType.VAPOREON] = true,
	[EEVEEMOD.PlayerType.ESPEON] = true,
	[EEVEEMOD.PlayerType.UMBREON] = true,
	[EEVEEMOD.PlayerType.GLACEON] = true,
	[EEVEEMOD.PlayerType.LEAFEON] = true,
	[EEVEEMOD.PlayerType.SYLVEON] = true ]]
}

---@class PokeballType
EEVEEMOD.PokeballType = {
	POKEBALL = Isaac.GetCardIdByName("Poke Ball"),
	GREATBALL = Isaac.GetCardIdByName("Great Ball"),
	ULTRABALL = Isaac.GetCardIdByName("Ultra Ball")
}

---@type table<PokeballType, string>
EEVEEMOD.PokeballTypeToString = {
	[EEVEEMOD.PokeballType.POKEBALL] = "r",
	[EEVEEMOD.PokeballType.GREATBALL] = "g",
	[EEVEEMOD.PokeballType.ULTRABALL] = "u",
	[EEVEEMOD.CollectibleType.MASTER_BALL] = "m"
}

---@type number[]
EEVEEMOD.RGB = {
	R = 255,
	G = 0,
	B = 0,
}

---@param entColor Color
function EEVEEMOD.GetRBG(entColor)
	return Color(EEVEEMOD.RGB.R / 255, EEVEEMOD.RGB.G / 255, EEVEEMOD.RGB.B / 255, entColor.A, 0, 0, 0)
end

---@type SlotVariant[]
EEVEEMOD.SlotVariant = {
	POKE_STOP = Isaac.GetEntityVariantByName("Poke Stop")
}

---@type SoundEffect[]
EEVEEMOD.SoundEffect = {
	SWIFT_FIRE = Isaac.GetSoundIdByName("Swift Fire"),
	SWIFT_HIT = Isaac.GetSoundIdByName("Swift Hit"),
	POKEBALL_CLICK = Isaac.GetSoundIdByName("Poke Ball Click"),
	POKEBALL_ROLL = Isaac.GetSoundIdByName("Poke Ball Roll"),
	POKEBALL_OPEN = Isaac.GetSoundIdByName("Poke Ball Open"),
	EXP_GAIN = Isaac.GetSoundIdByName("EXP Gain"),
	EXP_LEVELUP = Isaac.GetSoundIdByName("EXP Level Up"),
	SHINY_APPEAR = Isaac.GetSoundIdByName("Shiny Appear"),
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
	[VeeHelper.TearVariant.FETUS] = true,
}

---@type TrinketType[]
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

---@type TearVariant[]
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
	[VeeHelper.TearVariant.FETUS] = Color(1, 1, 1, 1, 0, 0, 0),
}

return EEVEEMOD
