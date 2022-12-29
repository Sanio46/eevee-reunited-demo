local useItem = {}

local ccp = require("src_eevee.player.characterCostumeProtector")
local cookieJar = require("src_eevee.items.collectibles.cookieJar")
local eeveeBirthright = require("src_eevee.attacks.eevee.birthright_tailwhip")
local eeveeBasics = require("src_eevee.player.eeveeBasics")
local eeveeSFX = require("src_eevee.player.eeveeSFX")
local pokeball = require("src_eevee.items.pickups.pokeball")
local strangeEgg = require("src_eevee.items.collectibles.strangeEgg")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")

---@param itemID CollectibleType
---@param itemRNG RNG
---@param player EntityPlayer
---@param flags UseFlag
---@param slot ActiveSlot
---@param varData integer
function useItem:main(itemID, itemRNG, player, flags, slot, varData)
	local useItemFunctions = {
		ccp:ResetCostumeOnItem(itemID, itemRNG, player, flags, slot, varData),
		pokeball:OnMasterBallUse(itemID, itemRNG, player, flags, slot, varData)
	}

	for _, func in pairs(useItemFunctions) do
		if func ~= nil then return func end
	end
end

function useItem:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, useItem.main)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, eeveeBasics.OnEsauJr, CollectibleType.COLLECTIBLE_ESAU_JR)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, eeveeSFX.OnLarynxOrBerserk, CollectibleType.COLLECTIBLE_BERSERK)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, eeveeSFX.OnLarynxOrBerserk, CollectibleType.COLLECTIBLE_LARYNX)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, eeveeBirthright.OnUse, EEVEEMOD.CollectibleType.TAIL_WHIP)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, strangeEgg.onUse, EEVEEMOD.CollectibleType.STRANGE_EGG)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, wonderousLauncher.OnUse, EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, ccp.OnShoop, CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, ccp.OnBoomerang, CollectibleType.COLLECTIBLE_BOOMERANG)
	EeveeReunited:AddCallback(ModCallbacks.MC_USE_ITEM, cookieJar.onUse, EEVEEMOD.CollectibleType.COOKIE_JAR)
end

return useItem
