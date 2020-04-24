    local physics = require("physics")
    local player = require("player")
    local displayMan = require("displayManager")
    local colourMan = require("colourManager")
    local heartPickup = require("heartPickups")

    local enemyFuncs = {}
    local enemyCollisionFilter = {categoryBits=16, maskBits=43}  -- Enemies collide with 1 (player), 2 (obstacles), 8 (bullets), 32 (walls)
    local enbulletCollisionFilter = {categoryBits=8, maskBits=35}  -- Bullets collides only with 1 (player), 2 (obstacles), 32 (walls)

    local maxEnAmount = 12
    local enAmount = 0
    local enArray = {}
    local enBulletArray = {}
    local enbulletForce = 0.5 --bullet force ('speed') scale, make it small bit slower than player
    local enMoveSpeed = 2000 --In ms
    local heartSpawnRate = 20 --This is 1/heartSpawnRate (default is 1/20), rate increases with green

    local function getMoveSpeed()
        return enMoveSpeed
    end

    local function createEn1() -- Stationary beech
        local width, height = 50, 50
        local en = displayMan.newRandomImageRect("Resources/Gfx/static2.png", width, height)
        en.stroke = { 1, 1, 1 }
        en.strokeWidth = 4
        --local en = displayMan.newRandomRect(width, height)
        --en:setFillColor(0,0,0) --make enemy black
        physics.addBody(en, "static", {density = 1.0, friction = 0.0, bounce = 0.9, filter=enemyCollisionFilter})
        en.myName = "en1"
        en.lives = 3.0 --has 3 lives
        return en
    end

    local function createEn2() -- Suicide Bomber Beech (white Ghost thingz)
        local width, height = 32, 32
        local en = displayMan.newRandomImageRect("Resources/Gfx/ghost.png", width, height)
        --local en = displayMan.newRandomRect(width, height)
        en:setFillColor(1,1,1) --make enemy white
        physics.addBody(en, "static", {density = 1.0, friction = 0.0, bounce = 0.9, filter=enemyCollisionFilter})
        en.myName = "en2"
        en.lives = 1.5 --has 1.5 lives
        timer.performWithDelay(5000, function() 
            speed = getMoveSpeed()
            transition.to(en, {time=speed, alpha=1.0, transition=easing.outQuint, x=player.getX(), y=player.getY()} ) 
        end, -1)        
        
        return en
    end

    local function createEn3() -- Depression Demonz (triangle ones)        
        local vertices = {0,-110, 27,-35, -27,-35}
        
        local en = displayMan.newRandomPolygon(vertices)
        en.fill = { type="image", filename="Resources/Gfx/triangle.png" }
        en.stroke = { 0, 0, 0 }
        en.strokeWidth = 4
        physics.addBody(en, "static", {density = 1.0, friction = 0.0, bounce = 0.9, filter=enemyCollisionFilter})
        timer.performWithDelay(4000, function() 
            speed = getMoveSpeed()
            transition.to(en, {time=speed, alpha=1.0, transition=easing.inOutCirc, x=player.getX(), y=player.getY()} ) 
        end, -1)
        en.myName = "en3"
        en.lives = 2.0 --has 2.0 lives
        return en
    end

    local function shootAtPlayer(obj)
        if obj == nil or obj.isVisible == false or obj.myName == "en3" then --enemy 3 cant shoot
            return
        end

        local vecX = player.getX()-obj.x
        local vecY = player.getY()-obj.y
        local magnitude = math.sqrt((vecX*vecX)+(vecY*vecY))

        -- normalize vector f
        if (magnitude > 0) then
          vecX = vecX / magnitude
          vecY = vecY / magnitude
        end
        
        local bullet = display.newCircle(obj.x, obj.y, 8)
        if obj.myName == "en1" then
            bullet:setFillColor(0,0,0) --make enemy 1 bullets black
            bullet.stroke ={1,1,1}
        elseif obj.myName == "en2" then
            bullet:setFillColor(1,1,1) --make enemy 2 bullets white
            bullet.stroke ={0,0,0}
        end
        
        bullet.strokeWidth = 2
        physics.addBody(bullet, "dynamic", {friction=0.0, bounce=1.0, radius=8, filter=enbulletCollisionFilter})
        bullet.gravityScale = 0
        bullet.isBullet = true --needed for better collisions
        bullet:applyForce(vecX*enbulletForce, vecY*enbulletForce, bullet.x, bullet.y)
        bullet.myName = "enBullet"
        
        table.insert(enBulletArray, bullet)
        timer.performWithDelay(4000, function() display.remove(bullet) end) --remove bullet 4 seconds after shooting
    end
    
    local function enemyCollisions(self, event)
        if event.phase == "began" and (event.other.myName == "bullet") then --player bullet, not enemies own bullet
            self.lives = self.lives-player.getBulletDamage()
            event.other.isVisible = false --don't manually remove bullet as player stuff auto removes it using timer
            if self.lives <= 0 then
                local x,y = self.x, self.y
                if(math.random(1, heartSpawnRate) == 1) then
                    timer.performWithDelay(50, function() heartPickup.Spawn(x, y) end)
                end
                displayMan.remove(self)
                
                for index, v in ipairs (enArray) do 
                    if (v == self) then
                        table.remove(enArray, index)
                        enAmount = enAmount-1
                        break
                    end
                end
            end
        end     
    end

    --colour manager callback
    local function updaterCallback()
        if (colourMan.getColourString() == "Blue") then
            enbulletForce = 0.25 --We decrease enemy bullet speed when blue
        else
            enbulletForce = 0.5
        end

        if (colourMan.getColourString() == "Cyan") then
            enMoveSpeed = 4000 --We decrease enemy move speed when cyan
        else
            enMoveSpeed = 2000
        end

        if (colourMan.getColourString() == "Green") then
            heartSpawnRate = 10 --We decrease heart spawn rate when green
        else
            heartSpawnRate = 20
        end
    end

    local function enemies_SpawnCommon(variant)
        local en = nil
        if (variant == 1) then
            en = createEn1()
        elseif (variant == 2) then
            en = createEn2()
        else
            en = createEn3()
        end

        en.collision = enemyCollisions
        en:addEventListener("collision")

        enArray[enAmount] = en
        enAmount = enAmount+1
    end
    
    function enemyFuncs.SpawnRandom()
        if enAmount > maxEnAmount then
            return false
        end

        enemies_SpawnCommon(math.random(1, 3))
        return true
    end

    local function enemies_SpawnAll()
        while (enAmount < 4) do --spawn 4 enemies initially
            enemyFuncs.SpawnRandom() -- random rn, but do we want enemies to get harder as game progresses?
        end
    end
    
    local function enemies_RemoveAll()
        while (enAmount > 0) do
            displayMan.remove(enArray[enAmount-1])
            enArray[enAmount-1] = nil	
            enAmount = enAmount-1
        end
    end
    
    function enemyFuncs.Setup()
        enbulletForce = 0.5
        heartSpawnRate = 20
        enemies_RemoveAll()
        enemies_SpawnAll()
        colourMan.addCallback(updaterCallback) --add function to colour manager callbacks, which get called when we get a new colour
    end
    
    function enemyFuncs.Cleanup()
        enemies_RemoveAll()
        for i,v in ipairs (enBulletArray) do
            v.isVisible = false
            display.remove(v)  
            v = nil
        end
        enBulletArray = {}
    end

    function enemyFuncs.allShoot()
        for i,v in ipairs (enArray) do
            shootAtPlayer(v)
        end
    end

return enemyFuncs