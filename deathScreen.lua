local widget = require("widget")
local composer = require("composer")
local deathUI = composer.newScene()
local pauseGroup = nil

local btnRestartGame = nil
local btnMainMenu = nil
local btnQuitGame = nil
local screenCap = nil
local secondsSurvivied = 0
local scoreText = nil
local gameOverText = nil

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
    local params = event.params

    if params then
        screenCap = params.screenshot
        screenCap.isVisible = true
        secondsSurvivied = params.score
    end

    local minutes = math.floor(secondsSurvivied / 60)
    local seconds = secondsSurvivied % 60
    scoreText = display.newText(string.format("   Time\n  %02d.%02d", minutes, seconds), display.contentCenterX, display.contentHeight/2.3, "Resources/Gfx/Doctor Glitch.otf", 80)
    scoreText:setFillColor(0,0,0)
    
    gameOverText = display.newText("GAME OVER!", display.contentCenterX, display.contentHeight/4, "Resources/Gfx/Doctor Glitch.otf", 80)
    gameOverText:setFillColor(0,0,0)

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
    pauseGroup:insert(scoreText)
    pauseGroup:insert(gameOverText)
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
        display.remove(scoreText)
        display.remove(gameOverText)
        display.remove(screenCap)
        screenCap, scoreText, gameOverText, btnRestartGame, btnMainMenu = nil, nil, nil, nil, nil
        secondsSurvivied = 0        

	elseif (phase == "did") then
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
