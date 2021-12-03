local playerInit = {}

local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]
local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]

function playerInit:main(player)
	eeveeBasics:OnPlayerInit(player)
	costumeProtector:OnPlayerInit(player)
end

return playerInit