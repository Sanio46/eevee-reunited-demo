local entityTakeDamage = {}

local eeveeSFX = require("src_eevee.player.eeveeSFX")
local ccp = require("src_eevee.player.characterCostumeProtector")
local lockOnSpecs = require("src_eevee.items.trinkets.lockOnSpecs")

---@param player EntityPlayer
---@param amount number
---@param flags integer
---@param source EntityRef
---@param countdown integer
function entityTakeDamage:main(player, amount, flags, source, countdown)
	player = player:ToPlayer()
	local entTakeDamageFunctions = {
		eeveeSFX:EeveeOnHit(player, amount, flags, source, countdown),
		ccp:AstralProjectionOnHit(player, amount, flags, source, countdown),
		lockOnSpecs:DropChanceOnHit(player, amount, flags, source, countdown),
	}

	for _, func in pairs(entTakeDamageFunctions) do
		if func ~= nil then return func end
	end
end

function entityTakeDamage:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, entityTakeDamage.main, EntityType.ENTITY_PLAYER)
end

return entityTakeDamage
