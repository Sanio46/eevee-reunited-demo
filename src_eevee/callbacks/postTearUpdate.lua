local postTearUpdate = {}

local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")
local ember = require("src_eevee.attacks.flareon.ember")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local customTearVariants = require("src_eevee.misc.customTearVariants")

---@param tear EntityTear
function postTearUpdate:main(tear)
	swiftAttack:SwiftAttackUpdate(tear)
	swiftTear:SPEEEN(tear)
	swiftTear:RemoveSpiritProjectile(tear)
	--ember:CreateEmberTrail(tear)
	wonderousLauncher:OnPoopDiscUpdate(tear)
	customTearVariants:OnCustomTearUpdate(tear)
end

function postTearUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, postTearUpdate.main)
end

return postTearUpdate
