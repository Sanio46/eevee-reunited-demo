local swiftKnife = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")
local swiftLaser = require("src_eevee.attacks.eevee.swiftLaser")

local knifeLifetime = 50

local function AssignSwiftFakeKnifeData(player, tearKnife, knife, anglePos)
	swiftBase:AssignSwiftBasicData(tearKnife, player, anglePos)
	local ptrHashTearKnife = tostring(GetPtrHash(tearKnife))
	local swiftTearKnife = swiftBase.Weapon[ptrHashTearKnife]
	local tC = tearKnife:GetSprite().Color

	swiftBase:SwiftTearFlags(tearKnife, true, false)
	tearKnife:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), -1, 1, false, false)
	swiftTearKnife.IsFakeKnife = true
	tearKnife.Child = knife
	swiftTearKnife.HeightDuration = knifeLifetime
	tearKnife.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	tearKnife.CollisionDamage = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
		swiftLaser:FireTechXLaser(tearKnife, player, Vector.Zero, true)
	end
end

local function AssignSwiftKnifeData(player, knife, tearKnife, invis)
	local sprite = knife:GetSprite()
	local fKC = tearKnife:GetSprite().Color
	local ptrHashTearKnife = tostring(GetPtrHash(tearKnife))
	local swiftTearKnife = swiftBase.Weapon[ptrHashTearKnife]

	sprite:Load("gfx/knife_swift.anm2", true)
	sprite:Play("Idle", true)
	sprite.Offset = Vector(0, -4)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		knife.Color = swiftBase:PlaydoughRandomColor()
	else
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 1, fKC.RO, fKC.GO, fKC.BO), -1, 1, true, false)
	end
	if invis then
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), 15, 1, true, false)
	end
	knife.Parent = tearKnife
	knife.Position = tearKnife.Position
	knife.Rotation = swiftTearKnife.ShotDir:GetAngleDegrees()
	knife.CollisionDamage = player.Damage
end

function swiftKnife:FireSwiftKnife(knifeParent, player, direction)
	local tearKnife = player:FireTear(knifeParent.Position - player.TearsOffset, direction, false, false, false, player)
	local knife = player:FireKnife(tearKnife)
	swiftBase:InitSwiftWeapon(tearKnife)
	local ptrHashTearKnife = tostring(GetPtrHash(tearKnife))
	local swiftTearKnife = swiftBase.Weapon[ptrHashTearKnife]

	swiftTearKnife.IsFakeKnife = true
	tearKnife.Child = knife
	swiftTearKnife.HeightDuration = knifeLifetime
	swiftTearKnife.ShotDir = direction
	swiftTearKnife.HoldTearHeight = tearKnife.Height
	AssignSwiftKnifeData(player, knife, tearKnife, false)
	local fKC = tearKnife:GetSprite().Color
	tearKnife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), -1, 1, false, false)
	if knifeParent.FrameCount < 15 then
		local invisTime = knifeParent.FrameCount
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), 15 - invisTime, 1, true, false)
	end
	tearKnife:ClearTearFlags(tearKnife.TearFlags)
	swiftBase:AddSwiftTrail(tearKnife, player)
	swiftBase:SwiftTearFlags(tearKnife, true, true)
	swiftTearKnife.HasFired = true
	swiftBase:AssignSwiftSounds(tearKnife)
end

function swiftKnife:SpawnSwiftKnives(player, degreeOfKnifeSpawns, offset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local anglePos = swiftBase:SpawnPos(player, degreeOfKnifeSpawns, offset)
	local tearKnife = player:FireTear((player.Position - player.TearsOffset) + (anglePos:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, false, false, false, player)
	local knife = player:FireKnife(player)

	AssignSwiftFakeKnifeData(player, tearKnife, knife, anglePos)
	AssignSwiftKnifeData(player, knife, tearKnife, true)
	swiftBase:AddSwiftTrail(tearKnife, player)

	if swiftPlayer.MultiShots > 0 and not player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
		local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 1, swiftPlayer.MultiShots + swiftSynergies:BookwormShot(player) do
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePosMulti = swiftBase:SpawnPosMulti(player, multiOffset, orbit, i)
			local tearKnifeMulti = player:FireTear((tearKnife.Position - player.TearsOffset) + (anglePosMulti:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, false, false, false, player)
			local knifeMulti = player:FireKnife(player)
			local dataMultiTear = tearKnifeMulti:GetData()

			dataMultiTear.IsMultiShot = true
			dataMultiTear.MultiRotation = (360 / swiftPlayer.MultiShots) * i
			tearKnifeMulti.Parent = tearKnife
			dataMultiTear.MultiSwiftOrbitDistance = orbit
			AssignSwiftFakeKnifeData(player, tearKnifeMulti, knifeMulti, anglePosMulti)
			AssignSwiftKnifeData(player, knifeMulti, tearKnifeMulti, true)
			knifeMulti:GetSprite().Scale = Vector(0.5, 0.5)
		end
	end
	swiftBase:AssignSwiftSounds(tearKnife)
end

function swiftKnife:SwiftKnifeUpdate(knife)
	if not VeeHelper.EntitySpawnedByPlayer(knife, true) then return end

	local tearKnife = knife.Parent
	if not knife.Parent then knife:Remove() return end
	local ptrHashTearKnife = tostring(GetPtrHash(tearKnife))
	local swiftTearKnife = swiftBase.Weapon[ptrHashTearKnife]

	if not swiftTearKnife or swiftTearKnife.IsFakeKnife ~= true then return end

	if swiftTearKnife.HeightDuration and swiftTearKnife.HeightDuration > 0 then
		if swiftTearKnife.HoldTearHeight then
			tearKnife:ToTear().Height = swiftTearKnife.HoldTearHeight
		end
		if swiftTearKnife.HasFired then
			swiftTearKnife.HeightDuration = swiftTearKnife.HeightDuration - 1
		end
	end

	if not swiftTearKnife.HasFired then
		knife.Rotation = swiftTearKnife.ShotDir:GetAngleDegrees()
	else
		if swiftTearKnife.AntiGravDir then
			knife.Rotation = swiftTearKnife.AntiGravDir:GetAngleDegrees()
		else
			knife.Rotation = tearKnife.Velocity:GetAngleDegrees()
		end
	end

	--Set boundary limit for knives
	if not tearKnife:ToTear():HasTearFlags(TearFlags.TEAR_CONTINUUM) then
		local room = EEVEEMOD.game:GetRoom()
		if not room:IsPositionInRoom(tearKnife.Position, -150) then
			tearKnife:Remove()
		end
	else
		local tC = tearKnife:GetSprite().Color
		tearKnife:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), -1, 1, false, false)
	end
end

return swiftKnife
