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

local Timers = Tabs['Main']:AddRightGroupbox('Timers')

local EasyDungeon = Timers:AddLabel("Easy Dungeon >> ", true)
local MediumDungeon = Timers:AddLabel("Medium Dungeon >> ", true)
local HardDungeon = Timers:AddLabel("Hard Dungeon >> ", true)
local InsaneDungeon = Timers:AddLabel("Insane Dungeon >> ", true)

local loop = nil

local dungeonsInfo = {
	["possibleDrops"] = {
		["gems"] = {
			["sword fragment"] = 5,
			["upgrade points"] = 5,
			["haki shard"] = 5,
			["lineage crystal"] = 3
		}
	},
	["dungeons"] = {
		["easy"] = {
			["metadata"] = "colorg",
			["coinsRate"] = 2043400000,
			["baseHealth"] = 1.749875e17,
			["startingMinute"] = 0,
			["primaryColor"] = Color3.fromRGB(65, 255, 113),
			["secondaryColor"] = Color3.fromRGB(155, 180, 118),
			["pivot"] = CFrame.new(0, 10000, 0)
		},
		["medium"] = {
			["metadata"] = "colory",
			["coinsRate"] = 24043400000,
			["baseHealth"] = 3.9999875e22,
			["startingMinute"] = 15,
			["primaryColor"] = Color3.fromRGB(254, 229, 41),
			["secondaryColor"] = Color3.fromRGB(180, 172, 113),
			["pivot"] = CFrame.new(-200, 10000, -0)
		},
		["hard"] = {
			["metadata"] = "coloro",
			["coinsRate"] = 119340000000,
			["baseHealth"] = 6.999975e28,
			["startingMinute"] = 30,
			["primaryColor"] = Color3.fromRGB(248, 79, 12),
			["secondaryColor"] = Color3.fromRGB(180, 132, 117),
			["pivot"] = CFrame.new(-400, 10000, 0)
		},
		["insane"] = {
			["metadata"] = "colorpu",
			["coinsRate"] = 2e16,
			["baseHealth"] = 4.5e32,
			["startingMinute"] = 45,
			["primaryColor"] = Color3.fromRGB(74, 41, 185),
			["secondaryColor"] = Color3.fromRGB(136, 114, 180),
			["pivot"] = CFrame.new(-600, 10000, 0)
		}
	}
}

local function getTimers()
	local CollectionService = game:GetService("CollectionService")
	local dungeonHitboxes = CollectionService:GetTagged("dungeonHitboxes")

	local v25 = Workspace:GetServerTimeNow()
	local v26 = v25 // 60 % 60
	local v27 = v25 % 60 // 1

	for _, v28 in dungeonHitboxes do
		local v29 = v28.Name
		local v30 = dungeonsInfo.dungeons[v29]

		if v30 then
			local v31 = v28.billboard
			local v32 = v30.startingMinute
			local v33 = v32 < v26 + 1 and 59 - v26 + v32 or v32 - v26 - 1
            local v34 = 59 - v27
			local v35 = v33 + 1 == 60
            v28.color.Dots.Enabled = v35

			if v35 then
				v31.timer.Text = ("Dungeon closing in %* seconds"):format(v34)
				-- utility:tween(v28.color, {
                --     ["Color"] = Color3.fromHex("a69eb4")
                -- }, 1)
			else
				v31.timer.Text = string.format("%02i:%02i", v33, v34)
                -- utility:tween(v28.color, {
                --     ["Color"] = v30.secondaryColor
                -- }, 1)
			end
		end
	end
end

local loopScheduler = require(ReplicatedStorage.Shared.loopScheduler)

task.spawn(function()
	while task.wait() do
		if not Library.Unloaded then
			if not loop then
				loop = loopScheduler:Bind(getTimers, 1)
			end
		else
			if loop then
				loop:Disconnect()
				loop = nil
			end
			return
		end
	end
end)

task.spawn(function()
	while task.wait() and not Library.Unloaded do
		local dungeonTimers = nil		

		if Workspace.currentWorld:FindFirstChild("dungeon") then
			dungeonTimers = Workspace.currentWorld.dungeon.elements.hitboxes
		else
			dungeonTimers = ReplicatedStorage.Assets.Worlds.dungeon.elements.hitboxes
		end

		local easyTimer = dungeonTimers.easy.billboard.timer.Text
		local mediumTimer = dungeonTimers.medium.billboard.timer.Text
		local hardTimer = dungeonTimers.hard.billboard.timer.Text
		local insaneTimer = dungeonTimers.insane.billboard.timer.Text

		EasyDungeon:SetText("Easy Dungeon   >>  " .. easyTimer)
		MediumDungeon:SetText("Medium Dungeon >>  " .. mediumTimer)
		HardDungeon:SetText("Hard Dungeon   >>  " .. hardTimer)
		InsaneDungeon:SetText("Insane Dungeon >>  " .. insaneTimer)
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