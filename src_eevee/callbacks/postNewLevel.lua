local postNewLevel = {}

local ccp = require("src_eevee.player.characterCostumeProtector")
local strangeEgg = require("src_eevee.items.collectibles.strangeEgg")
local pokeStop = require("src_eevee.items.collectibles.pokeStop")

function postNewLevel:main()
	local players = VeeHelper.GetAllPlayers()

	pokeStop:ResetSpecialRooms()
	for i = 1, #players do
		local player = players[i]
		ccp:OnNewLevel(player)
		strangeEgg:ChargeOnlyOnNewLevel(player)
		pokeStop:GetAllSpecialRooms(player)
	end
end

function postNewLevel:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, postNewLevel.main)
end

return postNewLevel
