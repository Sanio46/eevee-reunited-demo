local modConfigMenu = {}

if ModConfigMenu then
	--shamelessly copied from chatty devil who copied from pog mod and then copied again from chatty keepers
	ModConfigMenu.UpdateCategory(EEVEEMOD.Name, {
			Info = {EEVEEMOD.Name,}
		})
	--Title
	ModConfigMenu.AddText(EEVEEMOD.Name, "Settings", function() return EEVEEMOD.Name end)
	ModConfigMenu.AddSpace(EEVEEMOD.Name, "Settings")
	-- Settings
	ModConfigMenu.AddSetting(EEVEEMOD.Name, "Settings", 
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EEVEEMOD.Data.CustomDolly
			end,
			Display = function()
				local onOff = "False"
				if EEVEEMOD.Data.CustomDolly then
					onOff = "True"
				end
				return 'Custom Mr. Dollys: ' .. onOff
			end,
			OnChange = function(currentBool)
				EEVEEMOD.Data.CustomDolly = currentBool
			end,
			Info = {"Gives Eevee a unique Mr. Dolly sprite. Mr. Dolly's sprite will be replaced if on a pedestal and the first player is Eevee."}
		})
	ModConfigMenu.AddSetting(EEVEEMOD.Name, "Settings", 
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return EEVEEMOD.Data.CustomSpiritSword
			end,
			Display = function()
				local onOff = "False"
				if EEVEEMOD.Data.CustomSpiritSword then
					onOff = "True"
				end
				return 'Unique Spirit Sword: ' .. onOff
			end,
			OnChange = function(currentBool)
				EEVEEMOD.Data.CustomSpiritSword = currentBool
			end,
			Info = {"Gives Eevee a unique Spirit Sword sprite"}
		})
end
		
return modConfigMenu