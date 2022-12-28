VeeHelper = {}

local game = Game()
VeeHelper.RoomCleared = false

---@class UseItemReturn
---@field Discharge boolean
---@field ShowAnim boolean
---@field Remove boolean

---@alias Weapon EntityTear | EntityLaser | EntityKnife | EntityBomb

VeeHelper.RandomRNG = RNG()
VeeHelper.RandomRNG:SetSeed(Random() + 1, 35)
---@param lower? integer
---@param upper? integer
function VeeHelper.RandomNum(lower, upper)
	if upper then
		return VeeHelper.RandomRNG:RandomInt((upper - lower) + 1) + lower
	elseif lower then
		return VeeHelper.RandomRNG:RandomInt(lower) + 1
	else
		return VeeHelper.RandomRNG:RandomFloat()
	end
end

---@enum VectorDirection
VeeHelper.VectorDirection = {
	Down = Vector(0, 1),
	Right = Vector(1, 0),
	Up = Vector(0, -1),
	Left = Vector(-1, 0),

}

---@enum KnifeVariant
VeeHelper.KnifeVariant = {
	MOMS_KNIFE = 0,
	BONE = 1,
	BONE_KNIFE = 2,
	JAWBONE = 3,
	BAG_OF_CRAFTING = 4,
	SUMPTORIUM = 5,
	NOTCHED_AXE = 9,
	SPIRIT_SWORD = 10,
	TECH_SWORD = 11,
}

---@enum PoopVariant
VeeHelper.PoopVariant = {
	POOP = 0,
	GOLD = 1,
	POOP_BB = 10,
	STONE = 11,
	CORNY = 12,
	BURNING = 13,
	STINKY = 14,
	BLACK = 15,
	HOLY = 16
}

---@enum SlotVariant
VeeHelper.SlotVariant = {
	SLOT_MACHINE = 1,
	BLOOD_DONATION = 2,
	FORTUNE_TELLER = 3,
	BEGGAR = 4,
	BEGGAR_DEVIL = 5,
	SHELL_GAME = 6,
	BEGGAR_KEY = 7,
	DONATION = 8,
	BEGGAR_BOMB = 9,
	RESTOCK = 10,
	GREED_DONATION = 11,
	DRESSER = 12,
	BEGGAR_BATTERY = 13,
	TAINTED_UNLOCK = 14,
	HELL_GAME = 15,
	CRANE = 16,
	CONFESSIONAL = 17,
	BEGGAR_ROTTEN = 18,
}

---@type table<TearVariant, boolean>
VeeHelper.TearVariantBlacklist = {
	[TearVariant.BOBS_HEAD] = true,
	[TearVariant.CHAOS_CARD] = true,
	[TearVariant.KEY] = true,
	[TearVariant.KEY_BLOOD] = true,
	[TearVariant.FIRE] = true,
	[TearVariant.SWORD_BEAM] = true,
	[TearVariant.TECH_SWORD_BEAM] = true,
}

---@type table<TearVariant, boolean>
VeeHelper.TearFlagsBlood = {
	[TearVariant.BLOOD] = true,
	[TearVariant.CUPID_BLOOD] = true,
	[TearVariant.PUPULA_BLOOD] = true,
	[TearVariant.GODS_FLESH_BLOOD] = true,
	[TearVariant.NAIL_BLOOD] = true,
	[TearVariant.GLAUCOMA_BLOOD] = true,
	[TearVariant.EYE] = true,
	[TearVariant.EYE_BLOOD] = true,
	[TearVariant.BALLOON] = true,
	[TearVariant.BALLOON_BRIMSTONE] = true,
}

---@type table<EntityType, boolean>
VeeHelper.MajorBosses = {
	[EntityType.ENTITY_MOM] = true,
	[EntityType.ENTITY_MOMS_HEART] = true, --+It Lives
	[EntityType.ENTITY_ISAAC] = true, --+Blue Baby
	[EntityType.ENTITY_SATAN] = true,
	[EntityType.ENTITY_THE_LAMB] = true,
	[EntityType.ENTITY_MEGA_SATAN] = true,
	[EntityType.ENTITY_MEGA_SATAN_2] = true,
	[EntityType.ENTITY_HUSH] = true,
	[EntityType.ENTITY_DELIRIUM] = true,
	[EntityType.ENTITY_DOGMA] = true,
	[EntityType.ENTITY_BEAST] = true,
}

---@type string[]
VeeHelper.PlayerAnimations = {
	"Appear",
	"Pickup",
	"Hit",
	"Appear",
	"Death",
	"Happy",
	"Sad",
	"TeleportUp",
	"TeleportDown",
	"Trapdoor",
	"MinecartEnter",
	"Jump",
	"Glitch",
	"LiftItem",
	"HideItem",
	"UseItem",
	"FallIn",
	"JumpOut",
	"PickupWalkDown",
	"PickupWalkLeft",
	"PickupWalkUp",
	"PickupWalkRight",
	"LightTravel",
	"LeapUp",
	"SuperLeapUp",
	"LeapDown",
	"SuperLeapDown",
	"DeathTeleport",
	"ForgottenDeath"
}

---@type string[]
VeeHelper.PickupAnimations = {
	"PickupWalkDown",
	"PickupWalkLeft",
	"PickupWalkUp",
	"PickupWalkRight"
}

---@type string[]
VeeHelper.WalkAnimations = {
	"WalkLeft",
	"WalkUp",
	"WalkRight",
	"WalkDown"
}

---@type string[]
VeeHelper.GamePauseAnimations = {
	"Appear",
	"LightTravel",
	"TeleportUp",
	"TeleportDown",
	"Trapdoor",
	"MinecartEnter"
}

---@type string[]
VeeHelper.SuplexAnimations = {
	"LeapUp",
	"SuperLeapUp",
	"LeapDown",
	"SuperLeapDown"
}

---@type table<SkinColor, string>
VeeHelper.SkinColorToString = {
	[SkinColor.SKIN_PINK] = "",
	[SkinColor.SKIN_WHITE] = "_white",
	[SkinColor.SKIN_BLACK] = "_black",
	[SkinColor.SKIN_BLUE] = "_blue",
	[SkinColor.SKIN_RED] = "_red",
	[SkinColor.SKIN_GREEN] = "_green",
	[SkinColor.SKIN_GREY] = "_grey",
	[SkinColor.SKIN_SHADOW] = "_shadow"
}

---@type table<SeedEffect, boolean>
VeeHelper.SeedDisablesAchievements = {
	[SeedEffect.SEED_INFINITE_BASEMENT] = true,
	[SeedEffect.SEED_PICKUPS_SLIDE] = true,
	[SeedEffect.SEED_ITEMS_COST_MONEY] = true,
	[SeedEffect.SEED_PACIFIST] = true,
	[SeedEffect.SEED_ENEMIES_RESPAWN] = true,
	[SeedEffect.SEED_POOP_TRAIL] = true,
	[SeedEffect.SEED_INVINCIBLE] = true,
	[SeedEffect.SEED_KIDS_MODE] = true,
	[SeedEffect.SEED_PERMANENT_CURSE_LABYRINTH] = true,
	[SeedEffect.SEED_PREVENT_CURSE_DARKNESS] = true,
	[SeedEffect.SEED_PREVENT_CURSE_LABYRINTH] = true,
	[SeedEffect.SEED_PREVENT_CURSE_LOST] = true,
	[SeedEffect.SEED_PREVENT_CURSE_UNKNOWN] = true,
	[SeedEffect.SEED_PREVENT_CURSE_MAZE] = true,
	[SeedEffect.SEED_PREVENT_CURSE_BLIND] = true,
	[SeedEffect.SEED_PREVENT_ALL_CURSES] = true,
	[SeedEffect.SEED_GLOWING_TEARS] = true,
	[SeedEffect.SEED_ALL_CHAMPIONS] = true,
	[SeedEffect.SEED_ALWAYS_CHARMED] = true,
	[SeedEffect.SEED_ALWAYS_CONFUSED] = true,
	[SeedEffect.SEED_ALWAYS_AFRAID] = true,
	[SeedEffect.SEED_ALWAYS_ALTERNATING_FEAR] = true,
	[SeedEffect.SEED_ALWAYS_CHARMED_AND_AFRAID] = true,
	[SeedEffect.SEED_SUPER_HOT] = true
}

---@class BookState
VeeHelper.BookState = {
	BOOK_NONE = 0,
	BOOK_ACTIVE = 1,
	BOOK_DOUBLE = 2
}

---@param player EntityPlayer
function VeeHelper.GetBookState(player)
	local hasVirtues = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
	local hasBelial = VeeHelper.IsJudasBirthrightActive(player)
	local bookState = (hasVirtues and hasBelial) and VeeHelper.BookState.BOOK_DOUBLE or
		(hasVirtues or hasBelial) and VeeHelper.BookState.BOOK_ACTIVE or VeeHelper.BookState.BOOK_NONE

	return bookState
end

---@class Rune
local runes = {
	Card.RUNE_HAGALAZ,
	Card.RUNE_JERA,
	Card.RUNE_EHWAZ,
	Card.RUNE_DAGAZ,
	Card.RUNE_ANSUZ,
	Card.RUNE_PERTHRO,
	Card.RUNE_BLANK,
	Card.RUNE_BLACK,
	Card.CARD_SOUL_ISAAC,
	Card.CARD_SOUL_MAGDALENE,
	Card.CARD_SOUL_CAIN,
	Card.CARD_SOUL_JUDAS,
	Card.CARD_SOUL_BLUEBABY,
	Card.CARD_SOUL_EVE,
	Card.CARD_SOUL_SAMSON,
	Card.CARD_SOUL_AZAZEL,
	Card.CARD_SOUL_LAZARUS,
	Card.CARD_SOUL_EDEN,
	Card.CARD_SOUL_LOST,
	Card.CARD_SOUL_LILITH,
	Card.CARD_SOUL_KEEPER,
	Card.CARD_SOUL_APOLLYON,
	Card.CARD_SOUL_FORGOTTEN,
	Card.CARD_SOUL_BETHANY,
	Card.CARD_SOUL_JACOB
}

---@param card Card
---@return boolean
function VeeHelper.IsRune(card)
	local isRune = false
	if (card >= Card.RUNE_HAGALAZ and card <= Card.RUNE_BLACK)
		or card == Card.RUNE_SHARD
		or (card >= Card.CARD_SOUL_ISAAC and card <= Card.NUM_CARDS)
	then
		isRune = true
	end
	return isRune
end

---@enum HealthType
VeeHelper.PlayerHealthType = {
	NO_HEALTH = -1,
	NORMAL = 0,
	SOUL_ONLY = 1,
	BLACK_ONLY = 2
}

---@param playerType PlayerType
---@return HealthType
function VeeHelper:GetPlayerHealthType(playerType)
	local noRedHealth = {
		[PlayerType.PLAYER_BLUEBABY] = VeeHelper.PlayerHealthType.SOUL_ONLY,
		[PlayerType.PLAYER_BLACKJUDAS] = VeeHelper.PlayerHealthType.BLACK_ONLY,
		[PlayerType.PLAYER_THELOST] = VeeHelper.PlayerHealthType.NO_HEALTH,
		[PlayerType.PLAYER_JUDAS_B] = VeeHelper.PlayerHealthType.BLACK_ONLY,
		[PlayerType.PLAYER_BLUEBABY_B] = VeeHelper.PlayerHealthType.SOUL_ONLY,
		[PlayerType.PLAYER_THELOST_B] = VeeHelper.PlayerHealthType.NO_HEALTH,
		[PlayerType.PLAYER_BETHANY_B] = VeeHelper.PlayerHealthType.SOUL_ONLY
	}
	return noRedHealth[playerType] or VeeHelper.PlayerHealthType.NORMAL
end

function VeeHelper.RoundNum(num, setting, numToRoundBy)

	if not setting
		or (setting ~= "up" and setting ~= "down") then
		setting = "up"
	end

	numToRoundBy = numToRoundBy or 0.5

	if setting == "up" then
		if num > numToRoundBy then
			num = math.ceil(num)
		else
			num = math.floor(num)
		end
	elseif setting == "down" then
		if num > numToRoundBy then
			num = math.floor(num)
		else
			num = math.ceil(num)
		end
	end
	return num
end

function VeeHelper.RoundHighestVectorPoint(vec)
	local x, y = vec.X, vec.Y
	if (1 - math.abs(x)) < (1 - math.abs(y)) then
		x = VeeHelper.RoundNum(x, "up", 0)
		y = VeeHelper.RoundNum(y, "down", 0)
	elseif (1 - math.abs(x)) > (1 - math.abs(y)) then
		y = VeeHelper.RoundNum(y, "up", 0)
		x = VeeHelper.RoundNum(x, "down", 0)
	end
	return Vector(x, y)
end

---@return EntityPlayer[]
function VeeHelper.GetAllPlayers()
	local players = {}
	for i = 0, game:GetNumPlayers() - 1 do
		table.insert(players, Isaac.GetPlayer(i))
	end
	return players
end

---@return EntityPlayer[]
function VeeHelper.GetAllMainPlayers()
	local players = {}
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		if player:GetMainTwin():GetPlayerType() == player:GetPlayerType() --Is the main twin of 2 players
			and (not player.Parent or player.Parent.Type ~= EntityType.ENTITY_PLAYER) then --Not an item-related spawned-in player.
			table.insert(players, player)
		end
	end
	return players
end

--Credit: tem for blindfold toggle

---@param player EntityPlayer
---@param canShoot boolean
function VeeHelper.SetCanShoot(player, canShoot)
	local oldChallenge = game.Challenge
	game.Challenge = canShoot and 0 or 6
	player:UpdateCanShoot()
	game.Challenge = oldChallenge
end

---@param player EntityPlayer
---@return boolean canControl
function VeeHelper.PlayerCanControl(player)
	local canControl = false

	if not game:IsPaused()
		and not player:IsDead()
		and player.ControlsEnabled
	then
		canControl = true
	end

	return canControl
end

---@param sprite Sprite
---@param anims string[]
---@return boolean isPlaying
function VeeHelper.IsSpritePlayingAnims(sprite, anims)
	for i = 1, #anims do
		if sprite:GetAnimation() == anims[i] then
			return true
		end
	end
	return false
end

--Thank you piber!
---@param ent Entity
---@param range number
---@return EntityNPC | nil
function VeeHelper.DetectNearestEnemy(ent, range)
	local closestEnemy = nil --placeholder variable we'll put the closest enemy in
	local closestDistance = nil --placeholder variable we'll put the distance in

	for _, npc in pairs(Isaac.FindInRadius(ent.Position, range, EntityPartition.ENEMY)) do --if there are enemies, dumbass.
		npc = npc:ToNPC()
		if not npc then return end
		if npc:IsActiveEnemy() and npc:IsVulnerableEnemy() then --if its an active enemy

			local npcDistance = npc.Position:DistanceSquared(ent.Position) --calculate the distance of this npc from the starting position of the ent

			if not closestEnemy or npcDistance < closestDistance then --if we never stored any variables OR if this npc is closer than the closest one we stored last
				closestEnemy = npc --store this npc in the variable
				closestDistance = npcDistance --store this distance in the variable
			end
		end
	end
	return closestEnemy
end

---@param player EntityPlayer
function VeeHelper.PlayerStandingStill(player)
	if not game:IsPaused() and not player:IsDead() and player.ControlsEnabled and
		not (Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex)
			or Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex)
			or Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex)
			or Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex)) then
		return true
	else
		return false
	end
end

--Yet again more credit to tem
---@param player EntityPlayer
function VeeHelper.GetPlayerIdentifier(player)
	local IDToCheck = 1 --Any item can be used, Sad Onion is just an easy default.
	local playerType = player:GetPlayerType()
	if playerType == PlayerType.PLAYER_LAZURUS2_B then
		IDToCheck = 2
	end

	return player:GetCollectibleRNG(IDToCheck):GetSeed()
end

---@param player EntityPlayer
function VeeHelper.FindMarkedTarget(player)
	local targetPos = nil
	local targetVariants = {
		EffectVariant.TARGET,
		EffectVariant.OCCULT_TARGET
	}
	for i = 1, #targetVariants do
		local targets = Isaac.FindByType(EntityType.ENTITY_EFFECT, targetVariants[i])

		for _, target in pairs(targets) do
			if VeeHelper.EntitySpawnedByPlayer(target)
				and target.SpawnerEntity:GetData().Identifier == player:GetData().Identifier then
				targetPos = target.Position
			end
		end
	end
	return targetPos
end

--Credit to DeadInfinity for Lerping directly with angles!
function VeeHelper.GetAngleDifference(a1, a2)
	local sub = a1 - a2
	return (sub + 180) % 360 - 180
end

function VeeHelper.Lerp(vec1, vec2, percent)
	return vec1 * (1 - percent) + vec2 * percent
end

function VeeHelper.LerpAngleDegrees(aStart, aEnd, percent)
	return aStart + VeeHelper.GetAngleDifference(aEnd, aStart) * percent
end

---@param direction Vector
---@param shotSpeed number
---@param player? EntityPlayer
function VeeHelper.AddTearVelocity(direction, shotSpeed, player)
	local newDirection = direction:Resized(shotSpeed)

	if player then
		newDirection = newDirection + player:GetTearMovementInheritance(newDirection)
	end
	return newDirection
end

---@param player EntityPlayer
---@param itemID CollectibleType
function VeeHelper.GetActiveSlots(player, itemID)
	local slots = {}
	---@type ActiveSlot
	for i = 0, 3 do
		if player:GetActiveItem(i) == itemID then
			table.insert(slots, i)
		end
	end
	return slots
end

---@param player EntityPlayer
---@param itemID CollectibleType
function VeeHelper.GetActiveItemCharges(player, itemID)
	local slots = VeeHelper.GetActiveSlots(player, itemID)
	local slotNum = {}
	local charges = {}
	for i = 1, #slots do
		slotNum[i] = slots[i]
		table.insert(charges, player:GetActiveCharge(slotNum[i]))
	end
	return charges, slotNum
end

---@param baseChance number
---@param maxChance number
---@param luckValue number
---@param currentLuck number
---@param rng RNG
function VeeHelper.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck, rng)
	local number = baseChance + (currentLuck * luckValue)
	if number > maxChance then
		number = maxChance
	end
	if rng:RandomInt(100) <= number then
		return true
	else
		return false
	end
end

local wasRoomCleared = true
local greedWaveCheck = 0
local checkDelaySet = 35
local checkDelay = 35
local curWave = 0
local waveMax = 2
local doubleCheck = true

local function defaultRoomClear(room)
	local triggerRoomClear = false

	if room:IsClear() and wasRoomCleared == false then
		triggerRoomClear = true
		wasRoomCleared = true
	end
	wasRoomCleared = room:IsClear()

	return triggerRoomClear
end

function VeeHelper.RoomClearTriggered()
	local room = game:GetRoom()
	local triggerRoomClear = false
	local roomType = room:GetType()

	if not game:IsGreedMode() then

		--CHALLENGE ROOM / BOSS RUSH
		if (roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_BOSSRUSH) then
			waveMax = roomType == RoomType.ROOM_CHALLENGE and (game:GetLevel():HasBossChallenge() and 2 or 3) or 15
			if room:IsAmbushActive() then
				wasRoomCleared = false
				if checkDelay > 0 then
					checkDelay = checkDelay - 1
				end
				local hasWaveCleared = true
				for _, npc in ipairs(Isaac.GetRoomEntities()) do
					if (
						npc:IsActiveEnemy()
							or npc:IsDead()--Enemies are not active but playing their death animations
						)
						and npc.CanShutDoors
						and not (
						npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
							or npc:HasEntityFlags(EntityFlag.FLAG_PERSISTENT)
							or npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
						)
						and
						(
						(
							roomType == RoomType.ROOM_BOSSRUSH
								and npc:IsBoss()
								and not npc.SpawnerEntity
							)
							or roomType == RoomType.ROOM_CHALLENGE
						)
					then
						hasWaveCleared = false
						doubleCheck = true
					end
				end

				if hasWaveCleared == true and checkDelay == 0 then
					if doubleCheck then --For entities that spawn additional ones upon death
						checkDelay = 1
						doubleCheck = false
					else
						curWave = curWave + 1
						if curWave ~= waveMax then
							triggerRoomClear = true
						end
						checkDelay = checkDelaySet
					end
				end
			else
				curWave = 0
				checkDelay = checkDelaySet
				triggerRoomClear = defaultRoomClear(room)
			end
			--NORMAL ROOMS
		else
			triggerRoomClear = defaultRoomClear(room)
		end
		--GREED MODE
	else
		local greedWave = game:GetLevel().GreedModeWave

		if roomType == RoomType.ROOM_DEFAULT then
			if greedWaveCheck ~= greedWave and greedWave ~= 0 then
				greedWaveCheck = greedWave
				if room:GetFrameCount() > 0 then
					triggerRoomClear = true
				end
			end
		else
			triggerRoomClear = defaultRoomClear(room)
		end
	end
	VeeHelper.RoomCleared = triggerRoomClear
end

---@param player EntityPlayer
---@param useBody? boolean
function VeeHelper.SkinColor(player, useBody)
	local skinColor = useBody and player:GetBodyColor() or player:GetHeadColor()

	return VeeHelper.SkinColorToString[skinColor]
end

---@param ent Entity
function VeeHelper.EntitySpawnedByPlayer(ent)
	return ent.SpawnerEntity ~= nil and ent.SpawnerEntity:ToPlayer() ~= nil
end

---@param table table
---@param trinketType TrinketType
---@param player EntityPlayer
---@param mult? number
---@param mult2? number
function VeeHelper.MultiplyTrinketStats(table, trinketType, player, mult, mult2)
	local trinketMult = player:GetTrinketMultiplier(trinketType)

	for i, stat in pairs(table) do
		if mult then
			if trinketMult == 2 then
				stat = stat * mult
			elseif trinketMult == 3 then
				local multiplier = mult2 == nil and (mult * 2) or mult2
				stat = stat * multiplier
			end
		else
			stat = stat * trinketMult
		end
		table[i] = stat
	end
end

---Detects if the PlayerType of the provided EntityPlayer is a Tainted variant. If so, changes its PlayerType to its non-Tainted counterpart. They must both share the same name.
---@param player EntityPlayer
---@param playerName string
function VeeHelper.DisableTainted(player, playerName)
	local tainted = Isaac.GetPlayerTypeByName(playerName, true)
	local nonTainted = Isaac.GetPlayerTypeByName(playerName, false)

	if player:GetPlayerType() == tainted and (nonTainted ~= nil and nonTainted ~= -1) then
		player:ChangePlayerType(nonTainted)
	end
end

---@param c Color
---@param alpha number
---@return Color
function VeeHelper.SetColorAlpha(c, alpha)
	return Color(c.R, c.G, c.B, alpha, c.RO, c.GO, c.BO)
end

---@param tear EntityTear
---@return boolean isSplitTear
function VeeHelper.IsSplitTear(tear)
	local isSplit = false

	for _, tears in pairs(Isaac.FindInRadius(tear.Position, 10, EntityPartition.TEAR)) do
		local mainTear = tears:ToTear()
		if mainTear == nil then return false end
		if tear.InitSeed ~= mainTear.InitSeed
			and tear.FrameCount ~= mainTear.FrameCount
			and tear.SpawnerEntity
			and tear.SpawnerEntity:ToPlayer()
		then
			isSplit = true
		end
	end

	return isSplit
end

---@param tear EntityTear
---@return boolean tearFromFamiliar
function VeeHelper.IsTearFromFamiliar(tear)
	local isFamiliarSpawn = false

	local validFamiliars = {
		[FamiliarVariant.INCUBUS] = true,
		[FamiliarVariant.SPRINKLER] = true,
		[FamiliarVariant.TWISTED_BABY] = true,
		[FamiliarVariant.BLOOD_BABY] = true,
		[FamiliarVariant.UMBILICAL_BABY] = true
	}

	if tear.SpawnerEntity:ToFamiliar() and validFamiliars[tear.SpawnerEntity:ToFamiliar().Variant] then
		isFamiliarSpawn = true
	end

	return isFamiliarSpawn
end

--Taken directly from the source! Shoutouts to the modders who decompiled the Switch port.
---@param tear EntityTear
---@return string
function VeeHelper.TearScaleToSizeAnim(tear)
	local scale = tear.Scale
	local anim = "8"

	if scale <= 0.3 then
		anim = "1"
	elseif scale <= 0.55 then
		anim = "2"
	elseif scale <= 0.675 then
		anim = "3"
	elseif scale <= 0.8 then
		anim = "4"
	elseif scale <= 0.925 then
		anim = "5"
	elseif scale <= 1.05 then
		anim = "6"
	elseif scale <= 1.175 then
		anim = "7"
	elseif 1.425 < scale then
		if scale <= 1.675 then
			anim = "9"
		elseif scale <= 1.925 then
			anim = "10"
		elseif scale <= 2.175 then
			anim = "11"
		elseif 2.55 < scale then
			anim = "12"
		end
		anim = "13"
	end
	return anim
end

---@param currentNums integer[]
---@param maxNum integer
---@param rng RNG
function VeeHelper.DifferentRandomNum(currentNums, maxNum, rng)
	local checkCount = 0
	local randomNum = function() return rng:RandomInt(maxNum) end
	local num = randomNum()
	local allNums = {}
	for _, int in ipairs(currentNums) do
		allNums[tostring(int)] = true
	end
	while allNums[tostring(num)] and checkCount < maxNum do
		num = randomNum()
		checkCount = checkCount + 1
	end
	return num
end

---@param player EntityPlayer
---@return boolean
function VeeHelper.IsJudasBirthrightActive(player)
	local playerType = player:GetPlayerType()
	return (playerType == PlayerType.PLAYER_JUDAS or playerType == PlayerType.PLAYER_BLACKJUDAS) and
		player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
end

--Loops through all EntityPlayers to see if they have the provided TrinketType. Returns true if so, false otherwise.
---@param trinketType TrinketType
function VeeHelper.IsTrinketOwned(trinketType)
	local hasTrinket = false
	local players = VeeHelper.GetAllPlayers()

	for i = 1, #players do
		local player = players[i]
		if player:HasTrinket(trinketType) then
			hasTrinket = true
		end
	end
	return hasTrinket
end

--Takes a custom array of CollectibleTypes and returns a modified version of the array that excludes any player-owned items. Active items are removed if any player owns the "No!" trinket.
---@param pool CollectibleType[]
function VeeHelper.GetCustomItemPool(pool)
	local itemsOutOfPool = {}
	local players = VeeHelper.GetAllPlayers()
	local hasNO = VeeHelper.IsTrinketOwned(TrinketType.TRINKET_NO)

	for i = 1, #players do
		local player = players[i]
		for j = 1, #pool do
			if player:HasCollectible(pool[j]) or hasNO then
				itemsOutOfPool[j] = true
			end
		end
	end
	local currentPool = {}
	for i = 1, #pool do
		if not itemsOutOfPool[i] then
			table.insert(currentPool, pool[i])
		end
	end
	return currentPool
end

function VeeHelper.GameContinuedOnPlayerInit()
	--[[ local wasContinued = true
	if game:GetRoom():GetFrameCount() == 0 and #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		wasContinued = false
	end
	return wasContinued ]]
end

function VeeHelper.ShaderCrashFix()
	if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		Isaac.ExecuteCommand("reloadshaders")
	end
end

---@param a number
function VeeHelper.AngleToFireDirection(a)
	local DirAngles = {
		[-90] = 1,
		[0] = 2,
		[90] = 3,
		[180] = 0,
		[270] = 1,
	}
	return DirAngles[a]
end

function VeeHelper.AreColorsDifferent(c1, c2)
	local isDifferent = false
	if c1 ~= nil and c2 ~= nil then
		if c1.R ~= c2.R or c1.G ~= c2.G or c1.B ~= c2.B or c1.RO ~= c2.RO or c1.GO ~= c2.GO or c1.BO ~= c2.BO then
			isDifferent = true
		end
	end
	return isDifferent
end

local playdoughColor = {
	{ 0.9, 0, 0, 1 }, --red
	{ 0, 0.7, 0, 0.9 }, --green
	{ 0, 0, 1, 1 }, --blue
	{ 0.8, 0.8, 0, 1 }, --yellow
	{ 0, 0.5, 1, 0.9 }, --light blue
	{ 0.6, 0.4, 0, 1 }, --light brown
	{ 2, 0.1, 0.5, 1 }, --pink
	{ 1.1, 0, 1.1, 0.9 }, --purple
	{ 1, 0.1, 0, 1 } --dark orange
}

function VeeHelper.PlaydoughRandomColor()
	local dC = Color.Default
	local color = playdoughColor[VeeHelper.RandomNum(9)]
	dC:SetColorize(color[1], color[2], color[3], color[4])
	return dC
end

---@param pos Vector
---@return Vector | nil DoorSlotPos
function VeeHelper.GetClosestDoorSlotPos(pos)
	local closestDoor
	local closestDistance

	for doorSlot = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = EEVEEMOD.game:GetRoom():GetDoor(doorSlot)
		if door ~= nil and door:IsOpen() then
			local doorPos = EEVEEMOD.game:GetRoom():GetDoorSlotPosition(doorSlot)
			local doorDistance = doorPos:DistanceSquared(pos)

			if not closestDoor or doorDistance < closestDistance then
				closestDoor = doorPos
				closestDistance = doorDistance
			end
		end
	end

	return closestDoor
end

function VeeHelper.IsInStartingRoom()
	local level = EEVEEMOD.game:GetLevel()
	local roomIndex = level:GetCurrentRoomDesc().SafeGridIndex
	local startingRoomIndex = level:GetStartingRoomIndex()

	if roomIndex == startingRoomIndex
		and level:GetStage() == LevelStage.STAGE1_1 then
		if EEVEEMOD.game:GetFrameCount() == 0 or
			(EEVEEMOD.game:GetFrameCount() > 0 and level:GetCurrentRoom():IsFirstVisit() == true) then
			return true
		end
	end
	return false
end

---@param laser EntityLaser
function VeeHelper.isBrimLaser(laser)
	local brimVariants = {
		[LaserVariant.THIN_RED] = true,
		[LaserVariant.THICK_RED] = true,
		[LaserVariant.BRIM_TECH] = true,
		[LaserVariant.THICKER_RED] = true,
		[LaserVariant.THICKER_BRIM_TECH] = true,
		[LaserVariant.GIANT_RED] = true,
		[LaserVariant.GIANT_BRIM_TECH] = true
	}
	return brimVariants[laser.Variant]
end

function VeeHelper.copyOverTable(tableSubject, tableTarget)
	for variableName, value in pairs(tableSubject) do
		if type(value) == "table" then
			tableTarget[variableName] = {}
		else
			tableTarget[variableName] = value
		end
	end
end

return VeeHelper
