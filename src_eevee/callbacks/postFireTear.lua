local postFireTear = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local triggerOnFire = require("src_eevee.items.triggerOnFire")

function postFireTear:main(tear)
	swiftAttack:ActivateConstantOnKidneyStone(tear)
	triggerOnFire:OnWeaponInit(tear)
end

function postFireTear:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, postFireTear.main)
end

return postFireTear
