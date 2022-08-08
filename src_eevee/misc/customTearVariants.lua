local customTearVariants = {}

local ChangedVariants = {
	[TearVariant.BELIAL] = true,
	--[VeeHelper.TearVariant.FETUS] = true,
}

local tearSpritePath = {
	[TearVariant.BELIAL] = "gfx/tears/tear_belial.png",
	--[VeeHelper.TearVariant.FETUS] = "gfx/tears/tear_fetus_",
}

function customTearVariants:OnCustomTearUpdate(tear)
	if not tear.SpawnerEntity or not tear.SpawnerEntity:ToPlayer() or not ChangedVariants[tear.Variant] then
		return
	end

	local player = tear.SpawnerEntity:ToPlayer()
	local playerType = player:GetPlayerType()
	if not EEVEEMOD.IsPlayerEeveeOrEvolved[playerType] then return end
	local sprite = tear:GetSprite()
	local spritePath = tearSpritePath[tear.Variant]
	if not tear:GetData().CustomEeveeTearVariant then
		--[[ if tear.Variant == VeeHelper.TearVariant.FETUS then
			spritePath = spritePath .. EEVEEMOD.PlayerTypeToString[playerType] .. VeeHelper.SkinColor(player, false) .. ".png"
			local animToPlay = sprite:GetAnimation()
			sprite:Load("tears_fetus_eevee.anm2", true)
			sprite:ReplaceSpritesheet(0, spritePath)
			sprite:LoadGraphics()
			sprite:Play(animToPlay) ]]
		--else
			sprite:ReplaceSpritesheet(1, spritePath)
			sprite:ReplaceSpritesheet(0, spritePath)
			sprite:LoadGraphics()
		--end
		tear:GetData().CustomEeveeTearVariant = true
	end
end

return customTearVariants
