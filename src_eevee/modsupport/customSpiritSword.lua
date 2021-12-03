local customSpiritSword = {}

function customSpiritSword:ReplaceSpiritSwordOnInit(sword)
	local sprite = sword:GetSprite()
	local swordPath = "gfx/effects/spirit_sword_starrod.png"

	if EEVEEMOD.Data.CustomSpiritSword == true then
		if sword.Variant == 11 then
			swordPath = string.gsub(swordPath, "spirit", "tech")
		end
		if sword.SpawnerType == EntityType.ENTITY_PLAYER
		and sword.SpawnerEntity:ToPlayer():GetPlayerType() == EEVEEMOD.PlayerType.EEVEE 
		then
			for i = 0, 4 do
				sprite:ReplaceSpritesheet(i, swordPath)
			end
			sprite:LoadGraphics()
		end
	end
end

return customSpiritSword