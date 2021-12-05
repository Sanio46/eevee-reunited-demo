local playerInit = {}

local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]
local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]

function playerInit:main(player)
	eeveeBasics:OnPlayerInit(player)
	ccp:OnPlayerInit(player)
end

return playerInit