local npcUpdate = {}

local eeveeBirthright = EEVEEMOD.Src["items"]["collectibles.eeveeBirthright"]

function npcUpdate:main(npc)
	eeveeBirthright:TimeTillCanBeKnockedBack(npc)
end

return npcUpdate