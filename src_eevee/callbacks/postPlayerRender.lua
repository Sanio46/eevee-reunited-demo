local postPlayerRender = {}

local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]
local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]
local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postPlayerRender:main(player)
	costumeProtector:RestoreCostumeInMineshaft(player)
	eeveeBasics:PlayHurtSFX(player)
	swiftAttack:SwiftAttackTimers(player)
end

return postPlayerRender