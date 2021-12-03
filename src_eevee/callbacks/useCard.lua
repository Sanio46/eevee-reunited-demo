local useCard = {}

local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]

function useCard:main(card, player, useFlags)
	if card == Card.CARD_SOUL_SAMSON then
		eeveeBasics:OnSamsonSoul(card, player, useFlags)
	end
end

return useCard