local itemEffectOnFire = {}

--Manually re-creating effects that are usually blocked by blindfolds.

local tech05Duration = 2

function itemEffectOnFire:Tech05(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5)
	and player:GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
	and not player:CanShoot()
	and player:GetFireDirection() ~= Direction.NO_DIRECTION
	then
	
		if not dataPlayer.EeveeTech05Timer then
			dataPlayer.EeveeTech05Timer = tech05Duration
		elseif dataPlayer.EeveeTech05Timer > 0 then
			dataPlayer.EeveeTech05Timer = dataPlayer.EeveeTech05Timer - 1
		else
			if EEVEEMOD.RandomNum(6) == 6 then
				local laser = player:FireTechLaser(player.Position, LaserOffset.LASER_TECH5_OFFSET, EEVEEMOD.API.GetIsaacShootingDirection(player), false, false, player, 1)
				local dataLaser = laser:GetData()
				dataLaser.EeveeTech05Laser = true
			end
			dataPlayer.EeveeTech05Timer = tech05Duration
		end
	end
end

function itemEffectOnFire:Tech05StayOnPlayer(laser)
	local dataLaser = laser:GetData()
	if dataLaser.EeveeTech05Laser
	and laser.SpawnerEntity then
		local player = laser.SpawnerEntity:ToPlayer()
		laser.Position = (player.Position + EEVEEMOD.API.GetIsaacShootingDirection(player):Resized(20))
	end
end

function itemEffectOnFire:DeadTooth(player)
	local playerType = player:GetPlayerType()
	local dataPlayer = player:GetData()
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DEAD_TOOTH)
	and player:GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
	and not player:CanShoot()
	and player:GetFireDirection() ~= Direction.NO_DIRECTION
	then
		
	end
end


--Disabled currently, as there's no current way to reliably track when the player is considered "firing" for other weapon types.
--Same goes for Mom's Wig, Ghost Pepper, Bird's Eye, and Eye of Greed.
function itemEffectOnFire:ImmaculateHeart(weapon)
	local dataWeapon = weapon:GetData()
	
	if weapon.SpawnerType == EntityType.ENTITY_PLAYER 
	or weapon.SpawnerType == EntityType.ENTITY_FAMILIAR 
	and (weapon.SpawnerVariant == FamiliarVariant.INCUBUS or weapon.SpawnerVariant == FamiliarVariant.TWISTED_BABY)
	then
		local player = weapon.SpawnerEntity:ToPlayer() or weapon.SpawnerEntity:ToFamiliar().Player
		local dataPlayer = player:GetData()

		if player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART)
		and player:GetPlayerType() == EEVEEMOD.PlayerType.EEVEE
		and not player:CanShoot()
		then
			if EEVEEMOD.RandomNum(4) == 4 and not dataWeapon.IsImmaculateTear then
				local tear = player:FireTear(player.Position, EEVEEMOD.API.GetIsaacShootingDirection(player):Resized(10), false, false, false, player, 1):ToTear()
				tear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_ORBIT_ADVANCED)
				tear.Color = Color(1.5, 2.0, 2.0, 1, 0, 0, 0)
				tear.FallingSpeed = -6.5
				tear:GetData().IsImmaculateTear = true
			end
		end
	end
end

return itemEffectOnFire