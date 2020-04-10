	-----------------------------------------------------------------------------------------
	--
	-- main.lua
	--
	-----------------------------------------------------------------------------------------


	local physics = require("physics")
	physics.start()
	 
	 local colour = "White"
	local colourDisplay = display.newText( colour, display.contentCenterX, 20, native.systemFont, 40 )
	
	-- make it spawn one of these next few colours if it is not the current colour
	
	 local isBlue = false
	 local isGreen = false
	 local isRed = false
	 local isMagenta = false
	 local isYellow = false
	 local isCyan = false
	 local bluePickup = display.newRect(0,0,0,0)
	 bluePickup:setFillColor(0,0,0,0)
	 local greenPickup = display.newRect(0,0,0,0)
	 greenPickup:setFillColor(0,0,0,0)
	 local redPickup = display.newRect(0,0,0,0)
	 redPickup:setFillColor(0,0,0,0)
	 local yellowPickup = display.newRect(0,0,0,0)
	 yellowPickup:setFillColor(0,0,0,0)
	 local magentaPickup = display.newRect(0,0,0,0)
	 magentaPickup:setFillColor(0,0,0,0)
	 local cyanPickup = display.newRect(0,0,0,0)
	 cyanPickup:setFillColor(0,0,0,0)
	 local i = 1	
     gameLoopTimer = timer.performWithDelay( 500, spawnPickup, 0 )
     
	 local function spawnPickup()
	 while(i < 10) do
	  i = i + 1
	  
	  local ranX = math.random(0,1920)
	  local ranY = math.random(0, 1080)

			
			 local decision = math.random(0, 5)
				 
				if(decision == 0 and isBlue == false) then
				-- Blue pick-up
                 isBlue = true
                 isGreen = false
                 isRed = false
                 isMagenta = false
                 isYellow = false
                 isCyan = false
				bluePickup = display.newRect(ranX,ranY,40,40)
				physics.addBody(bluePickup, "static", {density=0.0})
				bluePickup.myName = "bluePickup"
				bluePickup:setFillColor(0,0,1)
				
				end
				
			if(decision == 1 and isGreen == false) then		
			-- Green pick-up
            isBlue = false
            isGreen = true
            isRed = false
            isMagenta = false
            isYellow = false
            isCyan = false
			greenPickup = display.newRect(ranX,ranY	,40,40)
			physics.addBody(greenPickup, "static", {density=0.0})
			greenPickup.myName = "greenPickup"
			greenPickup:setFillColor(0,1,0)
			end
			
			if(decision == 2 and isRed == false) then
			-- Red pick-up
            isBlue = false
            isGreen = false
            isRed = true
            isMagenta = false
            isYellow = false
            isCyan = false
			 redPickup = display.newRect(ranX,ranY,40,40)
			physics.addBody(redPickup, "static", {density=0.0})
			redPickup.myName = "redPickup"
			redPickup:setFillColor(1,0,0)
			end
			
			if(decision == 3 and isMagenta == false) then
			-- Magenta pick-up
			isBlue = false
            isGreen = false
            isRed = false
            isMagenta = true
            isYellow = false
            isCyan = false
			 magentaPickup = display.newRect(ranX,ranY,40,40)
			physics.addBody(magentaPickup, "static", {density=0.0})
			magentaPickup.myName = "magentaPickup"
			magentaPickup:setFillColor(1,0,1)
			end
			if(decision == 4 and isYellow == false) then
			-- Yellow pick-up
			isBlue = false
            isGreen = false
            isRed = false
            isMagenta = false
            isYellow = true
            isCyan = false
			 yellowPickup = display.newRect(ranX,ranY,40,40)
			physics.addBody(yellowPickup, "static", {density=0.0})
			yellowPickup.myName = "yellowPickup"
			yellowPickup:setFillColor(1,1,0)
			end
			if(decision == 5 and isCyan == false) then
			-- Cyan pick-up
			isBlue = false
            isGreen = false
            isRed = false
            isMagenta = false
            isYellow = false
            isCyan = true
			 cyanPickup = display.newRect(ranX,ranY,40,40)
			physics.addBody(cyanPickup, "static", {density=0.0})
			cyanPickup.myName = "cyanPickup"
			cyanPickup:setFillColor(0,1,1)
			end
        end		
end			
spawnPickup()
			--else i = i -1 
				
	
	-- char
	local sqr = display.newRect(200,200,20,20)
	sqr:setFillColor(150,150,150)
	physics.addBody(sqr, "dynamic", {density=0.0, friction=0.0, bounce=0.0})
	sqr.myName = "player"
	sqr.gravityScale = 0
    
		function bluePickup:collision( event)
		local phase, other = event.phase, event.other
		if phase == "began" and other.myName == "player" then
			display.remove(self)
			colourDisplay.text = "Blue"
			sqr:setFillColor(0,0,1)
			display.setDefault("background", 128/255, 128/255, 255/255)

			end
		end
		
		function greenPickup:collision( event)
		local phase, other = event.phase, event.other
		if phase == "began" and other.myName == "player" then
			display.remove(self)
			colourDisplay.text = "Green"
			sqr:setFillColor(0,1,0)
			display.setDefault("background", 128/255, 255/255, 128	/255)
			
			end
		end
		
		
		function redPickup:collision( event)
		local phase, other = event.phase, event.other
		if phase == "began" and other.myName == "player" then
			display.remove(self)
			colourDisplay.text = "Red"
			sqr:setFillColor(1,0,0)
			display.setDefault("background", 255/255, 128/255, 128/255)
			
			end
		end
		
		function magentaPickup:collision( event)
		local phase, other = event.phase, event.other
		if phase == "began" and other.myName == "player" then
			display.remove(self)
			colourDisplay.text = "Magenta"
			sqr:setFillColor(1,0,1)
			display.setDefault("background", 255/255, 128/255, 255/255)
			
			end
		end
		
		function yellowPickup:collision( event)
		local phase, other = event.phase, event.other
		if phase == "began" and other.myName == "player" then
			display.remove(self)
			colourDisplay.text = "Yellow"
			sqr:setFillColor(1,1,0)
			display.setDefault("background", 255/255, 255/255, 128/255)
			end
		end
		
		
		function cyanPickup:collision( event)
		local phase, other = event.phase, event.other
		if phase == "began" and other.myName == "player" then
			display.remove(self)
			colourDisplay.text = "Cyan"
			sqr:setFillColor(0,1,1)
			display.setDefault("background", 128/255, 255/255, 258/255)
			end
        end
        
        

	-- bullet
	local bllt = display.newRect(200,30,10,10)
	bllt:setFillColor(0,1,1)



	display.setDefault("background", 204/255,204/255,204/255)

	





	-- movement
	local upPressed = false
	local downPressed = false
	local leftPressed = false
	local rightPressed = false


	local function key( event)
		if (event.phase == "down") then
			if (event.keyName == "w") then
				upPressed = true
			elseif (event.keyName == "s") then
				downPressed = true
			elseif (event.keyName == "a") then
				leftPressed = true
			elseif (event.keyName == "d") then
				rightPressed = true
			end
		elseif (event.phase == "up") then
			if (event.keyName == "w") then
				upPressed = false
			elseif (event.keyName == "s") then
				downPressed = false
			elseif (event.keyName == "a") then
				leftPressed = false
			elseif (event.keyName == "d") then
				rightPressed = false
			end
		end

	end

	Runtime:addEventListener( "key", key)

	local function enterFrame(event )
		if (upPressed) then
			sqr.y = sqr.y - 6

		end
		if (downPressed) then
			sqr.y = sqr.y + 6

		end
		if (leftPressed) then
			sqr.x = sqr.x - 6

		end
		if (rightPressed) then
			sqr.x = sqr.x + 6

		end

	end

	Runtime:addEventListener( "enterFrame", enterFrame )
	-- Now the collectible stuff:


	bluePickup:addEventListener( "collision" )
	greenPickup:addEventListener( "collision" )
	redPickup:addEventListener( "collision" )
	magentaPickup:addEventListener( "collision" )
	yellowPickup:addEventListener( "collision" )
	cyanPickup:addEventListener( "collision" )

