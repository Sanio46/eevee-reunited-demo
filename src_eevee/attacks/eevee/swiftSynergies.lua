local swiftSynergies = {}
local swiftBase = require("src_eevee.attacks.eevee.swiftBase")

--This isn't for every single synergy, as to why lasers, knives, etc are in their own file. Those are for the different weapon types.
--This file is more of the synergies that will apply to the swift attack at varying points in the process of it, depending on your items.
--If I included all the different stuff I shove into the swift attack for synergies like this it would be way too huge.

local weaponTypeOverrides = {
	WeaponType.WEAPON_ROCKETS,
	WeaponType.WEAPON_BONE,
	WeaponType.WEAPON_LUDOVICO_TECHNIQUE,
	WeaponType.WEAPON_SPIRIT_SWORD,
	WeaponType.WEAPON_URN_OF_SOULS,
	WeaponType.WEAPON_NOTCHED_AXE, --fucking dumbass bitch isn't a weapontype when activated apparently
	WeaponType.WEAPON_UMBILICAL_WHIP,
	WeaponType.WEAPON_FETUS,
}

---@param player EntityPlayer
local function IsItemWeaponActive(player)
	local weaponOut = false
	local weaponEnt = player:GetActiveWeaponEntity()

	if weaponEnt ~= nil then
		if (weaponEnt.Type == EntityType.ENTITY_KNIFE and weaponEnt.Variant == VeeHelper.KnifeVariant.NOTCHED_AXE)
			or (weaponEnt.Type == EntityType.ENTITY_EFFECT and weaponEnt.Variant == EffectVariant.URN_OF_SOULS) then
			weaponOut = true
		end
	end
	for _, launcher in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.WONDEROUS_LAUNCHER, 0)) do
		if VeeHelper.EntitySpawnedByPlayer(launcher)
			and launcher.SpawnerEntity:GetData().Identifier == player:GetData().Identifier then
			weaponOut = true
		end
	end
	return weaponOut
end

---@param player EntityPlayer
function swiftSynergies:ToggleCanShootPerWeaponType(player)
	local override = false
	local canShoot = player:CanShoot()

	for i = 1, #weaponTypeOverrides do
		if player:HasWeaponType(weaponTypeOverrides[i])
			or IsItemWeaponActive(player) then
			override = true
		end
	end
	if override then
		if canShoot == false
			and not player:GetData().WonderLauncher then
			VeeHelper.SetCanShoot(player, true)
		end
	elseif not override and canShoot == true then
		VeeHelper.SetCanShoot(player, false)
	end
	return override
end

---@param swiftData SwiftInstance
---@param weapon Weapon
function swiftSynergies:ChocolateMilkDamageScaling(swiftData, weapon)
	local player = swiftData.Player

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
		or player:HasWeaponType(WeaponType.WEAPON_TECH_X)
	then
		return
	end

	local damageMult = 0.5 + (1.5 * (swiftData.TotalDuration - swiftData.DurationTimer) / swiftData.TotalDuration)
	local damageCalc = player.Damage * damageMult

	if damageCalc < 0.1 then
		weapon.CollisionDamage = 0.1
	elseif damageCalc > (player.Damage * 2) then
		weapon.CollisionDamage = (player.Damage * 2)
	else
		weapon.CollisionDamage = damageCalc
	end

end

local TearFlagsToDelay = {
	TearFlags.TEAR_GROW, --Lump of Coal
	TearFlags.TEAR_SHRINK, --Proptosis
	TearFlags.TEAR_ORBIT, --Tiny Planet
	TearFlags.TEAR_SQUARE, --Hook Worm
	TearFlags.TEAR_SPIRAL, --Ring Worm
	TearFlags.TEAR_BIG_SPIRAL, --Ouroborus Worm
	TearFlags.TEAR_HYDROBOUNCE, --Flat Stone
	TearFlags.TEAR_BOUNCE, --Rubber Cement
	TearFlags.TEAR_TURN_HORIZONTAL -- Brain Worm
}

---@param weapon Weapon
function swiftSynergies:DelayTearFlags(weapon)
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(weapon))]

	if not weapon:ToEffect() then
		for _, tearFlag in pairs(TearFlagsToDelay) do
			if swiftWeapon.HasFired == false then
				if weapon:HasTearFlags(tearFlag) then
					swiftWeapon.DelayedTearFlag = swiftWeapon.DelayedTearFlag + tearFlag
					weapon:ClearTearFlags(tearFlag)
				end
			elseif swiftWeapon.DelayedTearFlag ~= 0 then
				if not weapon:HasTearFlags(swiftWeapon.DelayedTearFlag) then
					weapon:AddTearFlags(swiftWeapon.DelayedTearFlag)
				end
			end
		end
	end
end

function swiftSynergies:TinyPlanetDistance(player, weapon)
	--[[	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET) then
		if swiftPlayer
		and swiftPlayer.AttackDuration > 0
		and swiftPlayer.AttackDurationSet
		and not swiftWeapon.HasFired then
			if not swiftWeapon.OriginalDist then
				swiftWeapon.OriginalDist = swiftWeapon.DistFromPlayer
			end
			local distanceCalc = (0.5*(swiftPlayer.AttackDurationSet - swiftPlayer.AttackDuration) / swiftPlayer.AttackDurationSet)
			swiftWeapon.DistFromPlayer = swiftWeapon.OriginalDist - (swiftWeapon.OriginalDist * distanceCalc)
		end
	end ]]
end

function swiftSynergies:IsKidneyStoneActive(tear, player)
	--[[ local isKidneyActive = false
	local playerType = player:GetPlayerType()

	if playerType ~= EEVEEMOD.PlayerType.EEVEE
	and tear:HasTearFlags(TearFlags.TEAR_PIERCING)
	and tear.Variant == TearVariant.STONE
	then
		local playerDamage = player.Damage * 5
		local tearDamage = tear.CollisionDamage

		if tearDamage >= playerDamage - 5 and tearDamage <= playerDamage + 5 then --Just a random check for if its not exact
			isKidneyActive = true
		end
	end

	return isKidneyActive ]]
end

---@param swiftWeapon SwiftWeapon
---@param player EntityPlayer
---@param weapon Weapon
function swiftSynergies:AntiGravityBlink(swiftWeapon, player, weapon)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY)
		or swiftWeapon.FireDelay <= 0
		or swiftWeapon.FireDelay % 15 ~= 0
	then
		return
	end
	local c = weapon:GetSprite().Color
	weapon:SetColor(Color(c.R, c.G, c.B, 1, 0, 0.5, 0.5), 14, 2, true, false)
end

function swiftSynergies:TechXKnifeUpdate(laser, tearKnife)
	if tearKnife.Type == EntityType.ENTITY_TEAR
		and laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
	then
		local ptrHashWeapon = tostring(GetPtrHash(tearKnife))
		local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

		laser.Position = tearKnife.Position

		if swiftWeapon.HasFired
			and (not EEVEEMOD.game:GetRoom():IsPositionInRoom(tearKnife.Position, -30)
				or tearKnife:IsDead())
		then
			laser:Remove()
		end
	end
end

return swiftSynergies
