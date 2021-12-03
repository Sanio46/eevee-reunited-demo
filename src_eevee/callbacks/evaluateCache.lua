local evaluateCache = {}

local eeveeStats = EEVEEMOD.Src["player"]["eeveeStats"]

function evaluateCache:main(player, cacheFlag)
	eeveeStats:onCache(player, cacheFlag)
end

return evaluateCache