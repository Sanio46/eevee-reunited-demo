local swiftLaser = {}

local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]
local swiftSynergies = EEVEEMOD.Src["attacks"]["swift.swiftSynergies"]

local function SwiftLaserType(player)
	if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
		return "techX"
	elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
		return "brim"
	elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
		return "laser"
	end
end

--TODO: Lasers are fucking stupid in color. Spawn a tear for a split second, grab its color, remove immediately, use that????
local function AssignSwiftLaserEffectData(player, effect, anglePos)
	local dataPlayer = player:GetData()
	local dataEffect = effect:GetData()
	local eC = effect:GetSprite().Color
	swiftBase:AssignSwiftBasicData(effect, player, anglePos)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		eC = EEVEEMOD.API.GiveRGB(effect)
	else
		local tear = player:FireTear(effect.Position, Vector.Zero, Vector.Zero)
		tear.CollisionDamage = 0
		local tC = tear:GetSprite().Color
		if swiftBase:AreColorsDifferent(eC, tC) == true then
			effect:SetColor(tC, -1, 1, false, false)
		else
			local colorRed = Color(1,0,0,1,0,0,0)
			effect:SetColor(colorRed, -1, 1, false, false)
		end
		tear:Remove()
	end
	--As theres a small delay on the manual Chocolate Milk synergy affecting the fired laser's collision damage,
	--If you fire fast enough you could potentially just fire a normal 3.5 damage attack. This prevents that.
	if SwiftLaserType(player) == "techX" then
		effect.CollisionDamage = effect.CollisionDamage * 0.25
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
		effect.CollisionDamage = effect.CollisionDamage * 0.1
	else
		effect.CollisionDamage = player.Damage
		if swiftBase:IsSwiftLaserEffect(effect) == "brim" then
			effect:GetSprite().Scale = Vector(0.7, 0.7)
		end
	end
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	effect.Parent = player
	effect.PositionOffset = Vector(0, -25)
end

function swiftLaser:SpawnSwiftLasers(player, degreeOfLaserSpawns, offset)
	local dataPlayer = player:GetData()
	local anglePos = swiftBase:SpawnPos(player, degreeOfLaserSpawns, offset)
	local laserVariant = nil
	if SwiftLaserType(player) == "brim"
	or (SwiftLaserType(player) == "techX" and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)) then
		laserVariant = EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL
	elseif SwiftLaserType(player) == "laser" 
	or SwiftLaserType(player) == "techX" then
		laserVariant = EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT
	end
	if laserVariant ~= nil then
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, laserVariant, 0, player.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero, player):ToEffect()
		AssignSwiftLaserEffectData(player, effect, anglePos)
		swiftBase:AddSwiftTrail(effect, player)
		
		if dataPlayer.Swift.MultiShots > 0 then
		local multiOffset = EEVEEMOD.RandomNum(360)
			for i = 1, dataPlayer.Swift.MultiShots + swiftSynergies:BookwormShot(player) do
				local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
				local anglePos = swiftBase:SpawnPosMulti(player, degreeOfLaserSpawns, offset, multiOffset, orbit, i)
				local effectMulti = Isaac.Spawn(EntityType.ENTITY_EFFECT, laserVariant, 0, effect.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero, player):ToEffect()
				local dataMultiEffect = effectMulti:GetData()
				
				dataMultiEffect.MultiSwiftTear = effect
				dataMultiEffect.MultiSwiftOrbitDistance = orbit
				AssignSwiftLaserEffectData(player, effectMulti, anglePos)
				effectMulti:GetSprite().Scale = Vector(0.5,0.5)
			end
		end
		swiftBase:AssignSwiftSounds(effect)
	end
end

function swiftLaser:TechXRadiusScaling(effect, player)
	local dataPlayer = player:GetData()
	local dataEffect = effect:GetData()
	local radius = 15
	
	if dataPlayer.Swift
	and dataPlayer.Swift.AttackDuration > 0
	and dataPlayer.Swift.AttackDurationSet then
		radius = 15 + (45 * (dataPlayer.Swift.AttackDurationSet - dataPlayer.Swift.AttackDuration) / dataPlayer.Swift.AttackDurationSet)
		if dataEffect.Swift then
			dataEffect.Swift.TechXRadius = radius
		end
	end
	
	return radius
end

function swiftLaser:TechXDamageScaling(weapon, player)
	local dataPlayer = player:GetData()
	local dataWeapon = weapon:GetData()
	
	if dataWeapon.Swift then
		if dataPlayer.Swift.AttackDuration > 0
		and dataPlayer.Swift.AttackDurationSet
		and not dataWeapon.Swift.HasFired then
			local playerDamage = player.Damage * 0.25
			local damageCalc = playerDamage + (3 * (dataPlayer.Swift.AttackDurationSet - dataPlayer.Swift.AttackDuration) / dataPlayer.Swift.AttackDurationSet)
			if damageCalc < 0.1 then
				weapon.CollisionDamage = 0.1
			elseif damageCalc > player.Damage then
				weapon.CollisionDamage = player.Damage
			else
				weapon.CollisionDamage = damageCalc
			end
		end
	end
end

function swiftLaser:FireTechXLaser(parent, player, direction, knifeOverride)
	local dataPlayer = player:GetData()
	local dataParent = parent:GetData()
	local damageMult = knifeOverride and player.Damage * 0.25 or parent.CollisionDamage / player.Damage
	local radius = knifeOverride and 25 or dataParent.Swift.TechXRadius or 15

	if damageMult == 0 then
		damageMult = 0.25
	end
	
	local techX = player:FireTechXLaser(parent.Position, swiftBase:SwiftShotVelocity(direction, player, true), radius, player, damageMult)
	local dataTechX = techX:GetData()
	if knifeOverride then
		techX.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE 
	end
	dataTechX.Swift = {}
	dataTechX.Swift.Player = player
	techX.Parent = parent
end

function swiftLaser:FireBrimLaser(parent, player, direction, rotationOffset)
	local dataPlayer = player:GetData()
	local dataParent = parent:GetData()
	local damageMult = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
		damageMult = parent.CollisionDamage / player.Damage
	end
	local brim = player:FireBrimstone(direction, parent, damageMult):ToLaser()
	local dataBrim = brim:GetData()
	local brimSprite = brim:GetSprite()
	dataBrim.Swift = {}
	brim.Parent = parent
	brim.PositionOffset = Vector(0, -23)
	dataBrim.Swift.Player = player
	if dataPlayer.Swift.Constant then
		dataBrim.Swift.IsConstantLaser = true
		dataParent.Swift.LaserHasFired = true
		if rotationOffset then
			dataBrim.Swift.ConstantRotationOffset = rotationOffset
		else
			dataBrim.Swift.ConstantRotationOffset = 0
		end
	end
end

function swiftLaser:FireTechLaser(parent, player, direction, isTech2)
	local dataParent = parent:GetData()
	local damageMult = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
		damageMult = parent.CollisionDamage / player.Damage
	end
	if isTech2 then
		damageMult = 0.8
	end
	local laser = player:FireTechLaser(parent.Position, LaserOffset.LASER_TRACTOR_BEAM_OFFSET, direction, false, false, parent, damageMult):ToLaser()
	local dataLaser = laser:GetData()
	dataLaser.Swift = {}
	dataLaser.Swift.Player = player
	laser.Parent = parent
	laser.PositionOffset = Vector(0, -23)
	if isTech2 then
		dataLaser.Swift.IsTech2 = true
		laser.Timeout = 3
		if not dataLaser.Swift.ConstantRotationOffset then
			dataLaser.Swift.ConstantRotationOffset = 0
		end
	end
end

function swiftLaser:FireSwiftLaser(parent, player, direction, rotationOffset)
	if SwiftLaserType(player) == "techX" then
		swiftLaser:FireTechXLaser(parent, player, direction)
	elseif SwiftLaserType(player) == "brim" then
		swiftLaser:FireBrimLaser(parent, player, direction, rotationOffset)
	elseif SwiftLaserType(player) == "laser" then
		swiftLaser:FireTechLaser(parent, player, direction)
	end
end

local LaserEffectSize = {
	[EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT] = 20,
	[EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL] = 35,
}

function swiftLaser:SwiftLaserEffectUpdate(effect)
	
	if effect.Parent
	and effect.Parent.Type == EntityType.ENTITY_PLAYER
	and swiftBase:IsSwiftLaserEffect(effect) then

	local player = effect.Parent:ToPlayer()
	local dataPlayer = player:GetData()
	local dataEffect = effect:GetData()
		
		if dataEffect.Swift and dataEffect.Swift.IsSwiftWeapon then
		
			if SwiftLaserType(player) == "techX" then
				swiftLaser:TechXDamageScaling(effect, player)
				swiftLaser:TechXRadiusScaling(effect, player)
			elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
				effect.CollisionDamage = player.Damage
			end
			
			local scale = effect:GetSprite().Scale.X
			
			for _, ent in pairs(Isaac.FindInRadius(effect.Position, scale * LaserEffectSize[effect.Variant], EntityPartition.ENEMY)) do
				if ent:IsActiveEnemy(false) and ent:IsVulnerableEnemy() and effect.FrameCount % 3 == 0 then
					ent:TakeDamage(effect.CollisionDamage, DamageFlag.DAMAGE_LASER, EntityRef(player), 50)
				end
			end
		
			if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
				EEVEEMOD.API.GiveRGB(effect)
			end
		
			if not dataEffect.Swift.HasFired then
				effect.Timeout = 2
			else
				local fireDirection = dataEffect.Swift.ShotDir
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
				and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
					fireDirection = fireDirection:Rotated(45)
				end
			
				if not dataEffect.Swift.LaserHasFired then
					if swiftBase:IsSwiftLaserEffect(effect) == "tech" then
						swiftLaser:FireSwiftLaser(effect, player, fireDirection)
					elseif swiftBase:IsSwiftLaserEffect(effect) == "brim" then
						swiftLaser:FireSwiftLaser(effect, player, fireDirection)
					end
					dataEffect.Swift.LaserHasFired = true
				end
				if dataEffect.Swift.ConstantOrbit then
					if player:GetFireDirection() ~= Direction.NO_DIRECTION then
						effect.Timeout = 2
					end
				end
			end
		end
	end
end

function swiftLaser:SwiftLaserUpdate(laser)
	local dataLaser = laser:GetData()

	if dataLaser.Swift
	and dataLaser.Swift.Player
	and laser.Parent
	and laser.Parent:GetData().Swift
	and (
	laser.Parent:GetData().Swift.ShotDir
	)	then
		local player = dataLaser.Swift.Player
		local parent = laser.Parent
		local dataPlayer = player:GetData()
		local dataParent = laser.Parent:GetData()
		
		laser.Position = parent.Position
		
		swiftSynergies:TechXKnifeUpdate(laser, parent)

		if (dataLaser.Swift.IsTech2 and not dataParent.Swift.HasFired)
		or (dataLaser.Swift.IsConstantLaser and player:GetFireDirection() ~= Direction.NO_DIRECTION
		and dataParent.Swift.ConstantOrbit)
		then
			if laser.Variant == EEVEEMOD.LaserVariant.BRIMSTONE then
				laser.Timeout = 7
			else
				laser.Timeout = 3
			end
			if dataLaser.Swift.ConstantRotationOffset then
				laser.Angle = dataParent.Swift.ShotDir:Rotated(dataLaser.Swift.ConstantRotationOffset):GetAngleDegrees()
			end
		end
	end
end

return swiftLaser