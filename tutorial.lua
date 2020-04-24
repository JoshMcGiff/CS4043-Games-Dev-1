
local widget = require( "widget" )
local composer = require( "composer" )
local colourFuncs = require("colourManager")
local TutorialMenuUI = composer.newScene()
local TutorialGroup = nil

local function ToGame()
    composer.gotoScene("Game", {time=500, effect="crossFade"})
end

local btnGame
local background

function TutorialMenuUI:create(event)
    TutorialGroup = display.newGroup()
    background = display.newImageRect(self.view, "Resources/Gfx/tutorial.jpg", display.contentWidth , display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
  
    btnGame = widget.newButton({
        parent = self.view,
        x = display.contentCenterX,
        y = display.contentCenterY,
        id = "btnGame",
        label = "",
        onPress = ToGame,
        shape = "Rect",
        width = display.contentWidth,
        height = display.contentHeight,
        cornerRadius = 2,
        fillColor = {default={0,0,0,0.1}, over={0,0,0,0.1}},
    })

    TutorialGroup:insert(background)
   TutorialGroup:insert(btnGame)
end

-- hide()
function TutorialMenuUI:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        TutorialGroup.isVisible = false
    end
end


-- destroy()
function TutorialMenuUI:destroy( event )
    --print("TutorialMenuUI:destroy\n")
    display:remove(TutorialGroup)
end

TutorialMenuUI:addEventListener("create", TutorialMenuUI)
TutorialMenuUI:addEventListener("hide", TutorialMenuUI)
TutorialMenuUI:addEventListener("destroy", TutorialMenuUI)

return TutorialMenuUI
