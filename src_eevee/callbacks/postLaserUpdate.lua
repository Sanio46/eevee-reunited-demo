local postLaserUpdate = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]
local itemEffectOnFire = EEVEEMOD.Src["player"]["itemEffectOnFire"]

function postLaserUpdate:main(laser)
	swiftAttack:SwiftAttackUpdate(laser)
	itemEffectOnFire:Tech05StayOnPlayer(laser)
end

return postLaserUpdate