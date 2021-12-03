local postNewRoom = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]
local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]

function postNewRoom:main()
	for i = 0, EEVEEMOD.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		swiftAttack:RespawnSwiftPerRoom(player)
		costumeProtector:OnNewRoom(player)
	end
end

return postNewRoom