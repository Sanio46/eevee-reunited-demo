local postPlayerRender = {}

local eeveeSFX = EEVEEMOD.Src["player"]["eeveeSFX"]
local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]
local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postPlayerRender:main(player)
	ccp:RestoreCostumeInMineshaft(player)
	eeveeSFX:PlayHurtSFX(player)
	swiftAttack:SwiftAttackTimers(player)
end

return postPlayerRender