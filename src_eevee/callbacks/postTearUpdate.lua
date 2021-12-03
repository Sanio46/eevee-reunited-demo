local postTearUpdate = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postTearUpdate:main(tear)
	swiftAttack:SwiftAttackUpdate(tear)
end

return postTearUpdate