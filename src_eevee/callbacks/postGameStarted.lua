local postGameStarted = {}

function postGameStarted:main(wasRunContinued)
	if not wasRunContinued then
		EEVEEMOD.isNewGame = true
	end
end

return postGameStarted