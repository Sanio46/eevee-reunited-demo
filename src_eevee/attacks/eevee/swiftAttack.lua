local swiftAttack = {}

local attackHelper = require("src_eevee.attacks.attackHelper")
local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")
local swiftLaser = require("src_eevee.attacks.eevee.swiftLaser")
local swiftKnife = require("src_eevee.attacks.eevee.swiftKnife")
local swiftBomb = require("src_eevee.attacks.eevee.swiftBomb")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")

------------------
--  INITIATING  --
------------------

---@param swiftData SwiftInstance
---@param shouldFire boolean
local function IsSwiftPlayerFiring(swiftData, shouldFire)
	local player = swiftData.Player

	if not player then return end
	local isFiring = player:GetFireDirection() ~= Direction.NO_DIRECTION

	isFiring = shouldFire == true and isFiring or shouldFire == false and not isFiring

	if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS then
		isFiring = not isFiring
	elseif swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_SPIRIT_SWORD
		or swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_LUDOVICO
	then
		isFiring = false
	end

	return isFiring
end

---@param player EntityPlayer
function swiftAttack:StartAttack(player)
	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
	if not swiftPlayer then return end
	local numNeptunusInstances = swiftBase.GetNumNeptunusInstances(swiftPlayer)

	if swiftPlayer.CanFire then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS)
			or player:GetFireDirection() ~= Direction.NO_DIRECTION
		then
			swiftPlayer.Cooldown = swiftBase:GetInstanceCooldown(player)
			if swiftBase:GetInstanceType(player) == swiftBase.InstanceType.INSTANCE_NEPTUNUS then
				swiftPlayer.NumNeptunusInstancesUnfired = swiftPlayer.NumNeptunusInstancesUnfired + 1
				if numNeptunusInstances < 2 then
					swiftPlayer.Cooldown = swiftPlayer.Cooldown - (swiftBase:GetFireDelay(player, true) * 2)
				end
			end
			swiftAttack:CreateSwiftInstance(player, player)
			swiftPlayer.CanFire = false
		end
	end
	if swiftPlayer.Cooldown then
		if swiftPlayer.Cooldown > 0 then
			swiftPlayer.Cooldown = swiftPlayer.Cooldown - 0.5
		elseif swiftPlayer.CanFire == false and
			(
			not player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) or
				(
				player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) and
					(
					swiftPlayer.NumNeptunusInstancesUnfired < 2
					)
				)
			) then
			local soyBrimActive = swiftSynergies:IsSoyBrim(player)
			local numNeeded = player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) and 2 or 1
			if not soyBrimActive or (soyBrimActive and #swiftPlayer.OwnedInstances < numNeeded) then
				swiftPlayer.CanFire = true
			end
		end
	end
end

---@param player EntityPlayer
---@param parent Entity
function swiftAttack:CreateSwiftInstance(player, parent)
	---@type SwiftInstance
	local instance = {}
	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
	VeeHelper.copyOverTable(swiftBase.swiftInstanceData, instance)
	table.insert(swiftBase.Instances, instance)
	if swiftPlayer then
		table.insert(swiftPlayer.OwnedInstances, instance)
	end
	local swiftData = swiftBase.Instances[#swiftBase.Instances]
	swiftData.Player = player
	swiftData.Parent = parent
	swiftData.InstanceType = swiftBase:GetInstanceType(player)
	swiftAttack:InitInstanceValues(swiftData)
	swiftAttack:SpawnSwiftWeapon(swiftData)
end

---@param swiftData SwiftInstance
function swiftAttack:InitInstanceValues(swiftData)
	---@type EntityPlayer
	local player = swiftData.Player
	if not player then return end
	local fireDelay = swiftBase:GetFireDelay(player)
	local totalDuration = (fireDelay * swiftData.NumWeaponsToSpawn) + 0.5
	local defaultNumStars = 5

	if swiftSynergies:ShouldUseTinyPlanet(player) then
		totalDuration = totalDuration * 3
	elseif swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_SPIRIT_SWORD then
		totalDuration = 10
	end

	swiftData.TotalDuration = totalDuration
	swiftData.DurationTimer = swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_LUDOVICO and totalDuration / 2 or
		totalDuration
	swiftData.WeaponSpawnTimer = fireDelay
	swiftData.ShotMultiplier = swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_SPIRIT_SWORD and 1 or
		attackHelper:GetMultiShot(player)
	swiftData.NumWeaponsToSpawn = defaultNumStars * swiftData.ShotMultiplier
	swiftData.Rotation = attackHelper:GetIsaacShootingDirection(player):Rotated(-1 *
		(360 / swiftData.NumWeaponsToSpawn) - 45):GetAngleDegrees()

	if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS then
		local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
		if not swiftPlayer then return end

		local numNeptunusInstances = swiftBase.GetNumNeptunusInstances(swiftPlayer)

		-- dumb bruteforced hack, might break if any other constants change -oat
		if numNeptunusInstances >= 2 then
			-- gets a consistent rotation relative to the inner layer at any fire delay to make a star shape
			local alignedRotation = fireDelay * 20 - 5
			swiftData.Rotation = alignedRotation
		end
	else
		--If firerates go too fast, the 
		local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
		if swiftPlayer then
			local lastInstance = swiftPlayer.OwnedInstances[#swiftPlayer.OwnedInstances - 1]
			if #swiftPlayer.OwnedInstances > 1 and fireDelay <= 2 then
				swiftData.Rotation = lastInstance.Rotation
			end
		end
	end
end

---@param swiftData SwiftInstance
function swiftAttack:SpawnSwiftWeapon(swiftData)
	local player = swiftData.Player
	if not player then return end
	for mult = 1, swiftData.ShotMultiplier do
		local isMult = mult > 1 and true or false

		swiftData.NumWeaponsSpawned = swiftData.NumWeaponsSpawned + 1

		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			swiftKnife:SpawnSwiftKnives(swiftData, isMult)
		elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			swiftBomb:SpawnSwiftBomb(swiftData, isMult)
		elseif (
			player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
				or player:HasWeaponType(WeaponType.WEAPON_LASER)
				or player:HasWeaponType(WeaponType.WEAPON_TECH_X)
			)
		then
			swiftLaser:SpawnSwiftLasers(swiftData, isMult)
		elseif player:HasWeaponType(WeaponType.WEAPON_TEARS)
			or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS)
			or player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
			or player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE)
		then
			swiftTear:SpawnSwiftTears(swiftData, isMult)
		end
	end
end


---@param knife EntityKnife
function swiftAttack:SpiritSwordInit(knife)
	local sprite = knife:GetSprite()
	if (knife.Variant ~= VeeHelper.KnifeVariant.SPIRIT_SWORD
		and knife.Variant ~= VeeHelper.KnifeVariant.TECH_SWORD)
		or knife:GetEntityFlags() ~= 67108864
	then
		return
	end
	local player = knife.SpawnerEntity:ToPlayer()
	if not player then return end
	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
	if not swiftPlayer then return end
	local data = knife:GetData()
	local spinAnims = {
		"SpinRight",
		"SpinLeft",
		"SpinUp",
		"SpinDown",
	}
	if VeeHelper.IsSpritePlayingAnims(sprite, spinAnims) then
		if sprite:IsPlaying(sprite:GetAnimation()) then
			if (sprite:GetFrame() == 0 or sprite:GetFrame() == 2) and not data.SwiftFiredOnFirstFrame then
				swiftAttack:CreateSwiftInstance(player, player)
				data.SwiftFiredOnFirstFrame = true
			elseif sprite:GetFrame() > 2 and data.SwiftFiredOnFirstFrame then
				data.SwiftFiredOnFirstFrame = false
			end
		end
	end
end

---@param tearOrKnife EntityTear | EntityKnife
function swiftAttack:InitLudoTearOrKnifeOnUpdate(tearOrKnife)
	if not tearOrKnife:HasTearFlags(TearFlags.TEAR_LUDOVICO) then return end
	local player = tearOrKnife.SpawnerEntity:ToPlayer()
	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
	if not swiftPlayer then return end
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(tearOrKnife))]
	if swiftWeapon or tearOrKnife:GetData().SwiftKnife then return end
	if tearOrKnife.FrameCount == 1 then
		tearOrKnife.Visible = false
		tearOrKnife.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		tearOrKnife:ClearTearFlags(tearOrKnife.TearFlags)
		tearOrKnife:AddTearFlags(TearFlags.TEAR_LUDOVICO)
		EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
	else
		if not swiftPlayer.SpawnedLudoTear then
			swiftPlayer.SpawnedLudoTear = true
			swiftAttack:CreateSwiftInstance(player, tearOrKnife)
		end
	end
end

--------------
--  FIRING  --
--------------

--This is just so Rocket Bombs can fire in the right fucking direction
---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param bomb EntityBomb
local function RefireRocketBomb(swiftData, swiftWeapon, bomb, direction)
	local player = swiftData.Player
	if not player then return end
	local newBomb = player:FireBomb(bomb.Position, attackHelper:TryFireToEnemy(player, bomb, direction, 30), player)
	newBomb.Flags = bomb.Flags
	newBomb:SetExplosionCountdown(35)
	swiftBase.Weapons[tostring(GetPtrHash(newBomb))] = {}
	local newSwiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(newBomb))]

	VeeHelper.copyOverTable(swiftWeapon, newSwiftWeapon)
	newSwiftWeapon.WeaponEntity = newBomb
	newSwiftWeapon.HasFired = true

	for index, childWeapons in pairs(swiftData.ChildSwiftWeapons) do
		if tostring(GetPtrHash(bomb)) == tostring(GetPtrHash(childWeapons.WeaponEntity)) then
			table.remove(swiftData.ChildSwiftWeapons, index)
			table.insert(swiftData.ChildSwiftWeapons, index, newSwiftWeapon)
			break
		end
	end
	swiftBase.Weapons[tostring(GetPtrHash(bomb))] = nil
	bomb:Remove()
	swiftData.NumWeaponsRemoved = swiftData.NumWeaponsRemoved - 1
end

---@param swiftData SwiftInstance
---@param firedEarly? boolean
function swiftAttack:WeaponAbleToFire(swiftData, firedEarly)
	---@type EntityEffect
	local antiGravParent
	local player = swiftData.Player
	if not player then return end
	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
	if not swiftPlayer then return end

	for index, swiftWeapon in ipairs(swiftData.ChildSwiftWeapons) do
		if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_ANTI_GRAV and not firedEarly then
			if index == 1 then
				antiGravParent = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.ANTI_GRAV_PARENT, 0,
					swiftData.Parent.Position, Vector.Zero, nil):ToEffect()
				antiGravParent:GetData().ParentInstance = swiftData
				antiGravParent:Update()
			end
			swiftData.Parent = antiGravParent
			swiftWeapon.FireDelay = swiftWeapon.FireDelay + 90
			swiftWeapon.AntiGravBlinkToReduceBy = swiftWeapon.FireDelay / 6
			swiftWeapon.AntiGravBlinkThreshold = swiftWeapon.AntiGravBlinkToReduceBy * 5
		end
	end

	swiftData.CanFire = true

	if firedEarly then
		local baseNumSpawned = swiftData.NumWeaponsSpawned / swiftData.ShotMultiplier
		local baseNumToSpawn = swiftData.NumWeaponsToSpawn / swiftData.ShotMultiplier

		swiftPlayer.Cooldown = (swiftBase:GetFireDelay(player) * (0.8 + (baseNumSpawned / baseNumToSpawn)))
	end

	if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS then
		swiftPlayer.NumNeptunusInstancesUnfired = swiftPlayer.NumNeptunusInstancesUnfired - 1
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param weapon Weapon | EntityEffect
function swiftAttack:SwiftMainFireWeapon(swiftData, swiftWeapon, weapon)
	local player = swiftData.Player
	if not player then return end
	local direction = VeeHelper.AddTearVelocity(swiftWeapon.ShootDirection, player.ShotSpeed * 10, player)

	--Loki's Horns, Mom's Eye, Eye Sore, Monstro's Lung
	if not swiftWeapon.IsMultiShot then
		local ExtraShotItems = {
			CollectibleType.COLLECTIBLE_LOKIS_HORNS,
			CollectibleType.COLLECTIBLE_MOMS_EYE,
			CollectibleType.COLLECTIBLE_MONSTROS_LUNG,
			CollectibleType.COLLECTIBLE_EYE_SORE
		}
		for i = 1, #ExtraShotItems do
			if attackHelper:ShouldFireExtraShot(player, ExtraShotItems[i]) then
				local directions = attackHelper:GetExtraFireDirections(player, direction)
				for j = 1, #directions do
					swiftAttack:FireExtraWeapon(swiftData, swiftWeapon, directions[j])
				end
				break
			end
		end
	end

	--Wiz rotation
	if attackHelper:ShouldWizShot(player)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		direction = direction:Rotated(45)
	end

	if not weapon:ToEffect() or (weapon:ToEffect() and weapon.Variant == EffectVariant.EVIL_EYE) then
		---@cast weapon Weapon
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET) or swiftSynergies:ShouldUseTinyPlanet(player) then
			if weapon:ToBomb() and (weapon.Variant == BombVariant.BOMB_ROCKET or weapon.Variant == BombVariant.BOMB_ROCKET_GIGA) then
				---@cast weapon EntityBomb
				RefireRocketBomb(swiftData, swiftWeapon, weapon, direction)
			else
				weapon.Velocity = attackHelper:TryFireToEnemy(player, weapon, direction, 30)
			end
		end
	else
		weapon.Velocity = Vector.Zero
		swiftAttack:FireExtraWeapon(swiftData, swiftWeapon, direction)
	end

	--Wiz opposite rotation
	if attackHelper:ShouldWizShot(player)
		and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		direction = direction:Rotated(-90)
	end

	--Wiz opposite shot
	if attackHelper:ShouldWizShot(player) then
		swiftAttack:FireExtraWeapon(swiftData, swiftWeapon, direction)
		--Wiz "normal" shot
		if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ) >= 2
			or player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) then
			swiftAttack:FireExtraWeapon(swiftData, swiftWeapon, direction:Rotated(45))
		end
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
function swiftAttack:FireExtraWeapon(swiftData, swiftWeapon, direction)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftWeapon.WeaponEntity
	if not parent then return end

	if (
		parent.Type ~= EntityType.ENTITY_EFFECT
			or (parent.Type == EntityType.ENTITY_EFFECT and swiftBase:IsSwiftLaserEffect(parent))
		) then
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			swiftKnife:FireSwiftKnife(swiftData, swiftWeapon, direction)
		elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			swiftBomb:FireSwiftBomb(swiftData, swiftWeapon, direction)
		elseif player:HasWeaponType(WeaponType.WEAPON_LASER)
			or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
			or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
			swiftLaser:FireSwiftLaser(swiftData, swiftWeapon, direction)
		elseif player:HasWeaponType(WeaponType.WEAPON_TEARS)
			or player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
			swiftTear:FireSwiftTear(parent, player, direction)
		end
	end
end

---------------------
--  WEAPON UPDATE  --
---------------------

---@param swiftData SwiftInstance
---@param weapon Weapon | EntityEffect
function swiftAttack:PreFireUpdate(swiftData, swiftWeapon, weapon)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end

	if player:IsDead() then
		swiftAttack:WeaponAbleToFire(swiftData, true)
	end

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_TRACTOR_BEAM) then
		weapon.Velocity = parent.Position -
			(weapon.Position - swiftWeapon.StartingAngle:Resized(swiftWeapon.OrbitDistance):Rotated(swiftData.Rotation))
	else
		weapon.Position = parent.Position + swiftWeapon.ShootDirection:Resized(swiftWeapon.OrbitDistance)
	end
	
	if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_ANTI_GRAV then
		if swiftData.CanFire == true then
			if IsSwiftPlayerFiring(swiftData, false) and swiftWeapon.FireDelay > 0 then
				swiftWeapon.FireDelay = 0
			end
		else
			swiftWeapon.ShootDirection = attackHelper:GetIsaacShootingDirection(player, weapon.Position)
		end
	else
		swiftWeapon.ShootDirection = attackHelper:GetIsaacShootingDirection(player, weapon.Position)
	end
end

---@param weapon Weapon | EntityEffect
function swiftAttack:SwiftAttackUpdate(weapon)
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(weapon))]
	if not swiftWeapon then return end
	local swiftData = swiftWeapon.ParentInstance
	if not swiftData then return end

	if not swiftData.Parent or not swiftData.Parent:Exists() then
		weapon:Remove()
		return
	end

	if weapon:ToTear() then
		---@cast weapon EntityTear
		swiftTear:SwiftTearUpdate(swiftData, swiftWeapon, weapon)
		swiftAttack:OnSwiftLudoWeaponUpdate(swiftData, weapon)
	elseif (
		weapon:ToEffect()
			and swiftBase:IsSwiftLaserEffect(weapon)
		) then
		---@cast weapon EntityEffect
		swiftLaser:SwiftLaserEffectUpdate(swiftData, swiftWeapon, weapon)
	elseif weapon:ToBomb() then
		---@cast weapon EntityBomb
		swiftBomb:SwiftBombUpdate(swiftData, swiftWeapon, weapon)
	end

	if not VeeHelper.EntitySpawnedByPlayer(weapon) then return end
	local player = weapon.SpawnerEntity:ToPlayer()

	swiftSynergies:DelayTearFlags(swiftWeapon, weapon)
	swiftAttack:ShouldRestoreSwiftTrail(swiftWeapon, weapon, player)

	if swiftWeapon.HasFired then return end

	swiftSynergies:AntiGravityBlink(swiftWeapon, player, weapon)
	swiftSynergies:ChocolateMilkDamageScaling(swiftData, weapon)
	swiftSynergies:TinyPlanetDistance(swiftData, swiftWeapon)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
		if swiftWeapon.Special.HasTech2 == false then
			swiftLaser:FireTechLaser(swiftData, swiftWeapon, swiftWeapon.ShootDirection, true)
		end
	end
	swiftAttack:PreFireUpdate(swiftData, swiftWeapon, weapon)

	if swiftData.CanFire or player:IsDead() then
		if swiftWeapon.FireDelay > 0 then
			swiftWeapon.FireDelay = swiftWeapon.FireDelay - 1
		elseif swiftWeapon.HasFired == false then
			local soyBrimActive = swiftSynergies:IsSoyBrim(player)

			if not soyBrimActive or (soyBrimActive and not swiftWeapon.Special.SoyBrimEarlyFire) then
				swiftAttack:SwiftMainFireWeapon(swiftData, swiftWeapon, weapon)
				if soyBrimActive then
					swiftWeapon.Special.SoyBrimEarlyFire = true
				end
			end
			if not soyBrimActive or (soyBrimActive and IsSwiftPlayerFiring(swiftData, false)) then
				swiftWeapon.HasFired = true
				if soyBrimActive then
					weapon.Velocity = Vector.Zero
				end
			end
		end
	end
end

---@param swiftData SwiftInstance
---@param tear EntityTear
function swiftAttack:OnSwiftLudoWeaponUpdate(swiftData, tear)
	if swiftData.InstanceType ~= swiftBase.InstanceType.INSTANCE_LUDOVICO then return end
	local player = tear.SpawnerEntity:ToPlayer()
	if not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		tear:AddTearFlags(TearFlags.TEAR_LUDOVICO)
	end

	if math.floor(tear.FrameCount / player.MaxFireDelay) ~= math.floor((tear.FrameCount - 1) / player.MaxFireDelay) then
		swiftTear:AssignSwiftSprite(tear)
	end
end

-----------------------
--  INSTNACE UPDATE  --
-----------------------

---@param swiftData SwiftInstance
function swiftAttack:RegenerateSwiftWeapons(swiftData)
	if swiftData.InstanceType ~= swiftBase.InstanceType.INSTANCE_LUDOVICO then return end
	if swiftData.NumWeaponsRemoved > 0 then
		for loop = 1, 2 do
			for index, swiftWeapon in ipairs(swiftData.ChildSwiftWeapons) do
				if loop == 1 then
					if not swiftWeapon.WeaponEntity:Exists() then
						table.remove(swiftData.ChildSwiftWeapons, index)
						swiftData.NumWeaponsRemoved = swiftData.NumWeaponsRemoved - 1
					end
				else
					swiftData.NumWeaponsSpawned = index
					swiftWeapon.StartingAngle = swiftBase:GetStartingAngle(swiftData)
				end
			end
		end
	end
end

function swiftAttack:RetainSwiftInstanceOnNewRoom()
	if EEVEEMOD.game:GetFrameCount() == 0 then return end
	for _, swiftData in ipairs(swiftBase.Instances) do
		if (swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_DEFAULT
			or swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS)
			and #swiftData.ChildSwiftWeapons > 0
		then
			local numToSpawn = 0
			swiftData.NumWeaponsSpawned = 0
			swiftData.NumWeaponsRemoved = 0

			for _, swiftWeapon in ipairs(swiftData.ChildSwiftWeapons) do
				if swiftWeapon.HasFired == false and swiftWeapon.IsMultiShot == false then
					numToSpawn = numToSpawn + 1
				end
			end
			swiftData.ChildSwiftWeapons = {}
			for _ = 1, numToSpawn do
				swiftAttack:SpawnSwiftWeapon(swiftData)
			end
		end
	end
end

---@param swiftData SwiftInstance
function swiftAttack:FireIfNotShooting(swiftData)
	if IsSwiftPlayerFiring(swiftData, false)
		and not swiftData.CanFire
		and not EEVEEMOD.game:IsPaused()
	then
		swiftAttack:WeaponAbleToFire(swiftData, true)
	end
end

---@param swiftData SwiftInstance
function swiftAttack:SpawnNextWeapon(swiftData)
	if swiftData.NumWeaponsSpawned >= swiftData.NumWeaponsToSpawn then return end

	if swiftData.WeaponSpawnTimer > 0 then
		swiftData.WeaponSpawnTimer = swiftData.WeaponSpawnTimer - 0.5
	else
		swiftAttack:SpawnSwiftWeapon(swiftData)
		swiftData.WeaponSpawnTimer = swiftBase:GetFireDelay(swiftData.Player)
	end
end

---@param swiftData SwiftInstance
function swiftAttack:CountdownDuration(swiftData)
	local player = swiftData.Player
	if not player then return end
	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]
	if not swiftPlayer then return end

	if swiftData.DurationTimer >= 0.5 then
		if swiftData.InstanceType ~= swiftBase.InstanceType.INSTANCE_LUDOVICO then
			swiftData.DurationTimer = swiftData.DurationTimer - 0.5
		end
	elseif not swiftData.CanFire then
		swiftData.DurationTimer = 0
		if swiftData.InstanceType ~= swiftBase.InstanceType.INSTANCE_NEPTUNUS then
			swiftAttack:WeaponAbleToFire(swiftData)
		end
	end
end

---@param swiftData SwiftInstance
function swiftAttack:RateOfOrbitRotation(swiftData)
	local player = swiftData.Player
	if not player then return end
	--TODO: With faster firerates especially, the rotation looks boring being fired off so fast. Give faster firerates a faster rotation, or maybe a continuous one that each next instance follows?
	local rateLimit = 2
	if swiftSynergies:ShouldUseTinyPlanet(player) then
		rateLimit = 5
	end
	local currentRotation = swiftData.Rotation
	local rateOfRotation = (7 * (player.ShotSpeed * (swiftData.DurationTimer / swiftData.TotalDuration)))
	if swiftBase:GetFireDelay(player, false) <= 1 then
		rateOfRotation = 3 * player.ShotSpeed
	end
	if rateOfRotation <= rateLimit then rateOfRotation = rateLimit end
	currentRotation = currentRotation + rateOfRotation
	if currentRotation > 360 then currentRotation = currentRotation - 360 end
	swiftData.Rotation = currentRotation
end

----------------------
--  REMOVING SWIFT  --
----------------------

---@param effect EntityEffect
function swiftAttack:RemoveAntiGravPlaceholder(effect)
	local data = effect:GetData()
	if data.ParentInstance and #data.ParentInstance.ChildSwiftWeapons == 0 then effect:Remove() end
end

---@param swiftData SwiftInstance
function swiftAttack:RemoveSwiftBombsBeforeNewRoom(swiftData)
	local player = swiftData.Player
	if not player then return end
	local closestDoorSlot = VeeHelper.GetClosestDoorSlotPos(player.Position)

	if closestDoorSlot and player.Position:DistanceSquared(closestDoorSlot) <= 10 ^ 2 then
		for _, swiftWeapon in ipairs(swiftData.ChildSwiftWeapons) do
			if swiftWeapon.WeaponEntity:ToBomb() and swiftWeapon.HasFired == false then
				swiftWeapon.WeaponEntity:Remove()
			end
		end
	end
end

---@param swiftData SwiftInstance
---@param index integer
function swiftAttack:RemoveSwiftInstance(swiftData, index)
	if EEVEEMOD.game:GetFrameCount() == 0 then return end
	if (swiftData.CanFire or swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_LUDOVICO) and
		swiftData.NumWeaponsRemoved == swiftData.NumWeaponsSpawned then
		local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(swiftData.Player))]
		if swiftPlayer then
			if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_LUDOVICO then
				swiftPlayer.SpawnedLudoTear = false
			end
		end
		table.remove(swiftBase.Instances, index)
		for index, ownedSwiftData in ipairs(swiftPlayer.OwnedInstances) do
			if ownedSwiftData == swiftData then
				table.remove(swiftPlayer.OwnedInstances, index)
				break
			end
		end
	end
end

---@param weapon Weapon
function swiftAttack:OnWeaponInstanceRemove(weapon)
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(weapon))]
	if swiftWeapon == nil then return end
	local swiftData = swiftWeapon.ParentInstance
	if swiftData == nil then return end

	if swiftWeapon ~= nil then
		swiftBase.Weapons[tostring(GetPtrHash(weapon))] = nil
		for _, parentSwiftWeapon in ipairs(swiftData.ChildSwiftWeapons) do
			if GetPtrHash(weapon) == GetPtrHash(parentSwiftWeapon.WeaponEntity) then
				swiftData.NumWeaponsRemoved = swiftData.NumWeaponsRemoved + 1
			end
		end
	end
end

------------
--  MISC  --
------------

---@param player EntityPlayer
function swiftAttack:OnPostPlayerUpdate(player)
	local playerType = player:GetPlayerType()
	if EEVEEMOD.game:GetFrameCount() < 1 then return end
	VeeHelper.GetClosestDoorSlotPos(player.Position)
	if playerType == EEVEEMOD.PlayerType.EEVEE then
		swiftBase:TryInitSwiftPlayer(player)
	end

	local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]

	if not swiftPlayer then return end
	if swiftSynergies:ShouldWeaponTypeOverride(player) == false and EEVEEMOD.game:GetRoom():GetFrameCount() > 1 then
		swiftAttack:StartAttack(player)
	end
	for index, swiftData in ipairs(swiftBase.Instances) do
		swiftAttack:RemoveSwiftInstance(swiftData, index)
		swiftAttack:FireIfNotShooting(swiftData)
		swiftAttack:RateOfOrbitRotation(swiftData)
		swiftAttack:RemoveSwiftBombsBeforeNewRoom(swiftData)
		swiftAttack:RegenerateSwiftWeapons(swiftData)
		if not swiftData.CanFire then
			swiftAttack:SpawnNextWeapon(swiftData)
			swiftAttack:CountdownDuration(swiftData)
		end
	end
end

---@param swiftWeapon SwiftWeapon
---@param weapon Weapon
---@param player EntityPlayer
function swiftAttack:ShouldRestoreSwiftTrail(swiftWeapon, weapon, player)
	if swiftWeapon.Trail and not swiftWeapon.Trail:Exists() then
		swiftBase:AddSwiftTrail(weapon, player)
	end
end

---@param trail EntityEffect
function swiftAttack:SwiftTrailUpdate(trail)
	local data = trail:GetData()

	if trail.Parent then
		local weapon = trail.Parent
		local room = EEVEEMOD.game:GetRoom()
		local tC = trail.Color

		if not data.EeveeEntHasColorCycle then
			local wC = weapon:GetSprite().Color
			if VeeHelper.AreColorsDifferent(wC, trail:GetData().TrailColor)
				and VeeHelper.AreColorsDifferent(wC, Color.Default) then
				trail:SetColor(wC, -1, 1, true, false)
			end
		end

		if not room:IsPositionInRoom(trail.Position, -30) then
			trail:SetColor(VeeHelper.SetColorAlpha(tC, 0), 5, 2, true, false)
		end
		local heightDif = 0
		if weapon:ToTear() then
			weapon = weapon:ToTear()
			local tearHeightToFollow = (weapon.Height * 0.4) - 15
			local sizeToFollow = weapon.Size * 0.5
			trail.SpriteScale = Vector(weapon.Size * 0.2, 1)
			trail.Position = Vector(weapon.Position.X, (weapon.Position.Y + (tearHeightToFollow + heightDif)) - sizeToFollow) +
				weapon.PosDisplacement
		else
			if weapon.Type == EntityType.ENTITY_EFFECT and weapon.Variant == EffectVariant.EVIL_EYE then
				heightDif = 20
			end
			trail.Position = Vector(weapon.Position.X, weapon.Position.Y + weapon.PositionOffset.Y - heightDif)
		end
	else
		if data.SwiftTrail then
			trail:Remove()
		end
	end
end

function swiftAttack:Debug()
	--[[ 	local numInstances = 0
	local weaponTimer = 0
	local durationTimer = 0
	local cooldown = 0
	local swiftData = nil
	if swiftBase.Instances[1] ~= nil then
		swiftData = swiftBase.Instances[1]
		numInstances = #swiftBase.Instances
		durationTimer = swiftData.DurationTimer
		weaponTimer = swiftData.WeaponSpawnTimer
	end
	if Isaac.GetPlayer():GetData().SwiftInstanceCooldown ~= nil then
		cooldown = Isaac.GetPlayer():GetData().SwiftInstanceCooldown
	end
	Isaac.RenderText("NumInstances: " .. numInstances, 50, 50, 1, 1, 1, 1)
	Isaac.RenderText("Duration: " .. durationTimer, 50, 70, 1, 1, 1, 1)
	Isaac.RenderText("Weapon Timer:" .. weaponTimer, 50, 90, 1, 1, 1, 1)
	Isaac.RenderText("Cooldown:" .. cooldown, 50, 110, 1, 1, 1, 1)

	if swiftBase.Instances[1] == nil then return end
	for index, weapon in ipairs(swiftBase.Instances[1].ChildSwiftWeapons) do
		local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(weapon.Position)
		local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(weapon))]
		--Isaac.RenderText(swiftWeapon.FireDelay, screenpos.X, screenpos.Y, 1, 1, 1, 1)
		--Isaac.RenderText(swiftWeapon.ShootDirection.X .. ", " .. swiftWeapon.ShootDirection.Y, screenpos.X, screenpos.Y + 30, 1, 1, 1, 1)
	end ]]
end

return swiftAttack
