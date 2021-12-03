local familiarInit = {}

local miniIsaac = EEVEEMOD.Src["misc"]["customMiniIsaac"]
local shadeEevee = EEVEEMOD.Src["misc"]["customShade"]

function familiarInit:main(familiar)
	if familiar.Variant == FamiliarVariant.MINISAAC then
		miniIsaac:onMiniInit(familiar)
	elseif familiar.Variant == FamiliarVariant.SHADE then
		shadeEevee:ReplaceShade(familiar)
	end
end

return familiarInit