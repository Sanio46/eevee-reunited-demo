local postEffectRender = {}

local eeveeBirthright = require("src_eevee.attacks.eevee.birthright_tailwhip")
local eeveeGhost = require("src_eevee.player.eeveeGhost")
local swiftKnife = require("src_eevee.attacks.eevee.swiftKnife")

function postEffectRender:main(effect)

end

function postEffectRender:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postEffectRender.main)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, eeveeGhost.eeveeGhostRenderUpdate,
		EEVEEMOD.EffectVariant.EEVEE_GHOST)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, eeveeBirthright.onEffectRender,
		EEVEEMOD.EffectVariant.TAIL_WHIP)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, swiftKnife.godheadAuraRenderUpdate,
		EEVEEMOD.EffectVariant.CUSTOM_TEAR_HALO)
end

return postEffectRender
