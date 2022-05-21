local miscMods = {}

function miscMods:addCoopGhostCompatibility()
	if CustomCoopGhost then
		CustomCoopGhost.ChangeSkin(EEVEEMOD.PlayerType.EEVEE, "eevee")
		CustomCoopGhost.AddCostume(EEVEEMOD.PlayerType.EEVEE, "eevee")
	end
end

function miscMods:addPogCompatibility()
	if Poglite then
		local pogCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_eevee_pog.anm2")
		Poglite:AddPogCostume("EeveePog", EEVEEMOD.PlayerType.EEVEE, pogCostume)
	end
end

--Might need to re-evaluate what costumes should be kept
function miscMods:addNoCostumesCompatibility()
	if NoCostumes then
		addCostumeToIgnoreList("gfx/characters/costume_eevee.anm2") --Main costume
		addCostumeToIgnoreList("gfx/characters/costume_eevee_pog.anm2") --cuz pog
	end
end

return miscMods
