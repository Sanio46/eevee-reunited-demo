local postTearInit = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")
local ember = require("src_eevee.attacks.flareon.ember")
local customTearVariants = require("src_eevee.misc.customTearVariants")

function postTearInit:main(tear)
	swiftTear:MakeSwiftTear(tear)
	ember:EmberTearInit(tear)
end

function postTearInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, postTearInit.main)
end

return postTearInit
