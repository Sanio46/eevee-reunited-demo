local postTearUpdate = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]
local swiftTear = EEVEEMOD.Src["attacks"]["swift.swiftTear"]

function postTearUpdate:main(tear)
	swiftAttack:SwiftAttackUpdate(tear)
	swiftTear:MakeSwiftTear(tear)
end

return postTearUpdate