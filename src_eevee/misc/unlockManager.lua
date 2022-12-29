local tracker = require("src_eevee.misc.achievementTracker")

local Manager = {}

local itemToUnlock = {
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = { Unlock = "Isaac" },
	[EEVEEMOD.CollectibleType.COOKIE_JAR] = { Unlock = "BlueBaby" },
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = { Unlock = "Satan" },
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = { Unlock = "BossRush" },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = { Unlock = "MegaSatan" },
	[EEVEEMOD.CollectibleType.BAD_EGG] = { Unlock = "Delirium" },
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = { Unlock = "Mother" },
	[EEVEEMOD.CollectibleType.MASTER_BALL] = { Unlock = "Beast" },
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = { Special = function()
		return (
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.GreedMode.Unlock and
				EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.GreedMode.Hard)
	end },
	[EEVEEMOD.CollectibleType.TAIL_WHIP] = { Special = function()
		return (
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.FullCompletion.Unlock and
				EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.FullCompletion.Hard)
	end },
	[EEVEEMOD.CollectibleType.POKE_STOP] = { Special = function()
		return EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal
	end },
}

local trinketToUnlock = {
	[EEVEEMOD.TrinketType.EVIOLITE] = { Unlock = "Lamb" },
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = { Unlock = "Hush" },
	[EEVEEMOD.TrinketType.ALERT_SPECS] = { Unlock = "GreedMode" },
}

function Manager.postPlayerInit(_)
	local TotPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER)

	if TotPlayers == 0 then
		if EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.MomsHeart == nil then
			---@type Unlocks
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee = tracker.CreateUnlocksTemplate()
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Tainted = false

			---@type Unlocks
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B = tracker.CreateUnlocksTemplate()
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.PolNegPath = false
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.SoulPath = false
		end

		if EEVEEMOD.game:GetFrameCount() > 0 then return end

		for item, tab in pairs(itemToUnlock) do
			local Suffix = tab.Tainted and "_B" or ""
			local Unlocked = false

			if tab.Special then
				Unlocked = tab.Special()
			else
				Unlocked = EEVEEMOD.PERSISTENT_DATA.UnlockData["Eevee" .. Suffix][tab.Unlock].Unlock
			end

			if not Unlocked then
				EEVEEMOD.game:GetItemPool():RemoveCollectible(item)
			end
		end
		for trinket, tab in pairs(trinketToUnlock) do
			local Suffix = tab.Tainted and "_B" or ""
			local Unlocked = false

			if tab.Special then
				Unlocked = tab.Special()
			else
				Unlocked = EEVEEMOD.PERSISTENT_DATA.UnlockData["Eevee" .. Suffix][tab.Unlock].Unlock
			end

			if not Unlocked then
				EEVEEMOD.game:GetItemPool():RemoveTrinket(trinket)
			end
		end
	end
end

---@param pickup EntityPickup
function Manager.postPickupInit(pickup)
	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
		or pickup.Variant == PickupVariant.PICKUP_TRINKET
	then
		local isGoldenTrinket = false
		local tab
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
			tab = itemToUnlock[pickup.SubType]
		else
			if pickup.SubType & TrinketType.TRINKET_GOLDEN_FLAG ~= 0 then
				isGoldenTrinket = true
			end
			tab = trinketToUnlock[pickup.SubType & TrinketType.TRINKET_ID_MASK]
		end

		if (not tab) then return end

		local Suffix = tab.Tainted and "_B" or ""
		local Unlocked = false

		if tab.Special then
			Unlocked = tab.Special()
		else
			Unlocked = EEVEEMOD.PERSISTENT_DATA.UnlockData["Eevee" .. Suffix][tab.Unlock].Unlock
		end

		if not Unlocked then
			if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				local roomPool = EEVEEMOD.game:GetItemPool():GetPoolForRoom(EEVEEMOD.game:GetRoom():GetType(),
					EEVEEMOD.game:GetLevel():GetCurrentRoomDesc().SpawnSeed)
				local targetItem = EEVEEMOD.game:GetItemPool():GetCollectible(roomPool, true, pickup.InitSeed)

				EEVEEMOD.game:GetItemPool():RemoveCollectible(pickup.SubType)
				pickup:Morph(pickup.Type, pickup.Variant, targetItem, true, true, true)
			elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
				EEVEEMOD.game:GetItemPool():RemoveTrinket(pickup.SubType)
				local newTrinket = EEVEEMOD.game:GetItemPool():GetTrinket()
				if isGoldenTrinket then
					newTrinket = newTrinket | TrinketType.TRINKET_GOLDEN_FLAG
				end
				pickup:Morph(pickup.Type, pickup.Variant, newTrinket, true, true, true)
			end
		end
	elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then --Placeholder in case Eeveium Z is a rune
		--[[ if pickup.SubType == EEVEEMOD.PokeballType.ULTRABALL then
			if not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.SoulPath then
				local Counter = 10000
				local TargetCard = EEVEEMOD.game:GetItemPool():GetCard(pickup.InitSeed + Counter, false, true, true)
			
				while TargetCard == EEVEEMOD.PokeballType.ULTRABALL do --PLACEHOLDER
					Counter = Counter + 10000
					TargetCard = EEVEEMOD.game:GetItemPool():GetCard(pickup.InitSeed + Counter, false, true, true)
				end
				
				pickup:Morph(pickup.Type, pickup.Variant, TargetCard, true, true, true)
			end
		end ]]
	end
end

---@param player EntityPlayer
---@param itemID CollectibleType
local function IsPocketBirthright(player, itemID)
	return player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and
		player:GetPlayerType() == EEVEEMOD.BirthrightToPlayerType[itemID] and
		player:GetActiveItem(ActiveSlot.SLOT_POCKET) == itemID
end

---@param player EntityPlayer
function Manager.postPlayerUpdate(player)
	for item, tab in pairs(itemToUnlock) do
		local HasIt = player:HasCollectible(item)

		if HasIt then
			local Suffix = tab.Tainted and "_B" or ""
			local Unlocked = false

			if tab.Special then
				Unlocked = tab.Special()
			else
				---@type Unlocks
				local unlockData = EEVEEMOD.PERSISTENT_DATA.UnlockData["Eevee" .. Suffix]
				Unlocked = unlockData[tab.Unlock].Unlock
			end

			if not Unlocked and not IsPocketBirthright(player, item) then
				local targetItem = EEVEEMOD.game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, player.InitSeed)
				player:RemoveCollectible(item)
				player:AddCollectible(targetItem, EEVEEMOD.ItemConfig:GetCollectible(targetItem).MaxCharges)
			end
		end
	end
	for trinket, tab in pairs(trinketToUnlock) do
		local HasIt = player:HasTrinket(trinket)

		if HasIt then
			local Suffix = tab.Tainted and "_B" or ""
			local Unlocked = false

			if tab.Special then
				Unlocked = tab.Special()
			else
				Unlocked = EEVEEMOD.PERSISTENT_DATA.UnlockData["Eevee" .. Suffix][tab.Unlock].Unlock
			end

			if not Unlocked then
				local targetTrinket = EEVEEMOD.game:GetItemPool():GetTrinket()
				player:TryRemoveTrinket(trinket)
				player:AddTrinket(targetTrinket)
			end
		end
	end
	--[[ for i = 0, 3 do  --Placeholder in case Eeveium Z is a rune
		if player:GetCard(i) == EEVEEMOD.PokeballType.ULTRABALL
		and (not EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.SoulPath)
		then
			local Counter = 10000
			local TargetCard = EEVEEMOD.game:GetItemPool():GetCard(player.InitSeed + Counter, false, true, true)
		
			while TargetCard == EEVEEMOD.PokeballType.ULTRABALL do --PLACEHOLDER
				Counter = Counter + 10000
				TargetCard = EEVEEMOD.game:GetItemPool():GetCard(player.InitSeed + Counter, false, true, true)
			end
			
			player:SetCard(i, TargetCard)
		end
	end ]]
end

return Manager
