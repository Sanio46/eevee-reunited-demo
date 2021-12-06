local useItem = {}

local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]
local eeveeBirthright = EEVEEMOD.Src["items"]["collectibles.eeveeBirthright"]
local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]
local eeveeSFX = EEVEEMOD.Src["player"]["eeveeSFX"]

function useItem:main(itemID, itemRNG, player, flags, slot, vardata)
	local useItemFunctions = {
		eeveeBasics:OnEsauJr(itemID, itemRNG, player, flags, slot, vardata),
		eeveeSFX:OnLarynxOrBerserk(itemID, itemRNG, player, flags, slot, vardata),
		ccp:ResetCostumeOnItem(itemID, itemRNG, player, flags, slot, vardata),
		eeveeBirthright:OnUse(itemID, itemRNG, player, flags, slot, vardata)
	}
	
	for i = 1, #useItemFunctions do
		if useItemFunctions[i] ~= nil then return useItemFunctions end
	end
end

return useItem