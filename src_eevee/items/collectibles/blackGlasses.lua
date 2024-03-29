local blackGlasses = {}

---@param player EntityPlayer
function blackGlasses:DetectDeals(player)
	local data = player:GetData()

	if data.PotentialDeal and data.PotentialDealID ~= 0 then
		if not data.PotentialDeal:Exists()
			or data.PotentialDeal.SubType ~= data.PotentialDealID
		then
			if player.QueuedItem.Item and player.QueuedItem.Item.ID == data.PotentialDealID and player.QueuedItem.Touched == false then
				local effects = player:GetEffects()
				local devilPrice = Isaac.GetItemConfig():GetCollectible(player.QueuedItem.Item.ID).DevilPrice
				effects:AddCollectibleEffect(EEVEEMOD.CollectibleType.BLACK_GLASSES, false, devilPrice)
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
				data.PotentialDeal = nil
				data.PotentialDealID = nil
			end
		end
	end
end

---@param item EntityPickup
---@param player EntityPlayer
function blackGlasses:OnCollectibleCollision(item, player)
	local data = player:GetData()

	if item:IsShopItem()
		and item.SubType ~= 0
		and (
		(item.Price < 0 and item.Price ~= -1000)
			or (player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH) and item.Price >= 0)
		) then
		data.PotentialDeal = item
		data.PotentialDealID = item.SubType
	end
end

---@param player EntityPlayer
---@param itemStats ItemStats
function blackGlasses:Stats(player, itemStats)
	if not player:HasCollectible(EEVEEMOD.CollectibleType.BLACK_GLASSES) then return end
	local effectNum = player:GetEffects():GetCollectibleEffectNum(EEVEEMOD.CollectibleType.BLACK_GLASSES)

	itemStats.DAMAGE_FLAT = itemStats.DAMAGE_FLAT +
		(0.5 * player:GetCollectibleNum(EEVEEMOD.CollectibleType.BLACK_GLASSES)
		)
	itemStats.DAMAGE_MULT = itemStats.DAMAGE_MULT + (0.1 * effectNum)
end

return blackGlasses
