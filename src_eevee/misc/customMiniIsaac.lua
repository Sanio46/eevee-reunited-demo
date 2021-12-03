local miniIsaac = {}

function miniIsaac:onMiniInit(minivee)
	local player = minivee.Player
	local playerType = player:GetPlayerType()
	
	if EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] ~= nil then
		local miniPath = "gfx/familiar/familiar_mini"
		local sprite = minivee:GetSprite()
		local currentAnim = sprite:GetAnimation()
		
		sprite:Load("gfx/familiar_minieevee.anm2", true)
		sprite:Play(currentAnim, true)
		sprite:ReplaceSpritesheet(0, miniPath..EEVEEMOD.PlayerTypeToString[playerType]..".png")
		sprite:ReplaceSpritesheet(1, miniPath..EEVEEMOD.PlayerTypeToString[playerType]..".png")
		sprite:LoadGraphics()
	end
end

return miniIsaac