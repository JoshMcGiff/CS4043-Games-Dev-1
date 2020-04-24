
local widget = require( "widget" )
local composer = require( "composer" )
local MainMenuUI = composer.newScene()
local buttonGroup

local background
local btnStart
local btnAchieve
local btnQuit

local function spawnGameMenu()
    if _G.doneTutorial == true then
        composer.gotoScene("Game", {time=500, effect="crossFade"})
    else
        _G.doneTutorial = true
        composer.gotoScene("tutorial", {time=500, effect="crossFade"})
    end
end

local function spawnAchieveMenu()
    composer.gotoScene( "AchieveMenu", { time=500, effect="fromBottom" } )
end

local function quitApp()
    native.requestExit()
end

function MainMenuUI:create(event)
    local new = audio.loadStream("Resources/audio/menu.wav")
    audio.setVolume(0.5)
    audio.play(new, {loops= -1})
    buttonGroup = display.newGroup()
    background = display.newImageRect(self.view, "Resources/Gfx/menu.jpg", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    btnStart = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentHeight/1.5,
        id = "btnStart",
        label = "Start Game",
        onPress = spawnGameMenu,
        shape = "roundedRect",
        width = 450,
        height = 65,
        cornerRadius = 2,
        labelColor = { default={ 0, 0, 0 } },
        fillColor = { default={200/255, 200/255, 200/255, 1}, over={200/255, 200/255, 200/255, 0.4} },
        strokeColor = { default={55/255, 55/255, 55/255, 1}, over={55/255, 55/255, 55/255, 0.4} },
        strokeWidth = 4
    })

    btnAchieve = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentHeight/1.26,
        id = "btnAchieve",
        label = "Achievements",
        onPress = spawnAchieveMenu,
        shape = "roundedRect",
        width = 450,
        height = 65,
        cornerRadius = 2,
        labelColor = { default={ 0, 0, 0 } },
        fillColor = { default={200/255, 200/255, 200/255, 1}, over={200/255, 200/255, 200/255, 0.4} },
        strokeColor = { default={55/255, 55/255, 55/255, 1}, over={55/255, 55/255, 55/255, 0.4} },
        strokeWidth = 4
    })

    btnQuit = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentHeight/1.1,
        id = "btnQuit",
        label = "Quit",
        onPress = quitApp,
        shape = "roundedRect",
        width = 450,
        height = 65,
        cornerRadius = 2,
        labelColor = { default={ 0, 0, 0 } },
        fillColor = { default={200/255, 200/255, 200/255, 1}, over={200/255, 200/255, 200/255, 0.4} },
        strokeColor = { default={55/255, 55/255, 55/255, 1}, over={55/255, 55/255, 55/255, 0.4} },
        strokeWidth = 4
    })

    buttonGroup:insert(btnStart)
    buttonGroup:insert(btnAchieve)
    buttonGroup:insert(btnQuit)
end

-- show()
function MainMenuUI:show( event )

	local sceneGroup = self.view
	local phase = event.phase

    if ( phase == "will" ) then
        background.isVisible = true
        buttonGroup.isVisible = true
        composer.removeHidden() --delete other scenes like game to completely reset
	elseif ( phase == "did" ) then
        
	end
end


-- hide()
function MainMenuUI:hide( event )
    
	local sceneGroup = self.view
	local phase = event.phase
    
	if ( phase == "will" ) then
        buttonGroup.isVisible = false
        
	elseif ( phase == "did" ) then
        background.isVisible = false
        
	end
end

MainMenuUI:addEventListener("create", MainMenuUI)
MainMenuUI:addEventListener("show", MainMenuUI)
MainMenuUI:addEventListener("hide", MainMenuUI)

return MainMenuUI
