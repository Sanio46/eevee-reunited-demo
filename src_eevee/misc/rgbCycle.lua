local rgbCycle = {}

--Total credit to patczuch, creator of the RGB Tainted Apollyon mod!

local redChangeAmount = 1
local greenChangeAmount = 1
local blueChangeAmount = 1
local colorsToCycle = { { 0, 0, 0 }, { 255, 255, 255 } }
local currentColor = 1
local rgb = true
local rgbSpeed = 10
local setR = 0
local setG = 0
local setB = 0
local defaultCycle = true
local lastDefaultCycle = false
local refresh = false

function rgbCycle:cycleRGB()
	if defaultCycle then
		if EEVEEMOD.RGB.R > 0 and EEVEEMOD.RGB.B == 0 then
			EEVEEMOD.RGB.R = EEVEEMOD.RGB.R - 1
			EEVEEMOD.RGB.G = EEVEEMOD.RGB.G + 1
		end
		if EEVEEMOD.RGB.G > 0 and EEVEEMOD.RGB.R == 0 then
			EEVEEMOD.RGB.G = EEVEEMOD.RGB.G - 1
			EEVEEMOD.RGB.B = EEVEEMOD.RGB.B + 1
		end
		if EEVEEMOD.RGB.B > 0 and EEVEEMOD.RGB.G == 0 then
			EEVEEMOD.RGB.R = EEVEEMOD.RGB.R + 1
			EEVEEMOD.RGB.B = EEVEEMOD.RGB.B - 1
		end
		currentColor = 1
	else
		if EEVEEMOD.RGB.R > colorsToCycle[currentColor][1] then
			EEVEEMOD.RGB.R = EEVEEMOD.RGB.R - redChangeAmount
		end
		if EEVEEMOD.RGB.R < colorsToCycle[currentColor][1] then
			EEVEEMOD.RGB.R = EEVEEMOD.RGB.R + redChangeAmount
		end
		if EEVEEMOD.RGB.G > colorsToCycle[currentColor][2] then
			EEVEEMOD.RGB.G = EEVEEMOD.RGB.G - greenChangeAmount
		end
		if EEVEEMOD.RGB.G < colorsToCycle[currentColor][2] then
			EEVEEMOD.RGB.G = EEVEEMOD.RGB.G + greenChangeAmount
		end
		if EEVEEMOD.RGB.B > colorsToCycle[currentColor][3] then
			EEVEEMOD.RGB.B = EEVEEMOD.RGB.B - blueChangeAmount
		end
		if EEVEEMOD.RGB.B < colorsToCycle[currentColor][3] then
			EEVEEMOD.RGB.B = EEVEEMOD.RGB.B + blueChangeAmount
		end

		if (math.floor(EEVEEMOD.RGB.R) == colorsToCycle[currentColor][1] and math.floor(EEVEEMOD.RGB.G) == colorsToCycle[currentColor][2] and math.floor(EEVEEMOD.RGB.B) == colorsToCycle[currentColor][3]) or refresh then
			local prevColor = currentColor
			currentColor = currentColor + 1
			if #colorsToCycle < currentColor then
				currentColor = 1
			end
			redChangeAmount = math.abs(colorsToCycle[currentColor][1] - colorsToCycle[prevColor][1]) / 255
			greenChangeAmount = math.abs(colorsToCycle[currentColor][2] - colorsToCycle[prevColor][2]) / 255
			blueChangeAmount = math.abs(colorsToCycle[currentColor][3] - colorsToCycle[prevColor][3]) / 255
			refresh = false
		end
	end
end

function rgbCycle:onRender()
	if defaultCycle ~= lastDefaultCycle then
		if defaultCycle then
			EEVEEMOD.RGB.R = 255
			EEVEEMOD.RGB.G = 0
			EEVEEMOD.RGB.B = 0
		else
			EEVEEMOD.RGB.R = colorsToCycle[currentColor][1]
			EEVEEMOD.RGB.G = colorsToCycle[currentColor][2]
			EEVEEMOD.RGB.B = colorsToCycle[currentColor][3]
		end
	end
	lastDefaultCycle = defaultCycle
	if rgbSpeed < 0 and EEVEEMOD.game:GetFrameCount() % -(rgbSpeed - 1) == 0 then
		rgbCycle:cycleRGB()
	elseif rgbSpeed > 0 then
		for i = 1, rgbSpeed do
			rgbCycle:cycleRGB()
		end
	end
end

return rgbCycle
