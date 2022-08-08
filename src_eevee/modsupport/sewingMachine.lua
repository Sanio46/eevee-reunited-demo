local sewingMachine = {}

if not Sewn_API then return sewingMachine end

Sewn_API:MakeFamiliarAvailable(EEVEEMOD.FamiliarVariant.LIL_EEVEE, EEVEEMOD.CollectibleType.LIL_EEVEE)

local FamiliarsWiki = {
	LilEevee = {
		Super = "An experience bar will appear above Lil Eevee. Every room clear fills the bar based on the room and floor, and each time the bar is filled, it will increase their level. The higher the level, the higher Lil Eevee's damage and firerate.",
		Ultra = "Levels and experience no longer reset when changing forms.",
		Notes = "Lil Eevee's stats will not reset if the upgrade is lost and then regained, but the Super upgrade's stats will reset when changing forms regardless of upgrades. Stats in the Ultra upgrade will update to the Super upgrade's stats if its higher than Ultra's stats."
	}
}
local EIDDescs = {
	LilEevee = {
		Super = "Lil Eevee can gain experience and levels#Each level increases damage and firerate#Level resets when changing forms",
		Ultra = "Level no longer resets when changing forms#10% chance to fire a random form's tear"
	}
}

local function resetStats(familiar)
	local initSeed = tostring(familiar.InitSeed)

	if not EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] then return end
	local lilEeveeData = EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Super

	lilEeveeData.Level = 1
	lilEeveeData.Exp.CurAmount = 0
	lilEeveeData.Exp.Stored = 0

end

function sewingMachine:OnStateChange(familiar)
	local initSeed = tostring(familiar.InitSeed)

	if not EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] then return end

	if EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Super.CurState ~= familiar.State
		or EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Ultra.CurState ~= familiar.State then
		EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Super.CurState = familiar.State
		EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed].Ultra.CurState = familiar.State
		resetStats(familiar)
	end
end

function sewingMachine:OnUltraGain(familiar, _)
	local initSeed = tostring(familiar.InitSeed)

	if not EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] then return end

	local lilEeveeData = EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed]

	if lilEeveeData.Ultra.Exp.CurAmount < lilEeveeData.Super.Exp.CurAmount then
		for variable, value in pairs(lilEeveeData.Super) do
			lilEeveeData.Ultra[tostring(variable)] = value
		end
	end
end

Sewn_API:AddCallback(Sewn_API.Enums.ModCallbacks.ON_FAMILIAR_UPGRADED, sewingMachine.OnUltraGain, EEVEEMOD.FamiliarVariant.LIL_EEVEE, Sewn_API.Enums.FamiliarLevelFlag.FLAG_SUPER)

local roomCleared = 0
local gainRate = 0
local previousRequirement = 0
local levelCap = 100
local tempest = Font()
local shouldDisplayLevelUp = false
local levelUpPos = 0
local levelUpDur = 7

function sewingMachine:UpdateGainRate(lilEeveeData)
	gainRate = lilEeveeData.Exp.Stored / 30
end

function sewingMachine:UpdateXPRequirement(lilEeveeData)
	lilEeveeData.Exp.ForNextLevel = lilEeveeData.Level + (lilEeveeData.Level ^ 2) * 0.2
	local previousLevel = lilEeveeData.Level - 1
	previousRequirement = previousLevel + previousLevel ^ 2
end

function sewingMachine:GainXP(familiar, lilEeveeData)
	if roomCleared == familiar.RoomClearCount or lilEeveeData.Level >= levelCap then return end
	roomCleared = familiar.RoomClearCount
	if EEVEEMOD.game:GetRoom():GetFrameCount() == 0 then return end

	local room = EEVEEMOD.game:GetRoom()
	local level = EEVEEMOD.game:GetLevel()
	local roomShape = room:GetRoomShape()
	local roomDesc = level:GetCurrentRoomDesc()
	local stageType = level:GetStage() > 0 and level:GetStage() or LevelStage.STAGE8 --If for some reason you reach a modding-shenanigans negative floor, level gain is that of
	local isMinibossRoom = roomDesc.SurpriseMiniboss
	local isBossRoom = roomDesc.Data.RoomType == RoomType.ROOM_BOSS
	local xpToGain = 1
	local xpMultiplier = 1 + (stageType * 0.3)

	if roomShape >= RoomShape.ROOMSHAPE_2x2 and roomShape < RoomShape.NUM_ROOMSHAPES then
		xpToGain = xpToGain + 1
	end
	if isBossRoom then
		xpToGain = xpToGain + 9
	elseif isMinibossRoom then
		xpToGain = xpToGain + 4
	end

	xpToGain = xpToGain * xpMultiplier
	lilEeveeData.Exp.Stored = lilEeveeData.Exp.Stored + xpToGain
	sewingMachine:UpdateGainRate(lilEeveeData)
	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.EXP_GAIN)
end

function sewingMachine:AddXP(lilEeveeData)
	if lilEeveeData.Exp.Stored <= 0 then return end

	lilEeveeData.Exp.CurAmount = lilEeveeData.Exp.CurAmount + gainRate
	lilEeveeData.Exp.Stored = lilEeveeData.Exp.Stored - gainRate
	if lilEeveeData.Exp.Stored < 0 then lilEeveeData.Exp.Stored = 0 end

	if lilEeveeData.Exp.CurAmount >= lilEeveeData.Exp.ForNextLevel then
		lilEeveeData.Level = lilEeveeData.Level + 1
		sewingMachine:UpdateXPRequirement(lilEeveeData)
		sewingMachine:UpdateGainRate(lilEeveeData)
		shouldDisplayLevelUp = true
		levelUpPos = 0
		EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.EXP_LEVELUP)
		if lilEeveeData.Level >= levelCap then
			lilEeveeData.Exp.CurAmount = 0
			lilEeveeData.Exp.Stored = 0
		end
	end
end

function sewingMachine:LevelBarOnRender()
	for _, f in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, EEVEEMOD.FamiliarVariant.LIL_EEVEE)) do
		local familiar = f:ToFamiliar()
		local initSeed = tostring(familiar.InitSeed)

		if EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] and Sewn_API:IsSuper(familiar:GetData(), true) and not EEVEEMOD.game:IsPaused() then
			local screenpos = EEVEEMOD.game:GetRoom():WorldToScreenPosition(familiar.Position)
			local lilEeveeData = EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed]
			lilEeveeData = Sewn_API:IsUltra(familiar:GetData()) and lilEeveeData.Ultra or lilEeveeData.Super
			local percentage = (lilEeveeData.Exp.CurAmount - previousRequirement) / (lilEeveeData.Exp.ForNextLevel - previousRequirement)
			local frameSet = math.ceil(percentage * 100)
			frameSet = frameSet > 0 and frameSet < 101 and frameSet or 1
			if not EEVEEMOD.Sprite.LevelBar:IsLoaded() then
				EEVEEMOD.Sprite.LevelBar:Load("gfx/render_lileevee_xpbar.anm2")
				EEVEEMOD.Sprite.LevelBar:Play("Main", true)
				EEVEEMOD.Sprite.LevelBar:SetFrame(frameSet)
				tempest:Load("font/terminus.fnt")
			end
			tempest:DrawStringScaled("Lv." .. tostring(lilEeveeData.Level), screenpos.X - 25, screenpos.Y - 55, 0.8, 0.8, KColor(0, 0.5, 1, 1), 50, true)

			if shouldDisplayLevelUp == true then
				local a = levelUpPos <= levelUpDur and 1 or 2 - (levelUpPos / levelUpDur) --1 second of visibility, 1 second of fading away.
				if a > 1 then a = 1 end
				tempest:DrawStringScaled("Lv. Up!", screenpos.X - 25, screenpos.Y - (65 + levelUpPos), 0.8, 0.8, KColor(0, 0.5, 1, a), 50, true)
				levelUpPos = levelUpPos + 0.25
				if a <= 0 then
					shouldDisplayLevelUp = false
				end
			end
			EEVEEMOD.Sprite.LevelBar:SetFrame(frameSet)
			EEVEEMOD.Sprite.LevelBar:Render(Vector(screenpos.X, screenpos.Y - 40), Vector.Zero, Vector.Zero)
		end
	end
end

function sewingMachine:OnUpgradedFamiliarUpdate(familiar)
	local initSeed = tostring(familiar.InitSeed)

	if not EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed] or not Sewn_API:IsSuper(familiar:GetData(), true) then return end
	local lilEeveeData = EEVEEMOD.PERSISTENT_DATA.LilEeveeData[initSeed]
	lilEeveeData = Sewn_API:IsUltra(familiar:GetData()) and lilEeveeData.Ultra or lilEeveeData.Super
	sewingMachine:GainXP(familiar, lilEeveeData)
	sewingMachine:AddXP(lilEeveeData)
end

if EID then
	Sewn_API:AddFamiliarDescription(
		EEVEEMOD.FamiliarVariant.LIL_EEVEE,
		EIDDescs.LilEevee.Super,
		EIDDescs.LilEevee.Ultra
	)
end

if Encyclopedia then
	Sewn_API:AddEncyclopediaUpgrade(
		EEVEEMOD.FamiliarVariant.LIL_EEVEE,
		FamiliarsWiki.LilEevee.Super,
		FamiliarsWiki.LilEevee.Ultra,
		FamiliarsWiki.LilEevee.Notes
	)
end

return sewingMachine
