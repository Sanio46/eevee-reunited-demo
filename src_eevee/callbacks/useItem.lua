local useItem = {}

local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]
local eeveeBirthright = EEVEEMOD.Src["items"]["collectibles.eeveeBirthright"]
local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]

function useItem:main(itemID, itemRNG, player, flags, slot, vardata)
	local useItemFunctions = {
		eeveeBasics:OnEsauJr(itemID, itemRNG, player, flags, slot, vardata),
		eeveeBasics:OnLarynxOrBerserk(itemID, itemRNG, player, flags, slot, vardata),
		costumeProtector:ResetCostumeOnItem(itemID, itemRNG, player, flags, slot, vardata),
		eeveeBirthright:OnUse(itemID, itemRNG, player, flags, slot, vardata)
	}
	
	for i = 1, #useItemFunctions do
		if useItemFunctions[i] ~= nil then return useItemFunctions end
	end
end

return useItem