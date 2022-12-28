local postBombInit = {}

local triggerOnFire = require("src_eevee.items.triggerOnFire")

---@param bomb EntityBomb
function postBombInit:main(bomb)
	triggerOnFire:OnWeaponInit(bomb)
end

function postBombInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, postBombInit.main)
end

return postBombInit
