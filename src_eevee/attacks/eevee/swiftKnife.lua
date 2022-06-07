local swiftKnife = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")
local swiftLaser = require("src_eevee.attacks.eevee.swiftLaser")

---@param swiftData SwiftInstance
---@param tearKnife EntityTear
---@param knife EntityKnife
local function AssignSwiftFakeKnifeData(swiftData, tearKnife, knife)
	local player = swiftData.Player
	local tC = tearKnife:GetSprite().Color
	if tearKnife.Height > -24 then tearKnife.Height = -24 end

	tearKnife:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_HOMING)
	swiftBase:InitSwiftWeapon(swiftData, tearKnife)
	tearKnife:SetColor(Color(tC.R, tC.G, tC.B, 0, tC.RO, tC.GO, tC.BO), -1, 1, false, false)
	tearKnife.Child = knife
	tearKnife.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	tearKnife.CollisionDamage = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
		swiftLaser:FireTechXLaser(tearKnife, player, Vector.Zero, true)
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param tearKnife EntityTear
---@param knife EntityKnife
local function AssignSwiftKnifeData(swiftData, swiftWeapon, tearKnife, knife)
	local player = swiftData.Player
	local sprite = knife:GetSprite()
	local fKC = tearKnife:GetSprite().Color

	sprite:Load("gfx/knife_swift.anm2", true)
	sprite:Play("Idle", true)
	sprite.Offset = Vector(0, -4)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		knife.Color = swiftBase:PlaydoughRandomColor()
	else
		knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 0, fKC.RO, fKC.GO, fKC.BO), 15, 1, true, false)
	end
	knife.Parent = tearKnife
	knife.Position = tearKnife.Position
	knife.Rotation = swiftWeapon.ShootDirection:GetAngleDegrees()
	knife.CollisionDamage = player.Damage / 2
end

function swiftKnife:FireSwiftKnife(knifeParent, player, direction)

end

---@param swiftData SwiftInstance
function swiftKnife:SpawnSwiftKnives(swiftData)
	local player = swiftData.Player
	local parent = swiftData.Parent
	local spawnPos = swiftBase:GetAdjustedStartingAngle(swiftData)
	local tearKnife = player:FireTear(swiftData.Parent.Position + spawnPos, Vector.Zero, false, false, false, parent)
	local knife = player:FireKnife(player)
	local swiftWeapon = swiftBase:InitSwiftWeapon(swiftData, tearKnife)

	AssignSwiftFakeKnifeData(swiftData, tearKnife, knife)
	AssignSwiftKnifeData(swiftData, swiftWeapon, tearKnife, knife)
end

---@param swiftWeapon SwiftWeapon
---@param knife EntityKnife
function swiftKnife:SwiftKnifeUpdate(swiftWeapon, knife)
	local tearKnife = knife.Parent

	if not swiftWeapon.HasFired then
		knife.Rotation = swiftWeapon.ShootDirection:GetAngleDegrees()
	else
		knife.Rotation = tearKnife.Velocity:GetAngleDegrees()
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
