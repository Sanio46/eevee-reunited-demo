local executeCmd = {}

function executeCmd:main(cmd, params)
	if cmd == "eeveemod" then
		local unlockType = ""
		if string.sub(params, 1, 7) == "unlock " then
			unlockType = "unlock "
		elseif string.sub(params, 1, 14) == "taintedunlock " then
			unlockType = "taintedunlock "
		end
		if unlockType ~= nil then
			local char = unlockType == "taintedunlock " and "Eevee_B" or "Eevee"
			local unlock = string.sub(params, string.len(unlockType) + 1, -1)

			local validBosses = {
				"MomsHeart",
				"Isaac",
				"Satan",
				"BlueBaby",
				"Lamb",
				"BossRush",
				"Hush",
				"MegaSatan",
				"Delirium",
				"Mother",
				"Beast",
				"GreedMode",
				"GreedierMode",
				"FullCompletion",
				"All",
			}
			local boss = nil
			for i = 1, #validBosses do
				if string.sub(string.lower(unlock), 1, string.len(validBosses[i])) == string.lower(validBosses[i]) then
					boss = validBosses[i]
					break
				end
			end
			if boss ~= nil then
				local state = string.sub(unlock, string.len(boss) + 2, -1)
				if string.sub(state, 1, 4) == "true" or string.sub(state, 1, 5) == "false" then
					local shouldDisplay = false
					if EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss] ~= nil then
						EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss].Unlock = state
						if boss ~= "GreedMode" then
							EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss].Hard = state
						end
						shouldDisplay = true
					elseif boss == "GreedierMode" then
						EEVEEMOD.PERSISTENT_DATA.UnlockData[char]["GreedMode"].Hard = state
						shouldDisplay = true
					elseif boss == "All" then
						EEVEEMOD.PERSISTENT_DATA.UnlockData[char]["FullCompletion"].Hard = state
						shouldDisplay = true
					end
					if shouldDisplay then
						local bossToName = {
							["MomsHeart"] = "Mom's Heart",
							["BlueBaby"] = "???",
							["BossRush"] = "Boss Rush",
							["MegaSatan"] = "Mega Satan",
							["GreedierMode"] = "Greedier Mode",
						}
						local unlockName = bossToName[boss] or boss
						local stateName = state == "true" and "enabled" or "disabled"
						local charName = char == "Eevee_B" and "Tainted Eevee (who has nothing yet lmao)" or char
						if boss == "All" or boss == "FullCompletion" then
							print("All of "..charName.."'s unlocks have been "..stateName.."!")
						else
							print(charName.."'s unlock for "..unlockName.." has been "..stateName)
						end
					end
				end
			end
		end
	end
end

function executeCmd:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_EXECUTE_CMD, executeCmd.main)
end

return executeCmd