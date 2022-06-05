local swift = {}

local mod = RegisterMod("Swift Tear Testing", 1)

---@class SwiftInstance
---@field Player EntityPlayer
---@field Parent Entity
---@field ActiveWeapons Weapon[]
local swiftInstanceData = {
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
	InverseShootingRequirement = false,
	Perpetual = false,
}

---@class SwiftWeapon
---@field Trail EntityEffect
---@field WeaponEntity Weapon
---@field ParentInstance SwiftInstance
local SwiftWeaponData = {
	ParentInstance = {},
	StartingAngle = Vector.Zero,
	ShootDirection = Vector.Zero,
	StartingAccel = 0,
	StartingFall = 0,
	OrbitDistance = 0,
	Trail = nil,
	FireDelay = 2,
	HasFired = false,
}

---@type SwiftInstance[]
local swiftInstances = {}
---@type SwiftWeapon[]
local swiftWeapons = {}

-------------------------------
--  SETTING / OBTANING DATA  --
-------------------------------

---@param player EntityPlayer
---@param ignoreCap? boolean
function swift:GetFireDelay(player, ignoreCap)
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
function swift:GetInstanceCooldown(player)
	local fireDelay = swift:GetFireDelay(player, true)
	fireDelay = fireDelay + (math.abs(fireDelay) * 9)
	return fireDelay
end

---@param player EntityPlayer
function swift:SwiftOrbitDistance(player)
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
function swift:GetStartingAngle(swiftData)
	return Vector.FromAngle((360 / swiftData.NumWeaponsToSpawn) * swiftData.NumWeaponsSpawned)
end

------------------
--  INITIATING  --
------------------

---@param player EntityPlayer
function swift:InitInstance(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if playerType == EEVEEMOD.PlayerType.EEVEE and not data.TimeTillNextInstance and player:GetFireDirection() ~= Direction.NO_DIRECTION then
		swift:CreateSwiftInstance(player, player)
		data.TimeTillNextInstance = swift:GetInstanceCooldown(player)
	end
	if data.TimeTillNextInstance then
		if data.TimeTillNextInstance > 0 then
			data.TimeTillNextInstance = data.TimeTillNextInstance - 0.5
		else
			data.TimeTillNextInstance = nil
		end
	end
end

---@param player EntityPlayer
---@param parent Entity
---@param customData? SwiftInstance
function swift:CreateSwiftInstance(player, parent, customData)
	---@type SwiftInstance
	local instance = {}
	for variableName, value in pairs(swiftInstanceData) do
		if customData ~= nil
			and customData[variableName] ~= nil then
			instance[variableName] = customData[variableName]
		else
			instance[variableName] = value
		end
	end
	instance.Player = player
	instance.Parent = parent
	table.insert(swiftInstances, instance)
	swift:InitInstanceValues(instance, customData)
	swift:FireSwift(instance, player, parent)
end

---@param swiftData SwiftInstance
---@param weapon Weapon
function swift:InitSwiftWeapon(swiftData, weapon)
	table.insert(swiftData.ActiveWeapons, weapon)
	local ptrHashWeapon = tostring(GetPtrHash(weapon))
	if swiftWeapons[ptrHashWeapon] == nil then
		swiftWeapons[ptrHashWeapon] = {}
		local swiftWeapon = swiftWeapons[ptrHashWeapon]
		for variableName, value in pairs(SwiftWeaponData) do
			swiftWeapon[variableName] = value
		end
		swift:InitWeaponValues(swiftData, swiftWeapon, weapon)
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param weapon Weapon
function swift:InitWeaponValues(swiftData, swiftWeapon, weapon)
	swiftWeapon.StartingAngle = swift:GetStartingAngle(swiftData)
	swiftWeapon.StartingAccel = weapon.FallingAcceleration
	swiftWeapon.StartingFall = weapon.FallingSpeed
	swiftWeapon.OrbitDistance = swift:SwiftOrbitDistance(swiftData.Player)
	swiftWeapon.ParentInstance = swiftData
	swiftWeapon.ShootDirection = VeeHelper.GetIsaacShootingDirection(swiftData.Player, weapon.Position)
	local fireDelay = (swift:GetFireDelay(swiftData.Player) / (swiftData.NumWeaponsToSpawn / swiftData.NumWeaponsSpawned))
	swiftWeapon.FireDelay = fireDelay
end

---@param swiftData SwiftInstance
---@param customData? SwiftInstance
function swift:InitInstanceValues(swiftData, customData)
	local fireDelay = swift:GetFireDelay(swiftData.Player)
	local totalDuration = (fireDelay * swiftData.NumWeaponsToSpawn) + 0.5
	
	if customData == nil or customData.TotalDuration == nil then
		swiftData.TotalDuration = totalDuration
	end
	if customData == nil or customData.DurationTimer == nil then
		swiftData.DurationTimer = totalDuration
	end
	if customData == nil or customData.WeaponSpawnTimer == nil then
		swiftData.WeaponSpawnTimer = fireDelay
	end
	swiftData.Rotation = VeeHelper.GetIsaacShootingDirection(swiftData.Player):Rotated(-1 * (360 / swiftData.NumWeaponsToSpawn)):GetAngleDegrees()
end

---@param tear EntityTear
function swift:AssignSwiftSprite(tear)

	if VeeHelper.TearVariantBlacklist[tear.Variant]
		or EEVEEMOD.KeepTearVariants[tear.Variant] then
		return
	end

	local tearSprite = tear:GetSprite()
	local dataTear = tear:GetData()
	local animationToPlay = VeeHelper.TearScaleToSizeAnim(tear)
	local variantToUse = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and "gfx/tear_swift.anm2" or EEVEEMOD.TearVariant.SWIFT

	if dataTear.ForceBlood or VeeHelper.TearFlagsBlood[tear.Variant] then
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

---@param weapon Weapon
function swift:AddBasicSwiftTrail(weapon)
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

---@param tear EntityTear
function swift:MakeStarOnTearInit(tear)
	if VeeHelper.EntitySpawnedByPlayer(tear) then
		local player = tear.SpawnerEntity:ToPlayer()
		local playerType = player:GetPlayerType()

		if playerType == EEVEEMOD.PlayerType.EEVEE then
			swift:AssignSwiftSprite(tear)
			--swift:AddBasicSwiftTrail(tear)
			swift:PlaySwiftFire()
		end
	end
end

-------------------
--  DOING STUFF  --
-------------------

function swift:PlaySwiftFire()
	local values = {
		0.9,
		1,
		1.1
	}
	EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SWIFT_FIRE, 1, 2, false, values[EEVEEMOD.RandomNum(3)])
end

---@param swiftData SwiftInstance
---@param player EntityPlayer
---@param parent Entity
function swift:FireSwift(swiftData, player, parent)
	local spawnPos = swift:GetStartingAngle(swiftData):Resized(swift:SwiftOrbitDistance(swiftData.Player)):Rotated(swiftData.Rotation)
	local parentPos = parent:ToPlayer() and (player.Position - player.TearsOffset) or parent.Position
	---@type EntityTear
	local swiftTear = player:FireTear(parentPos + spawnPos, Vector.Zero):ToTear()
	swiftTear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
	if swiftTear.Height > -24 then swiftTear.Height = -24 end
	swift:InitSwiftWeapon(swiftData, swiftTear)
end

---@param swiftData SwiftInstance
---@param index integer
function swift:RemoveSwiftInstance(swiftData, index)
	if swiftData.CanFire and swiftData.NumWeaponsDead >= swiftData.NumWeaponsSpawned or swiftData.NumWeaponsDead >= swiftData.NumWeaponsToSpawn then
		table.remove(swiftInstances, index)
	end
end

---@param weapon Weapon
function swift:RemoveWeaponOnDeath(weapon)
	local swiftWeapon = swiftWeapons[tostring(GetPtrHash(weapon))]
	if swiftWeapon == nil then return end
	local swiftData = swiftWeapon.ParentInstance
	if swiftData == nil then return end

	if swiftWeapon ~= nil then
		swiftData.NumWeaponsDead = swiftData.NumWeaponsDead + 1
	end
end

function swift:AddSwiftTrail(weapon, player)
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
	local swiftWeapon = swiftWeapons[tostring(GetPtrHash(weapon))]
	if swiftWeapon then
		swiftWeapon.Trail = trail
	end
	trail.MinRadius = 0.2
	trail.RenderZOffset = -10
	trail:Update()
end

--------------------
--  SWIFT UPDATE  --
--------------------

function swift:FireIfNotShooting(swiftData)
	local player = swiftData.Player

	if player:GetFireDirection() == Direction.NO_DIRECTION
		and not swiftData.CanFire then
		swiftData.CanFire = true
	end
end

---@param swiftData SwiftInstance
function swift:SpawnNextWeapon(swiftData)
	if swiftData.WeaponSpawnTimer > 0 then
		swiftData.WeaponSpawnTimer = swiftData.WeaponSpawnTimer - 0.5
	elseif swiftData.NumWeaponsSpawned < swiftData.NumWeaponsToSpawn then
		swiftData.NumWeaponsSpawned = swiftData.NumWeaponsSpawned + 1
		swift:FireSwift(swiftData, swiftData.Player, swiftData.Parent)
		swiftData.WeaponSpawnTimer = swift:GetFireDelay(swiftData.Player)
	end
end

---@param swiftData SwiftInstance
function swift:CountdownDuration(swiftData)
	if swiftData.DurationTimer > 0.5 then
		swiftData.DurationTimer = swiftData.DurationTimer - 0.5
	elseif swiftData.Perpetual == false and not swiftData.CanFire then
		swiftData.DurationTimer = 0
		swiftData.CanFire = true
	end
end

---@param swiftData SwiftInstance
function swift:RateOfOrbitRotation(swiftData, player)
	local currentRotation = swiftData.Rotation
	local rateOfRotation = (7 * (player.ShotSpeed * (swiftData.DurationTimer / swiftData.TotalDuration)))
	if rateOfRotation <= 2 then rateOfRotation = 2 end
	currentRotation = currentRotation + rateOfRotation
	if currentRotation > 360 then currentRotation = currentRotation - 360 end
	swiftData.Rotation = currentRotation
end

---@param player EntityPlayer
function swift:OnPostPlayerUpdate(player)
	swift:InitInstance(player)
	for index, swiftData in ipairs(swiftInstances) do
		swift:RemoveSwiftInstance(swiftData, index)
		swift:FireIfNotShooting(swiftData)
		swift:RateOfOrbitRotation(swiftData, player)
		if not swiftData.CanFire then
			swift:SpawnNextWeapon(swiftData)
			swift:CountdownDuration(swiftData)
		end
	end
end

---@param tear EntityTear
function swift:OnPostTearUpdate(tear)
	local swiftWeapon = swiftWeapons[tostring(GetPtrHash(tear))]
	if swiftWeapon == nil then return end
	local swiftData = swiftWeapon.ParentInstance
	if swiftData == nil then return end
	local sprite = tear:GetSprite()

	if tear.Variant == EEVEEMOD.TearVariant.SWIFT or tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD then
		local anim = tear.Variant == EEVEEMOD.TearVariant.SWIFT_BLOOD and "BloodTear" or "RegularTear"
		local animToPlay = anim .. VeeHelper.TearScaleToSizeAnim(tear)

		if tear.FrameCount > 1 and sprite:GetAnimation() ~= animToPlay then
			sprite:Play(anim .. VeeHelper.TearScaleToSizeAnim(tear), true)
		end
	end

	if swiftWeapon.FireDelay > 0 then
		tear.Velocity = swiftData.Parent.Position - (tear.Position - swiftWeapon.StartingAngle:Resized(swiftWeapon.OrbitDistance):Rotated(swiftData.Rotation))
		if swiftData.CanFire == true then
			swiftWeapon.FireDelay = swiftWeapon.FireDelay - 1
		end
		tear.FallingSpeed = -0.1
		tear.FallingAcceleration = 0
	elseif not swiftWeapon.HasFired then
		swiftWeapon.HasFired = true
		tear.FallingSpeed = swiftWeapon.StartingFall
		tear.FallingAcceleration = swiftWeapon.StartingAccel
		tear.Velocity = Vector(10, 0)
	end
	if tear.Variant == TearVariant.ICE or tear.Variant == TearVariant.COIN then
		if not swiftWeapon.HasFired then
			sprite.Rotation = swiftWeapon.ShootDirection:GetAngleDegrees()
		end
	elseif tear.Variant ~= TearVariant.BELIAL then
		if not swiftWeapon.HasFired then
			sprite.Rotation = (swiftData.Rotation * -2)
		else
			local data = tear:GetData()
			if not data.AfterFireSwiftRotation then
				data.AfterFireSwiftRotation = sprite.Rotation
			else
				sprite.Rotation = data.AfterFireSwiftRotation
				data.AfterFireSwiftRotation = data.AfterFireSwiftRotation - 20
			end
		end
	end
end

function swift:SwiftTrailUpdate(trail)
	if trail.Parent then
		local weapon = trail.Parent
		local room = EEVEEMOD.game:GetRoom()
		local tC = trail.Color

		if trail:GetData().EeveeRGB == true then
			trail:SetColor(EEVEEMOD.GetRBG(tC), -1, -1, true, false)
		else
			local wC = weapon:GetSprite().Color
			if VeeHelper.AreColorsDifferent(wC, trail:GetData().TrailColor)
				and VeeHelper.AreColorsDifferent(wC, Color.Default) then
				trail:SetColor(wC, -1, 1, true, false)
			end
		end

		if not room:IsPositionInRoom(trail.Position, -30) then
			trail:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 5, 2, true, false)
		end
		local heightDif = 0
		if weapon.Type == EntityType.ENTITY_TEAR then
			local tearHeightToFollow = (weapon:ToTear().Height * 0.4) - 15
			local sizeToFollow = weapon.Size * 0.5
			trail.SpriteScale = Vector(weapon.Size * 0.2, 1)
			trail.Position = Vector(weapon.Position.X, (weapon.Position.Y + (tearHeightToFollow + heightDif)) - sizeToFollow) + weapon:ToTear().PosDisplacement
		else
			if weapon.Type == EntityType.ENTITY_EFFECT and weapon.Variant == EffectVariant.EVIL_EYE then
				heightDif = 20
			end
			trail.Position = Vector(weapon.Position.X, weapon.Position.Y + weapon.PositionOffset.Y - heightDif)
		end
	else
		if trail:GetData().SwiftTrail then
			trail:Remove()
		end
	end
end

function swift:Debug()
--[[ 	local numInstances = 0
	local weaponTimer = 0
	local durationTimer = 0
	local cooldown = 0
	local numDead = 0
	local swiftData = nil
	if swiftInstances[1] ~= nil then
		swiftData = swiftInstances[1]
		numInstances = #swiftInstances
		durationTimer = swiftData.DurationTimer
		weaponTimer = swiftData.WeaponSpawnTimer
		numDead = swiftData.NumWeaponsDead
	end
	if Isaac.GetPlayer():GetData().TimeTillNextInstance ~= nil then
		cooldown = Isaac.GetPlayer():GetData().TimeTillNextInstance
	end
	Isaac.RenderText("NumInstances: " .. numInstances, 50, 50, 1, 1, 1, 1)
	Isaac.RenderText("Duration: " .. durationTimer, 50, 70, 1, 1, 1, 1)
	Isaac.RenderText("Weapon Timer:" .. weaponTimer, 50, 90, 1, 1, 1, 1)
	Isaac.RenderText("Cooldown:" .. cooldown, 50, 110, 1, 1, 1, 1)
	Isaac.RenderText("NumDead:" .. numDead, 50, 130, 1, 1, 1, 1) ]]
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, swift.Debug)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, swift.MakeStarOnTearInit)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, swift.OnPostTearUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, swift.OnPostPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, swift.RemoveWeaponOnDeath)

return swift
