local postEffectInit = {}

local triggerOnFire = require("src_eevee.items.triggerOnFire")

---@param effect EntityEffect
function postEffectInit:main(effect)

end

function postEffectInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, triggerOnFire.OnWeaponInit, EffectVariant.TARGET)
end

return postEffectInit
