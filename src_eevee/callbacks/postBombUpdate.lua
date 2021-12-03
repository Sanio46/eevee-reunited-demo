local postBombUpdate = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postBombUpdate:main(bomb)
	swiftAttack:SwiftAttackUpdate(bomb)
end

return postBombUpdate