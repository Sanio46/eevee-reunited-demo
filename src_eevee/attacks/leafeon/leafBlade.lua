local leafBlade = {}

--Basic Dash needs an after-image and smooth vector transitioning similar to Mars (why don't I just use Mars? For more control I guess?)
--Bleeding enemies take more damage and spew out blood tears

local function TriggerLeafBlade(player)
	local data = player:GetData()
	player:SetColor(Color(1, 1, 1, 1, 0.5, 0.5, 0.5), 5, 1, false, false)
	data.LeafBladeDashDuration = 8
	data.LeafBladeDashIFrames = 8
end

function leafBlade:OnUse(itemID, itemRNG, player, flags, slot, varData)
	--[[ if itemID == EEVEEMOD.CollectibleType.LEAF_BLADE then
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_SWORD_SPIN)
		TriggerLeafBlade(player)
	end ]]
end

function leafBlade:CountdownTimer(player)
	--[[ local data = player:GetData()

	if data.LeafBladeDashDuration then
		if data.LeafBladeDashDuration > 0 then
			local moveDir = player:GetMovementVector()
			local rotation = moveDir:GetAngleDegrees()

			if not data.LastSavedDashRotation then
				data.LastSavedDashRotation = rotation

				if moveDir.X == 0 and moveDir.Y == 0 then
					data.LastSavedDashRotation = 90
				end
			else
				if moveDir.X ~= 0 or moveDir.Y ~= 0 then
					if math.abs(math.abs(moveDir:GetAngleDegrees()) - math.abs(data.LastSavedDashRotation)) <= 90 then
						data.LastSavedDashRotation = rotation
					end
				end
			end
			player.Velocity = Vector(15, 0):Rotated(data.LastSavedDashRotation)
			data.LeafBladeDashDuration = data.LeafBladeDashDuration - 1
		else
			data.LastSavedDashRotation = nil
		end
	end
	if data.LeafBladeDashIFrames then
		if data.LeafBladeDashIFrames > 0 then
			data.LeafBladeDashIFrames = data.LeafBladeDashIFrames - 1
		end
	end ]]
end

function leafBlade:LeafBladeCooldown(npc)
	--[[ local data = npc:GetData()

	if data.LeafBladeDamageCooldown then
		if data.LeafBladeDamageCooldown > 0 then
			data.LeafBladeDamageCooldown = data.LeafBladeDamageCooldown - 1
		else
			data.LeafBladeDamageCooldown = nil
		end
	end ]]
end

function leafBlade:SlashCollidedEnemy(npc, collider, low)
	--[[ local player = collider:ToPlayer()
	local pData = player:GetData()
	local nData = npc:GetData()

	if pData.LeafBladeDashDuration and pData.LeafBladeDashDuration > 0 then
		if not nData.LeafBladeDamageCooldown then
			nData.LeafBladeDamageCooldown = 10
			npc:TakeDamage(player.Damage * 3, 0, EntityRef(player), 50)
		end
		return true
	end ]]
end

local allowDamageFlagsBlitz = {
	DamageFlag.DAMAGE_DEVIL,
	DamageFlag.DAMAGE_INVINCIBLE,
	DamageFlag.DAMAGE_IV_BAG,
}

local allowDamageSlotVariantBlitz = {
	[VeeHelper.SlotVariant.BEGGAR_DEVIL] = true,
	[VeeHelper.SlotVariant.BLOOD_DONATION] = true,
	[VeeHelper.SlotVariant.CONFESSIONAL] = true,
}

function leafBlade:PreventDamageOnDash(ent, amount, flags, source, countdown)
	--[[ local data = ent:GetData()
	
	if data.LeafBladeDashIFrames and data.LeafBladeDashIFrames > 0 then
		local takeDamage = false

		for _, bypassFlags in pairs(allowDamageFlagsBlitz) do
			if flags | bypassFlags == flags then
				takeDamage = true
				break
			end
		end

		if source and source.Type == EntityType.ENTITY_SLOT
		and allowDamageSlotVariantBlitz[source.Variant] then
			takeDamage = true
		end

		return takeDamage
	end ]]
end

return leafBlade
