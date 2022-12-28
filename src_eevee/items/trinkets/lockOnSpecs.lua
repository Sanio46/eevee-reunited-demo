local lockOnSpecs = {}

function lockOnSpecs:Stats(player, itemStats)
	local lockOnStats = {
		DAMAGE_MULT = 1,
		RANGE = 3,
		SHOTSPEED = 0.3
	}
	if player:HasTrinket(EEVEEMOD.TrinketType.LOCKON_SPECS) then
		VeeHelper.MultiplyTrinketStats(lockOnStats, EEVEEMOD.TrinketType.LOCKON_SPECS, player)
		itemStats.DAMAGE_MULT = itemStats.DAMAGE_MULT + lockOnStats.DAMAGE_MULT
		itemStats.RANGE = itemStats.RANGE + lockOnStats.RANGE
		itemStats.SHOTSPEED = itemStats.SHOTSPEED + lockOnStats.SHOTSPEED
	end
end

function lockOnSpecs:DropChanceOnHit(ent, _, flags, _, _)
	local player = ent:ToPlayer()

	if player:HasTrinket(EEVEEMOD.TrinketType.LOCKON_SPECS)
		and (
		flags ~= flags | DamageFlag.DAMAGE_NO_PENALTIES
			or flags ~= flags | DamageFlag.DAMAGE_RED_HEARTS
		)
	then
		local effects = player:GetEffects()
		local lockonRNG = player:GetTrinketRNG(EEVEEMOD.TrinketType.LOCKON_SPECS)

		if effects:GetCollectibleEffectNum(EEVEEMOD.TrinketType.LOCKON_SPECS) >= (lockonRNG:RandomInt(10) + 1) then
			lockOnSpecs:DropTrinket(player)
		else
			local trinketMult = player:GetTrinketMultiplier(EEVEEMOD.TrinketType.LOCKON_SPECS)
			effects:AddCollectibleEffect(EEVEEMOD.TrinketType.LOCKON_SPECS, false, trinketMult)
		end
	end
end

function lockOnSpecs:DropTrinket(player)
	local effects = player:GetEffects()
	local velocityStrength = 7

	EEVEEMOD.sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
	player:TryRemoveTrinket(EEVEEMOD.TrinketType.LOCKON_SPECS)
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.LOCKON_SPECS_DROP, 0, player.Position,
		Vector(VeeHelper.RandomNum(velocityStrength) + 1, VeeHelper.RandomNum(velocityStrength) + 1), player)

	effects:RemoveCollectibleEffect(EEVEEMOD.TrinketType.LOCKON_SPECS, -1)
end

function lockOnSpecs:DestroySpecsPickup(effect)
	local sprite = effect:GetSprite()

	if sprite:IsEventTriggered("Disappear") then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
		effect:Remove()
	end
end

return lockOnSpecs
