local postTearInit = {}

local swiftTear = EEVEEMOD.Src["attacks"]["swift.swiftTear"]

function postTearInit:main(tear)
	swiftTear:OnTearInit(tear)
end

return postTearInit