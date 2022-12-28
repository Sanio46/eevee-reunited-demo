local sneakScarf = {}

---@param player EntityPlayer
function sneakScarf:ConfuseOutOfRangeEnemies(player)
	if not player:HasCollectible(EEVEEMOD.CollectibleType.SNEAK_SCARF) then return end

	for _, ent in pairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
		local npc = ent:ToNPC()

		if npc.Type ~= EntityType.ENITY_FIREPLACE
			and npc.Type ~= EntityType.ENTITY_SHOPKEEPER
			and npc.Position:DistanceSquared(player.Position) >= 200 ^ 2 then
			if not npc:GetData().SneakScarfAvoid then
				npc:AddConfusion(EntityRef(player), 1, true)
			end
		else
			npc:GetData().SneakScarfAvoid = true
		end
	end
end

---@param player EntityPlayer
---@param itemStats ItemStats
function sneakScarf:Stats(player, itemStats)
	if player:HasCollectible(EEVEEMOD.CollectibleType.SNEAK_SCARF) then
		itemStats.SPEED = itemStats.SPEED + (0.3 * player:GetCollectibleNum(EEVEEMOD.CollectibleType.SNEAK_SCARF))
	end
end

return sneakScarf
