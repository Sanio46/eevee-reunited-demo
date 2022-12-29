local npcUpdate = {}

local eeveeBirthright = require("src_eevee.attacks.eevee.birthright_tailwhip")
local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")
local shinyCharm = require("src_eevee.items.collectibles.shinyCharm")

---@param npc EntityNPC
function npcUpdate:main(npc)
	shinyCharm:TryMakeShinyOnNPCInit(npc)
	shinyCharm:ShinyColoredNPCUpdate(npc)
	eeveeBirthright:TimeTillCanBeKnockedBack(npc)
	pokeyMans:StarterNPCUpdate(npc)
end

function npcUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_NPC_UPDATE, npcUpdate.main)
end

return npcUpdate
