local postLaserInit = {}

local triggerOnFire = require("src_eevee.items.triggerOnFire")

function postLaserInit:main(laser)
	triggerOnFire:OnWeaponInit(laser)
end

function postLaserInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_LASER_INIT, postLaserInit.main)
end

return postLaserInit
