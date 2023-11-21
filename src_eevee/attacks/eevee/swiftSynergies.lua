local vee = require("src_eevee.VeeHelper")
local swiftSynergies = {}

--This isn't for every single synergy, as to why lasers, knives, etc are in their own file. Those are for the different weapon types.
--This file is more of the synergies that will apply to the swift attack at varying points in the process of it, depending on your items.
--If I included all the different stuff I shove into the swift attack for synergies like this it would be way too huge.

local weaponTypeOverrides = {
	WeaponType.WEAPON_ROCKETS,
	WeaponType.WEAPON_BONE,
	WeaponType.WEAPON_LUDOVICO_TECHNIQUE,
	WeaponType.WEAPON_SPIRIT_SWORD,
	WeaponType.WEAPON_FETUS,
}

---@param player EntityPlayer
local function IsItemWeaponActive(player)
	local weaponOut = false
	local weaponEnt = player:GetActiveWeaponEntity()

	if weaponEnt ~= nil then
		if (weaponEnt.Type == EntityType.ENTITY_KNIFE and weaponEnt.Variant == vee.KnifeVariant.NOTCHED_AXE)
			or (weaponEnt.Type == EntityType.ENTITY_EFFECT and weaponEnt.Variant == EffectVariant.URN_OF_SOULS) then
			weaponOut = true
		end
	end
	for _, launcher in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.WONDEROUS_LAUNCHER, 0)) do
		if vee.EntitySpawnedByPlayer(launcher)
			and launcher.SpawnerEntity:GetData().Identifier == player:GetData().Identifier then
			weaponOut = true
		end
	end
	return weaponOut
end

---@param player EntityPlayer
function swiftSynergies:ShouldWeaponTypeOverride(player)
	local override = false
	local canShoot = player:CanShoot()

	for i = 1, #weaponTypeOverrides do
		if player:HasWeaponType(weaponTypeOverrides[i])
			or IsItemWeaponActive(player) then
			override = true
		elseif weaponTypeOverrides[i] == WeaponType.WEAPON_LUDOVICO_TECHNIQUE then
			if player:HasWeaponType(WeaponType.WEAPON_KNIFE) and
				player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
				override = true
			end
		end
		if override == true then
			break
		end
	end
	if override then
		if canShoot == false
			and not player:GetData().WonderLauncher then
			vee.SetCanShoot(player, true)
		end
	elseif not override and canShoot == true then
		vee.SetCanShoot(player, false)
	end
	return override
end

---@param swiftData SwiftInstance
---@param weapon Weapon | EntityEffect
function swiftSynergies:ChocolateMilkDamageScaling(swiftData, weapon)
	local player = swiftData.Player
	if not player then return end

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
		or player:HasWeaponType(WeaponType.WEAPON_TECH_X)
	then
		return
	end

	local damageMult = 0.5 + (1.5 * (swiftData.TotalDuration - swiftData.DurationTimer) / swiftData.TotalDuration)
	if weapon:ToBomb() then
		local data = weapon:GetData()
		local damageCalc = data.SwiftExplosionDamageInit * damageMult

		if not data.SwiftExplosionDamageInit then
			data.SwiftExplosionDamageInit = weapon.ExplosionDamage
		end

		if damageCalc > (data.SwiftExplosionDamageInit * 2) then
			weapon.ExplosionDamage = (data.SwiftExplosionDamageInit * 2)
		else
			weapon.ExplosionDamage = damageCalc
		end
	else
		local damageCalc = player.Damage * damageMult

		if damageCalc < 0.1 then
			weapon.CollisionDamage = 0.1
		elseif damageCalc > (player.Damage * 2) then
			weapon.CollisionDamage = (player.Damage * 2)
		else
			weapon.CollisionDamage = damageCalc
		end
	end
end

---@type TearFlags[]
local TearFlagsToDelay = {
	TearFlags.TEAR_GROW,        --Lump of Coal
	TearFlags.TEAR_SHRINK,      --Proptosis
	TearFlags.TEAR_SQUARE,      --Hook Worm
	TearFlags.TEAR_SPIRAL,      --Ring Worm
	TearFlags.TEAR_BIG_SPIRAL,  --Ouroborus Worm
	TearFlags.TEAR_HYDROBOUNCE, --Flat Stone
	TearFlags.TEAR_BOUNCE,      --Rubber Cement
	TearFlags.TEAR_TURN_HORIZONTAL -- Brain Worm
}

---@param swiftWeapon SwiftWeapon
---@param weapon Weapon | EntityEffect
function swiftSynergies:DelayTearFlags(swiftWeapon, weapon)
	if weapon:ToEffect() then return end

	for _, tearFlag in pairs(TearFlagsToDelay) do
		if swiftWeapon.HasFired == false then
			if weapon:HasTearFlags(tearFlag) then
				---@diagnostic disable-next-line: assign-type-mismatch
				swiftWeapon.DelayedTearFlag = swiftWeapon.DelayedTearFlag | tearFlag
				weapon:ClearTearFlags(tearFlag)
			end
		elseif swiftWeapon.DelayedTearFlag ~= 0 then
			if not weapon:HasTearFlags(swiftWeapon.DelayedTearFlag) then
				weapon:AddTearFlags(swiftWeapon.DelayedTearFlag)
			end
		end
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
function swiftSynergies:TinyPlanetDistance(swiftData, swiftWeapon)
	local player = swiftData.Player
	if not player or not player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET) then return end

	if swiftWeapon.FireDelay > 0
		and not swiftWeapon.HasFired
	then
		local distanceCalc = ((swiftData.TotalDuration - swiftData.DurationTimer) / swiftData.TotalDuration)
		swiftWeapon.OrbitDistance = swiftWeapon.OrbitDistanceSaved + (90 * distanceCalc)
	end
end

---@param player EntityPlayer
function swiftSynergies:ShouldUseTinyPlanet(player)
	return player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
		and (
			player:HasWeaponType(WeaponType.WEAPON_TEARS)
			or player:HasWeaponType(WeaponType.WEAPON_KNIFE)
			or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS)
			or player:HasWeaponType(WeaponType.WEAPON_FETUS)
		)
end

---@param player EntityPlayer
function swiftSynergies:ShouldUseLudo(player)
	return player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) or
		(
			player:HasWeaponType(WeaponType.WEAPON_KNIFE) and player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE)
		)
end

---@param swiftWeapon SwiftWeapon
---@param player EntityPlayer
---@param weapon Weapon | EntityEffect
function swiftSynergies:AntiGravityBlink(swiftWeapon, player, weapon)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY)
		or swiftWeapon.FireDelay <= 0
	then
		return
	end
	if swiftWeapon.FireDelay <= swiftWeapon.AntiGravBlinkThreshold then
		local c = weapon:GetSprite().Color
		weapon:SetColor(Color(c.R, c.G, c.B, 1, 0, 0.5, 0.5), 14, 2, true, false)
		swiftWeapon.AntiGravBlinkThreshold = swiftWeapon.AntiGravBlinkThreshold - swiftWeapon.AntiGravBlinkToReduceBy
	end
end

---@param swiftWeapon SwiftWeapon
---@param laser EntityLaser
---@param parent EntityEffect | EntityTear
function swiftSynergies:TechXKnifeUpdate(swiftWeapon, laser, parent)
	if not parent:ToTear()
		or laser.SubType ~= LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
	then
		return
	end
	laser.Position = parent.Position

	if swiftWeapon.HasFired
		and (not EEVEEMOD.game:GetRoom():IsPositionInRoom(parent.Position, -30)
			or parent:IsDead())
	then
		laser:Remove()
	end
end

---@param player EntityPlayer
---@return boolean
function swiftSynergies:IsSoyBrim(player)
	return player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) and
		(player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or
			player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK))
end

return swiftSynergies
