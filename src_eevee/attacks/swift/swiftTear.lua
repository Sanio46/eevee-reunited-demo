local swiftTear = {}
local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]

local function AssignSwiftSprite(tear)
local tearSprite = tear:GetSprite()
local animationToPlay = "RegularTear6"
local anm2ToUse = "gfx/tear_swift.anm2"
	for i = 1,13 do
		if tearSprite:IsPlaying("RegularTear" .. tostring(i)) then
			animationToPlay = "RegularTear" .. tostring(i)
		elseif tearSprite:IsPlaying("BloodTear" .. tostring(i)) then
			animationToPlay = "BloodTear" .. tostring(i)
			anm2ToUse = "gfx/tear_swift_blood.anm2"
		end
	end
	tearSprite:Load(anm2ToUse, true) --Load in the animation file
	tearSprite:Play(animationToPlay, true) --Play the animation assigned by code above
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
	local tear = player:FireTear(tearParent.Position, direction):ToTear()
	local tC = tear:GetSprite().Color
	local pC = tearParent:GetSprite().Color
	local dataTear = tear:GetData()
	dataTear.Swift = {}
	dataTear.Swift.IsSwiftWeapon = true
	dataTear.Swift.HasFired = true
	AssignSwiftSprite(tear)
	swiftBase:AddSwiftTrail(tear, player)
	swiftBase:SwiftTearFlags(tear, true, true)
	tear:SetColor(Color(pC.R, pC.G, pC.B, 1, pC.RO, pC.GO, pC.BO), -1, 1, true, false)
	if tearParent.FrameCount < 15 then
		local invisTime = tearParent.FrameCount
		tear:SetColor(Color(pC.R, pC.G, pC.B, 0, pC.RO, pC.GO, pC.BO), 15 - invisTime, 1, true, false)
	end
end

function swiftTear:SpawnSwiftTears(player, degreeOfTearSpawns, offset)
	local dataPlayer = player:GetData()
	local anglePos = Vector.FromAngle((degreeOfTearSpawns * dataPlayer.Swift.NumWeaponsSpawned)):Resized(swiftBase:SwiftTearDistanceFromPlayer(player)):Rotated(offset)
	local tear = player:FireTear(player.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero):ToTear()
	
	AssignSwiftTearData(player, tear, anglePos)
	AssignSwiftSprite(tear)
	swiftBase:AddSwiftTrail(tear, player)
	
	if dataPlayer.Swift.MultiShots > 0 then
	local multiOffset = EEVEEMOD.RandomNum(360)
		for i = 1, dataPlayer.Swift.MultiShots do
			local degrees = 360/dataPlayer.Swift.MultiShots
			local orbit = swiftBase:MultiSwiftTearDistanceFromTear(player)
			local anglePos = Vector.FromAngle(((degrees * i) * dataPlayer.Swift.NumWeaponsSpawned)):Resized(orbit):Rotated(multiOffset)
			local tearMulti = player:FireTear(tear.Position + (anglePos:Rotated(dataPlayer.Swift.RateOfOrbitRotation)), Vector.Zero):ToTear()
			local dataMultiTear = tearMulti:GetData()
			
			dataMultiTear.MultiSwiftTear = tear
			dataMultiTear.MultiSwiftOrbitDistance = orbit
			AssignSwiftTearData(player, tearMulti, anglePos)
			AssignSwiftSprite(tear)
			tearMulti:SetSize(tear.Size/2, Vector(0.5, 0.5), 8)
		end
	end
end

local function ShouldGiveFamiliarSwiftTear(tear)
	if tear.SpawnerType == EntityType.ENTITY_FAMILIAR then
		if tear.SpawnerVariant == FamiliarVariant.INCUBUS 
		or tear.SpawnerVariant == FamiliarVariant.TWISTED_BABY
		or tear.SpawnerVariant == FamiliarVariant.MINISAAC then
			return true
		end
	end
	return false
end

local SwiftTearVariantBlacklist = {
	[TearVariant.BOBS_HEAD] = true,
	[TearVariant.CHAOS_CARD] = true,
	[TearVariant.ICE] = true,
	[TearVariant.KEY] = true,
	[TearVariant.KEY_BLOOD] = true,
	[TearVariant.FIRE] = true,
}

function swiftTear:OnTearInit(tear)
	local dataTear = tear:GetData()

	if tear.SpawnerType == EntityType.ENTITY_PLAYER 
	or ShouldGiveFamiliarSwiftTear(tear)
	then
		local player = tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar().Player
		local dataPlayer = player:GetData()
		
		if dataPlayer.Swift 
		and not dataTear.Swift
		and SwiftTearVariantBlacklist[tear.Variant] ~= true then
			dataTear.Swift = {}
			dataTear.Swift.IsSwiftWeapon = true
			dataTear.Swift.HasFired = true
			AssignSwiftSprite(tear)
		end
	end
end

function swiftTear:SwiftTearUpdate(tear)
	
	if tear.SpawnerType == EntityType.ENTITY_PLAYER 
	or ShouldGiveFamiliarSwiftTear(tear)
	then

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

return swiftTear