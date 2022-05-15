local postUpdate = {}

local eeveeGhost = require("src_eevee.player.eeveeGhost")
local tracker = require("src_eevee.misc.achievementTracker")
local pokeStop = require("src_eevee.items.collectibles.pokeStop")

function postUpdate:main()
	if not EEVEEMOD.game:IsPaused() then
		VeeHelper.RoomClearTriggered()
		local players = VeeHelper.GetAllPlayers()
		for i = 1, #players do
			eeveeGhost:SpawnGhostEffect(players[i]) --Can I Do this in PLAYER_UPDATE?
		end
	end
	pokeStop:SlotUpdate()
	tracker.postUpdate()
end

function postUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_UPDATE, postUpdate.main)
end

return postUpdate
