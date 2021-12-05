local postNewRoom = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]
local ccp = EEVEEMOD.Src["player"]["characterCostumeProtector"]

function postNewRoom:main()
	for i = 0, EEVEEMOD.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		swiftAttack:RespawnSwiftPerRoom(player)
		ccp:OnNewRoom(player)
	end
end

return postNewRoom