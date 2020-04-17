
    local colourMan = require("colourManager")
    local displayMan = require("displayManager")

    local pickupFuncs = {}
    local pickupCollisionFilter = {categoryBits=4, maskBits=1}    --Pickups (4) collide with player (1)

    local soundTable = {
        ["bluePickup"] = audio.loadStream("Resources/Audio/Magenta.wav"),
	    ["greenPickup"] = audio.loadStream("Resources/Audio/Requiem.mp3"),
	    ["redPickup"] = audio.loadStream("Resources/Audio/out.wav"),
	    ["yellowPickup"] = audio.loadStream("Resources/Audio/out.wav"),
	    ["magentaPickup"] = audio.loadStream("Resources/Audio/Magenta.wav"),
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
            display.setDefault("background", 128/255, 255/255, 258/255)
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

        timer.performWithDelay(10000, function() displayMan.remove(pickup) end)
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

return pickupFuncs