local placeId = 17334984034
if game.placeId ~= placeId then return end
repeat task.wait() until game:IsLoaded()
local StartTick = tick()
task.wait(3)

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
        ['World'] = 'Slayer Town',
        ['Enemies'] = {'Gyutaro'},
        ['Enabled'] = false
    },
    ['AutoStar'] = {
        ['Enabled'] = false,
        ['SelectedStar'] = 'Slayer Star'
    },
    ['Misc'] = {
        ['Mount'] = false,
		['Speed'] = 26
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
local Players = game:GetService('Players')
local VirtualUser = game:GetService('VirtualUser')
local VirtualInputManager = game:GetService('VirtualInputManager')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')

local ScriptLibrary = require(game:GetService('ReplicatedStorage'):WaitForChild("Framework"):WaitForChild("Library"))
local passiveStats = require(ReplicatedStorage.Framework.Modules.Data.PassiveData)

local player = Players.LocalPlayer
local character = player.Character
local PlayerGui = player.PlayerGui
local playerMap = 1
local playerMode = nil

task.spawn(function()
    while task.wait() and not Library.Unloaded do
		local PETS = workspace['_PETS']:WaitForChild(player.UserId)
		for i, v in pairs(PETS:GetChildren()) do
			v:SetAttribute('WalkSPD', 150)
		end

        playerMap = ScriptLibrary.PlayerData.CurrentMap
        
        if player:GetAttribute('Mode') ~= nil then
            if player:GetAttribute('Mode') == 'Dungeon' then
                playerMode = 'Dungeon'
            elseif player:GetAttribute('Mode') == 'Raid' then
                playerMode = 'Raid'
            end
        end
    end
end)

local worldsNames = {
    'Slayer Town',
    'Giant District',
    'ABC City',
    'Cursed School'
}

local worldsTable = {
    ["Slayer Town"] = "1",
	["Giant District"] = "2",
	["ABC City"] = "3",
	["Cursed School"] = "4"
}

local worldsTableNumbers = {
    ["Slayer Town"] = 1,
	["Giant District"] = 2,
	["ABC City"] = 3,
	["Cursed School"] = 4
}

local attacking = false
local lastClosest = nil

function findNearestEnemy()
	local Closest = nil
	local ClosestDistance = math.huge

	local enemyModels = Workspace['_ENEMIES']['Server']:GetDescendants()

	for _, targetEnemy in ipairs(enemyModels) do
		if targetEnemy:IsA("Part") then
			local Distance = (character.HumanoidRootPart.Position - targetEnemy.Position).magnitude

			if Distance <= 1500 and Distance < ClosestDistance then
				Closest = targetEnemy
				ClosestDistance = Distance
			end
		end
	end

	if Closest == nil then ClosestDistance = math.huge end
	return Closest, ClosestDistance
end

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoFarm']['Enabled'] then
            local selectedWorld = settings['AutoFarm']['World']

			if tostring(playerMap) == tostring(worldsTableNumbers[selectedWorld] + 1)  then
                local worldEnemies = Workspace['_ENEMIES']['Server']:GetDescendants()
				local Closest, ClosestDistance = findNearestEnemy()

                if Closest then
					print(ClosestDistance)
                    if Closest:GetAttribute('Dead') == false then
                        if lastClosest == nil then lastClosest = Closest end

                        if lastClosest == Closest then
                            if attacking == false then
                                local args = { [1] = { [1] = { [1] = "PetSystem", [2] = "Attack", [3] = Closest.Name, [4] = true, ["n"] = 4 }, [2] = "\2" } }
                                ReplicatedStorage:WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                                attacking = true
                            end
                        else
                            VirtualInputManager:SendKeyEvent(true, 'R', false, nil)
							task.wait(0.005)
							VirtualInputManager:SendKeyEvent(false, 'R', false, nil)
							lastClosest = Closest
							attacking = false
                        end
					else
						attacking = false	
						lastClosest = Closest
                    end
                end
            end
        end
    end
end)

local stars = {
    'Slayer Star',
    'Titan Star',
    'Punch Star',
    'Cursed Star',
    'Player Star',
    'Pirate Star',
    'Bizarre Star',
    'Z Star'
}

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

local Timers = Tabs['Main']:AddRightGroupbox('Timers')
local DungeonCooldown = Timers:AddLabel("DUNGEON >> ", true)
local RaidCooldown = Timers:AddLabel("RAID    >> ", true)
local DefenseCooldown = Timers:AddLabel("DEFENSE >> ", true)

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