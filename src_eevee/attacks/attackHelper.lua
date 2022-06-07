local attackHelper = {}

local weaponTypeToCollectible = {
	[WeaponType.WEAPON_TECH_X] = CollectibleType.COLLECTIBLE_TECH_X,
	[WeaponType.WEAPON_LASER] = CollectibleType.COLLECTIBLE_TECHNOLOGY,
	[WeaponType.WEAPON_BOMBS] = CollectibleType.COLLECTIBLE_DR_FETUS,
	[WeaponType.WEAPON_KNIFE] = CollectibleType.COLLECTIBLE_MOMS_KNIFE
}

local itemToShotNum = {
	[CollectibleType.COLLECTIBLE_20_20] = 1,
	[CollectibleType.COLLECTIBLE_INNER_EYE] = 2,
	[CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = 3
}

--Returns the number of additional shots the player should shoot when firing. Does not count luck-based shot items.
---@param player EntityPlayer
function attackHelper:GetMultiShot(player)
	local count = 1

	--Basic multicount
	for itemID, num in pairs(itemToShotNum) do
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
		for weaponType, itemID in pairs(weaponTypeToCollectible) do
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

---@param player EntityPlayer
function attackHelper:BookwormShot(player)
	local count = 0
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_BOOK_WORM) then
		if EEVEEMOD.RandomNum(2) == 2 then
			count = 1
		end
	end
	return count
end

---@param player EntityPlayer
---@param itemID CollectibleType
function attackHelper:ShouldFireExtraShot(player, itemID)
	local currentLuck = player.Luck
	local shouldFire = false
	if itemID == CollectibleType.COLLECTIBLE_MOMS_EYE then
		local baseChance = 50
		local maxChance = 100
		local luckValue = 10
		if VeeHelper.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, EEVEEMOD.RunSeededRNG) then
			shouldFire = true
		end
	elseif itemID == CollectibleType.COLLECTIBLE_LOKIS_HORNS then
		local baseChance = 25
		local maxChance = 100
		local luckValue = 5
		if VeeHelper.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, EEVEEMOD.RunSeededRNG) then
			shouldFire = true
		end
	elseif itemID == CollectibleType.COLLECTIBLE_EYE_SORE then
		if EEVEEMOD.RandomNum(2) == 2 then
			shouldFire = true
		end
	end
	return shouldFire
end

function attackHelper:ShouldWizShot(player)
	local shouldWiz = false
	if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
		or player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY)
	then
		shouldWiz = true
	end
	return shouldWiz
end

---@param player EntityPlayer
---@param direction Vector
function attackHelper:GetExtraFireDirections(player, direction)
	local directions = {}
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS)
		and attackHelper:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_LOKIS_HORNS) == true
	then
		for i = 1, 3 do
			local rotationOffset = 90 * i
			local newDirection = direction:Rotated(rotationOffset)
			table.insert(directions, newDirection)
		end
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE)
		and attackHelper:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_MOMS_EYE) == true
	then
		local rotationOffset = 180
		local newDirection = direction:Rotated(rotationOffset)
		table.insert(directions, newDirection)
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
					local newDirection = direction:Rotated(rotationOffset)
					table.insert(directions, newDirection)
				end
			end
		end
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE)
		and attackHelper:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_EYE_SORE) == true
	then
		for i = 1, EEVEEMOD.RandomNum(3) do
			local rotationOffset = EEVEEMOD.RandomNum(360)
			local newDirection = direction:Rotated(rotationOffset)
			table.insert(directions, newDirection)
		end
	end
	return directions
end

---@param player EntityPlayer
---@param weapon Weapon
function attackHelper:EyeItemDamageChance(player, weapon)
	local shouldBeBlood = false
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

---@param player EntityPlayer
---@param weapon Weapon
---@param fireDir Vector
function attackHelper:TryFireToEnemy(player, weapon, fireDir)
	local newFireDir = fireDir
	local radius = player.TearRange / 2
	local closestEnemy = VeeHelper.DetectNearestEnemy(weapon, radius)
	local dirToEnemy = nil
	local angleLimit = 30

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT)
	then
		if closestEnemy ~= nil then
			dirToEnemy = (closestEnemy.Position - weapon.Position):Normalized()

			if math.abs(math.abs(dirToEnemy:GetAngleDegrees()) - math.abs(fireDir:GetAngleDegrees())) <= angleLimit then
				newFireDir = VeeHelper.AddTearVelocity(dirToEnemy, player.ShotSpeed * 10, player, true)
			end
		end
	end
	return newFireDir
end


return attackHelper