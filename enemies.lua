    local physics = require("physics")
    local player = require("player")

    local enemyFuncs = {}
    local enemyCollisionFilter = {categoryBits=16, maskBits=43}  -- Enemies collide with 1 (player), 2 (obstacles), 8 (bullets), 32 (walls)
    local enbulletCollisionFilter = {categoryBits=8, maskBits=35}  -- Bullets collides only with 1 (player), 2 (obstacles), 32 (walls)

    local enAmount = 0
    local enArray = {}
    local enbulletForce = 0.5 --bullet force ('speed') scale, make it small bit slower than player

    local function createEn1()
        local en = display.newRect(math.random(250,1900), math.random(200,1000), 50, 50)
        en:setFillColor(0,0,0) --make enemy black
        physics.addBody(en, "static", {density = 1.0, friction = 0.5, bounce = 0.8, filter=enemyCollisionFilter})
        en.myName = "en1"
        return en
    end

    local function createEn2()
        return createEn1() --for now
    end

    local function createEn3()
        return createEn1() --for now
    end

    local function shootAtPlayer(obj)
        if obj == nil or obj.isVisible == false then
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
        bullet:setFillColor(0,0,0) --make enemy bullets black

        physics.addBody(bullet, "dynamic", {friction=0.5, bounce=1.0, radius=8, filter=enbulletCollisionFilter})
        bullet.gravityScale = 0
        bullet.isBullet = true --needed for better collisions
        bullet:applyForce(vecX*enbulletForce, vecY*enbulletForce, bullet.x, bullet.y)
        bullet.myName = "enBullet"

        timer.performWithDelay(10000, function() display.remove(bullet) end) --remove bullet 10 seconds after shooting
    end

    local function enemyCollisions(self, event)
        if event.phase == "began" and (event.other.myName == "bullet") then --player bullet, not enemies own bullet
            display.remove(self)
            event.other.isVisible = false --don't manually remove bullet as player stuff auto removes it using timer

            for index, v in ipairs (enArray) do 
                if (v == self) then
                    table.remove(enArray, index)
                    enAmount = enAmount-1
                    break
                end
            end
		end
    end

    local function enemies_SpawnAll()
        while (enAmount < 6) do --spawn 8 enemies
            local ranNum = math.random(1, 3) --pick random enemy between 3 (we only have 1 rn)
            local en = nil

            if (ranNum == 1) then
                en = createEn1()
            elseif (ranNum == 2) then
                en = createEn2()
            else
                en = createEn3()
            end

            en.collision = enemyCollisions
            en:addEventListener("collision")

            enArray[enAmount] = en
            enAmount = enAmount+1
        end
    end
    
    local function enemies_RemoveAll()
        while (enAmount > 0) do
            display.remove(enArray[enAmount-1])
            enArray[enAmount-1] = nil	
            enAmount = enAmount-1
        end
    end
    
    function enemyFuncs.Setup()
        enemies_RemoveAll()
        enemies_SpawnAll()

        timer.performWithDelay(5000, function() --every 5 seconds make all enemies shoot at player (can implement staggering or something later)
            for i,v in ipairs (enArray) do
                shootAtPlayer(v)
            end
        end, -1)
    end

return enemyFuncs