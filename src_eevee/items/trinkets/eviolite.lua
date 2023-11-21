local eviolite = {}
local vee = require("src_eevee.veeHelper")

local function PlayerHasTransformation(player)
	local hasTransformation = false
	for i = 0, PlayerForm.NUM_PLAYER_FORMS do
		if player:HasPlayerForm(i) then
			hasTransformation = true
		end
	end
	if hasTransformation then
		return true
	else
		return false
	end
end

function eviolite:Stats(player, itemStats)
	local playerType = player:GetPlayerType()

	local evioliteStats = {
		[CacheFlag.CACHE_SPEED] = 0.2,
		[CacheFlag.CACHE_FIREDELAY] = -0.1,
		[CacheFlag.CACHE_DAMAGE] = 0.1,
		[CacheFlag.CACHE_RANGE] = 2,
		[CacheFlag.CACHE_SHOTSPEED] = 0.2,
	}

	local eeveeBonusStats = {
		[CacheFlag.CACHE_SPEED] = 0.4,
		[CacheFlag.CACHE_FIREDELAY] = -0.2,
		[CacheFlag.CACHE_DAMAGE] = 0.2,
		[CacheFlag.CACHE_RANGE] = 4,
		[CacheFlag.CACHE_SHOTSPEED] = 0.4,
	}

	if player:HasTrinket(EEVEEMOD.TrinketType.EVIOLITE)
		and not PlayerHasTransformation(player) then
		local statsToAdd = evioliteStats

		if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
			--statsToAdd = eeveeBonusStats
		end

		vee.MultiplyTrinketStats(statsToAdd, EEVEEMOD.TrinketType.EVIOLITE, player, 1.5, 2)

		if statsToAdd then
			itemStats.SPEED = itemStats.SPEED + statsToAdd[CacheFlag.CACHE_SPEED]
			itemStats.FIREDELAY = itemStats.FIREDELAY + statsToAdd[CacheFlag.CACHE_FIREDELAY]
			itemStats.DAMAGE_MULT = itemStats.DAMAGE_MULT + statsToAdd[CacheFlag.CACHE_DAMAGE]
			itemStats.RANGE = itemStats.RANGE + statsToAdd[CacheFlag.CACHE_RANGE]
			itemStats.SHOTSPEED = itemStats.SHOTSPEED + statsToAdd[CacheFlag.CACHE_SHOTSPEED]
		end
	end
end

function eviolite:DetectTransformationUpdate(player)
	local data = player:GetData()

	if player:HasTrinket(EEVEEMOD.TrinketType.EVIOLITE) then
		if PlayerHasTransformation(player) and not data.EvioliteDisabled then
			data.EvioliteDisabled = true
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end
	end
end

return eviolite
