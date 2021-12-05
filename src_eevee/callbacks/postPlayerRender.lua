local postPlayerRender = {}

local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]
local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]
local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postPlayerRender:main(player)
	ccp:RestoreCostumeInMineshaft(player)
	eeveeBasics:PlayHurtSFX(player)
	swiftAttack:SwiftAttackTimers(player)
end

return postPlayerRender