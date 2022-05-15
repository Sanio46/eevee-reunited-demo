local prePickupCollision = {}

local blackGlasses = require("src_eevee.items.collectibles.blackGlasses")
local customCollectibleSprites = require("src_eevee.modsupport.customCollectibleSprites")

function prePickupCollision:main(item, collider, low)
	if collider:ToPlayer() then
		local player = collider:ToPlayer()
		blackGlasses:OnCollectibleCollision(item, player, low)
	end
end

function prePickupCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, prePickupCollision.main, PickupVariant.PICKUP_COLLECTIBLE)
end

return prePickupCollision
