local swiftBase = {}

function swiftBase:AddSwiftTrail(weapon, player)
	local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, weapon.Position, Vector.Zero, nil):ToEffect()
	local wC = weapon:GetSprite().Color
	local tC = Color(wC.R, wC.G, wC.B, 1, wC.RO, wC.GO, wC.BO)

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		if weapon.Type == EntityType.ENTITY_TEAR then
			if not VeeHelper.AreColorsDifferent(wC, Color.Default) then
				if EEVEEMOD.TrailColor[weapon.Variant] ~= nil then
					tC = EEVEEMOD.TrailColor[weapon.Variant]
				else
					tC = EEVEEMOD.TrailColor[EEVEEMOD.TearVariant.SWIFT]
				end
			end
		end
	else
		if weapon.Type ~= EntityType.ENTITY_EFFECT and weapon.Type ~= EntityType.ENTITY_LASER then
			tC = VeeHelper.PlaydoughRandomColor()
		else
			trail:GetData().EeveeRGB = true
		end
	end
	trail.Parent = weapon
	trail:GetData().SwiftTrail = true
	trail:GetData().TrailColor = tC
	trail.Color = tC
	trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 15, 1, true, false)
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(weapon))]
	if swiftWeapon then
		swiftWeapon.Trail = trail
	end
	trail.MinRadius = 0.2
	trail.RenderZOffset = -10
	trail:Update()
end

--Instance Types:
--Default: The regular Swift attack as you know it
--???:
--???:
--???:
--???:

---@class SwiftInstance
---@field Player EntityPlayer
---@field Parent Entity
---@field ActiveWeapons Weapon[]
swiftBase.swiftInstanceData = {
	InstanceType = "Default",
	Player = nil,
	Parent = nil,
	ActiveWeapons = {},
	TotalDuration = 0,
	DurationTimer = 0,
	WeaponSpawnTimer = 0,
	CanFire = false,
	Rotation = 0,
	NumWeaponsSpawned = 1,
	NumWeaponsToSpawn = 5,
	NumWeaponsDead = 0,
}

---@class SwiftWeapon
---@field Trail EntityEffect
---@field WeaponEntity Weapon
---@field ParentInstance SwiftInstance
swiftBase.swiftWeaponData = {
	ParentInstance = {},
	StartingAngle = Vector.Zero,
	ShootDirection = Vector.Zero,
	OrbitDistance = 0,
	Trail = nil,
	FireDelay = 2,
	HasFired = false,
	DelayedTearFlag = 0,
	--Tears
	StartingAccel = 0,
	StartingFall = 0,
	--Lasers
	--Knives
	--YoMama
}

---@type SwiftInstance[]
swiftBase.Instances = {}
---@type SwiftWeapon[]
swiftBase.Weapons = {}


---@param swiftData SwiftInstance
---@param weapon Weapon
function swiftBase:InitSwiftWeapon(swiftData, weapon)
	table.insert(swiftData.ActiveWeapons, weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	if swiftBase.Weapons[ptrHashWeapon] == nil then
		swiftBase.Weapons[ptrHashWeapon] = {}
		local swiftWeapon = swiftBase.Weapons[ptrHashWeapon]
		for variableName, value in pairs(swiftBase.swiftWeaponData) do
			swiftWeapon[variableName] = value
		end
		swiftBase:InitWeaponValues(swiftData, swiftWeapon, weapon)
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param weapon Weapon
function swiftBase:InitWeaponValues(swiftData, swiftWeapon, weapon)
	swiftWeapon.StartingAngle = swiftBase:GetStartingAngle(swiftData)
	swiftWeapon.OrbitDistance = swiftBase:SwiftOrbitDistance(swiftData.Player)
	swiftWeapon.ParentInstance = swiftData
	swiftWeapon.ShootDirection = VeeHelper.GetIsaacShootingDirection(swiftData.Player, weapon.Position)
	local fireDelay = (swiftBase:GetFireDelay(swiftData.Player) / (swiftData.NumWeaponsToSpawn / swiftData.NumWeaponsSpawned))
	swiftWeapon.FireDelay = fireDelay
	if weapon:ToTear() then
		swiftWeapon.StartingAccel = weapon.FallingAcceleration
		swiftWeapon.StartingFall = weapon.FallingSpeed
	end
end

function swiftBase:PlaySwiftFire()
	local values = {
		0.9,
		1,
		1.1
	}
	EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SWIFT_FIRE, 1, 2, false, values[EEVEEMOD.RandomNum(3)])
end

---@param player EntityPlayer
---@param ignoreCap? boolean
function swiftBase:GetFireDelay(player, ignoreCap)
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
	fireDelay = fireDelay + (math.abs(fireDelay) * 9)
	return fireDelay
end

---@param player EntityPlayer
function swiftBase:SwiftOrbitDistance(player)
	local distFromPlayer = 50
	if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then return distFromPlayer end
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
	return distFromPlayer
end

---@param swiftData SwiftInstance
function swiftBase:GetStartingAngle(swiftData)
	return Vector.FromAngle((360 / swiftData.NumWeaponsToSpawn) * swiftData.NumWeaponsSpawned)
end

function swiftBase:IsSwiftLaserEffect(effect)
	local variant = nil
	if effect.Type ~= EntityType.ENTITY_EFFECT then return end

	if effect.Variant == EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT then
		variant = "tech"
	elseif effect.Variant == EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL then
		variant = "brim"
	end

	return variant
end

--[[ local Template_SwiftPlayer = {
	ShouldOverrideSwift = false,
	Instance = {},
	AttackInit = false,
	AttackDuration = 0,
	AttackDurationSet = 0,
	AttackCooldown = 0,
	RateOfOrbitRotation = 0,
	NumWeaponsSpawned = 0,
	TimeTillNextWeapon = 0,
	MultiShots = 0,
	KidneyTimer = 0,
	Constant = false,
	ConstantFiring = false,
	ExistingShots = {},
	StarSword = false,
}

local Template_SwiftWeapon = {
	PosToFollow = Vector(0, 0),
	ShotDir = Vector(0, 1),
	DistFromPlayer = 50,
	HasFired = false,
	ShotDelay = 0,
	Trail = nil,
	IsMultiShot = false,
	MultiShotRotation = 0,
	DistFromStar = 15,
	ConstantOrbit = false,
	TearFlagsToDelay = {
		TearFlags.TEAR_GROW, --Lump of Coal
		TearFlags.TEAR_SHRINK, --Proptosis
		TearFlags.TEAR_ORBIT, --Tiny Planet
		TearFlags.TEAR_SQUARE, --Hook Worm
		TearFlags.TEAR_SPIRAL, --Ring Worm
		TearFlags.TEAR_BIG_SPIRAL, --Ouroborus Worm
		TearFlags.TEAR_HYDROBOUNCE, --Flat Stone
		TearFlags.TEAR_BOUNCE, --Rubber Cement
		TearFlags.TEAR_TURN_HORIZONTAL -- Brain Worm
	},
	AntiGravFired = false,
	AntiGravDir = nil,
	AntiGravTimer = nil,
	Tech2Attached = false
}

local Template_SwiftWeaponUnique = {
	[EntityType.ENTITY_TEAR] = {
		HoldTearHeight = 0,
		StoredFallingAccel = 0,
		IsFakeKnife = false,
		HeightDuration = 0
	},
	[EntityType.ENTITY_EFFECT] = {
		LaserHasFired = false,
		TechXRadius = 0
	},
	[EntityType.ENTITY_LASER] = {
		IsTech2 = false,
		IsConstantLaser = false,
		Player = nil
	},
}

swiftBase.Player = {}
swiftBase.Weapon = {}

function swiftBase:InitSwiftPlayer(player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local playerType = player:GetPlayerType()

	if playerType == EEVEEMOD.PlayerType.EEVEE then
		if swiftBase.Player[ptrHashPlayer] == nil then
			swiftBase.Player[ptrHashPlayer] = {}
			for name, value in pairs(Template_SwiftPlayer) do
				swiftBase.Player[ptrHashPlayer][tostring(name)] = value
			end
		end
	end
end

function swiftBase:InitSwiftWeapon(weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))

	if VeeHelper.EntitySpawnedByPlayer(weapon) then
		local player = weapon.SpawnerEntity:ToPlayer()
		local playerType = player:GetPlayerType()

		if playerType == EEVEEMOD.PlayerType.EEVEE then
			if swiftBase.Weapon[ptrHashWeapon] == nil then
				swiftBase.Weapon[ptrHashWeapon] = {}
				for name, value in pairs(Template_SwiftWeapon) do
					swiftBase.Weapon[ptrHashWeapon][tostring(name)] = value
				end
				if Template_SwiftWeaponUnique[weapon.Type] ~= nil then
					for name, value in pairs(Template_SwiftWeaponUnique[weapon.Type]) do
						swiftBase.Weapon[ptrHashWeapon][tostring(name)] = value
					end
				end
			end
		end
	end
end

function swiftBase:ResetData()
	swiftBase.Player = {}
	swiftBase.Weapon = {}
end

function swiftBase:RemoveWeaponOnPostEntRemove(ent)
	local ptrHashWeapon = tostring(GetPtrHash(ent))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftWeapon then
		swiftBase.Weapon[ptrHashWeapon] = nil
	end
end

function swiftBase:AssignSwiftSprite(tear)

	if VeeHelper.TearVariantBlacklist[tear.Variant]
		or EEVEEMOD.KeepTearVariants[tear.Variant] then
		return
	end

	local tearSprite = tear:GetSprite()
	local dataTear = tear:GetData()
	local animationToPlay = VeeHelper.TearScaleToSizeAnim(tear)
	local variantToUse = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and "gfx/tear_swift.anm2" or EEVEEMOD.TearVariant.SWIFT
	local _, isBlood = string.gsub(animationToPlay, "BloodTear", "")

	if (dataTear.ForceBlood and dataTear.ForceBlood == true)
		or (isBlood ~= 0
			and (
			dataTear.ForceBlood == nil or
				dataTear.ForceBlood ~= false
			))
		or VeeHelper.TearFlagsBlood[tear.Variant]
	then
		animationToPlay = "BloodTear" .. animationToPlay
		variantToUse = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and "gfx/tear_swift_blood.anm2" or EEVEEMOD.TearVariant.SWIFT_BLOOD
	else
		animationToPlay = "RegularTear" .. animationToPlay
	end

	--So, for some dumb fuck reason, Ludo tears when updated entirely BREAK when having their variant changed. Can't damage anything and has strange collision with grid ents/walls.
	if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		tear:GetSprite():Load(variantToUse, true)
	else
		tear:ChangeVariant(variantToUse)
	end

	tearSprite:Play(animationToPlay, true)
end

function swiftBase:AddBasicSwiftTrail(weapon)
	local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, weapon.Position, Vector.Zero, nil):ToEffect()
	local tC = EEVEEMOD.TrailColor[EEVEEMOD.TearVariant.SWIFT]
	local data = weapon:GetData()

	data.BasicSwiftTrail = trail
	trail.Parent = weapon
	trail.Color = tC
	trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 15, 1, true, false)
	trail.MinRadius = 0.2
	trail.RenderZOffset = -10
	trail:Update()
end

function swiftBase:PlaySwiftFire()
	local values = {
		0.9,
		1,
		1.1
	}
	EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SWIFT_FIRE, 1, 2, false, values[EEVEEMOD.RandomNum(3)])
end

function swiftBase:AssignBasicSwiftStar(tear)
	tear:GetData().BasicSwift = true
	swiftBase:AssignSwiftSprite(tear)
	swiftBase:AddBasicSwiftTrail(tear)
	swiftBase:PlaySwiftFire()
end

function swiftBase:SpawnPos(player, degreeOfTearSpawns, offset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local anglePos = Vector.FromAngle((degreeOfTearSpawns * swiftPlayer.NumWeaponsSpawned)):Resized(swiftBase:SwiftTearDistanceFromPlayer(player)):Rotated(offset)
	--360/count * numSpawned to form star, resized for distance from the player, rotated by a customoffset (head direction)
	return anglePos
end

function swiftBase:SpawnPosMulti(player, multiOffset, orbit, i)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local degrees = 360 / swiftPlayer.MultiShots
	local anglePos = Vector.FromAngle((degrees * i) * swiftPlayer.NumWeaponsSpawned):Resized(orbit):Rotated(multiOffset)

	return anglePos
end

function swiftBase:SwiftFireDelay(player)
	local nextTearTime = player.MaxFireDelay
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)
		or player:HasWeaponType(WeaponType.WEAPON_TECH_X)
		or player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		nextTearTime = nextTearTime * 1.5
	end
	if swiftPlayer then
		if (not swiftPlayer.Constant and player.MaxFireDelay <= 0.5) then
			nextTearTime = 0.5
		end
	end
	return nextTearTime
end


function swiftBase:SwiftShotDelay(weapon, player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	local delay = swiftBase:SwiftFireDelay(player) / (5 / swiftPlayer.NumWeaponsSpawned)

	if not swiftPlayer.StarSword then
		if not swiftPlayer.Constant then
			if swiftBase:SwiftFireDelay(player) < 5
				or weapon.Type == EntityType.ENTITY_EFFECT
				or (weapon.Type == EntityType.ENTITY_TEAR
					and swiftWeapon.IsFakeKnife)
			then
				delay = 0
			end
		else
			if swiftPlayer.RespawnNewRoom then
				delay = swiftBase:SwiftFireDelay(player) + math.abs(swiftBase:SwiftFireDelay(player) * swiftPlayer.NumWeaponsSpawned)
			else
				delay = swiftBase:SwiftFireDelay(player) + math.abs(swiftBase:SwiftFireDelay(player) * 5)
			end
		end
	else
		delay = swiftPlayer.NumWeaponsSpawned
	end
	return delay
end

function swiftBase:SwiftTearFlags(weapon, addPiercing, addHoming)
	if not weapon:HasTearFlags(TearFlags.TEAR_SPECTRAL) then
		weapon:AddTearFlags(TearFlags.TEAR_SPECTRAL)
	end
	if addPiercing and not weapon:HasTearFlags(TearFlags.TEAR_PIERCING) then
		weapon:AddTearFlags(TearFlags.TEAR_PIERCING)
	end
	if addHoming and not weapon:HasTearFlags(TearFlags.TEAR_HOMING) then
		weapon:AddTearFlags(TearFlags.TEAR_HOMING)
	end
end

function swiftBase:AddSwiftTrail(weapon, player)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if swiftPlayer == nil
		or swiftWeapon == nil
		or (swiftPlayer.Constant and not swiftWeapon.ConstantOrbit and not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE))
	then
		return
	end

	local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, weapon.Position, Vector.Zero, nil):ToEffect()
	local wC = weapon:GetSprite().Color
	local tC = Color(wC.R, wC.G, wC.B, 1, wC.RO, wC.GO, wC.BO)

	if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		if weapon.Type == EntityType.ENTITY_TEAR then
			if not VeeHelper.AreColorsDifferent(wC, Color.Default) and not swiftWeapon.IsFakeKnife then
				if EEVEEMOD.TrailColor[weapon.Variant] ~= nil then
					tC = EEVEEMOD.TrailColor[weapon.Variant]
				else
					tC = EEVEEMOD.TrailColor[EEVEEMOD.TearVariant.SWIFT]
				end
			end
		end
	else
		if weapon.Type ~= EntityType.ENTITY_EFFECT and weapon.Type ~= EntityType.ENTITY_LASER then
			tC = swiftBase:PlaydoughRandomColor()
		else
			trail:GetData().EeveeRGB = true
		end
	end
	trail.Parent = weapon
	trail:GetData().SwiftTrail = true
	trail:GetData().TrailColor = tC
	trail.Color = tC
	trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 15, 1, true, false)
	swiftWeapon.Trail = trail
	trail.MinRadius = 0.2
	trail.RenderZOffset = -10
	trail:Update()
end

function swiftBase:SwiftTearDistanceFromPlayer(player)
	local distFromPlayer = 50
	if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then return distFromPlayer end
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
	return distFromPlayer
end

function swiftBase:MultiSwiftTearDistanceFromTear(player)
	local distFromTear = 15
	if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
		distFromTear = EEVEEMOD.RandomNum(10, 50)
	end
	return distFromTear
end

function swiftBase:AssignSwiftSounds(weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if weapon.Type == EntityType.ENTITY_TEAR then
		swiftBase:PlaySwiftFire()
	elseif weapon.Type == EntityType.ENTITY_EFFECT then
		if weapon.Variant == EffectVariant.EVIL_EYE then
			swiftBase:PlaySwiftFire()
		elseif swiftBase:IsSwiftLaserEffect(weapon) == "brim" then
			EEVEEMOD.sfx:Play(SoundEffect.SOUND_BLOOD_LASER, 1, 0, false, 1.5, 0)
		elseif swiftBase:IsSwiftLaserEffect(weapon) == "tech" then
			EEVEEMOD.sfx:Play(SoundEffect.SOUND_LASERRING_WEAK, 0.7, 0, false, 3, 0)
		end
	elseif weapon.Type == EntityType.ENTITY_BOMBDROP then
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_FETUS_LAND)
	end
end

function swiftBase:AssignSwiftBasicData(weapon, player, anglePos)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local dataWeapon = weapon:GetData()
	swiftBase:InitSwiftWeapon(weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	local swiftWeapon = swiftBase.Weapon[ptrHashWeapon]

	if weapon.Type == EntityType.ENTITY_TEAR then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_KIDNEY_STONE) then
			weapon.Height = weapon.Height - 16
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE)
			or player:HasCollectible(CollectibleType.COLLECTIBLE_PLUTO) then
			weapon.Height = weapon.Height - 8
		end
		swiftWeapon.HoldTearHeight = weapon.Height
	end

	swiftWeapon.ShotDir = swiftPlayer.StarSword and swiftPlayer.StarSword.Dir or VeeHelper.GetIsaacShootingDirection(player, weapon.Position)
	swiftWeapon.PosToFollow = anglePos:Rotated(180)
	swiftWeapon.ShotDir = VeeHelper.GetIsaacShootingDirection(player, weapon.Position)
	swiftWeapon.DistFromPlayer = swiftBase:SwiftTearDistanceFromPlayer(player)
	swiftWeapon.ShotDelay = swiftBase:SwiftShotDelay(weapon, player)

	if not dataWeapon.IsMultiShot then
		if not swiftPlayer.ExistingShots then
			swiftPlayer.ExistingShots = {}
		end
		swiftPlayer.ExistingShots[swiftPlayer.NumWeaponsSpawned] = weapon
	else
		swiftWeapon.IsMultiShot = true
		swiftWeapon.DistFromStar = dataWeapon.MultiSwiftOrbitDistance
		swiftWeapon.MultiShotRotation = dataWeapon.MultiRotation
	end

	if swiftPlayer.Constant == true then
		swiftWeapon.ConstantOrbit = true
	end
end




function swiftBase:SwiftShouldBeConstant(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
		or swiftBase:SwiftFireDelay(player) <= 3
	then
		return true
	else
		return false
	end
end

--Unused as I opted to entirely kill off arc shots instead
local function RestoreArcShot(player, tear)
	local local ptrHashTear = tostring(GetPtrHash(tear))
	local swiftTear = swiftBase.Weapon[ptrHashTear]
	local range = player.TearRange / 10

	if not swiftTear
	or (
	not tear:HasTearFlags(TearFlags.TEAR_EXPLOSIVE)
	and not tear:HasTearFlags(TearFlags.TEAR_BURSTSPLIT)
	and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH)
	)
	then
		return
	end

	if not swiftTear.PeakReached then
		if not swiftTear.HeightToAdd
		and not swiftTear.HeighToReach
		and not swiftTear.OriginalHeight then
			swiftTear.OriginalHeight = tear.Height
			swiftTear.HeightToAdd = range / 2
			swiftTear.HeightToReach = swiftTear.OriginalHeight - range
		elseif swiftTear.HeightToAdd > 0 then
			swiftTear.HeightToAdd = swiftTear.HeightToAdd / 2
			if swiftTear.HeightToAdd < 5 then
				swiftTear.HeightToAdd = 5
			end
		end

		tear.Height = tear.Height - swiftTear.HeightToAdd

		if tear.Height <= swiftTear.HeightToReach then
			swiftTear.PeakReached = true
			if tear.FallingAcceleration ~= swiftTear.StoredFallingAccel then
				tear.FallingAcceleration = swiftTear.StoredFallingAccel
			end
		end
	end
end

function swiftBase:DelayFallingAcceleration(player, tear)
	local ptrHashTear = tostring(GetPtrHash(tear))
	local swiftTear = swiftBase.Weapon[ptrHashTear]

	if tear.Type == EntityType.ENTITY_TEAR then
		if tear.FallingAcceleration ~= 0 and not swiftTear.StoredFallingAccel then
			swiftTear.StoredFallingAccel = tear.FallingAcceleration
		elseif swiftTear.StoredFallingAccel then
			if not swiftTear.HasFired then
				tear.FallingAcceleration = 0
			elseif swiftTear.HasFired then
				if tear.FallingAcceleration ~= swiftTear.StoredFallingAccel then
					tear.FallingAcceleration = swiftTear.StoredFallingAccel
				end
				RestoreArcShot(player, tear)
			end
		end
	end
end ]]

return swiftBase
