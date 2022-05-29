local miniIsaac = {}

---@param familiar EntityFamiliar
function miniIsaac:onMiniInit(familiar)
	local player = familiar.Player
	local playerType = player:GetPlayerType()

	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] ~= nil then
		local miniPath = "gfx/familiar/familiar_mini" .. EEVEEMOD.PlayerTypeToString[playerType] .. VeeHelper.SkinColor(player, true) .. ".png"
		local sprite = familiar:GetSprite()
		local currentAnim = sprite:GetAnimation()

		sprite:Load("gfx/familiar_minieevee.anm2", true)
		sprite:Play(currentAnim, true)
		for i = 0, 1 do
			sprite:ReplaceSpritesheet(i, miniPath)
		end
		sprite:LoadGraphics()
	end
end

return miniIsaac
