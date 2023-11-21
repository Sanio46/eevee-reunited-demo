local specialistDance = {}
require("src_eevee.modsupport.specialistFix")

local specialistDanceCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_eevee_dance.anm2")

function specialistDance:AddFunnyDance()
	if SpecialistModAPI then
		SpecialistModAPI:AddDanceCostume(EEVEEMOD.PlayerType.EEVEE, specialistDanceCostume, true)
		SpecialistModAPI:AddDanceCostume(EEVEEMOD.PlayerType.EEVEE_B, specialistDanceCostume, true)
	end
end

return specialistDance