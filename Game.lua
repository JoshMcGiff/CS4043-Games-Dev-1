local composer = require("composer")
local GameScene = composer.newScene()

local colourMan = require("colourManager")
local displayMan = require("displayManager")
local obstacleFuncs = require("obstacles")
local pickupFuncs = require("pickups")
local enemies = require("enemies")
local player = require("player")
local physics = require("physics")
physics.start()

local wallCollisionFilter = {categoryBits=32, maskBits=25}  -- Walls collides only with 1 (player), 8 (bullets) and 16 (enemies)
local pickupSpawnTimer = nil
local enemySpawnTimer = nil
local enemyShootTimer = nil

local Wall1 = nil
local Wall2 = nil
local Wall3 = nil
local Wall4 = nil

local function gameLoop()


end

local function spawn_PauseMenu(event)
    if (event.phase == "down") then
        if (event.keyName == "escape") then
            pauseGame()
        end
    end
end

function pauseGame()
    _G.gamePaused = true --set a global value
    timer.pause(pickupSpawnTimer)
    timer.pause(enemySpawnTimer)
    timer.pause(enemyShootTimer)
    pickupFuncs.pause()
    player.pause()
    physics.pause()
    audio.pause()
    
    --Show pause screen
    composer.showOverlay("pauseScreen", {isModal = true, effect = "fade", time = 300})
end

function GameScene:resumeGame()
    audio.resume()
    physics.start()
    player.resume()
    pickupFuncs.resume()
    timer.resume(enemyShootTimer)
    timer.resume(enemySpawnTimer)
    timer.resume(pickupSpawnTimer)
    _G.gamePaused = false --set a global value
end

function GameScene:cleanupGame()
    timer.cancel(pickupSpawnTimer)
    timer.cancel(enemySpawnTimer)
    timer.cancel(enemyShootTimer)
    player.Cleanup()
    obstacleFuncs.Cleanup()
    enemies.Cleanup()
    pickupFuncs.Cleanup()
    displayMan.Cleanup()
    colourMan.Cleanup()
    display.remove(Wall1)
    display.remove(Wall2)
    display.remove(Wall3)
    display.remove(Wall4)
end

function GameScene:create(event)
    audio.stop()
    local whiteSound = audio.loadStream("Resources/Audio/2sh.wav")
    audio.setVolume(0.5)
    audio.play(whiteSound, {loops= -1})

    
    -- wall stuff from enemies file, probably needs to be reworked a bit
    Wall1 = display.newRect(1920,540,10,1080)
    Wall2 = display.newRect(960,0,1920,10)
    Wall3 = display.newRect(960,1080,1920,10)
    Wall4 = display.newRect(0,540,10,1080)
    Wall1:setFillColor(1,1,0)
    Wall2:setFillColor(0,1,1)
    Wall3:setFillColor(0,1,1)
    Wall4:setFillColor(0,1,0)

    physics.addBody(Wall1, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})
    physics.addBody(Wall2, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})
    physics.addBody(Wall3, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})
    physics.addBody(Wall4, "static", {friction=0.5, bounce=1.0, filter=wallCollisionFilter})

    displayMan.Setup() --should always be done first
    pickupFuncs.Setup()
    enemies.Setup()
    obstacleFuncs.Setup()
    player.setupPlayer()


    pickupSpawnTimer = timer.performWithDelay(5000, function() pickupFuncs.SpawnRandomPickup() end, -1)
    enemySpawnTimer = timer.performWithDelay(8000, function() enemies.SpawnRandom() end, -1) --spawn enemy every 8 seconds
    enemyShootTimer = timer.performWithDelay(5000, function() enemies.allShoot() end, -1) --every 5 seconds make all enemies shoot at player 

    display.setDefault("background", 204/255,204/255,204/255)
    Runtime:addEventListener("key", spawn_PauseMenu)
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
        self:cleanupGame()

    elseif (phase == "did") then

    end
end


-- destroy()
function GameScene:destroy(event)
    local sceneGroup = self.view
    print("GameScene:destroy\n")
end

-- Scene event function listeners
GameScene:addEventListener( "create", GameScene )
GameScene:addEventListener( "show", GameScene )
GameScene:addEventListener( "hide", GameScene )
GameScene:addEventListener( "destroy", GameScene )

return GameScene
