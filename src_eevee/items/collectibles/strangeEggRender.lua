local strangeEggRender = {}

local function GetBottomRightNoOffset()
	return EEVEEMOD.game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442, 286)
end

local function GetBottomLeftNoOffset()
	return Vector(0, GetBottomRightNoOffset().Y)
end

local function GetTopRightNoOffset()
	return Vector(GetBottomRightNoOffset().X, 0)
end

local function GetTopLeftNoOffset()
	return Vector.Zero
end

local function GetScreenBottomRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 16, -hudOffset * 6)

	return GetBottomRightNoOffset() + offset
end

local function GetScreenBottomLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 20, -hudOffset * 12)

	return GetBottomLeftNoOffset() + offset
end

local function GetScreenTopRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 20, hudOffset * 12)

	return GetTopRightNoOffset() + offset
end

local function GetScreenTopLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 20, hudOffset * 12)

	return GetTopLeftNoOffset() + offset
end

local EggPlayers = {
	[1] = {
		Player = nil,
		Offset = Vector(4, 0),
		ScreenPos = function() return GetScreenTopLeft() end,
	},
	[2] = {
		Player = nil,
		Offset = Vector(-159, 0),
		ScreenPos = function() return GetScreenTopRight() end,
	},
	[3] = {
		Player = nil,
		Offset = Vector(16, -33),
		ScreenPos = function() return GetScreenBottomLeft() end,
	},
	[4] = {
		Player = nil,
		Offset = Vector(-36, -39),
		ScreenPos = function() return GetScreenBottomRight() end,
	}
}

local function AddEggPlayers(i, player)
	local curCharges = VeeHelper.GetActiveItemCharges(player, EEVEEMOD.CollectibleType.STRANGE_EGG)

	for j = 1, #curCharges do
		if curCharges[j] > 0 and curCharges[j] < 3 then
			EggPlayers[i].Player = player
		end
	end

	if i == 1
		and player:GetOtherTwin() ~= nil
		and player:GetOtherTwin():GetPlayerType() == PlayerType.PLAYER_ESAU
		and EggPlayers[4].Player == nil then
		local curCharges = VeeHelper.GetActiveItemCharges(player:GetOtherTwin(), EEVEEMOD.CollectibleType.STRANGE_EGG)
		for j = 1, #curCharges do
			if curCharges[j] > 0 and curCharges[j] < 3 then
				EggPlayers[4].Player = player
			end
		end
	end
end

local numHUDPlayers = 1

function strangeEggRender:UpdatePlayers()
	local players = VeeHelper.GetAllMainPlayers()

	if #players ~= numHUDPlayers then
		numHUDPlayers = #players
		for i = 1, 4 do
			EggPlayers[i].Player = nil
		end
	end

	for i = 1, #players do
		if i > 4 then break end

		local player = players[i]

		if player:HasCollectible(EEVEEMOD.CollectibleType.STRANGE_EGG)
			and EggPlayers[i].Player == nil
		then
			AddEggPlayers(i, player)
		elseif not player:HasCollectible(EEVEEMOD.CollectibleType.STRANGE_EGG)
			and EggPlayers[i].Player ~= nil then
			EggPlayers[i].Player = nil
		end
	end
end

local function GetBookFrame(player)
	local hasVirtues = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
	local hasBelial = VeeHelper.IsJudasBirthrightActive(player)
	local verdict = (hasVirtues and hasBelial) and 2 or (hasVirtues or hasBelial) and 1 or 0

	return verdict
end

function strangeEggRender:ShowItemOutline()
	for i = 1, #EggPlayers do
		local eggPlayer = EggPlayers[i]

		if not EEVEEMOD.Sprite.EggOutline:IsLoaded() then
			EEVEEMOD.Sprite.EggOutline:Load("gfx/render_strangeegg_outline.anm2", true)
			EEVEEMOD.Sprite.EggOutline:Play("Outline", true)
			EEVEEMOD.Sprite.EggOutline:SetFrame("Outline", 1)
		end

		if EEVEEMOD.Sprite.EggOutline:IsLoaded()
			and eggPlayer
			and eggPlayer.Player ~= nil
			and EEVEEMOD.game:GetHUD():IsVisible()
		then
			local pos = eggPlayer.ScreenPos() + eggPlayer.Offset
			local slots = VeeHelper.GetActiveSlots(eggPlayer.Player, EEVEEMOD.CollectibleType.STRANGE_EGG)
			for j = 1, #slots do
				local slotOffset = slots[j] == ActiveSlot.SLOT_SECONDARY and (i == 4 and 26 or -9) or 0
				local size = slots[j] == ActiveSlot.SLOT_SECONDARY and 0.5 or 1
				local bookFrame = slots[j] == ActiveSlot.SLOT_PRIMARY and GetBookFrame(eggPlayer.Player) or 0

				EEVEEMOD.Sprite.EggOutline:SetFrame(bookFrame)
				EEVEEMOD.Sprite.EggOutline.Scale = Vector(size, size)
				EEVEEMOD.Sprite.EggOutline:Render(Vector(pos.X + slotOffset, pos.Y), Vector.Zero, Vector.Zero)
			end
		end
	end
end

function strangeEggRender:OnRender()
	strangeEggRender:UpdatePlayers()
	strangeEggRender:ShowItemOutline()
end

function strangeEggRender:ResetOnGameStart()
	for i = 1, 4 do
		EggPlayers[i].Player = nil
	end
end

return strangeEggRender
