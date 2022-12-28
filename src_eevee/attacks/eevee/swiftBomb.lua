local swiftBomb = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param direction Vector
function swiftBomb:FireSwiftBomb(swiftData, swiftWeapon, direction)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local bomb = player:FireBomb(swiftWeapon.WeaponEntity.Position, direction, player)

	bomb:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	swiftBase:AddSwiftTrail(bomb, swiftData.Player)
	swiftBase:PlaySwiftFireSFX(bomb)
	bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
end

---@param swiftData SwiftInstance
---@param isMult boolean
function swiftBomb:SpawnSwiftBomb(swiftData, isMult)
	local player = swiftData.Player
	if not player then return end
	local parent = swiftData.Parent
	if not parent then return end
	local spawnPos = swiftBase:GetAdjustedStartingAngle(swiftData)
	local bomb = player:FireBomb(swiftData.Parent.Position + spawnPos, Vector.Zero, player)
	if bomb.Variant == BombVariant.BOMB_ROCKET or bomb.Variant == BombVariant.BOMB_ROCKET_GIGA then
		bomb.Visible = false
	end
	bomb:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	swiftBase:InitSwiftWeapon(swiftData, bomb, isMult)
end

---@param swiftData SwiftInstance
---@param swiftWeapon SwiftWeapon
---@param bomb EntityBomb
function swiftBomb:SwiftBombUpdate(swiftData, swiftWeapon, bomb)
	local player = swiftData.Player
	if not player then return end

	if bomb.Visible == false then
		bomb.Visible = true
	end
	
	if not swiftWeapon.HasFired then
		bomb:SetExplosionCountdown(35)
		bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		if bomb.Variant == BombVariant.BOMB_ROCKET or bomb.Variant == BombVariant.BOMB_ROCKET_GIGA then
			local sprite = bomb:GetSprite()
			sprite.Rotation = swiftWeapon.ShootDirection:GetAngleDegrees()
		end
	elseif bomb.Variant == BombVariant.BOMB_ROCKET or bomb.Variant == BombVariant.BOMB_ROCKET_GIGA then
		bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		local room = EEVEEMOD.game:GetRoom()
		if not room:IsPositionInRoom(bomb.Position, -150) then
			bomb:Remove()
		end
	end
end

return swiftBomb
