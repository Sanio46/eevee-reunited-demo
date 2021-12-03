local customMrDolly = {}

-- Credit to stewart, creator of the "Custom Mr. Dollys" mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2489635144

function customMrDolly:ReplaceDollyPedestalOnInit(pickup)
	local player = Isaac.GetPlayer(0) --Only replace pedestal if Eevee is the first player.
	local playerType = player:GetPlayerType()
	local sprite = pickup:GetSprite()
	local dataPedestal = pickup:GetData()
	local level = EEVEEMOD.game:GetLevel()
	local pedestalType = 5
	local collectibleVariant = 100
	local mrDollyID = 370
	
	
	if pickup.Type == pedestalType
	and pickup.Variant == collectibleVariant
	and pickup.SubType == mrDollyID
	and level:GetCurses() ~= LevelCurse.CURSE_OF_BLIND then
		if EEVEEMOD.Data.CustomDolly == true then
			if playerType == EEVEEMOD.PlayerType.EEVEE then
				sprite:ReplaceSpritesheet (1, "gfx/items/collectibles/"..player:GetName().."_MrDolly.png") --Add the character # to the custom MrDolly sprite to replace
				sprite:LoadGraphics()
				sprite:Update()
				sprite:Render(pickup.Position, Vector.Zero, Vector.Zero)
				dataPedestal.DollyReplaced = true
			end
		elseif dataPedestal.DollyReplaced then
			sprite:ReplaceSpritesheet (1, "gfx/items/collectibles/collectibles_370_mrdolly.png") --Add the character # to the custom MrDolly sprite to replace
			sprite:LoadGraphics()
			sprite:Update()
			sprite:Render(pickup.Position, Vector.Zero, Vector.Zero)
			dataPedestal.DollyReplaced = false
		end
	end
end

function customMrDolly:ReplaceDollyCostume(player)
	local playerType = player:GetPlayerType()
	local data = player:GetData()
	local dollyConfig = Isaac.GetItemConfig():GetCollectible(370)
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MR_DOLLY)
	and not data.DollyCostumeReplaced then
		if EEVEEMOD.Data.CustomDolly == true then
			if playerType == EEVEEMOD.PlayerType.EEVEE then
				player:ReplaceCostumeSprite(dollyConfig, "gfx/characters/costumes/"..player:GetName().."_DollyCostume.png", 0)
				data.DollyCostumeReplaced = true
			end
		elseif data.DollyCostumeReplaced then
			player:ReplaceCostumeSprite(dollyConfig, "gfx/characters/costumes/costume_370_mrdolly.png", 0)
			data.DollyCostumeReplaced = false
		end
	end
end

return customMrDolly