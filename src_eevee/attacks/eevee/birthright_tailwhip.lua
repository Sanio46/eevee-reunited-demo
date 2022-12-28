local tailWhip = {}

---@param player EntityPlayer
function tailWhip:GivePocketActive(player)
	local playerType = player:GetPlayerType()

	if playerType == EEVEEMOD.PlayerType.EEVEE
		and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		and player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= EEVEEMOD.CollectibleType.TAIL_WHIP then
		player:SetPocketActiveItem(EEVEEMOD.CollectibleType.TAIL_WHIP, ActiveSlot.SLOT_POCKET, false)
	end
end

---@param itemID CollectibleType
---@param player EntityPlayer
function tailWhip:OnUse(itemID, _, player, _, _, _)
	if itemID == EEVEEMOD.CollectibleType.TAIL_WHIP then
		local tailWhipSpin = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.TAIL_WHIP, 0, player.Position,
			Vector.Zero, player):ToEffect()
		local sprite = tailWhipSpin:GetSprite()
		local data = tailWhipSpin:GetData()
		local characterSpecial = {
			[PlayerType.PLAYER_BLUEBABY] = "bluebaby",
			[PlayerType.PLAYER_BLUEBABY_B] = "bluebaby",
			[PlayerType.PLAYER_KEEPER] = "keeper",
			[PlayerType.PLAYER_KEEPER_B] = "keeper",
			[PlayerType.PLAYER_APOLLYON] = "apollyon",
			[PlayerType.PLAYER_APOLLYON_B] = "apollyon",
			[PlayerType.PLAYER_THEFORGOTTEN] = "forgotten",
		}
		local tailWhipSpinPath = "gfx/effects/tailwhip.png"
		local playerType = player:GetPlayerType()

		if characterSpecial[playerType] ~= nil then
			tailWhipSpinPath = string.gsub(tailWhipSpinPath, ".png", "_" .. characterSpecial[playerType] .. ".png")
		end
		if characterSpecial[playerType] == nil or characterSpecial[playerType] == "apollyon" then
			tailWhipSpinPath = string.gsub(tailWhipSpinPath, ".png", VeeHelper.SkinColor(player, true) .. ".png")
		end
		data.HitBoxRotation = 0
		tailWhipSpin.Parent = player
		tailWhipSpin:FollowParent(player)
		for i = 0, 2 do
			sprite:ReplaceSpritesheet(i, tailWhipSpinPath)
		end
		sprite.Rotation = 180
		sprite:LoadGraphics()
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_SWORD_SPIN)

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
			data.TailWhipWisps = {}
			for i = 1, 5 do
				local posInLine = i * -20
				local wisp = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, CollectibleType.COLLECTIBLE_HOW_TO_JUMP,
					player.Position, Vector.Zero, player):ToFamiliar()
				wisp:GetData().TailWhipPosition = Vector(0, posInLine)
				table.insert(data.TailWhipWisps, wisp)
				wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				wisp.MaxHitPoints = 10
				wisp:AddHealth(10)
			end
		end
	end
end

local tailWhipPos = Vector(0, -30)
local tailWhipRadius = 50
local tailWhipHitCooldown = 10
local tailWhipWeaknessTimer = 120

---@param effect EntityEffect
function tailWhip:OnEffectUpdate(effect)
	local data = effect:GetData()
	local sprite = effect:GetSprite()

	if data.TailWhipWisps then
		for _, wisp in ipairs(data.TailWhipWisps) do
			if wisp:Exists() then
				local wispData = wisp:GetData()
				local wispVelExtension = wispData.TailWhipPosition
				if not sprite:WasEventTriggered("SwingStart") then
					wispVelExtension = VeeHelper.Lerp(Vector.Zero, wispData.TailWhipPosition, 0.3 * effect.FrameCount)
				elseif sprite:WasEventTriggered("SwingEnd") then
					wispVelExtension:Lerp(Vector.Zero, 0.3)
				end

				wisp.Velocity = effect.Position - (wisp.Position - wispVelExtension:Rotated(data.HitBoxRotation))
			end
		end
	end

	if sprite:IsFinished("SPEEEN") then
		if effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer() then
			local player = effect.SpawnerEntity:ToPlayer()
			player:GetEffects():RemoveCollectibleEffect(EEVEEMOD.CollectibleType.TAIL_WHIP)
		end
		if data.TailWhipWisps then
			for _, wisp in ipairs(data.TailWhipWisps) do
				wisp:Kill()
			end
		end
		effect:Remove()
	end

	if data.HitBoxRotation and sprite:WasEventTriggered("SwingStart") and not sprite:WasEventTriggered("SwingEnd") then


		for _, ent in pairs(Isaac.FindInRadius(effect.Position + tailWhipPos:Rotated(data.HitBoxRotation), tailWhipRadius,
			EntityPartition.ENEMY)) do
			if not ent:GetData().TailWhipCooldown then
				if ent.Type == EntityType.ENTITY_FIREPLACE then
					ent:TakeDamage(5, DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(effect.SpawnerEntity), 0)
				else
					ent:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS | EntityFlag.FLAG_WEAKNESS)
					ent:AddVelocity((ent.Position - effect.Position):Normalized():Resized(50))
					ent:GetData().TailWhipCooldown = tailWhipHitCooldown
					ent:GetData().WeaknessCooldown = tailWhipWeaknessTimer
				end
			end
		end

		for _, proj in pairs(Isaac.FindInRadius(effect.Position + tailWhipPos:Rotated(data.HitBoxRotation), tailWhipRadius,
			EntityPartition.BULLET)) do
			local projectile = proj:ToProjectile()
			if not projectile:GetData().TailWhipped then
				projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
				projectile:AddVelocity((proj.Position - effect.Position):Normalized():Resized(20))

				projectile:GetData().TailWhipped = true
			end
		end

		if data.HitBoxRotation < 360 then
			data.HitBoxRotation = data.HitBoxRotation + 45
		end
	end
end

---@param npc EntityNPC
function tailWhip:TimeTillCanBeKnockedBack(npc)
	local data = npc:GetData()

	if data.TailWhipCooldown then
		if data.TailWhipCooldown > 0 then
			data.TailWhipCooldown = data.TailWhipCooldown - 1
		else
			data.TailWhipCooldown = nil
		end
	end
	if data.WeaknessCooldown then
		if data.WeaknessCooldown > 0 then
			data.WeaknessCooldown = data.WeaknessCooldown - 1
		else
			npc:ClearEntityFlags(EntityFlag.FLAG_WEAKNESS | EntityFlag.FLAG_SLIPPERY_PHYSICS)
			data.WeaknessCooldown = nil
		end
	end
end

---@param player EntityPlayer
function tailWhip:CostumePlayerUpdate(player)
	local data = player:GetData()
	local effects = player:GetEffects()
	if player:HasCollectible(EEVEEMOD.CollectibleType.TAIL_WHIP)
		and not effects:HasCollectibleEffect(EEVEEMOD.CollectibleType.TAIL_WHIP)
		and not data.HasTailWhipCostume then
		data.HasTailWhipCostume = true
		player:AddNullCostume(EEVEEMOD.NullCostume.TAIL_WHIP)
	end
	if (not player:HasCollectible(EEVEEMOD.CollectibleType.TAIL_WHIP)
		or effects:HasCollectibleEffect(EEVEEMOD.CollectibleType.TAIL_WHIP)
		)
		and data.HasTailWhipCostume then
		data.HasTailWhipCostume = false
		player:TryRemoveNullCostume(EEVEEMOD.NullCostume.TAIL_WHIP)
	end
end

return tailWhip
