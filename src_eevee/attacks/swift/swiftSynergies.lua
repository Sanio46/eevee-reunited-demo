local swiftSynergies = {}
local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]

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

local function IsNotchedAxeActive(player)
	for _, axe in pairs(Isaac.FindByType(EntityType.ENTITY_KNIFE, EEVEEMOD.KnifeVariant.NOTCHED_AXE, 0)) do
		if axe.Parent and axe.Parent.Index == player.Index then
			return true
		else
			return false
		end
	end
end

local function IsUrnOfSoulsActive(player)
	for _, urn in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.URN_OF_SOULS, 0)) do
		if urn.Parent and urn.Parent.Index == player.Index then
			return true
		else
			return false
		end
	end
end

function swiftSynergies:WeaponShouldOverrideSwift(player)
	local dataPlayer = player:GetData()
	local override = false
	if not dataPlayer.SwiftOverride then
		dataPlayer.SwiftOverride = false
	end
	for i = 1, #weaponTypeOverrides do
		if player:HasWeaponType(weaponTypeOverrides[i])
		or IsNotchedAxeActive(player)
		or IsUrnOfSoulsActive(player) then
			override = true
		end
	end
	if override then
		if not dataPlayer.SwiftOverride then
			dataPlayer.SwiftOverride = true
			EEVEEMOD.API.SetCanShoot(player, true)
		end
		return true
	elseif not override and (player:CanShoot() == true or dataPlayer.SwiftOverride == true) then
		dataPlayer.SwiftOverride = false
		EEVEEMOD.API.SetCanShoot(player, false)
		return false
	end
end

function swiftSynergies:ShouldAttachTech2Laser(weapon, player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
		local dataWeapon = weapon:GetData()
		if dataWeapon.Swift
		and dataWeapon.Swift.IsSwiftWeapon
		and not dataWeapon.Swift.HasFired then
			return true
		end
	end
end

function swiftSynergies:ChocolateMilkDamageScaling(weapon, player)
	local dataPlayer = player:GetData()
	local dataWeapon = weapon:GetData()
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) 
	and not player:HasWeaponType(WeaponType.WEAPON_TECH_X)
	and dataWeapon.Swift
	and not dataWeapon.Swift.IsFakeKnife then
		if dataPlayer.Swift.AttackDuration > 0
		and dataPlayer.Swift.AttackDurationSet
		and not dataWeapon.Swift.HasFired then
			local playerDamage = player.Damage * 0.5
			local damageCalc = playerDamage + (1.5 * (dataPlayer.Swift.AttackDurationSet - dataPlayer.Swift.AttackDuration) / dataPlayer.Swift.AttackDurationSet)
			if damageCalc < 0.1 then
				weapon.CollisionDamage = 0.1
			elseif damageCalc > (player.Damage * 2) then
				weapon.CollisionDamage = (player.Damage * 2)
			else
				weapon.CollisionDamage = damageCalc
			end
		end
	end
end

local TearFlagsToDelay = {
	TearFlags.TEAR_SHRINK, --Proptosis
	TearFlags.TEAR_ORBIT, --Tiny Planet
	TearFlags.TEAR_SQUARE, --Hook Worm
	TearFlags.TEAR_SPIRAL, --Ring Worm
	TearFlags.TEAR_BIG_SPIRAL, --Ouroborus Worm
	TearFlags.TEAR_HYDROBOUNCE, --Flat Stone
	TearFlags.TEAR_BOUNCE, --Rubber Cement
}

function swiftSynergies:DelayTearFlags(weapon, player)
	local dataWeapon = weapon:GetData()
	local dataPlayer = player:GetData()
	if weapon.Type ~= EntityType.ENTITY_EFFECT then
		for i = 1, #TearFlagsToDelay do
			if dataWeapon.Swift then
				if not dataWeapon.Swift.HasFired then
					if weapon:HasTearFlags(TearFlagsToDelay[i]) then
						weapon:ClearTearFlags(TearFlagsToDelay[i])
						if dataWeapon.Swift.DelayTearFlags == nil then
							dataWeapon.Swift.DelayTearFlags = {}
						end
						dataWeapon.Swift.DelayTearFlags[i] = i
					end
				elseif dataWeapon.Swift.DelayTearFlags and dataWeapon.Swift.DelayTearFlags[i] then
					if not weapon:HasTearFlags(TearFlagsToDelay[ dataWeapon.Swift.DelayTearFlags[i] ]) then
						weapon:AddTearFlags(TearFlagsToDelay[i])
					end
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

	for itemID, num in pairs(ItemToShotNum) do
		if player:HasCollectible(itemID) then
			count = count + num
			if player:GetCollectibleNum(itemID) >= 2 then
				count = count + (player:GetCollectibleNum(itemID) - 1)
			end
		end
	end
	if player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then
		if  not player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_COLLECTIBLE_INNER_EYE)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
		then
			count = count + 2
		else
			count = count + 1
		end
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) and
	(
		player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
	or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN)
	)
	then
		count = count - 1
	end
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
		if EEVEEMOD.API.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck) then
			return true
		else
			return false
		end
	end
	if itemID == CollectibleType.COLLECTIBLE_LOKIS_HORNS then
		local baseChance = 25
		local maxChance = 100
		local luckValue = 5
		if EEVEEMOD.API.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck) then
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
	local dataPlayer = player:GetData()
	local dataWeapon = weapon:GetData()
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET) then
		if dataPlayer.Swift
		and dataPlayer.Swift.AttackDuration > 0
		and dataPlayer.Swift.AttackDurationSet
		and not dataWeapon.Swift.HasFired then
			if not dataWeapon.Swift.OriginalDist then
				dataWeapon.Swift.OriginalDist = dataWeapon.Swift.DistFromPlayer
			end
			local distanceCalc = (0.5*(dataPlayer.Swift.AttackDurationSet - dataPlayer.Swift.AttackDuration) / dataPlayer.Swift.AttackDurationSet)
			dataWeapon.Swift.DistFromPlayer = dataWeapon.Swift.OriginalDist - (dataWeapon.Swift.OriginalDist * distanceCalc)
		end
	end
end]]

function swiftSynergies:IsKidneyStoneActive(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_KIDNEY_STONE) then
		for _, tear in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR, TearVariant.STONE, 0)) do
			if tear.SpawnerType == EntityType.ENTITY_PLAYER then
				local kidneyPlayer = tear.SpawnerEntity:ToPlayer()
				if kidneyPlayer:GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
				and kidneyPlayer.InitSeed == player.InitSeed then
					return true
				else
					return false
				end
			end
		end
	end
end

function swiftSynergies:KidneyStoneDuration(player)
	local dataPlayer = player:GetData()
	if	dataPlayer.Swift
	and dataPlayer.Swift.KidneyTimer then
		if dataPlayer.Swift.KidneyTimer > 0 then
			dataPlayer.Swift.KidneyTimer = dataPlayer.Swift.KidneyTimer - 1
		else
			dataPlayer.Swift.KidneyTimer = nil
		end
	end
end

function swiftSynergies:AntiGravityDuration(player, weapon)
	local dataWeapon = weapon:GetData()

	if dataWeapon.Swift
	and dataWeapon.Swift.AntiGravDir
	and dataWeapon.Swift.AntiGravTimer then
		if dataWeapon.Swift.AntiGravTimer > 0 and player:GetFireDirection() ~= Direction.NO_DIRECTION then
			if dataWeapon.Swift.AntiGravTimer % 15 == 0 then
				local c = weapon:GetSprite().Color
				if dataWeapon.Swift.IsFakeKnife then
					c = weapon.Child:GetSprite().Color
					weapon.Child:SetColor(Color(c.R, c.G, c.B, 1, 0, 0.5, 0.5), 14, 2, true, false)
				else
					weapon:SetColor(Color(c.R, c.G, c.B, 1, 0, 0.5, 0.5), 14, 2, true, false)
				end
			end
			dataWeapon.Swift.AntiGravTimer = dataWeapon.Swift.AntiGravTimer - 1
			if weapon.Type == EntityType.ENTITY_TEAR and dataWeapon.Swift.AntiGravHeight then
				weapon.Height = dataWeapon.Swift.AntiGravHeight 
			end
		else
			weapon.Velocity = swiftBase:TryFireToEnemy(player, weapon, dataWeapon.Swift.AntiGravDir)
			dataWeapon.Swift.AntiGravDir = nil
			dataWeapon.Swift.AntiGravTimer = nil
		end
	end
end

return swiftSynergies
