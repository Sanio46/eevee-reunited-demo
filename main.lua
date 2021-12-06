local EeveeReunited = RegisterMod("Eevee: Reunited - Character Demo", 1)

if not REPENTANCE then
	Isaac.DebugString("Eevee: Reunited was disabled! This is a Repentance-only mod.")
	print("Eevee: Reunited was disabled! This is a Repentance-only mod.")
	return
end

EEVEEMOD = include("src_eevee.eeveeEnums")
EEVEEMOD.API = include("src_eevee.eeveeApi")
--Current Version = 1.5

local EeveeLuas = {
	{"attacks", {
		"swift.swiftBase",
		"swift.swiftSynergies",
		"swift.swiftBomb",
		"swift.swiftKnife",
		"swift.swiftLaser",
		"swift.swiftTear",
		"swift.swiftAttack",
	},
	},
	{"items", {
		"collectibles.eeveeBirthright",
	},
	},
	{"misc", {
		"customMiniIsaac",
		"customShade",
		"rgbCycle",
	},
	},
	{"modsupport", {
		"customMrDolly",
		"customSpiritSword",
		"eid",
		"encyclopedia",
		"miscModsOnPlayerInit",
		"modConfigMenu",
	},
	},
	{"player", {
		"characterCostumeProtector",
		"eeveeBasics",
		"eeveeGhost",
		"eeveeStats",
		"itemEffectOnFire",
	},
	},
	{"callbacks", {
		"npcUpdate",
		"postUpdate",
		"postRender",
		"useItem",
		"postPeffectUpdate",
		"useCard",
		"familiarInit",
		"evaluateCache",
		"postPlayerInit",
		"usePill",
		"entityTakeDamage",
		"postGameStarted",
		"preGameExit",
		"postNewLevel",
		"postNewRoom",
		"postPlayerRender",
		"postPickupInit",
		"postTearInit",
		"postTearUpdate",
		"postLaserUpdate",
		"postKnifeInit",
		"postKnifeUpdate",
		"postEffectInit",
		"postEffectUpdate",
		"postBombUpdate",
	},
	},
}

EEVEEMOD.Src = {
	["attacks"] = {},
	["items"] = {},
	["misc"] = {},
	["modsupport"] = {},
	["player"]	= {},
	["callbacks"] = {},
}

local json = require("json")
EeveeReunited.SavedData = {}

function EeveeReunited:SaveEeveeData()
	EeveeReunited.SavedData.CustomDolly = EEVEEMOD.Data.CustomDolly
	EeveeReunited.SavedData.CustomSpiritSword = EEVEEMOD.Data.CustomSpiritSword
	
	EeveeReunited:SaveData(json.encode(EeveeReunited.SavedData))
end

function EeveeReunited:LoadEeveeData()
	EeveeReunited.SavedData = json.decode(EeveeReunited:LoadData())

	EEVEEMOD.Data.CustomDolly = EeveeReunited.SavedData.CustomDolly or false
	EEVEEMOD.Data.CustomSpiritSword = EeveeReunited.SavedData.CustomSpiritSword or true
end

if Isaac.HasModData(EeveeReunited) then
	EeveeReunited:LoadEeveeData()
end

--Partial thanks to Cucco for the basics of loading multiple files through a single table of strings
for i, luas in ipairs(EeveeLuas) do
	local basepath = luas[1]
	for j, luapath in ipairs(luas[2]) do
		local fullPath = "src_eevee."..basepath.."."..luapath
		EEVEEMOD.Src[basepath][luapath] = include(fullPath)
	end
end

EeveeReunited:AddCallback(ModCallbacks.MC_NPC_UPDATE, EEVEEMOD.Src["callbacks"]["npcUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_UPDATE, EEVEEMOD.Src["callbacks"]["postUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_RENDER, EEVEEMOD.Src["callbacks"]["postRender"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, EEVEEMOD.Src["callbacks"]["useItem"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EEVEEMOD.Src["callbacks"]["postPeffectUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_USE_CARD, EEVEEMOD.Src["callbacks"]["useCard"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, EEVEEMOD.Src["callbacks"]["familiarInit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EEVEEMOD.Src["callbacks"]["evaluateCache"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, EEVEEMOD.Src["callbacks"]["postPlayerInit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_USE_PILL, EEVEEMOD.Src["callbacks"]["usePill"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EEVEEMOD.Src["callbacks"]["entityTakeDamage"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, EEVEEMOD.Src["callbacks"]["postGameStarted"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, EEVEEMOD.Src["callbacks"]["preGameExit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EEVEEMOD.Src["callbacks"]["postNewLevel"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EEVEEMOD.Src["callbacks"]["postNewRoom"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, EEVEEMOD.Src["callbacks"]["postPlayerRender"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, EEVEEMOD.Src["callbacks"]["postPickupInit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, EEVEEMOD.Src["callbacks"]["postTearInit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, EEVEEMOD.Src["callbacks"]["postTearUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, EEVEEMOD.Src["callbacks"]["postLaserUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, EEVEEMOD.Src["callbacks"]["postKnifeInit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, EEVEEMOD.Src["callbacks"]["postKnifeUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, EEVEEMOD.Src["callbacks"]["postEffectInit"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EEVEEMOD.Src["callbacks"]["postEffectUpdate"].main)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, EEVEEMOD.Src["callbacks"]["postBombUpdate"].main)

EeveeReunited:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, EeveeReunited.SaveEeveeData)
EeveeReunited:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EeveeReunited.SaveEeveeData)

EeveeReunited:SaveEeveeData()