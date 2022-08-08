local preUseItem = {}

local triggerOnFire = require("src_eevee.items.triggerOnFire")

---@param itemID CollectibleType
---@param itemRNG RNG
---@param player EntityPlayer
---@param flags UseFlag
---@param slot ActiveSlot
---@param varData integer
function preUseItem:main(itemID, itemRNG, player, flags, slot, varData)
	local preUseItemFunctions = {
		triggerOnFire:IgnoreItemUse(itemID, itemRNG, player, flags, slot, varData)
	}

	for _, func in pairs(preUseItemFunctions) do
		if func ~= nil then return func end
	end
end

function preUseItem:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, preUseItem.main)
end

return preUseItem
