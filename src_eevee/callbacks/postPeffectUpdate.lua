local postPeffectUpdate = {}

local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]
local customMrDolly = EEVEEMOD.Src["modsupport"]["customMrDolly"]
local eeveeBirthright = EEVEEMOD.Src["items"]["collectibles.eeveeBirthright"]
local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]
local itemEffectOnFire = EEVEEMOD.Src["player"]["itemEffectOnFire"]
local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]

function postPeffectUpdate:main(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()
	
	ccp:OnPeffectUpdate(player)
	customMrDolly:ReplaceDollyCostume(player)
	eeveeBirthright:GivePocketActive(player)
	eeveeBasics:GiveEsauJrEeveeData(player)
	eeveeBasics:TryDeinitEevee(player)
	itemEffectOnFire:FireTech05(player)
	swiftAttack:SwiftInit(player)

end

return postPeffectUpdate