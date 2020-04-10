local composer = require("composer")
local GameScene = composer.newScene()

local obstacleFuncs = require("obstacles")
local pickupFuncs = require("pickups")
local enemies = require("enemies")
local player = require("player")

local wallCollisionFilter = {categoryBits=32, maskBits=25}  -- Walls collides only with 1 (player), 8 (bullets) and 16 (enemies)

local physics = require("physics")
physics.start()

function GameScene:create(event)
    audio.stop()
    local whiteSound = audio.loadStream("Resources/Audio/2sh.wav")
    audio.setVolume(0.5)
    audio.play(whiteSound, {loops= -1})

    
    -- wall stuff from enemies file, probably needs to be reworked a bit
    local Wall1 = display.newRect(1920,540,10,1080)
    local Wall2 = display.newRect(960,0,1920,10)
    local Wall3 = display.newRect(960,1080,1920,10)
    local Wall4 = display.newRect(0,540,10,1080)
    Wall1:setFillColor(1,1,0)
    Wall2:setFillColor(0,1,1)
    Wall3:setFillColor(0,1,1)
    Wall4:setFillColor(0,1,0)

    physics.addBody(Wall1, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})
    physics.addBody(Wall2, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})
    physics.addBody(Wall3, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})
    physics.addBody(Wall4, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})

    pickupFuncs.Setup()
    enemies.Setup()
    obstacleFuncs.Setup()
    player.setupPlayer()


    timer.performWithDelay(5000, function() pickupFuncs.SpawnRandomPickup() end, -1)
    display.setDefault("background", 204/255,204/255,204/255)
end
    
-- show()
function GameScene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then

    end
end


-- hide()
function GameScene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then

    end
end


-- destroy()
function GameScene:destroy(event)
    local sceneGroup = self.view
    print("GameScene:destroy\n")
    timer.stop()
end

-- Scene event function listeners
GameScene:addEventListener( "create", GameScene )
GameScene:addEventListener( "show", GameScene )
GameScene:addEventListener( "hide", GameScene )
GameScene:addEventListener( "destroy", GameScene )

return GameScene
