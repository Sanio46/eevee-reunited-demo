local alertSpecs = {}

local greedEnemies = {
	EntityType.ENTITY_GREED,
	EntityType.ENTITY_ULTRA_GREED,
	EntityType.ENTITY_KEEPER,
	EntityType.ENTITY_ULTRA_COIN
}

local function HitByGreedEnemy(npc)
	local wasHitbyGreed = false

	for _, greeds in pairs(greedEnemies) do
		if npc.Type == greeds and npc.Type == EntityType.ENTITY_ULTRA_COIN and greeds.Variant == 0 then
			wasHitbyGreed = true
		elseif npc.Type == greeds then
			wasHitbyGreed = true
		end
	end
	return wasHitbyGreed
end

local function HitByGreedProjectile(proj)
	if proj:HasProjectileFlags(ProjectileFlags.GREED) then
		proj:AddProjectileFlags(ProjectileFlags.GREED * -1)
	else
		for _, greeds in pairs(greedEnemies) do
			if (proj.SpawnerType and proj.SpawnerType == greeds) or (proj.Parent and proj.Parent.Type == greeds) then
				return true
			end
		end
	end
end

local function PlayerDamageToTake(player, ent)
	local stage = EEVEEMOD.game:GetLevel():GetStage()
	local dmgAmount = 1
	if stage >= LevelStage.STAGE4_1 then --Should account for Greed as well
		dmgAmount = 2
	elseif ent.Type == EntityType.ENTITY_NPC and ent:IsChampion() then
		dmgAmount = 2
	elseif ent.Type == EntityType.ENTITY_PROJECTILE then
		dmgAmount = 2
	end
	return dmgAmount
end

function alertSpecs:OnCollisionGreedEnemy(npc, collider)
	local player = collider:ToPlayer()

	if player:HasTrinket(EEVEEMOD.TrinketType.ALERT_SPECS) then

		if HitByGreedEnemy(npc) then
			if not player:HasInvincibility() then
				player:TakeDamage(PlayerDamageToTake(player, npc), 0, EntityRef(player), 0)
				return false
			end
		end
	end
end

function alertSpecs:OnCollisionGreedProjectile(proj, collider)
	local player = collider:ToPlayer()

	if player:HasTrinket(EEVEEMOD.TrinketType.ALERT_SPECS) then

		if HitByGreedProjectile(proj) then
			if not player:HasInvincibility() then
				player:TakeDamage(PlayerDamageToTake(player, proj), 0, EntityRef(player), 0)
				return false
			end
		end
	end
end

return alertSpecs
