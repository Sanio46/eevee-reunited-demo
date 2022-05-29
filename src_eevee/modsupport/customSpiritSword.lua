local customSpiritSword = {}

---@param knife EntityKnife
function customSpiritSword:ReplaceSpiritSwordOnInit(knife)
	local sprite = knife:GetSprite()
	local swordPath = "gfx/effects/spirit_sword_starrod.png"

	if knife.Variant == VeeHelper.KnifeVariant.TECH_SWORD then
		swordPath = string.gsub(swordPath, "spirit", "tech")
	end

	if knife.SpawnerEntity
		and knife.SpawnerEntity:ToPlayer()
		and knife.SpawnerEntity:ToPlayer():GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
		and knife.SpawnerEntity:ToPlayer():HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
	then
		for i = 0, 4 do
			sprite:ReplaceSpritesheet(i, swordPath)
		end
		sprite:LoadGraphics()
	end
end

return customSpiritSword
