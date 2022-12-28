local executeCmd = {}

---@param cmd string
---@param params string
function executeCmd:main(cmd, params)
	if cmd == "eeveemod" then
		local unlockType = ""
		if string.sub(params, 1, 6) == "unlock" then
			unlockType = "unlock "
		elseif string.sub(params, 1, 13) == "taintedunlock" then
			unlockType = "taintedunlock "
		elseif string.sub(params, 1, 4) == "help" then
			print("[Eevee: Reunited] Available debug commands:")
			print("help - List all available debug commands")
			print("unlock - Toggle an avaliable unlock from the mod")
		end

		if unlockType ~= "" then
			local char = unlockType == "taintedunlock " and "Eevee_B" or "Eevee"
			local unlock = string.sub(params, string.len(unlockType) + 1, -1)

			if unlock == "" then
				print("[Eevee: Reunited] Instructions on the unlock command:")
				print("'eeveemod unlock/taintedunlock UnlockName true/false'")
				print("Unlock Names: MomsHeart, Isaac, Satan, BlueBaby, Lamb, BossRush, Hush, MegaSatan, Beast, GreedMode, GreedierMode, FullCompletion, PokeyMansCrystal, Tainted, All")
				return
			end
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
				"PokeyMansCrystal",
				"Tainted",
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
				local stateString = string.sub(unlock, string.len(boss) + 2, -1)
				if string.sub(stateString, 1, 4) == "true" or string.sub(stateString, 1, 5) == "false" or string.sub(stateString, 1, 1) == "" then
					local shouldDisplay = false
					local state = (stateString == "true" or stateString == "") and true or stateString == "false" and false

					if EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss] ~= nil then
						if boss == "Tainted" then
							if unlockType == "unlock " then
								EEVEEMOD.PERSISTENT_DATA.UnlockData.Eevee.Tainted = state
							else
								return
							end
						else
							EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss].Unlock = state
							if boss ~= "GreedMode" then
								EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss].Hard = state
							end
						end
						shouldDisplay = true
					elseif boss == "GreedierMode" then
						EEVEEMOD.PERSISTENT_DATA.UnlockData[char]["GreedMode"].Hard = state
						shouldDisplay = true
					elseif boss == "PokeyMansCrystal" then
						EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal = state
						shouldDisplay = true
					elseif boss == "All" then
						for boss, unlocks in pairs(EEVEEMOD.PERSISTENT_DATA.UnlockData[char]) do
							if boss == "Tainted" then
								EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss] = state
							else
								EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss].Unlock = state
								EEVEEMOD.PERSISTENT_DATA.UnlockData[char][boss].Hard = state
							end
						end
						EEVEEMOD.PERSISTENT_DATA.UnlockData.PokeyMansCrystal = state
						shouldDisplay = true
					end
					if shouldDisplay then
						local bossToName = {
							["PokeyMansCrystal"] = "Challenge 'Pokey Mans: Crystal'",
							["MomsHeart"] = "Mom's Heart",
							["BlueBaby"] = "???",
							["BossRush"] = "Boss Rush",
							["MegaSatan"] = "Mega Satan",
							["GreedierMode"] = "Greedier Mode",
						}
						local unlockName = bossToName[boss] or boss
						local stateName = state == true and "enabled" or "disabled"
						local charName = char == "Eevee_B" and "Tainted Eevee (who has nothing yet lmao)" or char
						if boss == "All" then
							print("All of " .. charName .. "'s unlocks have been " .. stateName .. "!")
						elseif boss == "PokeyMansCrystal" then
							print("Unlock for " .. unlockName .. " has been " .. stateName)
						elseif boss == "Tainted" then
							print("Tainted Eevee has been " .. stateName .. ", but they're unavailable regardless.")
						else
							print(charName .. "'s unlock for " .. unlockName .. " has been " .. stateName)
						end
					end
				end
			else
				print("Invalid unlock name. For a list of valid unlock names, type 'eeveemod unlock'")
			end
		end
	end
end

function executeCmd:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_EXECUTE_CMD, executeCmd.main)
end

return executeCmd
