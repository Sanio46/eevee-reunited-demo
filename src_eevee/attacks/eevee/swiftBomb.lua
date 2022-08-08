local swiftBomb = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")

local function AssignSwiftBombData(player, bomb, anglePos)
	swiftBase:AssignSwiftBasicData(bomb, player, anglePos)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	local bC = bomb:GetSprite().Color
	swiftBase:SwiftTearFlags(bomb, false, false)
	if swiftPlayer.Constant == true then
		swiftBase:SwiftTearFlags(bomb, true, false)
	end
	bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	bomb:SetColor(Color(bC.R, bC.G, bC.B, 0, bC.RO, bC.GO, bC.BO), 15, 1, true, false)
end

function swiftBomb:FireSwiftBomb(bombParent, player, direction)
	local bomb = player:FireBomb((bombParent.Position - player.TearsOffset), direction, player)
	local pC = bombParent:GetSprite().Color
	swiftBase:InitSwiftWeapon(bomb)
	local ptrHashBomb = tostring(GetPtrHash(bomb))
	local swiftBombWeapon = swiftBase.Weapon[ptrHashBomb]

	swiftBombWeapon.HasFired = true
	swiftBase:AddSwiftTrail(bomb, player)
	swiftBase:SwiftTearFlags(bomb, true, true)
	bomb:SetColor(Color(pC.R, pC.G, pC.B, 1, pC.RO, pC.GO, pC.BO), -1, 1, true, false)
	if bombParent.FrameCount < 15 then
		local invisTime = bombParent.FrameCount
		bomb:SetColor(Color(pC.R, pC.G, pC.B, 0, pC.RO, pC.GO, pC.BO), 15 - invisTime, 1, true, false)
	end
	swiftBase:AssignSwiftSounds(bomb)
end

function swiftBomb:SpawnSwiftBombs(player, degreeOfBombSpawns, offset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local anglePos = swiftBase:SpawnPos(player, degreeOfBombSpawns, offset)
	local bomb = player:FireBomb((player.Position - player.TearsOffset) + (anglePos:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, player)

	AssignSwiftBombData(player, bomb, anglePos)
	swiftBase:AddSwiftTrail(bomb, player)

	if swiftPlayer and swiftPlayer.MultiShots > 0 then
		local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 1, swiftPlayer.MultiShots + swiftSynergies:BookwormShot(player) do
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePosMulti = swiftBase:SpawnPosMulti(player, multiOffset, orbit, i)
			local bombMulti = player:FireBomb((bomb.Position - player.TearsOffset) + (anglePosMulti:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, player)
			local dataMultiBomb = bombMulti:GetData()

			dataMultiBomb.IsMultiShot = true
			dataMultiBomb.MultiRotation = (360 / swiftPlayer.MultiShots) * i
			bombMulti.Parent = bomb
			dataMultiBomb.MultiSwiftOrbitDistance = orbit
			AssignSwiftBombData(player, bombMulti, anglePosMulti)
			bombMulti:SetSize(bomb.Size / 2, Vector(0.5, 0.5), 8)
		end
	end
	swiftBase:AssignSwiftSounds(bomb)
end

function swiftBomb:SwiftBombUpdate(bomb)

	if not VeeHelper.EntitySpawnedByPlayer(bomb, true) then return end

	local player = bomb.SpawnerEntity:ToPlayer()
	local ptrHashBomb = tostring(GetPtrHash(bomb))
	local swiftBombWeapon = swiftBase.Weapon[ptrHashBomb]
	local room = EEVEEMOD.game:GetRoom()

	if not swiftBombWeapon then return end

	if not swiftBombWeapon.HasFired and not swiftBombWeapon.AntiGravTimer then
		bomb:SetExplosionCountdown(35)
		bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		for i = 1, DoorSlot.NUM_DOOR_SLOTS do
			if player.Position:DistanceSquared(room:GetDoorSlotPosition(i)) <= 10 ^ 2 then
				bomb:Remove()
			end
		end
	end
end

return swiftBomb
