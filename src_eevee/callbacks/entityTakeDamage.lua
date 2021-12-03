local entityTakeDamage = {}

local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]

function entityTakeDamage:main(ent, amount, flags, source, countdown)
	if ent.Type == EntityType.ENTITY_PLAYER and ent.ToPlayer then
		eeveeBasics:EeveeOnHurt(ent, amount, flags, source, countdown)
	end
end

return entityTakeDamage