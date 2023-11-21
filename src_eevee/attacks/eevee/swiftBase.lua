local vee = require("src_eevee.VeeHelper")
local swiftBase = {}
local attackHelper = require("src_eevee.attacks.attackHelper")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")
local rgbCycle = require("src_eevee.misc.rgbCycle")

---@class SwiftPlayer
---@field SpiritSword EntityKnife | nil
---@field OwnedInstances SwiftInstance[]
swiftBase.swiftPlayerData = {
	Cooldown = 0,
	CanFire = true,
	OwnedInstances = {},
	NumNeptunusInstancesUnfired = 0,
	SpiritSword = nil,
	SpawnedLudoTear = false
}

---Default: The regular Swift attack as you know it.
---
---Anti-Gravity: Attack stays in place, revolving around the spot it was ready to fire at. Fired automatically if the player stops firing themselves.
---
---Neptunus:
---Key press requirements reversed. Let go of keys to start spawning stars. Will spawn the normal five, then create another ring of stars with a further orbit distance.
---No cooldown between spawning the next set of stars.
---Firing will unleash stars in quick successtion.
---Can only have up to 2 instances.
---
---Ludovico: Star/Knife only. Control a single ring of stars.
---
---Spirit Sword: Spawn and near instantly shoot weapons while Spirit Sword does its charge attack
---@enum SwiftInstanceType
swiftBase.InstanceType = {
	INSTANCE_DEFAULT = 0,
	INSTANCE_ANTI_GRAV = 1,
	INSTANCE_NEPTUNUS = 2,
	INSTANCE_LUDOVICO = 3,
	INSTANCE_SPIRIT_SWORD = 4
}

---@class SwiftInstance
---@field InstanceType SwiftInstanceType
---@field Player EntityPlayer | nil
---@field Parent Entity | nil
---@field ChildSwiftWeapons SwiftWeapon[] | nil
swiftBase.swiftInstanceData = {
	InstanceType = swiftBase.InstanceType.INSTANCE_DEFAULT,
	Player = nil,
	Parent = nil,
	ChildSwiftWeapons = nil,
	NumWeaponsKilled = 0,
	TotalDuration = 0,
	DurationTimer = 0,
	WeaponSpawnTimer = 0,
	CanFire = false,
	Rotation = 0,
	NumWeaponsSpawned = 0,
	NumWeaponsToSpawn = 5,
	NumWeaponsRemoved = 0,
	ShotMultiplier = 1,
}

---@class SwiftTear
swiftBase.swiftTearData = {
	StartingAccel = 0,
	StartingFall = 0,
}

---@class SwiftLaser
---@field HoldTimeout fun(laser: EntityLaser): integer
swiftBase.swiftLaserData = {
	RotationOffset = 0,
	HasTech2 = false,
	HoldTimeout = function(laser)
		return (vee.isBrimLaser(laser) and 5 or 2)
	end,
	SoyBrimEarlyFire = false,
}

---@class SwiftWeapon
---@field Trail EntityEffect | nil
---@field WeaponEntity Weapon | EntityEffect | nil
---@field ParentInstance SwiftInstance
---@field AttachedLaser EntityLaser | nil
---@field Special SwiftTear | SwiftLaser | nil
---@field DelayedTearFlag BitSet128
swiftBase.swiftWeaponData = {
	ParentInstance = {},
	WeaponEntity = nil,
	StartingAngle = Vector.Zero,
	ShootDirection = Vector.Zero,
	OrbitDistance = 0,
	OrbitDistanceSaved = 0,
	Trail = nil,
	FireDelay = 2,
	HasFired = false,
	DelayedTearFlag = TearFlags.TEAR_NORMAL,
	IsMultiShot = false,
	AntiGravBlinkThreshold = 0,
	AntiGravBlinkToReduceBy = 0,
	AttachedLaser = nil,
	Special = nil
}

---@type SwiftPlayer[]
swiftBase.Players = {}
---@type SwiftInstance[]
swiftBase.Instances = {}
---@type SwiftWeapon[]
swiftBase.Weapons = {}

---@param player EntityPlayer
---@return SwiftInstanceType
function swiftBase:GetInstanceType(player)
	local instanceType = swiftBase.InstanceType.INSTANCE_DEFAULT
	if not player then return instanceType end

	if swiftSynergies:ShouldUseLudo(player) then
		instanceType = swiftBase.InstanceType.INSTANCE_LUDOVICO
	elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
		instanceType = swiftBase.InstanceType.INSTANCE_SPIRIT_SWORD
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) then
		instanceType = swiftBase.InstanceType.INSTANCE_NEPTUNUS
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
		instanceType = swiftBase.InstanceType.INSTANCE_ANTI_GRAV
	end
	return instanceType
end

---@param swiftPlayer SwiftPlayer
function swiftBase.GetNumNeptunusInstances(swiftPlayer)
	local numNeptunusInstances = 0

	for _, swiftData in ipairs(swiftPlayer.OwnedInstances) do
		if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS
			and swiftData.CanFire == false
		then
			numNeptunusInstances = numNeptunusInstances + 1
		end
	end
	return numNeptunusInstances
end

---@param swiftPlayer SwiftPlayer
---@param swiftData SwiftInstance
function swiftBase.getOrderNumberOfNeptunusInstance(swiftPlayer, swiftData)
	local instanceNum = 0
	for _, ownedSwiftData in ipairs(swiftPlayer.OwnedInstances) do
		if ownedSwiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS
			and ownedSwiftData.CanFire == false
		then
			instanceNum = instanceNum + 1
			if swiftData == ownedSwiftData then
				return instanceNum
			end
		end
	end
	return instanceNum
end

---@param player EntityPlayer
function swiftBase:TryInitSwiftPlayer(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	if swiftBase.Players[ptrHashPlayer] == nil then
		swiftBase.Players[ptrHashPlayer] = {}
		local swiftPlayer = swiftBase.Players[ptrHashPlayer]
		vee.copyOverTable(swiftBase.swiftPlayerData, swiftPlayer)
	end
end

---@param swiftData SwiftInstance
---@param weapon Weapon | EntityEffect
---@param isMult boolean
function swiftBase:InitSwiftWeapon(swiftData, weapon, isMult)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	if swiftBase.Weapons[ptrHashWeapon] == nil then
		swiftBase.Weapons[ptrHashWeapon] = {}
		local swiftWeapon = swiftBase.Weapons[ptrHashWeapon]

		vee.copyOverTable(swiftBase.swiftWeaponData, swiftWeapon)
		if swiftData.ChildSwiftWeapons == nil then
			swiftData.ChildSwiftWeapons = {} --Otherwise all swift instances point to the one made by swiftWeaponData
		end
		if swiftWeapon.Special == nil then
			swiftWeapon.Special = {}
		end
		vee.copyOverTable(swiftBase.swiftTearData, swiftWeapon.Special)
		vee.copyOverTable(swiftBase.swiftLaserData, swiftWeapon.Special)
		swiftWeapon.IsMultiShot = isMult
		swiftBase:AddSwiftTrail(weapon, swiftData.Player)
		swiftBase:PlaySwiftFireSFX(weapon)
		swiftBase:InitWeaponValues(swiftData, swiftWeapon, weapon)
		local insertPoint = swiftData.NumWeaponsSpawned > #swiftData.ChildSwiftWeapons + 1 and
		#swiftData.ChildSwiftWeapons or swiftData.NumWeaponsSpawned
		table.insert(swiftData.ChildSwiftWeapons, insertPoint, swiftWeapon)
		weapon:SetColor(vee.SetColorAlpha(weapon:GetColor(), 0), 15, 1, true, false)
	end
end

---@param swiftData SwiftInstance
function swiftBase:GetWeaponFireDelay(swiftData)
	return (swiftBase:GetFireDelay(swiftData.Player) / (swiftData.NumWeaponsToSpawn / swiftData.NumWeaponsSpawned))
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param weapon Weapon | EntityEffect
function swiftBase:InitWeaponValues(swiftData, swiftWeapon, weapon)
	local player = swiftData.Player
	if not player then return end

	swiftWeapon.ParentInstance = swiftData
	swiftWeapon.WeaponEntity = weapon
	swiftWeapon.StartingAngle = swiftBase:GetStartingAngle(swiftData)
	swiftWeapon.OrbitDistance = swiftBase:SwiftOrbitDistance(swiftData)
	swiftWeapon.OrbitDistanceSaved = swiftWeapon.OrbitDistance
	swiftWeapon.ShootDirection = attackHelper:GetIsaacShootingDirection(player, weapon.Position)
	swiftWeapon.FireDelay = swiftBase:GetWeaponFireDelay(swiftData)

	if weapon:ToTear() then
		swiftWeapon.StartingAccel = weapon.FallingAcceleration
		swiftWeapon.StartingFall = weapon.FallingSpeed
		weapon:ClearTearFlags(TearFlags.TEAR_ORBIT)
	end

	swiftSynergies:ChocolateMilkDamageScaling(swiftData, weapon)
end

---@param swiftData SwiftInstance
function swiftBase:GetAdjustedStartingAngle(swiftData)
	local player = swiftData.Player
	local distFromPlayer = swiftBase:SwiftOrbitDistance(swiftData)

	if player and swiftSynergies:ShouldUseTinyPlanet(player) then
		local distanceCalc = swiftBase:GetDurationPercentage(swiftData)
		distFromPlayer = distFromPlayer + (90 * distanceCalc)
	end
	return swiftBase:GetStartingAngle(swiftData):Resized(distFromPlayer):Rotated(swiftData.Rotation)
end

function swiftBase:SwiftStarFireSFX()
	local values = {
		0.9,
		1,
		1.1
	}
	EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SWIFT_FIRE, 1, 2, false, values[vee.RandomNum(3)])
end

---@param weapon Weapon | EntityEffect
function swiftBase:PlaySwiftFireSFX(weapon)
	EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
	if EEVEEMOD.game:GetRoom():GetFrameCount() == 0 then return end
	if weapon:ToTear() or (weapon:ToEffect() and weapon.Variant == EffectVariant.EVIL_EYE) then
		swiftBase:SwiftStarFireSFX()
	elseif swiftBase:IsSwiftLaserEffect(weapon) then
		EEVEEMOD.sfx:Stop(EEVEEMOD.SoundEffect.SWIFT_FIRE)
		if weapon.Variant == EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT then
			EEVEEMOD.sfx:Play(SoundEffect.SOUND_LASERRING_WEAK, 0.7, 0, false, 3, 0)
		elseif weapon.Variant == EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL then
			EEVEEMOD.sfx:Play(SoundEffect.SOUND_BLOOD_LASER, 1, 0, false, 1.5, 0)
		end
	elseif weapon:ToBomb() then
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_FETUS_LAND)
	end
end

---@param player EntityPlayer
---@param ignoreCap? boolean
function swiftBase:GetFireDelay(player, ignoreCap)
	if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
		return 1.5
	elseif swiftSynergies:ShouldUseLudo(player)
	then
		return 5
	end
	local fireDelay = player.MaxFireDelay
	local WeaponTypeToFireDelay = {
		[WeaponType.WEAPON_BRIMSTONE] = 1.2,
		[WeaponType.WEAPON_KNIFE] = 1.3,
		[WeaponType.WEAPON_TECH_X] = 1.5,
	}
	local mult = 1
	for weaponType, delayMult in pairs(WeaponTypeToFireDelay) do
		if player:HasWeaponType(weaponType) then
			if mult < delayMult then
				mult = delayMult
			end
		end
	end
	fireDelay = player.MaxFireDelay * mult
	if not ignoreCap then
		if fireDelay < 0.5 then
			fireDelay = 0.5
		end
	end
	return fireDelay
end

---@param player EntityPlayer
function swiftBase:GetInstanceCooldown(player)
	local fireDelay = swiftBase:GetFireDelay(player, true)
	fireDelay = fireDelay + (math.abs(fireDelay) * 6)
	return fireDelay
end

---@param swiftData SwiftInstance
function swiftBase:SwiftOrbitDistance(swiftData)
	local player = swiftData.Player
	local distFromPlayer = 45
	if not player then return distFromPlayer end
	if swiftSynergies:ShouldUseLudo(player) then return distFromPlayer end
	if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
		distFromPlayer = 100
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ANGELIC_PRISM) then
		distFromPlayer = 40
	elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
		distFromPlayer = 65
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND)
	then
		distFromPlayer = 70
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT) then
		distFromPlayer = 30
	end
	if swiftData.InstanceType == swiftBase.InstanceType.INSTANCE_NEPTUNUS then
		local swiftPlayer = swiftBase.Players[tostring(GetPtrHash(player))]

		if swiftPlayer and swiftBase.getOrderNumberOfNeptunusInstance(swiftPlayer, swiftData) >= 2 then
			distFromPlayer = distFromPlayer * 1.5
		end
	end
	if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
		distFromPlayer = vee.RandomNum(distFromPlayer - 30, distFromPlayer + 30)
	end

	return distFromPlayer
end

---@param swiftData SwiftInstance
function swiftBase:GetStartingAngle(swiftData)
	return Vector.FromAngle((360 / swiftData.NumWeaponsToSpawn) * swiftData.NumWeaponsSpawned)
end

---@param entity Entity
---@return string | nil
function swiftBase:IsSwiftLaserEffect(entity)
	local variant = nil
	if entity.Type ~= EntityType.ENTITY_EFFECT then return end

	if entity.Variant == EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT then
		variant = "tech"
	elseif entity.Variant == EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL then
		variant = "brim"
	end

	return variant
end

---@param weapon Weapon | EntityEffect
---@param player EntityPlayer
function swiftBase:AddSwiftTrail(weapon, player)
	---@type EntityEffect
	local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, weapon.Position, Vector.Zero, nil)
	:
	ToEffect()
	local data = trail:GetData()
	local wC = weapon:GetSprite().Color
	local tC = vee.SetColorAlpha(wC, 1)

	if not rgbCycle:shouldApplyColorCycle(player) then
		if weapon.Type == EntityType.ENTITY_TEAR then
			if not vee.AreColorsDifferent(wC, Color.Default) then
				if EEVEEMOD.TrailColor[weapon.Variant] ~= nil then
					tC = EEVEEMOD.TrailColor[weapon.Variant]
				end
			end
		end
	else
		if weapon.Type ~= EntityType.ENTITY_EFFECT and weapon.Type ~= EntityType.ENTITY_LASER then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
				tC = vee.PlaydoughRandomColor()
			else
				rgbCycle:applyColorCycle(trail, EEVEEMOD.ColorCycle.CONTINUUM)
			end
		else
			local colorCycle = player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) and
				EEVEEMOD.ColorCycle.RGB
				or player:HasCollectible(CollectibleType.COLLECTIBLE_CONTINUUM) and EEVEEMOD.ColorCycle.CONTINUUM
			rgbCycle:applyColorCycle(trail, colorCycle)
		end
	end
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(weapon))]

	trail.Parent = weapon
	data.SwiftTrail = true
	data.TrailColor = tC
	trail:SetColor(tC, -1, 1, false, false)
	trail:SetColor(vee.SetColorAlpha(tC, 0), 15, 1, true, false)
	if swiftWeapon then
		swiftWeapon.Trail = trail
	end
	trail.MinRadius = 0.2
	trail.RenderZOffset = -10
	trail:Update()
end

---@param swiftData SwiftInstance
function swiftBase:GetDurationPercentage(swiftData)
	return (swiftData.TotalDuration - swiftData.DurationTimer) / swiftData.TotalDuration
end

return swiftBase
