local ember = {}

function ember:EmberTearInit(tear)
	--[[ if VeeHelper.TearVariantBlacklist[tear.Variant] then return end

	if VeeHelper.EntitySpawnedByPlayer(tear) then
		local player = tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar().Player
		local playerType = player:GetPlayerType()
		local data = tear:GetData()

		if playerType == EEVEEMOD.PlayerType.FLAREON and not data.EmberShot then
			tear:ChangeVariant(TearVariant.FIRE_MIND)
			data.EmberShot = true
		end
	end ]]
end

function ember:CreateEmberTrail(tear)
	local data = tear:GetData()

	if not data.EmberShot then return end

	--[[  local frequency = 2
	local tearHeightToFollow = (tear.Height * 0.4) - 15
	local sizeToFollow = tear.Size * 0.5
	local spawnPos = Vector(tear.Position.X, (tear.Position.Y + tearHeightToFollow) - sizeToFollow) + tear.PosDisplacement
	if tear.FrameCount % frequency == 0 then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, spawnPos, tear.Velocity:Resized(-0.5), tear)
	end ]]
end

return ember
