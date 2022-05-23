local eeveeBasics = {}

local costumeProtector = require("src_eevee.player.characterCostumeProtector")
local miscMods = require("src_eevee.modsupport.miscModsOnPlayerInit")
--local uniqueCharacterItems = require("src_eevee.modsupport.uniqueCharacterItems")

function eeveeBasics:TryInitEevee(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if not data.IsEevee and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and not player:IsCoopGhost() then

		data.IsEevee = true
		miscMods:addPogCompatibility()
		miscMods:addCoopGhostCompatibility()
		miscMods:addNoCostumesCompatibility()
		VeeHelper.SetCanShoot(player, false)
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()

	end
end

local EeveeToEsauJr = {}

function eeveeBasics:OnEsauJr(itemID, itemRNG, player, flags, slot, vardata)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		table.insert(EeveeToEsauJr, data.Identifier)
	end
end

function eeveeBasics:GiveEsauJrEeveeData(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if #EeveeToEsauJr > 0 and EeveeToEsauJr[1] ~= nil then
		if EeveeToEsauJr == data.Identifier
			and not data.IsEevee
			and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
			VeeHelper.SetCanShoot(player, false)
			data.IsEevee = true
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
			costumeProtector:InitPlayerCostume(player)
			table.remove(EeveeToEsauJr, 1)
		end
	end
end

function eeveeBasics:NoTainted(player)
	local playerType = player:GetPlayerType()

	if playerType == EEVEEMOD.PlayerType.EEVEE_B then
		player:ChangePlayerType(EEVEEMOD.PlayerType.EEVEE)
		eeveeBasics:TryInitEevee(player)
	end
end

function eeveeBasics:TryDeinitEevee(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if data.IsEevee and not EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		data.IsEevee = false
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end

function eeveeBasics:TrackFireDirection(player)
	local playerType = player:GetPlayerType()
	VeeHelper.GetIsaacShootingDirection(player, player.Position)
end

return eeveeBasics
