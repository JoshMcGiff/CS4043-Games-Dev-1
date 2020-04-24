local widget = require("widget")
local composer = require("composer")
local pauseUI = composer.newScene()
local pauseGroup = nil
local backBtnDistance = 70

local btnResumeGame = nil
local btnMainMenu = nil
local btnQuitGame = nil
local screenCap = nil

local resuming = false

local function spawnMainMenu()
    composer.hideOverlay("fade", 300)
    composer.gotoScene("MainMenu", { time=500, effect="crossFade" } )
end

local function backToGame()
    resuming = true
    composer.hideOverlay("fade", 300)
end

function pauseUI:create(event)
    pauseGroup = display.newGroup()

    screenCap = display.captureScreen()
    screenCap.x, screenCap.y = display.contentCenterX, display.contentCenterY
    screenCap.fill.effect = "filter.blurGaussian"
    screenCap.fill.effect.horizontal.blurSize = 15
    screenCap.fill.effect.vertical.blurSize = 15

    btnResumeGame = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentHeight/1.5,
        id = "btnResumeGame",
        label = "Resume",
        onPress = backToGame,
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
    pauseGroup:insert(btnResumeGame)
    pauseGroup:insert(btnMainMenu)
end

-- show()
function pauseUI:show( event )
	local phase = event.phase

	if ( phase == "will" ) then
        pauseGroup.isVisible = true

	elseif ( phase == "did" ) then

	end
end


-- hide()
function pauseUI:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        pauseGroup.isVisible = false
        display.remove(btnResumeGame)
        display.remove(btnMainMenu)
        display.remove(screenCap)
        screenCap, btnResumeGame, btnMainMenu = nil, nil, nil

        if resuming == true then
            event.parent:resumeGame()
        end

	elseif (phase == "did") then
        resuming = false
	end
end

pauseUI:addEventListener("create", pauseUI)
pauseUI:addEventListener("show", pauseUI)
pauseUI:addEventListener("hide", pauseUI)

return pauseUI
