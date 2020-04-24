
local widget = require( "widget" )
local composer = require( "composer" )
local colourFuncs = require("colourManager")
local TutorialMenuUI = composer.newScene()
local TutorialGroup
local i = 120
local j = 70

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
        x = display.contentWidth-i,
        y = display.contentHeight-j,
        id = "btnGame",
        label = "Icon\nHere",
        onPress = ToGame,
        shape = "Rect",
        width = 200,
        height = 100,
        cornerRadius = 2,
        fillColor = { default={0,1,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={0,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    })

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
