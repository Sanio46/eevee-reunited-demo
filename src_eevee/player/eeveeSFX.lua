local eeveeSFX = {}

---@param player EntityPlayer
local function ShouldTriggerEeveeSFX(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		data.EeveeTriggerSFX = true
	end
end

---@param player EntityPlayer
function eeveeSFX:EeveeOnHit(player, _, _, _, _)
	ShouldTriggerEeveeSFX(player)
end

---@param player EntityPlayer
function eeveeSFX:OnLarynxOrBerserk(_, _, player, _, _, _)
	ShouldTriggerEeveeSFX(player)
end

---@param player EntityPlayer
function eeveeSFX:OnSamsonSoul(card, player, _)
	if card == Card.CARD_SOUL_SAMSON then
		ShouldTriggerEeveeSFX(player)
	end
end

---@param effect EntityEffect
function eeveeSFX:FindDeadPlayerEffect(effect)
	local sprite = effect:GetSprite()
	if sprite:GetFilename() == "gfx/001.000_Player.anm2"
		and sprite:IsEventTriggered("DeathSound") then
		---@type EntityPlayer
		local player = effect.SpawnerEntity:ToPlayer()
		ShouldTriggerEeveeSFX(player)
	end
end

---@param player EntityPlayer
function eeveeSFX:PlayHurtSFX(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then
		if data.EeveeTriggerSFX or player:GetSprite():IsEventTriggered("DeathSound") then
			for id, sfx in pairs(EEVEEMOD.PlayerSounds[playerType]) do
				if EEVEEMOD.sfx:IsPlaying(id) then
					EEVEEMOD.sfx:Stop(id)
					if EEVEEMOD.PERSISTENT_DATA.ClassicVoice == true then
						sfx = sfx + 1 --Classic sounds are made directly in front of the original sounds
						EEVEEMOD.sfx:Play(sfx, 5)
					else
						EEVEEMOD.sfx:Play(sfx)
					end
					data.EeveeTriggerSFX = nil
				end
			end
		end
	end
end

return eeveeSFX
