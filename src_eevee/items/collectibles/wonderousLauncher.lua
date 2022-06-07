local wonderousLauncher = {}

local cooldownDuration = 20
local shootDuration = 15
local dimeDisc = 50
local nickelDisc = 25

local coinVariantToString = {
	"coin",
	"nickel",
	"dime",
}

---@class DiscType
local DiscType = {
	COIN = 1,
	BOMB = 2,
	KEY = 3,
	POOP = 4,
	NUM_DISCS = 5,
}

---@class DiscCoinVariant
local DiscCoinVariant = {
	COIN_PENNY = 1,
	COIN_NICKEL = 2,
	COIN_DIME = 3
}

local throwableSpells = {
	[PoopSpellType.SPELL_POOP] = true,
	[PoopSpellType.SPELL_CORNY] = true,
	[PoopSpellType.SPELL_BURNING] = true,
	[PoopSpellType.SPELL_STONE] = true,
	[PoopSpellType.SPELL_STINKY] = true,
	[PoopSpellType.SPELL_BLACK] = true,
	[PoopSpellType.SPELL_HOLY] = true,
	[PoopSpellType.SPELL_BOMB] = true
}

---@type table<PoopSpellType, PoopVariant>
local spellToPoopVariant = {
	[PoopSpellType.SPELL_POOP] = 10,
	[PoopSpellType.SPELL_STONE] = 11,
	[PoopSpellType.SPELL_CORNY] = 12,
	[PoopSpellType.SPELL_BURNING] = 13,
	[PoopSpellType.SPELL_STINKY] = 14,
	[PoopSpellType.SPELL_BLACK] = 15,
	[PoopSpellType.SPELL_HOLY] = 16,
}

---@param player EntityPlayer
---@param discType DiscType
local function HasAmmoForPickup(player, discType)
	local hasAmmo = false

	if discType then
		if discType == DiscType.COIN then
			local numCoins = player:GetNumCoins()
			if numCoins > 0 then
				hasAmmo = true
			end
		elseif discType == DiscType.BOMB then
			local numBombs = player:GetNumBombs()
			if numBombs > 0 then
				hasAmmo = true
			end
		elseif discType == DiscType.KEY then
			local numKeys = player:GetNumKeys()
			if numKeys > 0 then
				hasAmmo = true
			end
		elseif discType == DiscType.POOP then
			local numPoops = player:GetPoopMana()
			if numPoops > 0 then
				if throwableSpells[player:GetPoopSpell(0)] == true then
					hasAmmo = true
				end
			end
		end
	end
	return hasAmmo
end

---@param player EntityPlayer
---@return DiscCoinVariant
local function GetCoinDiscVariant(player)
	local numCoins = player:GetNumCoins()
	local type = 1
	if numCoins >= dimeDisc then
		type = 3
	elseif numCoins >= nickelDisc then
		type = 2
	end
	return type
end

---@param player EntityPlayer
local function UpdateWonderDiscSprite(player)
	local data = player:GetData()
	local type = "coin"

	if not data.WonderDiscType then
		for i = 1, DiscType.NUM_DISCS - 1 do
			if HasAmmoForPickup(player, i) then
				data.WonderDiscType = i
				break
			end
			if i == DiscType.NUM_DISCS - 1 then
				data.WonderDiscType = 1
			end
		end
	end
	if HasAmmoForPickup(player, data.WonderDiscType) then
		if data.WonderDiscType == DiscType.COIN then
			type = coinVariantToString[GetCoinDiscVariant(player)]
		elseif data.WonderDiscType == DiscType.BOMB then
			type = "bomb"
		elseif data.WonderDiscType == DiscType.KEY then
			type = "key"
		elseif data.WonderDiscType == DiscType.POOP then
			type = "poop_" .. player:GetPoopSpell(0)
		end
	else
		type = "empty"
	end

	data.WonderLauncher:GetSprite():ReplaceSpritesheet(1, "gfx/effects/wonderouslauncher_" .. type .. ".png")
	data.WonderLauncher:GetSprite():LoadGraphics()
end

---@param sprite Sprite
---@return string
local function GetLauncherDirection(sprite)
	local DirAngles = {
		[-90] = "Up",
		[0] = "Right",
		[90] = "Down",
		[180] = "Left",
		[270] = "Up",
	}
	local vecRotation = Vector.FromAngle(sprite.Rotation)
	local spriteDir = VeeHelper.RoundHighestVectorPoint(vecRotation):GetAngleDegrees()
	local dir = "Down"
	if DirAngles[spriteDir] then
		dir = DirAngles[spriteDir]
	end
	return dir
end

---@param launcher EntityEffect
local function SetAnimState(launcher, state)
	local data = launcher:GetData()
	local sprite = launcher:GetSprite()

	data.AnimState = state
	data.AnimDir = GetLauncherDirection(sprite)
	sprite:Play(data.AnimState .. data.AnimDir, true)
	if state == "Reload" and data.ShootCooldown == nil then
		data.ShootCooldown = cooldownDuration
	end
end

---@param player EntityPlayer
local function SpawnWonderLauncher(player)
	local launcher = Isaac.Spawn(EntityType.ENTITY_EFFECT, EEVEEMOD.EffectVariant.WONDEROUS_LAUNCHER, 0, player.Position, Vector.Zero, player):ToEffect()
	launcher.Parent = player
	launcher.RenderZOffset = 101
	launcher:GetData().ShootCooldown = cooldownDuration
	launcher:GetData().CanShoot = true
	SetAnimState(launcher, "Idle")
	player:GetData().WonderLauncher = launcher
	UpdateWonderDiscSprite(player)
end

---@param player EntityPlayer
local function RemoveWonderLauncher(player)
	local data = player:GetData()
	data.WonderLauncher:Remove()
	data.WonderLauncher = nil
	if not player:CanShoot() then
		VeeHelper.SetCanShoot(player, true)
	end
end

---@param itemID CollectibleType
---@param player EntityPlayer
function wonderousLauncher:OnUse(itemID, _, player, _, _, _)
	local data = player:GetData()

	if itemID == EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER then
		if not data.WonderLauncher or not data.WonderLauncher:Exists() then
			SpawnWonderLauncher(player)
			if player:CanShoot() then
				VeeHelper.SetCanShoot(player, false)
			end
		elseif data.WonderLauncher and data.WonderLauncher:Exists() then
			RemoveWonderLauncher(player)
			return true
		end
	end
end

---@param player EntityPlayer
function wonderousLauncher:OrbitPlayer(player)
	local data = player:GetData()

	if not data.WonderLauncher or EEVEEMOD.game:IsPaused() then return end

	local sprite = data.WonderLauncher:GetSprite()
	local fireDir = player:GetFireDirection() ~= Direction.NO_DIRECTION and player:GetShootingInput() or VeeHelper.HeadDirectionToVector(player)
	local vecRotation = Vector.FromAngle(sprite.Rotation)
	sprite.Rotation = VeeHelper.LerpAngleDegrees(sprite.Rotation, fireDir:GetAngleDegrees(), 0.3)
	data.WonderLauncher:FollowParent(player)
	data.WonderLauncher.ParentOffset = vecRotation + Vector(0, -1)
	sprite.Offset = Vector(0, -10)
end

---@param player EntityPlayer
function wonderousLauncher:SwapThroughPickups(player)
	local data = player:GetData()

	if data.CycleCooldown then
		if data.CycleCooldown > 0 then
			data.CycleCooldown = data.CycleCooldown - 1
		else
			data.CycleCooldown = nil
		end
	end

	if not data.WonderLauncher or data.WonderLauncher:GetData().CanShoot == false or EEVEEMOD.game:IsPaused() then return end

	if Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) and not data.CycleCooldown then
		data.CycleCooldown = cooldownDuration
		local curDisc = data.WonderDiscType
		if data.WonderDiscType then
			for i = 1, 3 do
				local nextDisc = data.WonderDiscType + i
				if nextDisc > (DiscType.NUM_DISCS - 1) then nextDisc = nextDisc - (DiscType.NUM_DISCS - 1) end --Loop around
				if HasAmmoForPickup(player, nextDisc) then
					data.WonderDiscType = nextDisc
					break
				end
			end
		end

		if HasAmmoForPickup(player, data.WonderDiscType) and curDisc ~= data.WonderDiscType then
			SetAnimState(data.WonderLauncher, "Reload")
			UpdateWonderDiscSprite(player)
		end
	end
end

---@param player EntityPlayer
---@param buttonAction ButtonAction
function wonderousLauncher:ForcePoop(player, _, buttonAction)
	local data = player:GetData()

	if data.WonderDestroyPoopQueue ~= nil and buttonAction == ButtonAction.ACTION_BOMB then
		data.WonderDestroyPoop = data.WonderDestroyPoopQueue
		data.WonderDestroyPoopQueue = nil
		return true
	end
end

---@param player EntityPlayer
function wonderousLauncher:StopPoopAnimation(player)
	local data = player:GetData()
	if data.WonderDestroyPoopAnimation and VeeHelper.IsSpritePlayingAnims(player:GetSprite(), VeeHelper.PickupAnimations) then
		player:StopExtraAnimation()
		data.WonderDestroyPoopAnimation = nil
	end
end

---@param player EntityPlayer
function wonderousLauncher:RemoveHeldPoopSpell(player)
	local data = player:GetData()
	if data.WonderDestroyPoop == nil then return end
	local poops = Isaac.FindByType(EntityType.ENTITY_POOP)
	local buttBombs = Isaac.FindByType(EntityType.ENTITY_BOMB, BombVariant.BOMB_BUTT)

	if #poops > 0 then
		for i = 1, #poops do
			local poop = poops[i]
			local isValidPoop = poop.Variant == spellToPoopVariant[data.WonderDestroyPoop]

			if isValidPoop
				and player.Position:DistanceSquared(poop.Position) <= 5 ^ 2
				and poop.FrameCount < 1
			then
				EEVEEMOD.sfx:Stop(SoundEffect.SOUND_POOPITEM_HOLD)
				poop:Remove()
				data.WonderDestroyPoop = nil
				data.WonderDestroyPoopAnimation = true
			end
		end
	end
	if #buttBombs > 0 then
		for i = 1, #buttBombs do
			local buttBomb = buttBombs[i]

			if player.Position:DistanceSquared(buttBomb.Position) <= 5 ^ 2 then
				EEVEEMOD.sfx:Stop(SoundEffect.SOUND_POOPITEM_HOLD)
				buttBomb:Remove()
				data.WonderDestroyPoop = nil
			end
		end
	end
	UpdateWonderDiscSprite(player)
end

---@param tear EntityTear
function wonderousLauncher:OnPoopDiscUpdate(tear)
	local data = tear:GetData()
	if not data.PoopSpellDisc then return end
	data.PoopSpellDisc.Position = tear.Position
	tear:GetSprite().Rotation = tear.Velocity:GetAngleDegrees()
end

---@param tear EntityTear
function wonderousLauncher:OnPoopDiscDestroy(tear)
	local data = tear:GetData()
	if not data.PoopSpellDisc then return end
	data.PoopSpellDisc.Visible = true
	data.PoopSpellDisc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	data.PoopSpellDisc:GetSprite():Play("Appear", true)
	EEVEEMOD.sfx:Play(SoundEffect.SOUND_PLOP)
end

---@param tear EntityTear
function wonderousLauncher:OnCoinDiscDestroy(tear)
	if tear.Variant ~= EEVEEMOD.TearVariant.WONDERCOIN then return end

	local data = tear:GetData()
	if not data.WonderCoinVariant then data.WonderCoinVariant = 1 end
	EEVEEMOD.sfx:Play(SoundEffect.SOUND_POT_BREAK)

	for _ = 1, 6 do
		local vel = Vector(3, 0):Rotated(EEVEEMOD.RandomNum(360))
		local gibs = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.COIN_PARTICLE, 0, tear.Position, vel, nil)
		local sprite = gibs:GetSprite()
		sprite:ReplaceSpritesheet(0, "gfx/effects/wondercoin_gibs_" .. data.WonderCoinVariant .. ".png")
		sprite:LoadGraphics()
	end
end

---@type table<DiscType, CollectibleType>
local discTypeToItemID = {
	[DiscType.COIN] = CollectibleType.COLLECTIBLE_WOODEN_NICKEL,
	[DiscType.BOMB] = CollectibleType.COLLECTIBLE_MR_BOOM,
	[DiscType.KEY] = CollectibleType.COLLECTIBLE_SHARP_KEY,
	[DiscType.POOP] = CollectibleType.COLLECTIBLE_POOP
}

---@param player EntityPlayer
local function SpawnItemWisp(player, discType)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		return
	end

	local ID = player:GetData().Identifier
	if EEVEEMOD.PERSISTENT_DATA.PlayerData[ID]
		and EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps
		and #EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps < 6 then
		local wisp = player:AddWisp(discTypeToItemID[discType], player.Position, true)
		table.insert(EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps, tostring(wisp.InitSeed))
	end
end

---@param familiar EntityFamiliar
function wonderousLauncher:RemoveDeadLauncherWisps(familiar)
	local player = familiar.Player

	if not familiar.Player or familiar.Variant ~= FamiliarVariant.WISP or EEVEEMOD.game:GetRoom():GetFrameCount() == 0 then return end
	local data = player:GetData()
	local ID = data.Identifier

	if EEVEEMOD.PERSISTENT_DATA.PlayerData[ID]
		and EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps
	then
		for i, wispInitSeed in ipairs(EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps) do
			if wispInitSeed == tostring(familiar.InitSeed) then
				table.remove(EEVEEMOD.PERSISTENT_DATA.PlayerData[ID].WonderLauncherWisps, i)
			end
		end
	end
end

---@param launcher EntityEffect
---@param player EntityPlayer
function wonderousLauncher:FireDisc(launcher, player)
	local dataPlayer = player:GetData()
	local dir = Vector.FromAngle(launcher:GetSprite().Rotation)
	local pos = launcher.Position + dir:Resized(50)
	local vel = dir:Resized(15)
	local disc = nil

	if dataPlayer.WonderDiscType == DiscType.COIN then

		disc = Isaac.Spawn(EntityType.ENTITY_TEAR, EEVEEMOD.TearVariant.WONDERCOIN, 0, pos, vel, player):ToTear()
		local sprite = disc:GetSprite()
		local data = disc:GetData()
		local coinVariant = GetCoinDiscVariant(player)
		disc:AddTearFlags(TearFlags.TEAR_GREED_COIN)
		data.WonderCoinVariant = coinVariant
		sprite:Play("Spin", true)
		sprite:ReplaceSpritesheet(0, "gfx/tears/wondercoin_" .. coinVariant .. ".png")
		sprite:LoadGraphics()
		EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 2, false, 2, 0)

		local coinReduction = -1
		local damage = 10
		local mult = 1

		if coinVariant == 3 then
			coinReduction = -10
			mult = 10
		elseif coinVariant == 2 then
			coinReduction = -5
			mult = 5
		end
		player:AddCoins(coinReduction)
		disc.CollisionDamage = damage * mult
	elseif dataPlayer.WonderDiscType == DiscType.BOMB then

		disc = player:FireBomb(player.Position, vel, player)
		disc:AddTearFlags(player:GetBombFlags())
		player:AddBombs(-1)
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_BULLET_SHOT, 1, 0, false, 0.5, 0)

	elseif dataPlayer.WonderDiscType == DiscType.KEY then

		disc = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.KEY, 0, pos, vel, player):ToTear()
		disc:AddTearFlags(TearFlags.TEAR_PIERCING)
		disc.CollisionDamage = (player.Damage * 5) + 30
		player:AddKeys(-1)
		EEVEEMOD.sfx:Play(SoundEffect.SOUND_SHELLGAME)

	elseif dataPlayer.WonderDiscType == DiscType.POOP then
		if throwableSpells[player:GetPoopSpell(0)] == true then
			dataPlayer.WonderDestroyPoopQueue = player:GetPoopSpell(0)
			if player:GetPoopSpell(0) == PoopSpellType.SPELL_BOMB then

				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_BUTT, 0, pos, vel, player):ToBomb()
				bomb:AddTearFlags(TearFlags.TEAR_BUTT_BOMB)
				EEVEEMOD.sfx:Play(SoundEffect.SOUND_BULLET_SHOT, 1, 0, false, 0.5, 0)

			else

				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, EEVEEMOD.TearVariant.WONDERPOOP, 0, pos, vel, player):ToTear()
				local poop = Isaac.Spawn(EntityType.ENTITY_POOP, spellToPoopVariant[player:GetPoopSpell(0)], 0, pos, vel, player)
				local data = tear:GetData()
				local sprite = tear:GetSprite()
				EEVEEMOD.sfx:Play(SoundEffect.SOUND_FART, 1, 0, false, 2, 0)
				EEVEEMOD.sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
				tear.CollisionDamage = 0
				poop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				poop.Visible = false
				data.PoopSpellDisc = poop
				sprite:Play("Idle", true)
				sprite:ReplaceSpritesheet(0, "gfx/tears/wonderpoop_" .. player:GetPoopSpell(0) .. ".png")
				sprite:LoadGraphics()

			end
		end
	end
	SpawnItemWisp(player, dataPlayer.WonderDiscType)
end

---@param launcher EntityEffect
---@param player EntityPlayer
local function LauncherTimers(launcher, player)
	local data = launcher:GetData()

	if data.ShootDuration ~= nil then
		if data.ShootDuration > 0 then
			data.ShootDuration = data.ShootDuration - 1
		else
			data.ShootDuration = nil
			data.ShootCooldown = cooldownDuration
			if HasAmmoForPickup(player, player:GetData().WonderDiscType) then
				SetAnimState(launcher, "Reload")
			else
				SetAnimState(launcher, "Idle")
			end
		end
	end
	if data.ShootCooldown ~= nil then
		if data.ShootCooldown > 0 then
			data.ShootCooldown = data.ShootCooldown - 1
		else
			data.CanShoot = true
			data.ShootCooldown = nil
		end
	end
end

---@param launcher EntityEffect
function wonderousLauncher:FireHandling(launcher)
	if VeeHelper.EntitySpawnedByPlayer(launcher) then
		local player = launcher.SpawnerEntity:ToPlayer()
		local sprite = launcher:GetSprite()
		local data = launcher:GetData()

		LauncherTimers(launcher, player)

		data.AnimDir = GetLauncherDirection(sprite)

		if data.AnimState == "Reload" and not data.ShootCooldown then
			SetAnimState(launcher, "Idle")
		end

		if player:GetFireDirection() ~= Direction.NO_DIRECTION then
			if data.CanShoot == true
				and not data.ShootDuration
				and not data.ShootCooldown
				and HasAmmoForPickup(player, player:GetData().WonderDiscType)
				and data.AnimState ~= "Reload"
			then
				data.CanShoot = false
				data.ShootDuration = shootDuration
				SetAnimState(launcher, "Shoot")
			end
		end

		if sprite:IsEventTriggered("Shoot") then
			wonderousLauncher:FireDisc(launcher, player)
			UpdateWonderDiscSprite(player)
		end

		sprite:SetAnimation(data.AnimState .. data.AnimDir, false)
	end
end

---@param player EntityPlayer
local function DiscCoinTrackUpdate(player)
	local data = player:GetData()
	local curType = GetCoinDiscVariant(player)
	local shouldUpdate = false
	if not data.WonderCurrentCoin then data.WonderCurrentCoin = curType end
	if player:GetNumCoins() > 0 and curType ~= data.WonderCurrentCoin then
		data.WonderCurrentCoin = curType
		shouldUpdate = true
	end
	return shouldUpdate
end

---@param player EntityPlayer
function wonderousLauncher:ReloadOnNewAmmo(player)
	local data = player:GetData()
	if data.WonderLauncher then
		local dataLauncher = data.WonderLauncher:GetData()
		local hasAmmo = HasAmmoForPickup(player, data.WonderDiscType)
		if DiscCoinTrackUpdate(player) then
			data.WonderHasAmmo = false
		end
		if hasAmmo == true
			and not data.WonderHasAmmo
			and dataLauncher.CanShoot
			and dataLauncher.CanShoot == true
			and dataLauncher.AnimState ~= "Reload"
		then
			UpdateWonderDiscSprite(player)
			SetAnimState(data.WonderLauncher, "Reload")
		end
		data.WonderHasAmmo = hasAmmo
	end
end

---@param player EntityPlayer
function wonderousLauncher:OnPlayerUpdate(player)
	wonderousLauncher:SwapThroughPickups(player)
	wonderousLauncher:OrbitPlayer(player)
	wonderousLauncher:RemoveHeldPoopSpell(player)
	wonderousLauncher:ReloadOnNewAmmo(player)

	local data = player:GetData()

	if data.WonderLauncher
		and player:GetActiveItem() ~= EEVEEMOD.CollectibleType.WONDEROUS_LAUNCHER
	then
		RemoveWonderLauncher(player)
	end
end

---@param player EntityPlayer
function wonderousLauncher:OnNewRoom(player)
	local data = player:GetData()

	if data.WonderLauncher and not data.WonderLauncher:Exists() then
		SpawnWonderLauncher(player)
	end
end

return wonderousLauncher
