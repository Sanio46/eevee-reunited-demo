local vee = require("src_eevee.VeeHelper")
local swiftKnife = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftLaser = require("src_eevee.attacks.eevee.swiftLaser")
local rgbCycle = require("src_eevee.misc.rgbCycle")

---@param swiftData SwiftInstance
---@param tearKnife EntityTear
---@param isMult boolean
local function AssignSwiftFakeKnifeData(swiftData, tearKnife, isMult)
	local player = swiftData.Player
	if not player then return end
	if tearKnife.Height > -24 then tearKnife.Height = -24 end

	tearKnife:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_HOMING)
	swiftBase:InitSwiftWeapon(swiftData, tearKnife, isMult)
	tearKnife.Visible = false
	tearKnife.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	tearKnife.CollisionDamage = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
		swiftLaser:FireTechXLaser(swiftData, swiftBase.Weapons[tostring(GetPtrHash(tearKnife))], Vector.Zero)
	end
	--Knife never changes in size so the tear shouldn't either
	tearKnife:SetSize(1, Vector.One, 8)
end

---@param tearKnife EntityTear
---@param knife EntityKnife
---@param player EntityPlayer
local function BasicSwiftKnifeData(tearKnife, knife, player)
	local sprite = knife:GetSprite()
	local data = knife:GetData()

	sprite:Load("gfx/knife_swift.anm2", true)
	sprite:Play("Idle", true)
	knife:ClearTearFlags(TearFlags.TEAR_LUDOVICO)
	data.SwiftKnife = true
	sprite.Offset = Vector(0, -10)
	knife.Parent = tearKnife
	knife.Position = tearKnife.Position
	knife.CollisionDamage = player.Damage / 2
	--Invisible tear means invisible halo, but because of how this funcitons by making the tear do all the work and slapping a knife on it...
	--Removing the halo isn't an option, but there's still a halo, so this is to just create one that's visible
	if tearKnife:HasTearFlags(TearFlags.TEAR_GLOW) then
		local godheadEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.CUSTOM_TEAR_HALO, 0,
			knife.Position
			, Vector.Zero, tearKnife):ToEffect()
		godheadEffect.SpriteScale = Vector(0.5, 0.5)
		godheadEffect.SpriteOffset = Vector(0, -15)
	end
end

---@param swiftData SwiftInstance
---@param tearKnife EntityTear
---@param knife EntityKnife
local function AssignSwiftKnifeData(swiftData, tearKnife, knife)
	local player = swiftData.Player
	if not player then return end
	local fKC = tearKnife:GetSprite().Color

	BasicSwiftKnifeData(tearKnife, knife, player)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		knife.Color = vee.PlaydoughRandomColor()
		knife:SetColor(vee.SetColorAlpha(knife.Color, 0), 15, 1, true, false)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CONTINUUM) then
		rgbCycle:applyColorCycle(knife, EEVEEMOD.ColorCycle.CONTINUUM)
	else
		knife:SetColor(vee.SetColorAlpha(fKC, 0), 15, 1, true, false)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
		local data = knife:GetData()
		local timeTillBrim = 60
		data.SwiftKnifeBrim_Delay = timeTillBrim
	end
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
function swiftKnife:FireSwiftKnife(swiftData, swiftWeapon, direction)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local tearKnife = player:FireTear(swiftWeapon.WeaponEntity.Position, direction, false, false, false, player)
	local knife = player:FireKnife(player, direction:GetAngleDegrees())

	tearKnife:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	tearKnife:ClearTearFlags(TearFlags.TEAR_ORBIT)
	swiftBase:AddSwiftTrail(tearKnife, player)
	swiftBase:PlaySwiftFireSFX(tearKnife)
	BasicSwiftKnifeData(tearKnife, knife, player)
	tearKnife:SetColor(vee.SetColorAlpha(tearKnife.Color, 0), -1, 1, false, false)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
		knife.Color = vee.PlaydoughRandomColor()
	else
		local fKC = tearKnife:GetSprite().Color
		knife:SetColor(vee.SetColorAlpha(fKC, 1), -1, 1, false, false)
	end
end

---@param swiftData SwiftInstance
---@param isMult boolean
function swiftKnife:SpawnSwiftKnives(swiftData, isMult)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local spawnPos = swiftBase:GetAdjustedStartingAngle(swiftData)
	local tearKnife = player:FireTear(swiftData.Parent.Position + spawnPos, Vector.Zero, false, false, false, player)
	local knife = player:FireKnife(player)

	AssignSwiftFakeKnifeData(swiftData, tearKnife, isMult)
	AssignSwiftKnifeData(swiftData, tearKnife, knife)
end

---@param knife EntityKnife
function swiftKnife:SwiftKnifeUpdate(knife)
	local tearKnife = knife.Parent
	if not knife.Parent then return end
	tearKnife = tearKnife:ToTear()
	local player = knife.SpawnerEntity:ToPlayer()
	if not player or not tearKnife then return end
	local swiftWeapon = swiftBase.Weapons[tostring(GetPtrHash(tearKnife))]
	if not swiftWeapon then return end
	local data = knife:GetData()

	if not swiftWeapon.HasFired and not player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
		knife.Rotation = swiftWeapon.ShootDirection:GetAngleDegrees()
	else
		if data.SwiftKnifeBrim_KeepDirectionDuration then
			if data.SwiftKnifeBrim_KeepDirectionDuration > 0 then
				data.SwiftKnifeBrim_KeepDirectionDuration = data.SwiftKnifeBrim_KeepDirectionDuration - 1
			else
				data.SwiftKnifeBrim_KeepDirectionDuration = nil
			end
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
	elseif not data.EeveeEntHasColorCycle then
		local fKC = tearKnife:GetSprite().Color
		tearKnife:SetColor(vee.SetColorAlpha(fKC, 0), -1, 1, false, false)
	end

	if swiftWeapon.HasFired and data.SwiftKnifeBrim_Delay then
		if not data.SwiftKnifeBrim_OriginalColor then
			local fKC = tearKnife:GetSprite().Color
			data.SwiftKnifeBrim_OriginalColor = fKC
			knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 1, 0.7, 0, 0), -1, 1, false, false)
			knife:SetColor(data.SwiftKnifeBrim_OriginalColor, 60, 1, true, false)
		end
		if data.SwiftKnifeBrim_Delay > 0 then
			data.SwiftKnifeBrim_Delay = data.SwiftKnifeBrim_Delay - 1
			tearKnife.FallingSpeed = -0.1
			tearKnife.FallingAcceleration = 0
			if tearKnife.Velocity:Length() >= 1 then
				tearKnife:AddVelocity(swiftWeapon.ShootDirection:Resized(-0.15))
			end
		elseif not data.SwiftKnifeBrim_FiredBrim then
			data.SwiftKnifeBrim_FiredBrim = true
			data.SwiftKnifeBrim_KeepDirectionDuration = 20
			swiftWeapon.ShootDirection = tearKnife.Velocity:Normalized()
			swiftLaser:FireBrimLaser(swiftWeapon.ParentInstance, swiftWeapon, swiftWeapon.ShootDirection)
			tearKnife:AddVelocity(swiftWeapon.ShootDirection:Resized(player.ShotSpeed * -22.5))
			knife:SetColor(data.SwiftKnifeBrim_OriginalColor, -1, 1, false, false)
			local fKC = tearKnife:GetSprite().Color
			knife:SetColor(Color(fKC.R, fKC.G, fKC.B, 1, 0.7, 0, 0), 15, 1, true, false)
			tearKnife.FallingSpeed = swiftWeapon.Special.StartingFall
			tearKnife.FallingAcceleration = swiftWeapon.Special.StartingAccel
		end
	end
end

---@param effect EntityEffect
function swiftKnife:godheadAuraRenderUpdate(effect)
	if not effect.SpawnerEntity then
		effect:Remove()
	else
		effect.Position = effect.SpawnerEntity.Position
	end
end

return swiftKnife
