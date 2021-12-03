local postKnifeInit = {}

local customSpiritSword = EEVEEMOD.Src["modsupport"]["customSpiritSword"]

function postKnifeInit:main(knife)
	if knife.Variant == EEVEEMOD.KnifeVariant.SPIRIT_SWORD
	or knife.Variant == EEVEEMOD.KnifeVariant.TECH_SWORD then
		customSpiritSword:ReplaceSpiritSwordOnInit(knife)
	end
end

return postKnifeInit