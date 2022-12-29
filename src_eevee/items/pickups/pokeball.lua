local pokeball = {}

local pokeyMans = require("src_eevee.challenges.pokeyMansCrystal")
local attackHelper = require("src_eevee.attacks.attackHelper")

local pokeballSprite = Sprite()

---------------------------
--  THROWING YOUR BALLS  --
---------------------------

---@param player EntityPlayer
---@param id PokeballType | CollectibleType
local function HidePokeball(player, id)
	local data = player:GetData()
	if id and id == EEVEEMOD.CollectibleType.MASTER_BALL then
		player:AnimateCollectible(EEVEEMOD.CollectibleType.MASTER_BALL, "HideItem", "PlayerPickupSparkle")
	else
		pokeballSprite:SetFrame(1)
		player:AnimatePickup(pokeballSprite, false, "HideItem")
	end
	data.CanThrowPokeball = false
end

local function LoadPokeballSprite()
	pokeballSprite:Load("gfx/render_pokeball_holditem.anm2", true)
	pokeballSprite:Play("Main", true)
end

---@param ballType PokeballType
---@param player EntityPlayer
function pokeball:OnPokeballUse(ballType, player)
	local data = player:GetData()

	if ballType == EEVEEMOD.PokeballType.POKEBALL
		or ballType == EEVEEMOD.PokeballType.GREATBALL
		or ballType == EEVEEMOD.PokeballType.ULTRABALL
	then
		if not data.RemovePokeball then
			if not data.CanThrowPokeball or
				(data.CanThrowPokeball and data.PokeballTypeUsed == EEVEEMOD.CollectibleType.MASTER_BALL) then
				if not pokeballSprite:IsLoaded() then
					LoadPokeballSprite()
				end
				data.CanThrowPokeball = true
				data.PokeballTypeUsed = ballType
				pokeballSprite:ReplaceSpritesheet(0,
					"gfx/items/pickups/render_pokeball_" .. EEVEEMOD.PokeballTypeToString[data.PokeballTypeUsed] .. ".png")
				pokeballSprite:LoadGraphics()
				player:AnimatePickup(pokeballSprite, false, "LiftItem")
			elseif data.PokeballTypeUsed == ballType then
				HidePokeball(player, ballType)
			end
		end
	end
end

---@param itemID CollectibleType
---@param player EntityPlayer
function pokeball:OnMasterBallUse(itemID, _, player, _, _, _)
	local data = player:GetData()
	if itemID == EEVEEMOD.CollectibleType.MASTER_BALL and player:GetActiveItem() == EEVEEMOD.CollectibleType.MASTER_BALL then
		if not data.CanThrowPokeball or
			(data.CanThrowPokeball and data.PokeballTypeUsed ~= EEVEEMOD.CollectibleType.MASTER_BALL) then
			data.CanThrowPokeball = true
			data.PokeballTypeUsed = itemID
			player:AnimateCollectible(EEVEEMOD.CollectibleType.MASTER_BALL, "LiftItem", "PlayerPickupSparkle")
		elseif data.PokeballTypeUsed == itemID then
			HidePokeball(player, itemID)
		end

		return { Discharge = false, ShowAnim = false, Remove = false }
	else
		if data.CanThrowPokeball then
			data.CanThrowPokeball = false
			return false
		end
	end
end

---@param ball EntityEffect
---@param player EntityPlayer
local function AddPokeballData(ball, player, ballType)
	local bData = ball:GetData()
	local pData = player:GetData()
	local sprite = ball:GetSprite()

	bData.PokeballType = ballType
	sprite:ReplaceSpritesheet(0, "gfx/effects/pokeball_" .. EEVEEMOD.PokeballTypeToString[ballType] .. ".png")
	sprite:LoadGraphics()
	sprite.Offset = Vector(0, -40)
	ball.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	ball.RenderZOffset = -10

	if ballType ~= EEVEEMOD.CollectibleType.MASTER_BALL then
		if pData.PokeballTypeUsed then
			local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, ballType,
				ball.Position, ball.Velocity, ball):ToPickup()
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup.Visible = false
			bData.Pickup = pickup
		else
			bData.DestroyPokeBall = true
		end
	end

	bData.PlayerLuck = player.Luck
end

---@param player EntityPlayer
local function HideBallOnSwitch(player)
	local data = player:GetData()

	if data.PokeballTypeUsed == EEVEEMOD.CollectibleType.MASTER_BALL then
		if player:GetActiveItem() ~= EEVEEMOD.CollectibleType.MASTER_BALL then
			HidePokeball(player, data.PokeballTypeUsed)
		end
	else
		if player:GetCard(0) ~= data.PokeballTypeUsed then
			HidePokeball(player, data.PokeballTypeUsed)
		end
	end
end

---@param player EntityPlayer
local function ThrowBall(player, ballType)
	local Velocity = attackHelper:HeadDirectionToVector(player):Resized(11)
	local thrownPokeball = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.POKEBALL, 0, player.Position,
		Velocity, player)
	AddPokeballData(thrownPokeball, player, ballType)
end

---@param ballType Card
---@param player EntityPlayer
function pokeball:PlayerThrowPokeBall(ballType, player)
	local data = player:GetData()

	if ballType == EEVEEMOD.PokeballType.POKEBALL
		or ballType == EEVEEMOD.PokeballType.GREATBALL
		or ballType == EEVEEMOD.PokeballType.ULTRABALL then
		ThrowBall(player, ballType)
		if data.RemovePokeball then
			data.RemovePokeball = false
		end
		HidePokeball(player, ballType)
	end
end

---@param player EntityPlayer
function pokeball:PlayerThrowMasterBall(player)
	local data = player:GetData()

	if data.CanThrowPokeball and data.PokeballTypeUsed then
		HideBallOnSwitch(player)

		if player:GetFireDirection() ~= Direction.NO_DIRECTION then
			if player:HasCollectible(EEVEEMOD.CollectibleType.MASTER_BALL)
				and data.PokeballTypeUsed == EEVEEMOD.CollectibleType.MASTER_BALL
			then
				ThrowBall(player, data.PokeballTypeUsed)
				local masterBallSlot = VeeHelper.GetActiveSlots(player, EEVEEMOD.CollectibleType.MASTER_BALL)[1]
				player:SetActiveCharge(0, masterBallSlot)
				HidePokeball(player, data.PokeballTypeUsed)
			end
			if data.PokeballTypeUsed ~= EEVEEMOD.CollectibleType.MASTER_BALL then
				data.RemovePokeball = true
			end
		end

		local allWalkAnims = {
			"WalkDown",
			"WalkRight",
			"WalkUp",
			"WalkLeft",
			"PickupWalkDown",
			"PickupWalkRight",
			"PickupWalkUp",
			"PickupWalkLeft",
		}
		if not VeeHelper.IsSpritePlayingAnims(player:GetSprite(), allWalkAnims) then
			data.CanThrowPokeball = false
		end
	end
end

-----------------
--  CAPTURING  --
-----------------

---@param npc EntityNPC
---@param ball EntityEffect
---@param player EntityPlayer
local function TryCaptureBoss(npc, ball, player)
	local data = ball:GetData()
	local shouldCapture = false
	local weakStatus = {
		EntityFlag.FLAG_POISON,
		EntityFlag.FLAG_SLOW,
		EntityFlag.FLAG_FEAR,
		EntityFlag.FLAG_BURN,
		EntityFlag.FLAG_SHRINK,
		EntityFlag.FLAG_BLEED_OUT,
		EntityFlag.FLAG_WEAKNESS,
		EntityFlag.FLAG_CONFUSION
	}
	local strongStatus = {
		EntityFlag.FLAG_CHARM,
		EntityFlag.FLAG_MIDAS_FREEZE,
		EntityFlag.FLAG_ICE_FROZEN
	}
	local ballTypeToMultiplier = {
		[EEVEEMOD.PokeballType.POKEBALL] = 0,
		[EEVEEMOD.PokeballType.GREATBALL] = 1,
		[EEVEEMOD.PokeballType.ULTRABALL] = 2
	}
	local statusMult = 0
	local ballMult = ballTypeToMultiplier[data.PokeballType]
	for i = 1, #weakStatus do
		if npc:HasEntityFlags(weakStatus[i]) then
			statusMult = 1.5
		end
	end
	for i = 1, #strongStatus do
		if npc:HasEntityFlags(strongStatus[i]) then
			statusMult = 3
		end
	end
	local hpChance = ((2 - (npc.HitPoints / npc.MaxHitPoints)) + 0.1) * 5
	local luck = math.abs(data.PlayerLuck) < 5 and (data.PlayerLuck * 3) or
		(data.PlayerLuck / math.abs(data.PlayerLuck)) * 15
	local randomChance = player:GetCardRNG(data.PokeballType):RandomInt(50) + 1
	local totalChance = math.ceil(hpChance + ((ballMult * 4) + (statusMult * 5)) + luck)
	if totalChance >= randomChance then
		shouldCapture = true
	end

	if shouldCapture then
		data.NumShouldShake = 3
	else
		data.NumShouldShake = VeeHelper.RandomNum(0, 3) --troll
	end
	data.ShouldCapture = shouldCapture
	if data.NumShouldShake > 0 then
		ball:GetSprite():Play("Shake", true)
		EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.POKEBALL_ROLL)
	else
		ball:GetSprite():Play("Destroy_Closed", true)
	end
end

---@param npc EntityNPC
local function ShouldCaptureEnemy(npc)
	local canCapture = false

	if not npc:IsInvincible()
		and npc.Type ~= EntityType.ENITY_FIREPLACE
		and npc.Type ~= EntityType.ENTITY_SHOPKEEPER
		and not
		(
		npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
			or npc:HasEntityFlags(EntityFlag.FLAG_HELD)
			or npc:HasEntityFlags(EntityFlag.FLAG_THROWN)
		)
		and not VeeHelper.MajorBosses[npc.Type]
	then
		canCapture = true
	end
	return canCapture
end

---@param ball EntityEffect
local function KeepEnemyFrozenInsideBall(ball)
	local data = ball:GetData()
	data.CapturedEnemy.NPC.Position = ball.Position
	data.CapturedEnemy.NPC:AddEntityFlags(EntityFlag.FLAG_FREEZE)
	data.CapturedEnemy.NPC.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
end

---@param ball EntityEffect
local function SpawnPokeballParticles(ball)
	local data = ball:GetData()
	for _ = 1, 5 do
		local randomVec = Vector(2, 0):Rotated(VeeHelper.RandomNum(360))
		local gibs = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, ball.Position, randomVec, ball)
		local sprite = gibs:GetSprite()
		sprite:ReplaceSpritesheet(0, "gfx/effects/pokeball_gibs_" .. EEVEEMOD.PokeballTypeToString[data.PokeballType] .. ".png")
		sprite:LoadGraphics()
	end
end

---@param ball EntityEffect
local function DestroyPokeball(ball)
	EEVEEMOD.sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1, 0, false, 1.5)
	SpawnPokeballParticles(ball)
	ball:Remove()
end

---@param ball EntityEffect
function pokeball:TryCaptureNPC(ball)
	local data = ball:GetData()

	if not data.CapturedEnemy and not data.BallStationary then
		for _, ent in pairs(Isaac.FindInRadius(ball.Position, ball.Size, EntityPartition.ENEMY)) do
			local npc = ent:ToNPC()
			if ShouldCaptureEnemy(npc) then
				data.CapturedEnemy = {
					NPC = npc,
					Collision = npc.EntityCollisionClass,
					IsBoss = npc:IsBoss(),
				}
				for _, eternalFlies in pairs(Isaac.FindByType(EntityType.ENTITY_ETERNALFLY)) do
					local eternalFly = eternalFlies:ToNPC()
					if eternalFly.Position:DistanceSquared(npc.Position) <= 150 ^ 2
						and eternalFly.Parent
						and eternalFly.Parent.InitSeed == npc.InitSeed
					then
						eternalFly:Remove()
					end
				end

				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc.Visible = false
				if not npc:IsBoss() then
					data.ShouldCapture = true
					if npc:GetData().StarterPokemon then
						npc:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
					end
				end
				ball.Velocity = ball.Velocity:Resized(0.9)
				return
			end
		end
	elseif data.CapturedEnemy and data.CapturedEnemy.NPC then
		if not data.CapturedEnemy.NPC:Exists() or data.CapturedEnemy.NPC:IsDead() then
			DestroyPokeball(ball)
		else
			KeepEnemyFrozenInsideBall(ball)
		end
	end
end

---@param old EntityNPC
local function CloneNPC(old)
	local new
	-- Game:Spawn doesn't work if a SpawnerEntity isn't given, so this function
	-- is ever-so-slightly inaccurate
	if old.InitSeed and old.SpawnerEntity then
		new = Game():Spawn(old.Type, old.Variant, old.SubType, old.Position, old.Velocity, old.SpawnerEntity, old.InitSeed):
			ToNPC()
	else
		new = Isaac.Spawn(old.Type, old.Variant, old.SubType, old.Position, old.Velocity, old.SpawnerEntity):ToNPC()
	end

	new:AddEntityFlags(old:GetEntityFlags())
	if old:GetChampionColorIdx() ~= -1 then
		new:MakeChampion(1, old:GetChampionColorIdx(), false)
	end

	-- Clone fields
	-- As far as I'm aware, the following fields are the only fields you can
	-- modify without a "no member named" error, achieved through
	-- plain bruteforcing
	for _, key in ipairs({
		'Parent', 'Child', 'Color', 'EntityCollisionClass', 'GridCollisionClass', 'HitPoints', 'Parent', 'Child', 'Color',
		'EntityCollisionClass', 'GridCollisionClass', 'HitPoints', 'MaxHitPoints', 'Visible', 'CanShutDoors', 'CollisionDamage',
		'DepthOffset', 'FlipX', 'Friction', 'GroupIdx', 'I1', 'I2', 'Mass', 'PositionOffset',
		'RenderZOffset', 'Scale', 'Size', 'SizeMulti', 'SplatColor', 'SpriteOffset', 'SpriteRotation',
		'SpriteScale', 'State', 'StateFrame', 'V1', 'V2'
	}) do
		old[key] = new[key]
	end

	-- Clone sprite
	new:GetSprite():Play(old:GetSprite():GetAnimation())
	new:GetSprite():SetFrame(old:GetSprite():GetAnimation(), old:GetSprite():GetFrame())
	if not old:GetSprite():IsPlaying(old:GetSprite():GetAnimation()) then
		new:GetSprite():Stop()
	end

	new:GetSprite():SetOverlayFrame(old:GetSprite():GetOverlayAnimation(), old:GetSprite():GetOverlayFrame())
	-- There isn't a method to set the overlay render priority, so this function
	-- is ever-so-slightly inaccurate once more
	-- Isaac modding is great

	return new
end

---@param ball EntityEffect
local function ReleaseNPC(ball)
	local data = ball:GetData()
	---@type EntityNPC
	local capturedNPC = data.CapturedEnemy.NPC
	---@type EntityNPC
	local npc

	if capturedNPC:IsBoss() then
		-- Don't recreate NPC; release as-is
		npc = capturedNPC
	else
		-- Re-create NPC to recreate Friendly Ball logic and fix softlocks
		npc = CloneNPC(capturedNPC)
		capturedNPC.Visible = false
		capturedNPC:Remove()
	end

	npc:SetColor(Color(1, 1, 1, 1, 1, 1, 1), 30, 10, true, false)
	npc:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
	npc.EntityCollisionClass = data.CapturedEnemy.Collision
	npc.Visible = true

	if data.ShouldCapture then
		EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.POKEBALL_OPEN)
		npc:AddCharmed(EntityRef(ball), -1)
		npc:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		npc:AddEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL)

		local healthModifier = {
			[EEVEEMOD.PokeballType.POKEBALL] = 2,
			[EEVEEMOD.PokeballType.GREATBALL] = 4,
			[EEVEEMOD.PokeballType.ULTRABALL] = 6,
			[EEVEEMOD.CollectibleType.MASTER_BALL] = 10
		}
		for ball, modifier in pairs(healthModifier) do
			local challenge = Isaac.GetChallenge()

			if challenge == EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL then
				healthModifier[ball] = modifier * 2
			end
		end
		if npc:IsBoss() then
			local healthToSet = (npc.MaxHitPoints / 6) * healthModifier[data.PokeballType]
			if npc.HitPoints < healthToSet then
				if data.PokeballType == EEVEEMOD.CollectibleType.MASTER_BALL then
					npc:AddHealth(npc.MaxHitPoints)
				else
					npc:AddHealth(healthToSet)
				end
			end
		else
			local healthToSet = npc.MaxHitPoints * healthModifier[data.PokeballType]
			npc.MaxHitPoints = healthToSet
			npc:AddHealth(healthToSet)
		end
	end
	data.CapturedEnemy.NPC = nil
end

---@param ball EntityEffect
---@param player EntityPlayer
local function RemoveMasterBallItem(ball, player)
	local data = ball:GetData()
	if data.PokeballType == EEVEEMOD.CollectibleType.MASTER_BALL then
		player:RemoveCollectible(EEVEEMOD.CollectibleType.MASTER_BALL)
		player:AnimateHappy()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
			for i = 1, 6 do
				local pos = EEVEEMOD.game:GetRoom():FindFreePickupSpawnPosition(ball.Position, 1) --So they don't just spawn on top of an enemy.
				player:AddWisp(EEVEEMOD.CollectibleType.MASTER_BALL, pos, true)
			end
		end
	end
end

---@param ball EntityEffect
---@param player EntityPlayer
local function ShouldDestroyBall(ball, player)
	local data = ball:GetData()
	local shouldDestroy = false
	local challenge = Isaac.GetChallenge()

	if data.CapturedEnemy.IsBoss == true
		or data.PokeballType == EEVEEMOD.CollectibleType.MASTER_BALL
		or challenge == EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
		or VeeHelper.DoesLuckChanceTrigger(50, 80, 10, player.Luck, player:GetCardRNG(data.PokeballType))
	then
		shouldDestroy = true
	end
	return shouldDestroy
end

---@param ball EntityEffect
function pokeball:OnAnimationFinishOrEvent(ball)
	local data = ball:GetData()
	local sprite = ball:GetSprite()

	if not ball.SpawnerEntity or not ball.SpawnerEntity:ToPlayer() then return end

	local player = ball.SpawnerEntity:ToPlayer()

	if sprite:IsFinished("Idle") then
		if data.CapturedEnemy and data.CapturedEnemy.NPC then
			if data.CapturedEnemy.NPC:IsBoss() and data.PokeballType ~= EEVEEMOD.CollectibleType.MASTER_BALL then
				TryCaptureBoss(data.CapturedEnemy.NPC, ball, player)
			else
				local challenge = Isaac.GetChallenge()

				if challenge == EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
					and VeeHelper.IsInStartingRoom()
					and pokeyMans:ShouldRespawnStarters() then
					sprite:SetFrame("Idle", 1)
					return
				end
				sprite:Play("Open", true)
				data.ShouldCapture = true
			end
		end
	elseif sprite:IsFinished("Shake") then
		if not data.NumShaked then data.NumShaked = 0 end
		data.NumShaked = data.NumShaked + 1
		if data.NumShaked == data.NumShouldShake then
			if data.CapturedEnemy.IsBoss == true and not data.ShouldCapture then
				sprite:Play("Destroy_Closed", true)
			else
				sprite:Play("Caught", true)
			end
		else
			EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.POKEBALL_ROLL)
			sprite:Play("Shake", true)
		end
	elseif sprite:IsEventTriggered("ClickSound") then
		EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.POKEBALL_CLICK)
	elseif sprite:IsFinished("Caught") then
		sprite:Play("Open", true)
	elseif sprite:IsEventTriggered("Release") and data.CapturedEnemy.NPC then
		ReleaseNPC(ball)
		RemoveMasterBallItem(ball, player)
		if ShouldDestroyBall(ball, player) then
			data.DestroyPokeBall = true
			if data.Pickup then
				data.Pickup:Remove()
			end
		end
	elseif sprite:IsFinished("Open") then
		if data.DestroyPokeBall then
			sprite:Play("Destroy_Open", true)
		else
			sprite:Play("Close", true)
		end
	elseif sprite:IsEventTriggered("CloseSound") then
		data.CanCollectBall = true
	elseif sprite:IsFinished("Destroy_Open") or sprite:IsFinished("Destroy_Closed") then
		DestroyPokeball(ball)
	end
end

---@param ball EntityEffect
local function RechargeMasterBallOnTouch(ball)
	local data = ball:GetData()
	if not data.CapturedEnemy
		and ball.SpawnerEntity
		and ball.SpawnerEntity:ToPlayer()
	then
		local player = ball.SpawnerEntity:ToPlayer()
		local masterBallSlot = VeeHelper.GetActiveSlots(player, EEVEEMOD.CollectibleType.MASTER_BALL)
		for i = 1, #masterBallSlot do
			if player.Position:DistanceSquared(ball.Position) <= 30
				and player:HasCollectible(EEVEEMOD.CollectibleType.MASTER_BALL)
				and player:GetActiveCharge(masterBallSlot[i]) == 0
			then
				player:SetActiveCharge(1, masterBallSlot[i])
				EEVEEMOD.sfx:Play(SoundEffect.SOUND_ITEMRECHARGE)
				ball:Remove()
				break
			end
		end
	end
end

---@param ball EntityEffect
local function HandleAttachedBallPickup(ball)
	local data = ball:GetData()
	if data.Pickup then
		data.Pickup.Velocity = ball.Position - data.Pickup.Position
		if data.CapturedEnemy and not data.CanCollectBall then
			data.Pickup:GetSprite():SetFrame(24) --Prevents from being collected.
		end
		if data.Pickup:IsDead() and not data.DestroyPokeBall then
			ball:Remove()
		end
	end
end

---@param ball EntityEffect
function pokeball:PokeballEffectUpdate(ball)
	local data = ball:GetData()
	local sprite = ball:GetSprite()

	if sprite.Offset.Y < -2 then
		sprite.Offset = sprite.Offset + Vector(0, 1.7)
	else
		if not data.BallStationary then
			sprite:Play("Idle", true)
			data.BallStationary = true
			ball.Velocity = Vector.Zero
		else
			RechargeMasterBallOnTouch(ball)
		end
	end
	HandleAttachedBallPickup(ball)
	pokeball:TryCaptureNPC(ball)
	pokeball:OnAnimationFinishOrEvent(ball)
end

function pokeball:ResetBallsOnNewRoom(player)
	local data = player:GetData()

	if data.CanThrowPokeball then
		data.CanThrowPokeball = false
		if player:HasCollectible(EEVEEMOD.CollectibleType.MASTER_BALL) then
			local masterBallSlots = VeeHelper.GetActiveSlots(player, EEVEEMOD.CollectibleType.MASTER_BALL)

			for i = 1, #masterBallSlots do
				if player:GetActiveCharge(masterBallSlots[i]) == 0 then
					player:SetActiveCharge(1, masterBallSlots[i])
					EEVEEMOD.sfx:Play(SoundEffect.SOUND_ITEMRECHARGE)
				end
			end
		end
	end
end

---@param player EntityPlayer
---@param inputHook InputHook
---@param buttonAction ButtonAction
function pokeball:ForceKeysForPokeball(player, inputHook, buttonAction)
	local data = player:GetData()

	if buttonAction == ButtonAction.ACTION_PILLCARD
		and inputHook == InputHook.IS_ACTION_TRIGGERED
		and Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, player.ControllerIndex)
		and (
		player:GetCard(0) == EEVEEMOD.PokeballType.POKEBALL
			or player:GetCard(0) == EEVEEMOD.PokeballType.GREATBALL
			or player:GetCard(0) == EEVEEMOD.PokeballType.ULTRABALL
		)
	then
		pokeball:OnPokeballUse(player:GetCard(0), player)
		return false
	end

	--Forces you to remove the Poké Ball
	if buttonAction == ButtonAction.ACTION_PILLCARD
		and data.RemovePokeball
		and data.PokeballTypeUsed ~= nil
		and data.PokeballTypeUsed ~= EEVEEMOD.CollectibleType.MASTER_BALL then
		return true
	end
end

local PokeGoEnemies = {
	EntityType.ENTITY_ATTACKFLY,
	EntityType.ENTITY_FAT_BAT,
	EntityType.ENTITY_GAPER,
	EntityType.ENTITY_ONE_TOOTH,
	EntityType.ENTITY_POOTER,
	EntityType.ENTITY_VIS
}

---@param familiar EntityFamiliar
function pokeball:OnMasterBallWispDeath(familiar)
	if familiar.Variant ~= FamiliarVariant.WISP or familiar.SubType ~= EEVEEMOD.CollectibleType.MASTER_BALL then return end
	local wispRNG = RNG()
	wispRNG:SetSeed(familiar.InitSeed, 35)
	local randomInt = wispRNG:RandomInt(6) + 1
	local charmed = Isaac.Spawn(PokeGoEnemies[randomInt], 0, 0, familiar.Position, Vector.Zero, nil)
	charmed:AddCharmed(EntityRef(familiar), -1)
end

return pokeball
