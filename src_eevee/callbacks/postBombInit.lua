local postBombInit = {}

local triggerOnFire = require("src_eevee.items.triggerOnFire")

function postBombInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, triggerOnFire.OnWeaponInit)
end

return postBombInit
