local swiftTear = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")

---@param tear EntityTear
function swiftTear:AssignSwiftSprite(tear)

	if VeeHelper.TearVariantBlacklist[tear.Variant]
		or EEVEEMOD.KeepTearVariants[tear.Variant] then
		return
	end

	local tearSprite = tear:GetSprite()
	local dataTear = tear:GetData()
	local animationToPlay = VeeHelper.TearScaleToSizeAnim(tear)
	local variantToUse = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and "gfx/tear_swift.anm2" or EEVEEMOD.TearVariant.SWIFT

	if dataTear.ForceBlood or VeeHelper.TearFlagsBlood[tear.Variant] then
		animationToPlay = "BloodTear" .. animationToPlay
		variantToUse = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and "gfx/tear_swift_blood.anm2" or
			EEVEEMOD.TearVariant.SWIFT_BLOOD
	else
		animationToPlay = "RegularTear" .. animationToPlay
	end

	--So, for some dumb fuck reason, Ludo tears when updated entirely BREAK when having their variant changed. Can't damage anything and has strange collision with grid ents/walls.
	if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		---@cast variantToUse string
		tear:GetSprite():Load(variantToUse, true)
	else
		---@cast variantToUse integer
		tear:ChangeVariant(variantToUse)
	end

	tearSprite:Play(animationToPlay, true)
end

---@param player EntityPlayer
---@param tear EntityTear
---@param spawnPos Vector
---@param velocity Vector
function swiftTear:DecideForEvilEye(player, tear, spawnPos, velocity)
	---@type EntityTear | EntityEffect
	local tearOrEvilEye = tear
	if player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_EYE)
		and
		VeeHelper.DoesLuckChanceTrigger(3, 10, 1.5, player.Luck, player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_EVIL_EYE))
	then
		tearOrEvilEye = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EVIL_EYE, 0, spawnPos, velocity, player):ToEffect()
		tearOrEvilEye.Parent = player
		tear:Remove()
	end
	return tearOrEvilEye
end

---@param parent Entity
---@param player EntityPlayer
---@param direction Vector
function swiftTear:FireSwiftTear(parent, player, direction)
	---@type EntityTear | EntityEffect
	local tear = player:FireTear(parent.Position, direction, false, true, true, player,
		parent.CollisionDamage / player.Damage):ToTear()
	if tear.Height > -24 then tear.Height = -24 end

	tear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	tear:ClearTearFlags(TearFlags.TEAR_ORBIT)
	swiftBase:AddSwiftTrail(tear, player)
	swiftBase:PlaySwiftFireSFX(tear)
end

---@param swiftData SwiftInstance
---@param isMult boolean
function swiftTear:SpawnSwiftTears(swiftData, isMult)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local spawnPos = swiftBase:GetAdjustedStartingAngle(swiftData)
	---@type EntityTear | EntityEffect
	local tear = player:FireTear(parent.Position + spawnPos, Vector.Zero, false, false, true, player, 1):ToTear()
	if tear.Height > -24 then tear.Height = -24 end

	tear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	tear = swiftTear:DecideForEvilEye(player, tear, parent.Position, Vector.Zero)
	swiftBase:InitSwiftWeapon(swiftData, tear, isMult)
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param tear EntityTear
function swiftTear:SwiftTearUpdate(swiftData, swiftWeapon, tear)
	local sprite = tear:GetSprite()

	if tear.Variant == EEVEEMOD.TearVariant.SWIFT or tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD then
		local anim = tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD and "BloodTear" or "RegularTear"
		local animToPlay = anim .. VeeHelper.TearScaleToSizeAnim(tear)

		if tear.FrameCount > 1 and sprite:GetAnimation() ~= animToPlay then
			sprite:Play(anim .. VeeHelper.TearScaleToSizeAnim(tear), true)
		end
	end

	if not swiftWeapon.HasFired then
		tear.FallingSpeed = -0.1
		tear.FallingAcceleration = 0
		if swiftWeapon.FireDelay == 0 then
			tear.FallingSpeed = swiftWeapon.Special.StartingFall
			tear.FallingAcceleration = swiftWeapon.Special.StartingAccel
		end
	end
	if tear.Variant == TearVariant.ICE or tear.Variant == TearVariant.COIN then
		if not swiftWeapon.HasFired then
			sprite.Rotation = swiftWeapon.ShootDirection:GetAngleDegrees()
		end
	elseif tear.Variant ~= TearVariant.BELIAL then
		if not swiftWeapon.HasFired then
			sprite.Rotation = (swiftData.Rotation * -2)
		else
			local data = tear:GetData()
			if not data.AfterFireSwiftRotation then
				data.AfterFireSwiftRotation = sprite.Rotation
			else
				sprite.Rotation = data.AfterFireSwiftRotation
				data.AfterFireSwiftRotation = data.AfterFireSwiftRotation - 20
			end
		end
	end
end

function swiftTear:SPEEEN(tear)
	local sprite = tear:GetSprite()
	local data = tear:GetData()
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(tear))]

	if (tear.Variant == EEVEEMOD.TearVariant.SWIFT or tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD) and not swiftWeapon then
		if not data.BasicSwiftRotation then
			data.BasicSwiftRotation = sprite.Rotation
		else
			sprite.Rotation = data.BasicSwiftRotation
			data.BasicSwiftRotation = data.BasicSwiftRotation - 20
		end
	end
end

---@param tear EntityTear
function swiftTear:MakeStarOnTearInit(tear)
	if VeeHelper.EntitySpawnedByPlayer(tear) then

		local player = tear.SpawnerEntity:ToPlayer()
		local playerType = player:GetPlayerType()

		if playerType ~= EEVEEMOD.PlayerType.EEVEE
			or playerType == EEVEEMOD.PlayerType.EEVEE
			and (VeeHelper.TearVariantBlacklist[tear.Variant]
				or EEVEEMOD.KeepTearVariants[tear.Variant])
		then
			return
		end

		swiftTear:AssignSwiftSprite(tear)
		swiftBase:SwiftStarFireSFX()
	end
end

---@param tear EntityTear
function swiftTear:RemoveSpiritProjectile(tear)
	if not VeeHelper.EntitySpawnedByPlayer(tear) then return end

	local player = tear.SpawnerEntity:ToPlayer()
	local playerType = player:GetPlayerType()
	if playerType == EEVEEMOD.PlayerType.EEVEE
		and (
		tear.Variant == TearVariant.SWORD_BEAM
			or tear.Variant == TearVariant.TECH_SWORD_BEAM
		)
		and player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
	then
		tear:Remove()
	end
end

---@param tear EntityTear
---@param splashType string
function swiftTear:OnSwiftStarDestroy(tear, splashType)
	if tear.Variant ~= EEVEEMOD.TearVariant.SWIFT and tear.Variant ~= EEVEEMOD.TearVariant.SWIFT_BLOOD then return end

	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SWIFT_HIT)
	local splashPos = -15
	local poofToPlay = EffectVariant.TEAR_POOF_B
	if tear.Height < -4 and tear.Height > -5 then
		splashPos = 0
	end
	if tear.Scale > 0.55 then
		if splashType == "Collision" then
			poofToPlay = EffectVariant.TEAR_POOF_A
		end
	elseif tear.Scale < 0.3 then
		poofToPlay = EffectVariant.TEAR_POOF_SMALL
	else
		poofToPlay = EffectVariant.TEAR_POOF_VERYSMALL
	end
	local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, poofToPlay, 0, tear.Position, Vector.Zero, nil)
	local sprite = splash:GetSprite()
	sprite.Offset = Vector(0, splashPos)
	sprite.Scale = Vector(tear.Scale, tear.Scale)
	local color = Color.Default
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(tear))]

	if swiftWeapon
		and swiftWeapon.Trail and swiftWeapon.Trail:Exists()
		and (
		swiftWeapon.Trail:GetData().EeveeEntHasColorCycle
			or tear.SpawnerEntity:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
		) then
		color = swiftWeapon.Trail.Color
	elseif not VeeHelper.AreColorsDifferent(tear.Color, Color.Default) then
		color = EEVEEMOD.TrailColor[tear.Variant]
	else
		color = tear.Color
	end
	splash.Color = color
end

return swiftTear
