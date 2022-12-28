local postKnifeUpdate = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local swiftKnife = require("src_eevee.attacks.eevee.swiftKnife")
local triggerOnFire = require("src_eevee.items.triggerOnFire")

---@param knife EntityKnife
function postKnifeUpdate:main(knife)
	swiftKnife:SwiftKnifeUpdate(knife)
	swiftAttack:SpiritSwordInit(knife)
	swiftAttack:InitLudoTearOrKnifeOnUpdate(knife)
	triggerOnFire:OnKnifeUpdate(knife)
end

function postKnifeUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, postKnifeUpdate.main)
end

return postKnifeUpdate
