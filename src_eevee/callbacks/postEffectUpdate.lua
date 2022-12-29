local postEffectUpdate = {}

local eeveeSFX = require("src_eevee.player.eeveeSFX")
local pokeball = require("src_eevee.items.pickups.pokeball")
local swiftAttack = require("src_eevee.attacks.eevee.swiftAttack")
local swiftBase = require("src_eevee.attacks.eevee.swiftBase")
local wonderousLauncher = require("src_eevee.items.collectibles.wonderousLauncher")
local triggerOnFire = require("src_eevee.items.triggerOnFire")
local lockOnSpecs = require("src_eevee.items.trinkets.lockOnSpecs")
local badEgg = require("src_eevee.items.collectibles.badEgg")
local shinyCharm = require("src_eevee.items.collectibles.shinyCharm")

function postEffectUpdate:main(effect)

	if swiftBase:IsSwiftLaserEffect(effect) then
		swiftAttack:SwiftAttackUpdate(effect)
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

function postEffectUpdate:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postEffectUpdate.main)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, swiftAttack.SwiftTrailUpdate, EffectVariant.SPRITE_TRAIL)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, pokeball.PokeballEffectUpdate,
		EEVEEMOD.EffectVariant.POKEBALL)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, eeveeSFX.FindDeadPlayerEffect, EffectVariant.DEVIL)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, wonderousLauncher.FireHandling,
		EEVEEMOD.EffectVariant.WONDEROUS_LAUNCHER)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postEffectUpdate.TechDotAnimation,
		EEVEEMOD.EffectVariant.CUSTOM_TECH_DOT)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postEffectUpdate.BrimstoneSwirlAnimation,
		EEVEEMOD.EffectVariant.CUSTOM_BRIMSTONE_SWIRL)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, lockOnSpecs.DestroySpecsPickup,
		EEVEEMOD.EffectVariant.LOCKON_SPECS_DROP)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, triggerOnFire.OnTargetEffectUpdate, EffectVariant.TARGET)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, badEgg.RemoveGlitchOnAnimEnd,
		EEVEEMOD.EffectVariant.BAD_EGG_GLITCH)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, shinyCharm.ShinyParticleEffectUpdate,
		EEVEEMOD.EffectVariant.SHINY_SPARKLE)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, swiftAttack.RemoveAntiGravPlaceholder,
		EEVEEMOD.EffectVariant.ANTI_GRAV_PARENT)
end

return postEffectUpdate
