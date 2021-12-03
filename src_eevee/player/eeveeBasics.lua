local eeveeBasics = {}

local costumeProtector = EEVEEMOD.Src["player"]["eeveeCustomCostumes"]
local miscMods = EEVEEMOD.Src["modsupport"]["miscModsOnPlayerInit"]

function eeveeBasics:OnPlayerInit(player)
	local dataPlayer = player:GetData()
	local playerType = player:GetPlayerType()
	
	if not dataPlayer.IsEevee and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] and not player:IsCoopGhost() then

		dataPlayer.IsEevee = true

		if EEVEEMOD.game.TimeCounter == 0 or EEVEEMOD.isNewGame then
			local eeveeCostume = Isaac.GetCostumeIdByPath("gfx/characters/costume_eevee.anm2")
			player:AddNullCostume(eeveeCostume)
		end

		miscMods:addPogCompatibility()
		miscMods:addCoopGhostCompatibility()
		miscMods:addNoCostumesCompatibility()
		EEVEEMOD.API.SetCanShoot(player, false)
		dataPlayer.Swift = {}
		dataPlayer.CCP = {}
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
		
	end	
end

local EeveeToEsauJr = {}

function eeveeBasics:OnEsauJr(itemID, itemRNG, player, flags, slot, vardata)
	local dataPlayer = player:GetData()
	local playerType = player:GetPlayerType()
	
	if itemID == CollectibleType.COLLECTIBLE_ESAU_JR 
	and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		table.insert(EeveeToEsauJr, player.Index)
	end
end

function eeveeBasics:GiveEsauJrEeveeData(player)
	local dataPlayer = player:GetData()
	local playerType = player:GetPlayerType()

	if #EeveeToEsauJr > 0 and EeveeToEsauJr[1] ~= nil then
		if EeveeToEsauJr == player.Index
		and not dataPlayer.IsEevee 
		and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
			EEVEEMOD.API.SetCanShoot(player, false)
			dataPlayer.IsEevee = true
			dataPlayer.Swift = {}
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
			costumeProtector:InitPlayerCostume(player)
			table.remove(EeveeToEsauJr, 1)
		end
	end
end	

function eeveeBasics:TryDeinitEevee(player)
	local dataPlayer = player:GetData()
	local playerType = player:GetPlayerType()
	
	if dataPlayer.IsEevee and not EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		dataPlayer.IsEevee = false
		dataPlayer.Swift = nil
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end

local function ShouldTriggerEeveeSFX(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		dataPlayer.EeveeTriggerSFX = true
	end
end

function eeveeBasics:EeveeOnHurt(ent, amount, flags, source, countdown)
	local player = ent:ToPlayer()
	ShouldTriggerEeveeSFX(player)
end

function eeveeBasics:OnLarynxOrBerserk(itemID, itemRNG, player, flags, slot, vardata)
	if itemID == CollectibleType.COLLECTIBLE_LARYNX
	or itemID == CollectibleType.COLLECTIBLE_BERSERK
	then
		ShouldTriggerEeveeSFX(player)
	end
end

function eeveeBasics:OnSamsonSoul(card, player, useFlags)
	if card == Card.CARD_SOUL_SAMSON then
		ShouldTriggerEeveeSFX(player)
	end
end

function eeveeBasics:FindDeadPlayerEffect(effect)
	local sprite = effect:GetSprite()
	if sprite:GetFilename() == "gfx/001.000_Player.anm2"
	and sprite:IsEventTriggered("DeathSound") then
		local player = effect.SpawnerEntity:ToPlayer()
		ShouldTriggerEeveeSFX(player)
	end
end

function eeveeBasics:PlayHurtSFX(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()
	
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		if dataPlayer.EeveeTriggerSFX or player:GetSprite():IsEventTriggered("DeathSound") then
			for id, eeveesfx in pairs(EEVEEMOD.PlayerSounds[playerType]) do
				if EEVEEMOD.sfx:IsPlaying(id) then
					EEVEEMOD.sfx:Stop(id)
					EEVEEMOD.sfx:Play(eeveesfx, 1, 0, false, 1)
					dataPlayer.EeveeTriggerSFX = nil
				end
			end
		end
	end
end

return eeveeBasics