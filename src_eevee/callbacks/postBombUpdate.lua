local postBombUpdate = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")

function postBombUpdate:main(bomb)
	swiftAttack:SwiftAttackUpdate(bomb)
end

function postBombUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, postBombUpdate.main)
end

return postBombUpdate
