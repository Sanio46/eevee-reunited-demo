local postNewLevel = {}

local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]

function postNewLevel:main()
	if not EEVEEMOD.game:IsPaused() then
		for i = 0, EEVEEMOD.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			costumeProtector:OnNewLevel(player)
		end
	end
end

return postNewLevel