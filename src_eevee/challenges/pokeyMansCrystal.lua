local pokeyMans = {}

local startersSpawned = false
local startersCaptured = 0
local SPAWN_DELAY = 60
local spawnDelay = 60
local pokeballIdleReset = false

---@param player EntityPlayer
function pokeyMans:OnChallengePlayerInit(player)
	local challenge = Isaac.GetChallenge()
	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY) then return end

	player:AddCard(EEVEEMOD.PokeballType.POKEBALL)
	player:AddCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, 0, false)
	player:AddCollectible(EEVEEMOD.CollectibleType.LIL_EEVEE)
	player:ClearCostumes()
	player:AddNullCostume(EEVEEMOD.NullCostume.TRAINER_CAP)
end

local function SpawnStarters()
	local level = EEVEEMOD.game:GetLevel()
	local room = EEVEEMOD.game:GetRoom()
	local spawnPosX = {
		195,
		320,
		460
	}
	local entsToSpawn = {
		{ EntityType.ENTITY_DANNY, 1 },
		{ EntityType.ENTITY_BUBBLES, 0 },
		{ EntityType.ENTITY_MAW, 2 }
	}
	local gridIndex = {
		7,
		60,
		74,
		127
	}

	for i = 1, #gridIndex do
		local gridDoor = room:GetGridEntity(gridIndex[i]):ToDoor()
		if gridDoor ~= nil then
			gridDoor:Close(true)
		end
	end

	for i = 1, 3 do
		local ent = Isaac.Spawn(entsToSpawn[i][1], entsToSpawn[i][2], 0, Vector(spawnPosX[i], 280), Vector.Zero, nil):ToNPC()
		ent:GetData().StarterPokemon = true
		ent.CanShutDoors = true
		ent:AddEntityFlags(EntityFlag.FLAG_CONFUSION)
	end
	level:GetCurrentRoom():Update()
	startersSpawned = true
end

function pokeyMans:InitChallenge()
	local challenge = Isaac.GetChallenge()

	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
		or not VeeHelper.IsInStartingRoom()
	then
		return
	end
	SpawnStarters()
	startersCaptured = 0
	spawnDelay = 60
	pokeballIdleReset = false
end

function pokeyMans:ShouldRespawnStarters()
	return startersCaptured < #VeeHelper.GetAllMainPlayers()
end

function pokeyMans:TryRespawnStarters()
	local challenge = Isaac.GetChallenge()
	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
		or not VeeHelper.IsInStartingRoom() then
		return
	end

	if EEVEEMOD.game:GetFrameCount() == 1 then
		for _, p in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			local player = p:ToPlayer()
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			player:EvaluateItems()
		end
	end

	if startersSpawned == false then
		if pokeyMans:ShouldRespawnStarters() then
			if spawnDelay > 0 then
				spawnDelay = spawnDelay - 1
			else
				SpawnStarters()
				spawnDelay = SPAWN_DELAY
			end
		else
			if pokeballIdleReset == false then
				local shouldProceed = true
				for loop = 1, 2 do
					for _, pokeball in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.POKEBALL)) do
						local sprite = pokeball:GetSprite()
						if loop == 1 then
							if sprite:IsPlaying("Thrown") then
								shouldProceed = false
							end
						else
							if shouldProceed == true then
								pokeballIdleReset = true
							end
							if not sprite:IsPlaying("Thrown") then
								sprite:SetFrame("Idle", 1)
							end
						end
					end
				end
			end
		end
	end
end

---@param npc EntityNPC
function pokeyMans:StarterNPCUpdate(npc)
	local data = npc:GetData()

	if data.StarterPokemon and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then

		npc.Velocity = Vector.Zero

		for _, pokeball in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.POKEBALL)) do
			local pokeData = pokeball:GetData()

			if pokeData.CapturedEnemy and pokeData.CapturedEnemy.NPC and pokeball:GetSprite():IsPlaying("Thrown") then
				if pokeData.CapturedEnemy.NPC.InitSeed ~= npc.InitSeed then
					if npc.Type == EntityType.ENTITY_MAW then
						local eternalFlies = Isaac.FindByType(EntityType.ENTITY_ETERNALFLY)
						for _, eternalFly in ipairs(eternalFlies) do

							if eternalFly:Exists() then
								eternalFly:Remove()
							end
						end
					end
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, nil)
					npc:Remove()
				else
					data.StarterPokemon = nil
					startersSpawned = false
					startersCaptured = startersCaptured + 1
				end
			end
		end
	end
end

---@param collectible EntityPickup
function pokeyMans:ReplaceItemsOnInit(collectible)
	local challenge = Isaac.GetChallenge()
	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL then return end

	local quality = Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality
	local ballType = EEVEEMOD.PokeballType.POKEBALL

	if quality == 4 then
		ballType = EEVEEMOD.PokeballType.ULTRABALL
	elseif quality == 3 or quality == 2 then
		ballType = EEVEEMOD.PokeballType.GREATBALL
	end

	collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, ballType, true, false, true)
	collectible:IsShopItem()
end

---@param collider Entity
function pokeyMans:PrePickupCollision(_, collider)
	local challenge = Isaac.GetChallenge()
	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
		or not collider:ToPlayer()
		or EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal == true then
		return
	end

	CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" ..
		EEVEEMOD.AchievementGraphics.PokeyMansCrystal .. ".png")
	EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal = true
end

---@param rng RNG
---@param spawnPos Vector
function pokeyMans:OnClearReward(rng, spawnPos)
	local challenge = Isaac.GetChallenge()
	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL then return end
	local roomDesc = EEVEEMOD.game:GetLevel():GetCurrentRoomDesc()
	local roomType = roomDesc.Data.Type

	if roomType == RoomType.ROOM_BOSS then
		for _, p in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			local player = p:ToPlayer()
			if not player.Parent then
				local healthType = VeeHelper:GetPlayerHealthType(player:GetPlayerType())
				if healthType >= VeeHelper.PlayerHealthType.NORMAL then
					player:AnimateHappy()
					player:AddMaxHearts(2, false)
					player:AddHearts(2)
					local variant = healthType == VeeHelper.PlayerHealthType.BLACK_ONLY and 5 or
						healthType == VeeHelper.PlayerHealthType.SOUL_ONLY and 4 or 0
					local notify = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, variant, player.Position, Vector.Zero,
						player):ToEffect()
					notify.Parent = player
					notify:FollowParent(notify.Parent)
					notify:GetSprite().Offset = Vector(0, -24)
					notify.RenderZOffset = 1000
				end
			end
		end
		---@param e Entity
		for _, e in ipairs(Isaac.FindInRadius(EEVEEMOD.game:GetRoom():GetCenterPos(), 1500, EntityPartition.ENEMY)) do
			local npc = e:ToNPC()
			if npc and npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL) then
				local notify = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, npc.Position, Vector.Zero, npc):
					ToEffect()
				notify.Parent = npc
				notify:FollowParent(notify.Parent)
				notify:GetSprite().Offset = Vector(0, -24)
				notify.RenderZOffset = 1000
				npc:AddHealth(npc.MaxHitPoints)
				npc:SetColor(Color(1, 1, 1, 1, 0.5, 0, 0), 15, 5, true, true)
			end
		end
	elseif roomType == RoomType.ROOM_DEFAULT then
		local spawnChance = 0.30
		if rng:RandomFloat() < spawnChance then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, EEVEEMOD.PokeballType.POKEBALL, EEVEEMOD.game:GetRoom():FindFreePickupSpawnPosition(spawnPos),
				Vector.Zero, nil)
			return true
		end
	end
end

return pokeyMans
