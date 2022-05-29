local preProjectileCollision = {}

local alertSpecs = require("src_eevee.items.trinkets.alertSpecs")
local badEgg = require("src_eevee.items.collectibles.badEgg")

---@param proj EntityProjectile
---@param collider Entity
function preProjectileCollision:main(proj, collider)
	if collider:ToPlayer() then
		local player = collider:ToPlayer()
		alertSpecs:OnCollisionGreedProjectile(proj, player)
	end
	badEgg:BlockProjectile(proj, collider)
end

function preProjectileCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, preProjectileCollision.main)
end

return preProjectileCollision
