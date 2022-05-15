local eeveeBirthright = {}

--TODO: Wisp

function eeveeBirthright:GivePocketActive(player)
	local playerType = player:GetPlayerType()

	if playerType == EEVEEMOD.PlayerType.EEVEE
		and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		and player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= EEVEEMOD.Birthright.TAIL_WHIP then
		player:SetPocketActiveItem(EEVEEMOD.Birthright.TAIL_WHIP, ActiveSlot.SLOT_POCKET, false)
	end
end

function eeveeBirthright:OnUse(itemID, itemRNG, player, flags, slot, vardata)
	if itemID == EEVEEMOD.Birthright.TAIL_WHIP then
		local tailWhip = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.TAIL_WHIP, 0, player.Position, Vector.Zero, player)
		local sprite = tailWhip:GetSprite()
		local tailWhipPath = "gfx/effects/tail_whip" .. VeeHelper.SkinColor(player, true) .. ".png"
		tailWhip:GetData().HitBoxRotation = 0
		tailWhip.Parent = player
		tailWhip:ToEffect():FollowParent(player)
		for i = 0, 2 do
			sprite:ReplaceSpritesheet(i, tailWhipPath)
		end
		sprite.Rotation = 180
		sprite:LoadGraphics()
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_SWORD_SPIN)
	end
end

local tailWhipPos = Vector(0, -30)
local tailWhipRadius = 50
local tailWhipHitCooldown = 10
local tailWhipWeaknessTimer = 120

function eeveeBirthright:OnEffectUpdate(effect)
	local data = effect:GetData()
	local sprite = effect:GetSprite()

	if sprite:IsFinished("SPEEEN") then
		effect:Remove()
	end

	if data.HitBoxRotation and sprite:WasEventTriggered("SwingStart") and not sprite:WasEventTriggered("SwingEnd") then

		for _, ent in pairs(Isaac.FindInRadius(effect.Position + tailWhipPos:Rotated(data.HitBoxRotation), tailWhipRadius, EntityPartition.ENEMY)) do
			if not ent:GetData().TailWhipCooldown then
				ent:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS | EntityFlag.FLAG_WEAKNESS)
				ent:AddVelocity((ent.Position - effect.Position):Normalized():Resized(80))
				ent:GetData().TailWhipCooldown = tailWhipHitCooldown
				ent:GetData().WeaknessCooldown = tailWhipWeaknessTimer
			end
		end

		for _, proj in pairs(Isaac.FindInRadius(effect.Position + tailWhipPos:Rotated(data.HitBoxRotation), tailWhipRadius, EntityPartition.BULLET)) do
			local projectile = proj:ToProjectile()
			if not projectile:GetData().TailWhipped then
				projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
				projectile:AddVelocity((proj.Position - effect.Position):Normalized():Resized(20))

				projectile:GetData().TailWhipped = true
			end
		end

		if data.HitBoxRotation < 360 then
			data.HitBoxRotation = data.HitBoxRotation + 48
		end
	end
end

function eeveeBirthright:TimeTillCanBeKnockedBack(npc)
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

return eeveeBirthright
