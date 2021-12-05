local usePill = {}

local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]

function usePill:main(pillID, player)
	ccp:ResetCostumeOnPill(pillID, player)
end

return usePill