local postNewLevel = {}

local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]

function postNewLevel:main()
	if not EEVEEMOD.game:IsPaused() then
		for i = 0, EEVEEMOD.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			ccp:OnNewLevel(player)
		end
	end
end

return postNewLevel