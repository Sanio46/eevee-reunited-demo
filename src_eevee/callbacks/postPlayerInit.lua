local postPlayerInit = {}

local ccp = require("src_eevee.player.characterCostumeProtector")
local eeveeBasics = require("src_eevee.player.eeveeBasics")
local unlockManager = require("src_eevee.misc.unlockManager")
local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")

---@param player EntityPlayer
function postPlayerInit:main(player)
	VeeHelper.ShaderCrashFix()

	local seed = EEVEEMOD.game:GetSeeds():GetStartSeed()
	EEVEEMOD.RunSeededRNG:SetSeed(seed, 1)

	eeveeBasics:NoTainted(player)
	eeveeBasics:TryInitEevee(player)
	ccp:OnPlayerInit(player)
	unlockManager.postPlayerInit(player)
	pokeyMans:OnChallengeInit(player)
end

function postPlayerInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, postPlayerInit.main)
end

return postPlayerInit
