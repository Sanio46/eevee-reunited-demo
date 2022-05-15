local tracker = require("src_eevee.misc.achievementTracker")

local Manager = {}

local itemToUnlock = {
	[EEVEEMOD.CollectibleType.SHINY_CHARM] = { Unlock = "Isaac" },
	[EEVEEMOD.CollectibleType.COOKIE_JAR[6]] = { Unlock = "BlueBaby" },
	[EEVEEMOD.CollectibleType.BLACK_GLASSES] = { Unlock = "Satan" },
	[EEVEEMOD.CollectibleType.SNEAK_SCARF] = { Unlock = "BossRush" },
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = { Unlock = "MegaSatan" },
	[EEVEEMOD.CollectibleType.BAD_EGG] = { Unlock = "Delirium" },
	[EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS] = { Unlock = "Mother" },
	[EEVEEMOD.CollectibleType.MASTER_BALL] = { Unlock = "Beast" },
	[EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER] = { Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.GreedMode.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.GreedMode.Hard)
	end },
	[EEVEEMOD.Birthright.TAIL_WHIP] = { Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end },
	[EEVEEMOD.CollectibleType.POKE_STOP] = { Special = function()
		return EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal
	end },
	--[[ [EEVEEMOD.Birthright.OVERHEAT] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.THUNDER] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.DIVE] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.FUTURE_SIGHT] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.BRE] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.GLACE] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.SWORDS_DANCE] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.Birthright.SYLV] = {Special = function()
		return (EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Unlock and EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B.FullCompletion.Hard)
	end},
	[EEVEEMOD.CollectibleType.GIGANTAFLUFF] = {Unlock = "Beast", Tainted = true}
	]]
}

local trinketToUnlock = {
	[EEVEEMOD.TrinketType.EVIOLITE] = { Unlock = "Lamb" },
	[EEVEEMOD.TrinketType.LOCKON_SPECS] = { Unlock = "Hush" },
	[EEVEEMOD.TrinketType.ALERT_SPECS] = { Unlock = "GreedMode" },
}

function Manager.postPlayerInit(player)
	local TotPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER)

	if TotPlayers == 0 then
		if EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.MomsHeart == nil then
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee = tracker.CreateUnlocksTemplate()
			EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Tainted = false

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

function Manager.postPickupInit(pickup)
	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
		or pickup.Variant == PickupVariant.PICKUP_TRINKET
	then
		local tab
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
			tab = itemToUnlock[pickup.SubType]
		else
			tab = trinketToUnlock[pickup.SubType]
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
				local roomPool = EEVEEMOD.game:GetItemPool():GetPoolForRoom(EEVEEMOD.game:GetRoom():GetType(), EEVEEMOD.game:GetLevel():GetCurrentRoomDesc().SpawnSeed)
				local targetItem = EEVEEMOD.game:GetItemPool():GetCollectible(roomPool, true, pickup.InitSeed)

				EEVEEMOD.game:GetItemPool():RemoveCollectible(pickup.SubType)
				pickup:Morph(pickup.Type, pickup.Variant, targetItem, true, true, true)
			elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
				EEVEEMOD.game:GetItemPool():RemoveTrinket(pickup.SubType)
				pickup:Morph(pickup.Type, pickup.Variant, EEVEEMOD.game:GetItemPool():GetTrinket(), true, true, true)
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

function Manager.postPlayerUpdate(player)
	for item, tab in pairs(itemToUnlock) do
		local HasIt = player:HasCollectible(item)

		if HasIt then
			local Suffix = tab.Tainted and "_B" or ""
			local Unlocked = false

			if tab.Special then
				Unlocked = tab.Special()
			else
				Unlocked = EEVEEMOD.PERSISTENT_DATA.UnlockData["Eevee" .. Suffix][tab.Unlock].Unlock
			end

			if not Unlocked then
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
