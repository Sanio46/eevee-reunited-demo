local preSpawnCleanAward = {}

local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")

---@param rng RNG
---@param spawnPos Vector
function preSpawnCleanAward:main(rng, spawnPos)
	pokeyMans:OnClearReward(rng, spawnPos)
end

---@param EeveeReunited ModReference
function preSpawnCleanAward:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, preSpawnCleanAward.main)
end

return preSpawnCleanAward