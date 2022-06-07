local eeveeGhost = {}

---@param player EntityPlayer
function eeveeGhost:SpawnGhostEffect(player)
	local playerType = player:GetPlayerType()
	local sprite = player:GetSprite()
	local data = player:GetData()

	if playerType == EEVEEMOD.PlayerType.EEVEE
		and player:IsDead()
		and (
		sprite:IsPlaying("Death")
			or sprite:IsPlaying("LostDeath")
			or sprite:IsPlaying("HoleDeath")
		)
	then
		if not data.EeveeGhostSpawned then
			---@type EntityEffect
			local ghostEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.EEVEE_GHOST, 0, player.Position, Vector.Zero, player):ToEffect()
			local sprite = ghostEffect:GetSprite()
			sprite:Play(sprite:GetAnimation(), true)
			data.EeveeGhostSpawned = true
		end
	end
end

---@param effect EntityEffect
function eeveeGhost:KillOnVadeRetro(effect)
	if VeeHelper.EntitySpawnedByPlayer(effect) then
		local player = effect.SpawnerEntity:ToPlayer()
		local sprite = effect:GetSprite()
		local playerType = player:GetPlayerType()

		sprite:SetAnimation(sprite:GetAnimation(), false) --For like a really specific instance if the death animation changes mid-animation that i saw thanks to a twitter video 

		if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType]
			and player:IsDead()
			and VeeHelper.GetActiveSlots(player, CollectibleType.COLLECTIBLE_VADE_RETRO)[1] == ActiveSlot.SLOT_PRIMARY then
			local poofs = Isaac.FindByType(1000, 15)
			for i = 1, #poofs do
				local poof = poofs[i]
				local c = poof:GetSprite().Color

				if poof.Position.X == effect.Position.X
					and poof.Position.Y == effect.Position.Y
					and c.R == 1.5 and c.G == 1.5 and c.B == 1.5
				then
					effect:Remove()
				end
			end
		end
	end
end

return eeveeGhost
