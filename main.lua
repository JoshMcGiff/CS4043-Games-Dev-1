	-----------------------------------------------------------------------------------------
	--
	-- main.lua
	--
	-----------------------------------------------------------------------------------------

	-- Go to the menu screen
	local composer = require("composer")
	composer.isDebug = true --we should disable this when done the game
	--native.setProperty("mouseCursorVisible", false) <- Enable this if Shane implements a custom cursor because mouse is ugly
	native.setProperty("windowMode", "fullscreen") -- puts app in fullscreen mode when built, pause menu needed before enabling
	
	--swap these two lines for when wanting to go into menu first and straight into game
	--composer.gotoScene("Game",{ time=800, effect="crossFade" })
	composer.gotoScene("MainMenu",{ time=800, effect="crossFade" }) 
