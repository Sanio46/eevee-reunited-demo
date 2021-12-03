local eeveeGhost = {}

function eeveeGhost:SpawnGhostEffect(player)
	local playerType = player:GetPlayerType()
	local spritePlayer = player:GetSprite()
	local dataPlayer = player:GetData()
	
	if playerType == EEVEEMOD.PlayerType.EEVEE and player:IsDead() then
		if not dataPlayer.EeveeGhostSpawned then
			local ghostEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.EEVEE_GHOST, 0, player.Position, Vector.Zero, nil)
			ghostEffect:GetSprite():Play(spritePlayer:GetAnimation(), true)
			dataPlayer.EeveeGhostSpawned = true
		end
	end
end

return eeveeGhost