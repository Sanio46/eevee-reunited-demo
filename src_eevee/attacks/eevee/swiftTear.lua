local swiftTear = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")

local function AssignSwiftTearData(player, tear, anglePos)
	swiftBase:AssignSwiftBasicData(tear, player, anglePos)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local tC = tear:GetSprite().Color

	swiftBase:SwiftTearFlags(tear, false, false)
	if swiftPlayer.Constant == true then
		swiftBase:SwiftTearFlags(tear, true, false)
	end
	local invisTime = swiftPlayer.StarSword and 1 or 15
	tear:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), invisTime, 1, true, false)
end

function swiftTear:FireSwiftTear(tearParent, player, direction)
	local tear = player:FireTear((tearParent.Position - player.TearsOffset), direction, true, false, true, player):ToTear()
	local pC = tearParent:GetSprite().Color
	swiftBase:InitSwiftWeapon(tear)
	local ptrHashTear = tostring(GetPtrHash(tear))
	local swiftTear = swiftBase.Weapon[ptrHashTear]

	swiftTear.HasFired = true
	swiftSynergies:EyeItemDamageChance(player, tear)
	swiftBase:AssignSwiftSprite(tear)
	swiftBase:AddSwiftTrail(tear, player)
	swiftBase:SwiftTearFlags(tear, true, true)
	tear:SetColor(Color(pC.R, pC.G, pC.B, 1, pC.RO, pC.GO, pC.BO), -1, 1, true, false)
	if tearParent.FrameCount < 15 then
		local invisTime = tearParent.FrameCount
		tear:SetColor(Color(pC.R, pC.G, pC.B, 0, pC.RO, pC.GO, pC.BO), 15 - invisTime, 1, true, false)
	end
	swiftBase:AssignSwiftSounds(tear)
end

function swiftTear:SpawnSwiftTears(player, degreeOfTearSpawns, offset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local anglePos = swiftBase:SpawnPos(player, degreeOfTearSpawns, offset)
	local startingPos = player.Position - player.TearsOffset
	local ludoTearEntity = nil
	local damageMult = player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) and player.Damage * 0.5 or 1
	if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
		for _, tears in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR)) do
			local ludoTear = tears:ToTear()
			local ptrHashWeapon = tostring(GetPtrHash(ludoTear))
			local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
			if not swiftWeapon
				and ludoTear.SpawnerEntity
				and ludoTear.SpawnerEntity:ToPlayer()
				and ludoTear.SpawnerEntity:ToPlayer():GetData().Identifier == player:GetData().Identifier
				and ludoTear:HasTearFlags(TearFlags.TEAR_LUDOVICO)
			then
				ludoTearEntity = ludoTear
				startingPos = ludoTear.Position
			end
		end
	end
	local tear = player:FireTear(startingPos + (anglePos:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, true, false, true, player, damageMult):ToTear()
	local dataTear = tear:GetData()
	if dataTear.BasicSwift then dataTear.BasicSwift = nil end

	if ludoTearEntity then
		tear.Parent = ludoTearEntity
		tear:AddTearFlags(TearFlags.TEAR_LUDOVICO)
	end

	swiftSynergies:EyeItemDamageChance(player, tear)
	AssignSwiftTearData(player, tear, anglePos)
	swiftBase:AssignSwiftSprite(tear)
	swiftBase:AddSwiftTrail(tear, player)

	if swiftPlayer.MultiShots > 0 and not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
		local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 1, swiftPlayer.MultiShots + swiftSynergies:BookwormShot(player) do
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePosMulti = swiftBase:SpawnPosMulti(player, multiOffset, orbit, i)
			local tearMulti = player:FireTear((tear.Position - player.TearsOffset) + (anglePosMulti:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, true, false, true, player, damageMult):ToTear()
			local dataMultiTear = tearMulti:GetData()

			if dataMultiTear.BasicSwift then dataMultiTear.BasicSwift = nil end

			if ludoTearEntity then
				tear:AddTearFlags(TearFlags.TEAR_LUDOVICO)
			end

			dataMultiTear.IsMultiShot = true
			dataMultiTear.MultiRotation = (360 / swiftPlayer.MultiShots) * i
			tearMulti.Parent = tear
			dataMultiTear.MultiSwiftOrbitDistance = orbit
			swiftSynergies:EyeItemDamageChance(player, tearMulti)
			AssignSwiftTearData(player, tearMulti, anglePosMulti)
			swiftBase:AssignSwiftSprite(tearMulti)
			tearMulti:SetSize(tear.Size / 2, Vector(0.5, 0.5), 8)
		end
	end
	swiftBase:AssignSwiftSounds(tear)
end

function swiftTear:RemoveSpiritProjectile(tear)

	if not VeeHelper.EntitySpawnedByPlayer(tear, false) then return end

	local player = tear.SpawnerEntity:ToPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if not swiftPlayer then return end
	local multi = swiftSynergies:MultiShotCountInit(player)
	if multi then return end
	if (
		tear.Variant == TearVariant.SWORD_BEAM
			or tear.Variant == TearVariant.TECH_SWORD_BEAM
		)
		and player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
	then
		tear:Remove()
	end
end

function swiftTear:MakeSwiftTear(tear)
	if not tear.SpawnerEntity then return end
	local player = tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar().Player
	if not player then return end
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if not swiftPlayer then return end

	local dataTear = tear:GetData()

	if (tear.FrameCount > 0 and VeeHelper.IsTearFromFamiliar(tear))
		or VeeHelper.IsSplitTear(tear) then
		if not dataTear.BasicSwift
			and not VeeHelper.TearVariantBlacklist[tear.Variant]
		then
			dataTear.BasicSwift = true
			swiftBase:AssignSwiftSprite(tear)
			local c = tear:GetSprite().Color
			if c.A ~= 1 then
				tear.Color = Color(c.R, c.G, c.B, 1, c.RO, c.GO, c.BO)
			end
		end
	end
end

local function BasicSwiftRotation(tear)
	local dataTear = tear:GetData()
	local sprite = tear:GetSprite()

	if not dataTear.BasicSwift then return end

	dataTear.SwiftRotation = not dataTear.SwiftRotation and 0 or dataTear.SwiftRotation + 10
	sprite.Rotation = (dataTear.SwiftRotation * -2)
end

function swiftTear:SwiftTearUpdate(tear)
	local ptrHashTear = tostring(GetPtrHash(tear))
	local swiftTearWeapon = swiftBase.Weapon[ptrHashTear]
	local sprite = tear:GetSprite()

	if not VeeHelper.EntitySpawnedByPlayer(tear, true) then return end

	local player = tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar().Player
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	BasicSwiftRotation(tear)

	if tear.Variant == EEVEEMOD.TearVariant.SWIFT or tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD then
		local anim = tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD and "BloodTear" or "RegularTear"
		local animToPlay = anim .. VeeHelper.TearScaleToSizeAnim(tear)

		if tear.FrameCount > 1 and sprite:GetAnimation() ~= animToPlay then
			sprite:Play(anim .. VeeHelper.TearScaleToSizeAnim(tear), true)
		end
	end

	if not swiftTearWeapon then return end

	if not swiftTearWeapon.HasFired then
		if swiftTearWeapon.HoldTearHeight then
			tear.Height = swiftTearWeapon.HoldTearHeight
		end
	end

	if tear.StickTarget then return end

	if tear.Variant == TearVariant.ICE or tear.Variant == TearVariant.COIN then
		local sprite = sprite
		if not swiftTearWeapon.HasFired then
			sprite.Rotation = swiftTearWeapon.ShotDir:GetAngleDegrees()
		else
			if swiftTearWeapon.AntiGravDir then
				sprite.Rotation = swiftTearWeapon.AntiGravDir:GetAngleDegrees()
			end
		end
	elseif tear.Variant ~= TearVariant.BELIAL then
		if not swiftTearWeapon.HasFired then
			sprite.Rotation = (swiftPlayer.RateOfOrbitRotation * -2)
		else
			if not swiftTearWeapon.AfterFireRotation then
				swiftTearWeapon.AfterFireRotation = sprite.Rotation
			else
				sprite.Rotation = swiftTearWeapon.AfterFireRotation
				swiftTearWeapon.AfterFireRotation = swiftTearWeapon.AfterFireRotation - 20
			end
		end
	end
end

function swiftTear:OnSwiftStarDestroy(tear, splashType)
	if tear.Variant ~= EEVEEMOD.TearVariant.SWIFT and tear.Variant ~= EEVEEMOD.TearVariant.SWIFT_BLOOD then return end

	if splashType == "Wall" then return end
	
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
	if not swiftBase:AreColorsDifferent(tear.Color, Color.Default) then
		color = EEVEEMOD.TrailColor[tear.Variant]
	else
		color = tear.Color
	end
	splash.Color = color
end

return swiftTear
