local bagOfPokeballs = {}

---@param familiar EntityFamiliar
function bagOfPokeballs:SpawnPokeball(familiar)
	local sprite = familiar:GetSprite()
	local seed = EEVEEMOD.game:GetRoom():GetSpawnSeed()
	local player = familiar.Player

	if sprite:IsFinished("Spawn") then
		sprite:Play("FloatDown", false)
	end

	local numRoomsClearedCondition = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 8 or 12

	if familiar.RoomClearCount >= numRoomsClearedCondition then
		local ball = EEVEEMOD.PokeballType.POKEBALL
		local rng = familiar.Player:GetCollectibleRNG(EEVEEMOD.CollectibleType.BAG_OF_POKEBALLS)
		local randomNum = rng:RandomInt(10)

		if randomNum <= 1 then
			ball = EEVEEMOD.PokeballType.ULTRABALL
		elseif randomNum <= 3 then
			ball = EEVEEMOD.PokeballType.GREATBALL
		end

		EEVEEMOD.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, familiar.Position, Vector.Zero, familiar, ball, seed)
		sprite:Play("Spawn", false)
		familiar.RoomClearCount = 0
	end
end

return bagOfPokeballs
