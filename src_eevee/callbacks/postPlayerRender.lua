local postPlayerRender = {}

local ccp = require("src_eevee.player.characterCostumeProtector")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local pet = require('src_eevee.misc.petVee')

---@param player EntityPlayer
function postPlayerRender:main(player)
	wonderousLauncher:StopPoopAnimation(player)
	ccp:RestoreCostumeInMineshaft(player)
	pet:RenderPetting(player)
end

function postPlayerRender:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, postPlayerRender.main, 0)
end

return postPlayerRender
