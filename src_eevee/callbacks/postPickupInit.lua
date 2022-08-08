local postPickupInit = {}

local customCollectibleSprites = require("src_eevee.modsupport.uniqueCharacterItems")
local unlockManager = require("src_eevee.misc.unlockManager")
local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")

function postPickupInit:main(pickup)
	unlockManager.postPickupInit(pickup)
end

function postPickupInit:CollectibleInit(collectible)
	customCollectibleSprites:ReplaceCollectibleOnInit(collectible)
	pokeyMans:ReplaceItemsOnInit(collectible)
end

function postPickupInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, postPickupInit.main)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, postPickupInit.CollectibleInit, PickupVariant.PICKUP_COLLECTIBLE)
end

return postPickupInit
