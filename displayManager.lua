--displayManager file is a common helper to be able to spawn things on the display, without them overlapping, etc
local managerFuncs = {} 
local displayGrid = {} --keep track of every x and y value that's used; probably not the most efficient but it'll do
local hasSetup = false

local gridHeight = display.contentHeight
local gridWidth = display.contentWidth

function managerFuncs.isPosUsed(row,col,w,h)
    r = math.floor(row) --for some reason obstacles become a float and have a decimal, breaking the array? this is a dirty fix for now
    c = math.floor(col)
    for i = r, (r+h), 1 do
        if (i < gridHeight and i > 0) then
            for j = c, (c+w), 1 do
                if (j < gridWidth and j > 0) then
                    if (displayGrid[i][j] == true) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function setPosCommon(row,col,w,h,used)
    r = math.floor(row) --make sure row and cols have no decimal for whatever reason
    c = math.floor(col)
    for i = r, (r+h), 1 do
        for j = c, (c+w), 1 do
            displayGrid[i][j] = used
        end
    end
end

function managerFuncs.setPosUsed(row,col,w,h)
    setPosCommon(row,col,w,h,true)
end
function managerFuncs.setPosUnused(row,col,w,h)
    setPosCommon(row,col,w,h,false)
end

--Returns an x and y coord that are currently not used (accounting for size given)
function managerFuncs.getRandomLocation(width, height)
    local tries = 0
    while (tries < 100) do
        local ranX = math.random(width, gridWidth-width)
        local ranY = math.random(height, gridHeight-height)

        if (not (managerFuncs.isPosUsed(ranY, ranX, width, height))) then
            managerFuncs.setPosUsed(ranY, ranX, width, height)
            return ranX, ranY --we can return multiple values in lua
        end
        tries = tries+1
    end
    return 0,0
end

function managerFuncs.Cleanup()
    for i = 1, gridHeight do
        for j = 1, gridWidth do
            displayGrid[i][j] = false
        end
        displayGrid[i] = nil
    end
    displayGrid = {}
end

function managerFuncs.Setup()
    if hasSetup == true then --dont setup more than once
        return
    end

    --Create 2D array for keeping track of every x and y used
    for i = 1, gridHeight do
        displayGrid[i] = {}
        for j = 1, gridWidth do
            displayGrid[i][j] = false
        end
    end
end

function managerFuncs.newRandomRect(width, height)
    local posX, posY = managerFuncs.getRandomLocation(width, height)
    local obj = display.newRect(posX, posY, width, height)
    --we add our own bool to the object to keep track of ones in the grid when wanting to remove later
    obj.isDisplayManaged = true
    --anchor = 0.0 means x=0 and y=0 is actually 0,0 on the display, as corona sets x and y as the middle of the rect
    obj.anchorX = 0.0
    obj.anchorY = 0.0
    return obj
end

function managerFuncs.newRandomImageRect(filename, width, height)
    local posX, posY = managerFuncs.getRandomLocation(width, height)
    local obj = display.newImageRect(filename, width, height)
    --we add our own bool to the object to keep track of ones in the grid when wanting to remove later
    obj.isDisplayManaged = true
    obj.myName = fileName
    obj.x = posX
    obj.y = posY
    --anchor = 0.0 means x=0 and y=0 is actually 0,0 on the display, as corona sets x and y as the middle of the rect
    obj.anchorX = 0.0
    obj.anchorY = 0.0
    return obj
end

function managerFuncs.newRandomPolygon(vertices)
    local width, height = 0,0

    for i,v in ipairs(vertices) do
        if math.mod(i,2) == 0 then --y coords
            if math.abs(v) > height then
                height = math.abs(v)
            end
        else --x coords
            if math.abs(v) > width then
                width = math.abs(v)
            end
        end
    end

    --print(string.format("W: %d, H: %d", width, height))

    local posX, posY = managerFuncs.getRandomLocation(width, height)
    local obj = display.newPolygon(posX, posY, vertices)
    --we add our own bool to the object to keep track of ones in the grid when wanting to remove later
    obj.isDisplayManaged = true
    obj.x = posX
    obj.y = posY
    --anchor = 0.0 means x=0 and y=0 is actually 0,0 on the display, as corona sets x and y as the middle of the rect
    obj.anchorX = 0.0
    obj.anchorY = 0.0
    return obj
end

function managerFuncs.remove(obj)
    if type(obj.isDisplayManaged) == "boolean" and obj.isDisplayManaged == true then
        if (managerFuncs.isPosUsed(obj.y, obj.x, obj.width, obj.height)) then
            managerFuncs.setPosUnused(obj.y, obj.x, obj.width, obj.height)
        end

        display.remove(obj)
        obj.isDisplayManaged = false --no longer display managed, we set this incase there's another reference to the object somewhere
        obj = nil

    elseif type(obj.isDisplayManaged) == "boolean" and obj.isDisplayManaged == false then
        obj = nil --set the object to nil since it has already been managed and this is a reference
    end
end

--useful for player and enemies moving
function managerFuncs.move(obj, x, y)
    if type(obj.isDisplayManaged) == "boolean" and obj.isDisplayManaged == true then
        if (managerFuncs.isPosUsed(obj.y, obj.x, obj.width, obj.height)) then
            managerFuncs.setPosUnused(obj.y, obj.x, obj.width, obj.height) -- need to set unused first and new coord may only be a few spaces
        end

        if (not (managerFuncs.isPosUsed(y, x, obj.width, obj.height))) then
            managerFuncs.setPosUsed(y, x, obj.width, obj.height)
        else
            managerFuncs.setPosUsed(obj.y, obj.x, obj.width, obj.height) --if we cant move, set the original space as used again
        end

        obj.x = x
        obj.y = y
    end
end

return managerFuncs