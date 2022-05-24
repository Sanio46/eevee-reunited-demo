local uniqueCharacterItems = {}

local baseItemPath = "gfx/unique_items_eeveemod/collectibles_"
local baseCostumePath = "gfx/unique_items_eeveemod/costume_"

local itemPaths = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = "birthright_eevee",
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = "mrdolly_eevee"
}

local hasCostume = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = false,
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = true
}

if not UniqueCharacterItemsAPI then return uniqueCharacterItems end

UniqueCharacterItemsAPI.RegisterMod(EEVEEMOD.Name)
UniqueCharacterItemsAPI.RegisterCharacter("Eevee", false)

for itemID, spritePath in pairs(itemPaths) do
	--UniqueCharacterItemsAPI.RegisterItem(itemID) --This is only for testing. Ideally only to be used by mods that add these packs to be enabled by default, otherwise disabled by default.
	UniqueCharacterItemsAPI.AddCharacterItem({
		PlayerType = EEVEEMOD.PlayerType.EEVEE,
		ItemID = itemID,
		ItemSpritePath = baseItemPath .. spritePath .. ".png",
		CostumeSpritePath = hasCostume[itemID] and baseCostumePath .. spritePath .. ".png" or nil,
	})
end

return uniqueCharacterItems

--Old code, in case we push an update before this code is properly finished.

--[[  local customCollectibleSprites = {}

--Credit to stewart, creator of the "Custom Mr. Dollys" mod for the base of the code: https://steamcommunity.com/sharedfiles/filedetails/?id=2489635144
--I edited it further to be more flexible in accepting any itemID and replacing the sprite with Curse of the Blind after picking it up.

local collectibleSprites = {
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = "mrdolly",
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = "birthright",
}
local collectibleHasCostume = {
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = true,
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = false,
}
local function IsCollectibleEnabled(itemID)
	if EEVEEMOD.PERSISTENT_DATA.CustomDolly == true and itemID == CollectibleType.COLLECTIBLE_MR_DOLLY then
		return true
	elseif EEVEEMOD.PERSISTENT_DATA.UniqueBirthright == true and itemID == CollectibleType.COLLECTIBLE_BIRTHRIGHT then
		return true
	end
	return false
end

local gfxCollectiblePath = "gfx/items/collectibles/collectibles_"
local costumePath = "gfx/characters/costumes/costume_"

function customCollectibleSprites:ReplaceCollectibleOnInit(collectible)
	local level = EEVEEMOD.game:GetLevel()
	if level:GetCurses() == LevelCurse.CURSE_OF_BLIND then return end
	local player = Isaac.GetPlayer(0)
	local playerType = player:GetPlayerType()
	local sprite = collectible:GetSprite()
	local data = collectible:GetData()

	for itemID, spritePath in pairs(collectibleSprites) do
		local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
		if collectible.SubType == itemID then
			if IsCollectibleEnabled(itemID) then
				if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType]
					and (not data.UniqueItemSpriteReplaced or itemID ~= data.UniqueItemSpriteReplaced) then
					sprite:ReplaceSpritesheet(1, gfxCollectiblePath .. string.lower(player:GetName()) .. "_" .. spritePath .. ".png")
					sprite:LoadGraphics()
					sprite:Update()
					sprite:Render(collectible.Position, Vector.Zero, Vector.Zero)
					data.UniqueItemSpriteReplaced = itemID
				end
			elseif data.UniqueItemSpriteReplaced then
				sprite:ReplaceSpritesheet(1, string.lower(itemConfig.GfxFileName))
				sprite:LoadGraphics()
				sprite:Update()
				sprite:Render(collectible.Position, Vector.Zero, Vector.Zero)
				data.UniqueItemSpriteReplaced = nil
			end
			break --No need to loop through the other items
		end
	end
end

function customCollectibleSprites:ReplaceItemCostume(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	for itemID, spritePath in pairs(collectibleSprites) do
		local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
		if player:HasCollectible(itemID)
			and collectibleHasCostume[itemID] then
			if IsCollectibleEnabled(itemID) then
				if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
					if not data.UniqueCostumeSpriteReplaced or data.UniqueCostumeSpriteReplaced ~= player:GetCollectibleNum(itemID) then
						player:ReplaceCostumeSprite(itemConfig, costumePath .. string.lower(player:GetName()) .. "_" .. spritePath .. ".png", 0)
						data.UniqueCostumeSpriteReplaced = player:GetCollectibleNum(itemID)
					end
				end
			elseif data.UniqueCostumeSpriteReplaced then
				player:ReplaceCostumeSprite(itemConfig, costumePath .. itemID .. "_" .. spritePath .. ".png", 0)
				data.UniqueCostumeSpriteReplaced = false
			end
		end
	end
end

--Outside of pedestals, if the player ever has the unique item in their QueuedItem, then it should be updated appropriately
function customCollectibleSprites:ReplaceCollectibleOnItemQueue(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	for itemID, spritePath in pairs(collectibleSprites) do
		if player.QueuedItem.Item ~= nil
			and player.QueuedItem.Item.ID == itemID
			and IsCollectibleEnabled(itemID)
			and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType]
			and not data.UniqueItemSpriteHeld
		then
			local sprite = Sprite()
			sprite:Load("gfx/005.100_collectible.anm2", true)
			sprite:Play("PlayerPickupSparkle", true)
			sprite:ReplaceSpritesheet(1, gfxCollectiblePath .. string.lower(player:GetName()) .. "_" .. spritePath .. ".png")
			sprite:LoadGraphics()
			sprite:Update()
			player:AnimatePickup(sprite, false, "Pickup")
			data.UniqueItemSpriteHeld = true
		end
		break --No need to loop through the other items
	end
	if player:IsItemQueueEmpty() and data.UniqueItemSpriteHeld then
		data.UniqueItemSpriteHeld = nil
	end
end

return customCollectibleSprites ]]
