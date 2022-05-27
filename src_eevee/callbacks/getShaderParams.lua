local getShaderParams = {}

local activeItemRender = require("src_eevee.items.activeItemRender")

function getShaderParams:main(shaderName)
	if shaderName == "EeveeReunited-RenderAboveHUD" then
		activeItemRender:RenderActiveItem()
	end
end

function getShaderParams:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, getShaderParams.main)
end

return getShaderParams