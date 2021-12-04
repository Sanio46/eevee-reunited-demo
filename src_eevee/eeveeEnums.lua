local EEVEEMOD = {}

EEVEEMOD.game = Game()
EEVEEMOD.sfx = SFXManager()
EEVEEMOD.isNewGame = false
EEVEEMOD.Name = "Eevee: Reunited - Character Demo"

EEVEEMOD.RandomRNG = RNG()
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

EEVEEMOD.CollectibleType = {
	TAIL_WHIP = Isaac.GetItemIdByName("Tail Whip"),
}

EEVEEMOD.Data = {
	CustomDolly = false,
	CustomSpiritSword = true,
}

EEVEEMOD.EffectVariant = {
	CUSTOM_BRIMSTONE_SWIRL = Isaac.GetEntityVariantByName("Custom Brimstone Swirl"),
	CUSTOM_TECH_DOT = Isaac.GetEntityVariantByName("Custom Tech Dot"),
	EEVEE_GHOST = Isaac.GetEntityVariantByName("Eevee Ghost"),
	TAIL_WHIP = Isaac.GetEntityVariantByName("Tail Whip"),
}

EEVEEMOD.KnifeVariant = {
	MOMS_KNIFE = 0,
	BONE = 1,
	BONE_KNIFE = 2,
	JAWBONE = 3,
	BAG_OF_CRAFTING = 4,
	SUMPTORIUM = 5,
	NOTCHED_AXE = 9,
	SPIRIT_SWORD = 10,
	TECH_SWORD = 11,
}

EEVEEMOD.PlayerType = {
	EEVEE = Isaac.GetPlayerTypeByName("Eevee"),
}

EEVEEMOD.PlayerTypeToString = {
	[EEVEEMOD.PlayerType.EEVEE] = "eevee",
}

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

EEVEEMOD.IsPlayerEeveeOrEvolved = {
	[EEVEEMOD.PlayerType.EEVEE] = true,
}

EEVEEMOD.LaserVariant = {
	BRIMSTONE = 1,
	TECHNOLOGY = 2,
	SHOOP = 3,
	PRIDE = 4,
	ANGEL = 5,
	MEGA = 6,
	BIG_BRIMSTONE = 11
}

EEVEEMOD.RGB = {
	R = 255,
	G = 0,
	B = 0,
}

EEVEEMOD.SkinColorToString = {
	[SkinColor.SKIN_PINK] = "",
	[SkinColor.SKIN_WHITE] = "_white",
	[SkinColor.SKIN_BLACK] = "_black",
	[SkinColor.SKIN_BLUE] = "_blue",
	[SkinColor.SKIN_RED] = "_red",
	[SkinColor.SKIN_GREEN] = "_green",
	[SkinColor.SKIN_GREY] = "_grey",
	[SkinColor.SKIN_SHADOW] = "_shadow"
}

return EEVEEMOD
