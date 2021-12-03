local postPlayerRender = {}

local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]
local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]

function postPlayerRender:main(player)
	costumeProtector:RestoreCostumeInMineshaft(player)
	eeveeBasics:PlayHurtSFX(player)
end

return postPlayerRender