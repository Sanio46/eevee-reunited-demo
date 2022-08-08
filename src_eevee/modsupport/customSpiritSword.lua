local customSpiritSword = {}

function customSpiritSword:ReplaceSpiritSwordOnInit(sword)
	local sprite = sword:GetSprite()
	local swordPath = "gfx/effects/spirit_sword_starrod.png"

	if sword.Variant == VeeHelper.KnifeVariant.TECH_SWORD then
		swordPath = string.gsub(swordPath, "spirit", "tech")
	end

	if sword.SpawnerEntity
		and sword.SpawnerEntity:ToPlayer()
		and sword.SpawnerEntity:ToPlayer():GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
		and sword.SpawnerEntity:ToPlayer():HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
	then
		for i = 0, 4 do
			sprite:ReplaceSpritesheet(i, swordPath)
		end
		sprite:LoadGraphics()
	end
end

return customSpiritSword
