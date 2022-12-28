local swiftLaser = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")
local rgbCycle = require("src_eevee.misc.rgbCycle")

---@param player EntityPlayer
local function SwiftLaserType(player)
	if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
		return "techX"
	elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
		return "brim"
	elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
		return "laser"
	end
end

---@param swiftData SwiftInstance
---@param effect EntityEffect
local function AssignSwiftLaserEffectData(swiftData, effect)
	local player = swiftData.Player
	if not player then return end

	local eC = effect.Color

	if rgbCycle:shouldApplyColorCycle(player) then
		local colorCycle = player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) and EEVEEMOD.ColorCycle.RGB
			or player:HasCollectible(CollectibleType.COLLECTIBLE_CONTINUUM) and EEVEEMOD.ColorCycle.CONTINUUM
		rgbCycle:applyColorCycle(effect, colorCycle)
	else
		local tear = player:FireTear(effect.Position, Vector.Zero):ToTear()
		tear.Visible = false
		tear.CollisionDamage = 0
		local tC = tear:GetSprite().Color
		if VeeHelper.AreColorsDifferent(eC, tC) == true then
			effect:SetColor(tC, -1, 1, false, false)
		else
			local colorRed = Color(1, 0, 0, 1, 0, 0, 0)
			effect:SetColor(colorRed, -1, 1, false, false)
		end
		tear:Remove()
	end

	if SwiftLaserType(player) == "techX" then
		effect.CollisionDamage = player.Damage * 0.25
	else
		effect.CollisionDamage = player.Damage
		if swiftBase:IsSwiftLaserEffect(effect) == "brim" then
			effect:GetSprite().Scale = Vector(0.7, 0.7)
		end
	end
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	effect.PositionOffset = Vector(0, -25)
end

---@param swiftData SwiftInstance
---@param isMult boolean
function swiftLaser:SpawnSwiftLasers(swiftData, isMult)
	local player = swiftData.Player
	if not player then return end

	local laserVariant = nil

	if SwiftLaserType(player) == "brim"
		or (SwiftLaserType(player) == "techX" and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)) then
		laserVariant = EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL
	elseif SwiftLaserType(player) == "laser"
		or SwiftLaserType(player) == "techX" then
		laserVariant = EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT
	end

	if laserVariant == nil then return end

	local parent = swiftData.Parent
	local spawnPos = swiftBase:GetAdjustedStartingAngle(swiftData)
	local swiftEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, laserVariant, 0, swiftData.Parent.Position + spawnPos,
		Vector.Zero, parent):ToEffect()
	AssignSwiftLaserEffectData(swiftData, swiftEffect)
	swiftBase:InitSwiftWeapon(swiftData, swiftEffect, isMult)
end

---@param swiftData SwiftInstance
function swiftLaser:TechXRadiusScaling(swiftData)
	local radius = 15 + (45 * swiftBase:GetDurationPercentage(swiftData))
	return radius
end

---@param swiftData SwiftInstance
---@param weapon Weapon | EntityEffect
function swiftLaser:TechXDamageScaling(swiftData, weapon)
	local player = swiftData.Player
	if not player then return end

	local damageMult = 0.25 + (0.75 * swiftBase:GetDurationPercentage(swiftData))
	local damageCalc = player.Damage * damageMult

	if damageCalc < 0.1 then
		weapon.CollisionDamage = 0.1
	elseif damageCalc > (player.Damage * 2) then
		weapon.CollisionDamage = (player.Damage * 2)
	else
		weapon.CollisionDamage = damageCalc
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
function swiftLaser:FireTechXLaser(swiftData, swiftWeapon, direction)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local knifeOverride = (
		swiftData.Player:HasWeaponType(WeaponType.WEAPON_KNIFE) or swiftData.Player:HasWeaponType(WeaponType.WEAPON_BONE))
	local damageMult = knifeOverride and player.Damage * 0.25 or swiftWeapon.WeaponEntity.CollisionDamage / player.Damage
	local radius = knifeOverride and 25 or swiftLaser:TechXRadiusScaling(swiftData) or 15

	if damageMult < 0.25 then
		damageMult = 0.25
	end

	local laser = player:FireTechXLaser(swiftWeapon.WeaponEntity.Position,
		VeeHelper.AddTearVelocity(direction, player.ShotSpeed * 10, player), radius, player, damageMult)
		:ToLaser()

	if knifeOverride then
		laser.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	end

	laser.Parent = swiftWeapon.WeaponEntity
	swiftWeapon.AttachedLaser = laser
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
function swiftLaser:FireBrimLaser(swiftData, swiftWeapon, direction)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftWeapon.WeaponEntity
	if not parent then return end
	local damageMult = player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) and
		(swiftWeapon.WeaponEntity.CollisionDamage / player.Damage) or 1
	local laser = player:FireBrimstone(direction, player, damageMult):ToLaser()

	laser.Parent = swiftWeapon.WeaponEntity
	laser.PositionOffset = Vector(0, -23)
	laser.Timeout = swiftWeapon.Special.HoldTimeout(laser)
	swiftWeapon.AttachedLaser = laser
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
---@param isTech2 boolean
function swiftLaser:FireTechLaser(swiftData, swiftWeapon, direction, isTech2)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local damageMult = isTech2 and 0.2 or
		player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) and (swiftWeapon.WeaponEntity.CollisionDamage / player.Damage) or 1
	local laser = player:FireTechLaser(swiftWeapon.WeaponEntity.Position, LaserOffset.LASER_TRACTOR_BEAM_OFFSET, direction,
		false, false,
		player, damageMult):ToLaser()

	laser.Parent = swiftWeapon.WeaponEntity
	laser.PositionOffset = Vector(0, -23)
	swiftWeapon.Special.HasTech2 = isTech2 or false
	laser.Timeout = swiftWeapon.Special.HoldTimeout(laser)
	if isTech2 then
		laser.Timeout = laser.Timeout + 1
	end
	swiftWeapon.AttachedLaser = laser
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
function swiftLaser:FireSwiftLaser(swiftData, swiftWeapon, direction)
	local player = swiftData.Player
	if not player then return end

	if SwiftLaserType(player) == "techX" then
		swiftLaser:FireTechXLaser(swiftData, swiftWeapon, direction)
	elseif SwiftLaserType(player) == "brim" then
		swiftLaser:FireBrimLaser(swiftData, swiftWeapon, direction)
	elseif SwiftLaserType(player) == "laser" then
		swiftLaser:FireTechLaser(swiftData, swiftWeapon, direction, false)
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param effect EntityEffect
function swiftLaser:SwiftLaserEffectUpdate(swiftData, swiftWeapon, effect)
	local player = swiftData.Player
	local data = effect:GetData()
	if not player then return end

	if SwiftLaserType(player) == "techX" then
		swiftLaser:TechXDamageScaling(swiftData, swiftWeapon.WeaponEntity)
	end

	if rgbCycle:shouldApplyColorCycle(player) and not data.EeveeEntHasColorCycle then
		local colorCycle = player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) and EEVEEMOD.ColorCycle.RGB
			or player:HasCollectible(CollectibleType.COLLECTIBLE_CONTINUUM) and EEVEEMOD.ColorCycle.CONTINUUM
		rgbCycle:applyColorCycle(effect, colorCycle)
	end

	if not swiftWeapon.HasFired then
		effect.Timeout = 2
	end
end

---@param laser EntityLaser
function swiftLaser:SwiftLaserUpdate(laser)
	local parent = laser.Parent
	---@cast parent EntityEffect | EntityTear
	if not parent then return end
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(parent))]
	if not swiftWeapon then return end
	local swiftData = swiftWeapon.ParentInstance
	if not swiftData then return end
	local player = swiftData.Player
	if not player then return end

	swiftSynergies:TechXKnifeUpdate(swiftWeapon, laser, parent)

	if laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR then

		laser.Angle = swiftWeapon.ShootDirection:Rotated(swiftWeapon.Special.RotationOffset):GetAngleDegrees()
		laser.Position = parent.Position

		if not swiftWeapon.HasFired then
			laser.Timeout = swiftWeapon.Special.HoldTimeout(laser)
		end
	end
end

return swiftLaser
