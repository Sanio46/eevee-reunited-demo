local swiftKnife = {}
local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]
local swiftSynergies = EEVEEMOD.Src["attacks"]["swift.swiftSynergies"]

local knifeLifetime = 50

local function AssignSwiftFakeKnifeData(player, tearKnife, knife, anglePos)
	local dataPlayer = player:GetData()
	local dataTearKnife = tearKnife:GetData()
	local tC = tearKnife:GetSprite().Color
	
	swiftBase:SwiftTearFlags(tearKnife, true, false)
	swiftBase:AssignSwiftBasicData(tearKnife, player, anglePos)
	tearKnife:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), -1, 1, false, false)
	dataTearKnife.Swift.IsFakeKnife = true
	tearKnife.Child = knife
	dataTearKnife.HeightDuration = knifeLifetime
	tearKnife.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	tearKnife.CollisionDamage = 0
end

local function AssignSwiftKnifeData(knife, tearKnife, invis)
	local player = tearKnife.Parent:ToPlayer()
	local sprite = knife:GetSprite()
	local tC = knife:GetSprite().Color
	local fKC = tearKnife:GetSprite().Color
	local dataTearKnife = tearKnife:GetData()
	
	sprite:Load("gfx/knife_swift.anm2", true)
	sprite:Play("Idle", true)
	sprite.Offset = Vector(0, -4)
	knife:GetData().Swift = {}
	knife:GetData().Swift.Player = player
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		swiftBase:PlaydoughRandomColor(knife)
	else
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 1, fKC.RO, fKC.GO, fKC.BO), -1, 1, true, false)
	end
	if invis then
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), 15, 1, true, false)
	end
	knife.Parent = tearKnife
	knife.Position = tearKnife.Position
	knife.Rotation = dataTearKnife.Swift.ShotDir:GetAngleDegrees()
end

function swiftKnife:FireSwiftKnife(knifeParent, player, direction)
	local tearKnife = player:FireTear(knifeParent.Position, direction, false, false, false, player, 1)
	local knife = player:FireKnife(tearKnife)
	local dataTearKnife = tearKnife:GetData()
	
	dataTearKnife.Swift = {}
	dataTearKnife.Swift.IsFakeKnife = true
	tearKnife.Child = knife
	dataTearKnife.HeightDuration = knifeLifetime
	dataTearKnife.Swift.ShotDir = EEVEEMOD.API.GetIsaacShootingDirection(player)
	dataTearKnife.Swift.HoldTearHeight = tearKnife.Height
	AssignSwiftKnifeData(knife, tearKnife, false)
	local fKC = tearKnife:GetSprite().Color
	tearKnife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), -1, 1, false, false)
	if knifeParent.FrameCount < 15 then
		local invisTime = knifeParent.FrameCount
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), 15 - invisTime, 1, true, false)
	end
	tearKnife:ClearTearFlags(tearKnife.TearFlags)
	swiftBase:AddSwiftTrail(tearKnife)
	swiftBase:SwiftTearFlags(tearKnife, true, true)
	dataTearKnife.Swift.IsSwiftWeapon = true
	dataTearKnife.Swift.HasFired = true
end

function swiftKnife:SpawnSwiftKnives(player, degreeOfKnifeSpawns, offset)
	local dataPlayer = player:GetData()
	local anglePos = swiftBase:SpawnPos(player, degreeOfKnifeSpawns, offset)
	local tearKnife = player:FireTear(player.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero, false, false, false, player, 1)
	local knife = player:FireKnife(player)
	
	AssignSwiftFakeKnifeData(player, tearKnife, knife, anglePos)
	AssignSwiftKnifeData(knife, tearKnife, true)
	swiftBase:AddSwiftTrail(tearKnife)
	
	if dataPlayer.Swift.MultiShots > 0 then
	local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 1, dataPlayer.Swift.MultiShots + swiftSynergies:BookwormShot(player) do
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePos = swiftBase:SpawnPosMulti(player, degreeOfKnifeSpawns, offset, multiOffset, orbit, i)
			local tearKnifeMulti = player:FireTear(tearKnife.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero, false, false, false, player, 1)
			local knifeMulti = player:FireKnife(player)
			local dataMultiTear = tearKnifeMulti:GetData()
			
			dataMultiTear.MultiSwiftTear = tearKnife
			dataMultiTear.MultiSwiftOrbitDistance = orbit
			AssignSwiftFakeKnifeData(player, tearKnifeMulti, anglePos)
			AssignSwiftKnifeData(knifeMulti, tearKnifeMulti, true)
			knifeMulti:GetSprite().Scale = Vector(0.5,0.5)
		end
	end
end

function swiftKnife:SwiftKnifeUpdate(knife)
	if knife.Parent
	and knife.Parent.Type == EntityType.ENTITY_TEAR
	and knife.Parent:GetData().Swift
	and knife.Parent:GetData().Swift.IsSwiftWeapon
	then
	
		local tearKnife = knife.Parent
		local dataTearKnife = tearKnife:GetData()

		if dataTearKnife.Swift.IsSwiftWeapon then
		
			local fKC = tearKnife:GetSprite().Color
			knife.Color = Color(fKC.R, fKC.G, fKC.B, 1, fKC.RO, fKC.GO, fKC.BO)
		
			if dataTearKnife.HeightDuration and dataTearKnife.HeightDuration > 0 then
				if dataTearKnife.Swift.HoldTearHeight then
					tearKnife:ToTear().Height = dataTearKnife.Swift.HoldTearHeight
				end
				if dataTearKnife.Swift.HasFired then
					dataTearKnife.HeightDuration = dataTearKnife.HeightDuration - 1
				end
			end

			if not dataTearKnife.Swift.HasFired then
				knife.Rotation = dataTearKnife.Swift.ShotDir:GetAngleDegrees()
			else
				if dataTearKnife.Swift.AntiGravDir then
					knife.Rotation = dataTearKnife.Swift.AntiGravDir:GetAngleDegrees()
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
	end
end

return swiftKnife