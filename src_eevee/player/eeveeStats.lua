local eeveeStats = {}

local statsEevee = {
	[CacheFlag.CACHE_SPEED] = 0,
	[CacheFlag.CACHE_FIREDELAY] = 1,
	[CacheFlag.CACHE_DAMAGE] = 0.9,
	[CacheFlag.CACHE_RANGE] = 3,
	[CacheFlag.CACHE_SHOTSPEED] = 0.2,
	[CacheFlag.CACHE_LUCK] = 0,
}

local statsEeveelutions = {
	[EEVEEMOD.PlayerType.EEVEE] = statsEevee,
}

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function eeveeStats:OnCache(player, cacheFlag)
	local playerType = player:GetPlayerType()
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + statsEeveelutions[playerType][cacheFlag]
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay * statsEeveelutions[playerType][cacheFlag]
		end
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * statsEeveelutions[playerType][cacheFlag]
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + (statsEeveelutions[playerType][cacheFlag] * 40)
			if playerType == EEVEEMOD.PlayerType.EEVEE then
				player.TearFallingAcceleration = 0
			end
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + statsEeveelutions[playerType][cacheFlag]
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + statsEeveelutions[playerType][cacheFlag]
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
				or player:HasWeaponType(WeaponType.WEAPON_LASER) then
				---@diagnostic disable-next-line: assign-type-mismatch
				player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING | TearFlags.TEAR_SPECTRAL
			end
		end
	end
end

return eeveeStats