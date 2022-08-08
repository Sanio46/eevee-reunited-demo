local Tracker = {}

local UnlocksTemplate = {
	MomsHeart = { Unlock = false, Hard = false },
	Isaac = { Unlock = false, Hard = false },
	Satan = { Unlock = false, Hard = false },
	BlueBaby = { Unlock = false, Hard = false },
	Lamb = { Unlock = false, Hard = false },
	BossRush = { Unlock = false, Hard = false },
	Hush = { Unlock = false, Hard = false },
	MegaSatan = { Unlock = false, Hard = false },
	Delirium = { Unlock = false, Hard = false },
	Mother = { Unlock = false, Hard = false },
	Beast = { Unlock = false, Hard = false },
	GreedMode = { Unlock = false, Hard = false },
	FullCompletion = { Unlock = false, Hard = false },
}

local function UpdateCompletion(name, difficulty)
	for p = 0, EEVEEMOD.game:GetNumPlayers() - 1 do
		local pType = Isaac.GetPlayer(p):GetPlayerType()

		if EEVEEMOD.IsPlayerEeveeOrEvolved[pType] then
			local TargetTab = EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee

			if TargetTab[name].Unlock == false then
				TargetTab[name].Unlock = true

				if EEVEEMOD.AchievementGraphics.Eevee[name] then
					CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee[name] .. ".png")
				end
			end
			if difficulty == Difficulty.DIFFICULTY_HARD then
				TargetTab[name].Hard = true
			elseif difficulty == Difficulty.DIFFICULTY_GREEDIER then
				if TargetTab[name].Hard == false then
					TargetTab[name].Hard = true

					CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee.Greedier .. ".png")
				end
			end

			local MissingUnlock = false
			local MissingHard = false
			for boss, tab in pairs(TargetTab) do
				if boss ~= "FullCompletion"
					and type(tab) == "table"
				then
					if tab.Unlock == false then
						MissingUnlock = true
						break
					end
					if tab.Hard == false then
						MissingHard = true

						if boss == "GreedMode" then
							MissingUnlock = true
							break
						end
					end
				end
			end

			if (not MissingUnlock) then
				if not TargetTab.FullCompletion.Unlock then
					TargetTab.FullCompletion.Unlock = true
					CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee.FullCompletion .. ".png")
				end

				if (not MissingHard)
					and (not TargetTab.FullCompletion.Hard)
				then
					TargetTab.FullCompletion.Hard = true
				end
			end
		elseif pType == EEVEEMOD.PlayerType.EEVEE_B then
			local TargetTab = EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee_B

			if TargetTab[name].Unlock == false then
				TargetTab[name].Unlock = true

				if EEVEEMOD.AchievementGraphics.Eevee_B[name] then
					CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee_B[name] .. ".png")
				end
			end
			if difficulty == Difficulty.DIFFICULTY_HARD then
				TargetTab[name].Hard = true
			elseif difficulty == Difficulty.DIFFICULTY_GREEDIER then
				if TargetTab[name].Hard == false then
					TargetTab[name].Hard = true

					CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee_B.Greedier .. ".png")
				end
			end

			if TargetTab.PolNegPath == false
				and TargetTab.Isaac.Unlock == true
				and TargetTab.BlueBaby.Unlock == true
				and TargetTab.Satan.Unlock == true
				and TargetTab.Lamb.Unlock == true
			then
				TargetTab.PolNegPath = true

				CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee_B.PolNegPath .. ".png")
			end

			if TargetTab.SoulPath == false
				and TargetTab.BossRush.Unlock == true
				and TargetTab.Hush.Unlock == true
			then
				TargetTab.SoulPath = true

				CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee_B.SoulPath .. ".png")
			end

			local MissingUnlock = false
			local MissingHard = false
			for boss, tab in pairs(TargetTab) do
				if boss ~= "FullCompletion"
					and type(tab) == "table"
				then
					if tab.Unlock == false then
						MissingUnlock = true
						break
					end
					if tab.Hard == false then
						MissingHard = true

						if boss == "GreedMode" then
							MissingUnlock = true
							break
						end
					end
				end
			end

			if (not MissingUnlock)
				and TargetTab.Haunted
			then
				if not TargetTab.FullCompletion.Unlock then
					TargetTab.FullCompletion.Unlock = true
					CCO.AchievementDisplayAPI.PlayAchievement("gfx/ui/achieeveements/" .. EEVEEMOD.AchievementGraphics.Eevee_B.FullCompletion .. ".png")
				end

				if (not MissingHard)
					and (not TargetTab.FullCompletion.Hard)
				then
					TargetTab.FullCompletion.Hard = true
				end
			end
		end
	end
end

local UnlockFunctions = {
	[LevelStage.STAGE4_2] = function(room, stageType, difficulty, desc) -- Heart / Mother
		if room:IsClear() then
			local Name
			if stageType >= StageType.STAGETYPE_REPENTANCE
				and desc.SafeGridIndex == -10
			then
				Name = "Mother"
			elseif stageType <= StageType.STAGETYPE_AFTERBIRTH
				and room:IsCurrentRoomLastBoss()
			then
				Name = "MomsHeart"
			end

			if Name then
				UpdateCompletion(Name, difficulty)
			end
		end
	end,
	[LevelStage.STAGE4_3] = function(room, stageType, difficulty, desc) -- Hush
		if room:IsClear() then
			local Name = "Hush"

			UpdateCompletion(Name, difficulty)
		end
	end,
	[LevelStage.STAGE5] = function(room, stageType, difficulty, desc) -- Satan / Isaac
		if room:IsClear() then
			local Name = "Satan"
			if stageType == StageType.STAGETYPE_WOTL then
				Name = "Isaac"
			end

			UpdateCompletion(Name, difficulty)
		end
	end,
	[LevelStage.STAGE6] = function(room, stageType, difficulty, desc) -- Mega Satan / Lamb / Blue Baby
		if desc.SafeGridIndex == -7 then
			local MegaSatan
			for _, satan in ipairs(Isaac.FindByType(EntityType.ENTITY_MEGA_SATAN_2, 0)) do
				MegaSatan = satan
				break
			end

			if not MegaSatan then return end

			local sprite = MegaSatan:GetSprite()

			if sprite:IsPlaying("Death") and sprite:GetFrame() == 110 then
				local Name = "MegaSatan"

				UpdateCompletion(Name, difficulty)
			end
		else
			if room:IsClear() then
				local Name = "Lamb"
				if stageType == StageType.STAGETYPE_WOTL then
					Name = "BlueBaby"
				end

				UpdateCompletion(Name, difficulty)
			end
		end
	end,
	[LevelStage.STAGE7] = function(room, stageType, difficulty, desc) -- Delirium
		if desc.Data.Subtype == 70 and room:IsClear() then
			local Name = "Delirium"

			UpdateCompletion(Name, difficulty)
		end
	end,

	BossRush = function(room, stageType, difficulty, desc) -- Boss Rush
		if room:IsAmbushDone() then
			local Name = "BossRush"

			UpdateCompletion(Name, difficulty)
		end
	end,
	Beast = function(room, stageType, difficulty, desc) -- Beast
		local Beast
		for _, beast in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, 0)) do
			Beast = beast
			break
		end

		if not Beast then return end

		local sprite = Beast:GetSprite()

		if sprite:IsPlaying("Death") and sprite:GetFrame() == 30 then
			local Name = "Beast"

			UpdateCompletion(Name, difficulty)
		end
	end,
	Greed = function(room, stageType, difficulty, desc) -- Greed
		if room:IsClear() then
			local Name = "GreedMode"

			UpdateCompletion(Name, difficulty)
		end
	end,
}

function Tracker.postUpdate()
	local level = EEVEEMOD.game:GetLevel()
	local room = EEVEEMOD.game:GetRoom()
	local desc = level:GetCurrentRoomDesc()
	local levelStage = level:GetStage()
	local roomType = room:GetType()
	local difficulty = EEVEEMOD.game.Difficulty

	if Isaac.GetChallenge() > 0
		or EEVEEMOD.game:GetVictoryLap() > 0
	then
		return
	end

	if difficulty <= Difficulty.DIFFICULTY_HARD then
		local stageType = level:GetStageType()

		if levelStage == LevelStage.STAGE4_1
			and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0
		then
			levelStage = levelStage + 1
		end

		if roomType == RoomType.ROOM_BOSS and UnlockFunctions[levelStage] then
			UnlockFunctions[levelStage](room, stageType, difficulty, desc)
		elseif roomType == RoomType.ROOM_BOSSRUSH then
			UnlockFunctions.BossRush(room, stageType, difficulty, desc)
		elseif levelStage == LevelStage.STAGE8 and roomType == RoomType.ROOM_DUNGEON then
			UnlockFunctions.Beast(room, stageType, difficulty, desc)
		end
	else
		if levelStage == LevelStage.STAGE7_GREED
			and roomType == RoomType.ROOM_BOSS
			and desc.SafeGridIndex == 45
		then
			UnlockFunctions.Greed(room, nil, difficulty, desc)
		end
	end
end

function Tracker.CreateUnlocksTemplate()
	local UnlockTab = {}

	for i, v in pairs(UnlocksTemplate) do
		UnlockTab[i] = v
	end

	return UnlockTab
end

return Tracker
