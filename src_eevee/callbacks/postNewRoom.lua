local postNewRoom = {}

local ccp = require("src_eevee.player.characterCostumeProtector")
local pokeball = require("src_eevee.items.pickups.pokeball")
local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local gigantafluff = require("src_eevee.items.collectibles.gigantafluff")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local lilEevee = require("src_eevee.items.collectibles.lilEevee")
local pokeStop = require("src_eevee.items.collectibles.pokeStop")

function postNewRoom:main()
	local players = VeeHelper.GetAllPlayers()
	
	for i = 1, #players do
		local player = players[i]
		pokeball:ResetBallsOnNewRoom(player)
		--swiftAttack:RespawnSwiftPerRoom(player)
		ccp:OnNewRoom(player)
		gigantafluff:CharmEnemiesOnNewRoom(player)
		wonderousLauncher:OnNewRoom(player)
	end
	swiftAttack:RetainSwiftInstanceOnNewRoom()
	lilEevee:RemoveVineOnNewRoom()
	pokeStop:SpawnPokeStopInSpecialRoom()
end

function postNewRoom:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postNewRoom.main)
end

return postNewRoom
