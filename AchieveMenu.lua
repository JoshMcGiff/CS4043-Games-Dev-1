
local widget = require( "widget" )
local composer = require( "composer" )
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
