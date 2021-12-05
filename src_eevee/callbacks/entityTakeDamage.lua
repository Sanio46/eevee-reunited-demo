local entityTakeDamage = {}

local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]
local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]

function entityTakeDamage:main(ent, amount, flags, source, countdown)
	if ent.Type == EntityType.ENTITY_PLAYER and ent:ToPlayer() ~= nil then
		eeveeBasics:EeveeOnHurt(ent, amount, flags, source, countdown)
		ccp:AstralProjectionOnHit(ent, amount, flags, source, countdown)
	end
end

return entityTakeDamage