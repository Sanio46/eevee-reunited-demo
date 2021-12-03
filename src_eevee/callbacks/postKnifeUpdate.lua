local postKnifeUpdate = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postKnifeUpdate:main(knife)
	swiftAttack:SwiftAttackUpdate(knife)
end

return postKnifeUpdate