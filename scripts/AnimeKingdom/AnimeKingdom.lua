local placeId = 17334984034
if game.placeId ~= placeId then return end
repeat task.wait() until game:IsLoaded()
local StartTick = tick()

local HttpService = game:GetService('HttpService')
local repo = 'https://raw.githubusercontent.com/Beaast-exe/BeaastHub/master/libs/LinoriaLib/' -- BEAAST HUB LINORIA
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Beaast Hub | Anime Power', Center = true, AutoShow = true })
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
        ['Enabled'] = false
    },
    ['AutoStar'] = {
        ['Enabled'] = false,
        ['SelectedStar'] = ''
    },
    ['Misc'] = {
        ['Mount'] = false
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

local player = Players.LocalPlayer
local character = player.Character
local PlayerGui = player.PlayerGui

local AutoFarm = Tabs['Main']:AddLeftGroupbox('Auto Farm')

local Misc = Tabs['Main']:AddRightGroupbox('Miscellaneous')
    Misc:AddToggle('enableAutoMount', {
    Text = 'Enable Auto Mount',
    Default = settings['Misc']['Mount'] or defaultSettings['Misc']['Mount'],

    Callback = function(value)
        settings['Misc']['Mount'] = value
        SaveConfig()
    end
})

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

local minute = os.date("%M")
local unixTimestamp
local NoClipping = nil
local Clip = true

function Initialize()
	Library:Notify(string.format('Script Loaded in %.2f second(s)!', tick() - StartTick), 5)
	print("[Beaast Hub] Loaded")
end

task.spawn(function()
	while not Library.Unloaded do -- terste
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