local swiftBomb = {}
local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]
local swiftSynergies = EEVEEMOD.Src["attacks"]["swift.swiftSynergies"]

local function AssignSwiftBombData(player, bomb, anglePos)
	local dataPlayer = player:GetData()
	local dataBomb = bomb:GetData()
	local dataBomb = bomb:GetData()
	local bC = bomb:GetSprite().Color
	swiftBase:SwiftTearFlags(bomb, false, false)
	swiftBase:AssignSwiftBasicData(bomb, player, anglePos)
	if dataPlayer.Swift.Constant then
		swiftBase:SwiftTearFlags(bomb, true, false)
	end
	bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	bomb:SetColor(Color(bC.R, bC.G, bC.B, 0, bC.RO, bC.GO, bC.BO), 15, 1, true, false)
end

function swiftBomb:FireSwiftBomb(bombParent, player, direction)
	local bomb = player:FireBomb(bombParent.Position, direction)
	local bC = bomb:GetSprite().Color
	local pC = bombParent:GetSprite().Color
	local dataBomb = bomb:GetData()
	dataBomb.Swift = {}
	dataBomb.Swift.IsSwiftWeapon = true
	dataBomb.Swift.HasFired = true
	swiftBase:AddSwiftTrail(bomb)
	swiftBase:SwiftTearFlags(bomb, true, true)
	bomb:SetColor(Color(pC.R, pC.G, pC.B, 1, pC.RO, pC.GO, pC.BO), -1, 1, true, false)
	if bombParent.FrameCount < 15 then
		local invisTime = bombParent.FrameCount
		bomb:SetColor(Color(pC.R, pC.G, pC.B, 0, pC.RO, pC.GO, pC.BO), 15 - invisTime, 1, true, false)
	end
	swiftBase:AssignSwiftSounds(bomb)
end

function swiftBomb:SpawnSwiftBombs(player, degreeOfBombSpawns, offset)
	local dataPlayer = player:GetData()
	local anglePos = swiftBase:SpawnPos(player, degreeOfBombSpawns, offset)
	local bomb = player:FireBomb(player.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero)
	
	AssignSwiftBombData(player, bomb, anglePos)
	swiftBase:AddSwiftTrail(bomb)
	
	if dataPlayer.Swift and dataPlayer.Swift.MultiShots > 0 then
	local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 1, dataPlayer.Swift.MultiShots + swiftSynergies:BookwormShot(player) do
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePos = swiftBase:SpawnPosMulti(player, degreeOfBombSpawns, offset, multiOffset, orbit, i)
			local bombMulti = player:FireBomb(bomb.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero)
			local dataMultiBomb = bombMulti:GetData()
			
			dataMultiBomb.MultiSwiftTear = bomb
			dataMultiBomb.MultiSwiftOrbitDistance = orbit
			AssignSwiftBombData(player, bombMulti, anglePos)
			bombMulti:SetSize(bomb.Size/2, Vector(0.5, 0.5), 8)
		end
	end
	swiftBase:AssignSwiftSounds(bomb)
end

function swiftBomb:SwiftBombUpdate(bomb)
	
	if bomb.Parent and bomb.Parent.Type == EntityType.ENTITY_PLAYER then

	local player = bomb.Parent:ToPlayer()
	local dataPlayer = player:GetData()
	local dataBomb = bomb:GetData()
	local room = EEVEEMOD.game:GetRoom()
	
		if dataBomb.Swift and dataBomb.Swift.IsSwiftWeapon then

			if not dataBomb.Swift.HasFired and not dataBomb.Swift.AntiGravTimer then
				bomb:SetExplosionCountdown(35)
				bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				for i = 1, DoorSlot.NUM_DOOR_SLOTS do
					if player.Position:Distance(room:GetDoorSlotPosition(i)) <= 5 then
						bomb:Remove()
					end
				end
			end
		end
	end
end

return swiftBomb