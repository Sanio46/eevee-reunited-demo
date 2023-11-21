local pet = {}
local vee = require("src_eevee.veeHelper")

local petTimer = 9

local function LoadPets(data)
	data.EeveePetSprite = Sprite()
	data.EeveePetSprite:Load("gfx/render_pet.anm2", true)
	data.EeveePetSprite:Play("Idle", true)
end

---@param player EntityPlayer
function pet:IsMouseNearPlayer(player)
	local data = player:GetData()
	local playerType = player:GetPlayerType()

	if EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.MomsHeart.Unlock == true
		and EEVEEMOD.IsPlayerEeveeOrEvolved[playerType]
		and EEVEEMOD.game:GetRoom():IsClear()
		and Options.MouseControl
		and Input.GetMousePosition(true):DistanceSquared(player.Position) <= (25 * player.Size) ^ 2
		and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_RIGHT)
		and not data.EeveeBeingPet
	then
		data.EeveeBeingPet = true
		data.EeveeBeingPetDelay = true
		data.EeveeBeingPetTotalCount = 0
		data.EeveeBeingPetTimer = petTimer
		data.EeveeBeingPetSpriteScale = player.SpriteScale
		if not data.EeveePetSprite then
			LoadPets(data)
		end
		EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SQUEAK)
	end
end

---@param player EntityPlayer
local function StopBeingPet(player)
	local data = player:GetData()
	data.EeveeBeingPet = nil
	data.EeveeBeingPetTotalCount = nil
	data.EeveeBeingPetTimer = nil
	player.SpriteScale = data.EeveeBeingPetSpriteScale
	data.EeveeBeingPetSpriteScale = nil
	data.EeveePetSprite:Stop()
	data.EeveePetSprite = nil
end

---@param player EntityPlayer
function pet:ChangeSpriteScale(player)
	local data = player:GetData()
	if not data.EeveeBeingPet then return end

	if not vee.IsSpritePlayingAnims(player:GetSprite(), vee.WalkAnimations) then
		StopBeingPet(player)
	end

	if data.EeveeBeingPetDelay then
		data.EeveeBeingPetDelay = false
	else
		if data.EeveeBeingPetTotalCount < 12 then
			if data.EeveeBeingPetTimer > 0 then
				data.EeveeBeingPetTimer = data.EeveeBeingPetTimer - 1
				if data.EeveeBeingPetTotalCount % 2 == 0 then
					player.SpriteScale = Vector(player.SpriteScale.X + 0.035, player.SpriteScale.Y - 0.03)
				else
					player.SpriteScale = Vector(player.SpriteScale.X - 0.035, player.SpriteScale.Y + 0.03)
				end
			else
				data.EeveeBeingPetTotalCount = data.EeveeBeingPetTotalCount + 1
				data.EeveeBeingPetTimer = petTimer
				if data.TotalCount < 12 and data.TotalCount % 2 == 0 then
					EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SQUEAK)
				end
			end
		else
			StopBeingPet(player)
		end
	end
end

---@param player EntityPlayer
function pet:RenderPetting(player)
	local data = player:GetData()
	if data.EeveePetSprite then
		local data = player:GetData()
		if not data.EeveeBeingPet then return end
		local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(player.Position)

		data.EeveePetSprite:Render(Vector(screenpos.X, screenpos.Y - 25), Vector.Zero, Vector.Zero)
		data.EeveePetSprite:Update()
	end
end

---@param player EntityPlayer
function pet:OnPlayerUpdate(player)
	pet:IsMouseNearPlayer(player)
	pet:ChangeSpriteScale(player)
end

return pet
