--Provided by kittenchilly

local familiarBasics = {}

---@param player EntityPlayer
---@param cacheFlag CacheFlag
---@param familiarItemID CollectibleType
---@param familiarVariant FamiliarVariant
function familiarBasics:evaluateCache(player, cacheFlag, familiarItemID, familiarVariant)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local numFamiliars = player:GetCollectibleNum(familiarItemID) + player:GetEffects():GetCollectibleEffectNum(familiarItemID)
		if familiarVariant == EEVEEMOD.FamiliarVariant.BAD_EGG_DUPE then
			numFamiliars = player:GetCollectibleNum(familiarItemID) - player:GetEffects():GetCollectibleEffectNum(familiarItemID)
		end
		local rng = player:GetCollectibleRNG(familiarItemID)
		rng:Next()
		player:CheckFamiliar(familiarVariant, numFamiliars, rng, Isaac.GetItemConfig():GetCollectible(familiarItemID))
	end
end

function familiarBasics:postFamiliarInitMyFamiliar(familiar)
	familiar:AddToFollowers()
end

function familiarBasics:postFamiliarUpdateMyFamiliar(familiar)
	familiar:FollowParent()
end

return familiarBasics
