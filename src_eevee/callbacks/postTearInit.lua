local postTearInit = {}
local swiftTear = require("src_eevee.attacks.eevee.swiftTear")

---@param tear EntityTear
function postTearInit:main(tear)	
	swiftTear:MakeStarOnTearInit(tear)
end

function postTearInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, postTearInit.main)
end

return postTearInit
