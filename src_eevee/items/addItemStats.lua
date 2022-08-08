local addItemStats = {}

function addItemStats:OnCache(player, cacheFlag, itemStats)
	if cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + itemStats.SPEED
	end
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * itemStats.FIREDELAY
	end
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = (player.Damage * itemStats.DAMAGE_MULT) + itemStats.DAMAGE_FLAT
	end
	if cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + (itemStats.RANGE * 40)
	end
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		player.ShotSpeed = player.ShotSpeed + itemStats.SHOTSPEED
	end
	if cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + itemStats.LUCK
	end
end

return addItemStats
