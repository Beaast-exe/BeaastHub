local placeId = 17334984034
if game.placeId ~= placeId then return end
repeat task.wait() until game:IsLoaded()
if not game:IsLoaded() then game.Loaded:Wait() end
local StartTick = tick()
--task.wait(3)

local Players = game:GetService('Players')
local player = Players.LocalPlayer
local character = player.Character
local PlayerGui = player.PlayerGui

repeat task.wait() until player.Character and player.Character:FindFirstChild('HumanoidRootPart')

local HttpService = game:GetService('HttpService')
local repo = 'https://raw.githubusercontent.com/Beaast-exe/BeaastHub/master/libs/LinoriaLib/' -- BEAAST HUB LINORIA
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Beaast Hub | Anime Kingdom Simulator', Center = true, AutoShow = true })
local Tabs = {
	['Main'] = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings')
}

local saveFolderName = 'BeaastHub'
local gameFolderName = 'AnimeKingdom'
local saveFileName = game:GetService('Players').LocalPlayer.Name .. '.json'
local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

local defaultSettings = {
    ['AutoFarm'] = {
        ['Enabled'] = false,
        ['PetStats'] = false,
        ['TeleportToEnemies'] = false,
        ['TeleportPetsToEnemies'] = false,
        ['AutoClick'] = false,

        ['World'] = 'Slayer Town',
        ['Enemies'] = {'Gyutaro'}
    },
    ['AutoRaid'] = {
        ['Enabled'] = false,
        ['World'] = 'Slayer Town'
    },
    ['AutoDungeon'] = {
        ['Enabled'] = false,
        ['Difficulty'] = 'Easy'
    },
    ['AutoDefense'] = {
        ['Enabled'] = false
    },
    ['AutoStar'] = {
        ['Enabled'] = false,
        ['SelectedStar'] = 'Slayer Star'
    },
    ['Misc'] = {
        ['Mount'] = false,
        ['BackPosition'] = nil,
        ['BackWorld'] = "1",
        ['TeleportBack'] = false
    },
    ['Keybinds'] = {
		['menuKeybind'] = 'LeftShift'
	},
	watermark = false
}

if not isfolder(saveFolderName) then makefolder(saveFolderName) end
if not isfolder(saveFolderName .. '/' .. gameFolderName) then makefolder(saveFolderName .. '/' .. gameFolderName) end
if not isfile(saveFile) then writefile(saveFile, HttpService:JSONEncode(defaultSettings)) end

local settings = HttpService:JSONDecode(readfile(saveFile))
local function SaveConfig()
	writefile(saveFile, HttpService:JSONEncode(settings))
end

local function walkTable(path, table)
    for i, v in pairs(table) do
        path[i] = path[i] or v
        SaveConfig()

        if type(v) == 'table' then
            walkTable(path[i], v)
        end
    end
end

walkTable(settings, defaultSettings)
SaveConfig()

-- // VARIABLES
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService('Workspace')
local VirtualUser = game:GetService('VirtualUser')
local VirtualInputManager = game:GetService('VirtualInputManager')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local TeleportService = game:GetService('TeleportService')

local ffrostflame_bridgenet2 = ReplicatedStorage:FindFirstChild("ffrostflame_bridgenet2@1.0.0")
local dataRemoteEvent = ffrostflame_bridgenet2:FindFirstChild("dataRemoteEvent")

local ScriptLibrary = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
local passiveStats = require(ReplicatedStorage.Framework.Modules.Data.PassiveData)

local playerMap = "1"
local playerMode = nil

local worldsNames = {
    "Slayer Town",
	"Giant District",
	"ABC City",
	"Cursed School",
    "Leveling Town",
    "Sand Empire",
    "Bizarre Desert",
    "Z Hills",
    "Ninja Village"
}

local dungeonDifficulties = {
    "Easy",
    "Medium",
    "Hard",
    "Insane",
    "Extreme",
    "Impossible"
}

local worldsTable = {
    ["Slayer Town"] = "1",
	["Giant District"] = "2",
	["ABC City"] = "3",
	["Cursed School"] = "4",
    ["Leveling Town"] = "5",
    ["Sand Empire"] = "6",
    ["Bizarre Desert"] = "7",
    ["Z Hills"] = "8",
    ["Ninja Village"] = "9"
}

local worldsTableNumbers = {
    ["Slayer Town"] = 1,
	["Giant District"] = 2,
	["ABC City"] = 3,
	["Cursed School"] = 4,
    ["Leveling Town"] = 5,
    ["Sand Empire"] = 6,
    ["Bizarre Desert"] = 7,
    ["Z Hills"] = 8,
    ["Ninja Village"] = 9
}

local numbersToWorlds = {
    [1] = "Slayer Town",
    [2] = "Giant District",
    [3] = "ABC City",
    [4] = "Cursed School",
    [5] = "Leveling Town",
    [6] = "Sand Empire",
    [7] = "Bizarre Desert",
    [8] = "Z Hills",
    [9] = "Ninja Village"
}

local stars = {
    'Slayer Star',
    'Titan Star',
    'Punch Star',
    'Cursed Star',
    'Player Star',
    'Pirate Star',
    'Bizarre Star',
    'Z Star',
    'Ninja Star'
}

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        PlayerGui:FindFirstChild('Transition').Enabled = false
        playerMap = tostring(ScriptLibrary.PlayerData.CurrentMap)
        playerMode = player:GetAttribute('Mode') or nil
    end
end)

local function getTime(time)
    if time >= -999999 and time < 60 then
        return ("%02is"):format(time % 60)
    elseif time > 59 and time < 3600 then
        return ("%02im %02is"):format(time / 60 % 60, time % 60)
    elseif time > 3599 and time < 86399 then
        return ("%02ih %02im"):format(time / 3600 % 24, time / 60 % 60)
    else
        return ("%02id %02ih"):format(time / 86400, time / 3600 % 24)
    end
end

function stringToCFrame(string)
    return CFrame.new(table.unpack(string:gsub(' ', ''):split(',')))
end

function teleportToWorld(world, cframe)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    dataRemoteEvent:FireServer(unpack({{{"TeleportSystem", "To", tonumber(world), n = 3}, "\002"}}))
    task.wait(1)
    hrp.CFrame = cframe
end

local function checkDungeon()
    local In_Doing = nil
    local pgui = player:FindFirstChild('PlayerGui')
    if pgui then
        local Mode = pgui:FindFirstChild('Mode')
        if Mode then
            local Content = Mode:FindFirstChild("Content")
            if Content then 
                for i,v in ipairs(Content:GetChildren()) do
                    if v:IsA('Frame') and v.Visible then
                        In_Doing = v
                    end
                end
            end
        end
    end

    return In_Doing
end

local function checkEnemy()
    local enemyFolder = nil

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']:GetChildren()) do
        if folder:IsA('Folder') and (folder.Name == 'Dungeon' or folder.Name == 'Raid' or folder.Name == 'Defense') then
            for _, v in pairs(folder:GetChildren()) do
                if v:IsA('Folder') and v.Name == tostring(player.UserId) and #v:GetChildren() > 0 then
                    enemyFolder = v
                end
            end
        end
    end

    return enemyFolder
end

local function checkEnemyInMap(map)
    local enemyFolder = nil

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']:GetChildren()) do
        if folder:IsA('Folder') and folder.Name == map then
            for _, v in pairs(folder:GetChildren()) do
                if v:IsA('Folder') and v.Name == tostring(player.UserId) and #v:GetChildren() > 0 then
                    enemyFolder = v
                end
            end
        end
    end

    return enemyFolder
end

local function getEnemy()
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local distance = math.huge
    local enemy = nil

    for _, enemyFolder in ipairs(Workspace['_ENEMIES']['Server']:GetChildren()) do
        if enemyFolder:IsA("Folder") then
            local targetFolder = checkEnemy()
            if targetFolder then
                enemyFolder = targetFolder
            end

            for _, v in ipairs(enemyFolder:GetChildren()) do
                local HP = v:GetAttribute('HP')
                local Shield = v:GetAttribute('Shield')

                if HP and HP > 0 and Shield ~= true then
                    if v:IsA('Part') then
                        local magnitude = (HumanoidRootPart.Position - v.Position).magnitude

                        if magnitude < distance then
                            distance = magnitude
                            enemy = v
                        end
                    end
                end
            end
        end
    end

    return enemy
end

local function getEnemyInMap(map)
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local distance = math.huge
    local enemy = nil

    for _, enemyFolder in ipairs(Workspace['_ENEMIES']['Server']:GetChildren()) do
        if enemyFolder:IsA("Folder") then
            local targetFolder = checkEnemyInMap(map)
            if targetFolder then
                for _, v in ipairs(targetFolder:GetChildren()) do
                    local HP = v:GetAttribute('HP')
                    local Shield = v:GetAttribute('Shield')
    
                    if HP and HP > 0 and Shield ~= true then
                        if v:IsA('Part') then
                            local magnitude = (HumanoidRootPart.Position - v.Position).magnitude
    
                            if magnitude < distance then
                                distance = magnitude
                                enemy = v
                            end
                        end
                    end
                end
            end
        end
    end

    return enemy
end

local function equipTeam(id)
    dataRemoteEvent:FireServer(unpack({{{"PetSystem","EquipTeam",tostring(ID),["n"] = 3},"\2"}}))
end

local function retreat()
    dataRemoteEvent:FireServer(unpack({{{"PetSystem", "Retreat", n = 2}, "\2"}}))
end

local function attack()
    dataRemoteEvent:FireServer(unpack({{{"PetSystem", "Attack", tostring(getEnemy()), true, n = 133}, "\2"}}))
end

local function disableEffects()
    local whitelist = {'Damage', 'Hit'}

    for i, v in ipairs(Workspace['_IGNORE']:GetChildren()) do
        if v:IsA('Model') or v:IsA('Part') then
            if table.find(whitelist, v.Name) then
                v:Destroy()
            end
        end
    end
end

local function setPetsStats()
    for i, v in ipairs(Workspace['_PETS'][player.UserId]:GetChildren()) do
        v:SetAttribute('WalkSPD', 150)
    end
end

local function teleportToEnemy()
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local enemy = getEnemy()
    if enemy then
        HumanoidRootPart.CFrame = enemy.CFrame * CFrame.new(0, 3, 5)
    end
end

local function teleportToEnemyInMap(map)
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local enemy = getEnemyInMap(map)
    if enemy then
        HumanoidRootPart.CFrame = enemy.CFrame * CFrame.new(0, 3, 5)
    end
end

local function sendPetsToEnemy()
    local enemy = getEnemy()
    if not enemy then return end

    for _, folder in ipairs(Workspace['_PETS']:GetChildren()) do
        if folder:IsA('Folder') then
            if folder.Name == tostring(player.UserId) then
                for __, pets in ipairs(folder:GetChildren()) do
                    for i, v in ipairs(pets:GetChildren()) do
                        if v:IsA('Model') then
                            local target = v:FindFirstChild('HumanoidRootPart')

                            if target and enemy then
                                local magnitude = (target.Position - enemy.Position).magnitude

                                if magnitude > 15 and magnitude < 70 then
                                    target.CFrame = enemy.CFrame
                                end
                            end
                        end
                    end
                end
            end
        end

        for i, v in ipairs(Workspace['_IGNORE']['ShinyModels']:GetChildren()) do
            if v:IsA('Model') then
                local target = v:FindFirstChild('HumanoidRootPart')
                if target and enemy then
                    local magnitude = (target.Position - enemy.Position).magnitude

                    if magnitude > 15 and magnitude < 70 then
                        target.CFrame = enemy.CFrame
                    end
                end
            end
        end
    end
end

local function setupAttack()
    for i = 1, settings['AutoFarm']['Enabled'] do
        attack()
        task.wait()
    end

    task.wait(0.25)
end

local function getCurrentWorld()
    local world = nil
    local map = Workspace['_MAP']

    if map then
        for i, v in ipairs(map:GetChildren()) do
            if v:IsA('Folder') then
                local spawn = v:FindFirstChild('Spawn')
                local another = v:FindFirstChild(player.UserId)

                if spawn then
                    world = tostring(v)
                elseif another then
                    local spawn2 = another:FindFirstChild('Spawn')

                    if spawn2 then
                        world = tostring(v)
                    end
                end
            end
        end
    end

    return world
end

local function inDungeon()
    local currentWorld = getCurrentWorld()

    if currentWorld == 'Dungeon' then
        return true
    else
        return false    
    end
end

local function inRaid()
    local currentWorld = getCurrentWorld()

    if currentWorld == 'Raid' then
        return true
    else
        return false    
    end
end

local function inDefense()
    local currentWorld = getCurrentWorld()

    if currentWorld == 'Defense' then
        return true
    else
        return false    
    end
end

local function getDungeonCooldown()
    local DungeonDelay = ScriptLibrary.PlayerData.DungeonDelay
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < DungeonDelay then
            return true
        else
            return false
        end
end

local function createDungeon(difficulty)
    dataRemoteEvent:FireServer(unpack({{{"DungeonSystem", "Create", n = 2}, "\2"}}))
    dataRemoteEvent:FireServer(unpack({{{"DungeonSystem", "SelectMap", "RuinedPrison", n = 3}, "\2"}}))
    dataRemoteEvent:FireServer(unpack({{{"DungeonSystem", "SelectDiff", difficulty, n = 3}, "\2"}}))
    dataRemoteEvent:FireServer(unpack({{{"DungeonSystem", "Start", n = 2}, "\2"}}))
end

local function startDungeon(difficulty)
    if getDungeonCooldown() then return end
    if playerMode == nil then
        createDungeon(difficulty)
        task.wait(5)
    elseif checkDungeon() == 'Dungeon' or playerMode == 'Dungeon' then
        if inDungeon() then
            teleportToEnemyInMap('Dungeon')
            sendPetsToEnemy()
            task.wait(0.1)
        end
    end
end

local function getDefenseCooldown()
    local DefenseDelay = ScriptLibrary.PlayerData.DefenseDelay
    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < DefenseDelay then
        return true
    else
        return false
    end
end

local function createDefense()    
    dataRemoteEvent:FireServer(unpack({{{"DefenseSystem", "Create", "AlienPlanet", n = 3}, "\002"}}))
    dataRemoteEvent:FireServer(unpack({{{"DefenseSystem", "Start", n = 2}, "\2"}}))
end

local function startDefense()
    if getDefenseCooldown() then return end
    if playerMode == nil then
        createDefense()
        task.wait(5)
    elseif checkDungeon() == 'Defense' or playerMode == 'Defense' then
        if inDefense() then
            teleportToEnemyInMap('Defense')
            sendPetsToEnemy()
            task.wait(0.1)
        end
    end
end

local function clickDamage()
    dataRemoteEvent:FireServer(unpack({{{"PetSystem", "Click", n = 2}, "\2"}}))
end

local function getRaidCooldown()
    local RaidDelay = ScriptLibrary.PlayerData.RaidDelay
    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < RaidDelay then
        return true
    else
        return false
    end
end

local function createRaid(mapNumber)
    dataRemoteEvent:FireServer(unpack({{{"RaidSystem", "Create", n = 2}, "\2"}}))
    dataRemoteEvent:FireServer(unpack({{{"RaidSystem", "SelectMap", mapNumber, n = 3}, "\2"}}))
    dataRemoteEvent:FireServer(unpack({{{"RaidSystem", "Start", n = 2}, "\2"}}))
end

local function startRaid(mapNumber)
    if getRaidCooldown() then return end

    if playerMode == nil then
        createRaid(mapNumber)
        task.wait(5)
    elseif checkDungeon() == 'Raid' or playerMode == 'Raid' then
        if inRaid() then
            teleportToEnemyInMap('Raid')
            sendPetsToEnemy()
            task.wait(0.1)
        end
    end
end

local AutoFarm = Tabs['Main']:AddLeftGroupbox('Auto Farm')
AutoFarm:AddToggle('enableAutoFarm', {
    Text = 'Enable Auto AutoFarm',
    Default = settings['AutoFarm']['Enabled'],

    Callback = function(value)
        settings['AutoFarm']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoFarm']['Enabled'] then
            attack()
        end
    end
end)

AutoFarm:AddToggle('enablePetStats', {
    Text = 'Boost Pets Speed (Need Re-equip)',
    Default = settings['AutoFarm']['PetStats'],

    Callback = function(value)
        settings['AutoFarm']['PetStats'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoFarm']['PetStats'] then
            setPetsStats()
        end
    end
end)

AutoFarm:AddToggle('enableTeleportToEnemies', {
    Text = 'Teleport to Closest Enemies',
    Default = settings['AutoFarm']['TeleportToEnemies'],

    Callback = function(value)
        settings['AutoFarm']['TeleportToEnemies'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.25) and not Library.Unloaded do
        if settings['AutoFarm']['TeleportToEnemies'] then
            teleportToEnemy()
        end
    end
end)

AutoFarm:AddToggle('enablePetsTeleport', {
    Text = 'Teleport Pets to Closest Enemies',
    Default = settings['AutoFarm']['TeleportPetsToEnemies'],

    Callback = function(value)
        settings['AutoFarm']['TeleportPetsToEnemies'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoFarm']['TeleportPetsToEnemies'] then
            sendPetsToEnemy()
        end
    end
end)

AutoFarm:AddToggle('enableAutoClick', {
    Text = 'Enable Auto Click',
    Default = settings['AutoFarm']['AutoClick'],

    Callback = function(value)
        settings['AutoFarm']['AutoClick'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoFarm']['AutoClick'] then
            clickDamage()
        end
    end
end)

local AutoRaid = Tabs['Main']:AddRightGroupbox('Auto Raid')

AutoRaid:AddDropdown('selectedRaidMap', {
    Values = worldsNames,
    Default = settings['AutoRaid']['World'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Raid World',
    Tooltip = 'Selected Auto Raid World', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoRaid']['World'] = value
        SaveConfig()
    end
})

AutoRaid:AddToggle('enableAutoRaid', {
    Text = 'Enable Auto Raid',
    Default = settings['AutoRaid']['Enabled'],

    Callback = function(value)
        settings['AutoRaid']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoRaid']['Enabled'] then
            startRaid(worldsTableNumbers[settings['AutoRaid']['World']])
        end
    end
end)

local AutoDungeon = Tabs['Main']:AddRightGroupbox('Auto Dungeon')
AutoDungeon:AddDropdown('selectedDungeonDifficulty', {
    Values = dungeonDifficulties,
    Default = settings['AutoDungeon']['Difficulty'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Dungeon Difficulty',
    Tooltip = 'Selected Auto Dungeon Difficulty', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoDungeon']['Difficulty'] = value
        SaveConfig()
    end
})

AutoDungeon:AddToggle('enableAutoDungeon', {
    Text = 'Enable Auto Dungeon',
    Default = settings['AutoDungeon']['Enabled'],

    Callback = function(value)
        settings['AutoDungeon']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoDungeon']['Enabled'] then
            startDungeon(settings['AutoDungeon']['Difficulty'])
        end
    end
end)

local AutoDefense = Tabs['Main']:AddRightGroupbox('Auto Defense')
AutoDefense:AddToggle('enableAutoDefense', {
    Text = 'Enable Auto Defense',
    Default = settings['AutoDefense']['Enabled'],

    Callback = function(value)
        settings['AutoDefense']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoDefense']['Enabled'] then
            startDefense()
        end
    end
end)

local AutoStar = Tabs['Main']:AddLeftGroupbox('Auto Star')
AutoStar:AddDropdown('selectedAutoStar', {
    Values = stars,
    Default = settings['AutoStar']['SelectedStar'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Auto Star',
    Tooltip = 'Selected Auto Star to open', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoStar']['SelectedStar'] = value
        SaveConfig()
    end
})

AutoStar:AddToggle('enableAutoStar', {
    Text = 'Enable Auto Star',
    Default = settings['AutoStar']['Enabled'],

    Callback = function(value)
        settings['AutoStar']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoStar']['Enabled'] then
            local args = { [1] = { [1] = { [1] = "PetSystem", [2] = "Open", [3] = settings['AutoStar']['SelectedStar'], [4] = "All", ["n"] = 4 }, [2] = "\2" } }
            
            ReplicatedStorage:WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
        end
    end
end)

local Misc = Tabs['Main']:AddLeftGroupbox('Miscellaneous')
Misc:AddToggle('enableAutoMount', {
    Text = 'Enable Auto Mount',
    Default = settings['Misc']['Mount'],

    Callback = function(value)
        settings['Misc']['Mount'] = value
        SaveConfig()
    end
})

local ignoredBackWorlds = {"Defense", "Dungeon", "EasterInvasion", "Portal", "Raid"} 
local selectBackPosition = Misc:AddButton({
    Text = 'Save Back Position',
    Func = function()
        if table.find(ignoredBackWorlds, playerMap) then
            Library:Notify('Cannot save position in ' .. playerMap, 5)
            return
        end

        settings['Misc']['BackPosition'] = tostring(character:FindFirstChild("HumanoidRootPart").CFrame)
        settings['Misc']['BackWorld'] = playerMap
        SaveConfig()
        Library:Notify('Saved Position', 5)
    end,
    DoubleClick = false
})

local testSavedBackPosition = Misc:AddButton({
    Text = 'Test Back Position',
    Func = function()
        teleportToWorld(settings['Misc']['BackWorld'], stringToCFrame(settings['Misc']['BackPosition']))
    end,
    DoubleClick = false
})


Misc:AddToggle('enableAutoTeleportBack', {
    Text = 'Teleport Back After Modes',
    Default = settings['Misc']['TeleportBack'],

    Callback = function(value)
        settings['Misc']['TeleportBack'] = value
        SaveConfig()
    end
})

function teleportToSavedPosition()
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    teleportToWorld(settings['Misc']['BackWorld'], stringToCFrame(settings['Misc']['BackPosition']))
end

local modes = {"Dungeon", "Defense", "Portal"}
teleportedBack = false
task.spawn(function()
    while task.wait(1) and not Library.Unloaded do
        if settings['Misc']['TeleportBack'] then
            print('playerMode:', playerMode, '::', 'playerMap:', playerMap, '::', 'teleportedBack:', teleportedBack)
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local ResultsGUI = PlayerGui.Results
            local ReturnButton = ResultsGUI.Content.Return
            local RaidGui = PlayerGui.Mode.Content.Raid

            if ResultsGUI.Enabled and ReturnButton.Visible then
                for i, button in pairs(getconnections(ReturnButton.MouseButton1Click)) do
                        if i == 1 then
                            button:Fire()

                            repeat
                                pcall(function()
                                    teleportToSavedPosition()
                                    teleportedBack = true
                                end)
                            until ResultsGUI.Enabled == false or Library.Unloaded or not settings['Misc']['TeleportBack'] or not Library.Unloaded
                        end
                    end
            end

            if playerMode ~= nil then
                teleportedBack = false
                 
                if ResultsGUI.Enabled == true and ReturnButton.Visible == true then
                    for i, button in pairs(getconnections(ReturnButton.MouseButton1Click)) do
                        if i == 1 then
                            button:Fire()

                            repeat
                                pcall(function()
                                    print("repeat 1")
                                    teleportToSavedPosition()
                                    teleportedBack = true
                                end)
                            until ResultsGUI.Enabled == false or Library.Unloaded or not settings['Misc']['TeleportBack'] or not Library.Unloaded
                        end
                    end
                end
            elseif playerMode == nil and hrp.CFrame ~= stringToCFrame(settings['Misc']['BackPosition']) and teleportedBack == false then              
                print("2")
                --print("[" .. tostring(hrp.CFrame) .. "]" .. '::' .. "[" .. tostring(settings['Misc']['BackPosition']) .. "]")
                print(tostring(hrp.CFrame))
                print(tostring(settings['Misc']['BackPosition']))
                repeat
                    pcall(function()
                        print("repeat 2")
                        teleportToSavedPosition()
                        teleportedBack = true
                    end)
                --until stringToCFrame(settings['Misc']['BackPosition']) == hrp.CFrame or not settings['Misc']['TeleportBack'] or not Library.Unloaded
                until tostring(settings['Misc']['BackPosition']) == tostring(hrp.CFrame) or not settings['Misc']['TeleportBack'] or not Library.Unloaded
            end
        end

        task.wait()
    end
end)

local Timers = Tabs['Main']:AddRightGroupbox('Timers')
local DungeonCooldown = Timers:AddLabel("DUNGEON >> ", true)
local RaidCooldown = Timers:AddLabel("RAID    >> ", true)
local DefenseCooldown = Timers:AddLabel("DEFENSE >> ", true)

local dungeonMessage = 'DUNGEON >> '
local raidMessage = 'RAID    >> '
local defenseMessage = 'DEFENSE >> '
task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local RaidDelay = ScriptLibrary.PlayerData.RaidDelay
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < RaidDelay then
            raidMessage = "in " .. tostring(getTime(RaidDelay - Time))
        else
            raidMessage = 'READY !'
        end

        RaidCooldown:SetText('RAID    >> ' .. raidMessage)
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local DungeonDelay = ScriptLibrary.PlayerData.DungeonDelay
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < DungeonDelay then
            dungeonMessage = "in " .. tostring(getTime(DungeonDelay - Time))
        else
            dungeonMessage = 'READY !'
        end

        DungeonCooldown:SetText('DUNGEON >> ' .. dungeonMessage)
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local DefenseDelay = ScriptLibrary.PlayerData.DefenseDelay
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < DefenseDelay then
            defenseMessage = "in " .. tostring(getTime(DefenseDelay - Time))
        else
            defenseMessage = 'READY !'
        end

        DefenseCooldown:SetText('DEFENSE >> ' .. defenseMessage)
    end
end)

local minute = os.date("%M")
local unixTimestamp
local NoClipping = nil
local Clip = true

function Initialize()
	Library:Notify(string.format('Script Loaded in %.2f second(s)!', tick() - StartTick), 5)
	print("[Beaast Hub] Loaded")
end

task.spawn(function()
	while not Library.Unloaded do
		task.wait(0.1)

		minute = os.date("%M")
		unixTimestamp = os.time(os.date("!*t"))
	end
end)

Library:OnUnload(function()
	print('[Beaast Hub] Unloaded')
	Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
	Default = settings['Keybinds']['menuKeybind'],
	NoUI = true,
	Text = 'Menu keybind',

	ChangedCallback = function(value)
		settings['Keybinds']['menuKeybind'] = Options.MenuKeybind.Value
		SaveConfig()
	end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['Misc']['Mount'] then
            local args = { [1] = { [1] = { [1] = "MountSystem", [2] = "Add", ["n"] = 2 }, [2] = "\2" } }
            ReplicatedStorage:WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))           
        end
    end
end)

local OtherScripts = Tabs['UI Settings']:AddLeftGroupbox('Other Scripts')
OtherScripts:AddButton('Banana Hub', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/bui/main/temporynewkeysystem.lua', true)))
end)

OtherScripts:AddButton('Simple Spy', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua', true)))
end)

OtherScripts:AddButton('Dark Dex', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/Deniied0/Dex/master/source.lua', true)))
end)

OtherScripts:AddButton('Infinite Yield', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source', true)))
end)

Library.ToggleKeybind = Options.MenuKeybind

-- Addons:
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('BeaastHub')
local settingsRightBox = Tabs["UI Settings"]:AddRightGroupbox("Themes")
ThemeManager:ApplyToGroupbox(settingsRightBox)

game:GetService('Players').LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

Initialize()