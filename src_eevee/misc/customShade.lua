local shadeEevee = {}

function shadeEevee:ReplaceShade(familiar)
	if familiar.SpawnerType == EntityType.ENTITY_PLAYER
	and EEVEEMOD.IsPlayerEeveeOrEvolved[familiar.SpawnerEntity:ToPlayer():GetPlayerType()]
	then
		local sprite = familiar:GetSprite()
		
		sprite:Load("gfx/familiar_shade_eevee.anm2", true)
	end
end

return shadeEevee