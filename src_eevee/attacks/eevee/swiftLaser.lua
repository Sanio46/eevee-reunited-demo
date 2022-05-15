local swiftLaser = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")

local function SwiftLaserType(player)
	if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
		return "techX"
	elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
		return "brim"
	elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
		return "laser"
	end
end

local function AssignSwiftLaserEffectData(player, effect, anglePos)

	swiftBase:AssignSwiftBasicData(effect, player, anglePos)

	local eC = effect.Color
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		effect:SetColor(EEVEEMOD.GetRBG(eC), -1, 1, false, false)
	else
		local tear = player:FireTear(effect.Position, Vector.Zero, Vector.Zero):ToTear()
		tear.CollisionDamage = 0
		local tC = tear:GetSprite().Color
		if swiftBase:AreColorsDifferent(eC, tC) == true then
			effect:SetColor(tC, -1, 1, false, false)
		else
			local colorRed = Color(1, 0, 0, 1, 0, 0, 0)
			effect:SetColor(colorRed, -1, 1, false, false)
		end
		tear:Remove()
	end
	--As theres a small delay on the manual Chocolate Milk synergy affecting the fired laser's collision damage,
	--If you fire fast enough you could potentially just fire a normal 3.5 damage attack. This prevents that.
	if SwiftLaserType(player) == "techX" then
		effect.CollisionDamage = effect.CollisionDamage * 0.25
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
		effect.CollisionDamage = effect.CollisionDamage * 0.1
	else
		effect.CollisionDamage = player.Damage
		if swiftBase:IsSwiftLaserEffect(effect) == "brim" then
			effect:GetSprite().Scale = Vector(0.7, 0.7)
		end
	end
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	effect.PositionOffset = Vector(0, -25)
end

function swiftLaser:SpawnSwiftLasers(player, degreeOfLaserSpawns, offset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local anglePos = swiftBase:SpawnPos(player, degreeOfLaserSpawns, offset)
	local laserVariant = nil

	if SwiftLaserType(player) == "brim"
		or (SwiftLaserType(player) == "techX" and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)) then
		laserVariant = EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL
	elseif SwiftLaserType(player) == "laser"
		or SwiftLaserType(player) == "techX" then
		laserVariant = EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT
	end

	if laserVariant ~= nil then
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, laserVariant, 0, player.Position + (anglePos:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, player):ToEffect()
		AssignSwiftLaserEffectData(player, effect, anglePos)
		effect.Parent = player
		swiftBase:AddSwiftTrail(effect, player)

		if swiftPlayer.MultiShots > 0 then
			local multiOffset = EEVEEMOD.RandomNum(360)
			for i = 1, swiftPlayer.MultiShots + swiftSynergies:BookwormShot(player) do
				local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
				local anglePosMulti = swiftBase:SpawnPosMulti(player, multiOffset, orbit, i)
				local effectMulti = Isaac.Spawn(EntityType.ENTITY_EFFECT, laserVariant, 0, effect.Position + (anglePosMulti:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, player):ToEffect()
				local dataMultiEffect = effectMulti:GetData()

				dataMultiEffect.IsMultiShot = true
				dataMultiEffect.MultiRotation = (360 / swiftPlayer.MultiShots) * i
				effectMulti.Parent = effect
				dataMultiEffect.MultiSwiftOrbitDistance = orbit
				AssignSwiftLaserEffectData(player, effectMulti, anglePosMulti)
				effectMulti:GetSprite().Scale = Vector(0.5, 0.5)
			end
		end
		swiftBase:AssignSwiftSounds(effect)
	end
end

function swiftLaser:TechXRadiusScaling(effect, player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashEffect = tostring(GetPtrHash(effect))
	local swiftEffectWeapon = swiftBase.Weapon[ptrHashEffect]
	local radius = 15

	if swiftPlayer
		and swiftPlayer.AttackDuration > 0
		and swiftPlayer.AttackDurationSet then
		radius = 15 + (45 * (swiftPlayer.AttackDurationSet - swiftPlayer.AttackDuration) / swiftPlayer.AttackDurationSet)
		if swiftEffectWeapon then
			swiftEffectWeapon.TechXRadius = radius
		end
	end
end

function swiftLaser:TechXDamageScaling(weapon, player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftWeapon then
		if swiftPlayer.AttackDuration > 0
			and swiftPlayer.AttackDurationSet
			and not swiftWeapon.HasFired then
			local damageMult = 0.25 + (3 * (swiftPlayer.AttackDurationSet - swiftPlayer.AttackDuration) / swiftPlayer.AttackDurationSet)
			local damageCalc = player.Damage * damageMult
			if damageCalc < 0.1 then
				weapon.CollisionDamage = 0.1
			elseif damageCalc > player.Damage then
				weapon.CollisionDamage = player.Damage
			else
				weapon.CollisionDamage = damageCalc
			end
		end
	end
end

function swiftLaser:FireTechXLaser(parent, player, direction, knifeOverride)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashParent = tostring(GetPtrHash(parent))
	local swiftParent = swiftBase.Weapon[ptrHashParent]
	local damageMult = knifeOverride and player.Damage * 0.25 or parent.CollisionDamage / player.Damage
	local radius = knifeOverride and 25 or swiftPlayer.Constant and 15 or swiftParent.TechXRadius or 15

	if damageMult == 0 then
		damageMult = 0.25
	end

	local techX = player:FireTechXLaser(parent.Position, VeeHelper.AddTearVelocity(direction, player.ShotSpeed * 10, player, true), radius, player, damageMult):ToLaser()
	swiftBase:InitSwiftWeapon(techX)
	local ptrHashLaser = tostring(GetPtrHash(techX))
	local swiftLaser = swiftBase.Weapon[ptrHashLaser]

	if knifeOverride then
		techX.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	end

	swiftLaser.Player = player
	techX.Parent = parent
end

function swiftLaser:FireBrimLaser(parent, player, direction, rotationOffset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashParent = tostring(GetPtrHash(parent))
	local swiftParent = swiftBase.Weapon[ptrHashParent]
	local damageMult = player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) and (parent.CollisionDamage / player.Damage) or 1

	local brim = player:FireBrimstone(direction, parent, damageMult):ToLaser()
	swiftBase:InitSwiftWeapon(brim)
	local ptrHashLaser = tostring(GetPtrHash(brim))
	local swiftLaser = swiftBase.Weapon[ptrHashLaser]

	brim.Parent = parent
	brim.PositionOffset = Vector(0, -23)
	swiftLaser.Player = player

	if swiftPlayer.Constant == true then
		swiftLaser.IsConstantLaser = true
		swiftParent.LaserHasFired = true
		if rotationOffset then
			swiftLaser.ConstantRotationOffset = rotationOffset
		else
			swiftLaser.ConstantRotationOffset = 0
		end
	end
end

function swiftLaser:FireTechLaser(parent, player, direction, isTech2)
	local damageMult = player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) and (parent.CollisionDamage / player.Damage) or 1

	if isTech2 then
		damageMult = 0.8
	end

	local laser = player:FireTechLaser(parent.Position, LaserOffset.LASER_TRACTOR_BEAM_OFFSET, direction, false, false, parent, damageMult):ToLaser()
	swiftBase:InitSwiftWeapon(laser)
	local ptrHashLaser = tostring(GetPtrHash(laser))
	local swiftLaser = swiftBase.Weapon[ptrHashLaser]

	swiftLaser.Player = player
	laser.Parent = parent
	laser.PositionOffset = Vector(0, -23)

	if isTech2 then
		swiftLaser.IsTech2 = true
		laser.Timeout = 3
		if not swiftLaser.ConstantRotationOffset then
			swiftLaser.ConstantRotationOffset = 0
		end
	end
end

function swiftLaser:FireSwiftLaser(parent, player, direction, rotationOffset)
	if SwiftLaserType(player) == "techX" then
		swiftLaser:FireTechXLaser(parent, player, direction)
	elseif SwiftLaserType(player) == "brim" then
		swiftLaser:FireBrimLaser(parent, player, direction, rotationOffset)
	elseif SwiftLaserType(player) == "laser" then
		swiftLaser:FireTechLaser(parent, player, direction)
	end
end

local LaserEffectSize = {
	[EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT] = 20,
	[EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL] = 35,
}

function swiftLaser:SwiftLaserEffectUpdate(effect)
	if not VeeHelper.EntitySpawnedByPlayer(effect, true) then return end

	local player = effect.SpawnerEntity:ToPlayer()
	local ptrHashEffect = tostring(GetPtrHash(effect))
	local swiftEffectWeapon = swiftBase.Weapon[ptrHashEffect]

	if not swiftEffectWeapon then return end

	if SwiftLaserType(player) == "techX" then
		swiftLaser:TechXDamageScaling(effect, player)
		swiftLaser:TechXRadiusScaling(effect, player)
	elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
		effect.CollisionDamage = player.Damage
	end

	local scale = effect:GetSprite().Scale.X

	for _, ent in pairs(Isaac.FindInRadius(effect.Position, scale * LaserEffectSize[effect.Variant], EntityPartition.ENEMY)) do
		if ent:IsActiveEnemy(false) and ent:IsVulnerableEnemy() and effect.FrameCount % 3 == 0 then
			ent:TakeDamage(effect.CollisionDamage, DamageFlag.DAMAGE_LASER, EntityRef(player), 50)
		end
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		effect:SetColor(EEVEEMOD.GetRBG(effect.Color), -1, 1, false, false)
	end
	
	
	if not swiftEffectWeapon.HasFired then
		effect.Timeout = 2
	else
		local fireDirection = swiftEffectWeapon.ShotDir

		if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
			and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			fireDirection = fireDirection:Rotated(45)
		end

		if not swiftEffectWeapon.LaserHasFired then
			if swiftBase:IsSwiftLaserEffect(effect) == "tech" then
				swiftLaser:FireSwiftLaser(effect, player, fireDirection)
			elseif swiftBase:IsSwiftLaserEffect(effect) == "brim" then
				swiftLaser:FireSwiftLaser(effect, player, fireDirection)
			end
			swiftEffectWeapon.LaserHasFired = true
		end
		
		if swiftEffectWeapon.ConstantOrbit then
			if player:GetFireDirection() ~= Direction.NO_DIRECTION then
				effect.Timeout = 2
			end
		end
	end

end

function swiftLaser:SwiftLaserUpdate(laser)

	if not laser.Parent or not swiftBase.Weapon[tostring(GetPtrHash(laser.Parent))] then return end

	local ptrHashLaser = tostring(GetPtrHash(laser))
	local swiftLaserWeapon = swiftBase.Weapon[ptrHashLaser]
	local player = swiftLaserWeapon.Player
	local parent = laser.Parent
	local ptrHashParent = tostring(GetPtrHash(parent))
	local swiftParent = swiftBase.Weapon[ptrHashParent]

	if not swiftLaserWeapon then return end

	if laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR then
		laser.Position = parent.Position
	end

	swiftSynergies:TechXKnifeUpdate(laser, parent)

	if (swiftLaserWeapon.IsTech2 and not swiftParent.HasFired)
		or (swiftLaserWeapon.IsConstantLaser and player:GetFireDirection() ~= Direction.NO_DIRECTION
			and swiftParent.ConstantOrbit)
	then
		if laser.Variant == VeeHelper.LaserVariant.BRIMSTONE then
			laser.Timeout = 7
		else
			laser.Timeout = 3
		end
		if swiftLaserWeapon.ConstantRotationOffset then
			laser.Angle = swiftParent.ShotDir:Rotated(swiftLaserWeapon.ConstantRotationOffset):GetAngleDegrees()
		end
	end
end

return swiftLaser
