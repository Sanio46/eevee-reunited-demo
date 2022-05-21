--funny require() hack so it can be used with luamod. Go to the init file for start stuff.

--TODO:
--Black Candle edited ver for Eevee
--Detect golden trinkets that drop for unlock manager
--Isaac's Tears charing? I guess? lol.
--Figure out what to do for postTearSplash and spectral tears on collision.
--Spirit Sword still breaks when transitions rooms apparently

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
