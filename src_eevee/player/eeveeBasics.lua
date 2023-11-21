local vee = require("src_eevee.VeeHelper")
local eeveeBasics = {}

local attackHelper = require("src_eevee.attacks.attackHelper")
local costumeProtector = require("src_eevee.player.characterCostumeProtector")
local miscMods = require("src_eevee.modsupport.miscModsOnPlayerInit")
local swiftBase = require("src_eevee.attacks.eevee.swiftBase")

---@param player EntityPlayer
function eeveeBasics:TryInitEevee(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if not data.IsEevee and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and not player:IsCoopGhost() then
		data.IsEevee = true
		miscMods:OnPlayerInit(player)
		vee.SetCanShoot(player, false)
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end

local EeveeToEsauJr = {}

---@param player EntityPlayer
function eeveeBasics:OnEsauJr(_, _, player, _, _, _)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		table.insert(EeveeToEsauJr, data.Identifier)
	end
end

---@param player EntityPlayer
function eeveeBasics:GiveEsauJrEeveeData(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if #EeveeToEsauJr > 0 and EeveeToEsauJr[1] ~= nil then
		if EeveeToEsauJr == data.Identifier
			and not data.IsEevee
			and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
			data.IsEevee = true
			vee.SetCanShoot(player, false)
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
			costumeProtector:InitPlayerCostume(player)
			table.remove(EeveeToEsauJr, 1)
		end
	end
end

---@param player EntityPlayer
function eeveeBasics:NoTainted(player)
	local playerType = player:GetPlayerType()

	if playerType == EEVEEMOD.PlayerType.EEVEE_B then
		player:ChangePlayerType(EEVEEMOD.PlayerType.EEVEE)
		eeveeBasics:TryInitEevee(player)
	end
end

---@param player EntityPlayer
function eeveeBasics:TryDeinitEevee(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if data.IsEevee and not EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		data.IsEevee = false
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
		swiftBase.Players[tostring(GetPtrHash(player))] = nil
		vee.SetCanShoot(player, true)
	end
end

---@param player EntityPlayer
function eeveeBasics:TrackFireDirection(player)
	attackHelper:GetIsaacShootingDirection(player, player.Position)
end

return eeveeBasics
