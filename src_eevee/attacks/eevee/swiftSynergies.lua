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
		if VeeHelper.EntitySpawnedByPlayer(launcher, false)
			and launcher.SpawnerEntity:GetData().Identifier == player:GetData().Identifier then
			weaponOut = true
		end
	end
	return weaponOut
end

function swiftSynergies:WeaponShouldOverrideSwift(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local override = false
	if not swiftPlayer.ShouldOverrideSwift then
		swiftPlayer.ShouldOverrideSwift = false
	end
	for i = 1, #weaponTypeOverrides do
		if player:HasWeaponType(weaponTypeOverrides[i])
			or IsItemWeaponActive(player) then
			override = true
		end
	end
	if override then
		if not swiftPlayer.ShouldOverrideSwift then
			swiftPlayer.ShouldOverrideSwift = true
			if not player:GetData().WonderLauncher then
				VeeHelper.SetCanShoot(player, true)
			end
		end
	elseif not override and (player:CanShoot() == true or swiftPlayer.ShouldOverrideSwift == true) then
		swiftPlayer.ShouldOverrideSwift = false
		VeeHelper.SetCanShoot(player, false)
	end
	return override
end

function swiftSynergies:ShouldAttachTech2Laser(weapon, player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
		local ptrHashWeapon = tostring(GetPtrHash(weapon))
		local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

		if swiftWeapon and swiftWeapon.HasFired == false then
			return true
		end
	end
end

function swiftSynergies:ChocolateMilkDamageScaling(weapon, player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]


	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK)
		and not player:HasWeaponType(WeaponType.WEAPON_TECH_X)
		and swiftWeapon.IsFakeKnife == false
		and swiftPlayer.AttackDuration > 0
		and swiftPlayer.AttackDurationSet
		and swiftWeapon.HasFired == false then
		local damageMult = 0.5 + (1.5 * (swiftPlayer.AttackDurationSet - swiftPlayer.AttackDuration) / swiftPlayer.AttackDurationSet)
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

function swiftSynergies:DelayTearFlags(weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if weapon.Type ~= EntityType.ENTITY_EFFECT then
		for i = 1, #TearFlagsToDelay do
			if swiftWeapon.HasFired == false then
				if weapon:HasTearFlags(TearFlagsToDelay[i]) then
					weapon:ClearTearFlags(TearFlagsToDelay[i])
					if swiftWeapon.DelayTearFlags == nil then
						swiftWeapon.DelayTearFlags = {}
					end
					swiftWeapon.DelayTearFlags[i] = i
				end
			elseif swiftWeapon.DelayTearFlags and swiftWeapon.DelayTearFlags[i] then
				if not weapon:HasTearFlags(TearFlagsToDelay[swiftWeapon.DelayTearFlags[i]]) then
					weapon:AddTearFlags(TearFlagsToDelay[i])
				end
			end
		end
	end
end

local MultiWeaponTypeCombos = {
	[WeaponType.WEAPON_TECH_X] = CollectibleType.COLLECTIBLE_TECH_X,
	[WeaponType.WEAPON_LASER] = CollectibleType.COLLECTIBLE_TECHNOLOGY,
	[WeaponType.WEAPON_BOMBS] = CollectibleType.COLLECTIBLE_DR_FETUS,
	[WeaponType.WEAPON_KNIFE] = CollectibleType.COLLECTIBLE_MOMS_KNIFE
}

local ItemToShotNum = {
	[CollectibleType.COLLECTIBLE_20_20] = 1,
	[CollectibleType.COLLECTIBLE_INNER_EYE] = 2,
	[CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = 3
}

function swiftSynergies:MultiShotCountInit(player)
	local count = 0

	--Basic multicount
	for itemID, num in pairs(ItemToShotNum) do
		if player:HasCollectible(itemID) then
			count = count + num
			if player:GetCollectibleNum(itemID) >= 2 then
				count = count + (player:GetCollectibleNum(itemID) - 1)
			end
		end
	end

	--Reverse Hanged Man counts as another Inner Eye
	if player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
			and not player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
			and not player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
		then
			count = count + 2
		else
			count = count + 1
		end
	end

	--20/20 with other multi-shots removes its extra tear in trade for negating the tear delay
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) and
		(
		player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
			or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
			or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN)
		)
	then
		count = count - 1
	end

	--Wiz items, with further Wiz's affecting the multi-tear count
	local wizCount = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
		wizCount = wizCount + (1 * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ))
	end
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
		wizCount = wizCount + 2
	end
	if wizCount >= 3 then
		count = wizCount - 2
	end

	--The weird interactions with Monstro's Lung specifically
	if not player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
		for weaponType, itemID in pairs(MultiWeaponTypeCombos) do
			if player:HasWeaponType(weaponType) or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				if player:GetCollectibleNum(itemID) >= 2 then
					count = count + (1 * (player:GetCollectibleNum(itemID) - 1))
				end
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
			and player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) >= 2 then
			count = count + (4 * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG))
		end
	elseif player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
		count = count * 2
		count = count + (5 * player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG))
	end

	--Count cap
	if count > 16 then
		count = 16
	end

	return count
end

function swiftSynergies:BookwormShot(player)
	local count = 0
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_BOOK_WORM) then
		if EEVEEMOD.RandomNum(2) == 2 then
			count = 1
		end
	end
	return count
end

function swiftSynergies:ShouldFireExtraShot(player, itemID)
	local currentLuck = player.Luck
	if itemID == CollectibleType.COLLECTIBLE_MOMS_EYE then
		local baseChance = 50
		local maxChance = 100
		local luckValue = 10
		if VeeHelper.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, EEVEEMOD.RunSeededRNG) then
			return true
		else
			return false
		end
	end
	if itemID == CollectibleType.COLLECTIBLE_LOKIS_HORNS then
		local baseChance = 25
		local maxChance = 100
		local luckValue = 5
		if VeeHelper.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, EEVEEMOD.RunSeededRNG) then
			return true
		else
			return false
		end
	end
	if itemID == CollectibleType.COLLECTIBLE_EYE_SORE then
		if EEVEEMOD.RandomNum(2) == 2 then
			return true
		else
			return false
		end
	end
end

--[[function swiftSynergies:TinyPlanetDistance(player, weapon)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]
	
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
	end
end]]

function swiftSynergies:IsKidneyStoneActive(tear, player)
	local isKidneyActive = false
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

	return isKidneyActive
end

function swiftSynergies:KidneyStoneDuration(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if swiftPlayer
		and swiftPlayer.KidneyTimer then
		if swiftPlayer.KidneyTimer > 0 then
			swiftPlayer.KidneyTimer = swiftPlayer.KidneyTimer - 1
		else
			swiftPlayer.KidneyTimer = nil
		end
	end
end

function swiftSynergies:AntiGravityDuration(player, weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftWeapon
		and swiftWeapon.AntiGravDir ~= nil
		and swiftWeapon.AntiGravTimer ~= nil
	then
		if swiftWeapon.AntiGravTimer > 0 and player:GetFireDirection() ~= Direction.NO_DIRECTION then
			if swiftWeapon.AntiGravTimer % 15 == 0 then
				local c = weapon:GetSprite().Color
				if swiftWeapon.IsFakeKnife then
					c = weapon.Child:GetSprite().Color
					weapon.Child:SetColor(Color(c.R, c.G, c.B, 1, 0, 0.5, 0.5), 14, 2, true, false)
				else
					weapon:SetColor(Color(c.R, c.G, c.B, 1, 0, 0.5, 0.5), 14, 2, true, false)
				end
			end
			swiftWeapon.AntiGravTimer = swiftWeapon.AntiGravTimer - 1
			if weapon.Type == EntityType.ENTITY_TEAR and swiftWeapon.AntiGravHeight then
				weapon.Height = swiftWeapon.AntiGravHeight
			end
		else
			weapon.Velocity = swiftBase:TryFireToEnemy(player, weapon, swiftWeapon.AntiGravDir)
			swiftWeapon.AntiGravDir = nil
			swiftWeapon.AntiGravTimer = nil
		end
	end
end

function swiftSynergies:EyeItemDamageChance(player, weapon)
	local shouldBeBlood
	if weapon.Type == EntityType.ENTITY_TEAR then --All other weapon types seem to handle the synergy naturally
		if player:HasCollectible(CollectibleType.COLLECTIBLE_STYE) then
			if EEVEEMOD.RandomNum(2) == 2 then
				local c = weapon:GetSprite().Color
				weapon.CollisionDamage = weapon.CollisionDamage / 1.24
				weapon.Height = weapon.Height + 5
				weapon.Velocity = weapon.Velocity:Resized(1.2)
				if c.R == 1.5 and c.G == 2.0 and c.B == 2.0 then
					weapon:SetColor(Color(1, 1, 1, 1, c.RO, c.GO, c.BO), -1, 0, true, false)
				end
			end
		end
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_SCOOPER) then
			if EEVEEMOD.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage / 1.34
				shouldBeBlood = false
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) then
			if EEVEEMOD.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage + 1
				weapon.Height = weapon.Height - 10
				shouldBeBlood = true
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CHEMICAL_PEEL) then
			if EEVEEMOD.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage + 2
				shouldBeBlood = true
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_PEEPER) then
			if EEVEEMOD.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage * 1.34
				shouldBeBlood = true
			end
		end
		weapon:GetData().ForceBlood = shouldBeBlood
	end
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
