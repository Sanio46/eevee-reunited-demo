local postNpcInit = {}

---@param npc EntityNPC
function postNpcInit:main(npc)

end

function postNpcInit:init(EeveeReunited)
	EeveeReunited:AddCallback(ModCallbacks.MC_POST_NPC_INIT, postNpcInit.main)
end

return postNpcInit
