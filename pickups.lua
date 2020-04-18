
    local colourMan = require("colourManager")
    local displayMan = require("displayManager")

    local pickupFuncs = {}
    local pickupCollisionFilter = {categoryBits=4, maskBits=1}    --Pickups (4) collide with player (1)

    local soundTable = {
        ["bluePickup"] = audio.loadStream("Resources/Audio/Blue.wav"),
	    ["greenPickup"] = audio.loadStream("Resources/Audio/Requiem.mp3"),
	    ["redPickup"] = audio.loadStream("Resources/Audio/Red.wav"),
	    ["yellowPickup"] = audio.loadStream("Resources/Audio/Requiem.mp3"),
	    ["magentaPickup"] = audio.loadStream("Resources/Audio/Requiem.mp3"),
        ["cyanPickup"] = audio.loadStream("Resources/Audio/Requiem.mp3"),
    }

    local colourTable = {
        ["bluePickup"] = "Blue",
	    ["greenPickup"] = "Green",
	    ["redPickup"] = "Red",
	    ["yellowPickup"] = "Yellow",
	    ["magentaPickup"] = "Magenta",
        ["cyanPickup"] = "Cyan"
    }
    
    local pickUpSound = nil

    local bluePickup = nil
	local greenPickup = nil
	local redPickup = nil
	local yellowPickup = nil
	local magentaPickup = nil
    local cyanPickup = nil

    local pickupDespawnTimerTable = {}

    local function changeDisplayColour(colour)
        if (colour == "bluePickup") then
            display.setDefault("background", 128/255, 128/255, 255/255)
        
        elseif (colour == "greenPickup") then
            display.setDefault("background", 128/255, 255/255, 128/255)
        
        elseif (colour == "redPickup") then
            display.setDefault("background", 255/255, 128/255, 128/255)
        
        elseif (colour == "yellowPickup") then
            display.setDefault("background", 255/255, 255/255, 128/255)
        
        elseif (colour == "magentaPickup") then
            display.setDefault("background", 255/255, 128/255, 255/255)
        
        elseif (colour == "cyanPickup") then
            display.setDefault("background", 128/255, 255/255, 255/255)
        end
    end

    local function pickupCollisions(self, event)
        if event.phase == "began" and event.other.myName == "player" then
            audio.stop() --stop previous audio
            audio.play(pickUpSound) --sound played when you pickup something

            audio.play(soundTable[self.myName], {loops= -1, fadein = 500})
            --timer needed as cant change collisions in collision event
            timer.performWithDelay(50, function() colourMan.setCommonColour(colourTable[self.myName], true) end)
            changeDisplayColour(self.myName)
			displayMan.remove(self)
		end
    end

    local function pickupSpawnCommon(pickup)
        pickup.isVisible = true
		physics.addBody(pickup, "static", {filter=pickupCollisionFilter})

        pickup.collision = pickupCollisions
        pickup:addEventListener("collision")

        local timer = timer.performWithDelay(10000, function() 
            displayMan.remove(pickup)
            table.remove(pickupDespawnTimerTable, 0) 
        end)
        table.insert(pickupDespawnTimerTable, timer)
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

    function pickupFuncs.Setup()
        pickUpSound = audio.loadStream("Resources/Audio/switch.wav")
        --Initially Spawn in All 6 colours --
        spawnBlue()
        spawnRed()
        spawnGreen()
        spawnMagenta()
        spawnYellow()
        spawnCyan()
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
            table.remove(pickupDespawnTimerTable, i)
        end
        pickupDespawnTimerTable = {}
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