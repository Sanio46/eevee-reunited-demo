local postLaserUpdate = {}

local swiftLaser= require("src_eevee.attacks.eevee.swiftLaser")
local triggerOnFire = require("src_eevee.items.triggerOnFire")

---@param laser EntityLaser
function postLaserUpdate:main(laser)
	swiftLaser:SwiftLaserUpdate(laser)
	triggerOnFire:OnLaserUpdate(laser)
	triggerOnFire:Tech05StayOnPlayer(laser)
end

function postLaserUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, postLaserUpdate.main)
end

return postLaserUpdate
