local uniqueCharacterItems = {}

local baseItemPath = "gfx/unique_items_eeveemod/collectibles_"
local baseCostumePath = "gfx/unique_items_eeveemod/costume_"

---@type table<CollectibleType, string>
local itemPaths = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = "birthright_eevee",
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = "mrdolly_eevee"
}

---@type table<CollectibleType, boolean>
local hasCostume = {
	[CollectibleType.COLLECTIBLE_BIRTHRIGHT] = false,
	[CollectibleType.COLLECTIBLE_MR_DOLLY] = true
}

if not UniqueItemsAPI then return uniqueCharacterItems end

UniqueItemsAPI.RegisterMod(EEVEEMOD.Name)
UniqueItemsAPI.RegisterCharacter("Eevee", false)

for itemID, spritePath in pairs(itemPaths) do
	UniqueItemsAPI.AddCharacterItem({
		PlayerType = EEVEEMOD.PlayerType.EEVEE,
		ItemID = itemID,
		ItemSprite = baseItemPath .. spritePath .. ".png",
		CostumeSpritePath = hasCostume[itemID] and baseCostumePath .. spritePath .. ".png" or nil,
	})
end

return uniqueCharacterItems