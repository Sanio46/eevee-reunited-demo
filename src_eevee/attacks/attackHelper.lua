local vee = require("src_eevee.VeeHelper")
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

--Returns the number of additional shots the player should shoot when firing. Does not count external multi-shot items.
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
		if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) >= 2 then
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
		if vee.RandomNum(2) == 2 then
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
		if vee.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, EEVEEMOD.RunSeededRNG) then
			shouldFire = true
		end
	elseif itemID == CollectibleType.COLLECTIBLE_LOKIS_HORNS then
		local baseChance = 25
		local maxChance = 100
		local luckValue = 5
		if vee.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, EEVEEMOD.RunSeededRNG) then
			shouldFire = true
		end
	elseif itemID == CollectibleType.COLLECTIBLE_EYE_SORE then
		if vee.RandomNum(2) == 2 then
			shouldFire = true
		end
	elseif itemID == CollectibleType.COLLECTIBLE_MONSTROS_LUNG then
		for weaponType, _ in pairs(weaponTypeToCollectible) do
			if player:HasWeaponType(weaponType) then
				shouldFire = true
				break
			end
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
---@return Vector[]
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
				for i = 1, vee.RandomNum(3, 5) do
					local rotationOffset = vee.RandomNum(math.floor(degrees / -2), math.floor(degrees / 2))
					local newDirection = direction:Rotated(rotationOffset)
					table.insert(directions, newDirection)
				end
			end
		end
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE)
		and attackHelper:ShouldFireExtraShot(player, CollectibleType.COLLECTIBLE_EYE_SORE) == true
	then
		for i = 1, vee.RandomNum(3) do
			local rotationOffset = vee.RandomNum(360)
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
			if vee.RandomNum(2) == 2 then
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
			if vee.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage / 1.34
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) then
			if vee.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage + 1
				weapon.Height = weapon.Height - 10
				shouldBeBlood = true
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CHEMICAL_PEEL) then
			if vee.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage + 2
				shouldBeBlood = true
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_PEEPER) then
			if vee.RandomNum(2) == 2 then
				weapon.CollisionDamage = weapon.CollisionDamage * 1.34
				shouldBeBlood = true
			end
		end
		weapon:GetData().ForceBlood = shouldBeBlood
	end
end

---@param player EntityPlayer
---@param targetStartingPos Vector | nil
---@return Vector direction
function attackHelper:GetIsaacShootingDirection(player, targetStartingPos)
	local shootDir = player:GetShootingInput()
	local data = player:GetData()
	local HeadDirectionFire = Vector(-1, 0):Rotated(90 * player:GetHeadDirection())
	local ShootDirectionFire = Vector(-1, 0):Rotated(90 * player:GetFireDirection())

	if not data.LastSavedShootDirection then
		data.LastSavedShootDirection = HeadDirectionFire
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT)
		and (player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
			or player:HasWeaponType(WeaponType.WEAPON_LASER))
	then
		local targetPos = vee.FindMarkedTarget(player)
		if targetPos ~= nil and targetStartingPos ~= nil then
			data.LastSavedShootDirection = (targetPos - targetStartingPos):Normalized()
		end
	elseif (
			player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK)
			or player:HasWeaponType(WeaponType.WEAPON_KNIFE)
		) then
		if shootDir.X ~= 0 or shootDir.Y ~= 0 then
			data.LastSavedShootDirection = shootDir
		elseif Options.MouseControl and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) then
			shootDir = (Input.GetMousePosition(true) - player.Position):Normalized()
			data.LastSavedShootDirection = shootDir
		end
	elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
		local spinAnimsToVec = {
			["SpinLeft"] = vee.VectorDirection.Left,
			["SpinUp"] = vee.VectorDirection.Up,
			["SpinRight"] = vee.VectorDirection.Right,
			["SpinDown"] = vee.VectorDirection.Down
		}
		local spinAnims = {
			"SpinRight",
			"SpinLeft",
			"SpinUp",
			"SpinDown",
		}
		local sword = player:GetActiveWeaponEntity()
		if sword == nil or (
				sword.Variant ~= vee.KnifeVariant.SPIRIT_SWORD
				and sword.Variant ~= vee.KnifeVariant.TECH_SWORD
			)
		then
			data.LastSavedShootDirection = HeadDirectionFire
		else
			local sprite = sword:GetSprite()

			if vee.IsSpritePlayingAnims(sprite, spinAnims) then
				data.LastSavedShootDirection = spinAnimsToVec[sprite:GetAnimation()]
			end
		end
	elseif player:GetFireDirection() ~= -1 then
		data.LastSavedShootDirection = ShootDirectionFire
	end
	return data.LastSavedShootDirection
end

---@param player EntityPlayer
---@param weapon Weapon
---@param fireDir Vector
---@param angleLimit integer
function attackHelper:TryFireToEnemy(player, weapon, fireDir, angleLimit)
	local newFireDir = fireDir

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT)
	then
		local radius = player.TearRange / 2
		local closestEnemy = vee.DetectNearestEnemy(weapon, radius)
		local dirToEnemy = nil

		if closestEnemy ~= nil then
			dirToEnemy = (closestEnemy.Position - weapon.Position):Normalized()

			if math.abs(math.abs(dirToEnemy:GetAngleDegrees()) - math.abs(fireDir:GetAngleDegrees())) <= angleLimit then
				newFireDir = vee.AddTearVelocity(dirToEnemy, player.ShotSpeed * 10, player)
			end
		end
	end
	return newFireDir
end

---@param ent EntityNPC
---@param range integer
---@param direction Vector
---@return Vector direction
function attackHelper:TryFireToNearestEnemy(ent, range, direction)
	local closestEnemy = vee.DetectNearestEnemy(ent, range)

	if closestEnemy ~= nil then
		direction = (closestEnemy.Position - ent.Position):Normalized()
	end
	return direction
end

---@param player EntityPlayer
function attackHelper:FireDirectionToVector(player)
	local fireDir = player:GetFireDirection()
	local DirAngles = {
		[-1] = Vector(0, -1),
		[0] = Vector(-1, 0),
		[1] = Vector(0, -1),
		[2] = Vector(1, 0),
		[3] = Vector(0, 1),
	}
	local vector = DirAngles[fireDir]

	return vector
end

---@param player EntityPlayer
function attackHelper:HeadDirectionToVector(player)
	return Vector(-1, 0):Rotated(90 * player:GetHeadDirection())
end

return attackHelper
