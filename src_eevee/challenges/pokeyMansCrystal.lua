local pokeyMans = {}

--TODO: Spawn Brother Bobby as a temporary helper when you have no friends :(

function pokeyMans:OnChallengeInit(player)
	local challenge = Isaac.GetChallenge()

	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL then return end

	player:AddCard(EEVEEMOD.PokeballType.POKEBALL)
	player:AddCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, 0, false)
	player:AddCollectible(CollectibleType.COLLECTIBLE_BROTHER_BOBBY)
	player:ClearCostumes()
	--player:AddNullCostume(EEVEEMOD.NullCostume.POKEMON_MASTER)
end

function pokeyMans:SpawnStarters()
	local challenge = Isaac.GetChallenge()
	local level = EEVEEMOD.game:GetLevel()
	local room = EEVEEMOD.game:GetRoom()
	local roomIndex = level:GetCurrentRoomDesc().SafeGridIndex
	local startingRoomIndex = level:GetStartingRoomIndex()

	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
		or roomIndex ~= startingRoomIndex
		or level:GetStage() ~= LevelStage.STAGE1_1
		or (EEVEEMOD.game:GetFrameCount() > 0 and level:GetCurrentRoom():IsFirstVisit() == false)
	then
		return
	end
	local players = VeeHelper.GetAllPlayers()
	for i = 1, #players do
		local player = players[i]
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
		player:EvaluateItems()
	end

	local spawnPosX = {
		195,
		320,
		460
	}
	local entsToSpawn = {
		{ EntityType.ENTITY_FLAMINGHOPPER, 0 },
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
end

function pokeyMans:StarterNPCUpdate(npc)
	local data = npc:GetData()

	if data.StarterPokemon and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		npc.Velocity = Vector.Zero

		for _, pokeball in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.POKEBALL)) do
			local pokeData = pokeball:GetData()

			if pokeData.CapturedEnemy and pokeData.CapturedEnemy.NPC then
				if pokeData.CapturedEnemy.NPC.InitSeed ~= npc.InitSeed then
					if npc.Type == EntityType.ENTITY_MAW then
						local eternalFlies = Isaac.FindByType(EntityType.ENTITY_ETERNALFLY)
						local eternalFly = eternalFlies[1]

						if eternalFly:Exists() then
							eternalFly:Remove()
						end
					end
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, nil)
					npc:Remove()
				end
			end
		end
	elseif data.StarterPokemon and npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
		npc:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
		data.StarterPokemon = nil
	end
end

function pokeyMans:ReplaceItemsOnInit(collectible)
	local challenge = Isaac.GetChallenge()

	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL then return end

	local quality = Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality
	local ballType = EEVEEMOD.PokeballType.POKEBALL

	if quality == 4 then
		ballType = EEVEEMOD.PokeballType.ULTRABALL
	elseif quality == 3 then
		ballType = EEVEEMOD.PokeballType.GREATBALL
	end

	collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, ballType, true, false, true)
	collectible:IsShopItem()
end

function pokeyMans:PrePickupCollision(pickup, collider)
	local challenge = Isaac.GetChallenge()
	if challenge ~= EEVEEMOD.Challenge.POKEY_MANS_CRYSTAL
		or collider.Type ~= EntityType.ENTITY_PLAYER
		or EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal == true then
		return
	end

	CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.PokeyMansCrystal .. ".png")
	EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal = true
end

return pokeyMans
