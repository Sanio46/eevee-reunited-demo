local sneakScarf = {}

function sneakScarf:ConfuseOutOfRangeEnemies(player)
	if not player:HasCollectible(EEVEEMOD.CollectibleType.SNEAK_SCARF) then return end

	for _, enemies in pairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
		local ent = enemies:ToNPC()

		if ent.Position:DistanceSquared(player.Position) >= 200 ^ 2 then
			if not ent:GetData().SneakScarfAvoid then
				ent:AddConfusion(EntityRef(player), 1, true)
			end
		else
			ent:GetData().SneakScarfAvoid = true
		end
	end
end

function sneakScarf:Stats(player, itemStats)
	if player:HasCollectible(EEVEEMOD.CollectibleType.SNEAK_SCARF) then
		itemStats.SPEED = itemStats.SPEED + 0.3
	end
end

return sneakScarf
