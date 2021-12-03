local swiftAttack = {}

local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]
local swiftTear = EEVEEMOD.Src["attacks"]["swift.swiftTear"]
local swiftLaser = EEVEEMOD.Src["attacks"]["swift.swiftLaser"]
local swiftKnife = EEVEEMOD.Src["attacks"]["swift.swiftKnife"]
local swiftBomb = EEVEEMOD.Src["attacks"]["swift.swiftBomb"]
local swiftSynergies = EEVEEMOD.Src["attacks"]["swift.swiftSynergies"]

-----------------------
--  LOCAL FUNCTIONS  --
-----------------------

local function CalculateSwiftStats(player)
	local dataPlayer = player:GetData()
	local count = 5
	local degreeOfWeaponSpawns = 360/count
	local offset = math.random(0, 360)
	local duration = swiftBase:SwiftFireDelay(player) * count
	
	dataPlayer.Swift.AttackDuration = duration
	dataPlayer.Swift.AttackDurationSet = duration
	if not dataPlayer.Swift.RateOfOrbitRotation then
		dataPlayer.Swift.RateOfOrbitRotation = 0
	end
	dataPlayer.Swift.Instance = {degreeOfWeaponSpawns, offset} --Even if stats change while the attack is active, this is to ensure consistency during 1 instance of a Swift attack
	dataPlayer.Swift.NumWeaponsSpawned = 1
	dataPlayer.Swift.TimeTillNextWeapon = swiftBase:SwiftFireDelay(player)
	dataPlayer.Swift.MultiShots = swiftSynergies:MultiShotCount(player)
	local isConstant = false
	if swiftBase:SwiftShouldBeConstant(player) then
		isConstant = true
	else
		isConstant = false
	end
	if swiftSynergies:IsKidneyStoneActive(player) then
		isConstant = true
		if not dataPlayer.Swift.KidneyTimer then
			dataPlayer.Swift.KidneyTimer = 300
		end
	end
	dataPlayer.Swift.Constant = isConstant
	if isConstant then
		dataPlayer.Swift.ConstantFiring = true
	end
end

local function FireKnifeBrim(player)
	local dataPlayer = player:GetData()
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
	and player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		if dataPlayer.Swift
		and dataPlayer.Swift.NumWeaponsSpawned
		and dataPlayer.Swift.NumWeaponsSpawned > 0
		then
			local knivesSpawned = dataPlayer.Swift.NumWeaponsSpawned
			for i = 1, knivesSpawned do
				local degrees = Vector.FromAngle(((360/knivesSpawned) * i)) --???
				local direction = swiftBase:SwiftShotVelocity(degrees, player, false)
				swiftAttack:FireExtraWeapon(player, player, direction)
			end
		end
	end
end

local function TriggerSwiftCooldown(player)
	local dataPlayer = player:GetData()
	
	if dataPlayer.Swift.AttackDuration
	and dataPlayer.Swift.AttackDuration == 0 
	and not dataPlayer.Swift.AttackCooldown then
		FireKnifeBrim(player)
	end
	
	dataPlayer.Swift.AttackDuration = 0
	dataPlayer.Swift.NumWeaponsSpawned = 0

	if not dataPlayer.Swift.AttackCooldown then
		dataPlayer.Swift.AttackCooldown = swiftBase:SwiftFireDelay(player)
		dataPlayer.Swift.ExistingShots = nil
	end
end

local function TriggerSwiftCooldownIfPlayerStopsShooting(player)
	local dataPlayer = player:GetData()

	if player:GetFireDirection() == Direction.NO_DIRECTION
	and dataPlayer.Swift
	and dataPlayer.Swift.AttackDuration 
	and ((not dataPlayer.Swift.Constant and dataPlayer.Swift.AttackDuration > 0)
	or (dataPlayer.Swift.Constant and dataPlayer.Swift.ConstantFiring == true)) then
		FireKnifeBrim(player)
		TriggerSwiftCooldown(player)
		dataPlayer.Swift.ConstantFiring = false
	end
end

local function SwiftWeaponUpdateSynergies(weapon, player)
	local dataWeapon = weapon:GetData()
	local dataPlayer = player:GetData()
	
	swiftSynergies:ChocolateMilkDamageScaling(weapon, player)
	swiftSynergies:DelayTearFlags(weapon, player)
	swiftSynergies:TinyPlanetDistance(player, weapon)
	swiftSynergies:AntiGravityDuration(player, weapon)
			
	if swiftSynergies:ShouldAttachTech2Laser(weapon, player)
	and dataWeapon.Swift
	and dataWeapon.Swift.ShotDir 
	and not dataWeapon.Swift.Tech2Attached then
		swiftLaser:FireTechLaser(weapon, player, dataWeapon.Swift.ShotDir, true)
		dataWeapon.Swift.Tech2Attached = true
	end
end

local function ShouldWizShot(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
	or player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY)
	then
		return true
	else
		return false
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
	local dataWeapon = weapon:GetData()
	local dataPlayer = player:GetData()
	local fireDirection = swiftBase:SwiftShotVelocity(dataWeapon.Swift.ShotDir, player, true)
	
	if player:GetEffects():HasNullEffect(NullItemID.ID_WIZARD) then
		if not dataPlayer.Swift.WizardShot then
			dataPlayer.Swift.WizardShot = 45
		else
			if dataPlayer.Swift.WizardShot == 45 then
				dataPlayer.Swift.WizardShot = -45
			elseif dataPlayer.Swift.WizardShot == -45 then
				dataPlayer.Swift.WizardShot = 45
			end
		end
	else
		dataPlayer.Swift.WizardShot = 0
	end
	
	--Loki's Horns, Mom's Eye, Eye Sore, Monstro's Lung
	if not dataWeapon.MultiSwiftTear then
		if (not dataPlayer.Swift.Constant) or (dataPlayer.Swift.Constant and not player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)) then
			swiftAttack:ShouldFireExtraWeapons(weapon, player, fireDirection)
		end
	end
	
	--Wiz rotation
	if ShouldWizShot(player) 
	and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		fireDirection = fireDirection:Rotated(45 + dataPlayer.Swift.WizardShot)
	end
	
	if not dataWeapon.Swift.ConstantOrbit then
		if weapon.Type ~= EntityType.ENTITY_EFFECT then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
				weapon.Velocity = fireDirection
			else
				weapon.Velocity = Vector.Zero
				dataWeapon.Swift.AntiGravTimer = 90
				dataWeapon.Swift.AntiGravDir = fireDirection
				if weapon.Type == EntityType.ENTITY_TEAR then
					dataWeapon.Swift.AntiGravHeight = weapon.Height
				end
			end
		else
			weapon.Velocity = Vector.Zero
		end
	else
		swiftAttack:FireExtraWeapon(weapon, player, fireDirection)
	end
	
	--Wiz opposite rotation
	if ShouldWizShot(player)
	and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		fireDirection = fireDirection:Rotated(-90 + dataPlayer.Swift.WizardShot)
	end
	
	if ShouldWizShot(player) then
		swiftAttack:FireExtraWeapon(weapon, player, fireDirection)
		if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ) >= 2
		or player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
			swiftAttack:FireExtraWeapon(weapon, player, fireDirection:Rotated(45 + dataPlayer.Swift.WizardShot))
		end
	end
	
	if dataPlayer.Swift.Constant then
		dataWeapon.Swift.ShotDelay = swiftBase:SwiftShotDelay(weapon, player)
	end
end

function swiftAttack:FireExtraWeapon(parent, player, direction, rotationOffset)
	local dataPlayer = player:GetData()
	if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		swiftKnife:FireSwiftKnife(parent, player, direction)
	elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
		swiftBomb:FireSwiftBomb(parent, player, direction)
	elseif player:HasWeaponType(WeaponType.WEAPON_LASER)
	or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
	or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
		swiftLaser:FireSwiftLaser(parent, player, swiftBase:SwiftShotVelocity(parent:GetData().Swift.ShotDir, player, false), rotationOffset)
	elseif player:HasWeaponType(WeaponType.WEAPON_TEARS)
	or player:HasWeapon(WeaponType.WEAPON_MONSTROS_LUNGS) then
		swiftTear:FireSwiftTear(parent, player, direction)
	end
end

function swiftAttack:ShouldFireExtraWeapons(weapon, player, direction)
	local dataWeapon = weapon:GetData()

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
	local dataPlayer = player:GetData()
	local dataWeapon = weapon:GetData()
	local shootDir = EEVEEMOD.API.GetIsaacShootingDirection(player)
	
	--Orbiting the player, rotating around them.
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM) then
		if dataPlayer.Swift.RateOfOrbitRotation and dataWeapon.Swift.PosToFollow then
			if not dataWeapon.MultiSwiftTear then
				weapon.Velocity = player.Position - (weapon.Position + dataWeapon.Swift.PosToFollow:Resized(dataWeapon.Swift.DistFromPlayer):Rotated(dataPlayer.Swift.RateOfOrbitRotation))			
			end
		end
	else
		weapon.Position = player.Position + dataWeapon.Swift.ShotDir:Resized(dataWeapon.Swift.DistFromPlayer)
	end
	
	dataWeapon.Swift.ShotDir = shootDir

	if dataPlayer.Swift.AttackDuration
	and dataPlayer.Swift.AttackDuration <= 0
	and not dataWeapon.Swift.CanFire
	then
		dataWeapon.Swift.CanFire = true
	end
	
	if player:IsDead() and not dataWeapon.Swift.HasFired then
		swiftAttack:SwiftMainFireWeapon(weapon, player)
		dataWeapon.Swift.HasFired = true
	end
end

function swiftAttack:SwiftAttackUpdate(weapon)
	local dataWeapon = weapon:GetData()

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
	
	if weapon.SpawnerType == EntityType.ENTITY_PLAYER then
		local player = weapon.SpawnerEntity:ToPlayer() or weapon.SpawnerEntity:ToFamiliar().Player
		local dataPlayer = player:GetData()
		
		if dataPlayer.Swift
		and dataWeapon.Swift
		and dataWeapon.Swift.IsSwiftWeapon then
		
			SwiftWeaponUpdateSynergies(weapon, player)
			swiftAttack:ShouldRestoreSwiftTrail(player, weapon)
			swiftAttack:SwiftMultiRotation(player, weapon)
			swiftBase:RetainArcShot(player, weapon)
			
			if not dataWeapon.Swift.HasFired then

				swiftAttack:SwiftAttackWaitingToFire(weapon, player)

				if dataWeapon.Swift.CanFire then
					
					if not dataPlayer.Swift.Constant or not dataWeapon.Swift.ConstantOrbit then

						if dataWeapon.Swift.ShotDelay <= 0 then

							if weapon.Type ~= EntityType.ENTITY_EFFECT then
								swiftBase:SwiftTearFlags(weapon, false, true)
							end
							swiftAttack:SwiftMainFireWeapon(weapon, player)
							dataWeapon.Swift.HasFired = true
						end
					else
						if dataWeapon.Swift.ShotDelay <= 0 then
							if swiftBase:IsSwiftLaserEffect(weapon) == "brim" then
								if not dataWeapon.Swift.LaserHasFired then
									swiftAttack:SwiftMainFireWeapon(weapon, player)
								end
							else
								swiftAttack:SwiftMainFireWeapon(weapon, player)
							end					
						end
						
						if player:GetFireDirection() == Direction.NO_DIRECTION then
							dataWeapon.Swift.ConstantOrbit = false
							dataWeapon.Swift.ShotDelay = 0
						end
					end
				end
			end
		end
	end
end

function swiftAttack:SwiftMultiRotation(player, weapon)
	local dataWeapon = weapon:GetData()
	
	if not dataWeapon.MultiSwiftTear then
		if not dataWeapon.Swift.MultiShotRotation then
			dataWeapon.Swift.MultiShotRotation = 360
		else
			local rate = dataWeapon.Swift.MultiShotRotation - 15 * player.ShotSpeed
			if rate < 0 then rate = rate + 360 end
			dataWeapon.Swift.MultiShotRotation = rate
		end
	else
		if dataWeapon.MultiSwiftTear and dataWeapon.MultiSwiftTear:Exists() then
			local dataWeaponParent = dataWeapon.MultiSwiftTear:GetData()
			if dataWeaponParent.Swift.MultiShotRotation then
				weapon.Velocity = dataWeapon.MultiSwiftTear.Position - (weapon.Position + dataWeapon.Swift.PosToFollow:Resized(dataWeapon.MultiSwiftOrbitDistance):Rotated(dataWeaponParent.Swift.MultiShotRotation))
			end
		end
	end
end

function swiftAttack:ShouldRestoreWeapon(player)
	local dataPlayer = player:GetData()
	if dataPlayer.Swift
	and dataPlayer.Swift.ExistingShots
	then
		for i = 1, #dataPlayer.Swift.ExistingShots do
			if dataPlayer.Swift.Constant
			and dataPlayer.Swift.ConstantFiring
			and not dataPlayer.Swift.AttackCooldown
			and player:GetFireDirection() ~= Direction.NO_DIRECTION
			and not dataPlayer.Swift.ExistingShots[i]:Exists()
			then
				local originalNumSpawned = dataPlayer.Swift.NumWeaponsSpawned
				dataPlayer.Swift.NumWeaponsSpawned = i
				swiftAttack:SpawnSwiftWeapon(player, dataPlayer.Swift.Instance[1], dataPlayer.Swift.Instance[2])
				dataPlayer.Swift.NumWeaponsSpawned = originalNumSpawned
			end
		end
	end
end

function swiftAttack:ShouldRestoreSwiftTrail(player, weapon)
	local dataPlayer = player:GetData()
	local dataWeapon = weapon:GetData()
	if dataWeapon.Swift.Trail and not dataWeapon.Swift.Trail:Exists() then
		if (not dataPlayer.Swift.Constant) or (dataPlayer.Swift.Constant and dataWeapon.Swift.ConstantOrbit) then
			swiftBase:AddSwiftTrail(weapon, player)
		end
	end
end

function swiftAttack:SwiftInit(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()
	
	if playerType == EEVEEMOD.PlayerType.EEVEE
	and not EEVEEMOD.game:IsPaused()
	and dataPlayer.Swift ~= nil then

		if not swiftSynergies:WeaponShouldOverrideSwift(player) then
		
			if EEVEEMOD.API.PlayerCanControl(player) then
			
				if player:GetFireDirection() ~= Direction.NO_DIRECTION
				and not dataPlayer.Swift.AttackCooldown
				and not dataPlayer.Swift.AttackInit then
						
					CalculateSwiftStats(player)
					swiftAttack:SpawnSwiftWeapon(player, dataPlayer.Swift.Instance[1], dataPlayer.Swift.Instance[2])
					dataPlayer.Swift.AttackInit = true
						
				end
				
				--Basic updates
				TriggerSwiftCooldownIfPlayerStopsShooting(player)
				swiftAttack:ShouldRestoreWeapon(player)
				
				--Updating Kidney Stone's Constant Fire Override
				if swiftBase:SwiftShouldBeConstant(player) == false
				and not dataPlayer.Swift.KidneyTimer then
					dataPlayer.Swift.Constant = false
				end
				
				--For sudden firerate changes
				if dataPlayer.Swift.AttackDurationSet and dataPlayer.Swift.AttackDuration > 0 then
					local expectedDuration = swiftBase:SwiftFireDelay(player) * 5
					if dataPlayer.Swift.AttackDurationSet ~= expectedDuration then
						if expectedDuration < dataPlayer.Swift.AttackDurationSet then 
							local firerateDif = dataPlayer.Swift.AttackDurationSet - expectedDuration
							dataPlayer.Swift.AttackDuration = dataPlayer.Swift.AttackDuration - firerateDif
						else
							local firerateDif = expectedDuration - dataPlayer.Swift.AttackDurationSet
							dataPlayer.Swift.AttackDuration = dataPlayer.Swift.AttackDuration + firerateDif
						end
						dataPlayer.Swift.AttackDurationSet = expectedDuration
						dataPlayer.Swift.TimeTillNextWeapon = swiftBase:SwiftFireDelay(player)
					end
				end
			end
		else
			if dataPlayer.Swift then
				if dataPlayer.Swift.AttackDuration and dataPlayer.Swift.AttackDuration > 0 then
					TriggerSwiftCooldown(player)
				end
				if dataPlayer.Swift.Constant then
					dataPlayer.Swift.Constant = false
				end
			end
		end
	elseif playerType ~= EEVEEMOD.PlayerType.EEVEE then
		if dataPlayer.Swift then
			TriggerSwiftCooldown(player)
			dataPlayer.Swift = nil
		end
	end
end

--------------
--  TIMERS  --
--------------

local function SwiftShotDelayTimer()
	local TypeToFind = {
		{EntityType.ENTITY_TEAR, -1},
		{EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT},
		{EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL},
		{EntityType.ENTITY_KNIFE, -1},
		{EntityType.ENTITY_LASER, -1},
		{EntityType.ENTITY_BOMBDROP, -1}
	}
	for i = 1, #TypeToFind do
		for _, weapon in pairs(Isaac.FindByType(TypeToFind[i][1], TypeToFind[i][2], 0)) do
			local dataWeapon = weapon:GetData()
			
			if dataWeapon.Swift then
				if dataWeapon.Swift.IsSwiftWeapon 
				and dataWeapon.Swift.CanFire
				and dataWeapon.Swift.ShotDelay
				and dataWeapon.Swift.ShotDelay > 0 then
					dataWeapon.Swift.ShotDelay = dataWeapon.Swift.ShotDelay - 0.5
				end
				local screenposW = EEVEEMOD.game:GetRoom():WorldToScreenPosition(weapon.Position)
				local shootDir = "nil"
				local hasTech2 = "false"
				local inConstantOrbit = "false"
				local shotdelay = "nil"
				local hasFired = "false"
				if dataWeapon.Swift then
					if dataWeapon.Swift.HasFired then
						hasFired = "true"
					end
					if dataWeapon.Swift.ShotDelay then
						shotdelay = dataWeapon.Swift.ShotDelay
					end
					if dataWeapon.Swift.Tech2Attached then
						hasTech2 = "true"
					end
					if dataWeapon.Swift.ShotDir then
						shootDir = dataWeapon.Swift.ShotDir
					end
					if dataWeapon.Swift.ConstantOrbit then
						inConstantOrbit = "true"
					end
					local fired = "false"
					if dataWeapon.Swift.LaserHasFired then
						fired = "true"
					end
					--Isaac.RenderText(hasFired, screenposW.X, screenposW.Y + 30, 1, 1, 1, 1)
					--Isaac.RenderText(tostring(dataWeapon.Swift.Timer), screenposW.X, screenposW.Y + 70, 1, 1, 1, 1)
					--Isaac.RenderText("Dir: "..shootDir.X..", "..shootDir.Y, screenposW.X, screenposW.Y + 30, 1, 1, 1, 1)
					--Isaac.RenderText("Constant: "..inConstantOrbit, screenposW.X, screenposW.Y + 10, 1, 1, 1, 1)
					--Isaac.RenderText("Has Fired Laser: "..fired, screenposW.X, screenposW.Y + 50, 1, 1, 1, 1)
					--Isaac.RenderText("Tech 2: "..hasTech2, screenposW.X, screenposW.Y + 50, 1, 1, 1, 1)
				end
			end
		end
	end
end

local function SwiftDurationHandle(player)
	local dataPlayer = player:GetData()
	if dataPlayer.Swift
	and dataPlayer.Swift.AttackDuration
	and not dataPlayer.Swift.AttackCooldown then
		
		local attackDuration = dataPlayer.Swift.AttackDuration
		if attackDuration > 0.5 then
			attackDuration = attackDuration - 0.5
		else
			if dataPlayer.Swift.NumWeaponsSpawned >= 5 then
				attackDuration = 0
				if not dataPlayer.Swift.Constant then
					TriggerSwiftCooldown(player)
				end
			elseif player:GetFireDirection() ~= Direction.NO_DIRECTION and dataPlayer.Swift.AttackInit then
				attackDuration = 0.5
			end
		end
		dataPlayer.Swift.AttackDuration = attackDuration
	end
end

local function SwiftRateOfRotation(player)
	local dataPlayer = player:GetData()
	
	if dataPlayer.Swift
	and dataPlayer.Swift.RateOfOrbitRotation
	and dataPlayer.Swift.AttackDuration
	and not dataPlayer.Swift.AttackCooldown then
		if dataPlayer.Swift.Constant or player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET) then
			local rate = dataPlayer.Swift.RateOfOrbitRotation + 5 * player.ShotSpeed
			if rate > 360 then rate = rate - 360 end
			dataPlayer.Swift.RateOfOrbitRotation = rate
		else
			if dataPlayer.Swift.AttackDuration > 0 then
				local rate = dataPlayer.Swift.RateOfOrbitRotation + math.floor(dataPlayer.Swift.AttackDuration / 4)
				if dataPlayer.Swift.AttackDuration > 50 then
					rate = dataPlayer.Swift.RateOfOrbitRotation + 12.5
				end
				if rate > 360 then rate = rate - 360 end
				dataPlayer.Swift.RateOfOrbitRotation = rate
			end
		end
	end
end

local function SwiftCooldownTimer(player)
	local dataPlayer = player:GetData()
	if dataPlayer.Swift.AttackCooldown then
		if dataPlayer.Swift.AttackCooldown > 0 then
			dataPlayer.Swift.AttackCooldown = dataPlayer.Swift.AttackCooldown - 0.5
		else
			dataPlayer.Swift.AttackCooldown = nil
			dataPlayer.Swift.AttackInit = false
		end
	end
end

local function SwiftSpawningNextWeapon(player)
	local dataPlayer = player:GetData()
	if dataPlayer.Swift.AttackDuration
	and dataPlayer.Swift.AttackDuration > 0
	and player:GetFireDirection() ~= Direction.NO_DIRECTION 
	then
		if dataPlayer.Swift.TimeTillNextWeapon > 0 then
			dataPlayer.Swift.TimeTillNextWeapon = dataPlayer.Swift.TimeTillNextWeapon - 0.5
		else
			if dataPlayer.Swift.NumWeaponsSpawned < 5 then
				dataPlayer.Swift.NumWeaponsSpawned = dataPlayer.Swift.NumWeaponsSpawned + 1
				swiftAttack:SpawnSwiftWeapon(player, dataPlayer.Swift.Instance[1], dataPlayer.Swift.Instance[2])
				dataPlayer.Swift.TimeTillNextWeapon = swiftBase:SwiftFireDelay(player)
			end
		end
	end
end

function swiftAttack:SwiftAttackTimers(player)
	local dataPlayer = player:GetData()
	if EEVEEMOD.API.PlayerCanControl(player) and dataPlayer.Swift then
		SwiftShotDelayTimer()
		SwiftDurationHandle(player)
		SwiftRateOfRotation(player)
		SwiftCooldownTimer(player)
		SwiftSpawningNextWeapon(player)
		swiftSynergies:KidneyStoneDuration(player)
	end
end

-- MISC

function swiftAttack:RespawnSwiftPerRoom(player)
	local dataPlayer = player:GetData()

	if dataPlayer.Swift
	and dataPlayer.Swift.NumWeaponsSpawned
	and dataPlayer.Swift.NumWeaponsSpawned > 0 then
	local currentCount = dataPlayer.Swift.NumWeaponsSpawned
		for i = 1, currentCount do
			dataPlayer.Swift.NumWeaponsSpawned = i
			swiftAttack:SpawnSwiftWeapon(player, dataPlayer.Swift.Instance[1], dataPlayer.Swift.Instance[2])
			EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
		end
	end
end

function swiftAttack:SwiftTrailUpdate(trail)
	if trail.Parent
	and trail.Parent:GetData().Swift
	and trail.Parent:GetData().Swift.IsSwiftWeapon then
		local weapon = trail.Parent
		local room = EEVEEMOD.game:GetRoom()
		
		if trail:GetData().EeveeRGB == true then
			EEVEEMOD.API.GiveRGB(trail:GetSprite())
		else
			local tC = trail.Color
			local wC = weapon:GetSprite().Color
			if weapon.Type == EntityType.ENTITY_TEAR then
				if weapon:GetData().Swift.IsFakeKnife then
					trail:SetColor(Color(wC.R, wC.G, wC.B, 1, wC.RO, wC.GO, wC.BO), -1, 1, true, false)
				else
					trail:SetColor(wC, -1, 1, true, false)
				end
			end
		end
		
		if not room:IsPositionInRoom(trail.Position, -30) then
			local tC = trail.Color
			trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 5, 2, true, false)
		end
		
		if weapon.Type == EntityType.ENTITY_TEAR then
			local tearHeightToFollow = weapon:ToTear().Height
			local sizeToFollow = weapon.Size * 0.5
			local heightDif = 0
			trail.SpriteScale = Vector(weapon.Size * 0.2, 1)

			if weapon:GetData().Swift.IsFakeKnife then
				heightDif = 10
			end
			trail.Position = Vector(weapon.Position.X, (weapon.Position.Y + (tearHeightToFollow + heightDif)) - sizeToFollow) + weapon:ToTear().PosDisplacement
		else
			trail.Position = Vector(weapon.Position.X, weapon.Position.Y + weapon.PositionOffset.Y)
		end
	end
end

-- DEBUG

function swiftAttack:onRender()
	local player = Isaac.GetPlayer()
	local dataPlayer = player:GetData()
	local cooldown = "nil"
	if dataPlayer.Swift then
		if dataPlayer.Swift.AttackCooldown then
			cooldown = dataPlayer.Swift.AttackCooldown
		end
		local duration = "nil"
		if dataPlayer.Swift.AttackDuration then
			duration = dataPlayer.Swift.AttackDuration
		end
		local rotation = "nil"
		if dataPlayer.Swift.RateOfOrbitRotation then
			rotation = dataPlayer.Swift.RateOfOrbitRotation
		end
		local delaybetweenshots = "nil"
		if dataPlayer.Swift.TimeTillNextWeapon then
			delaybetweenshots = dataPlayer.Swift.TimeTillNextWeapon
		end
		local numtears = "nil"
		if dataPlayer.Swift.NumWeaponsSpawned then
			numtears = dataPlayer.Swift.NumWeaponsSpawned
		end
		--Isaac.RenderText("Cooldown: "..cooldown, 50, 50, 1, 1, 1, 1)
		--Isaac.RenderText("Duration: "..duration, 50, 70, 1, 1, 1, 1)
		--Isaac.RenderText("Rotation: "..rotation, 50, 90, 1, 1, 1, 1)
		--Isaac.RenderText("Tear Spawn: "..delaybetweenshots, 50, 110, 1, 1, 1, 1)
		--Isaac.RenderText("Num Tears Spawned: "..numtears, 50, 130, 1, 1, 1, 1)
	end
end

return swiftAttack