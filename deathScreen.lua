local widget = require("widget")
local composer = require("composer")
local deathUI = composer.newScene()
local pauseGroup = nil
local backBtnDistance = 70

local btnRestartGame = nil
local btnMainMenu = nil
local btnQuitGame = nil
local screenCap = nil

local resuming = false

local function spawnMainMenu()
    composer.hideOverlay("fade", 300)
    local new = audio.loadStream("Resources/audio/missu.wav")
    audio.setVolume(0.5)
    audio.play(new, {loops= -1})
    composer.gotoScene("MainMenu", { time=500, effect="crossFade" } )
end

local function restartGame()
    composer.removeScene("Game")
    composer.gotoScene("Game", { time=500, effect="crossFade" })
end

function deathUI:create(event)
    pauseGroup = display.newGroup()

    screenCap = display.captureScreen()
    screenCap.x, screenCap.y = display.contentCenterX, display.contentCenterY
    screenCap.fill.effect = "filter.blurGaussian"
    screenCap.fill.effect.horizontal.blurSize = 15
    screenCap.fill.effect.vertical.blurSize = 15

    btnRestartGame = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentHeight/1.5,
        id = "btnRestartGame",
        label = "Restart",
        onPress = restartGame,
        shape = "roundedRect",
        width = 450,
        height = 65,
        cornerRadius = 2,
        labelColor = { default={ 0, 0, 0 } },
        fillColor = { default={200/255, 200/255, 200/255, 1}, over={200/255, 200/255, 200/255, 0.4} },
        strokeColor = { default={55/255, 55/255, 55/255, 1}, over={55/255, 55/255, 55/255, 0.4} },
        strokeWidth = 4
    })

    btnMainMenu = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentHeight/1.26,
        id = "btnMainMenu",
        label = "Main Menu",
        onPress = spawnMainMenu,
        shape = "roundedRect",
        width = 450,
        height = 65,
        cornerRadius = 2,
        labelColor = { default={ 0, 0, 0 } },
        fillColor = { default={200/255, 200/255, 200/255, 1}, over={200/255, 200/255, 200/255, 0.4} },
        strokeColor = { default={55/255, 55/255, 55/255, 1}, over={55/255, 55/255, 55/255, 0.4} },
        strokeWidth = 4
    })

    pauseGroup:insert(screenCap)
    pauseGroup:insert(btnRestartGame)
    pauseGroup:insert(btnMainMenu)
end

-- show()
function deathUI:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        pauseGroup.isVisible = true

	elseif ( phase == "did" ) then

	end
end


-- hide()
function deathUI:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        pauseGroup.isVisible = false
        display.remove(btnRestartGame)
        display.remove(btnMainMenu)
        display.remove(screenCap)
        screenCap, btnRestartGame, btnMainMenu = nil, nil, nil

        if resuming == true then
            event.parent:restartGame()
        end

	elseif (phase == "did") then
        resuming = false
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
deathUI:addEventListener( "create", deathUI )
deathUI:addEventListener( "show", deathUI )
deathUI:addEventListener( "hide", deathUI )
--deathUI:addEventListener( "destroy", deathUI )
-- -----------------------------------------------------------------------------------

return deathUI
