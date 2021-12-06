local eeveeSFX = {}

local function ShouldTriggerEeveeSFX(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		dataPlayer.EeveeTriggerSFX = true
	end
end

function eeveeSFX:EeveeOnHurt(ent, amount, flags, source, countdown)
	local player = ent:ToPlayer()
	ShouldTriggerEeveeSFX(player)
end

function eeveeSFX:OnLarynxOrBerserk(itemID, itemRNG, player, flags, slot, vardata)
	if itemID == CollectibleType.COLLECTIBLE_LARYNX
	or itemID == CollectibleType.COLLECTIBLE_BERSERK
	then
		ShouldTriggerEeveeSFX(player)
	end
end

function eeveeSFX:OnSamsonSoul(card, player, useFlags)
	if card == Card.CARD_SOUL_SAMSON then
		ShouldTriggerEeveeSFX(player)
	end
end

function eeveeSFX:FindDeadPlayerEffect(effect)
	local sprite = effect:GetSprite()
	if sprite:GetFilename() == "gfx/001.000_Player.anm2"
	and sprite:IsEventTriggered("DeathSound") then
		local player = effect.SpawnerEntity:ToPlayer()
		ShouldTriggerEeveeSFX(player)
	end
end

function eeveeSFX:PlayHurtSFX(player)
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

return eeveeSFX
