local swiftAttack = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")
local swiftLaser = require("src_eevee.attacks.eevee.swiftLaser")
local swiftKnife = require("src_eevee.attacks.eevee.swiftKnife")
local swiftBomb = require("src_eevee.attacks.eevee.swiftBomb")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")

-----------------------
--  LOCAL FUNCTIONS  --
-----------------------

local function CalculateSwiftStats(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local count = 5
	local degreeOfWeaponSpawns = 360 / count
	local offset = VeeHelper.GetIsaacShootingDirection(player):Rotated(-1 * degreeOfWeaponSpawns):GetAngleDegrees()
	local duration = swiftBase:SwiftFireDelay(player) * count
	local isConstant = false

	swiftPlayer.AttackDuration = duration
	swiftPlayer.AttackDurationSet = duration
	swiftPlayer.RateOfOrbitRotation = 0
	swiftPlayer.Instance = { degreeOfWeaponSpawns, offset }
	swiftPlayer.NumWeaponsSpawned = 1
	swiftPlayer.TimeTillNextWeapon = swiftBase:SwiftFireDelay(player)
	swiftPlayer.MultiShots = swiftSynergies:MultiShotCountInit(player)

	if swiftBase:SwiftShouldBeConstant(player) then
		isConstant = true
	end
	swiftPlayer.Constant = isConstant

	if isConstant then
		swiftPlayer.ConstantFiring = true
	end
end

local function FireKnifeBrim(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
		and player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		if swiftPlayer
			and swiftPlayer.NumWeaponsSpawned
			and swiftPlayer.NumWeaponsSpawned > 0
		then
			local knivesSpawned = swiftPlayer.NumWeaponsSpawned
			for i = 1, knivesSpawned do
				local degrees = Vector.FromAngle(((360 / knivesSpawned) * i))
				local direction = VeeHelper.AddTearVelocity(degrees, player.ShotSpeed * 10, player, false)
				swiftAttack:FireExtraWeapon(player, player, direction)
			end
		end
	end
end

local function TriggerSwiftCooldown(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if swiftPlayer.AttackDuration <= 0.5
		and not swiftPlayer.AttackCooldown then
		FireKnifeBrim(player)
	end

	swiftPlayer.AttackDuration = 0
	swiftPlayer.NumWeaponsSpawned = 0

	if not swiftPlayer.AttackCooldown then
		if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
			swiftPlayer.AttackCooldown = 5
		else
			swiftPlayer.AttackCooldown = (swiftBase:SwiftFireDelay(player) * 2.5) + 0.5
		end
		swiftPlayer.ExistingShots = nil
	end
end

local function TriggerSwiftCooldownIfPlayerStopsShooting(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE)
		and player:GetFireDirection() == Direction.NO_DIRECTION
		and swiftPlayer
		and ((swiftPlayer.Constant == false and swiftPlayer.AttackDuration > 0)
			or (swiftPlayer.Constant == true and swiftPlayer.ConstantFiring == true)) then
		FireKnifeBrim(player)
		TriggerSwiftCooldown(player)
		swiftPlayer.ConstantFiring = false
	end
end

local function SwiftWeaponUpdateSynergies(weapon, player)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	swiftSynergies:ChocolateMilkDamageScaling(weapon, player)
	swiftSynergies:DelayTearFlags(weapon)
	swiftSynergies:AntiGravityDuration(player, weapon)

	if swiftSynergies:ShouldAttachTech2Laser(weapon, player)
		and swiftWeapon.ShotDir
		and not swiftWeapon.Tech2Attached
		and weapon.Type ~= EntityType.ENTITY_LASER
	then
		swiftWeapon.Tech2Attached = true
		swiftLaser:FireTechLaser(weapon, player, swiftWeapon.ShotDir, true)
	end
end

local function ShouldWizShot(player)
	local shouldWiz = false
	if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
		or player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY)
	then
		shouldWiz = true
	end
	return shouldWiz
end

local function UpdateDurationWithFirerate(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if swiftPlayer.AttackDuration > 0 then
		local expectedDuration = swiftBase:SwiftFireDelay(player) * 5

		if swiftPlayer.AttackDurationSet ~= expectedDuration then
			if expectedDuration < swiftPlayer.AttackDurationSet then
				local firerateDif = swiftPlayer.AttackDurationSet - expectedDuration
				swiftPlayer.AttackDuration = swiftPlayer.AttackDuration - firerateDif
			else
				local firerateDif = expectedDuration - swiftPlayer.AttackDurationSet
				swiftPlayer.AttackDuration = swiftPlayer.AttackDuration + firerateDif
			end
			swiftPlayer.AttackDurationSet = expectedDuration
			swiftPlayer.TimeTillNextWeapon = swiftBase:SwiftFireDelay(player)
		end
	end
end

------------------
--  MAIN STUFF  --
------------------

function swiftAttack:SpawnSwiftWeapon(player, degreeOfWeaponSpawns, offset)
	if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		swiftKnife:SpawnSwiftKnives(player, degreeOfWeaponSpawns, offset)
	elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
		swiftBomb:SpawnSwiftBombs(player, degreeOfWeaponSpawns, offset)
	elseif (
		player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
			or player:HasWeaponType(WeaponType.WEAPON_LASER)
			or player:HasWeaponType(WeaponType.WEAPON_TECH_X)
		)
	then
		swiftLaser:SpawnSwiftLasers(player, degreeOfWeaponSpawns, offset)
	elseif player:HasWeaponType(WeaponType.WEAPON_TEARS)
		or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
		swiftTear:SpawnSwiftTears(player, degreeOfWeaponSpawns, offset)
	end
end

function swiftAttack:SwiftMainFireWeapon(weapon, player)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local fireDirection = VeeHelper.AddTearVelocity(swiftWeapon.ShotDir, player.ShotSpeed * 10, player, true)
	--[[
	if player:GetEffects():HasNullEffect(NullItemID.ID_WIZARD) then
		if not swiftPlayer.WizardShot then
			swiftPlayer.WizardShot = 45
		else
			swiftPlayer.WizardShot = swiftPlayer.WizardShot * -1
		end
	else
		swiftPlayer.WizardShot = 0
	end]]

	--Loki's Horns, Mom's Eye, Eye Sore, Monstro's Lung
	if not swiftWeapon.IsMultiShot then
		if not swiftPlayer.Constant or (swiftPlayer.Constant and not player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)) then
			swiftAttack:ShouldFireExtraWeapons(weapon, player, fireDirection)
		end
	end

	--Wiz rotation
	if ShouldWizShot(player)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		fireDirection = fireDirection:Rotated(45)
	end

	if not swiftWeapon.ConstantOrbit then
		if not swiftBase:IsSwiftLaserEffect(weapon) then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
				weapon.Velocity = swiftBase:TryFireToEnemy(player, weapon, fireDirection)
			else
				weapon.Velocity = Vector.Zero
				swiftWeapon.AntiGravTimer = 90
				swiftWeapon.AntiGravDir = fireDirection
				if weapon.Type == EntityType.ENTITY_TEAR then
					swiftWeapon.AntiGravHeight = weapon.Height
				end
			end
		else
			weapon.Velocity = Vector.Zero
		end
	else
		if not swiftPlayer.Constant then
			weapon.Velocity = swiftBase:TryFireToEnemy(player, weapon, fireDirection)
		end
		swiftAttack:FireExtraWeapon(weapon, player, fireDirection)
	end

	--Wiz opposite rotation
	if ShouldWizShot(player)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		fireDirection = fireDirection:Rotated(-90)
	end

	--Wiz "normal" shot
	if ShouldWizShot(player) then
		swiftAttack:FireExtraWeapon(weapon, player, swiftBase:TryFireToEnemy(player, weapon, fireDirection))
		if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ) >= 2
			or player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
			swiftAttack:FireExtraWeapon(weapon, player, swiftBase:TryFireToEnemy(player, weapon, fireDirection:Rotated(45)))
		end
	end

	if swiftPlayer.Constant == true then
		swiftWeapon.ShotDelay = swiftBase:SwiftShotDelay(weapon, player)
	end
end

function swiftAttack:FireExtraWeapon(parent, player, direction, rotationOffset)
	if (
		parent.Type ~= EntityType.ENTITY_EFFECT
			or (parent.Type == EntityType.ENTITY_EFFECT and swiftBase:IsSwiftLaserEffect(parent))--No Evil Eye!
		) then
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			swiftKnife:FireSwiftKnife(parent, player, direction)
		elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			swiftBomb:FireSwiftBomb(parent, player, direction)
		elseif player:HasWeaponType(WeaponType.WEAPON_LASER)
			or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
			or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
			local ptrHashParent = tostring(GetPtrHash(parent))
			local swiftParent = swiftBase.Weapon[ptrHashParent]
			swiftLaser:FireSwiftLaser(parent, player, VeeHelper.AddTearVelocity(swiftParent.ShotDir, player.ShotSpeed * 10, player, false), rotationOffset)
		elseif player:HasWeaponType(WeaponType.WEAPON_TEARS)
			or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
			swiftTear:FireSwiftTear(parent, player, direction)
		end
	end
end

function swiftAttack:ShouldFireExtraWeapons(weapon, player, direction)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS)
		and swiftSynergies:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_LOKIS_HORNS) == true
	then
		for i = 1, 3 do
			local rotationOffset = 90 * i
			direction = direction:Rotated(rotationOffset)
			swiftAttack:FireExtraWeapon(weapon, player, direction, rotationOffset)
		end
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE)
		and swiftSynergies:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_MOMS_EYE) == true
	then
		local rotationOffset = 180
		direction = direction:Rotated(rotationOffset)
		swiftAttack:FireExtraWeapon(weapon, player, direction, rotationOffset)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
		local WeaponTypeShotDegrees = {
			[WeaponType.WEAPON_BRIMSTONE] = 360,
			[WeaponType.WEAPON_KNIFE] = 360,
			[WeaponType.WEAPON_TECH_X] = 180,
			[WeaponType.WEAPON_LASER] = 60,
			[WeaponType.WEAPON_BOMBS] = 30,
		}
		for weaponType, degrees in pairs(WeaponTypeShotDegrees) do
			if player:HasWeaponType(weaponType) then
				for i = 1, EEVEEMOD.RandomNum(3, 5) do
					local rotationOffset = EEVEEMOD.RandomNum((degrees / -2), (degrees / 2))
					direction = direction:Rotated(rotationOffset)
					swiftAttack:FireExtraWeapon(weapon, player, direction, rotationOffset)
				end
			end
		end
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE)
		and swiftSynergies:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_EYE_SORE) == true
	then
		for i = 1, EEVEEMOD.RandomNum(3) do
			local rotationOffset = EEVEEMOD.RandomNum(360)
			direction = direction:Rotated(rotationOffset)
			swiftAttack:FireExtraWeapon(weapon, player, direction, rotationOffset)
		end
	end
end

function swiftAttack:SwiftAttackWaitingToFire(weapon, player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
		if weapon.Parent
			and weapon.Parent:ToTear()
			and weapon.Parent:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO)
		then
			local ludoTear = weapon.Parent:ToTear()
			weapon.Velocity = ludoTear.Position - (weapon.Position + swiftWeapon.PosToFollow:Resized(swiftWeapon.DistFromPlayer):Rotated(swiftPlayer.RateOfOrbitRotation))
		end
		if weapon.FrameCount > 1 and (not weapon.Parent or weapon.Parent:IsDead() or not weapon.Parent:Exists()) then
			swiftPlayer.AttackInit = false
			weapon:Remove()
		end
	elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM) then
		if swiftPlayer.RateOfOrbitRotation
			and swiftWeapon.PosToFollow
			and not swiftWeapon.IsMultiShot then
			weapon.Velocity = player.Position - (weapon.Position + swiftWeapon.PosToFollow:Resized(swiftWeapon.DistFromPlayer):Rotated(swiftPlayer.RateOfOrbitRotation))
		end
	else
		weapon.Position = player.Position + swiftWeapon.ShotDir:Resized(swiftWeapon.DistFromPlayer)
	end

	if not swiftPlayer.StarSword then
		swiftWeapon.ShotDir = VeeHelper.GetIsaacShootingDirection(player, weapon.Position)
	else
		swiftWeapon.ShotDir = swiftPlayer.StarSword.Dir
	end

	if swiftPlayer.AttackDuration
		and swiftPlayer.AttackDuration <= 0
		and not swiftWeapon.CanFire
	then
		swiftWeapon.CanFire = true
	end

	if player:IsDead()
		or (swiftWeapon.ConstantOrbit and not swiftPlayer.Constant)
		and not swiftWeapon.HasFired then
		if weapon.Type ~= EntityType.ENTITY_EFFECT then
			swiftBase:SwiftTearFlags(weapon, false, true)
		end
		swiftAttack:SwiftMainFireWeapon(weapon, player)
		swiftWeapon.HasFired = true
	end
end

function swiftAttack:SwiftAttackUpdate(weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if weapon.Type == EntityType.ENTITY_TEAR then
		swiftTear:SwiftTearUpdate(weapon)
	elseif weapon.Type == EntityType.ENTITY_LASER then
		swiftLaser:SwiftLaserUpdate(weapon)
	elseif (
		weapon.Type == EntityType.ENTITY_EFFECT
			and swiftBase:IsSwiftLaserEffect(weapon)
		) then
		swiftLaser:SwiftLaserEffectUpdate(weapon)
	elseif weapon.Type == EntityType.ENTITY_KNIFE then
		swiftKnife:SwiftKnifeUpdate(weapon)
	elseif weapon.Type == EntityType.ENTITY_BOMBDROP then
		swiftBomb:SwiftBombUpdate(weapon)
	end

	if VeeHelper.EntitySpawnedByPlayer(weapon, false) then

		local player = weapon.SpawnerEntity:ToPlayer()
		local ptrHashPlayer = tostring(GetPtrHash(player))
		local swiftPlayer = swiftBase.Player[ptrHashPlayer]

		if swiftPlayer and swiftWeapon then
			
			SwiftWeaponUpdateSynergies(weapon, player)
			swiftAttack:ShouldRestoreSwiftTrail(player, weapon)
			swiftAttack:SwiftMultiRotation(player, weapon)
			swiftBase:DelayFallingAcceleration(player, weapon)

			if not swiftWeapon.HasFired then
				swiftAttack:SwiftAttackWaitingToFire(weapon, player)

				if swiftWeapon.CanFire and not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then

					if not swiftPlayer.Constant or not swiftWeapon.ConstantOrbit then

						if swiftWeapon.ShotDelay <= 0 then

							if weapon.Type ~= EntityType.ENTITY_EFFECT then
								swiftBase:SwiftTearFlags(weapon, false, true)
							end
							swiftAttack:SwiftMainFireWeapon(weapon, player)
							swiftWeapon.HasFired = true
						end
					else
						if swiftWeapon.ShotDelay <= 0 then
							if swiftBase:IsSwiftLaserEffect(weapon) == "brim" then
								if not swiftWeapon.LaserHasFired then
									swiftAttack:SwiftMainFireWeapon(weapon, player)
								end
							else
								swiftAttack:SwiftMainFireWeapon(weapon, player)
							end
						end

						if player:GetFireDirection() == Direction.NO_DIRECTION then
							swiftWeapon.ConstantOrbit = false
							swiftWeapon.ShotDelay = 0
						end
					end
				end
			end
		end
	end
end

function swiftAttack:SwiftMultiRotation(player, weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftWeapon.IsMultiShot
		and weapon.Parent
		and weapon.Parent:Exists() then

		local ptrHashParent = tostring(GetPtrHash(weapon.Parent))
		local swiftParent = swiftBase.Weapon[ptrHashParent]

		if swiftParent and swiftParent.PosToFollow then

			local rate = swiftWeapon.MultiShotRotation - 15 * player.ShotSpeed
			if rate < 0 then rate = rate + 360 end
			swiftWeapon.MultiShotRotation = rate

			weapon.Velocity = weapon.Parent.Position - (weapon.Position + swiftParent.PosToFollow:Resized(swiftWeapon.DistFromStar):Rotated(swiftWeapon.MultiShotRotation))
		end
	end
end

function swiftAttack:ShouldRestoreWeapon(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if swiftPlayer
		and swiftPlayer.ExistingShots
	then
		for i = 1, #swiftPlayer.ExistingShots do
			if swiftPlayer.Constant
				and swiftPlayer.ConstantFiring
				and not swiftPlayer.AttackCooldown
				and player:GetFireDirection() ~= Direction.NO_DIRECTION
				and not swiftPlayer.ExistingShots[i]:Exists()
			then
				local originalNumSpawned = swiftPlayer.NumWeaponsSpawned
				swiftPlayer.NumWeaponsSpawned = i
				swiftAttack:SpawnSwiftWeapon(player, swiftPlayer.Instance[1], swiftPlayer.Instance[2])
				swiftPlayer.NumWeaponsSpawned = originalNumSpawned
			end
		end
	end
end

function swiftAttack:ShouldRestoreSwiftTrail(player, weapon)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftWeapon.Trail and not swiftWeapon.Trail:Exists() then
		if (not swiftPlayer.Constant) or (swiftPlayer.Constant and swiftWeapon.ConstantOrbit) then
			swiftBase:AddSwiftTrail(weapon, player)
		end
	end
end

function swiftAttack:SwiftInit(player)
	local playerType = player:GetPlayerType()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if playerType == EEVEEMOD.PlayerType.EEVEE
		and not EEVEEMOD.game:IsPaused()
		and swiftPlayer ~= nil then

		if not swiftSynergies:WeaponShouldOverrideSwift(player) then

			if VeeHelper.PlayerCanControl(player)
				and VeeHelper.IsSpritePlayingAnims(player:GetSprite(), VeeHelper.WalkAnimations) then --Cannot shoot if any other player animation if playing, which would normally interrupt firing.

				if player:GetFireDirection() ~= Direction.NO_DIRECTION
					and not swiftPlayer.AttackCooldown
					and swiftPlayer.AttackInit == false then
					CalculateSwiftStats(player)
					swiftAttack:SpawnSwiftWeapon(player, swiftPlayer.Instance[1], swiftPlayer.Instance[2])
					swiftPlayer.AttackInit = true
				end

				--Basic updates
				TriggerSwiftCooldownIfPlayerStopsShooting(player)
				swiftAttack:ShouldRestoreWeapon(player)

				--Updating Kidney Stone's Constant Fire Override
				if swiftBase:SwiftShouldBeConstant(player) == false
					and swiftPlayer.Constant
					and not swiftPlayer.KidneyTimer then
					swiftPlayer.Constant = false
				end

				--For sudden firerate changes
				UpdateDurationWithFirerate(player)
			end
		else
			if swiftPlayer.AttackDuration
				and swiftPlayer.AttackDuration > 0
				and not player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
				and not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE)
			then
				TriggerSwiftCooldown(player)
			end
			if not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) and swiftPlayer.Constant == true then
				swiftPlayer.Constant = false
			end
		end
	elseif playerType ~= EEVEEMOD.PlayerType.EEVEE then
		if swiftPlayer then
			TriggerSwiftCooldown(player)
			swiftPlayer = nil
		end
	end
end

function swiftAttack:SpiritSword(knife)
	local sprite = knife:GetSprite()
	local isPlaying = nil
	local anims = {
		"SpinRight",
		"SpinDown",
		"SpinLeft",
		"SpinUp"
	}
	local AnimToVector = {
		["SpinDown"] = Vector(0, 1),
		["SpinRight"] = Vector(1, 0),
		["SpinUp"] = Vector(0, -1),
		["SpinLeft"] = Vector(-1, 0)
	}
	if not VeeHelper.EntitySpawnedByPlayer(knife, false)
		or (knife.Variant ~= VeeHelper.KnifeVariant.SPIRIT_SWORD
			and knife.Variant ~= VeeHelper.KnifeVariant.TECH_SWORD)
	then
		return
	end
	local player = knife.SpawnerEntity:ToPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if not swiftPlayer then return end

	if not swiftPlayer.StarSword or not swiftPlayer.StarSword.Entity then
		for i = 1, #anims do
			if sprite:IsPlaying(anims[i]) then
				isPlaying = anims[i]
			end
		end
		if isPlaying ~= nil and knife.SubType == 4 then
			swiftPlayer.StarSword = {
				Entity = knife,
				Dir = AnimToVector[sprite:GetAnimation()]
			}
		end
	elseif swiftPlayer.StarSword.Entity.InitSeed == knife.InitSeed then
		if not swiftPlayer.AttackInit then
			swiftPlayer.AttackInit = true
			swiftPlayer.MultiShots = swiftSynergies:MultiShotCountInit(player)
			swiftPlayer.AttackDuration = 13
			swiftPlayer.AttackDurationSet = 13
			swiftPlayer.RateOfOrbitRotation = 0
			swiftPlayer.Constant = false
		end
		local degreeOfWeaponSpawns = 72 --(360/5)
		local offset = swiftPlayer.StarSword.Dir:Rotated(-1 * degreeOfWeaponSpawns):GetAngleDegrees()
		local spawnAtFrame = {
			3,
			6,
			9,
			11,
			13
		}
		for i = 1, #spawnAtFrame do
			if sprite:GetFrame() == spawnAtFrame[i] then
				swiftPlayer.NumWeaponsSpawned = i
				swiftTear:SpawnSwiftTears(player, degreeOfWeaponSpawns, offset)
				if i == 5 then
					swiftPlayer.StarSword.Entity = nil
				end
			end
		end
	end
end

function swiftAttack:ActivateConstantOnKidneyStone(tear)
	if tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() then return end
	local player = tear.SpawnerEntity:ToPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if not swiftPlayer then return end

	if swiftSynergies:IsKidneyStoneActive(tear, player) then
		swiftPlayer.Constant = true
		swiftPlayer.KidneyTimer = 345
		TriggerSwiftCooldown(player)
	end
end

function swiftAttack:postLudoTearReset(tear)
	local ptrHashWeapon = tostring(GetPtrHash(tear))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
	if swiftWeapon then
		swiftWeapon.Trail:Remove()
	else
		tear:GetData().BasicSwiftTrail:Remove()
	end
end

function swiftAttack:OnSwiftLudoUpdate(tear)
	local ptrHashWeapon = tostring(GetPtrHash(tear))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
	if (not swiftWeapon or not tear:GetData().BasicSwift) or not tear.SpawnerEntity or not tear.SpawnerEntity:ToPlayer() or not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then return end
	local player = tear.SpawnerEntity:ToPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if math.floor(tear.FrameCount / player.MaxFireDelay) ~= math.floor((tear.FrameCount - 1) / player.MaxFireDelay) then
		swiftAttack:postLudoTearReset(tear)
		swiftAttack:postFireTear(tear, player)
	end
end

local numCollect = 0

local function RemoveSwiftTears(swiftPlayer)
	for i, weapon in pairs(swiftPlayer.ExistingShots) do
		if weapon.FrameCount > 0 then
			weapon:Remove()
		end
	end
end

function swiftAttack:SwiftSpecialAttackKillSwitch(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if not swiftPlayer or not swiftPlayer.ExistingShots then return end

	if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) and numCollect ~= player:GetCollectibleCount() then
		numCollect = player:GetCollectibleCount()
		RemoveSwiftTears(swiftPlayer)
		TriggerSwiftCooldown(player)
	elseif not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) and numCollect ~= 0 then
		numCollect = 0
		RemoveSwiftTears(swiftPlayer)
		TriggerSwiftCooldown(player)
	end
	if not player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) and swiftPlayer.StarSword then
		swiftPlayer.StarSword = false
	end
end

function swiftAttack:SwiftLudovicoSpawn(ludoTear)
	if not ludoTear.SpawnerEntity or not ludoTear.SpawnerEntity:ToPlayer() or not ludoTear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then return end
	local player = ludoTear.SpawnerEntity:ToPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(ludoTear))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftPlayer and not swiftWeapon and swiftPlayer.AttackInit and ludoTear.Visible == true then
		if not ludoTear:GetData().BasicSwift then
			swiftBase:AssignBasicSwiftStar(ludoTear)
		end
	end

	if not swiftPlayer then return end

	if swiftPlayer and ludoTear.FrameCount > 0 then
		if not swiftPlayer.AttackInit then
			ludoTear.Visible = false
			ludoTear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			ludoTear.TearFlags = TearFlags.TEAR_LUDOVICO
			swiftPlayer.AttackInit = true
			swiftPlayer.MultiShots = swiftSynergies:MultiShotCountInit(player)
			swiftPlayer.AttackDuration = 0
			swiftPlayer.AttackDurationSet = 0
			swiftPlayer.RateOfOrbitRotation = 0
			swiftPlayer.Constant = true
			swiftPlayer.ConstantFiring = true
			local degreeOfWeaponSpawns = 72 --(360/5)
			local offset = Vector(0, 1):Rotated(-1 * degreeOfWeaponSpawns):GetAngleDegrees()
			for i = 1, 5 do
				swiftPlayer.NumWeaponsSpawned = i
				swiftTear:SpawnSwiftTears(player, degreeOfWeaponSpawns, offset)
			end
		end
	end
end

--------------
--  TIMERS  --
--------------

local function SwiftShotDebug(weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(weapon.Position)
	local shootDir = "nil"
	local hasTech2 = "false"
	local inConstantOrbit = "false"
	local shotdelay = "nil"
	local hasFired = "false"
	if swiftWeapon then
		if swiftWeapon.HasFired then
			hasFired = "true"
		end
		if swiftWeapon.ShotDelay then
			shotdelay = swiftWeapon.ShotDelay
		end
		if swiftWeapon.Tech2Attached then
			hasTech2 = "true"
		end
		if swiftWeapon.ShotDir then
			shootDir = Vector(math.floor(swiftWeapon.ShotDir.X), math.floor(swiftWeapon.ShotDir.Y))
		end
		if swiftWeapon.ConstantOrbit then
			inConstantOrbit = "true"
		end
		local fired = "false"
		if swiftWeapon.LaserHasFired then
			fired = "true"
		end
		--Isaac.RenderText(weapon:ToTear().Height, screenpos.X, screenpos.Y + 30, 1, 1, 1, 1)
		--Isaac.RenderText(shotdelay, screenpos.X, screenpos.Y + 30, 1, 1, 1, 1)
		--Isaac.RenderText(tostring(swiftWeapon.Timer), screenposW.X, screenposW.Y + 70, 1, 1, 1, 1)
		--Isaac.RenderText("Dir: "..tostring(shootDir.X)..", "..tostring(shootDir.Y), screenpos.X, screenpos.Y + 50, 1, 1, 1, 1)
		--Isaac.RenderText("Constant: "..inConstantOrbit, screenposW.X, screenposW.Y + 10, 1, 1, 1, 1)
		--Isaac.RenderText("Has Fired Laser: "..fired, screenposW.X, screenposW.Y + 50, 1, 1, 1, 1)
		--Isaac.RenderText("Tech 2: "..hasTech2, screenposW.X, screenposW.Y + 50, 1, 1, 1, 1)
	end
end

local function SwiftShotDelayTimer(player)
	local TypeToFind = {
		{ EntityType.ENTITY_TEAR, -1 },
		{ EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT },
		{ EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL },
		{ EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.EVIL_EYE },
		{ EntityType.ENTITY_KNIFE, -1 },
		{ EntityType.ENTITY_LASER, -1 },
		{ EntityType.ENTITY_BOMBDROP, -1 }
	}
	for i = 1, #TypeToFind do
		for _, weapon in pairs(Isaac.FindByType(TypeToFind[i][1], TypeToFind[i][2], 0)) do
			local ptrHashWeapon = tostring(GetPtrHash(weapon))
			local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

			local ptrHashPlayer = tostring(GetPtrHash(player))
			local swiftPlayer = swiftBase.Player[ptrHashPlayer]

			if swiftWeapon then
				if swiftWeapon.ShotDelay > 0
					and ((swiftPlayer.Constant == false and swiftWeapon.CanFire)
						or swiftPlayer.Constant == true) then
					swiftWeapon.ShotDelay = swiftWeapon.ShotDelay - 0.5
				end
				SwiftShotDebug(weapon)
			end
		end
	end
end

local function SwiftDurationHandle(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if swiftPlayer
		and swiftPlayer.AttackDuration
		and not swiftPlayer.AttackCooldown then

		local attackDuration = swiftPlayer.AttackDuration
		if attackDuration > 0.5 then
			attackDuration = attackDuration - 0.5
		else
			if swiftPlayer.NumWeaponsSpawned >= 5 then
				attackDuration = 0
				if not swiftPlayer.Constant then
					TriggerSwiftCooldown(player)
				end
			elseif player:GetFireDirection() ~= Direction.NO_DIRECTION and swiftPlayer.AttackInit == true then
				attackDuration = 0.5
			end
		end
		swiftPlayer.AttackDuration = attackDuration
	end
end

local function SwiftRateOfRotation(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local holdStarFrames = swiftBase:SwiftFireDelay(player) * 0.35
	if swiftPlayer
		and swiftPlayer.RateOfOrbitRotation
		and swiftPlayer.AttackDuration
		and ((not swiftPlayer.Constant and swiftPlayer.AttackDuration <= (swiftPlayer.AttackDurationSet - holdStarFrames))
			or (swiftPlayer.Constant))
	then
		local currentRotation = swiftPlayer.RateOfOrbitRotation
		local rateOfRotation = (8 * (player.ShotSpeed * (swiftPlayer.AttackDuration / swiftPlayer.AttackDurationSet)))
		if swiftPlayer.Constant == true then
			rateOfRotation = (5 * player.ShotSpeed)
		end
		if rateOfRotation <= 2 then rateOfRotation = 2 end
		currentRotation = currentRotation + rateOfRotation
		if currentRotation > 360 then currentRotation = currentRotation - 360 end
		swiftPlayer.RateOfOrbitRotation = currentRotation
	end
end

local function SwiftCooldownTimer(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if swiftPlayer.AttackCooldown then
		if swiftPlayer.AttackCooldown > 0 then
			swiftPlayer.AttackCooldown = swiftPlayer.AttackCooldown - 0.5
		else
			swiftPlayer.AttackCooldown = nil
			swiftPlayer.AttackInit = false
		end
	end
end

local function SwiftSpawningNextWeapon(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if swiftPlayer.AttackDuration
		and swiftPlayer.AttackDuration > 0
		and player:GetFireDirection() ~= Direction.NO_DIRECTION
	then
		if not swiftPlayer.TimeTillNextWeapon then return end
		if swiftPlayer.TimeTillNextWeapon > 0 then
			swiftPlayer.TimeTillNextWeapon = swiftPlayer.TimeTillNextWeapon - 0.5
		else
			if swiftPlayer.NumWeaponsSpawned < 5 then
				swiftPlayer.NumWeaponsSpawned = swiftPlayer.NumWeaponsSpawned + 1
				swiftAttack:SpawnSwiftWeapon(player, swiftPlayer.Instance[1], swiftPlayer.Instance[2])
				swiftPlayer.TimeTillNextWeapon = swiftBase:SwiftFireDelay(player)
			end
		end
	end
end

function swiftAttack:SwiftAttackTimers(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if VeeHelper.PlayerCanControl(player) and swiftPlayer then
		SwiftShotDelayTimer(player)
		SwiftDurationHandle(player)
		SwiftRateOfRotation(player)
		SwiftCooldownTimer(player)
		SwiftSpawningNextWeapon(player)
		swiftSynergies:KidneyStoneDuration(player)
	end
end

------------
--  MISC  --
------------

function swiftAttack:InitSwiftEvilEye(effect)

	if not effect.Parent or not effect.Parent:ToPlayer() then return end
	local player = effect.Parent:ToPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashEffect = tostring(GetPtrHash(effect))
	local swiftEffectWeapon = swiftBase.Weapon[ptrHashEffect]

	if effect.SpawnerEntity == nil and effect.SpawnerType == EntityType.ENTITY_NULL then
		effect.SpawnerEntity = effect.Parent
		effect.SpawnerType = EntityType.ENTITY_PLAYER
	end
	if swiftPlayer and not swiftEffectWeapon then
		swiftBase:AssignSwiftBasicData(effect, player, swiftBase:SpawnPos(player, swiftPlayer.Instance[1], swiftPlayer.Instance[2]))
		swiftBase:AddSwiftTrail(effect, player)
		local tC = effect:GetSprite().Color
		effect:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 15, 1, true, false)
	end
end

function swiftAttack:RespawnSwiftPerRoom(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	if swiftPlayer and EEVEEMOD.game:GetFrameCount() > 1 then
		if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
			swiftPlayer.AttackInit = false
		elseif swiftPlayer.NumWeaponsSpawned
			and swiftPlayer.NumWeaponsSpawned > 0 then
			local currentCount = swiftPlayer.NumWeaponsSpawned
			swiftPlayer.RespawnNewRoom = true
			for i = 1, currentCount do
				swiftPlayer.NumWeaponsSpawned = i
				swiftAttack:SpawnSwiftWeapon(player, swiftPlayer.Instance[1], swiftPlayer.Instance[2])
				EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
			end
			swiftPlayer.RespawnNewRoom = nil
		end
	end
end

local function SwiftBasicTrailUpdate(trail)
	local weapon = trail.Parent

	if trail.Parent then
		if not weapon:GetData().BasicSwift then return end
		local room = EEVEEMOD.game:GetRoom()
		local tC = trail.Color
		local tearHeightToFollow = (weapon:ToTear().Height * 0.4) - 15
		local sizeToFollow = weapon.Size * 0.5

		trail.SpriteScale = Vector(weapon.Size * 0.2, 1)
		trail.Position = Vector(weapon.Position.X, (weapon.Position.Y + tearHeightToFollow) - sizeToFollow) + weapon:ToTear().PosDisplacement

		if not room:IsPositionInRoom(trail.Position, -30) then
			trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 5, 2, true, false)
		end
	else
		if trail:GetData().SwiftTrail then
			trail:Remove()
		end
	end
end

function swiftAttack:SwiftTrailUpdate(trail)

	SwiftBasicTrailUpdate(trail)

	if trail.Parent and swiftBase.Weapon[tostring(GetPtrHash(trail.Parent))] then
		local weapon = trail.Parent
		local ptrHashWeapon = tostring(GetPtrHash(trail.Parent))
		local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
		local room = EEVEEMOD.game:GetRoom()
		local tC = trail.Color

		if trail:GetData().EeveeRGB == true then
			trail:SetColor(EEVEEMOD.GetRBG(tC), -1, -1, true, false)
		else
			local wC = weapon:GetSprite().Color
			if swiftBase:AreColorsDifferent(wC, trail:GetData().TrailColor)
				and swiftBase:AreColorsDifferent(wC, Color.Default) then
				trail:SetColor(wC, -1, 1, true, false)
			end
		end

		if not room:IsPositionInRoom(trail.Position, -30) then
			trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 5, 2, true, false)
		end
		local heightDif = 0
		if weapon.Type == EntityType.ENTITY_TEAR then
			local tearHeightToFollow = (weapon:ToTear().Height * 0.4) - 15
			local sizeToFollow = weapon.Size * 0.5
			trail.SpriteScale = Vector(weapon.Size * 0.2, 1)

			if swiftWeapon.IsFakeKnife then
				heightDif = 10
			end
			trail.Position = Vector(weapon.Position.X, (weapon.Position.Y + (tearHeightToFollow + heightDif)) - sizeToFollow) + weapon:ToTear().PosDisplacement
		else
			if weapon.Type == EntityType.ENTITY_EFFECT and weapon.Variant == EffectVariant.EVIL_EYE then
				heightDif = 20
			end
			trail.Position = Vector(weapon.Position.X, weapon.Position.Y + weapon.PositionOffset.Y - heightDif)
		end
	else
		if trail:GetData().SwiftTrail then
			trail:Remove()
		end
	end
end

-- DEBUG

function swiftAttack:onRender()
	local player = Isaac.GetPlayer()
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local cooldown = "nil"
	if swiftPlayer then
		if swiftPlayer.AttackCooldown then
			cooldown = swiftPlayer.AttackCooldown
		end
		local duration = "nil"
		if swiftPlayer.AttackDuration then
			duration = swiftPlayer.AttackDuration
		end
		local rotation = "nil"
		if swiftPlayer.RateOfOrbitRotation then
			rotation = swiftPlayer.RateOfOrbitRotation
		end
		local delaybetweenshots = "nil"
		if swiftPlayer.TimeTillNextWeapon then
			delaybetweenshots = swiftPlayer.TimeTillNextWeapon
		end
		local numtears = "nil"
		if swiftPlayer.NumWeaponsSpawned then
			numtears = swiftPlayer.NumWeaponsSpawned
		end
		local kidney = 0
		if swiftPlayer.KidneyTimer then
			kidney = swiftPlayer.KidneyTimer
		end
		--[[ if swiftPlayer.ExistingShots then
			for i = 1, #swiftPlayer.ExistingShots do
				if swiftPlayer.ExistingShots[i] ~= nil then
					local ptrHashWeapon = tostring(GetPtrHash(swiftPlayer.ExistingShots[i]))
					local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
					local playerShot = swiftPlayer.ExistingShots[i].SpawnerEntity:ToPlayer()
					local ptrHashPlayerShot = tostring(GetPtrHash(playerShot))
					local swiftPlayerShot = swiftBase.Player[ptrHashPlayerShot]
					local hasPlayer = "false"
					if swiftPlayerShot then
						hasPlayer = "true"
					end
					if swiftWeapon then
						Isaac.RenderText(i .. hasPlayer, 50, 25 + (25 * i), 1, 1, 1, 1)
					end
				end
			end
		end ]]
		--[[ Isaac.RenderText("Cooldown: " .. cooldown, 50, 50, 1, 1, 1, 1)
		Isaac.RenderText("Duration: " .. duration, 50, 70, 1, 1, 1, 1)
		Isaac.RenderText("Rotation: " .. rotation, 50, 90, 1, 1, 1, 1)
		Isaac.RenderText("Tear Spawn: " .. delaybetweenshots, 50, 110, 1, 1, 1, 1)
		Isaac.RenderText("Num Tears Spawned: " .. numtears, 50, 130, 1, 1, 1, 1)
		Isaac.RenderText("Kidney: " .. kidney, 50, 30, 1, 1, 1, 1) ]]
	end
end

return swiftAttack
