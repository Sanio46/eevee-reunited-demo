local evaluateCache = {}

local bagOfPokeballs = require("src_eevee.items.collectibles.bagOfPokeballs")
local lilEevee = require("src_eevee.items.collectibles.lilEevee")
local eeveeStats = require("src_eevee.player.eeveeStats")
local lockOnSpecs = require("src_eevee.items.trinkets.lockOnSpecs")
local eviolite = require("src_eevee.items.trinkets.eviolite")
local blackGlasses = require("src_eevee.items.collectibles.blackGlasses")
local cookieJar = require("src_eevee.items.collectibles.cookieJar")
local sneakScarf = require("src_eevee.items.collectibles.sneakScarf")
local addItemStats = require("src_eevee.items.addItemStats")
local familiarBasics = require("src_eevee.misc.familiarBasics")
local shinyCharm = require("src_eevee.items.collectibles.shinyCharm")

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function evaluateCache:main(player, cacheFlag)
	---@class ItemStats
	local itemStats = {
		SPEED = 0,
		FIREDELAY = 1,
		DAMAGE_FLAT = 0,
		DAMAGE_MULT = 1,
		RANGE = 0,
		SHOTSPEED = 0,
		LUCK = 0,
	}
	--Base Stats
	eeveeStats:OnCache(player, cacheFlag)

	--Item Stats
	lockOnSpecs:Stats(player, itemStats)
	eviolite:Stats(player, itemStats)
	blackGlasses:Stats(player, itemStats)
	sneakScarf:Stats(player, itemStats)
	cookieJar:Stats(player, itemStats)
	shinyCharm:Stats(player, itemStats)

	--Put together all item stats
	addItemStats:OnCache(player, cacheFlag, itemStats)

	for i, familiarTable in pairs(EEVEEMOD.ItemToFamiliarVariant) do
		local itemID = familiarTable[1]
		local familiarVariant = familiarTable[2]
		familiarBasics:evaluateCache(player, cacheFlag, itemID, familiarVariant)
	end
end

function evaluateCache:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluateCache.main)
end

return evaluateCache
