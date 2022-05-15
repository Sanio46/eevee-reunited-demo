--Entire lua provided by tem! Please thank them for the suffering they went through.
local lilithbr = {}

local whitelistedFamiliars = {
	[EEVEEMOD.FamiliarVariant.LIL_EEVEE] = true,
}

local function hasLilithBR(player)
	local playerType = player:GetPlayerType()
	local br = false
	if playerType == PlayerType.PLAYER_LILITH
		and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	then
		br = true
	end
	return br
end

function lilithbr:OnPeffectUpdate(player)
	local data = player:GetData()

	if hasLilithBR(player) then
		local familiars = Isaac.FindByType(3)
		local playerfamiliars = {}
		for i = 1, #familiars do
			local familiar = familiars[i]:ToFamiliar()

			if familiar.Player
				and whitelistedFamiliars[familiar.Variant]
				and familiar.Player:GetData().Identifier == data.Identifier
				and familiar.OrbitDistance:Length() == 0 then
				table.insert(playerfamiliars, familiar)
			end
		end
		local aimDir = player:GetAimDirection()
		if aimDir:Length() ~= 0 then
			aimDir = aimDir:Normalized()
			data.LilithBRLastAimDirection = aimDir
		elseif data.LilithBRLastAimDirection then
			local currentangle = data.LilithBRLastAimDirection:GetAngleDegrees()
			local newangle = currentangle
			while math.floor(newangle) % 90 ~= 0 do
				newangle = newangle + 1
			end
			data.LilithBRLastAimDirection = data.LilithBRLastAimDirection:Rotated(newangle - currentangle)
		end
		aimDir = data.LilithBRLastAimDirection or Vector(0, 1)
		local currentiterfamiliar = 0

		for i = 1, #playerfamiliars do
			currentiterfamiliar = currentiterfamiliar + 1
			local familiar = playerfamiliars[i]
			local targetAngle = 180 * currentiterfamiliar / (#playerfamiliars + 1)
			familiar:GetData().LilithBRFollowPos = aimDir:Rotated(targetAngle - 90)
		end
	end
end

function lilithbr:OnFamiliarUpdate(familiar)
	local player = familiar.Player
	local data = familiar:GetData()

	if player and hasLilithBR(player) and data.LilithBRFollowPos then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_KING_BABY) and familiar.Variant ~= FamiliarVariant.KING_BABY then --Your player a owns King Baby
			local kingBabies = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.KING_BABY) --Searching for all King Babies
			local kingiestOfKingBabies = nil --The most recent King Baby
			for i = 1, #kingBabies do
				local kingBaby = kingBabies[i]:ToFamiliar()
				if kingBaby.Player
					and kingBaby.Player:GetData().Identifier == player:GetData().Identifier
				then
					if not kingiestOfKingBabies then
						kingiestOfKingBabies = kingBaby --The first King Baby is set
					elseif kingiestOfKingBabies.FrameCount > kingBaby.FrameCount then --The most recent King Baby gets priority
						kingiestOfKingBabies = kingBaby
					end
				end
			end
			if kingiestOfKingBabies and player:GetFireDirection() ~= Direction.NO_DIRECTION then --Only attach when firing
				familiar.Velocity = ((kingiestOfKingBabies.Position + data.LilithBRFollowPos * 50) - familiar.Position) * 0.5
			end
		else
			familiar.Velocity = ((player.Position + data.LilithBRFollowPos * 50) - familiar.Position) * 0.5
		end
	end
end

return lilithbr
