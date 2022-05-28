local EeveeReunited = RegisterMod("Eevee: Reunited - Demo", 1)

--VERSION: 2.0.3

local json = nil

local SaveDataVer = 2.1

EeveeReunited.SavedData = {
	CustomDolly = false,
	ClassicVoice = false,
	UniqueBirthright = false,
	PassiveShiny = true,
	PlayerData = {},
	LilEeveeData = {},
	UnlockData_Eevee = {},
	UnlockData_Eevee_B = {},
	UnlockData_PokeyMansCrystal = false,
}

local Template_PlayerData = {
	CookieSpeed = 0,
	WonderLauncherWisps = {}
}

local Template_LilEeveeData = {
	Level = 1,
	Exp = {
		CurAmount = 0,
		Stored = 0,
		ForNextLevel = 0,
	},
	CurState = 0,
}

function EeveeReunited:init(j)

	json = j

	if not REPENTANCE then
		local str = "[Eevee: Reunited] Mod was disabled! This is a Repentance-only mod."
		Isaac.DebugString(str)
		print(str)
		return EeveeReunited
	end

	require("src_eevee.VeeHelper") --Creates VeeHelper global
	require("src_eevee.EeveeEnums") --Adds to existing EEVEEMOD global
	require("src_eevee.misc.achievementDisplayApi")

	local mods = "src_eevee.modsupport."
	require(mods .. "eid")
	require(mods .. "modConfigMenu")
	require(mods .. "sewingMachine")
	--require(mods .. "uniqueCharacterItems")

	if Encyclopedia then
		local encyclopedia = require(mods .. "encyclopedia")
		encyclopedia.Init(EeveeReunited)
		encyclopedia.AddEncyclopediaDescs()
	end

	local EeveeCallbacks = {
		"npcUpdate",
		"postUpdate",
		"postRender",
		"useItem",
		"postPeffectUpdate",
		"useCard",
		"familiarInit",
		"familiarUpdate",
		"evaluateCache",
		"postPlayerInit",
		"usePill",
		"entityTakeDamage",
		"inputAction",
		"postGameStarted",
		"preGameExit",
		"postNewLevel",
		"postNewRoom",
		"getShaderParams",
		"executeCmd",
		"postNpcInit",
		"preNpcCollision",
		"postPlayerUpdate",
		"prePlayerCollision",
		"postPlayerRender",
		"postPickupInit",
		"postPickupUpdate",
		"prePickupCollision",
		"postTearInit",
		"postTearUpdate",
		"preTearCollision",
		"postTearSplash",
		"preProjectileCollision",
		"postLaserInit",
		"postLaserUpdate",
		"postKnifeInit",
		"postKnifeUpdate",
		"postEffectInit",
		"postEffectUpdate",
		"postBombInit",
		"postBombUpdate",
		"postFireTear",
		"postEntityRemove",
		"postEntityKill"
	}

	EeveeReunited:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, EeveeReunited.LoadEeveeData)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, EeveeReunited.SaveEeveeData)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EeveeReunited.SaveEeveeData)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, EeveeReunited.CreatePersistentData)
	EeveeReunited:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, EeveeReunited.CreatePersistentLilEeveeData, EEVEEMOD.FamiliarVariant.LIL_EEVEE)

	--VeeHelper include in every file when full release comes because yeah
	local path = "src_eevee.callbacks."
	for _, callback in ipairs(EeveeCallbacks) do
		local callback = require(path .. callback)
		callback:init(EeveeReunited)
	end
end

function EeveeReunited:SaveEeveeData()
	if EEVEEMOD.shouldSaveData == true then
		EeveeReunited.SavedData.CustomDolly = EEVEEMOD.PERSISTENT_DATA.CustomDolly
		EeveeReunited.SavedData.ClassicVoice = EEVEEMOD.PERSISTENT_DATA.ClassicVoice
		EeveeReunited.SavedData.PassiveShiny = EEVEEMOD.PERSISTENT_DATA.PassiveShiny
		EeveeReunited.SavedData.UniqueBirthright = EEVEEMOD.PERSISTENT_DATA.UniqueBirthright
		EeveeReunited.SavedData.PlayerData = EEVEEMOD.PERSISTENT_DATA.PlayerData
		EeveeReunited.SavedData.UnlockData_Eevee = EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee
		EeveeReunited.SavedData.UnlockData_Eevee_B = EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B
		EeveeReunited.SavedData.UnlockData_PokeyMansCrystal = EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal
		EeveeReunited.SavedData.LilEeveeData = EEVEEMOD.PERSISTENT_DATA.LilEeveeData
		EeveeReunited.SavedData.SaveDataVer = SaveDataVer

		EeveeReunited:SaveData(json.encode(EeveeReunited.SavedData))
	end
end

---@param player EntityPlayer
function EeveeReunited:CreatePersistentData(player)
	local data = player:GetData()

	if EEVEEMOD.game:GetFrameCount() == 0 then
		EEVEEMOD.PERSISTENT_DATA.PlayerData = {}
		EEVEEMOD.PERSISTENT_DATA.LilEeveeData = {}
	end

	data.Identifier = tostring(VeeHelper.GetPlayerIdentifier(player))

	if data.Identifier ~= nil and EEVEEMOD.PERSISTENT_DATA.PlayerData[data.Identifier] == nil then
		EEVEEMOD.PERSISTENT_DATA.PlayerData[data.Identifier] = {}

		for variable, value in pairs(Template_PlayerData) do
			EEVEEMOD.PERSISTENT_DATA.PlayerData[data.Identifier][variable] = value
		end
	end
end

---@param familiar EntityFamiliar
function EeveeReunited:CreatePersistentLilEeveeData(familiar)
	local initSeed = tostring(familiar.InitSeed)
	if EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] == nil then
		EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] = {}
		EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Super = {}
		EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Ultra = {}

		for variable, value in pairs(Template_LilEeveeData) do
			EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Super[variable] = value
			EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Ultra[variable] = value
		end
	end
end

function EeveeReunited:LoadEeveeData()
	if EeveeReunited:HasData() then
		local newData = json.decode(EeveeReunited:LoadData())
		if not newData.SaveDataVer or newData.SaveDataVer ~= SaveDataVer then
			if newData.SaveDataVer and newData.SaveDataVer ~= SaveDataVer then
				local msg = "[Eevee: Reunited] !!SAVE DATA HAS BEEN RESET!! as result of a save data update. If you had unlocks, please use the 'eeveemod unlock' command!"
				Isaac.DebugString(msg)
				print(msg)
			end
			EeveeReunited.SavedData.SaveDataVer = SaveDataVer
			EeveeReunited:SaveData(json.encode(EeveeReunited.SavedData))
		else
			EeveeReunited.SavedData = newData
			EEVEEMOD.PERSISTENT_DATA.CustomDolly = EeveeReunited.SavedData.CustomDolly or false
			EEVEEMOD.PERSISTENT_DATA.ClassicVoice = EeveeReunited.SavedData.ClassicVoice or false
			EEVEEMOD.PERSISTENT_DATA.PassiveShiny = EeveeReunited.SavedData.PassiveShiny or true
			EEVEEMOD.PERSISTENT_DATA.UniqueBirthright = EeveeReunited.SavedData.UniqueBirthright or false
			EEVEEMOD.PERSISTENT_DATA.PlayerData = EeveeReunited.SavedData.PlayerData or EEVEEMOD.PERSISTENT_DATA.PlayerData
			EEVEEMOD.PERSISTENT_DATA.LilEeveeData = EeveeReunited.SavedData.LilEeveeData or EEVEEMOD.PERSISTENT_DATA.LilEeveeData
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee = EeveeReunited.SavedData.UnlockData_Eevee or EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B = EeveeReunited.SavedData.UnlockData_Eevee_B or EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B
			EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal = EeveeReunited.SavedData.UnlockData_PokeyMansCrystal or EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal
		end
	end
end

--[[ local tearsFired = 0
local entChecks = 0

function resetChecks()
	tearsFired = 0
	entChecks = 0
end

function EeveeReunited:postRender()
	local players = VeeHelper.GetAllPlayers()
	local totalChance = tearsFired > 0 and entChecks / tearsFired or 0
	for i = 1, #players do
		local player = players[i]
		local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(player.Position)
		local data = player:GetData()

		Isaac.RenderText("Tears Fired: "..tearsFired, 50, 50, 1, 1, 1, 1)
		Isaac.RenderText("Num things triggered: "..entChecks, 50, 70, 1, 1, 1, 1)
		Isaac.RenderText("Total Chance: "..totalChance, 50, 90, 1, 1, 1, 1)
	end
end
EeveeReunited:AddCallback(ModCallbacks.MC_POST_RENDER, EeveeReunited.postRender)

function EeveeReunited:postFireTear(tear)
	tearsFired = tearsFired + 1
end
EeveeReunited:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, EeveeReunited.postFireTear)

function EeveeReunited:postEntCheckInit(entity)
	entChecks = entChecks + 1
end
EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, EeveeReunited.postEntCheckInit, EffectVariant.RIFT) --Change this to whatever you're checking ]]

return EeveeReunited
