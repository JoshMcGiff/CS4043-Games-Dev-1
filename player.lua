    
    local colourMan = require("colourManager")
    
    local playerFuncs = {}
    local playerCollisionFilter = {categoryBits=1, maskBits=38}  -- Player collides only with 2 (obstacles), 4 (pickups) and 32 (walls)
    local bulletCollisionFilter = {categoryBits=8, maskBits=50}  -- Bullets collides only with 2 (obstacles), 16 (enemies) and 32 (walls)
    local playerGroup = display.newGroup()

    --Player Movement
    local upPressed = false
    local downPressed = false
    local leftPressed = false
    local rightPressed = false

    --Player Directional Bullets: 0 = not shot, 1 = waiting to get shot, 2 = has been shot and waiting for key to be released
    local bulletForce = 1.5 --bullet force ('speed') scale
    local upBullet = 0
    local downBullet = 0
    local leftBullet = 0
    local rightBullet = 0

    
    local player_front = nil
    local player_back = nil
    local player_left = nil
    local player_right = nil
    local lives = 3

    local function updateImage(curImage)
        player_front.isVisible = false
        player_back.isVisible = false
        player_left.isVisible = false
        player_right.isVisible = false

        if curImage == 1 then
            player_front.isVisible = true
        elseif curImage == 2 then
            player_left.isVisible = true
        elseif curImage == 3 then
            player_right.isVisible = true
        else 
            player_back.isVisible = true
        end
    end

    --Common function that sets up and spawns player bullet
    local function player_bulletCommon(xForce, yForce)
        local bullet = display.newCircle(playerFuncs.getX(), playerFuncs.getY(), 10)
        colourMan.updateObjColour(bullet) --make bullet same colour as player and world

        physics.addBody(bullet, "dynamic", {friction=0.5, bounce=1.0, radius=10, filter=bulletCollisionFilter})
        bullet.gravityScale = 0
        bullet.isBullet = true --needed for better collisions
        bullet:applyForce(xForce, yForce, bullet.x, bullet.y)
        bullet.myName = "bullet"

        timer.performWithDelay(5000, function() display.remove(bullet) end) --remove bullet 5 seconds after shooting
    end

    --Bullet spawn based on mouse click
    local function player_mouseBullet(event)
        if (event.phase == "ended") then
            if (event.x >= 0 and event.x <= display.contentWidth and event.y >= 0 and event.y <= display.contentHeight) then
                --Make the bullet always have same force applied using vector mAgIc (thanks Stephen Maguire and google xoxo)
                local vecX = event.x-playerFuncs.getX()
                local vecY = event.y-playerFuncs.getY()
                local magnitude = math.sqrt((vecX*vecX)+(vecY*vecY))

                -- normalize vector f
                if (magnitude > 0) then
                  vecX = vecX / magnitude
                  vecY = vecY / magnitude
                end

                player_bulletCommon(vecX*bulletForce, vecY*bulletForce)
            end
        end
        return true  -- Prevents tap/touch propagation to underlying objects
    end

    local function player_DirectionalBullet(event)
        if (event.phase == "down") then
            if (event.keyName == "up") then
                upBullet = 1
            elseif (event.keyName == "down") then
                downBullet = 1
            elseif (event.keyName == "left") then
                leftBullet = 1
            elseif (event.keyName == "right") then
                rightBullet = 1
            end

        elseif (event.phase == "up") then
            if (event.keyName == "up") then
                upBullet = 0
            elseif (event.keyName == "down") then
                downBullet = 0
            elseif (event.keyName == "left") then
                leftBullet = 0
            elseif (event.keyName == "right") then
                rightBullet = 0
            end
        end
    end
 
    local function player_bulletEnterFrame(event)
        if (upBullet == 1) then
            player_bulletCommon(0, -bulletForce)
            upBullet = 2
        elseif (downBullet == 1) then
            player_bulletCommon(0, bulletForce)
            downBullet = 2
        elseif (leftBullet == 1) then
            player_bulletCommon(-bulletForce, 0)
            leftBullet = 2
        elseif (rightBullet == 1) then
            player_bulletCommon(bulletForce, 0)
            rightBullet = 2
        end
    end

    local function player_Move(event)
        if (event.phase == "down") then
            if (event.keyName == "w") then
                upPressed = true
                updateImage(0)
            elseif (event.keyName == "s") then
                downPressed = true
                updateImage(1)
            elseif (event.keyName == "a") then
                leftPressed = true
                updateImage(2)
            elseif (event.keyName == "d") then
                rightPressed = true
                updateImage(3)
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

    local function player_moveEnterFrame(event)
        local moveAmount = 8 --This is player speed
        if (upPressed) then
            playerFuncs.setY(player_front.y - moveAmount)
        end
        if (downPressed) then
            playerFuncs.setY(player_front.y + moveAmount)
        end
        if (leftPressed) then
            playerFuncs.setX(player_front.x - moveAmount)
        end
        if (rightPressed) then
            playerFuncs.setX(player_front.x + moveAmount)
        end
    end
      
    local function updateColour()
        colourMan.updateObjColour(player_front)
        colourMan.updateObjColour(player_back)
        colourMan.updateObjColour(player_left)
        colourMan.updateObjColour(player_right)
        player_left:toFront()
        player_right:toFront()
        player_back:toFront()
        player_front:toFront()
    end

    local function setupPlayerCommon(player, vis)
        player.x = display.contentCenterX
        player.y = display.contentCenterY
        player.isVisible = vis
        player:setFillColor(1,1,1)
        player.myName = "player"
        physics.addBody(player, "dynamic", {filter=playerCollisionFilter})
        player.isFixedRotation = true
        player.gravityScale = 0
    end

    function playerFuncs.setupPlayer()
        player_front = display.newImageRect(playerGroup, "Resources/Gfx/player_front.png", 56, 95)
        player_back = display.newImageRect(playerGroup, "Resources/Gfx/player_back.png", 56, 95)
        player_left = display.newImageRect(playerGroup, "Resources/Gfx/player_left.png", 43, 95)
        player_right = display.newImageRect(playerGroup, "Resources/Gfx/player_right.png", 43, 95)
        setupPlayerCommon(player_front, true)
        setupPlayerCommon(player_back, false)
        setupPlayerCommon(player_left, false)
        setupPlayerCommon(player_right, false)

        Runtime:addEventListener("key", player_Move)
        Runtime:addEventListener("enterFrame", player_moveEnterFrame)
        Runtime:addEventListener("key", player_DirectionalBullet)
        Runtime:addEventListener("enterFrame", player_bulletEnterFrame)
        Runtime:addEventListener("touch", player_mouseBullet)
        colourMan.addCallback(updateColour)
    end

    function playerFuncs.setX(x)
        player_front.x = x
        player_back.x = x
        player_left.x = x
        player_right.x = x
    end

    function playerFuncs.setY(y)
        player_front.y = y
        player_back.y = y
        player_left.y = y
        player_right.y = y
    end

    function playerFuncs.getX()
        return player_front.x 
    end

    function playerFuncs.getY()
        return player_front.y
    end

    function playerFuncs.getLives()
        return lives
    end

    function playerFuncs.take1Life()
        lives = lives-1
        return (lives == 0) --return out of lives
    end


return playerFuncs