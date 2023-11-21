local vee = require("src_eevee.VeeHelper")
local customSpiritSword = {}

---@param knife EntityKnife
function customSpiritSword:ReplaceSpiritSwordOnInit(knife)
	if knife.Variant ~= vee.KnifeVariant.SPIRIT_SWORD and knife.Variant ~= vee.KnifeVariant.TECH_SWORD then return end
	local sprite = knife:GetSprite()
	local swordPathPng = "gfx/effects/sword_eevee.png"
	local swordPathAnm2 = "gfx/sword_eevee.anm2"

	if knife.Variant == vee.KnifeVariant.TECH_SWORD then
		swordPathAnm2 = string.gsub(swordPathAnm2, ".anm2", "_tech.anm2")
		swordPathPng = string.gsub(swordPathAnm2, ".png", "_tech.png")
	end

	if knife.SpawnerEntity
		and knife.SpawnerEntity:ToPlayer()
		and knife.SpawnerEntity:ToPlayer():GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
		and knife.SpawnerEntity:ToPlayer():HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)
	then
		if knife.SubType == 4 then --Sword woosh
			sprite:ReplaceSpritesheet(1, swordPathPng)
			sprite:ReplaceSpritesheet(2, swordPathPng)
			sprite:LoadGraphics()
		elseif knife.SubType == 0 then --Regular sword
			sprite:Load(swordPathAnm2, true)
			sprite:ReplaceSpritesheet(1, "gfx/blank.png")
			sprite:ReplaceSpritesheet(2, "gfx/blank.png")
			sprite:LoadGraphics()
		end
	end
end

return customSpiritSword
