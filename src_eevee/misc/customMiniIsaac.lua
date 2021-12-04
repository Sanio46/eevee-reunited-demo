local miniIsaac = {}

function miniIsaac:onMiniInit(minivee)
	local player = minivee.Player
	local playerType = player:GetPlayerType()
	
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] ~= nil then
		local miniPath = "gfx/familiar/familiar_mini"..EEVEEMOD.PlayerTypeToString[playerType]..EEVEEMOD.API.SkinColor(player, true)..".png"
		local sprite = minivee:GetSprite()
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