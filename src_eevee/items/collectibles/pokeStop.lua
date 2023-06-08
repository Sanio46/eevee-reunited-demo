local pokeStop = {}

local roomToSpawnIn = {}
local specialRooms = {}
local blacklistedRooms = {
	[0] = true,
	[1] = true,
	[3] = true,
	[14] = true,
	[15] = true,
	[16] = true,
	[17] = true,
	[22] = true,
	[23] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
}
local uniqueRoomReward = {
	[RoomType.ROOM_TREASURE] = { PickupVariant.PICKUP_KEY, KeySubType.KEY_DOUBLEPACK },
	[RoomType.ROOM_SHOP] = { PickupVariant.PICKUP_GRAB_BAG, 0 },
	[RoomType.ROOM_BOSS] = { PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL },
	[RoomType.ROOM_MINIBOSS] = { PickupVariant.PICKUP_TAROTCARD, -1 },
	[RoomType.ROOM_SECRET] = { PickupVariant.PICKUP_HEART, HeartSubType.BONE },
	[RoomType.ROOM_SUPERSECRET] = { PickupVariant.PICKUP_LOCKEDCHEST, 0 },
	[RoomType.ROOM_ARCADE] = { PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME },
	[RoomType.ROOM_CURSE] = { PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK },
	[RoomType.ROOM_CHALLENGE] = { PickupVariant.PICKUP_TRINKET,
		function() return EEVEEMOD.game:GetItemPool():GetTrinket(true) end },
	[RoomType.ROOM_LIBRARY] = { PickupVariant.PICKUP_WOODENCHEST, 0 },
	[RoomType.ROOM_SACRIFICE] = { PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK },
	[RoomType.ROOM_ISAACS] = { PickupVariant.PICKUP_CHEST, 0 },
	[RoomType.ROOM_BARREN] = { PickupVariant.PICKUP_OLDCHEST, 0 },
	[RoomType.ROOM_CHEST] = { PickupVariant.PICKUP_ETERNALCHEST, 0 },
	[RoomType.ROOM_DICE] = { PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD },
	[RoomType.ROOM_PLANETARIUM] = { PickupVariant.PICKUP_TRINKET, TrinketType.TELESCOPE_LENS },
	[RoomType.ROOM_ULTRASECRET] = { PickupVariant.PICKUP_REDCHEST, 0 }
}
---@type table<PickupVariant, CoinSubType | BombSubType | KeySubType>
local pickupSpawnWeights = {
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY },
	{ PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL },
	{ PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL },
	{ PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL },
	{ PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL },
	{ PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL },
}

local MAX_SPINS = 6

function pokeStop:ResetSpecialRooms()
	roomToSpawnIn = {}
	specialRooms = {}
end

---@param player EntityPlayer
function pokeStop:GetAllSpecialRooms(player)
	if player:HasCollectible(EEVEEMOD.CollectibleType.POKE_STOP) then
		local level = EEVEEMOD.game:GetLevel()
		local rooms = level:GetRooms()

		if #specialRooms == 0 then
			for i = 0, rooms.Size - 1 do
				local room = rooms:Get(i)
				local data = room.Data

				if blacklistedRooms[data.Type] ~= true then
					table.insert(specialRooms, room.ListIndex)
				end
			end
		end

		for _ = 1, player:GetCollectibleNum(EEVEEMOD.CollectibleType.POKE_STOP) do
			local pokeStopRng = player:GetCollectibleRNG(EEVEEMOD.CollectibleType.POKE_STOP)
			local randomNum = VeeHelper.DifferentRandomNum(roomToSpawnIn, #specialRooms, pokeStopRng) + 1
			local randomRoomIndex = specialRooms[randomNum]
			roomToSpawnIn[randomRoomIndex] = true
		end
	end
end

local function SpawnPokeStop()
	local room = EEVEEMOD.game:GetRoom()
	local centerPos = room:GetCenterPos()
	local stop = Isaac.Spawn(EntityType.ENTITY_PICKUP, EEVEEMOD.SlotVariant.POKE_STOP, 0,
		Vector(centerPos.X, centerPos.Y - 70), Vector.Zero, nil)
	local data = stop:GetData()
	stop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	stop.Mass = 100
	local pokeStopRNG = RNG()
	pokeStopRNG:SetSeed(stop.InitSeed, 35)
	data.PokeStopRNG = pokeStopRNG
	stop:GetSprite():Play("Appear", true)
end

function pokeStop:SpawnPokeStopInSpecialRoom()
	local room = EEVEEMOD.game:GetRoom()
	local level = EEVEEMOD.game:GetLevel()
	local currentIndex = level:GetCurrentRoomDesc().ListIndex

	if roomToSpawnIn[currentIndex] and room:IsFirstVisit() == true then
		SpawnPokeStop()
	end
	for _, stop in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, EEVEEMOD.SlotVariant.POKE_STOP)) do		
		--Check if is a pokestop, then apply player only collision type and some mass.
		if stop:ToPickup().Touched then
			stop:Remove()
		else
		stop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		stop.Mass = 100
		end
	end
end

---@param stop Entity
function pokeStop:IfTouchPokeStop(_, stop, _)
	if stop.Type == EntityType.ENTITY_PICKUP
		and stop.Variant == EEVEEMOD.SlotVariant.POKE_STOP then
		stop:ToPickup().Touched = true
		print(stop:ToPickup().Touched)
		local sprite = stop:GetSprite()
		sprite:Play("Spin", false)
		stop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
end

function pokeStop:SlotUpdate()			--Changed the Spawn methods to normal ones to use random seed and dont break on D20
	for _, stop in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, EEVEEMOD.SlotVariant.POKE_STOP)) do
		local data = stop:GetData()
		local sprite = stop:GetSprite()

		if data.PosToStayIn and stop.Position:DistanceSquared(data.PosToStayIn) >= 2 then
			stop.Position = data.PosToStayIn
		end

		if not data.TimesSpun then data.TimesSpun = 0 end

		if sprite:IsEventTriggered("Prize") then
			data.TimesSpun = data.TimesSpun + 1

			if not data.PokeStopRNG then
				local pokeStopRNG = RNG()
				pokeStopRNG:SetSeed(stop.InitSeed, 35)
				data.PokeStopRNG = pokeStopRNG
			end

			if data.TimesSpun <= MAX_SPINS then
				local velocity = Vector(3, 0):Rotated(VeeHelper.RandomNum(360))
				local randomNum = data.PokeStopRNG:RandomInt(#pickupSpawnWeights - 1) + 1
				data.PokeStopRNG:Next()
				local pickupSpawn = pickupSpawnWeights[randomNum]
				Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupSpawn[1], pickupSpawn[2], stop.Position, velocity, stop)
			elseif data.TimesSpin == MAX_SPINS then
				local roomDesc = EEVEEMOD.game:GetLevel():GetCurrentRoomDesc()
				local roomType = roomDesc.Data.Type
				local pickupSpawn = uniqueRoomReward[roomType]
				if pickupSpawn == nil then pickupSpawn = { PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL } end
				local velocity = Vector(3, 0):Rotated(VeeHelper.RandomNum(360))

				if roomType == RoomType.ROOM_TREASURE and roomDesc.Flags == (roomDesc.Flags | RoomDescriptor.FLAG_DEVIL_TREASURE) then
					pickupSpawn[1] = PickupVariant.PICKUP_TAROTCARD
					pickupSpawn[2] = Card.CARD_CRACKED_KEY
				end
				Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupSpawn[1], pickupSpawn[2], stop.Position, velocity, stop)
			elseif data.TimesSpun >= MAX_SPINS then
				sprite:Play("Spin_Winddown", false)
			end
		end

		if sprite:IsFinished("Spin_Winddown") then
			sprite:Play("Disappear", false)
		end

		if sprite:IsFinished("Disappear") then
			stop:Remove()
		end
	end
end

---@param player EntityPlayer
function pokeStop:DropPokeStopOnFirstPickup(player)
	local data = player:GetData()

	if player.QueuedItem.Item ~= nil then
		if player.QueuedItem.Item.ID == EEVEEMOD.CollectibleType.POKE_STOP
			and not data.ShouldDropPokeStop
		then
			data.ShouldDropPokeStop = true
		end

	elseif player:IsItemQueueEmpty() and data.ShouldDropPokeStop then
		SpawnPokeStop()
		data.ShouldDropPokeStop = nil
	end
end

---@param player EntityPlayer
function pokeStop:SpawnOnGameExit(player)
	local data = player:GetData()

	if data.ShouldDropPokeStop then
		SpawnPokeStop()
		data.ShouldDropPokeStop = nil
	end
end

return pokeStop
