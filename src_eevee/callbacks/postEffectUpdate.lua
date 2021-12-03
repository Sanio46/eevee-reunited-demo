local postEffectUpdate = {}

local swiftAttack = EEVEEMOD.Src["attacks"]["swift.swiftAttack"]
local swiftBase = EEVEEMOD.Src["attacks"]["swift.swiftBase"]
local eeveeBirthright = EEVEEMOD.Src["items"]["collectibles.eeveeBirthright"]
local eeveeBasics = EEVEEMOD.Src["player"]["eeveeBasics"]

function postEffectUpdate:main(effect)
	if effect.Variant == EffectVariant.SPRITE_TRAIL then
		swiftAttack:SwiftTrailUpdate(effect)
	end
	
	if effect.Variant == EEVEEMOD.EffectVariant.TAIL_WHIP then
		eeveeBirthright:OnEffectUpdate(effect)
	end
	
	if effect.Variant == EffectVariant.DEVIL then
		eeveeBasics:FindDeadPlayerEffect(effect)
	end
	
	if swiftBase:IsSwiftLaserEffect(effect) then
	
		swiftAttack:SwiftAttackUpdate(effect)
		
		if swiftBase:IsSwiftLaserEffect(effect) == "brim" then
			postEffectUpdate:BrimstoneSwirlAnimation(effect)
		elseif swiftBase:IsSwiftLaserEffect(effect) == "tech" then
			postEffectUpdate:TechDotAnimation(effect)
		end
	end
end

function postEffectUpdate:BrimstoneSwirlAnimation(effect)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	end
	if effect.Timeout == 0 then
		sprite:Play("Shoot")
	end
	if sprite:IsFinished("Shoot") then
		effect:Remove()
	end
end

function postEffectUpdate:TechDotAnimation(effect)
	local sprite = effect:GetSprite()
	if effect.Timeout == 0 then
		sprite:Play("Disappear")
	end
	if sprite:IsFinished("Disappear") then
		effect:Remove()
	end
end

return postEffectUpdate