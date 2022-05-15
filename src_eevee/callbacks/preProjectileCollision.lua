local preProjectileCollision = {}

local alertSpecs = require("src_eevee.items.trinkets.alertSpecs")
local badEgg = require("src_eevee.items.collectibles.badEgg")

function preProjectileCollision:main(proj, collider)
	if collider.Type == EntityType.ENTITY_PLAYER then
		alertSpecs:OnCollisionGreedProjectile(proj, collider)
	end
	badEgg:BlockProjectile(proj, collider)
end

function preProjectileCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, preProjectileCollision.main)
end

return preProjectileCollision
