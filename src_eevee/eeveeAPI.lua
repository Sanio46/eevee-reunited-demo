local EEVEEMOD = EEVEEMOD or {}
EEVEEMOD.API = {}

--Credit: tem
function EEVEEMOD.API.SetCanShoot(player, canShoot)
	local oldChallenge = EEVEEMOD.game.Challenge
	EEVEEMOD.game.Challenge = canShoot and 0 or 6
	player:UpdateCanShoot()
	EEVEEMOD.game.Challenge = oldChallenge
end

function EEVEEMOD.API.PlayerCanControl(player)
	local canControl = false
	
	if not EEVEEMOD.game:IsPaused()
	and not player:IsDead()
	and player.ControlsEnabled
	then
		canControl = true
	end
	
	return canControl
end

function EEVEEMOD.API.IsPlayerWalking(player)
	local isWalking = false
	local pSprite = player:GetSprite()
	
	if pSprite:GetAnimation() == "WalkLeft"
	or pSprite:GetAnimation() == "WalkUp"
	or pSprite:GetAnimation() == "WalkRight"
	or pSprite:GetAnimation() == "WalkDown"
	then
		isWalking = true
	end
	
	return isWalking
end

function EEVEEMOD.API.DetectNearestEnemy(ent, range)
	local closestEnemy = nil --placeholder variable we'll put the closest enemy in
   local closestDistance = nil --placeholder variable we'll put the distance in
	for _, npc in pairs (Isaac.FindInRadius(ent.Position, range, EntityPartition.ENEMY)) do --if there are enemies, dumbass.
		if npc:IsActiveEnemy() and npc:IsVulnerableEnemy() then --if its an active enemy
	
			local npcDistance = npc.Position:Distance(ent.Position) --calculate the distance of this npc from the starting position of the ent
			
			if not closestEnemy or npcDistance < closestDistance then --if we never stored any variables OR if this npc is closer than the closest one we stored last
				closestEnemy = npc --store this npc in the variable
				closestDistance = npcDistance --store this distance in the variable
				return closestEnemy
			end
		end
	end
end

function EEVEEMOD.API.PlayerStandingStill(player)
	if not EEVEEMOD.game:IsPaused() and not player:IsDead() and player.ControlsEnabled and
	not (Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex)
	or Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex)
	or Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex)
	or Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex)) then
		return true
	else
		return false
	end
end

function FindMarkedTarget(player)
	local targetPos = nil
	for _, target in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0)) do
		if target.SpawnerEntity.Index == player.Index then
			targetPos = target.Position
		end
	end
	for _, target in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.OCCULT_TARGET, 0)) do
		if target.SpawnerEntity.Index == player.Index then
			targetPos = target.Position
		end
	end
	return targetPos
end

function EEVEEMOD.API.GetIsaacShootingDirection(player, weapon)
	local shootDir = player:GetShootingInput()
	local data = player:GetData()
	local HeadDirectionFire = Vector(-1, 0):Rotated(90 * player:GetHeadDirection())
	local ShootDirectionFire = Vector(-1, 0):Rotated(90 * player:GetFireDirection())
	
	if not data.LastSavedShootDirection then
		data.LastSavedShootDirection = HeadDirectionFire
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)
	or player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT)
	and (player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) 
	or player:HasWeaponType(WeaponType.WEAPON_LASER)) then
		if FindMarkedTarget(player) ~= nil and weapon ~= nil then
			data.LastSavedShootDirection = (FindMarkedTarget(player) - weapon.Position):Normalized()
		end
	elseif (
	player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK)
	or player:HasWeaponType(WeaponType.WEAPON_KNIFE)
	) then
		if shootDir.X ~= 0 or shootDir.Y ~= 0 then
			data.LastSavedShootDirection =  player:GetShootingInput()
		end
	elseif player:GetFireDirection() ~= -1 then
		data.LastSavedShootDirection = ShootDirectionFire
	end
	if data.LastSavedShootDirection ~= nil then
		return data.LastSavedShootDirection
	else --Failsafe
		return HeadDirectionFire
	end
end

function EEVEEMOD.API.GetActiveSlot(player, itemID)
	for i = 0, 3 do
		if player:GetActiveItem(i) == itemID then
			return i
		end
	end
end

function EEVEEMOD.API.DoesLuckChanceTrigger(baseChance, maxChance, luckValue, currentLuck)
	local number = baseChance + (currentLuck * luckValue)
	if number > maxChance then
		number = maxChance
	end
	if EEVEEMOD.RandomNum(100) <= number then
		return true
	else
		return false
	end
end

local wasRoomCleared = true
local greedWaveCheck = 0
local enemySpawnCounterClearCountdown = 10
local enemySpawnCounter = 0
local enemySpawnCounterTrack = 0
local enemySpawnCounterMax = 0
local enemySpawnCounterMaxSet = false

function EEVEEMOD.API.RoomClearTriggered(player)
	local room = EEVEEMOD.game:GetRoom()
	local triggerRoomClear = false
	
	if not EEVEEMOD.game:IsGreedMode() then
		local roomType = room:GetType()
		
		--CHALLENGE ROOMS
		if roomType == RoomType.ROOM_CHALLENGE and room:IsAmbushActive() then
			if enemySpawnCounterClearCountdown > 0 then
				enemySpawnCounterClearCountdown = enemySpawnCounterClearCountdown - 1
				if enemySpawnCounterClearCountdown == 0 then
					enemySpawnCounter = 0
				end
			end
			
			for _, ent in pairs(Isaac.FindInRadius(player.Position, 1500, EntityPartition.ENEMY)) do
				if ent:IsActiveEnemy(false) and ent:IsVulnerableEnemy() then
					if ent.FrameCount == 2 then
						enemySpawnCounter = enemySpawnCounter + 1
						enemySpawnCounterClearCountdown = 10
					end
					
					if enemySpawnCounter ~= 0 then
						if enemySpawnCounterTrack ~= enemySpawnCounter then
							enemySpawnCounterTrack = enemySpawnCounter
							enemySpawnCounterMaxSet = false
						else
							if enemySpawnCounterMaxSet == false then
								enemySpawnCounterMax = enemySpawnCounterTrack
								enemySpawnCounterMaxSet = true
							end
						end
						
						if enemySpawnCounter == enemySpawnCounterMax and enemySpawnCounterMaxSet then
							enemySpawnCounterMax = enemySpawnCounterMax + 1
							enemySpawnCounterClearCountdown = 10
							triggerRoomClear = true
						end
					end
				end
			end

		--BOSS RUSH
		elseif roomType == RoomType.ROOM_BOSSRUSH and room:IsAmbushActive() then
			if enemySpawnCounterClearCountdown > 0 then
				enemySpawnCounterClearCountdown = enemySpawnCounterClearCountdown - 1
				if enemySpawnCounterClearCountdown == 0 then
					enemySpawnCounter = 0
				end
			end
			
			for _, ent in pairs(Isaac.FindInRadius(player.Position, 1500, EntityPartition.ENEMY)) do
				if ent:IsBoss() then
					if ent.FrameCount == 2 then
						local npc = ent:ToNPC()
						if not npc.ParentNPC then --so we dont do stuff for each segment of segmented bosses
							enemySpawnCounter = enemySpawnCounter + 1
							enemySpawnCounterClearCountdown = 10
						end
					end

					if enemySpawnCounter == 2 then
						enemySpawnCounter = enemySpawnCounter + 1
						enemySpawnCounterClearCountdown = 10
						triggerRoomClear = true
					end
				end
			end

		else --NORMAL ROOMS
			if room:IsClear() and wasRoomCleared == false then
				triggerRoomClear = true
			end
			wasRoomCleared = room:IsClear()
		end
	else
		--GREED MODE
		local greedWave = EEVEEMOD.game:GetLevel().GreedModeWave
		if greedWaveCheck ~= greedWave and greedWave ~= 0 then
			greedWaveCheck = greedWave
			triggerRoomClear = true
		end
	end
	
	return triggerRoomClear
end

function EEVEEMOD.API.PlayerAnimationPlaying(player)
	local playing = false
	for i = 1, #EEVEEMOD.AnimBlacklist do
		if player:GetSprite():IsPlaying(EEVEEMOD.AnimBlacklist[i]) then
			playing = true
		end
	end
	if playing == true then
		return true
	else
		return false
	end
end

function EEVEEMOD.API.GiveRGB(ent)
	ent.Color = Color(EEVEEMOD.RGB.R/255,EEVEEMOD.RGB.G/255,EEVEEMOD.RGB.B/255,ent.Color.A,0,0,0)
end

function EEVEEMOD.API.SkinColor(player, useBody)
	local skinColor = player:GetHeadColor() or useBody and player:GetBodyColor()

	return EEVEEMOD.SkinColorToString[skinColor]
end

-------------------
--  SWIFT STUFF  --
-------------------

return EEVEEMOD.API