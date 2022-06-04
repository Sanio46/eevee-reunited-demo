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
	IgnoreTimer = false,
	NumWeaponsToSpawn = 5,
	NumWeaponsDead = 0,
}

---@class SwiftWeapon
---@field Trail EntityEffect
---@field WeaponEntity Weapon
---@field ParentInstance SwiftInstance
local SwiftWeaponData = {
	ParentInstance = {},
	StartingPosition = Vector.Zero,
	ShootDirection = Vector.Zero,
	StartingAccel = 0,
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
function swift:GetFireDelay(player)
	local WeaponTypeToFireDelay = {
		[WeaponType.WEAPON_TECH_X] = 1.5,
		[WeaponType.WEAPON_KNIFE] = 1.3,
		[WeaponType.WEAPON_BRIMSTONE] = 1.2,
	}
	for weaponType, delayMult in pairs(WeaponTypeToFireDelay) do
		if player:HasWeaponType(weaponType) then
			return player.MaxFireDelay * delayMult
		end
	end
	return player.MaxFireDelay
end

---@param player EntityPlayer
function swift:GetInstanceCooldown(player)
	local fireDelay = swift:GetFireDelay(player) * 6
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
function swift:GetStartingPos(swiftData)
	return Vector.FromAngle((360 / swiftData.NumWeaponsToSpawn) * swiftData.NumWeaponsSpawned):Resized(swift:SwiftOrbitDistance(swiftData.Player))
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
function swift:CreateSwiftInstance(player, parent)
	---@type SwiftInstance
	local instance = {}
	for variableName, value in pairs(swiftInstanceData) do
		instance[variableName] =  value
	end
	instance.Player = player
	instance.Parent = parent
	table.insert(swiftInstances, instance)
	swift:InitInstanceValues(instance)
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
		swiftWeapon.ParentInstance = swiftData
	end
end

---@param swiftData SwiftInstance
function swift:InitInstanceValues(swiftData)
	local fireDelay = swift:GetFireDelay(swiftData.Player)
	local totalDuration = fireDelay * swiftData.NumWeaponsToSpawn
	swiftData.TotalDuration = totalDuration + 0.5
	swiftData.DurationTimer = totalDuration + 0.5
	swiftData.WeaponSpawnTimer = fireDelay
end

---@param weapon Weapon
function swift:InitWeaponValues(weapon)

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
	local startPos = swift:GetStartingPos(swiftData)

	local parentPos = parent:ToPlayer() and (player.Position - player.TearsOffset) or parent.Position
	---@type EntityTear
	local swiftTear = player:FireTear(parentPos + startPos:Rotated(swiftData.Rotation), Vector.Zero):ToTear()
	swift:InitSwiftWeapon(swiftData, swiftTear)
	---@type SwiftWeapon
	local swiftWeapon = swiftWeapons[tostring(GetPtrHash(swiftTear))]
	swiftWeapon.StartingPosition = startPos
	swiftWeapon.StartingAccel = swiftTear.Height
	swiftWeapon.OrbitDistance = swift:SwiftOrbitDistance(player)
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
	elseif swiftData.IgnoreTimer == false and not swiftData.CanFire then
		swiftData.DurationTimer = 0
		swiftData.CanFire = true
	end
end

---@param swiftData SwiftInstance
function swift:RateOfOrbitRotation(swiftData, player)
	local currentRotation = swiftData.Rotation
	local rateOfRotation = (5 * player.ShotSpeed)
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

	if swiftData.CanFire == false then
		tear.Velocity = swiftData.Parent.Position - (tear.Position - swiftWeapon.StartingPosition:Resized(swiftWeapon.OrbitDistance):Rotated(swiftData.Rotation))
	end
	if swiftWeapon.FireDelay > 0 then
		if swiftData.CanFire == true then
			swiftWeapon.FireDelay = swiftWeapon.FireDelay - 1
		end
		tear.Height = swiftWeapon.StartingAccel
	elseif not swiftWeapon.HasFired then
		swiftWeapon.HasFired = true
		tear.Velocity = Vector(10, 0)
	end
end

function swift:Debug()
	local numInstances = 0
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
	Isaac.RenderText("NumInstances: "..numInstances, 50, 50, 1, 1, 1, 1)
	Isaac.RenderText("Duration: "..durationTimer, 50, 70, 1, 1, 1, 1)
	Isaac.RenderText("Weapon Timer:"..weaponTimer, 50, 90, 1, 1, 1, 1)
	Isaac.RenderText("Cooldown:"..cooldown, 50, 110, 1, 1, 1, 1)
	Isaac.RenderText("NumDead:"..numDead, 50, 130, 1, 1, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, swift.Debug)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, swift.MakeStarOnTearInit)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, swift.OnPostTearUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, swift.OnPostPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, swift.RemoveWeaponOnDeath)

return swift
