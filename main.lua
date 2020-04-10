	-----------------------------------------------------------------------------------------
	--
	-- main.lua
	--
	-----------------------------------------------------------------------------------------

	-- Go to the menu screen
	local composer = require("composer")
	--native.setProperty("mouseCursorVisible", false) <- Enable this when Shane implements a custom cursor because mouse is ugly
	--native.setProperty("windowMode", "fullscreen") -- puts app in fullscreen mode when built, pause menu needed before enabling
	
	composer.gotoScene("Game",{ time=800, effect="crossFade" })
