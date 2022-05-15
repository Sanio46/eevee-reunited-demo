local usePill = {}

local ccp = require("src_eevee.player.characterCostumeProtector")

function usePill:main(pillID, player)
	ccp:ResetCostumeOnPill(pillID, player)
end

function usePill:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_PILL, usePill.main)
end

return usePill
