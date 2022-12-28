local earbuds = {}

--Apparently, Options.SFXVolume can't be changed directly. Code commented out alongside the item in case it does ever work again.

local volumeBar = Sprite()
local volumeSlider = Sprite()

---@param player EntityPlayer
function earbuds:LoadVolumeBar(player)
	--[[  if player:HasCollectible(EEVEEMOD.CollectibleType.HI_TECH_EARBUDS)
	and (not volumeBar:IsLoaded() or not volumeSlider:IsLoaded())
	then
		volumeBar:Load("gfx/ui/hitech_volumebar.anm2", true)
		volumeSlider:Load("gfx/ui/hitech_volumebar.anm2", true)
		volumeBar:Play("VolumeBar", true)
		volumeSlider:Play("VolumeSlider", true)
	end ]]
end

function earbuds:RenderVolumeBar()
	--[[  if volumeBar:IsLoaded() and volumeSlider:IsLoaded() then
		volumeBar:Render(Vector.Zero, Vector.Zero, Vector.Zero)
		volumeSlider:Render(Vector(Options.SFXVolume * 166, 0), Vector.Zero, Vector.Zero)

		if Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) then
			if Input.IsButtonPressed(Keyboard.KEY_KP_ADD, 0) and Options.SFXVolume ~= 1 then
				Options.SFXVolume = Options.SFXVolume + 0.1
				EEVEEMOD.sfx:Play(SoundEffect.SOUND_PLOP)
			end
			if Input.IsButtonPressed(Keyboard.KEY_KP_SUBTRACT, 0) and Options.SFXVolume ~= 0 then
				Options.SFXVolume = Options.SFXVolume - 0.1
				EEVEEMOD.sfx:Play(SoundEffect.SOUND_PLOP)
			end
		end
	end ]]
end

return earbuds
