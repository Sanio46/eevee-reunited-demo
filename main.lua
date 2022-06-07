--funny require() hack so it can be used with luamod. Go to the init file for start stuff.

--Noted Bugs on Workshop:
--Golden Trinkets of Eevee's unlockable trinkets that have not been unlocked can appear, but will be rerolled when picked up.
--Isaac's Tears does not work with Eevee (does not charge when firing)
--Black Candle's costume on Eevee does not line up correctly
--(FIXED?) Swift stars constantly splash on collision with friendly enemies and Stoneys, and possibly other entities.
--(WIP) Spirit Sword with Eevee stops spawning stars when transitioning rooms
--(FIXED) Any items that would grant Eevee a unique hair costume are not applied if picked up while transitioning rooms
--(WIP) Anything that involves constantly changing your firerate at a rapid pace breaks Swift, usually causing it to be unable to fire. (This will take a while to fix...)
--Swift's Brimstone lasers are invisible with Chocolate Milk
--(FIXED) All laser weapon types deal extremely low damage with Chocolate Milk
--(FIXED) Swift loses range over the duration of its charge-up
--(FIXED) Tail Whip cannot be found in any item pools
--(For below, use Friendly Ball logic for enemies, keep current logic for bosses)
--Catching an enemy that a boss would normally require that they stop existing causes a softlock.

local json = require("json")

local function isLuaDebugEnabled()
	return package ~= nil
end

local function initGlobalVariable()
	if EEVEEMOD == nil then
		EEVEEMOD = {}
	end
	if EEVEEMOD.Src == nil then
		EEVEEMOD.Src = {}
	end
end

local function unloadEverything()
	for k, v in pairs(EEVEEMOD.Src) do
		package.loaded[k] = nil
	end
end

local vanillaRequire = require
local function patchedRequire(file)
	EEVEEMOD.Src[file] = true
	return vanillaRequire(file)
end

if isLuaDebugEnabled() then
	initGlobalVariable()
	unloadEverything()
	require = patchedRequire
end

local modInit = require("EeveeReunitedInit")
modInit:init(json)

if isLuaDebugEnabled() then
	require = vanillaRequire
end
