--[[Used to load current level, next level and so on.
    Also handles destroying levels, drawing levels and
    returning spawn coordinates for the player.
    LevelList is used to load the correct level. Active level
    should be set to true. LevelInit table gets leveldata from
    the Levels file, this data is then asigned to the Blocks table.
    ]]--

require("Levels.Levels")

LevelHandler = {}

local Levels = Levels:getLevels()

Levelinit = {}
for i = 1, #Levels, 1 do
    Levelinit[i] = Levels[i]
end

World = 0
SpeedRun = false
local isPlaying = false
local leveldata
--Initializes all "blocks" (where each level stores data such as physics bodies, fixtures and shapes)--
function LevelHandler:initBlocks()
    blocks = {}
    for i = 0, 150, 1 do
        blocks[i] = {}
    end
end

function LevelHandler:loadLevels()
    if LevelList ~= nil then
        isPlaying = false
        LevelList = nil
    end
    LevelList = {}
    for i = 0, 100, 1 do
        LevelList[i] = {}
    end
    if World == 1 then
        LevelList[1] = true
    end
    if World == 2 then
        LevelList[6] = true
    end
    if World == 3 then
        LevelList[11] = true
    end
    if World == 4 then
        LevelList[16] = true
    end
    if World == 5 then
        LevelList[21] = true
    end
    if World == 6 then
        LevelList[26] = true
    end
    if World == 7 then
        LevelList[31] = true
    end
    if World == 8 then
        LevelList[36] = true
    end
    if World == 9 then
        LevelList[41] = true
    end
    if World == 10 then
        LevelList[42] = true
    end
    if World == 11 then
        LevelList[43] = true
    end
    if World == 12 then
        LevelList[44] = true
    end
    if World == 13 then
        LevelList[45] = true
    end
    if World == 14 then
        LevelList[46] = true
    end
    return LevelList
end
--Disposes of all the physics bodies, shapes and fixtures and destroys the physics world--
function LevelHandler:dispose()
    for i = 1, #blocks, 1 do
        if blocks[i].b ~= nil then
            blocks[i].b:destroy()
        end
    end
    blocks = nil
    w:destroy()
end
--Calls dispose function, sets current leveList value to false and the next one to true--
function LevelHandler:next()
    isPlaying = true
    LevelHandler:dispose()
    local matchFound = false
    for i = 0, #LevelList, 1 do
        if matchFound then
            matchFound = false
            LevelList[i] = true
            break
        end
        if LevelList[i] == true then
            LevelList[i] = false
            matchFound = true
        end
    end
    LevelHandler:loadCurrentLevel()
end

--Loads the level data and assigns data to the blocks
function LevelHandler:loadLevelData(leveldata)
    for i = 1, #leveldata, 1 do
        if type(leveldata[i][1]) == "number" then
            blocks[i].b = p.newBody(w, leveldata[i][1], leveldata[i][2], "static")
            blocks[i].s = p.newRectangleShape(leveldata[i][3], leveldata[i][4])
            blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
            blocks[i].f:setUserData("normal")
        elseif type(leveldata[i][1]) == "string" then
            blocks[i].b = p.newBody(w, leveldata[i][2], leveldata[i][3], "kinematic")
            if leveldata[i][1] == "spike" then
                blocks[i].s = p.newPolygonShape(leveldata[i][4])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("spike")
            elseif leveldata[i][1] == "goal" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("goal")
            elseif leveldata[i][1] == "secret" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("secret")
            else
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
            end
        end
    end
    currentSpawn = leveldata.spawn
    textboxLocation = leveldata.textboxLocation
    levelColor = leveldata.color
    bgLevelColor = leveldata.bgcolor
    if leveldata.levelType ~= nil then
        levelType = leveldata.levelType
    end
end
--Loads the current level depending on LevelList value--
function LevelHandler:loadCurrentLevel(secret)
    LevelHandler:initBlocks()
    p.setMeter(100)
    w = p.newWorld(0, 12.8*p.getMeter(), true)
    w:setCallbacks(beginContact, endContact)
    persisting = 0
    for i = 0, #LevelList, 1 do
        if LevelList[i] == true then
            if i == 6 then
                DataHandler:saveGame(2)
            end
            if i == 11 then
                DataHandler:saveGame(3)
            end
            if i == 16 then
                DataHandler:saveGame(4)
            end
            if i == 21 then
                DataHandler:saveGame(5)
            end
            if i == 26 then
                DataHandler:saveGame(6)
            end
            if i == 31 then
                DataHandler:saveGame(7)
            end
            if i == 36 then
                DataHandler:saveGame(8)
            end
            if i == 41 then
                DataHandler:saveGame(9)
            end
            if i == 42 then
                DataHandler:saveGame(10)
            end
            if i == 43 then
                DataHandler:saveGame(11)
            end
            if i == 44 then
                DataHandler:saveGame(12)
            end
            if i == 45 then
                DataHandler:saveGame(13)
            end
            if i == 46 then
                DataHandler:saveGame(14)
            end
            Player:initLives(SpeedRun)
            if secret ~= nil then
                leveldata = Levelinit[i].s
            else
                leveldata = Levelinit[i]
            end
            LevelHandler:loadLevelData(leveldata)
            Text:reset()
            Text:dialogSetup1("Lives:"..Player:checkLives())
            if secret ~= nil then
                Text:dialogSetup(Text:storylineSecret(Levelinit[i].s.num))
            else
                Text:dialogSetup(Text:storyline(i))
            end
            break
        end
    end
    Text:moveTo(LevelHandler:textboxLocation())
    if isPlaying == false then
        Player:init(LevelHandler:playerSpawnLocation())
    end
end
--Draws the level
function LevelHandler:drawLevel()
    g.setColor(LevelHandler:colors(2))
    g.rectangle("fill", -3000, -1200, 9280, 9020)
    g.setColor(LevelHandler:colors(1))
    for i = 1, #blocks, 1 do
        if blocks[i].b ~= nil then
            if blocks[i].f:getUserData() ~= nil then
                if blocks[i].f:getUserData() == "goal" then
                    g.setColor(1.0, 1.0, 1.0, 0.0)
                elseif blocks[i].f:getUserData() == "secret" then
                    g.setColor(1.0, 1.0, 1.0, 0.5)
                end
            end
            g.polygon("fill", blocks[i].b:getWorldPoints(blocks[i].s:getPoints()))
            g.setColor(LevelHandler:colors(1))
        end
    end
    for i = 1, 4, 1 do
        if levelType == "long" then
            g.rectangle("fill", Levels.borders2[i][1], Levels.borders2[i][2], Levels.borders2[i][3], Levels.borders2[i][4])
        elseif levelType == "high" then
            g.rectangle("fill", Levels.borders1[i][1], Levels.borders1[i][2], Levels.borders1[i][3], Levels.borders1[i][4])
        elseif levelType == "normal" then
            g.rectangle("fill", Levels.borders[i][1], Levels.borders[i][2], Levels.borders[i][3], Levels.borders[i][4])
        end
    end
end
--Returns spawn location depending on which level is active
function LevelHandler:playerSpawnLocation()
    local x, y
    x = leveldata.spawn[1]
    y = leveldata.spawn[2]
    return x, y
end

function LevelHandler:textboxLocation()
    local x, y
    x = leveldata.textboxLocation[1]
    y = leveldata.textboxLocation[2]
    return x, y
end

function LevelHandler:colors(colorChoice)
    local color, bgColor
    if leveldata ~= nil then
        color = leveldata.color
        bgColor = leveldata.bgcolor
        if colorChoice == 1 then
            return color
        elseif colorChoice == 2 then
            return bgColor
        end
    end
end

function LevelHandler:textboxColor()
    local color
    if leveldata ~= nil then
        color = leveldata.textboxColor
        return color
    end
end

--If leveldata contains .gravitychange then gravity can be changed
function LevelHandler:returnGravityChange()
    if leveldata.gravityChange ~= nil then
        return leveldata.gravityChange
    else
        return false
    end
end