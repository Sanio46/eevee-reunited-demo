local postGameStarted = {}

local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")
local triggerOnFire = require("src_eevee.items.triggerOnFire")
local strangeEggRender = require("src_eevee.items.collectibles.strangeEggRender")
local ccp = require("src_eevee.player.characterCostumeProtector")
local badEgg = require("src_eevee.items.collectibles.badEgg")
local swiftBase = require("src_eevee.attacks.eevee.swiftBase")

function postGameStarted:main(wasRunContinued)
	EEVEEMOD.shouldSaveData = true
	if not wasRunContinued then
		strangeEggRender:ResetOnGameStart()
	else
		ccp:GnawedOnLoad()
	end
	triggerOnFire:ResetOnGameStart()
	pokeyMans:SpawnStarters()
	badEgg:GetFamiliarItemsOnGameStart()
	swiftBase:ResetData()
end

function postGameStarted:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, postGameStarted.main)
end

return postGameStarted
