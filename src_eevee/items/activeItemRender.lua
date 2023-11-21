local activeItemRender = {}
local vee = require("src_eevee.veeHelper")

local function GetScreenBottomRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 16, -hudOffset * 6)

	return Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + offset
end

local function GetScreenBottomLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 22, -hudOffset * 6)

	return Vector(0, Isaac.GetScreenHeight()) + offset
end

local function GetScreenTopRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 24, hudOffset * 12)

	return Vector(Isaac.GetScreenWidth(), 0) + offset
end

local function GetScreenTopLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 20, hudOffset * 12)

	return Vector.Zero + offset
end

---@type table<integer, {ScreenPos: function, Offset: table<ActiveSlot, Vector>}>
local ActivePositions = {
	[1] = {
		ScreenPos = function() return GetScreenTopLeft() end,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(4, 0),
			[ActiveSlot.SLOT_SECONDARY] = Vector(-5, 0),
		}
	},
	[2] = {
		ScreenPos = function() return GetScreenTopRight() end,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(-155, 0),
			[ActiveSlot.SLOT_SECONDARY] = Vector(-164, 0),
		}
	},
	[3] = {
		ScreenPos = function() return GetScreenBottomLeft() end,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(14, -39),
			[ActiveSlot.SLOT_SECONDARY] = Vector(5, -39)
		}
	},
	[4] = {
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(-36, -39),
			[ActiveSlot.SLOT_SECONDARY] = Vector(-10, -39),
		},
		ScreenPos = function() return GetScreenBottomRight() end,
	}
}

---@param player EntityPlayer
local function GetCookieFrame(player)
	local numCookieEffects = player:GetEffects():GetCollectibleEffectNum(EEVEEMOD.CollectibleType.COOKIE_JAR)
	local cookieFrame = 5 - numCookieEffects
	if cookieFrame < 0 then cookieFrame = 0 end
	return cookieFrame
end

---@type table<CollectibleType, {Sprite: Sprite, Directory: string, StartFrame: integer, UpdatedFrame: function, Condition?: function}>
local activesToRender = {
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = {
		Sprite = EEVEEMOD.Sprite.EggOutline,
		Directory = "gfx/render_strangeegg_outline.anm2",
		StartFrame = 0,
		UpdatedFrame = function(player) return vee.GetBookState(player) end,
		Condition = function(player, activeSlot)
			local charge = player:GetActiveCharge(activeSlot)
			return charge > 0 and charge < 3
		end
	},
	[EEVEEMOD.CollectibleType.COOKIE_JAR] = {
		Sprite = EEVEEMOD.Sprite.CookieJar,
		Directory = "gfx/render_cookiejar_count.anm2",
		StartFrame = 5,
		UpdatedFrame = function(player) return GetCookieFrame(player) end
	}
}

for _, params in pairs(activesToRender) do
	params.Sprite:Load(params.Directory, true)
	params.Sprite:Play(params.Sprite:GetDefaultAnimation(), true)
	params.Sprite:SetFrame(params.Sprite:GetDefaultAnimation(), params.StartFrame)
end

function activeItemRender:RenderActiveItem()
	local players = vee.GetAllMainPlayers()
	if players[1]
	and players[1]:GetOtherTwin()
	and players[1]:GetOtherTwin():GetPlayerType() == PlayerType.PLAYER_ESAU
	then
		players[4] = players[1]:GetOtherTwin()
	end
	players = {
		{players[1]},
		{players[2]},
		{players[3]},
		{players[4]},
	}
	
	for i, almostPlayer in ipairs(players) do
		local activeItemPos = ActivePositions[i]
		local player = almostPlayer[1]
		if player and player.FrameCount > 0 and EEVEEMOD.game:GetHUD():IsVisible() then
			for itemID, params in pairs(activesToRender) do
				if player:HasCollectible(itemID) then
					local slots = vee.GetActiveSlots(player, itemID)
					for k = 1, #slots do
						if ((params.Condition == nil) or (params.Condition ~= nil and params.Condition(player, slots[k]) == true)) then
							local pos = activeItemPos.ScreenPos() +
								(activeItemPos.Offset[slots[k]] or activeItemPos.Offset[slots[0]])
							local size = slots[k] == ActiveSlot.SLOT_PRIMARY and 1 or 0.5
							local bookOffset = slots[k] == ActiveSlot.SLOT_PRIMARY and vee.GetBookState(player) > 0 and
								-4 or 0
							params.Sprite:SetFrame(params.UpdatedFrame(player))
							params.Sprite.Scale = Vector(size, size)
							params.Sprite:Render(Vector(pos.X, pos.Y + bookOffset), Vector.Zero, Vector.Zero)
						end
					end
				end
			end
		end
	end
end

function activeItemRender:OnRender()
	activeItemRender:RenderActiveItem()
end

function activeItemRender:ResetOnGameStart()
	for i = 1, 4 do
		ActivePositions[i].Player = nil
	end
end

return activeItemRender