local vee = require("src_eevee.VeeHelper")
local lilEevee = {}

local swiftTear = require("src_eevee.attacks.eevee.swiftTear")
local attackHelper = require("src_eevee.attacks.attackHelper")

local VINE_DURATION = 45

local eeveeDirState = {
	"Side2",
	"Up",
	"Side",
	"Down"
}

---@class EvolutionStates
local EvolutionStates = {
	EEVEE = 0,
	FLAREON = 1,
	JOLTEON = 2,
	VAPOREON = 3,
	ESPEON = 4,
	UMBREON = 5,
	GLACEON = 6,
	LEAFEON = 7,
	SYLVEON = 8
}

---@class LilEeveeStats
---@field Damage number
---@field FireCooldown number
---@field Flags TearFlags
---@field TearVariant TearVariant
---@field Color Color

---@type table<EvolutionStates, LilEeveeStats>
local EvolutionStats = {
	[EvolutionStates.EEVEE] = {
		Damage = 2.5,
		FireCooldown = 22,
		Flags = TearFlags.TEAR_HOMING,
		TearVariant = TearVariant.BLUE,
		Color = Color.Default
	},
	[EvolutionStates.FLAREON] = {
		Damage = 4.0,
		FireCooldown = 26,
		Flags = TearFlags.TEAR_BURN,
		TearVariant = TearVariant.FIRE_MIND,
		Color = Color.Default
	},
	[EvolutionStates.JOLTEON] = {
		Damage = 2,
		FireCooldown = 14,
		Flags = TearFlags.TEAR_JACOBS,
		TearVariant = TearVariant.BLUE,
		Color = Color(1, 0.8, 0)
	},
	[EvolutionStates.VAPOREON] = {
		Damage = 3.5,
		FireCooldown = 22,
		Flags = TearFlags.TEAR_NORMAL,
		TearVariant = TearVariant.BLUE,
		Color = Color(0, 0.2, 0.7, 0.5)
	},
	[EvolutionStates.ESPEON] = {
		Damage = 5.0,
		FireCooldown = 30,
		Flags = TearFlags.TEAR_HOMING,
		TearVariant = TearVariant.BLUE,
		Color = Color(0.4, 0.15, 0.4, 1, 0.3, 0, 0.56)
	},
	[EvolutionStates.UMBREON] = {
		Damage = 5.0,
		FireCooldown = 30,
		Flags = TearFlags.TEAR_NORMAL,
		TearVariant = TearVariant.DARK_MATTER,
		Color = Color.Default
	},
	[EvolutionStates.GLACEON] = {
		Damage = 3.5,
		FireCooldown = 22,
		Flags = TearFlags.TEAR_ICE,
		TearVariant = TearVariant.ICE,
		Color = Color.Default
	},
	[EvolutionStates.LEAFEON] = {
		Damage = 3.5,
		FireCooldown = 22,
		Flags = TearFlags.TEAR_NORMAL,
		TearVariant = TearVariant.BLUE,
		Color = Color.Default
	},
	[EvolutionStates.SYLVEON] = {
		Damage = 3.5,
		FireCooldown = 22,
		Flags = TearFlags.TEAR_CHARM,
		TearVariant = TearVariant.BLUE,
		Color = Color(2.75, 1, 0.75, 1, 0, 0, 0)
	}
}

---@type table<EvolutionStates, string>
local EvoltuionSprites = {
	[EvolutionStates.EEVEE] = "gfx/familiar/lil_eevee.png",
	[EvolutionStates.FLAREON] = "gfx/familiar/lil_flareon.png",
	[EvolutionStates.JOLTEON] = "gfx/familiar/lil_jolteon.png",
	[EvolutionStates.VAPOREON] = "gfx/familiar/lil_vaporeon.png",
	[EvolutionStates.ESPEON] = "gfx/familiar/lil_espeon.png",
	[EvolutionStates.UMBREON] = "gfx/familiar/lil_umbreon.png",
	[EvolutionStates.GLACEON] = "gfx/familiar/lil_glaceon.png",
	[EvolutionStates.LEAFEON] = "gfx/familiar/lil_leafeon.png",
	[EvolutionStates.SYLVEON] = "gfx/familiar/lil_sylveon.png"
}

---@param player EntityPlayer
local function ShouldAutoAim(player)
	local shouldAuto = false
	local playerType = player:GetPlayerType()
	if player:HasCollectible(CollectibleType.COLLECTIBLE_KING_BABY)
		or (playerType == PlayerType.PLAYER_LILITH_B and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT))
	then
		shouldAuto = true
	end
	return shouldAuto
end

---@param familiar EntityFamiliar
---@param player EntityPlayer
local function CalculateFamiliarShootDirection(familiar, player)
	local shootDir = vee.AddTearVelocity(attackHelper:FireDirectionToVector(player), 10, player)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT)
	then
		local targetPos = vee.FindMarkedTarget(player)

		if targetPos ~= nil then
			shootDir = (targetPos - familiar.Position):Normalized():Resized(10)
		end
	elseif ShouldAutoAim(player) then
		shootDir = attackHelper:TryFireToNearestEnemy(familiar, 500, shootDir):Resized(10)
	end
	return shootDir
end

---@param familiar EntityFamiliar
---@param player EntityPlayer
local function LilEeveeFireTear(familiar, player)
	local fData = familiar:GetData()
	local stats = EvolutionStats[familiar.State]
	if Sewn_API ~= nil and Sewn_API:IsUltra(fData) then
		local veeRNG = player:GetCollectibleRNG(EEVEEMOD.CollectibleType.LIL_EEVEE)
		if veeRNG:RandomInt(10) + 1 == 10 then
			local newState = vee.DifferentRandomNum({ familiar.State }, 9, veeRNG)
			stats = EvolutionStats[newState]
		end
	end
	fData.AnimState = "FloatShoot"

	--Base tear stats
	local shootDir = CalculateFamiliarShootDirection(familiar, player)
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, stats.TearVariant, 0, familiar.Position, shootDir, familiar):ToTear()
	local lilEeveeData = EEVEEMOD.PERSISTENT_DATA.LilEeveeData[tostring(familiar.InitSeed)]
	local damage = stats.Damage
	local fireDelay = stats.FireCooldown
	if Sewn_API ~= nil and Sewn_API:IsSuper(fData, true) then
		local level = Sewn_API:IsUltra(fData) and lilEeveeData.Ultra.Level or
			Sewn_API:IsSuper(fData, false) and lilEeveeData.Super.Level
		damage = damage + (level * 0.2)
		fireDelay = fireDelay - math.ceil(level * 0.2)
		fireDelay = fireDelay > 2 and fireDelay or 2
	end
	tear:GetData().LilEeveeTear = familiar.State
	tear:AddTearFlags(stats.Flags)
	tear:SetColor(stats.Color, -1, 1, false, false)
	tear:Update()

	if familiar.State == EvolutionStates.EEVEE then
		swiftTear:AssignSwiftSprite(tear)
	end

	--Modifiers
	if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		tear:AddTearFlags(TearFlags.TEAR_HOMING)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		damage = damage * 2
	end
	if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
		fireDelay = fireDelay / 2
	end

	familiar.FireCooldown = fireDelay
	tear.CollisionDamage = damage
end

---@param familiar EntityFamiliar
local function ChangeLilEeveeState(familiar)
	local sprite = familiar:GetSprite()

	sprite:ReplaceSpritesheet(0, EvoltuionSprites[familiar.State])
	sprite:LoadGraphics()
end

---@param familiar EntityFamiliar
function lilEevee:OnFamiliarInit(familiar)
	local fData = familiar:GetData()

	familiar.HeadFrameDelay = 0
	familiar.FireCooldown = 0
	fData.Damage = EvolutionStats[familiar.State].Damage
	fData.Flags = EvolutionStats[familiar.State].Flags
	fData.TearVariant = EvolutionStats[familiar.State].TearVariant
	familiar.ShootDirection = 3
	fData.DirState = "Down"
	fData.AnimState = "Float"
	familiar:GetSprite():Play(fData.AnimState .. "" .. fData.DirState, true)
end

---@param familiar EntityFamiliar
function lilEevee:OnFamiliarUpdate(familiar)
	local player = familiar.Player
	local fData = familiar:GetData()
	local fireDir = player:GetFireDirection()

	--Changing sprite apparently doesn't work on init
	if familiar.FrameCount == 1 then
		ChangeLilEeveeState(familiar)
	end

	familiar:GetSprite():SetAnimation(fData.AnimState .. "" .. fData.DirState, false)

	if fireDir ~= Direction.NO_DIRECTION then
		if familiar.FireCooldown == 0 then
			LilEeveeFireTear(familiar, player)
			familiar.HeadFrameDelay = 17
			fData.WaitToAttack = true
		end

		local fireDir = CalculateFamiliarShootDirection(familiar, player)
		local dirToFace = vee.RoundHighestVectorPoint(fireDir):GetAngleDegrees()
		local angleToDir = vee.AngleToFireDirection(dirToFace)
		if angleToDir then
			familiar.ShootDirection = angleToDir
		else
			familiar.ShootDirection = player:GetHeadDirection()
		end
		fData.DirState = eeveeDirState[familiar.ShootDirection + 1]
	end

	if familiar.HeadFrameDelay and familiar.FireCooldown then
		if fData.WaitToAttack == true then
			if familiar.FireCooldown > 0 then
				familiar.FireCooldown = familiar.FireCooldown - 1
			else
				fData.WaitToAttack = false
			end
		end

		if familiar.HeadFrameDelay > 8 then
			familiar.HeadFrameDelay = familiar.HeadFrameDelay - 1
		elseif familiar.HeadFrameDelay == 8 then
			if fireDir ~= Direction.NO_DIRECTION then
				fData.AnimState = "Float"
			else
				familiar.HeadFrameDelay = familiar.HeadFrameDelay - 1
			end
		elseif familiar.HeadFrameDelay > 0 then
			familiar.HeadFrameDelay = familiar.HeadFrameDelay - 1
		else
			fData.AnimState = "Float"
			fData.DirState = "Down"
		end
	end
end

---@param rune Card
---@param player EntityPlayer
function lilEevee:OnRune(rune, player, _)
	if vee.IsRune(rune) == false then return end

	for _, e in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, EEVEEMOD.FamiliarVariant.LIL_EEVEE, 0)) do
		local familiar = e:ToFamiliar()
		local veeRNG = player:GetCollectibleRNG(EEVEEMOD.CollectibleType.LIL_EEVEE)

		if familiar.Player:GetData().Identifier == player:GetData().Identifier then
			familiar.State = vee.DifferentRandomNum({ familiar.State }, 9, veeRNG)
			ChangeLilEeveeState(familiar)
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, familiar.Position, Vector.Zero,
					familiar)
				:ToEffect()
			poof:GetSprite().PlaybackSpeed = 1.5
			poof:FollowParent(familiar)
			EEVEEMOD.sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
		end
	end
end

---@param tear EntityTear
function lilEevee:OnLilVaporeonTearRemove(tear)
	local data = tear:GetData()
	if not data.LilEeveeTear and data.LilEeveeTear ~= EvolutionStates.VAPOREON then return end

	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, tear.Position, Vector.Zero,
		tear.SpawnerEntity)
end

---@param tear EntityTear
---@param collider Entity
local function SpawnLeafeonVine(tear, collider)
	local vine = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, EEVEEMOD.FamiliarVariant.VINE, 0, collider.Position, Vector
		.Zero,
		tear.SpawnerEntity):ToFamiliar()
	vine:GetData().TrapEnemy = true
	vine.Parent = collider
	vine:GetSprite():Play("Grab", true)
	vine.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	vine.RenderZOffset = 1000
	if tear.SpawnerEntity:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		vine.CollisionDamage = vine.CollisionDamage * 2
	end
end

---@param tear EntityTear
---@param collider Entity
function lilEevee:OnLilLeafeonTearCollision(tear, collider, _)
	local data = tear:GetData()
	if data.LilEeveeTear
		and data.LilEeveeTear == EvolutionStates.LEAFEON
		and collider:ToNPC()
		and collider:ToNPC():IsActiveEnemy()
	then
		if vee.RandomNum(1) == 1 then
			SpawnLeafeonVine(tear, collider)
		end
	end
end

---@param familiar EntityFamiliar
function lilEevee:OnLeafVineUpdate(familiar)
	local data = familiar:GetData()
	local sprite = familiar:GetSprite()

	if sprite:IsFinished("GrabEnd") then
		familiar:Remove()
	end
	if familiar.Parent and familiar.Parent:Exists() then
		if data.TrapEnemy then
			familiar.Parent:AddSlowing(EntityRef(familiar), 1, 0.1, familiar.Parent.Color)
			familiar.Parent.Velocity = familiar.Position - familiar.Parent.Position
		end
		if sprite:IsPlaying("Grab") and sprite:IsEventTriggered("Shoot") then
			data.VineGrabDuration = VINE_DURATION
			familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		end
		if sprite:IsFinished("Grab") then
			sprite:Play("GrabLoop", true)
		end
		if data.VineGrabDuration then
			if data.VineGrabDuration > 0 then
				data.VineGrabDuration = data.VineGrabDuration - 1
			elseif not sprite:IsPlaying("GrabEnd") then
				sprite:Play("GrabEnd", true)
			end
		end
		if sprite:IsPlaying("GrabEnd") and sprite:IsEventTriggered("Shoot") then
			data.TrapEnemy = nil
			familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
	else
		sprite:Play("GrabEnd", false)
	end
end

function lilEevee:RemoveVineOnNewRoom()
	for _, vine in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, EEVEEMOD.FamiliarVariant.VINE)) do
		---@type EntityFamiliar
		local vine = vine:ToFamiliar()
		vine:Remove()
	end
end

return lilEevee
