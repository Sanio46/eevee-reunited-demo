local preGameExit = {}

local pokeStop = require("src_eevee.items.collectibles.pokeStop")

function preGameExit:main()
	EEVEEMOD.isNewGame = false
	local players = VeeHelper.GetAllPlayers()
	for i = 1, #players do
		local player = players[i]
		pokeStop:SpawnOnGameExit(player)
	end
end

function preGameExit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, preGameExit.main)
end

return preGameExit
