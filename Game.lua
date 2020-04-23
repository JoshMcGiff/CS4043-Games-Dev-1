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

local background = nil
local clockText = nil
local countDownTimer = nil

local afterRingSetup = false
local secondsLeft = nil
local Wall1 = nil
local Wall2 = nil
local Wall3 = nil
local Wall4 = nil

local livesArray = {}

local function gameLoop()


end

local function changeBackground()
    colourMan.updateObjColour(background)
end

local function spawn_PauseMenu(event)
    if (event.phase == "down") then
        if (event.keyName == "escape") then
            pauseGame()
        end
    end
end

local function spawn_DeathScreen(event)
    if (event.phase == "down") then
        if (event.keyName == "0") then
            deathGame()
        end
    end
end

function pauseGame()
    if (not (enemyShootTimer == nil)) then
        timer.pause(enemyShootTimer)
    end
    if (not (enemySpawnTimer == nil)) then
        timer.pause(enemySpawnTimer)
    end
    if (not (pickupSpawnTimer == nil)) then
        timer.pause(pickupSpawnTimer)
    end
    pickupFuncs.pause()
    player.pause()
    physics.pause()
    audio.pause()
    Runtime:removeEventListener("key", spawn_PauseMenu)
    
    --Show pause screen
    composer.showOverlay("pauseScreen", {isModal = true, effect = "fade", time = 300})
end

function deathGame()
    if (not (enemyShootTimer == nil)) then
        timer.pause(enemyShootTimer)
    end
    if (not (enemySpawnTimer == nil)) then
        timer.pause(enemySpawnTimer)
    end
    if (not (pickupSpawnTimer == nil)) then
        timer.pause(pickupSpawnTimer)
    end
    pickupFuncs.pause()
    player.pause()
    physics.pause()
    audio.pause()

    for i,v in ipairs(livesArray) do
        display.remove(v)
        v = nil
    end
    livesArray = {}
    
    --goto death screen
    composer.gotoScene("deathScreen", {effect = "fade", time = 300})
end

function GameScene:resumeGame()
    Runtime:addEventListener("key", spawn_PauseMenu)
    audio.resume()
    physics.start()
    player.resume()
    pickupFuncs.resume()
    if (not (enemyShootTimer == nil)) then
        timer.resume(enemyShootTimer)
    end
    if (not (enemySpawnTimer == nil)) then
        timer.resume(enemySpawnTimer)
    end
    if (not (pickupSpawnTimer == nil)) then
        timer.resume(pickupSpawnTimer)
    end
end

function GameScene:cleanupGame()
    Runtime:removeEventListener("key", spawn_PauseMenu)
    Runtime:removeEventListener("key", spawn_DeathScreen)
    if (not (enemyShootTimer == nil)) then
        timer.cancel(enemyShootTimer)
    end
    if (not (enemySpawnTimer == nil)) then
        timer.cancel(enemySpawnTimer)
    end
    if (not (pickupSpawnTimer == nil)) then
        timer.cancel(pickupSpawnTimer)
    end
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
    display.remove(clockText)
    display.remove(background)
end

local function updateTime(event)
    secondsLeft = secondsLeft + 1
    local minutes = math.floor( secondsLeft / 60 )
    local seconds = secondsLeft % 60
    local timeDisplay = string.format( "%02d.%02d", minutes, seconds )
    clockText.text = timeDisplay
end

function updateHealth()
    for i,v in ipairs(livesArray) do
        display.remove(v)
        v = nil
    end

    livesArray = {} --reset hearts array
    --for i=1,player.getMaxLives() do
    for i=1,player.getLives() do
        local heart = display.newImageRect("Resources/Gfx/heart.png", 100, 100)
        heart.x = display.contentWidth * (1.00 - (0.05*i))
        heart.y = display.contentHeight * 0.05
        table.insert(livesArray, heart)
    end
end

local function afterRingPickup()
    if (afterRingSetup == true) then
        return
    end
    enemies.Setup()
    enemySpawnTimer = timer.performWithDelay(1000, function() enemies.SpawnRandom() end, -1) --spawn enemy every 8 seconds
    enemyShootTimer = timer.performWithDelay(2500, function() enemies.allShoot() end, -1) --every 2.5 seconds make all enemies shoot at player 
    pickupSpawnTimer = timer.performWithDelay(5000, function() pickupFuncs.SpawnRandomPickup() end, -1)
    afterRingSetup = true
end

function GameScene:create(event)
    composer.removeScene("deathScreen")
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
    pickupFuncs.Setup(afterRingPickup) --'afterRingPickup' is called after player picks an initial colour
    afterRingSetup = false
    obstacleFuncs.Setup()
    player.setupPlayer(updateHealth)
    updateHealth() --call to setup gfx once
    background = display.newImageRect("Resources/Gfx/background.jpg", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background:toBack()
    secondsLeft = 0
    colourMan.addCallback(changeBackground)
    clockText = display.newText("00.00", display.contentCenterX/5, 80, "Resources/Gfx/Doctor Glitch.otf", 150)
    clockText:setFillColor(0,0,0)

    countDownTimer = timer.performWithDelay(1000, updateTime, -1) --update clock every second

    display.setDefault("background", 204/255,204/255,204/255)
    Runtime:addEventListener("key", spawn_PauseMenu)
    Runtime:addEventListener("key", spawn_DeathScreen)
end

local function updateColour()
    colourMan.updateObjColour(background)
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
