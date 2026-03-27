local placeId = 101640913672688
if game.placeId ~= placeId then return end
repeat task.wait() until game:IsLoaded()
if not game:IsLoaded() then game.Loaded:Wait() end
local StartTick = tick()
task.wait(20)

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
    ['Gachas'] = Window:AddTab('Gachas'),
    ['Shops'] = Window:AddTab('Shops'),
    ['Upgrades'] = Window:AddTab('Upgrades'),
    -- ['Testing'] = Window:AddTab('Testing'),
	['UI Settings'] = Window:AddTab('UI Settings')
}

local saveFolderName = 'BeaastHub'
local gameFolderName = 'AnimeGhosts'
local saveFileName = game:GetService('Players').LocalPlayer.Name .. '.json'
local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

local defaultSettings = {
    ['AutoDungeon'] = {
        ['Enabled'] = false,
        ['AutoDungeon'] = false,
        ['Map'] = 'CrystalCave',
        ['Difficulty'] = 'Easy',
        ['AutoLeave'] = false,
        ['LeaveWave'] = 50
    },
    ['AutoRaid'] = {
        ['Enabled'] = false,
        ['AutoRaid'] = false,
        ['Map'] = 'TitanTown',
        ['Difficulty'] = 'Easy',
        ['AutoLeave'] = false,
        ['LeaveWave'] = 50
    },
    ['InfinityCastle'] = {
        ['Enabled'] = false,
        ['InfinityCastle'] = false,
        ['Act'] = 'Act1',
        ['Difficulty'] = 'Easy',
        ['AutoLeave'] = false,
        ['LeaveWave'] = 50
    },
    ['DefenseMode'] = {
        ['Enabled'] = false,
        ['DefenseMode'] = false,
        ['Difficulty'] = 'Easy',
        ['AutoLeave'] = false,
        ['LeaveWave'] = 50
    },
    ['AutoScroll'] = {
        ['Enabled'] = false,
        ['SelectedScroll'] = 'Titan Scroll'
    },
    ['Misc'] = {
        ['BackPosition'] = nil,
        ['BackWorld'] = '1',
        ['TeleportBack'] = false,
        ['TimeRewards'] = false,
        ['DailyGems'] = false,
        ['AutoAttack'] = false
    },
    ['AutoPotions'] = {
        ['SelectedPotions'] = {"EnergyPotion1"},
        ['Enabled'] = false,
        ['OnlyWhenFull'] = false
    },
    ['DungeonShop'] = {
        ['SelectedItems'] = {'Gems', 'DungeonTickets', 'EnergyPotion3', 'DamagePotion3', 'GhostPotion3', 'LuckPotion3', 'DropPotion3', 'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'},
        ['Enabled'] = false
    },
    ['RaidShop'] = {
        ['SelectedItems'] = {'Gems', 'RaidTickets', 'EnergyPotion3', 'DamagePotion3', 'GhostPotion3', 'LuckPotion3', 'DropPotion3', 'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'},
        ['Enabled'] = false
    },
    ['DefenseShop'] = {
        ['SelectedItems'] = {'Gems', 'DefenseTickets', 'EnergyPotion3', 'DamagePotion3', 'GhostPotion3', 'LuckPotion3', 'DropPotion3', 'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'},
        ['Enabled'] = false
    },
    ['AutoUpgrades'] = {
        ['Dungeon'] = {
            ['SelectedUpgrades'] = {'Energy', 'Damage', 'Ghost', 'CritDMG', 'ModeDelay', 'DungeonEnemyScale'},
            ['Enabled'] = false
        },
        ['Raid'] = {
            ['SelectedUpgrades'] = {'Energy', 'Damage', 'Ghost', 'AtkSPD', 'ModeDelay', 'GachaSpins'},
            ['Enabled'] = false
        },
        ['Defense'] = {
            ['SelectedUpgrades'] = {'Energy', 'Damage', 'Ghost', 'AtkSPD', 'ModeDelay', 'Defense ModeSpawnSpeed', 'WarriorEquipTitan', 'WarriorEquipShadow', 'WarriorEquipStand'},
            ['Enabled'] = false
        },
        ['Division'] = {
            ['SelectedUpgrades'] = {'Energy', 'Damage', 'Ghost', 'CritDMG', 'AtkSPD'},
            ['Enabled'] = false
        },
        ['Exchange'] = {
            ['SelectedUpgrades'] = {'Energy', 'Damage', 'Ghost', 'Drop', 'EggLuck', 'GachaLuck', 'EnemyRange'},
            ['Enabled'] = false
        },
        ['CrewMastery'] = {
            ['SelectedUpgrades'] = {'Start', 'Energy', 'Damage', 'Ghost', 'EggLuck', 'GachaLuck', 'AtkSPD'},
            ['Enabled'] = false
        },
        ['Relics'] = {
            ['SelectedRelics'] = {'WingsOfFreedom', 'CursedBalls', 'HollowMask', 'HunterDaggers', 'StrawHat', 'PillarNecklace', 'KaijuMask', 'HorseSpinner'},
            ['Enabled'] = false,
            ['SmartEvolve'] = false
        },
        ['StandMastery'] = {
            ['SelectedUpgrades'] = {'Start', 'Energy', 'Damage', 'Ghost', 'CritDMG', 'Drop', 'WalkSPD'},
            ['Enabled'] = false
        }
    },
    ['Exchange'] = {
        ['Potions'] = {
            ['Tier1'] = {
                ['SelectedPotions'] = {'EnergyPotion1', 'DamagePotion1', 'GhostPotion1', 'LuckPotion1', 'DropPotion1'},
                ['Enabled'] = false
            },
            ['Tier2'] = {
                ['SelectedPotions'] = {'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'},
                ['Enabled'] = false
            },
            ['OnlyWhenFull'] = false
        },
        ['Currency'] = {
            ['Sell'] = {
                ['Tokens'] = {'PassiveTokens', 'WeaponTokens', 'AvatarTokens', 'TraitShards', 'MountTokens', 'EnchantmentTokens', 'SerumTokens', 'TitanTokens', 'BloodlineTokens', 'PsychicTokens', 'AlienTokens', 'PossessionTokens', 'ShinigamiTokens', 'ZanpakutoTokens', 'SoulTokens', 'ShadowTokens', 'HunterTokens', 'MonarchTokens', 'HakiColorTokens', 'MarineTokens', 'FruitTokens', 'CrewTokens', 'PirateTokens', 'SlayerTokens', 'DemonTokens', 'BlessingTokens', 'BreathingTokens'},
                ['Enabled'] = false
            },
            ['Buy'] = {
                ['Tokens'] = {'PassiveTokens', 'WeaponTokens', 'AvatarTokens', 'TraitShards', 'MountTokens', 'EnchantmentTokens', 'SerumTokens', 'TitanTokens', 'BloodlineTokens', 'PsychicTokens', 'AlienTokens', 'PossessionTokens', 'ShinigamiTokens', 'ZanpakutoTokens', 'SoulTokens', 'ShadowTokens', 'HunterTokens', 'MonarchTokens', 'HakiColorTokens', 'MarineTokens', 'FruitTokens', 'CrewTokens', 'PirateTokens', 'SlayerTokens', 'DemonTokens', 'BlessingTokens', 'BreathingTokens'},
                ['Enabled'] = false
            }
        }
    },
    ['AutoSpin'] = {
        ['Avatar'] = false,
        ['Weapons'] = {
            ["Blood-Red"] = false,
            ["Dark Blade"] = false
        },
        ['Traits'] = false,
        ['RemoveAnimation'] = false,
        ['WeaponBuffs'] = {
            ['SelectedWeapon'] = 'None',
            ['SelectedEnchant'] = {"Electric6"},
            ['SelectedBreathing'] = {'Mist'},
            ['Enchant'] = false,
            ['Breathing'] = false
        },
        ['PetBuffs'] = {
            ['SelectedPet'] = 'None',
            ['SelectedPassive'] = {'Phantom'},
            ['Passive'] = false
        }
    },
    ['Keybinds'] = {
		['menuKeybind'] = 'LeftShift'
	}
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

-- task.spawn(function()
--     while task.wait(0.1) and not Library.Unloaded do
--         settings = HttpService:JSONDecode(readfile(saveFile))
--         SaveConfig()
--     end
-- end)

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
local GeneralTimeRewards = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("TimeRewardData"):WaitForChild("General"))

if not ScriptLibrary then repeat task.wait() until ScriptLibrary.PlayerData end

local playerMap = "1"
local playerMode = nil

local AnimeGhosts = {}
AnimeGhosts.EnemyData = {}
AnimeGhosts.WeaponData = {}
AnimeGhosts.AvatarData = {}
AnimeGhosts.WeaponNameLookup = {}
AnimeGhosts.HeroNameLookup = {}

local worldsNames = {
    "Loading Docks",
    "Supernatural Farm",
    "Spirit Town",
    "Double Dungeon",
    "Egg Island",
    "Demon District",
    "Kaiju City",
    "Bizarre Desert"
}

local worldsTable = {
    ["Loading Docks"] = "1",
	["Supernatural Farm"] = "2",
	["Spirit Town"] = "3",
	["Double Dungeon"] = "4",
    ["Egg Island"] = "5",
    ["Demon District"] = "6",
    ["Kaiju City"] = "7",
    ["Bizarre Desert"] = "8"
}

local worldsTableNumbers = {
    ["Loading Docks"] = 1,
    ["Supernatural Farm"] = 2,
    ["Spirit Town"] = 3,
    ["Double Dungeon"] = 4,
    ["Egg Island"] = 5,
    ["Demon District"] = 6,
    ["Kaiju City"] = 7,
    ["Bizarre Desert"] = 8
}

local numbersToWorlds = {
    [1] = "Loading Docks",
    [2] = "Supernatural Farm",
    [3] = "Spirit Town",
    [4] = "Double Dungeon",
    [5] = "Egg Island",
    [6] = "Demon District",
    [7] = "Kaiju City",
    [8] = "Bizarre Desert"
}

local scrolls = {
    'Titan Scroll',
    'Supernatural Scroll',
    'Spiritual Scroll',
    'Solo Scroll',
    'Punk Scroll',
    'Slayer Scroll',
    'Kaiju Scroll',
    'Bizarre Scroll'
}

local dungeonMaps = {
    "CrystalCave",
    "PunkCity"
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

local function FireBridge(...)
    local args = {...}
    args.n = #args
    pcall(function()
        local Event = game:GetService("ReplicatedStorage"):FindFirstChild("ffrostflame_bridgenet2@1.0.0")
        if Event then Event = Event.dataRemoteEvent end
        if Event then
            Event:FireServer({args, "\x02"})
        elseif ScriptLibrary and ScriptLibrary.Remote then
            ScriptLibrary.Remote:Fire(table.unpack(args))
        end
    end)
end

local function GetInventoryData(categoryName)
    local formattedItems = {}
    local RS = game:GetService("ReplicatedStorage")

    local rarityColors = {
        Common = Color3.fromRGB(180, 180, 180),
        Uncommon = Color3.fromRGB(0, 255, 0),
        Rare = Color3.fromRGB(0, 255, 204),
        Epic = Color3.fromRGB(170, 0, 255),
        Legendary = Color3.fromRGB(255, 170, 0),
        Mythic = Color3.fromRGB(255, 0, 128),
        Mythical = Color3.fromRGB(255, 0, 128),
        Secret = Color3.fromRGB(255, 50, 50)
    }

    pcall(function()
        local RarityData = require(RS:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("RarityData"))
        if RarityData then
            for name, data in pairs(RarityData) do
                if data.Color then rarityColors[name] = data.Color end
            end
        end
    end)

    local itemLookup = {}
    pcall(function()
        local DataPath = RS:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data")
        local CurrencyData = require(DataPath:WaitForChild("CurrencyData"))
        if CurrencyData then
            for id, info in pairs(CurrencyData) do
                itemLookup[id] = {
                    Name = info.Name or id,
                    Icon = info.Icon or "rbxassetid://10138402123",
                    Color = info.Color or rarityColors[info.Rarity] or Color3.fromRGB(0, 255, 255)
                }
            end
        end

        local ItemDataFolder = DataPath:FindFirstChild("ItemData")
        if ItemDataFolder then
            for _, child in ipairs(ItemDataFolder:GetChildren()) do
                pcall(function()
                    local moduleData = require(child)
                    if type(moduleData) == 'table' then
                        for id, info in pairs(moduleData) do
                            itemLookup[id] = {
                                Name = info.Name or id,
                                Icon = info.Icon or "rbxassetid://10138402123",
                                Color = rarityColors[info.Rarity] or Color3.fromRGB(0, 255, 255),
                                Desc = info.Desc
                            }
                        end
                    end
                end)
            end
        end
    end)

    pcall(function()
        local CenterGUI = player.PlayerGui:FindFirstChild("CenterGUI")
        local Content = CenterGUI and CenterGUI:FindFirstChild("Inventory") and CenterGUI.Inventory:FindFirstChild("Content")
        if not Content then return end
            
        local targetFolder = categoryName and Content:FindFirstChild(categoryName) or Content:FindFirstChild("Items")
        if not targetFolder then return end
            
        local invScroll = targetFolder:FindFirstChild("Scroll") or targetFolder:FindFirstChild("ContentPage") or targetFolder
        if invScroll then
            for _, slot in ipairs(invScroll:GetChildren()) do
                if slot:IsA("Frame") or slot:IsA("ImageButton") or slot:IsA("TextButton") then
                    if slot.Name == "UIGridLayout" or slot.Name == "UIListLayout" then continue end
                        
                    local itemId = slot.Name
                    local lookup = itemLookup[itemId]
                    local iconImage = "rbxassetid://10138402123"
                    local amount = 1
                    local itemName = itemId
                    local itemColor = Color3.fromRGB(0, 255, 255)
                        
                    if lookup then
                        itemName = lookup.Name; iconImage = lookup.Icon; itemColor = lookup.Color
                    else
                        local img = slot:FindFirstChildWhichIsA("ImageLabel", true)
                        if img then iconImage = img.Image end
                            
                        for _, child in ipairs(slot:GetDescendants()) do
                            if child:IsA("TextLabel") and not tonumber(child.Text) and child.Text ~= "" and #child.Text > 1 then
                                itemName = child.Text; break
                            end
                        end
                    end
                        
                    for _, child in ipairs(slot:GetDescendants()) do
                        if child:IsA("TextLabel") then
                            local num = tonumber(child.Text:match("%d+"))
                            if num and num > 0 then amount = num; break end
                        end
                    end
                        
                    table.insert(formattedItems, {Name = itemName, Icon = iconImage, Amount = amount, Color = itemColor, RawName = itemId})
                end
            end
        end
    end)

    if #formattedItems == 0 and not categoryName then
        pcall(function()
            local GachaData = require(RS:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("GachaData"))
            if GachaData then
                for _, gachaInfo in pairs(GachaData) do
                    if gachaInfo.Targets then
                        for targetId, targetData in pairs(gachaInfo.Targets) do
                            table.insert(formattedItems, { Name = targetData.Name or targetId, Icon = targetData.Icon or "rbxassetid://10138402123", Amount = 1, Color = rarityColors[targetData.Rarity] or Color3.fromRGB(0, 255, 255), RawName = targetId })
                        end
                    end
                end
            end
        end)
    end

    if #formattedItems == 0 then
        pcall(function()
            if ScriptLibrary and ScriptLibrary.PlayerData then
                local playerData = ScriptLibrary.PlayerData
                local invTable = playerData.Inventory or playerData.Weapons or playerData.Pets or {}
                    
                if categoryName == "Weapons" and playerData.Weapons then invTable = playerData.Weapons
                elseif (categoryName == "Avatars" or categoryName == "Pets") and (playerData.Avatars or playerData.Pets) then invTable = playerData.Avatars or playerData.Pets end
                    
                if type(invTable) == "table" then
                    for itemName, itemData in pairs(invTable) do
                        if type(itemData) == "table" then
                            local lookup = itemLookup[itemName]
                            table.insert(formattedItems, { Name = (lookup and lookup.Name) or tostring(itemName), Icon = (lookup and lookup.Icon) or itemData.Icon or "rbxassetid://10138402123", Amount = itemData.Amount or itemData.Quantity or itemData.Copies or 1, Color = (lookup and lookup.Color) or rarityColors[itemData.Rarity] or Color3.fromRGB(0, 255, 255), RawName = itemName })
                        end
                    end
                end
            end
        end)
    end

    if #formattedItems == 0 then
        table.insert(formattedItems, {
            Name = "Empty Bag",
            Amount = 0,
            Color = Color3.fromRGB(255, 50, 90)
        })
    end

    return formattedItems
end

local function hasTokenAmountToRoll(token)
    local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
    local VIPGamepass = PlayerData and PlayerData.Gamepasses and PlayerData.Gamepasses.VIPGamepass
    local inventory = PlayerData and PlayerData.Inventory

    local amountNeeded = 10
    if VIPGamepass then amountNeeded = 7 else amountNeeded = 10 end

    local tokenAmount = inventory[token]
    if tokenAmount >= amountNeeded then
        return true
    else
        return false
    end
end

local function getItemAmount(item)
    local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
    local VIPGamepass = PlayerData and PlayerData.Gamepasses and PlayerData.Gamepasses.VIPGamepass
    local inventory = PlayerData and PlayerData.Inventory

    if inventory[item] then
        return inventory[item]
    end
end

task.spawn(function()
    local enemyDataModule = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("EnemyData")
    if enemyDataModule then
        for id, info in pairs(require(enemyDataModule)) do
            AnimeGhosts.EnemyData[id] = info.Name or id
        end
    end
end)

task.spawn(function()
    local weaponDataModule = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("WeaponData")
    if weaponDataModule then
        AnimeGhosts.WeaponData = require(weaponDataModule)
    end
end)

task.spawn(function()
    local avatarDataModule = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("AvatarData")
    if avatarDataModule then
        AnimeGhosts.AvatarData = require(avatarDataModule)
    else
        local petDataModule = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("PetData")
        if petDataModule then
            AnimeGhosts.AvatarData = require(petDataModule)
        end
    end
end)

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
                if v:IsA('Folder') and #v:GetChildren() > 0 and (v.Name == tostring("Dungeon_" .. player.UserId) or v.Name == tostring("Raid_" .. player.UserId) or v.Name == tostring("Infinity Castle_" .. player.UserId)) then
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
        if folder:IsA('Folder') and folder.Name == tostring(playerMap) then
            for _, v in pairs(folder:GetChildren()) do
                if v:IsA('Folder') and #v:GetChildren() > 0 then
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
            local targetFolder = checkEnemyInMap(tostring(map))
            --print(targetFolder)
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

local function checkEnemyInGamemode(gamemode)
    local enemyFolder = nil

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']['Gamemode']:GetChildren()) do
        if folder:IsA('Folder') and #folder:GetChildren() > 0 and folder.Name == gamemode.Name then
            enemyFolder = folder
        end
    end

    return enemyFolder
end

local function getEnemyInGamemode(gamemode)
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local distance = math.huge
    local enemy = nil

    for _, enemyFolder in ipairs(Workspace['_ENEMIES']['Server']['Gamemode']:GetChildren()) do
        if enemyFolder:IsA("Folder") then
            local targetFolder = checkEnemyInGamemode(gamemode)
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

local function teleportToEnemyInGamemode(gamemode)
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local enemy = getEnemyInGamemode(gamemode)
    if enemy then
        HumanoidRootPart.CFrame = enemy.CFrame * CFrame.new(0, 3, 5)
    end
end

local function checkEnemyInDefense(defense)
    local enemyFolder = nil

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']['Gamemode']:GetChildren()) do
        if folder:IsA('Folder') and #folder:GetChildren() > 0 and folder.Name == defense.Name then
            enemyFolder = folder
        end
    end

    return enemyFolder
end

local function getEnemyInDefense(defense)
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local distance = math.huge
    local enemy = nil

    for _, enemyFolder in ipairs(Workspace['_ENEMIES']['Server']['Gamemode']:GetChildren()) do
        if enemyFolder:IsA("Folder") then
            local targetFolder = checkEnemyInDefense(defense)

            if targetFolder then
                local mapFolder = Workspace:WaitForChild('_MAP'):WaitForChild('Gamemode'):WaitForChild(targetFolder.Name)
                if mapFolder then
                    local endpoint = mapFolder:WaitForChild('Spots'):WaitForChild('Endpoint1')
                    if endpoint then
                        for _, v in ipairs(targetFolder:GetChildren()) do
                            local HP = v:GetAttribute('HP')
                            local Shield = v:GetAttribute('Shield')

                            if HP and HP > 0 and Shield ~= true then
                                if v:IsA('Part') then
                                    local magnitude = (endpoint.Position - v.Position).magnitude

                                    if magnitude < distance then
                                        distance = magnitude
                                        enemy = v
                                    end
                                end
                            end
                        end
                    end
                end


                -- for _, v in ipairs(targetFolder:GetChildren()) do
                --     local HP = v:GetAttribute('HP')
                --     local Shield = v:GetAttribute('Shield')
    
                --     if HP and HP > 0 and Shield ~= true then
                --         if v:IsA('Part') then
                --             local magnitude = (HumanoidRootPart.Position - v.Position).magnitude
    
                --             if magnitude < distance then
                --                 distance = magnitude
                --                 enemy = v
                --             end
                --         end
                --     end
                -- end
            end
        end
    end

    return enemy
end

local function teleportToEnemyInDefense(defense)
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local enemy = getEnemyInDefense(defense)
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
                local another = v:FindFirstChild("Dungeon_" .. player.UserId) or v:FindFirstChild("Raid_" .. player.UserId) or v:FindFirstChild("Infinity Castle_" .. player.UserId)

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
    local DungeonDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay.Dungeon
    if DungeonDelay == nil then return end

    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < DungeonDelay then
        return true
    else
        return false
    end
end

local function createDungeon(difficulty)
    FireBridge("GamemodeSystem", "Create", "Dungeon", settings['AutoDungeon']['Map'], settings['AutoDungeon']['Difficulty'])
    task.wait(5)
    FireBridge("GamemodeSystem", "Start", "Dungeon", player.UserId)
end

local function getPlayerGamemode()
    local dungeon = nil

    for i, v in pairs(ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode'):GetChildren()) do
        if v:FindFirstChild('Players') and v['Players']:GetAttribute(player.UserId) then
            dungeon = v
        end
    end

    return dungeon
end

local function startDungeon(difficulty)
    if getDungeonCooldown() then return end
    if playerMode == nil then
        createDungeon(difficulty)
        task.wait(3)
    elseif checkDungeon() == 'Dungeon' or playerMode == 'Dungeon' then
        -- teleportToEnemyInMap('Gamemode')
        task.wait()
    end
end

local function startDungeon2()
    if getDungeonCooldown() then return end

    if checkDungeon() == 'Dungeon' or playerMode == 'Dungeon' then
        local gamemode = getPlayerGamemode()
        if gamemode then
            if gamemode:GetAttribute('ModeId') == 'Dungeon' and gamemode:GetAttribute('MapId') == settings['AutoDungeon']['Map'] and gamemode:GetAttribute('Diff') == settings['AutoDungeon']['Difficulty'] then
                teleportToEnemyInGamemode(gamemode)
                task.wait()
            end
        end
    end
end

local function getRaidCooldown()
    local RaidDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay.Raid
    if RaidDelay == nil then return end

    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < RaidDelay then
        return true
    else
        return false
    end
end

local function createRaid()
    FireBridge("GamemodeSystem", "Create", "Raid", settings['AutoRaid']['Map'], "Easy")
    task.wait(5)
    FireBridge("GamemodeSystem", "Start", "Raid", player.UserId)
end

local function startRaid()
    if getRaidCooldown() then return end
    if playerMode == nil then
        createRaid()
        task.wait(3)
    elseif checkDungeon() == 'Raid' or playerMode == 'Raid' then
        --teleportToEnemyInMap('Gamemode')
        task.wait()
    end
end

local function startRaid2()
    if getRaidCooldown() then return end

    if checkDungeon() == 'Raid' or playerMode == 'Raid' then
        local gamemode = getPlayerGamemode()
        if gamemode then
            if gamemode:GetAttribute('ModeId') == 'Raid' then
                teleportToEnemyInGamemode(gamemode)
                task.wait()
            end
        end
    end
end

-- local AutoFarm = Tabs['Main']:AddLeftGroupbox('Auto Farm')
-- AutoFarm:AddToggle('enableAutoFarm', {
--     Text = 'Enable Auto Farm',
--     Default = settings['AutoFarm']['Enabled'],

--     Callback = function(value)
--         settings['AutoFarm']['Enabled'] = value
--         SaveConfig()
--     end
-- })

local AutoScroll = Tabs['Main']:AddLeftGroupbox('Auto Scroll')
AutoScroll:AddDropdown('selectedScroll', {
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
            local playerGamemode = getPlayerGamemode()

            if not playerGamemode and playerMode ~= 'Dungeon' and playerMode ~= 'Raid' and playerMode ~= 'Defense Mode' then
                local args = {{{"PetSystem", "Open", settings['AutoScroll']['SelectedScroll'], "All", n = 4 }, "\002" }}
                game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
            end
        end 
    end
end)

local PotionsList = {"EnergyPotion1", "EnergyPotion2", "EnergyPotion3", "EnergyPotion4", "DamagePotion1", "DamagePotion2", "DamagePotion3", "DamagePotion4", "DropPotion1", "DropPotion2", "DropPotion3", "DropPotion4", "GhostPotion1", "GhostPotion2", "GhostPotion3", "GhostPotion4", "LuckPotion1", "LuckPotion2", "LuckPotion3", "LuckPotion4"}
local AutoPotions = Tabs['Main']:AddLeftGroupbox('Auto Potions')
AutoPotions:AddDropdown('selectedPotions', {
    Values = PotionsList,
    Default = settings['AutoPotions']['SelectedPotions'], -- number index of the value / string
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'Selected Potions',
    Tooltip = 'Selected Potions to use', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoPotions']['SelectedPotions'] = value
        SaveConfig()
    end
})

AutoPotions:AddToggle('enableAutoPotions', {
    Text = 'Auto Use Potions',
    Default = settings['AutoPotions']['Enabled'],

    Callback = function(value)
        settings['AutoPotions']['Enabled'] = value
        SaveConfig()
    end
})

AutoPotions:AddToggle('enableAutoPotionsOnlyWhenFull', {
    Text = 'Only When Full',
    Default = settings['AutoPotions']['OnlyWhenFull'],

    Callback = function(value)
        settings['AutoPotions']['OnlyWhenFull'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.2) and not Library.Unloaded do
        if settings['AutoPotions']['Enabled'] then
            for _, potion in pairs(settings['AutoPotions']['SelectedPotions']) do
                if settings['AutoPotions']['OnlyWhenFull'] then
                    if getItemAmount(potion) > 90 then
                        FireBridge("ItemSystem", "Use", tostring(potion))
                    end
                else
                    FireBridge("ItemSystem", "Use", tostring(potion))
                end
            end
        end
    end
end)

local Misc = Tabs['Main']:AddLeftGroupbox('Miscellaneous')
Misc:AddToggle('enableAutoAttack', {
    Text = 'Auto Attack',
    Default = settings['Misc']['AutoAttack'],

    Callback = function(value)
        settings['Misc']['AutoAttack'] = value
        SaveConfig()
    end
})

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
                                    teleportToSavedPosition()
                                    teleportedBack = true
                                end)
                            until ResultsGUI.Enabled == false or Library.Unloaded or not settings['Misc']['TeleportBack'] or not Library.Unloaded
                        end
                    end
                end
            elseif playerMode == nil and hrp.CFrame ~= stringToCFrame(settings['Misc']['BackPosition']) and teleportedBack == false then
                repeat
                    pcall(function()
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

Misc:AddToggle('enableAutoClaimTimeRewards', {
    Text = 'Auto Claim Time Rewards',
    Default = settings['Misc']['TimeRewards'],

    Callback = function(value)
        settings['Misc']['TimeRewards'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(3) and not Library.Unloaded do
        if settings['Misc']['TimeRewards'] then
            local GeneralRewards = GeneralTimeRewards.Rewards
            local playerRewardsTime = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.TimeRewards and ScriptLibrary.PlayerData.TimeRewards.General and ScriptLibrary.PlayerData.TimeRewards.General.Time

            if GeneralRewards then
                for i, v in pairs(GeneralRewards) do
                    local canClaimReward = playerRewardsTime - v.Time > 5

                    if canClaimReward then
                        FireBridge("TimeRewardSystem", "Claim", "General", tonumber(i))
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(3) and not Library.Unloaded do
        if settings['Misc']['TimeRewards'] then
            local button = PlayerGui.CenterGUI.TimeRewards.Main.Content.Reset.Button
            if button and button.Visible then
                FireBridge("TimeRewardSystem", "Reset", "General")
            end
        end
    end
end)

Misc:AddToggle('enableAutoClaimDaily Gems', {
    Text = 'Auto Claim Daily Gems',
    Default = settings['Misc']['DailyGems'],

    Callback = function(value)
        settings['Misc']['DailyGems'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(3) and not Library.Unloaded do
        if settings['Misc']['DailyGems'] then
            local PlayerWeeklyRewards = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.WeeklyRewards and ScriptLibrary.PlayerData.WeeklyRewards.Gems
            local ReplicatedTime = ReplicatedStorage:GetAttribute("Time")

            if not PlayerWeeklyRewards then return end
            if not ReplicatedTime then return end

            local Times = {
                ['HOUR_TIME'] = 3600,
                ['DAILY_TIME'] = 86400
            }

            Times.WEEKLY_TIME = 7 * Times.DAILY_TIME
            Times.EXTRA_TIME = -(1 * Times.DAILY_TIME) - 4 * Times.HOUR_TIME
            local currentDay = math.floor((ReplicatedTime + Times.EXTRA_TIME) % Times.WEEKLY_TIME / Times.DAILY_TIME) + 1
            
            if not PlayerWeeklyRewards.Claimed[tostring(currentDay)] and Times.HOUR_TIME <= PlayerWeeklyRewards.Time then
                FireBridge('WeeklyRewardSystem', 'Claim', 'Gems', currentDay)
            end
        end
    end
end)

local AutoDungeon = Tabs['Main']:AddRightGroupbox('Auto Dungeon')
AutoDungeon:AddDropdown('selectedDungeonMap', {
    Values = dungeonMaps,
    Default = settings['AutoDungeon']['Map'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Dungeon Map',
    Tooltip = 'Selected Auto Dungeon Map', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoDungeon']['Map'] = value
        SaveConfig()
    end
})

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
    Text = 'Auto Create Dungeon',
    Default = settings['AutoDungeon']['Enabled'],

    Callback = function(value)
        settings['AutoDungeon']['Enabled'] = value
        SaveConfig()
    end
})

AutoDungeon:AddToggle('enableAutoDoDungeon', {
    Text = 'Auto do dungeons',
    Default = settings['AutoDungeon']['AutoDungeon'],

    Callback = function(value)
        settings['AutoDungeon']['AutoDungeon'] = value
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
    while task.wait() and not Library.Unloaded do
        if settings['AutoDungeon']['Enabled'] then
            startDungeon(settings['AutoDungeon']['Difficulty'])
            -- local dungeonName = "Dungeon_" .. player.UserId

            -- if settings['AutoDungeon']['AutoLeave'] and playerMode == 'Dungeon' then
            --     local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            --     if Gamemode:FindFirstChild(dungeonName) then
            --         if Gamemode:FindFirstChild(dungeonName):GetAttribute('Stage') >= settings['AutoDungeon']['LeaveWave'] then
            --             teleportToSavedPosition()
            --         end
            --     end
            -- end
        end
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoDungeon']['AutoDungeon'] then
            startDungeon2()

            -- local dungeonName = getPlayerGamemode()
            -- if dungeonName and settings['AutoDungeon']['AutoLeave'] then
            --     local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            --     if Gamemode:FindFirstChild(dungeonName.Name) then
            --         if Gamemode:FindFirstChild(dungeonName.Name):GetAttribute('Stage') >= settings['AutoDungeon']['LeaveWave'] then
            --            teleportToSavedPosition()
            --         end
            --     end
            -- end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        local dungeonName = getPlayerGamemode()

        if settings['AutoDungeon']['AutoLeave'] and dungeonName then
            local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            if Gamemode:FindFirstChild(dungeonName.Name) and Gamemode:FindFirstChild(dungeonName.Name):GetAttribute('ModeId') == 'Dungeon' then
                if Gamemode:FindFirstChild(dungeonName.Name):GetAttribute('Stage') >= settings['AutoDungeon']['LeaveWave'] then
                    teleportToSavedPosition()
                end
            end
        end
    end
end)

local raidMaps = {"TitanTown", "HollowDimension"}
local AutoRaid = Tabs['Main']:AddRightGroupbox('Auto Raid')
AutoRaid:AddDropdown('selectedRaidMap', {
    Values = raidMaps,
    Default = settings['AutoRaid']['Map'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Raid Map',
    Tooltip = 'Selected Auto Raid Map', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoRaid']['Map'] = value
        SaveConfig()
    end
})

AutoRaid:AddToggle('enableAutoRaid', {
    Text = 'Auto Create Raid',
    Default = settings['AutoRaid']['Enabled'],

    Callback = function(value)
        settings['AutoRaid']['Enabled'] = value
        SaveConfig()
    end
})


AutoRaid:AddToggle('enableAutoDoRaid', {
    Text = 'Auto do Raids',
    Default = settings['AutoRaid']['AutoRaid'],

    Callback = function(value)
        settings['AutoRaid']['AutoRaid'] = value
        SaveConfig()
    end
})

AutoRaid:AddSlider('raidLeaveWaveSlider', {
    Text = 'Raid Leave Wave',
    Default = settings['AutoRaid']['LeaveWave'],
    Min = 1,
    Max = 100,
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
    while task.wait() and not Library.Unloaded do
        if settings['AutoRaid']['Enabled'] then
            startRaid()
            local raidName = "Raid_" .. player.UserId

            if settings['AutoRaid']['AutoLeave'] and playerMode == 'Raid' then
                local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
                if Gamemode:FindFirstChild(raidName) then
                    if Gamemode:FindFirstChild(raidName):GetAttribute('Stage') >= settings['AutoRaid']['LeaveWave'] then
                        teleportToSavedPosition()
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoRaid']['AutoRaid'] then
            startRaid2()

            -- local raidName = getPlayerGamemode()
            -- if raidName and settings['AutoRaid']['AutoLeave'] then
            --     local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            --     if Gamemode:FindFirstChild(raidName.Name) then
            --         if Gamemode:FindFirstChild(raidName.Name):GetAttribute('Stage') >= settings['AutoRaid']['LeaveWave'] then
            --            teleportToSavedPosition()
            --         end
            --     end
            -- end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        local raidName = getPlayerGamemode()

        if settings['AutoRaid']['AutoLeave'] and raidName then

            local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            if Gamemode:FindFirstChild(raidName.Name) and Gamemode:FindFirstChild(raidName.Name):GetAttribute('ModeId') == 'Raid' then
                if Gamemode:FindFirstChild(raidName.Name):GetAttribute('Stage') >= settings['AutoRaid']['LeaveWave'] then
                    teleportToSavedPosition()
                end
            end
        end
    end
end)

local AutoInfinityCastle = Tabs['Main']:AddRightGroupbox('Auto Infinity Castle')
local InfinityCastleActs = {'Act1', 'Act2'}
AutoInfinityCastle:AddDropdown('selectedInfinityCastleAct', {
    Values = {'Act1', 'Act2'},
    Default = settings['InfinityCastle']['Act'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Act',
    Tooltip = 'Selected Infinity Castle Act', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['InfinityCastle']['Act'] = value
        SaveConfig()
    end
})

AutoInfinityCastle:AddToggle('enableAutoInfinityCastle', {
    Text = 'Auto Create Infinity Castle',
    Default = settings['InfinityCastle']['Enabled'],

    Callback = function(value)
        settings['InfinityCastle']['Enabled'] = value
        SaveConfig()
    end
})

AutoInfinityCastle:AddToggle('enableAutoDoInfinityCastle', {
    Text = 'Auto do Infinity Castle',
    Default = settings['InfinityCastle']['InfinityCastle'],

    Callback = function(value)
        settings['InfinityCastle']['InfinityCastle'] = value
        SaveConfig()
    end
})

AutoInfinityCastle:AddSlider('infinityCastleLeaveWaveSlider', {
    Text = 'Infinity Castle Leave Wave',
    Default = settings['InfinityCastle']['LeaveWave'],
    Min = 1,
    Max = 50,
    Rounding = 0,
    Compact = false,

    Callback = function(value)
        settings['InfinityCastle']['LeaveWave'] = value
        SaveConfig()
    end
})

AutoInfinityCastle:AddToggle('enableInfinityCastleAutoLeave', {
    Text = 'Auto Leave Infinity Castle at Wave',
    Default = settings['InfinityCastle']['AutoLeave'],

    Callback = function(value)
        settings['InfinityCastle']['AutoLeave'] = value
        SaveConfig()
    end
})

local function getInfinityCastleCooldown()
    local InfinityCastleDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay['Infinity Castle']
    if InfinityCastleDelay == nil then return end

    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < InfinityCastleDelay then
        return true
    else
        return false
    end
end

local function createInfinityCastle()
    FireBridge("GamemodeSystem", "Create", "Infinity Castle", settings['InfinityCastle']['Act'], "Easy")
    task.wait(5)
    FireBridge("GamemodeSystem", "Start", "Infinity Castle", player.UserId)
end

local function startInfinityCastle()
    if getInfinityCastleCooldown() then return end
    if playerMode == nil then
        createInfinityCastle()
        task.wait(3)
    elseif checkDungeon() == 'Infinity Castle' or playerMode == 'Infinity Castle' then
        --teleportToEnemyInMap('Gamemode')
        task.wait()
    end
end

local function startInfinityCastle2()
    if getInfinityCastleCooldown() then return end

    if checkDungeon() == 'Infinity Castle' or playerMode == 'Infinity Castle' then
        local gamemode = getPlayerGamemode()
        if gamemode then
            if gamemode:GetAttribute('ModeId') == 'Infinity Castle' then
                teleportToEnemyInGamemode(gamemode)
                task.wait()
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        if settings['InfinityCastle']['Enabled'] then
            startInfinityCastle()
            local raidName = "Infinity Castle_" .. player.UserId

            if settings['InfinityCastle']['AutoLeave'] and playerMode == 'Infinity Castle' then
                local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
                if Gamemode:FindFirstChild(raidName) then
                    if Gamemode:FindFirstChild(raidName):GetAttribute('Stage') >= settings['InfinityCastle']['LeaveWave'] then
                        teleportToSavedPosition()
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['InfinityCastle']['InfinityCastle'] then
            startInfinityCastle2()
        end
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local infCastleName = getPlayerGamemode()

        if settings['InfinityCastle']['AutoLeave'] and infCastleName then
            local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            if Gamemode:FindFirstChild(infCastleName.Name) and Gamemode:FindFirstChild(infCastleName.Name):GetAttribute('ModeId') == 'Infinity Castle' then
                if Gamemode:FindFirstChild(infCastleName.Name):GetAttribute('Stage') >= settings['InfinityCastle']['LeaveWave'] then
                    teleportToSavedPosition()
                end
            end
        end
    end
end)

local AutoDefenseMode = Tabs['Main']:AddRightGroupbox('Auto Defense Mode')
AutoDefenseMode:AddToggle('enableAutoDefenseMode', {
    Text = 'Auto Create Defense Mode',
    Default = settings['DefenseMode']['Enabled'],

    Callback = function(value)
        settings['DefenseMode']['Enabled'] = value
        SaveConfig()
    end
})

AutoDefenseMode:AddToggle('enableAutoDoDefenseMode', {
    Text = 'Auto do Defense Mode',
    Default = settings['DefenseMode']['DefenseMode'],

    Callback = function(value)
        settings['DefenseMode']['DefenseMode'] = value
        SaveConfig()
    end
})

AutoDefenseMode:AddSlider('defenseModeLeaveWaveSlider', {
    Text = 'Defense Mode Leave Wave',
    Default = settings['DefenseMode']['LeaveWave'],
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,

    Callback = function(value)
        settings['DefenseMode']['LeaveWave'] = value
        SaveConfig()
    end
})

AutoDefenseMode:AddToggle('enableDefenseModeAutoLeave', {
    Text = 'Auto Leave Defense Mode',
    Default = settings['DefenseMode']['AutoLeave'],

    Callback = function(value)
        settings['DefenseMode']['AutoLeave'] = value
        SaveConfig()
    end
})

local function getDefenseModeCooldown()
    local DefenseModeDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay['Defense Mode']
    if DefenseModeDelay == nil then return end

    local Time = ReplicatedStorage:GetAttribute('Time')

    if Time < DefenseModeDelay then
        return true
    else
        return false
    end
end

local function createDefenseMode()
    FireBridge("GamemodeSystem", "Create", "Defense Mode", "BizarreDesert", "Easy")
    task.wait(5)
    FireBridge("GamemodeSystem", "Start", "Defense Mode", player.UserId)
end

local function startDefenseMode()
    if getDefenseModeCooldown() then return end
    if playerMode == nil then
        createDefenseMode()
        task.wait(3)
    elseif checkDungeon() == 'Defense Mode' or playerMode == 'Defense Mode' then
        --teleportToEnemyInMap('Gamemode')
        task.wait()
    end
end

local function startDefenseMode2()
    if getDefenseModeCooldown() then return end

    if checkDungeon() == 'Defense Mode' or playerMode == 'Defense Mode' then
        local gamemode = getPlayerGamemode()
        if gamemode then
            if gamemode:GetAttribute('ModeId') == 'Defense Mode' then
                --teleportToEnemyInGamemode(gamemode)
                teleportToEnemyInDefense(gamemode)
                task.wait()
            end
        end
    end
end

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['DefenseMode']['Enabled'] then
            startDefenseMode()
            local raidName = "Defense Mode_" .. player.UserId

            if settings['DefenseMode']['AutoLeave'] and playerMode == 'Defense Mode' then
                local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
                if Gamemode:FindFirstChild(raidName) then
                    if Gamemode:FindFirstChild(raidName):GetAttribute('Stage') >= settings['DefenseMode']['LeaveWave'] then
                        teleportToSavedPosition()
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['DefenseMode']['DefenseMode'] then
            startDefenseMode2()
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) and not Library.Unloaded do
        local defModeName = getPlayerGamemode()

        if settings['DefenseMode']['AutoLeave'] and defModeName then
            local Gamemode = ReplicatedStorage:WaitForChild('Server'):WaitForChild('Gamemode')
            if Gamemode:FindFirstChild(defModeName.Name) and Gamemode:FindFirstChild(defModeName.Name):GetAttribute('ModeId') == 'Defense Mode' then
                if Gamemode:FindFirstChild(defModeName.Name):GetAttribute('Stage') >= settings['DefenseMode']['LeaveWave'] then
                    teleportToSavedPosition()
                end
            end
        end
    end
end)

local Timers = Tabs['Main']:AddLeftGroupbox('Timers')
local DungeonCooldown = Timers:AddLabel("DUNGEON     >> ", true)
local RaidCooldown = Timers:AddLabel("RAID        >> ", true)
local InfCastleCooldown = Timers:AddLabel("INF CASTLE  >> ", true)
local DefModeCooldown = Timers:AddLabel("DEF MODE    >> ", true)

local dungeonMessage = 'DUNGEON     >> '
local raidMessage = 'RAID        >> '
local infCastleMessage = 'INF CASTLE  >> '
local defModeMessage = 'DEF MODE    >> '

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local RaidDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay.Raid
        if RaidDelay == nil then return end
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < RaidDelay then
            raidMessage = "in " .. tostring(getTime(RaidDelay - Time))
        else
            raidMessage = 'READY !'
        end

        RaidCooldown:SetText('RAID        >> ' .. raidMessage)
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local DungeonDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay.Dungeon
        if DungeonDelay == nil then return end
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < DungeonDelay then
            dungeonMessage = "in " .. tostring(getTime(DungeonDelay - Time))
        else
            dungeonMessage = 'READY !'
        end

        DungeonCooldown:SetText('DUNGEON     >> ' .. dungeonMessage)
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local InfinityCastleDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay['Infinity Castle']

        if InfinityCastleDelay == nil then return end
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < InfinityCastleDelay then
            infCastleMessage = "in " .. tostring(getTime(InfinityCastleDelay - Time))
        else
            infCastleMessage = 'READY !'
        end

        InfCastleCooldown:SetText('INF CASTLE  >> ' .. infCastleMessage)
    end
end)

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        local DefenseModeDelay = ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Delay['Defense Mode']

        if DefenseModeDelay == nil then return end
        local Time = ReplicatedStorage:GetAttribute('Time')

        if Time < DefenseModeDelay then
            defModeMessage = "in " .. tostring(getTime(DefenseModeDelay - Time))
        else
            defModeMessage = 'READY !'
        end

        DefModeCooldown:SetText('DEF MODE    >> ' .. defModeMessage)
    end
end)

local AutoGacha = Tabs['Gachas']:AddLeftGroupbox("Auto Gachas")
local UnifiedFilters = {
    Electric6 = true,
    Haunt6 = true,
    Blessed6 = true,
    Ruin6 = true,
    Secret = true,
    Phantom = true,
    Holy = true,
    ColossalTitan = true,
    Ackerman = true,
    ColossalSerum = true,
    EvilEye = true,
	Singularity = true,
    Earth = true,
    TrueQuincy = true,
    Nozarashi = true,
    National = true,
    DragonFruit = true,
    BlackHaki = true,
    Blessing6 = true,
    Blessing5 = true,
    Mist = true,
    Flame = true
}

AutoGacha:AddToggle('enableDeleteSpinAnimation', {
    Text = 'Remove Spin Animation',
    Default = settings['AutoSpin']['RemoveAnimation'],

    Callback = function(value)
        settings['AutoSpin']['RemoveAnimation'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        pcall(function()
            if settings['AutoSpin']['RemoveAnimation'] and not Library.Unloaded then
                local GachaAnimation = player.PlayerGui:FindFirstChild("GachaAnimation")
                if GachaAnimation then
                    GachaAnimation.Enabled = false
                    local root = GachaAnimation:FindFirstChild("Root")
                    if root then
                        root.Visible = false
                    end
                end
            end
        end)

        pcall(function()
            local StarterGachaAnimation = game:GetService("StarterGui"):FindFirstChild("GachaAnimation")
            if StarterGachaAnimation then
                StarterGachaAnimation:Destroy()
            end
        end)
    end
end)

AutoGacha:AddDivider()

AutoGacha:AddToggle('enableAutoSpinAvatar', {
    Text = 'Spin Avatar',
    Default = settings['AutoSpin']['Avatar'],

    Callback = function(value)
        settings['AutoSpin']['Avatar'] = value
        SaveConfig()
    end
})

AutoGacha:AddToggle('enableAutoSpinWeapons', {
    Text = 'Spin Weapons (Blood-Red)',
    Default = settings['AutoSpin']['Weapons']['Blood-Red'],

    Callback = function(value)
        settings['AutoSpin']['Weapons']['Blood-Red'] = value
        SaveConfig()
    end
})

AutoGacha:AddToggle('enableAutoSpinWeapons2', {
    Text = 'Spin Weapons (Dark Blade)',
    Default = settings['AutoSpin']['Weapons']['Dark Blade'],

    Callback = function(value)
        settings['AutoSpin']['Weapons']['Dark Blade'] = value
        SaveConfig()
    end
})

AutoGacha:AddToggle('enableAutoSpinTraits', {
    Text = 'Spin Traits',
    Default = settings['AutoSpin']['Traits'],

    Callback = function(value)
        settings['AutoSpin']['Traits'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoSpin']['Avatar'] then
            if hasTokenAmountToRoll("AvatarTokens") then
                FireBridge("GachaSystem", "Spin", "Avatar", "Classic", UnifiedFilters)
            end
        end

        if settings['AutoSpin']['Weapons']['Blood-Red'] then
            if hasTokenAmountToRoll("WeaponTokens") then
                FireBridge("GachaSystem", "Spin", "Weapon", "Blood-Red", UnifiedFilters)
            end
        end

        if settings['AutoSpin']['Weapons']['Dark Blade'] then
            if hasTokenAmountToRoll("WeaponTokens") then
                FireBridge("GachaSystem", "Spin", "Weapon", "Dark Blade", UnifiedFilters)
            end
        end

        if settings['AutoSpin']['Traits'] then
            if hasTokenAmountToRoll("TraitShards") then
                FireBridge("ItemSystem", "RollTrait", "Trait")
            end
        end
    end
end)

local PetBuffs = Tabs['Gachas']:AddLeftGroupbox("Pet Buffs")
PetBuffs:AddLabel("SELECTED PET INFO")
local SelectedPetName = PetBuffs:AddLabel("NAME >> ", true)
local SelectedPetPassive = PetBuffs:AddLabel("PASSIVE >> ", true)
PetBuffs:AddDivider()

local PetList = {'None'}
local PassiveList = {'None', 'Fated', 'Whisper', 'Holy', 'Phantom'}
PetBuffs:AddDropdown('selectedPetDropdown', {
    Values = PetList,
    Default = settings['AutoSpin']['PetBuffs']['SelectedPet'],
    Multi = false,

    Text = 'Selected Pet',
    Tooltip = 'Selected Pet to Roll',

    Callback = function(value)
        settings['AutoSpin']['PetBuffs']['SelectedPet'] = AnimeGhosts.HeroNameLookup[value] or value
        SaveConfig()

        pcall(function()
            if ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Pets then
                local name = ScriptLibrary.PlayerData.Pets[value].Id --AnimeGhosts.AvatarData[ScriptLibrary.PlayerData.Pets[value].Id].Name
                local passive = ScriptLibrary.PlayerData.Pets[value].Buffs and ScriptLibrary.PlayerData.Pets[value].Buffs.Passive or 'None'
            
                SelectedPetName:SetText("NAME >> ".. name)
                SelectedPetPassive:SetText("PASSIVE >> " .. passive)
            end
        end)
    end
})

PetBuffs:AddButton({
    Text = 'Refresh Pets',
    Func = function()
        local newOptions = {"None"}

        pcall(function()
            if ScriptLibrary and ScriptLibrary.PlayerData then
                local pets = ScriptLibrary.PlayerData.Pets
                local avatarData = AnimeGhosts.AvatarData or {}

                if pets then
                    for uuid, avatar in pairs(pets) do
                        local avatarId = avatar.Id or uuid
                        local displayName = (avatarData[avatarId] and avatarData[avatarId].Name) or avatarId

                        displayName = displayName:gsub("%s*%[.*%]", "")
                        AnimeGhosts.HeroNameLookup[displayName] = uuid

                        if not table.find(newOptions, uuid) then
                            table.insert(newOptions, uuid)
                        end
                    end
                end
            end
        end)

        if #newOptions == 1 then
            local inventory = GetInventoryData("Pets")

            for _, item in ipairs(inventory) do
                if item.Name then
                    local cleanName = item.Name:gsub("%s*%[.*%]", "")
                    AnimeGhosts.HeroNameLookup[cleanName] = item.RawName or item.Name
                    table.insert(newOptions, item.cleanName)
                end
            end
        end

        if #newOptions == 1 then table.insert(newOptions, "None Found") end
        if Options['selectedPetDropdown'] and Options['selectedPetDropdown'].SetValues and Options['selectedPetDropdown'].Refresh then
            Options['selectedPetDropdown']:SetValues(newOptions)
        end
    end,
    DoubleClick = false
})

PetBuffs:AddDropdown('selectedPetPassiveToRoll', {
    Values = PassiveList,
    Default = settings['AutoSpin']['PetBuffs']['SelectedPassive'], -- number index of the value / string
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'Selected Pet Passive',
    Tooltip = 'Selected Pet Passive to Roll', -- Information shown when you hover over the dropdown

    Callback = function(value)
        settings['AutoSpin']['PetBuffs']['SelectedPassive'] = value
        SaveConfig()
    end
})

PetBuffs:AddToggle('enableSpinPetPassive', {
    Text = 'Spin Pet Passive',
    Default = settings['AutoSpin']['PetBuffs']['Passive'],

    Callback = function(value)
        settings['AutoSpin']['PetBuffs']['Passive'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoSpin']['PetBuffs']['Passive'] then
            local selectedPassivePet = settings['AutoSpin']['PetBuffs']['SelectedPet']

            if not selectedPassivePet or selectedPassivePet == "None" then task.wait(1); continue end
            if table.find(settings['AutoSpin']['PetBuffs']['SelectedPassive'], "None") then task.wait(1); continue end

            pcall(function()
                local playerData = ScriptLibrary and ScriptLibrary.PlayerData
                local pets = playerData and playerData.Pets
                local petData = pets and pets[selectedPassivePet]
                local currentPassive = petData and petData.Buffs and petData.Buffs.Passive or "None"

                local match = false
                if currentPassive and settings['AutoSpin']['PetBuffs']['SelectedPassive'] then
                    for _, targetPassive in ipairs(settings['AutoSpin']['PetBuffs']['SelectedPassive']) do
                        if string.find(currentPassive, targetPassive) then match = true; break end
                    end
                end

                if not match then
                    if hasTokenAmountToRoll("PassiveTokens") then
                        FireBridge("GachaSystem", "Spin", "Passive", "Normal", UnifiedFilters, selectedPassivePet)
                    end
                else
                    Library:Notify("Passive Hit!", 5)
                    task.wait(0.2)
                    Library:Notify("Matched: " .. tostring(currentPassive), 5)
                end
            end)
        end
    end
end)

local AutoWeaponBuffs = Tabs['Gachas']:AddRightGroupbox("Weapon Buffs")

AutoWeaponBuffs:AddLabel("SELECTED WEAPON INFO")
local SelectedWeaponName = AutoWeaponBuffs:AddLabel("NAME >> ", true)
local SelectedWeaponEnchant = AutoWeaponBuffs:AddLabel("ENCHANT >> ", true)
local SelectedWeaponBreathing = AutoWeaponBuffs:AddLabel("BREATHING >> ", true)
AutoWeaponBuffs:AddDivider()

local WeaponList = {'None'}
local EnchantList = {'None', 'Blessed6', 'Blessed5', 'Haunt6', 'Haunt5', 'Ruin6', 'Ruin5', 'Electric6', 'Electric5'}
local BreathingList = {'None', 'Mist', 'Flame', 'Insect', 'Lightning', 'Water', 'Beast'}

AutoWeaponBuffs:AddDropdown('selectedWeaponDropdown', {
    Values = WeaponList,
    Default = settings['AutoSpin']['WeaponBuffs']['SelectedWeapon'], -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Selected Weapon',
    Tooltip = 'Selected Weapon to Roll', -- Information shown when you hover over the dropdown

    Callback = function(value)
        --settings['AutoSpin']['WeaponBuffs']['SelectedWeapon'] = value
        settings['AutoSpin']['WeaponBuffs']['SelectedWeapon'] = AnimeGhosts.WeaponNameLookup[value] or value
        SaveConfig()

        pcall(function()
            if ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Weapons then
                local name = AnimeGhosts.WeaponData[ScriptLibrary.PlayerData.Weapons[value].Id].Name
                local enchant = ScriptLibrary.PlayerData.Weapons[value].Buffs and ScriptLibrary.PlayerData.Weapons[value].Buffs.Enchantment or "None"
                local breathing = ScriptLibrary.PlayerData.Weapons[value].Buffs and ScriptLibrary.PlayerData.Weapons[value].Buffs.Breathing or "None"

                SelectedWeaponName:SetText('Name >> ' .. name)
                SelectedWeaponEnchant:SetText('ENCHANT >> ' .. enchant)
                SelectedWeaponBreathing:SetText('BREATHING >> ' .. breathing)
            end
        end)
    end
})

AutoWeaponBuffs:AddButton({
    Text = 'Refresh Weapons',
    Func = function()
        local newOptions = {"None"}

        pcall(function()
            if ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Weapons then
                local weaponData = AnimeGhosts.WeaponData or {}

                for uuid, weapon in pairs(ScriptLibrary.PlayerData.Weapons) do
                    local weaponId = weapon.Id or uuid
                    local displayName = (weaponData[weaponId] and weaponData[weaponId].Name) or weaponId

                    displayName = displayName:gsub("%s*%[.*%]", "")
                    AnimeGhosts.WeaponNameLookup[displayName] = uuid

                    if not table.find(newOptions, uuid) then
                        table.insert(newOptions, uuid)
                    end
                end
            end
        end)

        if #newOptions == 1 then
            local inventory = GetInventoryData("Weapons")

            for _, item in ipairs(inventory) do
                if item.Name then
                    local cleanName = item.Name:gsub("%s*%[.*%]", "")
                    AnimeGhosts.WeaponNameLookup[cleanName] = item.RawName or item.Name
                    table.insert(newOptions, item.cleanName)
                end
            end
        end

        if #newOptions == 1 then table.insert(newOptions, "None Found") end
        if Options['selectedWeaponDropdown'] and Options['selectedWeaponDropdown'].SetValues and Options['selectedWeaponDropdown'].Refresh then
            Options['selectedWeaponDropdown']:SetValues(newOptions)
        end
    end,
    DoubleClick = false
})

AutoWeaponBuffs:AddDropdown('selectedWeaponEnchant', {
    Values = EnchantList,
    Default = settings['AutoSpin']['WeaponBuffs']['SelectedEnchant'], -- number index of the value / string
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'Selected Weapon Enchant',
    Tooltip = 'Selected Enchant to Roll', -- Information shown when you hover over the dropdown

    Callback = function(value)
        --settings['AutoSpin']['WeaponBuffs']['SelectedWeapon'] = value
        settings['AutoSpin']['WeaponBuffs']['SelectedEnchant'] = value
        SaveConfig()
    end
})

AutoWeaponBuffs:AddToggle('enableSpinWeaponEnchant', {
    Text = 'Spin Weapon Enchant',
    Default = settings['AutoSpin']['WeaponBuffs']['Enchant'],

    Callback = function(value)
        settings['AutoSpin']['WeaponBuffs']['Enchant'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoSpin']['WeaponBuffs']['Enchant'] then
            local selectedEnchantWeapon = settings['AutoSpin']['WeaponBuffs']['SelectedWeapon']

            if not selectedEnchantWeapon or selectedEnchantWeapon == "None" then task.wait(1); continue end
            if table.find(settings['AutoSpin']['WeaponBuffs']['SelectedEnchant'], "None") then task.wait(1); continue end

            pcall(function()
                local playerData = ScriptLibrary and ScriptLibrary.PlayerData
                local weapons = playerData and playerData.Weapons
                local weaponData = weapons and weapons[selectedEnchantWeapon]
                local currentEnchant = weaponData and weaponData.Buffs and weaponData.Buffs.Enchantment or "None"

                local match = false
                if currentEnchant and settings['AutoSpin']['WeaponBuffs']['SelectedEnchant'] then
                    for _, targetEnchant in ipairs(settings['AutoSpin']['WeaponBuffs']['SelectedEnchant']) do
                        if string.find(currentEnchant, targetEnchant) then match = true; break end
                    end
                end

                if not match then
                    if hasTokenAmountToRoll("EnchantmentTokens") then
                        FireBridge("GachaSystem", "Spin", "Enchantment", "Normal", UnifiedFilters, selectedEnchantWeapon)
                    end
                else
                    Library:Notify("Enchantment Hit!", 5)
                    task.wait(0.2)
                    Library:Notify("Matched: " .. tostring(currentEnchant), 5)
                end
            end)
        end
    end
end)



task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if ScriptLibrary and ScriptLibrary.PlayerData and ScriptLibrary.PlayerData.Pets and ScriptLibrary.PlayerData.Weapons then
            local selectedPet = settings['AutoSpin']['PetBuffs']['SelectedPet']
            local selectedWeapon = settings['AutoSpin']['WeaponBuffs']['SelectedWeapon']

            if selectedPet == 'None' or selectedWeapon == 'None' then return end

            local selectedPetName = ScriptLibrary.PlayerData.Pets[selectedPet].Id
            local selectedPetPassive = ScriptLibrary.PlayerData.Pets[selectedPet].Buffs and ScriptLibrary.PlayerData.Pets[selectedPet].Buffs.Passive or 'None'

            SelectedPetName:SetText("NAME >> ".. selectedPetName)
            SelectedPetPassive:SetText("PASSIVE >> " .. selectedPetPassive)

            local selectedWeaponName = AnimeGhosts.WeaponData[ScriptLibrary.PlayerData.Weapons[selectedWeapon].Id].Name
            local selectedWeaponEnchant = ScriptLibrary.PlayerData.Weapons[selectedWeapon].Buffs and ScriptLibrary.PlayerData.Weapons[selectedWeapon].Buffs.Enchantment or "None"
            local selectedWeaponBreathing = ScriptLibrary.PlayerData.Weapons[selectedWeapon].Buffs and ScriptLibrary.PlayerData.Weapons[selectedWeapon].Buffs.Breathing or "None"

            SelectedWeaponName:SetText('Name >> ' .. selectedWeaponName)
            SelectedWeaponEnchant:SetText('ENCHANT >> ' .. selectedWeaponEnchant)
            SelectedWeaponBreathing:SetText('BREATHING >> ' .. selectedWeaponBreathing)
        end
    end
end)

local ExchangeUpgradesList = {'Energy', 'Damage', 'Ghost', 'Drop', 'EggLuck', 'GachaLuck', 'EnemyRange'}
local ExchangeUpgrades = Tabs['Upgrades']:AddLeftGroupbox('Exchange Upgrades')
ExchangeUpgrades:AddDropdown('selectedExchangeUpgrades', {
    Values = ExchangeUpgradesList,
    Default = settings['AutoUpgrades']['Exchange']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Exchange Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['Exchange']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

ExchangeUpgrades:AddToggle('enableAutoUpgradesExchange', {
    Text = 'Auto Buy Exchange Upgrades',
    Default = settings['AutoUpgrades']['Exchange']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['Exchange']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['Exchange']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local ExchangeUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Exchange")).Targets
            
            if PlayerInventory and PlayerUpgrades and ExchangeUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['Exchange']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Exchange_' .. upgrade]
                    local UpgradePrice = ExchangeUpgradesData[upgrade].Price * (1.5 ^ PlayerUpgradeLevel)

                    if ExchangeUpgradesData[upgrade].MaxPrice then
                        if UpgradePrice > ExchangeUpgradesData[upgrade].MaxPrice then
                            UpgradePrice = ExchangeUpgradesData[upgrade].MaxPrice
                        end
                    end
                    if UpgradePrice > 2500 and not ExchangeUpgradesData[upgrade].MaxPrice then UpgradePrice = 2500 end

                    if PlayerUpgradeLevel < ExchangeUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("ExchangeTokens") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Exchange", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local DungeonUpgradesList = {'Energy', 'Damage', 'Ghost', 'CritDMG', 'ModeDelay', 'DungeonEnemyScale'}
local DungeonUpgrades = Tabs['Upgrades']:AddLeftGroupbox('Dungeon Upgrades')
DungeonUpgrades:AddDropdown('selectedDungeonUpgrades', {
    Values = DungeonUpgradesList,
    Default = settings['AutoUpgrades']['Dungeon']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Dungeon Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['Dungeon']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

DungeonUpgrades:AddToggle('enableAutoUpgradesDungeon', {
    Text = 'Auto Buy Dungeon Upgrades',
    Default = settings['AutoUpgrades']['Dungeon']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['Dungeon']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['Dungeon']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local DungeonUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Dungeon")).Targets
            
            if PlayerInventory and PlayerUpgrades and DungeonUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['Dungeon']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Dungeon_' .. upgrade]
                    local UpgradePrice = DungeonUpgradesData[upgrade].Price * (2 ^ PlayerUpgradeLevel)

                    if UpgradePrice > 3000 then UpgradePrice = 3000 end

                    if PlayerUpgradeLevel < DungeonUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("DungeonShards") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Dungeon", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local RaidUpgradesList = {'Energy', 'Damage', 'Ghost', 'AtkSPD', 'ModeDelay', 'GachaSpins'}
local RaidUpgrades = Tabs['Upgrades']:AddLeftGroupbox('Raid Upgrades')
RaidUpgrades:AddDropdown('selectedRaidUpgrades', {
    Values = RaidUpgradesList,
    Default = settings['AutoUpgrades']['Raid']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Raid Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['Raid']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

RaidUpgrades:AddToggle('enableAutoUpgradesRaid', {
    Text = 'Auto Buy Raid Upgrades',
    Default = settings['AutoUpgrades']['Raid']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['Raid']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['Raid']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local RaidUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Raid")).Targets
            
            if PlayerInventory and PlayerUpgrades and RaidUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['Raid']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Raid_' .. upgrade]
                    local UpgradePrice = RaidUpgradesData[upgrade].Price * (2 ^ PlayerUpgradeLevel)

                    if UpgradePrice > 3000 and upgrade ~= "GachaSpins" then UpgradePrice = 3000 end

                    if PlayerUpgradeLevel < RaidUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("RaidShards") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Raid", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local DefenseUpgradesList = {'Energy', 'Damage', 'Ghost', 'AtkSPD', 'ModeDelay', 'Defense ModeSpawnSpeed', 'WarriorEquipTitan', 'WarriorEquipShadow', 'WarriorEquipStand'}
local DefenseUpgrades = Tabs['Upgrades']:AddLeftGroupbox('Defense Upgrades')
DefenseUpgrades:AddDropdown('selectedDefenseUpgrades', {
    Values = DefenseUpgradesList,
    Default = settings['AutoUpgrades']['Defense']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Defense Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['Defense']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

DefenseUpgrades:AddToggle('enableAutoUpgradesDefense', {
    Text = 'Auto Buy Defense Upgrades',
    Default = settings['AutoUpgrades']['Defense']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['Defense']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['Defense']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local DefenseUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Defense")).Targets
            
            if PlayerInventory and PlayerUpgrades and DefenseUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['Defense']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Defense_' .. upgrade]
                    local UpgradePrice = DefenseUpgradesData[upgrade].Price * (2 ^ PlayerUpgradeLevel)

                    if DefenseUpgradesData[upgrade].MaxPrice then
                        if UpgradePrice > DefenseUpgradesData[upgrade].MaxPrice then
                            UpgradePrice = DefenseUpgradesData[upgrade].MaxPrice
                        end
                    end

                    if UpgradePrice > 3000 and not DefenseUpgradesData[upgrade].MaxPrice then UpgradePrice = 3000 end

                    if PlayerUpgradeLevel < DefenseUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("DefenseShards") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Defense", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local DivisionUpgradesList = {'Energy', 'Damage', 'Ghost', 'CritDMG', 'AtkSPD'}
local DivisionUpgrades = Tabs['Upgrades']:AddRightGroupbox('Division Upgrades')
DivisionUpgrades:AddDropdown('selectedDivisionUpgrades', {
    Values = DivisionUpgradesList,
    Default = settings['AutoUpgrades']['Division']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Division Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['Division']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

DivisionUpgrades:AddToggle('enableAutoUpgradesDivision', {
    Text = 'Auto Buy Division Upgrades',
    Default = settings['AutoUpgrades']['Division']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['Division']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['Division']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local DivisionUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Division")).Targets
            
            if PlayerInventory and PlayerUpgrades and DivisionUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['Division']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Division_' .. upgrade]
                    local UpgradePrice = DivisionUpgradesData[upgrade].Price * (2 ^ PlayerUpgradeLevel)

                    if UpgradePrice > 2500 then UpgradePrice = 2500 end

                    if PlayerUpgradeLevel < DivisionUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("DivisionTokens") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Division", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local CrewMasteryUpgradesList = {'Start', 'Energy', 'Damage', 'Ghost', 'EggLuck', 'GachaLuck', 'AtkSPD'}
local CrewMasteryUpgrades = Tabs['Upgrades']:AddRightGroupbox('Crew Mastery Upgrades')
CrewMasteryUpgrades:AddDropdown('selectedCrewMasteryUpgrades', {
    Values = CrewMasteryUpgradesList,
    Default = settings['AutoUpgrades']['CrewMastery']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Crew Mastery Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['CrewMastery']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

CrewMasteryUpgrades:AddToggle('enableAutoUpgradesCrewMastery', {
    Text = 'Auto Buy Crew Mastery Upgrades',
    Default = settings['AutoUpgrades']['CrewMastery']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['CrewMastery']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['CrewMastery']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local CrewMasteryUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Crew Mastery")).Targets
            
            if PlayerInventory and PlayerUpgrades and CrewMasteryUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['CrewMastery']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Crew Mastery_' .. upgrade]
                    local UpgradePrice = CrewMasteryUpgradesData[upgrade].Price * (2 ^ PlayerUpgradeLevel)

                    if UpgradePrice > 10000 then UpgradePrice = 10000 end

                    if PlayerUpgradeLevel < CrewMasteryUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("CrewTokens") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Crew Mastery", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local StandMasteryUpgradesList = {'Start', 'Energy', 'Damage', 'Ghost', 'CritDMG', 'Drop', 'WalkSPD'}
local StandMasteryUpgrades = Tabs['Upgrades']:AddRightGroupbox('Stand Mastery Upgrades')
StandMasteryUpgrades:AddDropdown('selectedStandMasteryUpgrades', {
    Values = StandMasteryUpgradesList,
    Default = settings['AutoUpgrades']['StandMastery']['SelectedUpgrades'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Stand Mastery Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['StandMastery']['SelectedUpgrades'] = value
        SaveConfig()
    end
})

StandMasteryUpgrades:AddToggle('enableAutoUpgradesStandMastery', {
    Text = 'Auto Buy Stand Mastery Upgrades',
    Default = settings['AutoUpgrades']['StandMastery']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['StandMastery']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoUpgrades']['StandMastery']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerUpgrades = PlayerData and PlayerData.Upgrades
            local StandMasteryUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Stand Mastery")).Targets
            
            if PlayerInventory and PlayerUpgrades and StandMasteryUpgradesData then
                for _, upgrade in pairs(settings['AutoUpgrades']['StandMastery']['SelectedUpgrades']) do
                    local PlayerUpgradeLevel = PlayerUpgrades['Stand Mastery_' .. upgrade]
                    local UpgradePrice = StandMasteryUpgradesData[upgrade].Price * (2 ^ PlayerUpgradeLevel)

                    if StandMasteryUpgradesData[upgrade].MaxPrice then
                        if UpgradePrice > StandMasteryUpgradesData[upgrade].MaxPrice then
                            UpgradePrice = StandMasteryUpgradesData[upgrade].MaxPrice
                        end
                    end

                    if UpgradePrice > 10000 and not StandMasteryUpgradesData[upgrade].MaxPrice then UpgradePrice = 10000 end

                    if PlayerUpgradeLevel < StandMasteryUpgradesData[upgrade].MaxLevel then
                        if getItemAmount("StandMasteryTokens") >= UpgradePrice then
                            FireBridge("UpgradeSystem", "Buy", "Stand Mastery", upgrade)
                        end
                    end
                end
            end
        end
    end
end)

local RelicsList = {'None', 'WingsOfFreedom', 'CursedBalls', 'HollowMask', 'HunterDaggers', 'StrawHat', 'PillarNecklace', 'KaijuMask', 'HorseSpinner'}
local RelicsUpgrades = Tabs['Upgrades']:AddRightGroupbox('Relics Upgrades')
RelicsUpgrades:AddDropdown('selectedRelicsUpgrades', {
    Values = RelicsList,
    Default = settings['AutoUpgrades']['Relics']['SelectedRelics'],
    Multi = true,

    Text = 'Selected Upgrades to Buy',
    Tooltip = 'Selected Upgrades to Buy from Crew Mastery Upgrades',

    Callback = function(value)
        settings['AutoUpgrades']['Relics']['SelectedRelics'] = value
        SaveConfig()
    end
})

RelicsUpgrades:AddToggle('enableAutoUpgradesRelics', {
    Text = 'Auto Upgrade Relics',
    Default = settings['AutoUpgrades']['Relics']['Enabled'],

    Callback = function(value)
        settings['AutoUpgrades']['Relics']['Enabled'] = value
        SaveConfig()
    end
})

RelicsUpgrades:AddToggle('enableAutoSmartEvolveRelics', {
    Text = 'Evolve with enough tokens',
    Tooltip = 'Evolve only with 25k tokens',
    Default = settings['AutoUpgrades']['Relics']['SmartEvolve'],

    Callback = function(value)
        settings['AutoUpgrades']['Relics']['SmartEvolve'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['AutoUpgrades']['Relics']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local PlayerRelics = PlayerData and PlayerData.Relics
            local CrewMasteryUpgradesData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("UpgradeData"):WaitForChild("Crew Mastery")).Targets
            
            if PlayerInventory and PlayerRelics and CrewMasteryUpgradesData then
                for _, relic in pairs(settings['AutoUpgrades']['Relics']['SelectedRelics']) do
                    if PlayerRelics[relic] then
                        local relicTier = PlayerRelics[relic].Tier
                        local relicLevel = PlayerRelics[relic].Level

                        if relicLevel == 100 and relicTier < 7 then
                            if settings['AutoUpgrades']['Relics']['SmartEvolve'] then
                                if getItemAmount("RelicShards") >= 25000 then
                                    FireBridge("RelicSystem", "Evolve", tostring(relic))
                                end
                            else
                                FireBridge("RelicSystem", "Evolve", tostring(relic))
                            end
                        end

                        if relicLevel < 100 then
                            if getItemAmount("RelicShards") >= 250 then
                                FireBridge("RelicSystem", "Upgrade", tostring(relic))
                            end
                        end
                    end
                end
            end
        end
    end
end)

local CurrencyTokensList = {
    'PassiveTokens',
    'WeaponTokens',
    'AvatarTokens',
    'TraitShards',
    'MountTokens',
    'EnchantmentTokens',
    'SerumTokens',
    'TitanTokens',
    'BloodlineTokens',
    'PsychicTokens',
    'AlienTokens',
    'PossessionTokens',
    'ShinigamiTokens',
    'ZanpakutoTokens',
    'SoulTokens',
    'ShadowTokens',
    'HunterTokens',
    'MonarchTokens',
    'HakiColorTokens',
    'MarineTokens',
    'FruitTokens',
    'CrewTokens',
    'PirateTokens',
    'SlayerTokens',
    'DemonTokens',
    'BlessingTokens',
    'BreathingTokens'
}

local CurrencyExchange = Tabs['Shops']:AddLeftGroupbox('Currency Exchange')
CurrencyExchange:AddDropdown('selectedTokensToSell', {
    Values = CurrencyTokensList,
    Default = settings['Exchange']['Currency']['Sell']['Tokens'],
    Multi = true,

    Text = 'Selected Items to Sell',
    Tooltip = 'Selected Items to Sell for Exchange Tokens',

    Callback = function(value)
        settings['Exchange']['Currency']['Sell']['Tokens'] = value
        SaveConfig()
    end
})

CurrencyExchange:AddDropdown('selectedTokensToBuy', {
    Values = CurrencyTokensList,
    Default = settings['Exchange']['Currency']['Buy']['Tokens'],
    Multi = true,

    Text = 'Selected Items to Buy',
    Tooltip = 'Selected Items to Buy with Exchange Tokens',

    Callback = function(value)
        settings['Exchange']['Currency']['Buy']['Tokens'] = value
        SaveConfig()
    end
})

CurrencyExchange:AddToggle('enableAutoExchangeSell', {
    Text = 'Auto Sell Items',
    Default = false, settings['Exchange']['Currency']['Sell']['Enabled'],

    Callback = function(value)
        settings['Exchange']['Currency']['Sell']['Enabled'] = value
        SaveConfig()
    end
})

CurrencyExchange:AddToggle('enableAutoExchangeBuy', {
    Text = 'Auto Buy Items',
    Default = false, --settings['Exchange']['Currency']['Buy']['Enabled'],

    Callback = function(value)
        settings['Exchange']['Currency']['Buy']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['Exchange']['Currency']['Sell']['Enabled'] and Toggles['enableAutoExchangeSell'].Value then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            if not PlayerInventory then return end

            for _, currency in pairs(settings['Exchange']['Currency']['Sell']['Tokens']) do
                local count = PlayerInventory[currency] or 0

                if count >= 10 then
                    local amountToExchange = math.floor(count / 10)
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Currency', currency, amountToExchange)
                end
            end
        end

        if settings['Exchange']['Currency']['Buy']['Enabled'] and Toggles['enableAutoExchangeBuy'].Value then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local PlayerInventory = PlayerData and PlayerData.Inventory
            if not PlayerInventory then return end

            for _, currency in pairs(settings['Exchange']['Currency']['Buy']['Tokens']) do
                if getItemAmount('ExchangeTokens') >= 1000 then
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Exchange Tokens', tostring('ExchangeTokens' .. currency), 1000)
                elseif getItemAmount('ExchangeTokens') >= 500 then
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Exchange Tokens', tostring('ExchangeTokens' .. currency), 500)
                elseif getItemAmount('ExchangeTokens') >= 100 then
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Exchange Tokens', tostring('ExchangeTokens' .. currency), 100)
                elseif getItemAmount('ExchangeTokens') >= 50 then
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Exchange Tokens', tostring('ExchangeTokens' .. currency), 50)
                elseif getItemAmount('ExchangeTokens') >= 10 then
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Exchange Tokens', tostring('ExchangeTokens' .. currency), 10)
                elseif getItemAmount('ExchangeTokens') >= 1 then
                    FireBridge('ExchangeSystem', 'Make', 'Currency', 'Exchange Tokens', tostring('ExchangeTokens' .. currency), 1)
                end
            end
        end
    end
end)

local DungeonShopItems = {'Gems', 'DungeonTickets', 'EnergyPotion3', 'DamagePotion3', 'GhostPotion3', 'LuckPotion3', 'DropPotion3', 'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'}
local DungeonShop = Tabs['Shops']:AddLeftGroupbox('Dungeon Shop')
DungeonShop:AddDropdown('selectedItems', {
    Values = DungeonShopItems,
    Default = settings['DungeonShop']['SelectedItems'],
    Multi = true,

    Text = 'Selected Items to Buy',
    Tooltip = 'Selected Items to Buy from Dungeon Shop',

    Callback = function(value)
        settings['DungeonShop']['SelectedItems'] = value
        SaveConfig()
    end
})

DungeonShop:AddToggle('enableAutoDungeonShop', {
    Text = 'Auto Buy Items',
    Default = settings['DungeonShop']['Enabled'],

    Callback = function(value)
        settings['DungeonShop']['Enabled'] = value
        SaveConfig()
    end
})

-- DungeonShards
task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['DungeonShop']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local DungeonStockShop = PlayerData and PlayerData.StockShops and PlayerData.StockShops.Dungeon and PlayerData.StockShops.Dungeon.Items
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local DungeonShopData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("StockShopData"):WaitForChild("Dungeon"))

            if DungeonStockShop and DungeonShopData and PlayerInventory then
                for _, item in pairs(settings['DungeonShop']['SelectedItems']) do
                    local itemPrice = DungeonShopData.Items[item].Price

                    if getItemAmount("DungeonShards") >= itemPrice and DungeonStockShop[item] > 0 then
                        FireBridge("StockShopSystem", "Buy", "Dungeon", item, 0)
                    end
                end
            end
        end
    end
end)

local RaidShopItems = {'Gems', 'RaidTickets', 'EnergyPotion3', 'DamagePotion3', 'GhostPotion3', 'LuckPotion3', 'DropPotion3', 'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'}
local RaidShop = Tabs['Shops']:AddLeftGroupbox('Raid Shop')
RaidShop:AddDropdown('selectedRaidShopItems', {
    Values = RaidShopItems,
    Default = settings['RaidShop']['SelectedItems'],
    Multi = true,

    Text = 'Selected Items to Buy',
    Tooltip = 'Selected Items to Buy from Raid Shop',

    Callback = function(value)
        settings['RaidShop']['SelectedItems'] = value
        SaveConfig()
    end
})

RaidShop:AddToggle('enableAutoRaidShop', {
    Text = 'Auto Buy Items',
    Default = settings['RaidShop']['Enabled'],

    Callback = function(value)
        settings['RaidShop']['Enabled'] = value
        SaveConfig()
    end
})

-- RaidShards
task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['RaidShop']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local DungeonStockShop = PlayerData and PlayerData.StockShops and PlayerData.StockShops.Raid and PlayerData.StockShops.Raid.Items
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local RaidShopData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("StockShopData"):WaitForChild("Raid"))

            if DungeonStockShop and RaidShopData and PlayerInventory then
                for _, item in pairs(settings['RaidShop']['SelectedItems']) do
                    local itemPrice = RaidShopData.Items[item].Price

                    if getItemAmount("RaidShards") >= itemPrice and DungeonStockShop[item] > 0 then
                        FireBridge("StockShopSystem", "Buy", "Raid", item, 0)
                    end
                end
            end
        end
    end
end)

local DefenseShopItems = {'Gems', 'DefenseTickets', 'EnergyPotion3', 'DamagePotion3', 'GhostPotion3', 'LuckPotion3', 'DropPotion3', 'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'}
local DefenseShop = Tabs['Shops']:AddLeftGroupbox('Defense Shop')

DefenseShop:AddDropdown('selectedDefenseShopItems', {
    Values = DefenseShopItems,
    Default = settings['DefenseShop']['SelectedItems'],
    Multi = true,

    Text = 'Selected Items to Buy',
    Tooltip = 'Selected Items to Buy from Raid Shop',

    Callback = function(value)
        settings['DefenseShop']['SelectedItems'] = value
        SaveConfig()
    end
})

DefenseShop:AddToggle('enableAutoDefenseShop', {
    Text = 'Auto Buy Items',
    Default = settings['DefenseShop']['Enabled'],

    Callback = function(value)
        settings['DefenseShop']['Enabled'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['DefenseShop']['Enabled'] then
            local PlayerData = ScriptLibrary and ScriptLibrary.PlayerData
            local DefenseStockShop = PlayerData and PlayerData.StockShops and PlayerData.StockShops.Defense and PlayerData.StockShops.Defense.Items
            local PlayerInventory = PlayerData and PlayerData.Inventory
            local DefenseShopData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("StockShopData"):WaitForChild("Defense"))

            if DefenseStockShop and DefenseShopData and PlayerInventory then
                for _, item in pairs(settings['DefenseShop']['SelectedItems']) do
                    local itemPrice = DefenseShopData.Items[item].Price

                    if getItemAmount("DefenseShards") >= itemPrice and DefenseStockShop[item] > 0 then
                        FireBridge("StockShopSystem", "Buy", "Defense", item, 0)
                    end
                end
            end
        end
    end
end)

local PotionExchangeListT1 = {'EnergyPotion1', 'DamagePotion1', 'GhostPotion1', 'LuckPotion1', 'DropPotion1'}
local PotionExchangeListT2 = {'EnergyPotion2', 'DamagePotion2', 'GhostPotion2', 'LuckPotion2', 'DropPotion2'}
local PotionExchange = Tabs['Shops']:AddRightGroupbox('Potion Exchange')
PotionExchange:AddDropdown('selectedExchangePotionsT1', {
    Values = PotionExchangeListT1,
    Default = settings['Exchange']['Potions']['Tier1']['SelectedPotions'],
    Multi = true,

    Text = 'Selected Tier 1 Potions',
    Tooltip = 'Selected Potions to Sacrifice',

    Callback = function(value)
        settings['Exchange']['Potions']['Tier1']['SelectedPotions'] = value
        SaveConfig()
    end
})

PotionExchange:AddDropdown('selectedExchangePotionsT2', {
    Values = PotionExchangeListT2,
    Default = settings['Exchange']['Potions']['Tier2']['SelectedPotions'],
    Multi = true,

    Text = 'Selected Tier 2 Potions',
    Tooltip = 'Selected Potions to Sacrifice',

    Callback = function(value)
        settings['Exchange']['Potions']['Tier2']['SelectedPotions'] = value
        SaveConfig()
    end
})

PotionExchange:AddToggle('enableAutoExchangePotionsT1', {
    Text = 'Exchange Potions (Tier 1)',
    Default = settings['Exchange']['Potions']['Tier1']['Enabled'],

    Callback = function(value)
        settings['Exchange']['Potions']['Tier1']['Enabled'] = value
        SaveConfig()
    end
})

PotionExchange:AddToggle('enableAutoExchangePotionsT2', {
    Text = 'Exchange Potions (Tier 2)',
    Default = settings['Exchange']['Potions']['Tier2']['Enabled'],

    Callback = function(value)
        settings['Exchange']['Potions']['Tier2']['Enabled'] = value
        SaveConfig()
    end
})

PotionExchange:AddToggle('enableExchangePotionsOnlyWhenFull', {
    Text = 'Only When Full',
    Default = settings['Exchange']['Potions']['OnlyWhenFull'],

    Callback = function(value)
        settings['Exchange']['Potions']['OnlyWhenFull'] = value
        SaveConfig()
    end
})

local PotionResults = {
    ["Tier1"] = {
        ["EnergyPotion1"] = "EnergyPotion2",
        ["DamagePotion1"] = "DamagePotion2",
        ["LuckPotion1"] = "LuckPotion2",
        ["GhostPotion1"] = "GhostPotion2",
        ["DropPotion1"] = "DropPotion2"
    },
    ["Tier2"] = {
        ["EnergyPotion2"] = "EnergyPotion3",
        ["DamagePotion2"] = "DamagePotion3",
        ["LuckPotion2"] = "LuckPotion3",
        ["GhostPotion2"] = "GhostPotion3",
        ["DropPotion2"] = "DropPotion3"
    }
}

task.spawn(function()
    while task.wait(0.2) and not Library.Unloaded do
        if settings['Exchange']['Potions']['Tier1']['Enabled'] then
            for _, potion in pairs(settings['Exchange']['Potions']['Tier1']['SelectedPotions']) do
                if settings['Exchange']['Potions']['OnlyWhenFull'] then
                    if getItemAmount(potion) >= 95 and getItemAmount(PotionResults['Tier1'][potion]) < 99  then
                        FireBridge("ExchangeSystem", "Make", "Potion", "Tier 1", tostring(potion), 1)
                    end
                else
                    if getItemAmount(potion) >= 5 and getItemAmount(PotionResults['Tier1'][potion]) < 99 then
                        FireBridge("ExchangeSystem", "Make", "Potion", "Tier 1", tostring(potion), 1)
                    end
                end
            end
        end

        if settings['Exchange']['Potions']['Tier2']['Enabled'] then
            for _, potion in pairs(settings['Exchange']['Potions']['Tier2']['SelectedPotions']) do
                if settings['Exchange']['Potions']['OnlyWhenFull'] then
                    if getItemAmount(potion) >= 95 and getItemAmount(PotionResults['Tier2'][potion]) < 99 then
                        FireBridge("ExchangeSystem", "Make", "Potion", "Tier 2", tostring(potion), 1)
                    end
                else
                    if getItemAmount(potion) >= 5 and getItemAmount(PotionResults['Tier2'][potion]) < 99 then
                        FireBridge("ExchangeSystem", "Make", "Potion", "Tier 2", tostring(potion), 1)
                    end
                end
            end
        end
    end
end)

AutoWeaponBuffs:AddDropdown('selectedWeaponBreathing', {
    Values = BreathingList,
    Default = settings['AutoSpin']['WeaponBuffs']['SelectedBreathing'], -- number index of the value / string
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'Selected Weapon Breathing',
    Tooltip = 'Selected Breathing to Roll', -- Information shown when you hover over the dropdown

    Callback = function(value)
        --settings['AutoSpin']['WeaponBuffs']['SelectedWeapon'] = value
        settings['AutoSpin']['WeaponBuffs']['SelectedBreathing'] = value
        SaveConfig()
    end
})

AutoWeaponBuffs:AddToggle('enableSpinWeaponBreathing', {
    Text = 'Spin Weapon Breathing',
    Default = settings['AutoSpin']['WeaponBuffs']['Breathing'],

    Callback = function(value)
        settings['AutoSpin']['WeaponBuffs']['Breathing'] = value
        SaveConfig()
    end
})

task.spawn(function()
    while task.wait(0.5) and not Library.Unloaded do
        if settings['AutoSpin']['WeaponBuffs']['Breathing'] then
            local selectedEnchantWeapon = settings['AutoSpin']['WeaponBuffs']['SelectedWeapon']

            if not selectedEnchantWeapon or selectedEnchantWeapon == "None" then task.wait(1); continue end
            if table.find(settings['AutoSpin']['WeaponBuffs']['SelectedBreathing'], "None") then task.wait(1); continue end

            pcall(function()
                local playerData = ScriptLibrary and ScriptLibrary.PlayerData
                local weapons = playerData and playerData.Weapons
                local weaponData = weapons and weapons[selectedEnchantWeapon]
                local currentBreathing = weaponData and weaponData.Buffs and weaponData.Buffs.Breathing or "None"

                local match = false
                if currentBreathing and settings['AutoSpin']['WeaponBuffs']['SelectedBreathing'] then
                    for _, targetBreathing in ipairs(settings['AutoSpin']['WeaponBuffs']['SelectedBreathing']) do
                        if string.find(currentBreathing, targetBreathing) then match = true; break end
                    end
                end

                if not match then
                    if hasTokenAmountToRoll("BreathingTokens") then
                        FireBridge("GachaSystem", "Spin", "Breathing", "Normal", UnifiedFilters, selectedEnchantWeapon)
                    end
                else
                    Library:Notify("Breathing Hit!", 5)
                    task.wait(0.2)
                    Library:Notify("Matched: " .. tostring(currentBreathing), 5)
                end
            end)
        end
    end
end)

-- local Testing = Tabs['Testing']:AddRightGroupbox('Testing')

-- local TestingValues = {"_item1", "_item2", "_item3", "_item4", "_item5"}
-- Testing:AddDropdown('selectedTestingValues', {
--     Values = TestingValues,
--     Default = settings['Testing']['Selected2'], -- number index of the value / string
--     Multi = true, -- true / false, allows multiple choices to be selected

--     Text = 'Selected Testing Values',
--     Tooltip = 'Selected Values for Testing', -- Information shown when you hover over the dropdown

--     Callback = function(value)
--         settings['Testing']['Selected2'] = value
--         SaveConfig()
--     end
-- })

local function getEnemyFolderInCurrentMap()
    local enemyFolder = nil

    for _, folder in ipairs(Workspace['_ENEMIES']['Server']:GetChildren()) do
        if folder:IsA('Folder') and folder.Name == tostring(playerMap) and #folder:GetChildren() > 0 then
            enemyFolder = folder
        end
    end

    return enemyFolder
end

local function getEnemyInCurrentMap()
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local distance = math.huge
    local enemy = nil

    local targetFolder = getEnemyFolderInCurrentMap()
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

    return enemy
end

local function getEnemyInGlobalBosses()
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart')
    if not HumanoidRootPart then return end

    local distance = math.huge
    local enemy = nil

    local targetFolder = Workspace['_ENEMIES']['Server']['GlobalBoss']
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

    return enemy
end

local function attack(enemy)
    if enemy then
        FireBridge('ClickSystem', 'Execute', enemy)
        ScriptLibrary.Target = enemy
    else
        FireBridge('ClickSystem', 'Execute')
    end
end

task.spawn(function()
    while task.wait() and not Library.Unloaded do
        if settings['Misc']['AutoAttack'] then
            local playerGamemode = getPlayerGamemode()

            if not playerGamemode then
                local enemyInMap = getEnemyInCurrentMap()

                if playerMap ~= "Lobby" then
                    if enemyInMap then
                        attack(enemyInMap.Name)
                    else
                        attack()
                    end
                else
                    local enemy = getEnemyInGlobalBosses()
                    if enemy then
                        attack(enemy)
                    else
                        attack()
                    end
                end
            else
                local enemy = nil

                if playerMode == 'Dungeon' then
                    enemy = getEnemyInGamemode(playerGamemode)
                elseif playerMode == 'Raid' then
                    enemy = getEnemyInGamemode(playerGamemode)
                elseif playerMode == 'Infinity Castle' then
                    enemy = getEnemyInGamemode(playerGamemode)
                elseif playerMode == 'Defense Mode' then
                    enemy = getEnemyInDefense(playerGamemode)
                end

                if enemy then
                    attack(enemy.Name)
                else
                    attack()
                end
            end
        end
    end
end)

local minute = os.date("%M")
local unixTimestamp
local NoClipping = nil
local Clip = true

function Initialize()
	Library:Notify(string.format('Script Loaded in %.2f second(s)!', tick() - StartTick), 5)
	print("[BeaastHub] Anime Ghosts Loaded")

    ScriptLibrary = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
    GeneralTimeRewards = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("TimeRewardData"):WaitForChild("General"))
end

task.spawn(function()
	while not Library.Unloaded do
		task.wait(0.1)

        settings = HttpService:JSONDecode(readfile(saveFile))
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


local lastActivityTime = tick()
local antiAfkConnection = nil

local function setupAntiAfk()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
    end
    
    antiAfkConnection = player.Idled:Connect(function(idleTime)
        -- Reset idle time when detected
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        print("Anti-AFK triggered - prevented kick")
    end)
    
    -- Additional heartbeat check for activity
    RunService.Heartbeat:Connect(function()
        if tick() - lastActivityTime > 600 then -- 10 minutes safety check
            -- Simulate activity
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
            lastActivityTime = tick()
            print("Anti-AFK heartbeat triggered")
        end
    end)
end

local function updateActivity()
    lastActivityTime = tick()
end

task.spawn(function()
        
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(0, 0))
    task.wait(0.1)
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

    while task.wait(60) do
        updateActivity()
        
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
        task.wait(0.1)
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

pcall(function()
    for _, connection in ipairs(getconnections(player.Idled)) do
        if connection['Disable'] then
            connection:Disable()
        end
    end
end)

Initialize()
setupAntiAfk()