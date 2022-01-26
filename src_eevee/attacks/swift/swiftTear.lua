local swiftTear = {}

local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]
local swiftSynergies = EEVEEMOD.Src["attacks"]["swift.swiftSynergies"]

local SwiftTearVariantBlacklist = {
	[TearVariant.BOBS_HEAD] = true,
	[TearVariant.CHAOS_CARD] = true,
	[TearVariant.COIN] = true,
	[TearVariant.BELIAL] = true,
	[TearVariant.ICE] = true,
	[TearVariant.ROCK] = true,
	[TearVariant.KEY] = true,
	[TearVariant.KEY_BLOOD] = true,
	[TearVariant.FIRE] = true,
}

local BloodTearFlags = {
	[TearVariant.EYE] = true,
	[TearVariant.BALLOON] = true,
	[TearVariant.BALLOON_BRIMSTONE] = true,
}

local function AssignSwiftSprite(tear)

	if SwiftTearVariantBlacklist[tear.Variant] then
		return
	end
	
	local maxSizes = 13
	local tearSprite = tear:GetSprite()
	local dataTear = tear:GetData()
	local animationToPlay = tearSprite:GetAnimation()
	local anm2ToUse = "gfx/tear_swift.anm2"
	local x, isBlood = string.gsub(animationToPlay, "BloodTear", "")
	
	for i = 1, maxSizes do
		local foundNum = string.find(animationToPlay, tostring(i))

		if foundNum ~= nil and foundNum == i then
			animationToPlay = i
			break
		end
		if i == maxSizes and foundNum == nil then
			animationToPlay = 6
		end
	end

	if (dataTear.ForceBlood and dataTear.ForceBlood == true)
	or (isBlood ~= 0 
	and (
	dataTear.ForceBlood == nil or 
	dataTear.ForceBlood ~= false
	))
	or BloodTearFlags[tear.Variant]
	then
		animationToPlay = "BloodTear"..animationToPlay
		anm2ToUse = "gfx/tear_swift_blood.anm2"
	else
		animationToPlay = "RegularTear"..animationToPlay
	end
	
	tearSprite:Load(anm2ToUse, true)
	tearSprite:Play(animationToPlay, true)
end

local function AssignSwiftTearData(player, tear, anglePos)
	local dataPlayer = player:GetData()
	local dataTear = tear:GetData()
	local tC = tear:GetSprite().Color
	
	swiftBase:SwiftTearFlags(tear, false, false)
	swiftBase:AssignSwiftBasicData(tear, player, anglePos)
	if dataPlayer.Swift.Constant then
		swiftBase:SwiftTearFlags(tear, true, false)
	end
	tear:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), 15, 1, true, false)
end

function swiftTear:FireSwiftTear(tearParent, player, direction)
	local tear = player:FireTear((tearParent.Position - player.TearsOffset), direction, true, false, true, player):ToTear()
	local tC = tear:GetSprite().Color
	local pC = tearParent:GetSprite().Color
	local dataTear = tear:GetData()
	dataTear.Swift = {}
	dataTear.Swift.IsSwiftWeapon = true
	dataTear.Swift.HasFired = true
	swiftSynergies:EyeItemDamageChance(player, tear)
	AssignSwiftSprite(tear)
	swiftBase:AddSwiftTrail(tear, player)
	swiftBase:SwiftTearFlags(tear, true, true)
	tear:SetColor(Color(pC.R, pC.G, pC.B, 1, pC.RO, pC.GO, pC.BO), -1, 1, true, false)
	if tearParent.FrameCount < 15 then
		local invisTime = tearParent.FrameCount
		tear:SetColor(Color(pC.R, pC.G, pC.B, 0, pC.RO, pC.GO, pC.BO), 15 - invisTime, 1, true, false)
	end
	swiftBase:AssignSwiftSounds(tear)
end

function swiftTear:SpawnSwiftTears(player, degreeOfTearSpawns, offset)
	local dataPlayer = player:GetData()
	local anglePos = swiftBase:SpawnPos(player, degreeOfTearSpawns, offset)
	local tear = player:FireTear((player.Position - player.TearsOffset) + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero, true, false, true, player):ToTear()

	swiftSynergies:EyeItemDamageChance(player, tear)
	AssignSwiftTearData(player, tear, anglePos)
	AssignSwiftSprite(tear)
	swiftBase:AddSwiftTrail(tear, player)

	if dataPlayer.Swift.MultiShots > 0 then
	local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 0, dataPlayer.Swift.MultiShots + swiftSynergies:BookwormShot(player) do
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePos = swiftBase:SpawnPosMulti(player, degreeOfTearSpawns, offset, multiOffset, orbit, i)
			local tearMulti = player:FireTear((tear.Position - player.TearsOffset) + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero, true, false, true, player):ToTear()
			local dataMultiTear = tearMulti:GetData()
			
			dataMultiTear.MultiSwiftTear = tear
			dataMultiTear.MultiSwiftOrbitDistance = orbit
			swiftSynergies:EyeItemDamageChance(player, tearMulti)
			AssignSwiftTearData(player, tearMulti, anglePos)
			AssignSwiftSprite(tearMulti)
			tearMulti:SetSize(tear.Size/2, Vector(0.5, 0.5), 8)
		end
	end
	swiftBase:AssignSwiftSounds(tear)
end

function swiftTear:MakeSwiftTear(tear)
	local dataTear = tear:GetData()

	if tear.SpawnerType == EntityType.ENTITY_PLAYER 
	and tear.SpawnerEntity
	then
		local player = tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar().Player
		local dataPlayer = player:GetData()
		
		if dataPlayer.Swift 
		and not dataTear.Swift
		and not SwiftTearVariantBlacklist[tear.Variant]
		and tear.FrameCount > 0 then
			dataTear.Swift = {}
			dataTear.Swift.IsSwiftWeapon = true
			dataTear.Swift.HasFired = true
			AssignSwiftSprite(tear)
			local c = tear:GetSprite().Color
			if c.A ~= 1 then
				tear.Color = Color(c.R, c.G, c.B, 1, c.RO, c.GO, c.BO)
			end
		end
	end
end

function swiftTear:SwiftTearUpdate(tear)
	
	if tear.SpawnerType == EntityType.ENTITY_PLAYER then

		local player = tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar().Player
		local dataPlayer = player:GetData()
		local dataTear = tear:GetData()
		
		if dataPlayer.Swift 
		and dataTear.Swift
		and dataTear.Swift.IsSwiftWeapon then
		
			if not dataTear.Swift.HasFired then
				if dataTear.Swift.HoldTearHeight then
					tear.Height = dataTear.Swift.HoldTearHeight
				end
			end
			
			if tear.StickTarget then return end
			
			if tear.Variant == TearVariant.ICE or tear.Variant == TearVariant.COIN then
				local sprite = tear:GetSprite()
				if not dataTear.Swift.HasFired then
					sprite.Rotation = dataTear.Swift.ShotDir:GetAngleDegrees()
				else
					if dataTear.Swift.AntiGravDir then
						sprite.Rotation = dataTear.Swift.AntiGravDir:GetAngleDegrees()
					end
				end
			else
				if not dataTear.Swift.HasFired then
					tear:GetSprite().Rotation = (dataPlayer.Swift.RateOfOrbitRotation * -2)
				else
					if not dataTear.Swift.AfterFireRotation then 
						dataTear.Swift.AfterFireRotation = tear:GetSprite().Rotation
					else
						tear:GetSprite().Rotation = dataTear.Swift.AfterFireRotation
						dataTear.Swift.AfterFireRotation = dataTear.Swift.AfterFireRotation - 20
					end
				end
			end
		end
	end
end

return swiftTear