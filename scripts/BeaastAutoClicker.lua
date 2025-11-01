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

local Window = Library:CreateWindow({ Title = 'Beaast Hub | Auto Clicker', Center = true, AutoShow = true })
local Tabs = {
	['Main'] = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings')
}

local saveFolderName = 'BeaastHub'
local gameFolderName = 'AutoClicker'
local saveFileName = game:GetService('Players').LocalPlayer.Name .. '.json'
local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

local defaultSettings = {
    ['AutoClicker'] = {
        ['Enabled'] = false,
        ['PosX'] = 0,
        ['PosY'] = 0,
        ['Interval'] = 0.01,
        ['Keybind'] = 'F'
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

-- // VARIABLES \\ --
local VirtualInputManager = game:GetService("VirtualInputManager")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local AutoClicker = Tabs['Main']:AddLeftGroupbox('Auto Clicker')
-- AutoClicker:AddToggle('enableAutoClicker', {
--     Text = 'Enable Auto Clicker',
--     Default = settings['AutoClicker']['Enabled'],

--     Callback = function(value)
--         settings['AutoClicker']['Enabled'] = value
--         SaveConfig()
--     end
-- })

AutoClicker:AddSlider('autoClickerDelay', {
    Text = 'Auto Clicker Delay',
    Default = settings['AutoClicker']['Interval'],
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Suffix = 's ',
    Compact = false,

    Callback = function(value)
        settings['AutoClicker']['Interval'] = value
        SaveConfig()
    end
})

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Point = Instance.new('TextLabel')
Point.Name = 'CLICK'
Point.Text = 'CLICK'
Point.Parent = ScreenGui
Point.BackgroundTransparency = 0.000
Point.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Point.Size = UDim2.new(0, 20, 0, 20)
Point.Position = UDim2.fromOffset(settings['AutoClicker']['PosX'], settings['AutoClicker']['PosY'])
Point.Font = Enum.Font.SourceSans
Point.TextScaled = true
Point.TextSize = 14.000
Point.TextWrapped = true
Point.AnchorPoint = Vector2.new(0.5, 0.5)

AutoClicker:AddLabel('Keybind'):AddKeyPicker('autoClickerKeybind', {
    Default = settings['AutoClicker']['Keybind'],
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Auto Clicker Keybind',
    NoUI = true,

    Callback = function(value)
        settings['AutoClicker']['PosX'] = Mouse.X
        settings['AutoClicker']['PosY'] = Mouse.Y

        settings['AutoClicker']['Enabled'] = value
        SaveConfig()

        if value then
            Library:Notify('Enabled Auto Clicker', 5)
        else
            Library:Notify('Disabled Auto Clicker', 5)
        end
    end,

    ChangedCallback = function(value)
        settings['AutoClicker']['Keybind'] = Options.autoClickerKeybind.Value
        SaveConfig()
    end
})

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		if settings['AutoClicker']['Enabled'] then
			VirtualInputManager:SendMouseButtonEvent(settings['AutoClicker']['PosX'], settings['AutoClicker']['PosY'], 0, true, game, 1)
			VirtualInputManager:SendMouseButtonEvent(settings['AutoClicker']['PosX'], settings['AutoClicker']['PosY'], 0, false, game, 1)

            Point.Position = UDim2.fromOffset(settings['AutoClicker']['PosX'], settings['AutoClicker']['PosY'])
            Point.Visible = true
			task.wait(settings['AutoClicker']['Interval'])
        else
            Point.Visible = false
		end
	end
end)

function Initialize()
	Library:Notify(string.format('Script Loaded in %.2f second(s)!', tick() - StartTick), 5)
	print("[BeaastHub] Auto Clicker Loaded")
end

Library:OnUnload(function()
	print('[BeaastHub] Anime Clicker Unloaded')
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