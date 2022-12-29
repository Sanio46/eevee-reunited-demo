local rgbCycle = {}

--Credit to patczuch for the color changing code, creator of the RGB Tainted Apollyon mod!
--Adjustments to the system to apply global RGB or per entity custom colors

local rGlobal = 255
local gGlobal = 0
local bGlobal = 0

local colorsToCycle = {
	[EEVEEMOD.ColorCycle.RGB] = { { 0, 0, 0 }, { 255, 255, 255 } },
	[EEVEEMOD.ColorCycle.CONTINUUM] = { { 170, 0, 255 }, { 255, 255, 255 }, { 0, 0, 0 } }
}
local colorSpeed = {
	[EEVEEMOD.ColorCycle.RGB] = 10,
	[EEVEEMOD.ColorCycle.CONTINUUM] = 23
}

---@type table<Entity, ColorCycle>[]
local entsToColorCycle = {}

---@param player EntityPlayer
function rgbCycle:shouldApplyColorCycle(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_CONTINUUM)
	then
		return true
	end
	return false
end

---@param ent Entity
---@param colorCycle ColorCycle
function rgbCycle:applyColorCycle(ent, colorCycle)
	local data = ent:GetData()
	data.EeveeEntHasColorCycle = true
	table.insert(entsToColorCycle, { ent, colorCycle })
end

local function ConvertToFloat(num)
	return math.floor(num) / 255
end

function rgbCycle:cycleRGB()
	for _ = 1, colorSpeed[EEVEEMOD.ColorCycle.RGB] do
		if rGlobal > 0 and bGlobal == 0 then
			rGlobal = rGlobal - 1
			gGlobal = gGlobal + 1
		end
		if gGlobal > 0 and rGlobal == 0 then
			gGlobal = gGlobal - 1
			bGlobal = bGlobal + 1
		end
		if bGlobal > 0 and gGlobal == 0 then
			rGlobal = rGlobal + 1
			bGlobal = bGlobal - 1
		end
	end
	for i, ents in ipairs(entsToColorCycle) do
		---@type Entity
		local ent = ents[1]
		---@type ColorCycle
		local colorCycle = ents[2]

		if not ent:Exists() then
			table.remove(entsToColorCycle, i)
		elseif colorCycle == EEVEEMOD.ColorCycle.RGB then
			ent:SetColor(Color(ConvertToFloat(rGlobal), ConvertToFloat(gGlobal), ConvertToFloat(bGlobal), ent.Color.A, 0, 0, 0),
				-1, 15, false, false)
		end
	end
end

function rgbCycle:cycleCustomColor()
	for i, ents in ipairs(entsToColorCycle) do
		---@type Entity
		local ent = ents[1]
		---@type ColorCycle
		local colorCycle = ents[2]

		if not ent:Exists() then
			table.remove(entsToColorCycle, i)
		elseif colorCycle ~= EEVEEMOD.ColorCycle.RGB then
			local data = ent:GetData()
			local curColorCycle = colorsToCycle[colorCycle]
			if not data.EeveeCCC then
				data.EeveeCCC = { --CustomColorCycle
					r = curColorCycle[colorCycle][1] - 10,
					g = curColorCycle[colorCycle][2] - 10,
					b = curColorCycle[colorCycle][3] - 10,
					rChangeNum = 1,
					gChangeNum = 1,
					bChangeNum = 1,
					curColor = 1
				}
			end
			for _ = 1, colorSpeed[colorCycle] do
				if data.EeveeCCC.r > curColorCycle[data.EeveeCCC.curColor][1] then
					data.EeveeCCC.r = data.EeveeCCC.r - data.EeveeCCC.rChangeNum
				end
				if data.EeveeCCC.r < curColorCycle[data.EeveeCCC.curColor][1] then
					data.EeveeCCC.r = data.EeveeCCC.r + data.EeveeCCC.rChangeNum
				end
				if data.EeveeCCC.g > curColorCycle[data.EeveeCCC.curColor][2] then
					data.EeveeCCC.g = data.EeveeCCC.g - data.EeveeCCC.gChangeNum
				end
				if data.EeveeCCC.g < curColorCycle[data.EeveeCCC.curColor][2] then
					data.EeveeCCC.g = data.EeveeCCC.g + data.EeveeCCC.gChangeNum
				end
				if data.EeveeCCC.b > curColorCycle[data.EeveeCCC.curColor][3] then
					data.EeveeCCC.b = data.EeveeCCC.b - data.EeveeCCC.bChangeNum
				end
				if data.EeveeCCC.b < curColorCycle[data.EeveeCCC.curColor][3] then
					data.EeveeCCC.b = data.EeveeCCC.b + data.EeveeCCC.bChangeNum
				end

				if (
					math.floor(data.EeveeCCC.r) == curColorCycle[data.EeveeCCC.curColor][1]
						and math.floor(data.EeveeCCC.g) == curColorCycle[data.EeveeCCC.curColor][2]
						and math.floor(data.EeveeCCC.b) == curColorCycle[data.EeveeCCC.curColor][3]
					) then
					local prevColor = data.EeveeCCC.curColor
					data.EeveeCCC.curColor = data.EeveeCCC.curColor + 1
					if #curColorCycle < data.EeveeCCC.curColor then
						data.EeveeCCC.curColor = 1
					end
					data.EeveeCCC.rChangeNum = math.abs(curColorCycle[data.EeveeCCC.curColor][1] - curColorCycle[prevColor][1]) / 255
					data.EeveeCCC.gChangeNum = math.abs(curColorCycle[data.EeveeCCC.curColor][2] - curColorCycle[prevColor][2]) / 255
					data.EeveeCCC.bChangeNum = math.abs(curColorCycle[data.EeveeCCC.curColor][3] - curColorCycle[prevColor][3]) / 255
				end
			end
			--[[ if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == EffectVariant.SPRITE_TRAIL then
				ent.Color:SetColorize(data.EeveeCCC.r / 255, data.EeveeCCC.g / 255, data.EeveeCCC.b / 255, 1)
			else ]]
			ent:SetColor(Color(ConvertToFloat(data.EeveeCCC.r), ConvertToFloat(data.EeveeCCC.g), ConvertToFloat(data.EeveeCCC.b),
				ent.Color.A, 0, 0, 0), -1, 15, false, false)
			--end
		end
	end
end

function rgbCycle:onRender()
	if EEVEEMOD.game:IsPaused() then return end
	--[[ if rgbSpeed < 0 and EEVEEMOD.game:GetFrameCount() % -(rgbSpeed - 1) == 0 then
		rgbCycle:cycleRGB()
	elseif rgbSpeed > 0 then ]]
	rgbCycle:cycleRGB()
	--end
	rgbCycle:cycleCustomColor()
end

return rgbCycle
