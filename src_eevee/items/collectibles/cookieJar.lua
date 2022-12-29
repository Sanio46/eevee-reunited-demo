local cookieJar = {}

---@param player EntityPlayer
local function IsFat(player)
	local fatty = false

	local items = {
		CollectibleType.COLLECTIBLE_BUCKET_OF_LARD,
		CollectibleType.COLLECTIBLE_BINGE_EATER,
		CollectibleType.COLLECTIBLE_JUPITER,
		CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION,
		CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION
	}
	for i = 1, #items do
		if player:HasCollectible(items[i]) then
			fatty = true
		end
	end
	return fatty
end

---@param player EntityPlayer
local function UpdateCookieSpeedData(player)
	local ID = player:GetData().Identifier
	if EEVEEMOD.PERSISTENT_DATA.PlayerData[ID]
		and EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed
		and player.MoveSpeed >= 0.2
		and not IsFat(player)
	then
		EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed = EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed - 0.2
	end
end

local MAX_COOKIE_USES = 6

---@param player EntityPlayer
function cookieJar:onUse(_, _, player, _, _, _)
	local effects = player:GetEffects()
	local shouldRemove = false

	player:AddHearts(2)

	if effects:GetCollectibleEffectNum(EEVEEMOD.CollectibleType.COOKIE_JAR) == MAX_COOKIE_USES - 1 then
		shouldRemove = true
		player:AddMaxHearts(4, true)
		player:AddHearts(2)
	end

	EEVEEMOD.sfx:Play(SoundEffect.SOUND_VAMP_GULP)
	UpdateCookieSpeedData(player)
	player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	player:EvaluateItems()

	return {Discharge = false, Remove = shouldRemove, ShowAnim = true}
end

---@param player EntityPlayer
---@param itemStats ItemStats
function cookieJar:Stats(player, itemStats)
	local ID = player:GetData().Identifier

	if EEVEEMOD.PERSISTENT_DATA.PlayerData[ID]
		and EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed
	then
		itemStats.SPEED = itemStats.SPEED + EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed
	end
end

---@param player EntityPlayer
function cookieJar:SpeedUpdate(player)
	local data = player:GetData()
	local cookieSpeedDelay = 30
	local ID = player:GetData().Identifier

	if player:GetEffects():GetCollectibleEffectNum(EEVEEMOD.CollectibleType.COOKIE_JAR) >= 6 then
		player:GetEffects():RemoveCollectibleEffect(EEVEEMOD.CollectibleType.COOKIE_JAR, -1)
	end

	if EEVEEMOD.PERSISTENT_DATA.PlayerData[ID]
		and EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed
		and EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed < 0 then
		if not data.CookieSpeedWait then
			data.CookieSpeedWait = cookieSpeedDelay
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
		else
			if data.CookieSpeedWait <= 0 then
				EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed = EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].CookieSpeed + 0.01
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
				data.CookieSpeedWait = cookieSpeedDelay
			end
			data.CookieSpeedWait = data.CookieSpeedWait - 1
		end
	end
end

return cookieJar
