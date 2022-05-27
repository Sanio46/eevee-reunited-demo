local postPickupUpdate = {}

---@param pickup EntityPickup
function postPickupUpdate:main(pickup)

end

function postPickupUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, postPickupUpdate.main, PickupVariant.PICKUP_TRINKET)
end

return postPickupUpdate
