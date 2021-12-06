local postEffectInit = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postEffectInit:main(effect)
	if effect.Variant == EffectVariant.EVIL_EYE then
		--swiftAttack:InitSwiftEvilEye(effect)
	end
end

return postEffectInit
