local postKnifeInit = {}

local customSpiritSword = require("src_eevee.modsupport.customSpiritSword")
local triggerOnFire = require("src_eevee.items.triggerOnFire")

function postKnifeInit:main(knife)
	customSpiritSword:ReplaceSpiritSwordOnInit(knife)
	triggerOnFire:OnWeaponInit(knife)
end

function postKnifeInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, postKnifeInit.main)
end

return postKnifeInit
