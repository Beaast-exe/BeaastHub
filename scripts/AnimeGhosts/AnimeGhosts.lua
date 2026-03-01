local placeId = 101640913672688
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

local Window = Library:CreateWindow({ Title = 'Beaast Hub | Anime Ghosts', Center = true, AutoShow = true })
local Tabs = {
	['Main'] = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings')
}

local saveFolderName = 'BeaastHub'
local gameFolderName = 'AnimeGhosts'
local saveFileName = game:GetService('Players').LocalPlayer.Name .. '.json'
local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

local defaultSettings = {
    ['AutoDungeon'] = {
        ['Enabled'] = false,
        ['Difficulty'] = "Easy",
        ['AutoLeave'] = false,
        ['LeaveWave'] = 10
    },
    ['AutoRaid'] = {
        ['Enabled'] = false,
        ['Difficulty'] = "Easy",
        ['AutoLeave'] = false,
        ['LeaveWave'] = 10
    },
    ['AutoScroll'] = {
        ['Enabled'] = false,
        ['SelectedScroll'] = 'Titan Scroll'
    },
    ['Misc'] = {
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

local playerMap = "1"
local playerMode = nil

local worldsNames = {
    "Loading Docks",
    "Supernatural Farm",
    "Spirit Town",
    "Double Dungeon",
    "Egg Island"
}

local worldsTable = {
    ["Loading Docks"] = "1",
	["Supernatural Farm"] = "2",
	["Spirit Town"] = "3",
	["Double Dungeon"] = "4",
    ["Egg Island"] = "5"
}

local worldsTableNumbers = {
    ["Loading Docks"] = 1,
    ["Supernatural Farm"] = 2,
    ["Spirit Town"] = 3,
    ["Double Dungeon"] = 4,
    ["Egg Island"] = 5
}

local numbersToWorlds = {
    [1] = "Loading Docks",
    [2] = "Supernatural Farm",
    [3] = "Spirit Town",
    [4] = "Double Dungeon",
    [5] = "Egg Island"
}

local scrolls = {
    'Titan Scroll',
    'Supernatural Scroll',
    'Spiritual Scroll',
    'Solo Scroll',
    'Punk Scroll'
}

local dungeonDifficulties = {
    "Easy",
    "Medium",
    "Hard"
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

function teleportToSavedPosition()
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    teleportToWorld(settings['Misc']['BackWorld'], stringToCFrame(settings['Misc']['BackPosition']))
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

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']:GetDescendants()) do
        if folder:IsA('Folder') and (folder.Name == 'Dungeon' or folder.Name == 'Raid' or folder.Name == 'Gamemode') then
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

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']:GetDescendants()) do
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

local function getDungeonCooldown()
    local DungeonDelay = ScriptLibrary.PlayerData.Delay.Dungeon
    if DungeonDelay == nil then return end

    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < DungeonDelay then
        return true
    else
        return false
    end
end

local function createDungeon(difficulty)
    dataRemoteEvent:FireServer(unpack({{{"GamemodeSystem", "Create", "Dungeon", "CrystalCave", difficulty, n = 6}, "\002" }}))
    task.wait(5)
    dataRemoteEvent:FireServer(unpack({{{ "GamemodeSystem", "Start", "Dungeon", player.UserId, n = 4 }, "\002"}}))
end

local function startDungeon(difficulty)
    if getDungeonCooldown() then return end
    if playerMode == nil then
        createDungeon(difficulty)
        task.wait(3)
    elseif checkDungeon() == 'Dungeon' or playerMode == 'Dungeon' then
        teleportToEnemyInMap('Gamemode')
        task.wait()
    end
end

local function getRaidCooldown()
    local RaidDelay = ScriptLibrary.PlayerData.Delay.Raid
    if RaidDelay == nil then return end

    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < RaidDelay then
        return true
    else
        return false
    end
end

local function createRaid()
    dataRemoteEvent:FireServer(unpack({{{"GamemodeSystem", "Create", "Raid", "TitanTown", "Easy", n = 6 }, "\002" }}))
    task.wait(5)
    dataRemoteEvent:FireServer(unpack({{{"GamemodeSystem", "Start", "Raid", player.UserId, n = 4 }, "\002"}}))
end

local function startRaid()
    if getRaidCooldown() then return end
    if playerMode == nil then
        createRaid()
        task.wait(3)
    elseif checkDungeon() == 'Raid' or playerMode == 'Raid' then
        teleportToEnemyInMap('Gamemode')
        task.wait()
    end
end

local AutoScroll = Tabs['Main']:AddLeftGroupbox('Auto Scroll')
AutoScroll:AddDropdown('selectedDungeonDifficulty', {
    Values = scrolls,
    Default = settings['AutoScroll']['SelectedScroll'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Auto Scroll',
    Tooltip = 'Selected Auto Scroll to open', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoScroll']['SelectedScroll'] = value
        SaveConfig()
    end
})

AutoScroll:AddToggle('enableAutoScroll', {
    Text = 'Enable Auto Scroll',
    Default = settings['AutoScroll']['Enabled'],

    Callback = function(value)
        settings['AutoScroll']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoScroll']['Enabled'] then
            local args = {{{"PetSystem", "Open", settings['AutoScroll']['SelectedScroll'], "All", n = 4 }, "\002" }}
            game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
        end 
    end
end)

local Misc = Tabs['Main']:AddLeftGroupbox('Miscellaneous')
local ignoredBackWorlds = {"Gamemode"}
local selectBackPosition = Misc:AddButton({
    Text = 'Save Back Position',
    Func = function()
        if table.find(ignoredBackWorlds, playerMap) then
            Library:Notify('Cannot save position in ' .. playerMap, 5)
            return
        end

        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            Library:Notify('No HumanoidRootPart', 5)
            return
        end

        settings['Misc']['BackPosition'] = tostring(hrp.CFrame)
        settings['Misc']['BackWorld'] = playerMap

        SaveConfig()
        Library:Notify('Saved Position', 5)
        --Library:Notify('World: ' .. playerMap .. '\nPosition: ' .. settings['Misc']['BackPosition'], 5)
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

local modes = {"Dungeon", "Defense", "Portal", "Invasion"}
teleportedBack = false
task.spawn(function()
    while task.wait(1) and not Library.Unloaded do
        if settings['Misc']['TeleportBack'] then
            --print('playerMode:', playerMode, '::', 'playerMap:', playerMap, '::', 'teleportedBack:', teleportedBack)
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local ResultsGUI = PlayerGui.Results
            local ReturnButton = ResultsGUI.Content.Return

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
                                    --print("repeat 1")
                                    teleportToSavedPosition()
                                    teleportedBack = true
                                end)
                            until ResultsGUI.Enabled == false or Library.Unloaded or not settings['Misc']['TeleportBack'] or not Library.Unloaded
                        end
                    end
                end
            elseif playerMode == nil and hrp.CFrame ~= stringToCFrame(settings['Misc']['BackPosition']) and teleportedBack == false then              
                --print("2")
                --print("[" .. tostring(hrp.CFrame) .. "]" .. '::' .. "[" .. tostring(settings['Misc']['BackPosition']) .. "]")
                --print(tostring(hrp.CFrame))
                --print(tostring(settings['Misc']['BackPosition']))
                repeat
                    pcall(function()
                        --print("repeat 2")
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

AutoDungeon:AddSlider('dungeonLeaveWaveSlider', {
    Text = 'Dungeon Leave Wave',
    Default = settings['AutoDungeon']['LeaveWave'],
    Min = 1,
    Max = 50,
    Rounding = 0,
    Compact = false,

    Callback = function(value)
        settings['AutoDungeon']['LeaveWave'] = value
        SaveConfig()
    end
})

AutoDungeon:AddToggle('enableDungeonAutoLeave', {
    Text = 'Auto Leave Dungeon at Wave',
    Default = settings['AutoDungeon']['AutoLeave'],

    Callback = function(value)
        settings['AutoDungeon']['AutoLeave'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoDungeon']['Enabled'] then
            startDungeon(settings['AutoDungeon']['Difficulty'])

            if settings['AutoDungeon']['AutoLeave'] and playerMode == 'Dungeon' then
                local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
                if Gamemode:FindFirstChild(player.UserId) then
                    --if Gamemode[player.UserId].Players:GetAttribute(player.UserId) == true then
                        print(Gamemode:FindFirstChild(player.UserId):GetAttribute('Stage'))
                        if Gamemode:FindFirstChild(player.UserId):GetAttribute('Stage') >= settings['AutoDungeon']['LeaveWave'] then
                            --if Gamemode[player.UserId]:GetAttribute('ModeId') == 'Dungeon' then
                                teleportToSavedPosition()
                            --end
                        end
                    --end
                end
            end
        end
    end
end)

local AutoRaid = Tabs['Main']:AddRightGroupbox('Auto Raid')
AutoRaid:AddToggle('enableAutoRaid', {
    Text = 'Enable Auto Raid',
    Default = settings['AutoRaid']['Enabled'],

    Callback = function(value)
        settings['AutoRaid']['Enabled'] = value
        SaveConfig()
    end
})

AutoRaid:AddSlider('raidLeaveWaveSlider', {
    Text = 'Raid Leave Wave',
    Default = settings['AutoRaid']['LeaveWave'],
    Min = 1,
    Max = 50,
    Rounding = 0,
    Compact = false,

    Callback = function(value)
        settings['AutoRaid']['LeaveWave'] = value
        SaveConfig()
    end
})

AutoRaid:AddToggle('enableRaidAutoLeave', {
    Text = 'Auto Leave Raid at Wave',
    Default = settings['AutoRaid']['AutoLeave'],

    Callback = function(value)
        settings['AutoRaid']['AutoLeave'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['AutoRaid']['Enabled'] then
            startRaid()

            if settings['AutoRaid']['AutoLeave'] and playerMode == 'Raid' then
                local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
                if Gamemode:FindFirstChild(player.UserId) then
                    --if Gamemode[player.UserId].Players:GetAttribute(player.UserId) == true then
                        print(Gamemode:FindFirstChild(player.UserId):GetAttribute('Stage'))
                        if Gamemode:FindFirstChild(player.UserId):GetAttribute('Stage') >= settings['AutoRaid']['LeaveWave'] then
                            --if Gamemode[player.UserId]:GetAttribute('ModeId') == 'Dungeon' then
                                teleportToSavedPosition()
                            --end
                        end
                    --end
                end
            end
        end
    end
end)

local Timers = Tabs['Main']:AddRightGroupbox('Timers')
local DungeonCooldown = Timers:AddLabel("DUNGEON >> ", true)
local RaidCooldown = Timers:AddLabel("RAID    >> ", true)

local dungeonMessage = 'DUNGEON  >> '
local raidMessage = 'RAID     >> '

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local RaidDelay = ScriptLibrary.PlayerData.Delay.Raid
        if RaidDelay == nil then return end
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < RaidDelay then
            raidMessage = "in " .. tostring(getTime(RaidDelay - Time))
        else
            raidMessage = 'READY !'
        end

        RaidCooldown:SetText('RAID     >> ' .. raidMessage)
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local DungeonDelay = ScriptLibrary.PlayerData.Delay.Dungeon
        if DungeonDelay == nil then return end
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < DungeonDelay then
            dungeonMessage = "in " .. tostring(getTime(DungeonDelay - Time))
        else
            dungeonMessage = 'READY !'
        end

        DungeonCooldown:SetText('DUNGEON  >> ' .. dungeonMessage)
    end
end)

local minute = os.date("%M")
local unixTimestamp
local NoClipping = nil
local Clip = true

function Initialize()
	Library:Notify(string.format('Script Loaded in %.2f second(s)!', tick() - StartTick), 5)
	print("[BeaastHub] Anime Ghosts Loaded")
end

task.spawn(function()
	while not Library.Unloaded do
		task.wait(0.1)

		minute = os.date("%M")
		unixTimestamp = os.time(os.date("!*t"))
	end
end)

Library:OnUnload(function()
	print('[BeaastHub] Anime Ghosts Unloaded')
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

local OtherScripts = Tabs['UI Settings']:AddLeftGroupbox('Other Scripts')
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