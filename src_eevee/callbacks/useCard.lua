local useCard = {}

local eeveeSFX = EEVEEMOD.Src["player"]["eeveeSFX"]

function useCard:main(card, player, useFlags)
	if card == Card.CARD_SOUL_SAMSON then
		eeveeSFX:OnSamsonSoul(card, player, useFlags)
	end
end

return useCard