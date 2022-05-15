local postTearUpdate = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")
local ember = require("src_eevee.attacks.flareon.ember")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")

function postTearUpdate:main(tear)
	swiftAttack:SwiftAttackUpdate(tear)
	swiftAttack:SwiftLudovicoSpawn(tear)
	swiftAttack:OnSwiftLudoUpdate(tear)
	swiftTear:MakeSwiftTear(tear)
	swiftTear:RemoveSpiritProjectile(tear)
	ember:CreateEmberTrail(tear)
	wonderousLauncher:OnPoopDiscUpdate(tear)
end

function postTearUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, postTearUpdate.main)
end

return postTearUpdate
