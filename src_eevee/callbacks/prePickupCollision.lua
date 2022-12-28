local prePickupCollision = {}

local blackGlasses = require("src_eevee.items.collectibles.blackGlasses")
local pokeyMansCrystal = require("src_eevee.challenges.pokeyMansCrystal")

---@param item EntityPickup
---@param collider Entity
---@param low boolean
---@diagnostic disable-next-line: unused-local
function prePickupCollision:main(item, collider, low)
	if collider:ToPlayer() then
		local player = collider:ToPlayer()
		blackGlasses:OnCollectibleCollision(item, player)
	end
end

function prePickupCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, prePickupCollision.main, PickupVariant.PICKUP_COLLECTIBLE)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, pokeyMansCrystal.PrePickupCollision, PickupVariant.PICKUP_TROPHY)
end

return prePickupCollision
