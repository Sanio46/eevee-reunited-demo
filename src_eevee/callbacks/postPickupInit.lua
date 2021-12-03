local postPickupInit = {}

local customMrDolly = EEVEEMOD.Src["modsupport"]["customMrDolly"]

function postPickupInit:main(ent)
	customMrDolly:ReplaceDollyPedestalOnInit(ent)
end

return postPickupInit