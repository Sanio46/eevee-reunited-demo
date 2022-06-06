local postFireTear = {}

local triggerOnFire = require("src_eevee.items.triggerOnFire")

---@param tear EntityTear
function postFireTear:main(tear)
	triggerOnFire:OnWeaponInit(tear)
end

function postFireTear:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, postFireTear.main)
end

return postFireTear
