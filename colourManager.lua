local colourFuncs = {} 
local curColour = "White"

local colourTable = {
    ["White"] = {1,1,1},
    ["Green"] = {0,1,0},
    ["Red"] = {1,0,0},
    ["Cyan"] = {0,1,1},
    ["Magenta"] = {1,0,1},
    ["Yellow"] = {1,1,0},
    ["Blue"] = {0,191/255,1},
}

local colourUsedTable = {
    ["White"] = false,
    ["Green"] = false,
    ["Red"] = false,
    ["Cyan"] = false,
    ["Magenta"] = false,
    ["Yellow"] = false,
    ["Blue"] = false,
}

--This table allows us to store functions (with no params) to call when we change colour, saving us from doing it manually for everything
local callbacks = {}
local callbackAmount = 1

--Returns a string with the current colour
function colourFuncs.getColourString()
    return curColour
end

function colourFuncs.validColour(colour)
    if (colour == "White" or colour == "Green") then
        return true
    elseif (colour == "Red" or colour == "Cyan") then
        return true
    elseif (colour == "Magenta" or colour == "Yellow" or colour == "Blue") then
        return true
    else
        return false
    end
end

function colourFuncs.achievement1()
    return colourUsedTable["Cyan"]
end
function colourFuncs.achievement2()
    return colourUsedTable["Red"]
end
function colourFuncs.achievement3()
    return colourUsedTable["Yellow"]
end

local function runCallbacks()
    amount = 1
    while (amount < callbackAmount) do
        local func = callbacks[amount]
        if (type(func) == "function") then
            func()
        end
        amount = amount+1
    end
end

function colourFuncs.setCommonColour(colour, runCBs)
    if (colourFuncs.validColour(colour)) then
        curColour = colour
        colourUsedTable[colour] = true
        if (runCBs == true) then
            runCallbacks()
        end
    else
        print(colour .. " is not a valid colour!")
    end
end

function colourFuncs.addCallback(func)
    if (type(func) == "function") then
        callbacks[callbackAmount] = func
        callbackAmount = callbackAmount+1
    end
end

--use to manually update the colour of objects such as player, obstacles, etc
function colourFuncs.updateObjColour(obj)
    local cl = colourTable[curColour]
    obj:setFillColor(cl[1], cl[2], cl[3])
end

function colourFuncs.Cleanup()
    while (callbackAmount > 0) do
        callbacks[callbackAmount-1] = nil	
        callbackAmount = callbackAmount-1
    end

    curColour = "White"
    callbackAmount = 1
    callbacks = {}
end

return colourFuncs