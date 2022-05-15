local inputAction = {}

local pokeball = require("src_eevee.items.pickups.pokeball")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local strangeEgg = require("src_eevee.items.collectibles.strangeEgg")

function inputAction:main(entity, inputHook, buttonAction)
	if entity and entity:ToPlayer() then
		local player = entity:ToPlayer()
		local inputActionFunctions = {
			pokeball:ForceKeysForPokeball(player, inputHook, buttonAction),
			wonderousLauncher:ForcePoop(player, inputHook, buttonAction),
			strangeEgg:ForceItemUse(player, inputHook, buttonAction)
		}

		for _, func in pairs(inputActionFunctions) do
			if func ~= nil then return func end
		end
	end
end

function inputAction:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_INPUT_ACTION, inputAction.main)
end

return inputAction
