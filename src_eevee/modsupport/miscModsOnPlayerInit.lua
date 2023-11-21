local miscMods = {}
local coopGhostPath = "gfx/characters/ghost/ghost_"

function miscMods:addCoopGhostCompatibility()
	if CustomCoopGhost then
		CustomCoopGhost.ChangeSkin(EEVEEMOD.PlayerType.EEVEE, coopGhostPath .. "eevee.png")
		CustomCoopGhost.AddCostume(EEVEEMOD.PlayerType.EEVEE, coopGhostPath .. "eevee_hair.png")
	end
end

function miscMods:addPogCompatibility()
	if Poglite then
		local pogCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_eevee_pog.anm2")
		Poglite:AddPogCostume("EeveePog", EEVEEMOD.PlayerType.EEVEE, pogCostume)
	end
end

function miscMods:addUghCompatibility()
	if Ughlite then
		local pogCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_eevee_disappointed.anm2")
		Ughlite:AddUghCostume("EeveeUgh", EEVEEMOD.PlayerType.EEVEE, pogCostume)
	end
end

--Might need to re-evaluate what costumes should be kept
function miscMods:addNoCostumesCompatibility()
	if NoCostumes then
		addCostumeToIgnoreList("gfx/characters/costume_eevee.anm2") --Main costume
		addCostumeToIgnoreList("gfx/characters/costume_eevee_pog.anm2") --cuz pog
	end
end

---@param player EntityPlayer
function miscMods:OnPlayerInit(player)
	miscMods:addPogCompatibility()
	miscMods:addCoopGhostCompatibility()
	miscMods:addNoCostumesCompatibility()
	miscMods:addUghCompatibility()
end

return miscMods
