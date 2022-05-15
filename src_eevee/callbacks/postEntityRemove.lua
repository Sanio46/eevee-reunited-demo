local postEntityRemove = {}

local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")

function postEntityRemove:OnTearDeath(tear)
	wonderousLauncher:OnPoopDiscDestroy(tear)
end

function postEntityRemove:OnFamiliarDeath(familiar)
	wonderousLauncher:RemoveDeadLauncherWisps(familiar)
end

function postEntityRemove:main(ent)
	if ent:ToTear() then
		local tear = ent:ToTear()
		postEntityRemove:OnTearDeath(tear)
	end
	if ent:ToFamiliar() then
		local familiar = ent:ToFamiliar()
		postEntityRemove:OnFamiliarDeath(familiar)
	end
end

function postEntityRemove:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, postEntityRemove.main)
end

return postEntityRemove
