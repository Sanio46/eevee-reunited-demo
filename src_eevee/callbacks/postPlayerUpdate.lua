local postPlayerUpdate = {}

local eeveeGhost = require("src_eevee.player.eeveeGhost")
local earbuds = require("src_eevee.items.collectibles.hiTechEarbuds")
local pokeball = require("src_eevee.items.pickups.pokeball")
local unlockManager = require("src_eevee.misc.unlockManager")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local eeveeSFX = require("src_eevee.player.eeveeSFX")
local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local ccp = require("src_eevee.player.characterCostumeProtector")
local strangeEgg = require("src_eevee.items.collectibles.strangeEgg")

---@param player EntityPlayer
function postPlayerUpdate:main(player)
	eeveeGhost:SpawnGhostEffect(player)
	earbuds:LoadVolumeBar(player)
	pokeball:PlayerThrowPokeball(player)
	unlockManager.postPlayerUpdate(player)
	wonderousLauncher:OnPlayerUpdate(player)
	eeveeSFX:PlayHurtSFX(player)
	swiftAttack:SwiftSpecialAttackKillSwitch(player)
	swiftAttack:SwiftAttackTimers(player)
	ccp:OnPlayerUpdate(player)
	strangeEgg:ForceItemUse(player)
end

function postPlayerUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, postPlayerUpdate.main)
end

return postPlayerUpdate
