local postRender = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]
local rgbCycle = EEVEEMOD.Src["misc"]["rgbCycle"]

function postRender:main()
	rgbCycle:onRender()
	swiftAttack:onRender()
	--[[for _, e in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DEVIL, 0)) do
		local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(e.Position)
		Isaac.RenderText(tostring(e.Type..", "..e.Variant..", "..e.SubType), screenpos.X, screenpos.Y - 30, 1, 1, 1, 1)
	end]]
end

return postRender