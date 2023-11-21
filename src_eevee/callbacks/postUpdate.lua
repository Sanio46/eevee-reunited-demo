local vee = require("src_eevee.VeeHelper")
local postUpdate = {}

local tracker = require("src_eevee.misc.achievementTracker")
local pokeStop = require("src_eevee.items.collectibles.pokeStop")
local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")

function postUpdate:main()
	if not EEVEEMOD.game:IsPaused() then
		vee.RoomClearTriggered()
		--[[ local players = vee.GetAllPlayers()
		for i = 1, #players do
			local player = players[i]
			
		end ]]
	end
	pokeStop:SlotUpdate()
	tracker.postUpdate()
	pokeyMans:TryRespawnStarters()
end

function postUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_UPDATE, postUpdate.main)
end

return postUpdate
