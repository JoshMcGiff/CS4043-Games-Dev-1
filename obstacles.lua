
    local colourMan = require("colourManager")

    local obstacleFuncs = {}
    local obstacleCollisionFilter = {categoryBits=2, maskBits=9}    --Obstacles (2) collides with player (1) and playerBullets (8)
    local obstacleGroup = display.newGroup()

    local obGfxTable = {
        ["White"] = "Resources/Gfx/rock.png",
        ["Green"] = "Resources/Gfx/bush.png",
        ["Blue"] = "Resources/Gfx/rock.png",
        ["Red"] = "Resources/Gfx/rock.png",
        ["Yellow"] = "Resources/Gfx/rock.png",
        ["Cyan"] = "Resources/Gfx/rock.png",
        ["Magenta"] = "Resources/Gfx/rock.png",
    }
     
    local obAmount = 0;
    local obArray = {}

    local function obstacles_SpawnAll(fileName)
        while (obAmount < 6) do --spawn 6 obstacles
            local ranX = math.random(0, display.contentWidth)
            local ranY = math.random(0, display.contentHeight)
            local dimensions = math.random(100, 200)
            local ob = display.newImageRect(fileName, dimensions, dimensions)
            ob.myName = fileName
            ob.x = ranX
            ob.y = ranY
            physics.addBody(ob, "static", {density=1.0, filter=obstacleCollisionFilter})
            obArray[obAmount] = ob
            obAmount = obAmount+1            
        end	
    end
    
    local function obstacles_RemoveAll()
        while (obAmount > 0) do
            physics.removeBody(obArray[obAmount-1])
            display.remove(obArray[obAmount-1])	
            obAmount = obAmount-1
        end
    end

    --to be used as a callback
    local function updateObstacles()
        obstacles_RemoveAll()
        obstacles_SpawnAll(obGfxTable[colourMan.getColourString()])
    end
    
    function obstacleFuncs.Setup()
        obstacles_RemoveAll()
        obstacles_SpawnAll(obGfxTable["White"])
        colourMan.addCallback(function()updateObstacles()end)
    end


return obstacleFuncs