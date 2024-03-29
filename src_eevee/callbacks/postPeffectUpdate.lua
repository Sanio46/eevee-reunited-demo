local postPeffectUpdate = {}

local blackGlasses = require("src_eevee.items.collectibles.blackGlasses")
local ccp = require("src_eevee.player.characterCostumeProtector")
local cookieJar = require("src_eevee.items.collectibles.cookieJar")
local eeveeBirthright = require("src_eevee.attacks.eevee.birthright_tailwhip")
local eeveeBasics = require("src_eevee.player.eeveeBasics")
local eviolite = require("src_eevee.items.trinkets.eviolite")
local triggerOnFire = require("src_eevee.items.triggerOnFire")
local lilithbr = require("src_eevee.player.lilithbr")
local sneakScarf = require("src_eevee.items.collectibles.sneakScarf")
local strangeEgg = require("src_eevee.items.collectibles.strangeEgg")

---@param player EntityPlayer
function postPeffectUpdate:main(player)
	eeveeBasics:TrackFireDirection(player)

	blackGlasses:DetectDeals(player)
	ccp:OnPeffectUpdate(player)
	cookieJar:SpeedUpdate(player)

	eeveeBirthright:GivePocketActive(player)
	eeveeBirthright:CostumePlayerUpdate(player)
	eeveeBasics:GiveEsauJrEeveeData(player)
	eeveeBasics:TryDeinitEevee(player)
	eviolite:DetectTransformationUpdate(player)
	triggerOnFire:Tech05(player)
	triggerOnFire:DeadTooth(player)
	lilithbr:OnPeffectUpdate(player)
	sneakScarf:ConfuseOutOfRangeEnemies(player)

	triggerOnFire:StopIgnoreItemNextFrame(player)
end

function postPeffectUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, postPeffectUpdate.main)
end

return postPeffectUpdate
