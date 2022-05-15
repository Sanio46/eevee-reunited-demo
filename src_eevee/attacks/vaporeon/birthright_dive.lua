local dive = {}

--Change creep things based on level. Maybe steam emits from creep in Mines/Ashpit and is lighter, blood in Womb,

function dive:OnUse(itemID, itemRNG, player, flags, slot, varData)
	--[[ if itemID == EEVEEMOD.Birthright.DIVE then
	   local data = player:GetData()
	   data.DiveDuration = 60
	   data.PreDiveEntColl = player.EntityCollisionClass
	   player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	   Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, player.Position, Vector.Zero, player)
	   EEVEEMOD.sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.5, 2, false, 1.6)
	   VeeHelper.SetCanShoot(player, false)
	end ]]
end

function dive:WhileDiveActive(player)
	local data = player:GetData()

	--[[ if data.DiveDuration then
		if data.DiveDuration > 0 then
			data.DiveDuration = data.DiveDuration - 1
			if data.DiveDuration % 3 == 0 then
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, player.Position, Vector.Zero, player)
				creep.CollisionDamage = 1
				if player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) then
					creep.Size = 2
					creep.CollisionDamage = 2
				end
				creep:Update()
			end
			player:SetColor(Color(1,1,1,0,0,0,0), 1, 5, false, false)
		else
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, player.Position, Vector.Zero, player)
			EEVEEMOD.sfx:Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.5, 2, false, 1.6)
			local c = player:GetSprite().Color
			player:SetColor(Color(0.5, 0.7, 1, c.A, 0, 0, 0), 15, 1, true, false)
			player.EntityCollisionClass = data.PreDiveEntColl or EntityCollisionClass.ENTCOLL_ENEMIES
			VeeHelper.SetCanShoot(player, true)
			data.DiveDuration = nil
			data.PreDiveEntColl = nil
		end
	end ]]
end

return dive
