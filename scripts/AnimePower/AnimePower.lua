local placeId = 76598287484083
if game.placeId ~= placeId then return end
repeat task.wait() until game:IsLoaded()
local StartTick = tick()

local HttpService = game:GetService('HttpService')
local repo = 'https://raw.githubusercontent.com/Beaast-exe/BeaastHub/master/libs/LinoriaLib/' -- BEAAST HUB LINORIA
--local repo = 'https://raw.githubusercontent.com/TrapstarKS/LinoriaLib/main/' -- BEAAST HUB LINORIA
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Beaast Hub | Anime Power', Center = true, AutoShow = true })
local Tabs = {
	['Main'] = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings')
}

local saveFolderName = 'BeaastHub'
local gameFolderName = 'AnimePower'
local saveFileName = game:GetService('Players').LocalPlayer.Name .. '.json'
local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

local defaultSettings = {
    ['AutoFarm'] = {
        ['Enabled'] = false,
        ['AutoAttack'] = false,
        ['AutoArise'] = false
    },
	['AutoRoll'] = {
		['Lineages'] = false,
		['Swords'] = false,
		['Star'] = false
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
AutoFarm:AddToggle('enableAutoAttack', {
	Text = 'Enable Auto Attack',
	Default = settings['AutoFarm']['AutoAttack'],
	Tooltip = 'Enable Auto Attack',

	Callback = function(value)
		settings['AutoFarm']['AutoAttack'] = value
		SaveConfig()
	end
})

AutoFarm:AddToggle('enableAutoArise', {
	Text = 'Enable Auto Arise',
	Default = settings['AutoFarm']['AutoArise'],
	Tooltip = 'Enable Auto Arise',

	Callback = function(value)
		settings['AutoFarm']['AutoArise'] = value
		SaveConfig()
	end
})

AutoFarm:AddToggle('enableAutoAbility', {
	Text = 'Enable Auto Ability',
	Default = settings['AutoFarm']['AutoAbility'],
	Tooltip = 'Enable Auto Ability',

	Callback = function(value)
		settings['AutoFarm']['AutoAbility'] = value
		SaveConfig()
	end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoFarm']['AutoAttack'] then
            local args = { [1] = "attack" }
			ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
        end

		
    end
end)

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		if settings['AutoFarm']['AutoArise'] then
			local args = { [1] = "arise" }
			ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
		end
	end
end)

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		if settings['AutoFarm']['AutoAbility'] then
			local args = { [1] = "useAbility" }
			ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
		end
	end
end)

local AutoRoll = Tabs['Main']:AddLeftGroupbox('Auto Roll')
AutoRoll:AddToggle('enableAutoRollLineages', {
	Text = 'Auto Roll Lineages',
	Default = settings['AutoRoll']['Lineages'],
	Tooltip = 'Enable Auto Roll Lineages',

	Callback = function(value)
		settings['AutoRoll']['Lineages'] = value
		SaveConfig()
	end
})

AutoRoll:AddToggle('enableAutoRollSwords', {
	Text = 'Auto Roll Swords',
	Default = settings['AutoRoll']['Swords'],
	Tooltip = 'Enable Auto Roll Swords',

	Callback = function(value)
		settings['AutoRoll']['Swords'] = value
		SaveConfig()
	end
})

AutoRoll:AddToggle('enableAutoRollStar', {
	Text = 'Auto Roll Star (Last World)',
	Default = settings['AutoRoll']['Star'],
	Tooltip = 'Enable Auto Roll Star (Last World)',

	Callback = function(value)
		settings['AutoRoll']['Star'] = value
		SaveConfig()
	end
})

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		if settings['AutoRoll']['Lineages'] then
			local args = { [1] = "rollLineages" }
			ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
		end
	end
end)

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		if settings['AutoRoll']['Swords'] then
			local args = { [1] = "rollSwords",  [2] = "one" }
			ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
		end
	end
end)

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		if settings['AutoRoll']['Star'] then
			local args = { [1] = "rollChampion", [2] = "one", [3] = "cursed school" }
			ReplicatedStorage.Shared.events.RemoteEvent:FireServer(unpack(args))
		end
	end
end)

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

local OtherScripts = Tabs['UI Settings']:AddLeftGroupbox('Other Scripts')
OtherScripts:AddButton('Banana Hub', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/bui/main/temporynewkeysystem.lua', true)))
end)

OtherScripts:AddButton('Simple Spy', function()
	task.spawn(loadstring(game:HttpGet('https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua', true)))
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