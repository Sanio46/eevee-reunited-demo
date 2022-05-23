local modConfigMenu = {}

if not ModConfigMenu then return modConfigMenu end

--shamelessly copied from chatty devil who copied from pog mod and then copied again from chatty keepers
ModConfigMenu.UpdateCategory(EEVEEMOD.Name, {
	Info = { EEVEEMOD.Name, }
})
--Title
ModConfigMenu.AddText(EEVEEMOD.Name, "Settings", function() return EEVEEMOD.Name end)
ModConfigMenu.AddSpace(EEVEEMOD.Name, "Settings")
-- Settings
ModConfigMenu.AddSetting(EEVEEMOD.Name, "Settings",
	{
	Type = ModConfigMenu.OptionType.BOOLEAN,
	CurrentSetting = function()
		return EEVEEMOD.PERSISTENT_DATA.CustomDolly
	end,
	Display = function()
		local onOff = "False"
		if EEVEEMOD.PERSISTENT_DATA.CustomDolly then
			onOff = "True"
		end
		return "Custom Mr. Dollys: " .. onOff
	end,
	OnChange = function(currentBool)
		EEVEEMOD.PERSISTENT_DATA.CustomDolly = currentBool
	end,
	Info = { "Gives Eevee a unique Mr. Dolly sprite. Mr. Dolly's sprite will be replaced if on a pedestal and the first player is Eevee." }
})
ModConfigMenu.AddSetting(EEVEEMOD.Name, "Settings",
	{
	Type = ModConfigMenu.OptionType.BOOLEAN,
	CurrentSetting = function()
		return EEVEEMOD.PERSISTENT_DATA.UniqueBirthright
	end,
	Display = function()
		local onOff = "False"
		if EEVEEMOD.PERSISTENT_DATA.UniqueBirthright then
			onOff = "True"
		end
		return 'Unique Birthright: ' .. onOff
	end,
	OnChange = function(currentBool)
		EEVEEMOD.PERSISTENT_DATA.UniqueBirthright = currentBool
	end,
	Info = { "Gives Birthright a unique item sprite if the first player is Eevee." }
})
ModConfigMenu.AddSetting(EEVEEMOD.Name, "Settings",
	{
	Type = ModConfigMenu.OptionType.BOOLEAN,
	CurrentSetting = function()
		return EEVEEMOD.PERSISTENT_DATA.ClassicVoice
	end,
	Display = function()
		local onOff = "False"
		if EEVEEMOD.PERSISTENT_DATA.ClassicVoice then
			onOff = "True"
		end
		return 'Classic Voice: ' .. onOff
	end,
	OnChange = function(currentBool)
		EEVEEMOD.PERSISTENT_DATA.ClassicVoice = currentBool
	end,
	Info = { "Toggle Eevee's basic Pokemon cry from older generations" }
})
ModConfigMenu.AddSetting(EEVEEMOD.Name, "Settings",
	{
	Type = ModConfigMenu.OptionType.BOOLEAN,
	CurrentSetting = function()
		return EEVEEMOD.PERSISTENT_DATA.PassiveShiny
	end,
	Display = function()
		local onOff = "False"
		if EEVEEMOD.PERSISTENT_DATA.PassiveShiny then
			onOff = "True"
		end
		return 'Passive Shinies: ' .. onOff
	end,
	OnChange = function(currentBool)
		EEVEEMOD.PERSISTENT_DATA.PassiveShiny = currentBool
	end,
	Info = { "An enemy may spawn shiny without a player needing to hold a Shiny Charm, at a low encounter rate." }
})

return modConfigMenu
