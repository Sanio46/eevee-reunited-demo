local preTearCollision = {}

local lilEevee = require("src_eevee.items.collectibles.lilEevee")

function preTearCollision:main(tear, collider, low)
	lilEevee:OnLilLeafeonTearCollision(tear, collider, low)
end

function preTearCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, preTearCollision.main)
end

return preTearCollision
