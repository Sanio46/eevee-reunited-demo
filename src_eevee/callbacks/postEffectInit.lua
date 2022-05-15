local postEffectInit = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local triggerOnFire = require("src_eevee.items.triggerOnFire")

function postEffectInit:main(effect)
	
end

function postEffectInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, swiftAttack.InitSwiftEvilEye, EffectVariant.EVIL_EYE)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, triggerOnFire.OnWeaponInit, EffectVariant.TARGET)
end

return postEffectInit
