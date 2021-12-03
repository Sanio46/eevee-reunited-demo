local postUpdate = {}

local eeveeGhost = EEVEEMOD.Src["player"]["eeveeGhost"]

function postUpdate:main()
	if not EEVEEMOD.game:IsPaused() then
		for i = 0, EEVEEMOD.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			eeveeGhost:SpawnGhostEffect(player)
		end
	end
end

return postUpdate