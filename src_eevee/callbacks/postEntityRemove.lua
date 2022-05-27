local postEntityRemove = {}

local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")

---@param tear EntityTear
function postEntityRemove:OnTearDeath(tear)
	wonderousLauncher:OnPoopDiscDestroy(tear)
end

---@param familiar EntityFamiliar
function postEntityRemove:OnFamiliarDeath(familiar)
	wonderousLauncher:RemoveDeadLauncherWisps(familiar)
end

function postEntityRemove:main(ent)
	swiftBase:RemoveWeaponOnPostEntRemove(ent)
	if ent:ToTear() then
		---@type EntityTear
		local tear = ent:ToTear()
		postEntityRemove:OnTearDeath(tear)
	elseif ent:ToFamiliar() then
		---@type EntityFamiliar
		local familiar = ent:ToFamiliar()
		postEntityRemove:OnFamiliarDeath(familiar)
	end
end

function postEntityRemove:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, postEntityRemove.main)
end

return postEntityRemove
