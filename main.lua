	-----------------------------------------------------------------------------------------
	--
	-- main.lua
	--
	-----------------------------------------------------------------------------------------

	-- Go to the menu screen
	local composer = require("composer")
	native.setProperty("windowMode", "fullscreen") -- puts app in fullscreen mode when built, pause menu needed before enabling
	
	composer.gotoScene("MainMenu",{ time=800, effect="crossFade" }) 
