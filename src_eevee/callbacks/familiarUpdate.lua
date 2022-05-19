local familiarUpdate = {}

local bagOfPokeballs = require("src_eevee.items.collectibles.bagOfPokeballs")
local lilEevee = require("src_eevee.items.collectibles.lilEevee")
local lilithbr = require("src_eevee.player.lilithbr")
local sewingMachine = require("src_eevee.modsupport.sewingMachine")
local badEgg = require("src_eevee.items.collectibles.badEgg")
local familiarBasics = require("src_eevee.misc.familiarBasics")

function familiarUpdate:main(familiar)
	for i, familiarTable in pairs(EEVEEMOD.ItemToFamiliarVariant) do
		local familiarVariant = familiarTable[2]
		if familiar.Variant == familiarVariant then
			familiarBasics:postFamiliarUpdateMyFamiliar(familiar)
		end
	end
	if familiar.Variant == EEVEEMOD.FamiliarVariant.LIL_EEVEE then
		lilEevee:OnFamiliarUpdate(familiar)
		if Sewn_API then
			sewingMachine:OnUpgradedFamiliarUpdate(familiar)
			sewingMachine:OnStateChange(familiar)
		end
		lilithbr:OnFamiliarUpdate(familiar)
	elseif familiar.Variant == EEVEEMOD.FamiliarVariant.BAG_OF_POKEBALLS then
		bagOfPokeballs:SpawnPokeball(familiar)
	elseif familiar.Variant == EEVEEMOD.FamiliarVariant.VINE then
		lilEevee:OnLeafVineUpdate(familiar)
	elseif familiar.Variant == EEVEEMOD.FamiliarVariant.BAD_EGG or familiar.Variant == EEVEEMOD.FamiliarVariant.BAD_EGG_DUPE then
		badEgg:OnFamiliarUpdate(familiar)
	end
end

function familiarUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiarUpdate.main)
end

return familiarUpdate
