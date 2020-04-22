
local widget = require( "widget" )
local composer = require( "composer" )
local colourFuncs = require("colourManager")
local AchieveMenuUI = composer.newScene()
local AchieveGroup
local backBtnDistance = 70


local function backToMainMenu()
    composer.gotoScene( "MainMenu",  { time=500, effect="fromTop" } )
end

local btnMainMenu
local background

function AchieveMenuUI:create(event)
    AchieveGroup = display.newGroup()

    background = display.newImageRect(self.view, "Resources/Gfx/menu.jpg", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background:setFillColor(100/255, 100/255, 255/255)  -- Tints image blue

    btnMainMenu = widget.newButton({
        parent = self.view,
        x = display.contentWidth-backBtnDistance,
        y = display.contentHeight-backBtnDistance,
        id = "btnMainMenu",
        label = "Icon\nHere",
        onPress = backToMainMenu,
        shape = "Rect",
        width = 50,
        height = 50,
        cornerRadius = 2,
        fillColor = { default={0,1,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={0,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    })
    -- Achievement 1:
    if (colourFuncs.achievement1() == false) then
         achieve1 = display.newImageRect(self.view, "Resources/Gfx/achieve1.png", 1000, 200)
    else 
         achieve1 = display.newImageRect(self.view, "Resources/Gfx/achieve1done.png", 1000, 200)
    end  
        achieve1.x = display.contentCenterX
        achieve1.y = display.contentCenterY / 2 

    -- Achievement 2:
    if (colourFuncs.achievement2() == false) then
         achieve2 = display.newImageRect(self.view, "Resources/Gfx/achieve2.png", 1000, 200)
    else 
         achieve2 = display.newImageRect(self.view, "Resources/Gfx/achieve2done.png", 1000, 200)
    end
        achieve2.x = display.contentCenterX
        achieve2.y = display.contentCenterY 

    -- Achievement 3:
    if (colourFuncs.achievement3() == false) then
         achieve3 = display.newImageRect(self.view, "Resources/Gfx/achieve3.png", 1000, 200)
    else
         achieve3 = display.newImageRect(self.view, "Resources/Gfx/achieve3done.png", 1000, 200)
    end
        achieve3.x = display.contentCenterX
        achieve3.y = display.contentCenterY / 2 * 3
    


    AchieveGroup:insert(btnMainMenu)
end

-- show()
function AchieveMenuUI:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        AchieveGroup.isVisible = true

	elseif ( phase == "did" ) then

	end
end


-- hide()
function AchieveMenuUI:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        AchieveGroup.isVisible = false

    elseif ( phase == "did" ) then
        display.remove(AchieveGroup)

	end
end


-- destroy()
function AchieveMenuUI:destroy( event )
    local sceneGroup = self.view
    print("AchieveMenuUI:destroy\n")
    display:remove(AchieveGroup)
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
AchieveMenuUI:addEventListener( "create", AchieveMenuUI )
AchieveMenuUI:addEventListener( "show", AchieveMenuUI )
AchieveMenuUI:addEventListener( "hide", AchieveMenuUI )
AchieveMenuUI:addEventListener( "destroy", AchieveMenuUI )
-- -----------------------------------------------------------------------------------

return AchieveMenuUI
