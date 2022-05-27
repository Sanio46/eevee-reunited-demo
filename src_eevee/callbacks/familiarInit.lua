local familiarInit = {}

local bagOfPokeballs = require("src_eevee.items.collectibles.bagOfPokeballs")
local lilEevee = require("src_eevee.items.collectibles.lilEevee")
local miniIsaac = require("src_eevee.misc.customMiniIsaac")
local shadeEevee = require("src_eevee.misc.customShade")
local familiarBasics = require("src_eevee.misc.familiarBasics")

---@param familiar EntityFamiliar
function familiarInit:main(familiar)
	for i, familiarTable in pairs(EEVEEMOD.ItemToFamiliarVariant) do
		local familiarVariant = familiarTable[2]
		if familiar.Variant == familiarVariant then
			familiarBasics:postFamiliarInitMyFamiliar(familiar)
		end
	end
	if familiar.Variant == EEVEEMOD.FamiliarVariant.LIL_EEVEE then
		lilEevee:OnFamiliarInit(familiar)
	elseif familiar.Variant == FamiliarVariant.MINISAAC then
		miniIsaac:onMiniInit(familiar)
	elseif familiar.Variant == FamiliarVariant.SHADE then
		shadeEevee:ReplaceShade(familiar)
	end
	--[[ if familiar.Variant == FamiliarVariant.WISP and familiar.SubType ~= EEVEEMOD.CollectibleType.COOKIE_JAR[1] then
		if not familiar.Player then return end
		local player = familiar.Player
		local data = player:GetData()

		if data.CookieJarRemoveWisp then
			data.CookieJarRemoveWisp = nil
			familiar:Remove()
		end
	end ]]
end

function familiarInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiarInit.main)
end

return familiarInit
