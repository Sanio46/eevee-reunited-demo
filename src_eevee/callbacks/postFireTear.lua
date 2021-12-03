local postFireTear = {}

local itemEffectOnFire = EEVEEMOD.Src["player"]["itemEffectOnFire"]

function postFireTear:main(tear)
	itemEffectOnFire:ImmaculateHeart(tear)
end

return postFireTear