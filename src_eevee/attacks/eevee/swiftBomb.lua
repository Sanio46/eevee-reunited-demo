local swiftBomb = {}

--[[ local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local swiftSynergies = require("src_eevee.attacks.eevee.swiftSynergies")

local function AssignSwiftBombData(player, bomb, anglePos)
	swiftBase:AssignSwiftBasicData(bomb, player, anglePos)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]

	local bC = bomb:GetSprite().Color
	bomb:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
	bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	bomb:SetColor(Color(bC.R, bC.G, bC.B, 0, bC.RO, bC.GO, bC.BO), 15, 1, true, false)
end

function swiftBomb:FireSwiftBomb(bombParent, player, direction)

end

function swiftBomb:SpawnSwiftBombs(player, degreeOfBombSpawns, offset)
	local ptrHashPlayer = tostring(GetPtrHash(player))
	local swiftPlayer = swiftBase.Player[ptrHashPlayer]
	local anglePos = swiftBase:SpawnPos(player, degreeOfBombSpawns, offset)
	local bomb = player:FireBomb((player.Position - player.TearsOffset) + (anglePos:Rotated(swiftPlayer.RateOfOrbitRotation)), Vector.Zero, player)

	AssignSwiftBombData(player, bomb, anglePos)
end

function swiftBomb:SwiftBombUpdate(swiftData, swiftWeapon, bomb)
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
end ]]

return swiftBomb
