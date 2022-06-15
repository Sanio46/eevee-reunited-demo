local preNpcCollision = {}

local alertSpecs = require("src_eevee.items.trinkets.alertSpecs")
local leafBlade = require("src_eevee.attacks.leafeon.leafBlade")

---@param npc EntityNPC
---@param collider Entity
---@param low boolean
---@diagnostic disable-next-line: unused-local
function preNpcCollision:main(npc, collider, low)
	if collider.Type == EntityType.ENTITY_PLAYER and collider:ToPlayer() then
		local player = collider:ToPlayer()
		local useItemFunctions = {
			alertSpecs:OnCollisionGreedEnemy(npc, player),
			leafBlade:SlashCollidedEnemy(npc, player),
		}
		for i = 1, #useItemFunctions do
			if useItemFunctions[i] ~= nil then return useItemFunctions[i] end
		end
	end
end

function preNpcCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, preNpcCollision.main)
end

return preNpcCollision
