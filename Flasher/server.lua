---@diagnostic disable: undefined-global, lowercase-global

-- =============== Variables ===============

local accSys = exports["[R]Accounts"]
local mickSys = exports["[R]Core"]
local notf = exports["[R]Notification"]
local DealerShip = exports["[R]DS"]

-- =============== Prices ===============
local prices = {
    [1] = {price = 1000},
    [2] = {price = 2000},
    [3] = {price = 3000},
    [4] = {price = 4000},
    [5] = {price = 5000}
}

-- =============== SQL-Events ===============

local db = nil

function createTableIfNotExists()
    local create = dbExec(db, [[
    CREATE TABLE IF NOT EXISTS flashers (
        pUserID INTEGER PRIMARY KEY,
        pFlasherID INTEGER NOT NULL,
        pFlasherDayLeft INTEGER NOT NULL
    );
    ]])

    if not create then
        outputDebugString("[Database]: ERROR not created table")
    else
        outputDebugString("[Database]: Created Flashers Table")
    end
end

function takeOneDayOff()
    dbExec(db, "UPDATE `flashers` SET pFlasherDayLeft = pFlasherDayLeft - 1 WHERE pFlasherDayLeft >= 1 AND pFlasherID > 0;")
    dbExec(db, "DELETE FROM `flashers` WHERE pFlasherDayLeft <= 0")
end

function connectDatabase()
    db = dbConnect("sqlite", "shopdb.sql")
    if db then
        outputDebugString("[Database]: Connected!")
        createTableIfNotExists()
        setTimer(takeOneDayOff, 86400000, 0)
    else
        outputDebugString("[Database]: ERROR: Check connection!!!")
    end
end
addEventHandler("onResourceStart", resourceRoot, connectDatabase)

-- =============== Flasher List Command ===============
addCommandHandler("flashlist", function(thePlayer)
    outputChatBox("#9B00FF========================Flasher-List========================", thePlayer, 255, 255 ,255, true)
    for i = 1, 5 do
        outputChatBox(string.format("#9B00FF [Flasher %d]: #4D006B cheshmak #FFFFFF %d Left %d Right #FFAE00 %d Gold", 
            i, i, i, prices[i].price), thePlayer, 255, 255, 255, true)
    end
    exports["notf"]:addNotification(thePlayer, "List")
end)

-- =============== Vehicle Light Flashers System ===============
local light = false

local function toggleLights(veh, lights)
    if light then
        for _, l in ipairs(lights) do
            setVehicleLightState(veh, l, 0)
        end
    else
        for _, l in ipairs(lights) do
            setVehicleLightState(veh, l, 1)
        end
    end
end

function flasherOne(veh)   toggleLights(veh, {0, 1}) end
function flasherTwo(veh)   toggleLights(veh, {2, 3}) end
function flasherThree(veh) toggleLights(veh, {0,1,2,3}) end
function flasherFour(veh)  toggleLights(veh, {0,2}) end
function flasherFive(veh)  toggleLights(veh, {1,3}) end

local funcs = {flasherOne, flasherTwo, flasherThree, flasherFour, flasherFive}
local index = 1

setTimer(function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        light = not light
        funcs[index](veh)
        index = index + 1
        if index > #funcs then index = 1 end
    end
end, 500, 0)

-- =============== Buy Flasher Command ===============

addCommandHandler("buyflasher", function(thePlayer, cmd, FlasherID)
    local acc = accSys:getPlayerAcc(thePlayer)
    if not acc then return end

    local pUserID = tonumber(getElementData(acc, "pID"))
    local fID = tonumber(FlasherID)
    if not fID or not prices[fID] then return end


    local query = dbQuery(db, "SELECT * FROM flashers WHERE pUserID = ?", pUserID)
    local result = dbPoll(query, -1)
    if #result > 0 then
        outputChatBox("You already own a flasher!", thePlayer, 255, 0, 0)
        return
    end


    local money_player = tonumber(getElementData(acc, "pCash")) or 0
    if money_player < prices[fID].price then
        outputChatBox("Not enough money!", thePlayer, 255, 0, 0)
        return
    end


    setElementData(acc, "pCash", money_player - prices[fID].price)
    dbExec(db, "INSERT INTO `flashers` (`pUserID`,`pFlasherID`,`pFlasherDayLeft`) VALUES (?, ?, 30)", pUserID, fID)

    outputChatBox("Flasher purchased successfully!", thePlayer, 0, 255, 0)
end)

-- =================== Vehicle Light Flashers System ===================

local light = false
local flasherEnabled = false
local flasherTimer = nil

local function toggleLights(veh, lights)
    if light then
        for _, l in ipairs(lights) do
            setVehicleLightState(veh, l, 0)
        end
    else
        for _, l in ipairs(lights) do
            setVehicleLightState(veh, l, 1)
        end
    end
end

function flasherOne(veh)   toggleLights(veh, {0, 1}) end
function flasherTwo(veh)   toggleLights(veh, {2, 3}) end
function flasherThree(veh) toggleLights(veh, {0,1,2,3}) end
function flasherFour(veh)  toggleLights(veh, {0,2}) end
function flasherFive(veh)  toggleLights(veh, {1,3}) end

local funcs = {flasherOne, flasherTwo, flasherThree, flasherFour, flasherFive}
local index = 1


addCommandHandler("onflasher", function(thePlayer)

    if flasherEnabled then return end

    flasherEnabled = true

    flasherTimer = setTimer(function()
        local veh = getPedOccupiedVehicle(thePlayer)
        if veh then
            light = not light
            funcs[index](veh)
            index = index + 1
            if index > #funcs then index = 1 end
        end
    end, 500, 0)

end)


addCommandHandler("offflasher", function(thePlayer)

    flasherEnabled = false

    if isTimer(flasherTimer) then
        killTimer(flasherTimer)
    end

    local veh = getPedOccupiedVehicle(thePlayer)
    if veh then

        for i = 0, 3 do
            setVehicleLightState(veh, i, 0)
        end
    end


end)
