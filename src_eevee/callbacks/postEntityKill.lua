local postEntityKill = {}

local shinyCharm = require("src_eevee.items.collectibles.shinyCharm")
local pokeball = require("src_eevee.items.pickups.pokeball")
local strangeEgg = require("src_eevee.items.collectibles.strangeEgg")

---@param npc EntityNPC
function postEntityKill:OnNPCDeath(npc)
	shinyCharm:PostShinyKill(npc)
end

---@param familiar EntityFamiliar
function postEntityKill:OnFamiliarDeath(familiar)
	pokeball:OnMasterBallWispDeath(familiar)
	strangeEgg:OnStrangeEggWispDeath(familiar)
end

---@param ent Entity
function postEntityKill:main(ent)
	if ent:ToNPC() then
		---@type EntityNPC
		local npc = ent:ToNPC()
		postEntityKill:OnNPCDeath(npc)
	elseif ent:ToFamiliar() then
		---@type EntityFamiliar
		local familiar = ent:ToFamiliar()
		postEntityKill:OnFamiliarDeath(familiar)
	end
end

function postEntityKill:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, postEntityKill.main)
end

return postEntityKill
