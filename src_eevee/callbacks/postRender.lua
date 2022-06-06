local postRender = {}

local earbuds = require("src_eevee.items.collectibles.hiTechEarbuds")
local rgbCycle = require("src_eevee.misc.rgbCycle")
local activeItemRender = require("src_eevee.items.activeItemRender")
local sewingMachine = require("src_eevee.modsupport.sewingMachine")

function postRender:main()
	rgbCycle:onRender()
	earbuds:RenderVolumeBar()
	activeItemRender:OnRender()
	--postRender:ItemSwap()
	if Sewn_API then
		sewingMachine:LevelBarOnRender()
	end
	--[[ postRender:RecordPlayingSounds()
 	postRender:RenderText() ]]
	--[[ local players = VeeHelper.GetAllPlayers()
  for i = 1, #players do
	local player = players[i]
	local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(player.Position)
	local data = player:GetData()
	local ID = data.Identifier
	if EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps then
	   for i = 1, #EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps do
		Isaac.RenderText(EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps[i], 50, 40 + (10 * i), 1, 1, 1, 1)
	  end
	end
  end ]]
	--[[ for _, e in pairs(Isaac.GetRoomEntities()) do
		local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(e.Position)
		Isaac.RenderText(e.Type..", "..e.Variant, screenpos.X, screenpos.Y + 20, 1, 1, 1, 1)
	end ]]
	--[[ for _, e in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, EEVEEMOD.EffectVariant.LIL_EEVEE)) do
		local familiar = e:ToFamiliar()
		local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(familiar.Position)
		if EEVEEMOD.PERSISTENT_DATA.LilEeveeData[familiar.InitSeed] then
			Isaac.RenderText("Level: "..EEVEEMOD.PERSISTENT_DATA.LilEeveeData[familiar.InitSeed].Super.Level, screenpos.X - 10, screenpos.Y - 100, 1, 1, 1, 1)
			Isaac.RenderText("CurrentXP: "..EEVEEMOD.PERSISTENT_DATA.LilEeveeData[familiar.InitSeed].Super.Exp.CurAmount, screenpos.X - 13, screenpos.Y - 80, 1, 1, 1, 1)
			Isaac.RenderText("XP To Gain: "..EEVEEMOD.PERSISTENT_DATA.LilEeveeData[familiar.InitSeed].Super.Exp.Stored, screenpos.X - 15, screenpos.Y - 60, 1, 1, 1, 1)
			Isaac.RenderText("XP To Reach: "..EEVEEMOD.PERSISTENT_DATA.LilEeveeData[familiar.InitSeed].Super.Exp.ForNextLevel, screenpos.X - 16, screenpos.Y - 40, 1, 1, 1, 1)
		end
	end ]]
end

local KeyDelayStatic = 10
local KeyDelay
local currentItem = 1

function postRender:ItemSwap()
	local player = Isaac.GetPlayer()
	local index = player.ControllerIndex

	if not KeyDelay and (Input.IsButtonPressed(Keyboard.KEY_L, index) or Input.IsButtonPressed(Keyboard.KEY_J, index)) then
		local itemConfig = Isaac.GetItemConfig()
		if Input.IsButtonPressed(Keyboard.KEY_L, index) then
			currentItem = currentItem + 1
			while itemConfig:GetCollectible(currentItem) == nil do
				currentItem = currentItem + 1
			end
		elseif Input.IsButtonPressed(Keyboard.KEY_J, index) then
			currentItem = currentItem - 1
			while itemConfig:GetCollectible(currentItem) == nil do
				currentItem = currentItem + 1
			end
		end
		KeyDelay = KeyDelayStatic
	end
	if not player:HasCollectible(currentItem) then
		local lastItem = currentItem + 1
		local nextItem = currentItem - 1
		if currentItem or lastItem <= 0 then currentItem = 1
			lastItem = 1
		end
		player:RemoveCollectible(lastItem)
		player:RemoveCollectible(nextItem)
		player:AddCollectible(currentItem)
	end
	if KeyDelay then
		if KeyDelay > 0 then
			KeyDelay = KeyDelay - 1
		else
			KeyDelay = nil
		end
	end
end

function postRender:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_RENDER, postRender.main)
end

-- Constants
local TEXT_X = 60
local TEXT_Y = 90
local WHITE = KColor(1, 1, 1, 1)

-- Mod variables
local messageArray = {}
local font = Font()
font:Load("font/terminus.fnt")
local lineHeight = font:GetLineHeight()
local sfxManager = SFXManager()

-- From: https://stackoverflow.com/questions/33510736
local function includes(t, val)
	for index, value in ipairs(t) do
		if value == val then
			return true
		end
	end

	return false
end

local function pushMessageArray(msg)
	messageArray[#messageArray + 1] = msg
	if #messageArray > 10 then
		-- We only want to show 10 messages at a time
		-- Remove the first elemenent
		table.remove(messageArray, 1)
	end
end

function postRender:RecordPlayingSounds()
	for soundEffectName, soundEffect in pairs(SoundEffect) do
		if sfxManager:IsPlaying(soundEffect) then
			local message = tostring(soundEffect) .. " - " .. soundEffectName
			if not includes(messageArray, message) then
				pushMessageArray(message)
			end
		end
	end
end

function postRender:RenderText()
	for i, msg in ipairs(messageArray) do
		font:DrawStringUTF8(
			msg,
			TEXT_X,
			TEXT_Y + ((i - 1) * lineHeight),
			WHITE,
			0,
			true
		)
	end
end

return postRender
