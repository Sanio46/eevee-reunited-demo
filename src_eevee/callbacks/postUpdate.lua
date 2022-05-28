local postUpdate = {}

local tracker = require("src_eevee.misc.achievementTracker")
local pokeStop = require("src_eevee.items.collectibles.pokeStop")

function postUpdate:main()
	if not EEVEEMOD.game:IsPaused() then
		VeeHelper.RoomClearTriggered()
		--[[ local players = VeeHelper.GetAllPlayers()
		for i = 1, #players do
			local player = players[i]
			
		end ]]
	end
	pokeStop:SlotUpdate()
	tracker.postUpdate()
end

function postUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_UPDATE, postUpdate.main)
end

return postUpdate
