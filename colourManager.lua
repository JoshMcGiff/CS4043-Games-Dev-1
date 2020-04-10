local colourFuncs = {} 
local curColour = "White"

local colourTable = {
    ["White"] = {1,1,1},
    ["Green"] = {0,1,0},
    ["Red"] = {1,0,0},
    ["Cyan"] = {0,1,1},
    ["Magenta"] = {1,0,1},
    ["Yellow"] = {1,1,0},
    ["Blue"] = {0,0,1},
}

--This table allows us to store functions (with no params) to call when we change colour, saving us from doing it manually for everything
local callbacks = {}
local callbackAmount = 1

--Returns a string with the current colour
function colourFuncs.getColourString()
    return curColour
end

--Returns a table with the current colour values
function colourFuncs.getColourValue()
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

return colourFuncs