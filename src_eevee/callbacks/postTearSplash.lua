local postTearSplash = {}

local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")

---@param tear EntityTear
---@param splashType string
---@param collider Entity|nil
function postTearSplash:main(tear, splashType, collider)
	if splashType == "Wall" and tear:HasTearFlags(TearFlags.TEAR_SPECTRAL) then return end
	if splashType == "Collision" then
		if tear:HasTearFlags(TearFlags.TEAR_SPECTRAL) and collider ~= nil then
			if collider.Type == EntityType.ENTITY_FIREPLACE
			or collider.Type == EntityType.ENTITY_STONEY
			or collider.Type == EntityType.ENTITY_FAMILIAR
			or collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			then
				return
			end
		end
		if tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
			return
		end
	end
	wonderousLauncher:OnCoinDiscDestroy(tear)
	swiftTear:OnSwiftStarDestroy(tear, splashType)
end

function postTearSplash:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, postTearSplash.OnPostEntityRemove)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, postTearSplash.OnTearCollision)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, postTearSplash.OnTearUpdate)
end

--Hitting the floor
---@param tear EntityTear
function postTearSplash:OnPostEntityRemove(tear)
	if not tear:ToTear() or tear:ToTear().Height <= -5 then
		return
	end
	postTearSplash:main(tear:ToTear(), "Floor", nil)
end

--Hitting an enemy
---@param tear EntityTear
---@param collider Entity
function postTearSplash:OnTearCollision(tear, collider)
	if not collider:ToNPC() then return end
	postTearSplash:main(tear, "Collision", collider)
end

--Hitting a wall or grid entity
---@param tear EntityTear
function postTearSplash:OnTearUpdate(tear)
	if tear.Height > -5 then
		return
	end
	local data = tear:GetData()

	if not data.TearDeaded and tear:IsDead() then
		data.TearDeaded = true
		postTearSplash:main(tear, "Wall")
	end
end

return postTearSplash
