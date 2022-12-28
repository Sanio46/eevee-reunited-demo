local prePlayerCollision = {}

local pokeStop = require("src_eevee.items.collectibles.pokeStop")

---@param player EntityPlayer
---@param collider Entity
---@param low boolean
function prePlayerCollision:main(player, collider, low)
	pokeStop:IfTouchPokeStop(player, collider, low)
end

function prePlayerCollision:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, prePlayerCollision.main, 0)
end

return prePlayerCollision
