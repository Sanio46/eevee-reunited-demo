local activeItemRender = {}

local function GetScreenBottomRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 16, -hudOffset * 6)

	return Vector(Isaac.GetScreenWidth(), -1 * Isaac.GetScreenHeight()) + offset
end

local function GetScreenBottomLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 20, -hudOffset * 12)

	return Vector(0, -1 * Isaac.GetScreenHeight()) + offset
end

local function GetScreenTopRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 20, hudOffset * 12)

	return Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + offset
end

local function GetScreenTopLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 20, hudOffset * 12)

	return Vector.Zero + offset
end

---@param player EntityPlayer
function GetCookieFrame(player)
	local numCookieEffects = player:GetEffects():GetCollectibleEffectNum(EEVEEMOD.CollectibleType.COOKIE_JAR)
	local cookieFrame = 5 - numCookieEffects
	if cookieFrame < 0 then cookieFrame = 0 end
	return cookieFrame
end

---@type table<integer, {Player: EntityPlayer, ScreenPos: function, Offset: table<ActiveSlot, Vector>}>
local IndexedPlayers = {
	[1] = {
		Player = nil,
		ScreenPos = function() return GetScreenTopLeft() end,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(4, 0),
			[ActiveSlot.SLOT_SECONDARY] = Vector(-5, 0),
		}
	},
	[2] = {
		Player = nil,
		ScreenPos = function() return GetScreenTopRight() end,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(-159, 0),
			[ActiveSlot.SLOT_SECONDARY] = Vector(-168, 0),
		}
	},
	[3] = {
		Player = nil,
		ScreenPos = function() return GetScreenBottomLeft() end,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(16, -33),
			[ActiveSlot.SLOT_SECONDARY] = Vector(7, -33)
		}
	},
	[4] = {
		Player = nil,
		Offset = {
			[ActiveSlot.SLOT_PRIMARY] = Vector(-36, -39),
			[ActiveSlot.SLOT_SECONDARY] = Vector(-10, -39),
		},
		ScreenPos = function() return GetScreenBottomRight() end,
	}
}

local function AddActivePlayers(i, player)

	IndexedPlayers[i].Player = player

	if i == 1
		and player:GetOtherTwin() ~= nil
		and player:GetOtherTwin():GetPlayerType() == PlayerType.PLAYER_ESAU
		and IndexedPlayers[4].Player == nil then
		IndexedPlayers[4].Player = player
	end
end

local numHUDPlayers = 1

---@type table<CollectibleType, {Sprite: Sprite, Directory: string, StartFrame: integer, UpdatedFrame: function, Condition?: function}>
local activesToRender = {
	[EEVEEMOD.CollectibleType.STRANGE_EGG] = {
		Sprite = EEVEEMOD.Sprite.EggOutline,
		Directory = "gfx/render_strangeegg_outline.anm2",
		StartFrame = 0,
		UpdatedFrame = function(player) return VeeHelper.GetBookState(player) end,
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

function activeItemRender:UpdatePlayers()
	local players = VeeHelper.GetAllMainPlayers()

	if #players ~= numHUDPlayers then
		numHUDPlayers = #players
		for i = 1, 4 do
			IndexedPlayers[i].Player = nil
		end
	end

	for i = 1, #players do
		if i > 4 then break end

		local player = players[i]

		if IndexedPlayers[i].Player == nil then
			AddActivePlayers(i, player)
		end
	end
end

local function LoadItemSprites()
	for _, params in pairs(activesToRender) do
		params.Sprite:Load(params.Directory, true)
		params.Sprite:Play(params.Sprite:GetDefaultAnimation(), true)
		params.Sprite:SetFrame(params.Sprite:GetDefaultAnimation(), params.StartFrame)
	end
end

local hasLoadedItems = false

function activeItemRender:RenderActiveItem()
	for i = 1, #IndexedPlayers do
		local activeItemPlayer = IndexedPlayers[i]
		
		if hasLoadedItems == false then
			LoadItemSprites()
			hasLoadedItems = true
		elseif activeItemPlayer
			and activeItemPlayer.Player ~= nil
			and EEVEEMOD.game:GetHUD():IsVisible()
		then
			local player = activeItemPlayer.Player

			for itemID, params in pairs(activesToRender) do
				if player:HasCollectible(itemID) then
					local slots = VeeHelper.GetActiveSlots(player, itemID)
					for k = 1, #slots do
						if ((params.Condition == nil) or (params.Condition ~= nil and params.Condition(player, slots[k]) == true)) then
							local pos = activeItemPlayer.ScreenPos() + (activeItemPlayer.Offset[slots[k]] or activeItemPlayer.Offset[slots[0]])
							local size = slots[k] == ActiveSlot.SLOT_PRIMARY and 1 or 0.5
							local bookOffset = slots[k] == ActiveSlot.SLOT_PRIMARY and VeeHelper.GetBookState(player) > 0 and -4 or 0
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
	activeItemRender:UpdatePlayers()
end

function activeItemRender:ResetOnGameStart()
	for i = 1, 4 do
		IndexedPlayers[i].Player = nil
	end
end

return activeItemRender
