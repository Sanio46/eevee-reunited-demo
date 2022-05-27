local entityTakeDamage = {}

local eeveeSFX = require("src_eevee.player.eeveeSFX")
local ccp = require("src_eevee.player.characterCostumeProtector")
local leafBlade = require("src_eevee.attacks.leafeon.leafBlade")
local lockOnSpecs = require("src_eevee.items.trinkets.lockOnSpecs")

---@param ent Entity
---@param amount number
---@param flags integer
---@param source EntityRef
---@param countdown integer
function entityTakeDamage:main(ent, amount, flags, source, countdown)
	ent = ent:ToPlayer()
	local entTakeDamageFunctions = {
		leafBlade:PreventDamageOnDash(ent, amount, flags, source, countdown),
		eeveeSFX:EeveeOnHit(ent, amount, flags, source, countdown),
		ccp:AstralProjectionOnHit(ent, amount, flags, source, countdown),
		lockOnSpecs:DropChanceOnHit(ent, amount, flags, source, countdown),
	}

	for _, func in pairs(entTakeDamageFunctions) do
		if func ~= nil then return func end
	end
end

function entityTakeDamage:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, entityTakeDamage.main, EntityType.ENTITY_PLAYER)
end

return entityTakeDamage
