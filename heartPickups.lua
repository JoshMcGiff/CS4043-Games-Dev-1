local player = require("player")

local heartFuncs = {}
local heartCollisionFilter = {categoryBits=64, maskBits=1} --hearts (64) collides with player (1)

local heartArray = {}
local heartDespawnTimerTable = {}
local heartDespawnTransitionTable = {}

local function heartCollision(self, event)
    if event.phase == "began" and (event.other.myName == "player") then --player
        self:removeEventListener("collision")
        player.add1Life()
        self.isVisible = false
        timer.performWithDelay(50, function() physics.removeBody(self) end)
    end
end
    
local function hearts_RemoveAll()
    for i,v in ipairs (heartArray) do
        display.remove(v)
    end
    heartArray = {}
end
    
function heartFuncs.Spawn(x,y)
    local heart = display.newImageRect("Resources/Gfx/heart.png", 50, 50)
    heart.x = x
    heart.y = y
    heart.anchorX = 0.1
    heart.anchorY = 0.1
    heart.myName = "heartPickup"
    physics.addBody(heart, "static", {filter=heartCollisionFilter})

    heart.collision = heartCollision
    heart:addEventListener("collision")

    table.insert(heartArray, heart)
    
    local despawnTime = 10000
    local tran = transition.to(heart, {time=despawnTime, alpha=0})
    
    local timeDespawn = timer.performWithDelay(despawnTime, function() 
        --display.remove(heart)
        table.remove(heartDespawnTimerTable, 0)
        table.remove(heartDespawnTransitionTable, 0)
    end)
    
    table.insert(heartDespawnTimerTable, timeDespawn)
    table.insert(heartDespawnTransitionTable, tran)
end

function heartFuncs.pause()
    for i,v in ipairs (heartDespawnTransitionTable) do
        transition.pause(v)
    end
    for i,v in ipairs (pickupDespawnTimerTable) do
        timer.pause(v)
    end
end

function heartFuncs.resume()
    for i,v in ipairs (heartDespawnTransitionTable) do
        transition.resume(v)
    end
    for i,v in ipairs (pickupDespawnTimerTable) do
        timer.resume(v)
    end
end
    
function heartFuncs.Cleanup()
    obstacles_RemoveAll()
end


return heartFuncs