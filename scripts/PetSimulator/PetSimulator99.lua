local StartTick = tick()

local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--repeat task.wait(1) until game:IsLoaded()
--repeat task.wait(1) until game.PlaceId ~= nil
--repeat task.wait(1) until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character.HumanoidRootPart

local WORLD = 0

local repo = 'https://raw.githubusercontent.com/TrapstarKSSKSKSKKS/LinoriaLib/main/' -- TRAP HUB
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Beaast Hub | Pet Simulator 99', Center = true, AutoShow = true })
local Tabs = {
	['Main'] = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings')
}

local saveFolderName = 'BeaastHub'
local gameFolderName = 'PetSimulator99'
local saveFileName = Players.LocalPlayer.Name .. '.json'
local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

local defaultSettings = {
	['Relics'] = {
		['Enabled'] = false
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
local RELICS_FIND_DELAY = 0.5

function Initialize()
    if game.PlaceId == 8737899170 then
        WORLD = 1
    
        repeat
            WORLD = 1
            task.wait(1)
        until #Workspace['Map']:GetChildren() == 100
    elseif game.PlaceId == 16498369169 then
        WORLD = 2
    
        repeat
            WORLD = 2
            task.wait(1)
        until #Workspace['Map']:GetChildren() == 26
    end

    repeat task.wait(1) until Workspace['__THINGS'] and Workspace['__DEBRIS']
    
    task.wait(5)
    print('[Beaast Hub] Loaded Pet Simulator 99 :: WORLD ' .. WORLD)
end

local Autos = Tabs['Main']:AddRightGroupbox('Autos')
Autos:AddToggle('enableAutoShinyRelics', {
	Text = 'Auto Shiny Relics',
	Default = settings['Relics']['Enabled'],
	Tooltip = 'Auto find Shiny Relics',

	Callback = function(value)
		settings['Relics']['Enabled'] = value
		SaveConfig()
	end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['Relics']['Enabled'] then
            for _, relic in pairs(Workspace['__THINGS']:FindFirstChild('ShinyRelics'):GetChildren()) do
                if relic:IsA('BasePart') then
                    if relic.Transparency == 0.75 then
                        --relic:Destroy()
                    end
                end
            end
    
            local highlight = Workspace['__THINGS']:FindFirstChild('ShinyRelics'):FindFirstChild('Highlight')
            if highlight then
                highlight:Destroy()
            end
    
            local allRelics = ReplicatedStorage['Network']['Relics_Request']:InvokeServer()
            for _, v in pairs(Workspace['__THINGS']:FindFirstChild('ShinyRelics'):GetChildren()) do
                Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = v.CFrame
                task.wait(RELICS_FIND_DELAY)
    
                local relicNumber
                for relicNum, relicData in pairs(allRelics) do
                    if relicData.Position == v.CFrame then
                        relicNumber = relicNum
                        break
                    end
                end
    
                print(ReplicatedStorage['Network']['Relic_Found']:InvokeServer(relicNumber))
                task.wait(1)
                --v.Destroy()
            end
        end
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
OtherScripts:AddButton('Zer0 Hub', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/Discord0000/Zer0Hub/main/MainScript.lua', true)))
end)

OtherScripts:AddButton('Simple Spy', function()
	task.spawn(loadstring(game:HttpGet('https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua', true)))
end)

OtherScripts:AddButton('Dark Dex', function()
	task.spawn(loadstring(game:HttpGet('https://raw.githubusercontent.com/Deniied0/Dex/master/source.lua', true)))
end)

Library.ToggleKeybind = Options.MenuKeybind

-- Addons:
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('BeaastHub')
local settingsRightBox = Tabs['UI Settings']:AddRightGroupbox('Themes')
ThemeManager:ApplyToGroupbox(settingsRightBox)

game:GetService('Players').LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

Initialize()