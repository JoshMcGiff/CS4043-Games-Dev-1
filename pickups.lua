
    local colourMan = require("colourManager")
    local displayMan = require("displayManager")

    local pickupFuncs = {}
    local pickupCollisionFilter = {categoryBits=4, maskBits=1}    --Pickups (4) collide with player (1)

    local soundTable = {
        ["Blue"] = audio.loadSound("Resources/Audio/Blue.wav"),
	    ["Green"] = audio.loadSound("Resources/Audio/Green.wav"),
	    ["Red"] = audio.loadSound("Resources/Audio/Red.wav"),
	    ["Yellow"] = audio.loadSound("Resources/Audio/Yellow.wav"),
	    ["Magenta"] = audio.loadSound("Resources/Audio/Magenta.wav"),
        ["Cyan"] = audio.loadSound("Resources/Audio/Cyan.wav"),
    }

    local colourTable = {
        ["bluePickup"] = "Blue",
	    ["greenPickup"] = "Green",
	    ["redPickup"] = "Red",
	    ["yellowPickup"] = "Yellow",
	    ["magentaPickup"] = "Magenta",
        ["cyanPickup"] = "Cyan"
    }
    
    local pickUpSound = audio.loadSound("Resources/Audio/pickup.wav")
    local pickUpCallback = nil

    local bluePickup = nil
	local greenPickup = nil
	local redPickup = nil
	local yellowPickup = nil
	local magentaPickup = nil
    local cyanPickup = nil

    local pickupDespawnTimerTable = {}
    local pickupStartTable = {}
    local pickupTable = {}

    --colour manager callback (change audio when change colour)
    local function reloadAudio()
            audio.stop() --stop previous audio
            audio.play(pickUpSound) --sound played when you pickup something
            audio.play(soundTable[colourMan.getColourString()], {loops= -1, fadein = 500})
    end

    -- THESE ARE FOR PICKUPS SPAWNING IN A RING AT START OF GAME --
    local function pickupStart_RemoveAll()
        for i,v in ipairs(pickupStartTable) do
            v.isVisible = false
            displayMan.remove(v)
            v = nil
        end
        pickupStartTable = {}
    end

    local function pickupStartCollisions(self, event)
        if event.phase == "began" and event.other.myName == "player" then
            self:removeEventListener("collision")
            timer.performWithDelay(50, function() colourMan.setCommonColour(colourTable[self.myName], true) end)
            timer.performWithDelay(50, pickupStart_RemoveAll, 1)
            
            if (not (pickUpCallback == nil)) and type(pickUpCallback) == "function" then
                timer.performWithDelay(50, pickUpCallback, 1) --start spawning enemies, more pickups, etc
                pickUpCallback = nil --not needed anymore, remove so cant be called again
            end
		end
    end

    local function pickupStartSpawnCommon(pickup)
        pickup.isVisible = true
		physics.addBody(pickup, "static", {filter=pickupCollisionFilter})

        pickup.collision = pickupStartCollisions
        pickup:addEventListener("collision")
        table.insert(pickupStartTable, pickup)
    end

    local function spawnStartBlue()
        bluePickup = displayMan.newRandomImageRect("Resources/Gfx/blue.png", 50, 50)
        local x = display.contentCenterX
        local y = display.contentCenterY - (display.contentCenterY * 0.25)
        displayMan.move(bluePickup,x,y)
        bluePickup.myName = "bluePickup"
        pickupStartSpawnCommon(bluePickup)
    end
    
    local function spawnStartGreen()
        greenPickup = displayMan.newRandomImageRect("Resources/Gfx/green.png", 50, 50)
        local x = display.contentCenterX
        local y = display.contentCenterY + (display.contentCenterY * 0.25)
        displayMan.move(greenPickup,x,y)
        greenPickup.myName = "greenPickup"
        pickupStartSpawnCommon(greenPickup)
    end

    local function spawnStartRed()
        redPickup = displayMan.newRandomImageRect("Resources/Gfx/red.png", 50, 50)
        local x = display.contentCenterX - (display.contentCenterY * 0.19)
        local y = display.contentCenterY - (display.contentCenterY * 0.10)
        displayMan.move(redPickup,x,y)
        redPickup.myName = "redPickup"
		pickupStartSpawnCommon(redPickup)
    end

    local function spawnStartMagenta()
        magentaPickup = displayMan.newRandomImageRect("Resources/Gfx/magenta.png", 50, 50)
        local x = display.contentCenterX + (display.contentCenterY * 0.19)
        local y = display.contentCenterY - (display.contentCenterY * 0.10)
        displayMan.move(magentaPickup,x,y)
        magentaPickup.myName = "magentaPickup"
        pickupStartSpawnCommon(magentaPickup)
    end

    local function spawnStartYellow()
        yellowPickup = displayMan.newRandomImageRect("Resources/Gfx/yellow.png", 50, 50)
        local x = display.contentCenterX - (display.contentCenterY * 0.19)
        local y = display.contentCenterY + (display.contentCenterY * 0.10)
        displayMan.move(yellowPickup,x,y)
        yellowPickup.myName = "yellowPickup"
        pickupStartSpawnCommon(yellowPickup)
    end
    
    local function spawnStartCyan()
        cyanPickup = displayMan.newRandomImageRect("Resources/Gfx/cyan.png", 50, 50)
        local x = display.contentCenterX + (display.contentCenterY * 0.19)
        local y = display.contentCenterY + (display.contentCenterY * 0.10)
        displayMan.move(cyanPickup,x,y)
        cyanPickup.myName = "cyanPickup"
        pickupStartSpawnCommon(cyanPickup)
    end

    -- THESE ARE FOR PICKUPS SPAWNING RANDOMLY IN THE GAME --

    local function pickupCollisions(self, event)
        if event.phase == "began" and event.other.myName == "player" then
            --timer needed as cant change collisions in collision event
            timer.performWithDelay(50, function() colourMan.setCommonColour(colourTable[self.myName], true) end)
			displayMan.remove(self)
		end
    end

    local function pickupSpawnCommon(pickup)
        pickup.isVisible = true
		physics.addBody(pickup, "static", {filter=pickupCollisionFilter})

        pickup.collision = pickupCollisions
        pickup:addEventListener("collision")

        local timer = timer.performWithDelay(10000, function() 
            pickup.isVisible = false
            displayMan.remove(pickup)
            table.remove(pickupDespawnTimerTable, 0) 
        end)
        table.insert(pickupDespawnTimerTable, timer)
        table.insert(pickupTable, pickup)
    end
    
    local function spawnBlue()
		bluePickup = displayMan.newRandomImageRect("Resources/Gfx/blue.png", 50, 50)
        bluePickup.myName = "bluePickup"
        pickupSpawnCommon(bluePickup)
	end
				
	local function spawnGreen()
		greenPickup = displayMan.newRandomImageRect("Resources/Gfx/green.png", 50, 50)
        greenPickup.myName = "greenPickup"
        pickupSpawnCommon(greenPickup)
	end
					
	local function spawnRed()
		redPickup = displayMan.newRandomImageRect("Resources/Gfx/red.png", 50, 50)
        redPickup.myName = "redPickup"
		pickupSpawnCommon(redPickup)
	end
			
	local function spawnMagenta()
		magentaPickup = displayMan.newRandomImageRect("Resources/Gfx/magenta.png", 50, 50)
        magentaPickup.myName = "magentaPickup"
        pickupSpawnCommon(magentaPickup)
    end

	local function spawnYellow()
		yellowPickup = displayMan.newRandomImageRect("Resources/Gfx/yellow.png", 50, 50)
        yellowPickup.myName = "yellowPickup"
        pickupSpawnCommon(yellowPickup)
	end

    local function spawnCyan()
		cyanPickup = displayMan.newRandomImageRect("Resources/Gfx/cyan.png", 50, 50)
        cyanPickup.myName = "cyanPickup"
        pickupSpawnCommon(cyanPickup)
	end
	
    function pickupFuncs.SpawnRandomPickup()
        local ranNum = math.random(1, 6)
        if (ranNum == 1) then
            spawnBlue()
        elseif (ranNum == 2) then
            spawnRed()
        elseif (ranNum == 3) then
            spawnGreen()
        elseif (ranNum == 4) then
            spawnMagenta()
        elseif (ranNum == 5) then
            spawnYellow()
        else spawnCyan()
        end
    end

    function pickupFuncs.Setup(callback)
        --Initially Spawn in All 6 colours --
        spawnStartBlue()
        spawnStartRed()
        spawnStartGreen()
        spawnStartMagenta()
        spawnStartYellow()
        spawnStartCyan()
        pickUpCallback = callback
        colourMan.addCallback(reloadAudio)
    end

    function pickupFuncs.Cleanup()
        audio.dispose(pickUpSound)
        pickUpSound = nil
        -- Unload All colours --
        displayMan.remove(bluePickup)
        displayMan.remove(greenPickup)
        displayMan.remove(redPickup)
        displayMan.remove(yellowPickup)
        displayMan.remove(magentaPickup)
        displayMan.remove(cyanPickup)
        bluePickup = nil
        greenPickup = nil
        redPickup = nil
        yellowPickup = nil
        magentaPickup = nil
        cyanPickup = nil
        for i,v in ipairs (pickupDespawnTimerTable) do
            timer.cancel(v)
            v = nil
        end
        pickupDespawnTimerTable = {}
        
        for i,v in ipairs (pickupTable) do
            v.isVisible = false
            displayMan.remove(v)  
            v = nil
        end
        pickupTable = {}
    end

    function pickupFuncs.pause()
        for i,v in ipairs (pickupDespawnTimerTable) do
            timer.pause(v)
        end
    end

    function pickupFuncs.resume()
        for i,v in ipairs (pickupDespawnTimerTable) do
            timer.resume(v)
        end
    end

return pickupFuncs