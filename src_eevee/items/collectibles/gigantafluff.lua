local gigantafluff = {}

--Spawn clouds ala Toxic Shock/Butt Bombs for as long as its duration lasts

---@param player EntityPlayer
function gigantafluff:CharmEnemiesOnNewRoom(player)
	--[[ if player:HasCollectible(EEVEEMOD.CollectibleType.GIGANTAFLUFF) then
		local duration = player:GetHearts() > 1 and (player:GetHearts() * 15) or (2 * 30) --Minimum of 2 hearts duration regardless of low/no red health.
		for _, ent in ipairs(Isaac.GetRoomEntities()) do --FindInRadius doesn't make AddCharmed work for some dumbass reason lol
			if ent:IsActiveEnemy(false)
			and ent.Type ~= EntityType.ENTITY_FIREPLACE
			and ent.Type ~= EntityType.ENTITY_SHOPKEEPER
			and not ent:IsInvincible() then
				ent:AddCharmed(EntityRef(player), duration)
			end
		end
	end ]]
end

return gigantafluff
