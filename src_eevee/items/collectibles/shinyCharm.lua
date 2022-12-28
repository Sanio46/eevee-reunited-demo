local shinyCharm = {}

local BASE_SHINY_CHANCE = 4096
local forceSpawn = false

---@param npc EntityNPC
function shinyCharm:MakeNPCShiny(npc)
	local colorRNG = RNG()
	colorRNG:SetSeed(npc.Type + 1000, 35)
	local color = npc.Color
	local sprite = npc:GetSprite()
	if npc.Type == EntityType.ENTITY_HENRY then
		color:SetColorize(4, 2, 0.5, 1)
		sprite.Color = color
	else
		local r, g, b = (colorRNG:RandomInt(50) + 1) * 0.1, (colorRNG:RandomInt(50) + 1) * 0.1,
			(colorRNG:RandomInt(50) + 1) * 0.1
		color:SetColorize(r, g, b, 0.5)
		sprite.Color = color
	end
	local data = npc:GetData()

	npc:AddEntityFlags(EntityFlag.FLAG_FEAR)
	npc.MaxHitPoints = npc.MaxHitPoints * 4
	npc:AddHealth(npc.MaxHitPoints)
	data.ShinyColor = color
	data.IsShinyEnemy = true
	data.ShinyFleeTimer = 300
	EEVEEMOD.sfx:Play(EEVEEMOD.SoundEffect.SHINY_APPEAR)
	local shiny = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.SHINY_APPEAR, 0,
		Vector(npc.Position.X, npc.Position.Y), Vector.Zero, npc):ToEffect()
	shiny.RenderZOffset = 100
	shiny.Parent = npc
	shiny:FollowParent(shiny.Parent)
end

---@param npc EntityNPC
function shinyCharm:TryMakeShinyOnNPCInit(npc)
	if npc.FrameCount <= 2 --If it makes through in its spawn frames
		and npc:IsActiveEnemy()
		and not npc:IsInvincible()
		and npc:IsVulnerableEnemy()
		and not npc:IsBoss()
		and not npc:IsChampion()
		and npc.Type ~= EntityType.ENITY_FIREPLACE
		and npc.Type ~= EntityType.ENTITY_SHOPKEEPER
		and not npc.SpawnerEntity
		and not npc:GetData().ShinyChecked --So it doesn't check multiple times
	then
		local players = VeeHelper.GetAllPlayers()
		local shinyRNG = BASE_SHINY_CHANCE
		for i = 1, #players do
			local player = players[i]
			if player:HasCollectible(EEVEEMOD.CollectibleType.SHINY_CHARM) then
				shinyRNG = shinyRNG / (player:GetCollectibleNum(EEVEEMOD.CollectibleType.SHINY_CHARM) + 1)
			end
		end

		--Go through if shinies are enabled passively, and if not, require Shiny Charm (RNG being below 4096 means it triggered)
		if forceSpawn or ((EEVEEMOD.PERSISTENT_DATA.PassiveShiny == true or shinyRNG < BASE_SHINY_CHANCE)
			and EEVEEMOD.RunSeededRNG:RandomInt(BASE_SHINY_CHANCE) + 1 == shinyRNG) then
			shinyCharm:MakeNPCShiny(npc)
		end
		npc:GetData().ShinyChecked = true
	end
end

local frequency = 5

---@param npc EntityNPC
function shinyCharm:ShinyColoredNPCUpdate(npc)
	local data = npc:GetData()

	if not data.IsShinyEnemy then return end

	if data.ShinyColor then
		npc:GetSprite().Color = data.ShinyColor
	end

	if npc.FrameCount % frequency == 0 then
		local sparkle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.SHINY_SPARKLE, 0,
			Vector(npc.Position.X, npc.Position.Y - 10), Vector.Zero, nil):ToEffect()
		local sprite = sparkle:GetSprite()
		sprite.Offset = Vector(VeeHelper.RandomNum(-20, 20), VeeHelper.RandomNum(10, 20) * -1)
		sprite.PlaybackSpeed = 0.5
		sparkle.FallingSpeed = VeeHelper.RandomNum(7, 13) * 0.1
		sparkle.DepthOffset = 20
		sparkle:SetColor(data.ShinyColor, -1, 1, false, false)
	end

	if data.ShinyFleeTimer then
		if data.ShinyFleeTimer > 0 then
			data.ShinyFleeTimer = data.ShinyFleeTimer - 1
		else
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc):ToEffect()
			poof:GetSprite().PlaybackSpeed = 1.5
			npc:Remove()
		end
	end
end

---@param npc EntityNPC
function shinyCharm:PostShinyKill(npc)
	local data = npc:GetData()
	local pos = EEVEEMOD.game:GetRoom():FindFreePickupSpawnPosition(npc.Position)
	local dropRNG = RNG()
	dropRNG:SetSeed(npc.DropSeed, 35)
	local subType = EEVEEMOD.game:GetItemPool():GetTrinket(false) + TrinketType.TRINKET_GOLDEN_FLAG

	if data.IsShinyEnemy then
		EEVEEMOD.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, pos, Vector.Zero, nil, subType,
			npc.DropSeed)

		-- There's certain instances where the game will fire the kill callback twice
		-- To account for this, we remove the shiny flag upon kill so the same
		-- logic will not trigger again for eg. Uranus
		data.IsShinyEnemy = false
	end
end

---@param player EntityPlayer
---@param itemStats ItemStats
function shinyCharm:Stats(player, itemStats)
	if player:HasCollectible(EEVEEMOD.CollectibleType.SHINY_CHARM) then
		itemStats.LUCK = itemStats.LUCK + (2 * player:GetCollectibleNum(EEVEEMOD.CollectibleType.SHINY_CHARM))
	end
end

---@param effect EntityEffect
function shinyCharm:ShinyParticleEffectUpdate(effect)
	local sprite = effect:GetSprite()
	if sprite.Offset.Y < 0 then
		sprite.Offset = sprite.Offset + Vector(0, effect.FallingSpeed)
	end
	if sprite:IsFinished("Idle") then
		effect:Remove()
	end
end

return shinyCharm
