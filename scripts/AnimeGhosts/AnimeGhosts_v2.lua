local animeGhosts = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local global = getgenv and getgenv() or shared

local function Initialize()
    if global.AnimeGhosts then
        pcall(function() global.AnimeGhosts.Running = false end)
        pcall(function() if global.AnimeGhosts.MovementConnection then global.AnimeGhosts.MovementConnection:Disconnect() end end)
        pcall(function() if global.AnimeGhosts.NoClipConnection then global.AnimeGhosts.NoClipConnection:Disconnect() end end)
        pcall(function() if global.AnimeGhosts.RenderSteppedConnection then global.AnimeGhosts.RenderSteppedConnection:Disconnect() end end)
        pcall(function() if global.AnimeGhosts.AntiAfkConnection then global.AnimeGhosts.AntiAfkConnection:Disconnect() end end)

        if global.AnimeGhosts.CurrentHighlight then pcall(function() global.AnimeGhosts.CurrentHighlight:Destroy() end) end
        if global.AnimeGhosts.ScannerHighlight then pcall(function() global.AnimeGhosts.ScannerHighlight:Destroy() end) end
        if global.AnimeGhosts.Platform then pcall(function() global.AnimeGhosts.Platform:Destroy() end) end

        task.wait(0.5)
    end

    global.AnimeGhosts = {}
    local AnimeGhosts = global.AnimeGhosts

    print("/// BEAAST ANIME GHOSTS INITIALIZED - " .. os.date("%X") .. " \\\\\\")

    local SessionID = tostring(math.random(1, 1000000)) .. tostring(tick())
    AnimeGhosts.SessionID = SessionID
    AnimeGhosts.AutoAttack = false
    AnimeGhosts.IsTeleporting = false
    AnimeGhosts.IsQueuingGamemode = false
    _G.IsTransitioningMaps = false
    AnimeGhosts.AutoAscension = false
    AnimeGhosts.SmoothFarm = true
    AnimeGhosts.SelectedPotion = ""
    AnimeGhosts.LastPotionUsed = 0
    AnimeGhosts.GachaDelay = 0.5
    AnimeGhosts.AutoExchange = false
    AnimeGhosts.SelectedExchangeCurrencies = {}
    AnimeGhosts.MapLoadTime = 0

    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local VirtualUser = game:GetService("VirtualUser")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    local RequestFunction = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or nil

    local function SafeSetFont(obj, font)
        pcall(function() obj.Font = font end)
    end

    local UtilityConnections = {}
    local UtilityInstances = {}

    local function trackConnection(connection)
        table.insert(UtilityConnections, connection)
        return connection
    end

    local function trackInstance(instance)
        table.insert(UtilityInstances, instance)
        return instance
    end

    local function unloadUtility()
        AnimeGhosts.Running = false

        for _, connection in ipairs(UtilityConnections) do
            if connection.Connected then pcall(function() connection:Disconnect() end) end
        end

        for _, instance in ipairs(UtilityInstances) do
            if instance and instance.Parent then pcall(function() instance:Destroy() end) end
        end

        if AnimeGhosts.CurrentHighlight then pcall(function() AnimeGhosts.CurrentHighlight:Destroy() end) end
        if AnimeGhosts.Platform then pcall(function() AnimeGhosts.Platform:Destroy() end) end
    
        table.clear(UtilityConnections)
        table.clear(UtilityInstances)
        print("[Beaast Hub - Anime Ghosts] Utility successfully unloaded.")
    end

    local GameLibrary = nil
    pcall(function() GameLibrary = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library")) end)

    AnimeGhosts.EnemyData = {}
    pcall(function()
        local enemyDataModule = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("EnemyData")
    
        if enemyDataModule then
            for id, info in pairs(require(enemyDataModule)) do
                AnimeGhosts.EnemyData[id] = info.Name or id
            end
        end
    end)

    AnimeGhosts.WeaponData = {}
    pcall(function()
        local weaponDataModule = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("WeaponData")
        if weaponDataModule then
            AnimeGhosts.WeaponData = require(weaponDataModule)
        end
    end)

    AnimeGhosts.AvatarData = {}
    pcall(function()
        local avatarData = ReplicatedStorage:FindFirstChild("Framework") and ReplicatedStorage.Framework:FindFirstChild("Modules") and ReplicatedStorage.Framework.Modules:FindFirstChild("Data") and ReplicatedStorage.Framework.Modules.Data:FindFirstChild("AvatarData")
        if avatarData then
            AnimeGhosts.WeaponData = require(avatarData)
        end
    end)

    AnimeGhosts.TargetSettings = { ScanRange = 3000, TickRate = 0 }
    local TargetState = { CurrentTarget = nil, IsAttacking = false }

    local function IsEnemyAlive(enemy)
        if enemy:GetAttribute("Dead") or enemy:GetAttribute("Shield") then return false end

        local billboard = enemy:FindFirstChild("EnemyBillboard")
        if billboard and billboard:FindFirstChild("Amount") and billboard.Amount:IsA("TextLabel") then
            local hpMatch = string.match(billboard.Amount.Text, "^%s*([%d%.]+[kKmMbBtTqQ]?)") or string.match(billboard.Amount.Text, "(%d+)")
            if hpMatch and tostring(hpMatch) ~= 0 then return true end
            return false
        end

        local humanoid = enemy:FindFirstChild("Humanoid")
        if humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then return true end
       
        return false
    end

    local function GetRealEnemyName(model)
        local enemyData = AnimeGhosts.EnemyData
        if enemyData and enemyData[model.Name] then return enemyData[model.Name] end

        local billboard = model:FindFirstChild("EnemyBillboard")
        if billboard and billboard:FindFirstChild("Title") and billboard.Title:IsA("Textlabel") then
            local rawName = billboard.Title.Text:gsub("<[^>]+>", "")
            if rawName ~= "" then return rawName end
        end

        local humanoid = model:FindFirstChild("Humanoid")
        if humanoid and humanoid:IsA("Humanoid") and humanoid.DisplayName ~= "" then
            return humanoid.DisplayName:gsub("%s*%[.*%]", "")
        end
        
        return model.Name
    end

    local function FireBridge(...)
        local args = {...}
        args.n = #args

        pcall(function()
            local Event = game:GetService("ReplicatedStorage"):FindFirstChild("ffrostflame_bridgenet2@1.0.0")
            if Event then Event = Event.dataRemoteEvent end

            if Event then
                Event:FireServer({args, "\x02"})
            elseif GameLibrary and GameLibrary.Remote then
                GameLibrary.Remote:Fire(table.unpack(args))
            end
        end)
    end

    local function TeleportToMap(mapId)
        _G.IsTransitioningMaps = true
        AnimeGhosts.IsTeleporting = true

        FireBridge("TeleportSystem", "To", mapId)

        task.wait(2)
        _G.IsTransitioningMaps = false
        AnimeGhosts.IsTeleporting = false
        return true
    end

    local function ScanFolder(folder, myRoot, bestTarget, shortestDist, ignoreSelection)
        if not folder then return bestTarget, shortestDist end

        for _, enemy in ipairs(folder:GetChildren()) do
            if enemy:IsA("Model") and enemy ~= player.Character then
                local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("EnemyHitbox") or enemy.PrimaryPart
                if rootPart and IsEnemyAlive(enemy) then
                    local realName = GetRealEnemyName(enemy)
                    local isSelected = false

                    if ignoreSelection then
                        isSelected = true
                    else
                        local selection = AnimeGhosts.SelectedEnemy
                        if not selection or (typeof(selection) == 'string' and selection == 'All') then
                            isSelected = true
                        elseif typeof(selection) == 'table' then
                            if #selection == 0 or table.find(selection, 'All') then
                                isSelected = true
                            else
                                for _, sel in ipairs(selection) do
                                    if string.find(realName, sel) or string.find(enemy.Name, sel) then
                                        isSelected = true
                                        break
                                    end
                                end
                            end
                        elseif typeof(selection) == 'string' then
                            isSelected = string.find(realName, selection) or string.find(enemy.Name, selection)
                        end
                    end

                    if isSelected then
                        local dist = (rootPart.Position - myRoot.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            bestTarget = enemy
                        end
                    end
                end
            end
        end

        return bestTarget, shortestDist
    end

    AnimeGhosts.GamemodeCooldownEndTime = 0
    task.spawn(function()
        pcall(function()
            local bridgeNetEvent = game:GetService("ReplicatedStorage"):WaitForChild("ffrostflame_bridgenet2@1.0.0", 5)
            if bridgeNetEvent and bridgeNetEvent:FindFirstChild("dataRemoteEvent") then
                trackConnection(bridgeNetEvent.dataRemoteEvent.OnClientEvent:Connect(function(args)
                    if type(args) == 'table' and args["\x02"] then
                        for _, msgData in ipairs(args["\x02"]) do
                            if type(msgData) == 'table' and msgData[1] == 'Notify' then
                                local txt = msgData[2]

                                if txt and type(txt) == 'string' and string.find(txt, "Able to Create/Join") then
                                    local m = string.match(txt, "(%d+)m")
                                    local s = string.match(txt, "(%d+)s")
                                    local totalSeconds = 0

                                    if m then totalSeconds = totalSeconds + (tonumber(m) * 60) end
                                    if s then totalSeconds = totalSeconds + tonumber(s) end

                                    if totalSeconds > 0  then
                                        AnimeGhosts.GamemodeCooldownEndTime = tick() + totalSeconds
                                    end
                                end
                            end
                        end
                    end
                end))
            end
        end)
    end)

    local function GetSmartTarget()
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        local bestTarget, shortestDist = nil, AnimeGhosts.TargetSettings.ScanRange

        local isInsideGamemode = Workspace:FindFirstChild("'_MAP") and Workspace['_MAP']:FindFirstChild("Gamemode") and #Workspace['_MAP']['Gamemode']:GetChildren() > 0
        
        if isInsideGamemode or tick() > (AnimeGhosts.GamemodeCooldownEndTime or 0) then
            local priorityFolders = {"Dungeons", "Dungeon", "Raids", "Raid", "_DUNGEONS", "_RAIDS"}
        
            local gamemodeMap = Workspace:FindFirstChild("_MAP") and Workspace['_MAP']:FindFirstChild("Gamemode")
            if gamemodeMap then
                for _, map in ipairs(gamemodeMap:GetChildren()) do
                    bestTarget, shortestDist = ScanFolder(map, myRoot, bestTarget, shortestDist, true)
                    for _, sub in ipairs(map:GetChildren()) do
                        if sub:IsA("Folder") or sub:IsA("Model") then
                            bestTarget, shortestDist = ScanFolder(sub, myRoot, bestTarget, shortestDist, true)

                            for _, deepSub in ipairs(sub:GetChildren()) do
                                if deepSub:IsA("Folder") or deepSub:IsA("Model") then
                                    bestTarget, shortestDist = ScanFolder(deepSub, myRoot, bestTarget, shortestDist, true)
                                end
                            end
                        end
                    end
                end
            end

            for _, folderName in ipairs(priorityFolders) do
                local folder = Workspace:FindFirstChild(folderName)
                if folder then
                    bestTarget, shortestDist = ScanFolder(folder, myRoot, bestTarget, shortestDist, true)

                    for _, sub in ipairs(folder:GetChildren()) do
                        if sub:IsA("Folder") or sub:IsA("Model") then
                            bestTarget, shortestDist = ScanFolder(sub, myRoot, bestTarget, shortestDist, true)
                        end
                    end
                end
            end

            if bestTarget then
                AnimeGhosts.LastActiveGamemodeTick = tick()
                return bestTarget
            end
        end

        if AnimeGhosts.IsQueuingGamemode then
            return nil
        end

        local enemiesFolder = Workspace:FindFirstChild("_ENEMIES")
        if enemiesFolder then
            bestTarget, shortestDist = ScanFolder(enemiesFolder, myRoot, bestTarget, shortestDist, false)
            for _, sub in ipairs(enemiesFolder:GetChildren()) do
                if sub:IsA("Folder") or sub:IsA("Model") then
                    bestTarget, shortestDist = ScanFolder(sub, myRoot, bestTarget, shortestDist, false)
                end
            end
        end

        for _, folderName in ipairs({"Mobs", "Enemies"}) do
            local folder = Workspace:FindFirstChild(folderName)
            if folder then
                bestTarget, shortestDist = ScanFolder(folder, myRoot, bestTarget, shortestDist, false)
            end
        end

        return bestTarget
    end

    task.spawn(function()
        while task.wait(0.05) do
            if AnimeGhosts.SessionID ~= SessionID then break end
            if AnimeGhosts.AutoAttack then
                TargetState.CurrentTarget = GetSmartTarget()
            else
                TargetState.CurrentTarget = nil
            end
        end
    end)

    local platform = Instance.new("Part")
    platform.name = "BeaastPlatform"
    platform.Size = Vector3.new(5, 1, 5)
    platform.Anchored = true
    platform.Transparency = 1
    platform.CanCollide = true
    platform.Parent = workspace

    AnimeGhosts.Platform = platform
    AnimeGhosts.NoClipConnection = trackConnection(RunService.Stepped:Connect(function()
        if AnimeGhosts.AutoAttack and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end))

    AnimeGhosts.MovementConnection = trackConnection(RunService.Stepped:Connect(function()
        if not AnimeGhosts.AutoAttack then platform.Position = Vector3.new(0, 99999, 0); return end
        if _G.IsTransitioningMaps or AnimeGhosts.IsTeleporting or AnimeGhosts.IsQueuingGamemode then return end
    
        if AnimeGhosts.MapLoadTime and (tick() - AnimeGhosts.MapLoadTime) < 10 then
            platform.Position = Vector3.new(0, 99999, 0)
            return
        end

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local target = TargetState.CurrentTarget
        if root and target and target.Parent then
            local targetRoot = target:FindFirstChild("EnemyHitbox") or target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
            if targetRoot then
                if (root.Position - targetRoot.Position).Magnitude > 300 and AnimeGhosts.IsTeleporting then return end
                root.CFrame = targetRoot.CFrame * CFrame.new(0, -1.0, 8.5)
                platform.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.2, root.Position.Z)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            else
                platform.Position = Vector3.new(0, 99999, 0)
            end
        else
            platform.Position = Vector3.new(0, 99999, 0)
        end
    end))

    task.spawn(function()
        while AnimeGhosts.AutoAttack do
            if AnimeGhosts.SessionID ~= SessionID then break end

            if AnimeGhosts.IsTeleporting or AnimeGhosts.IsQueuingGamemode or _G.IsTransitioningMaps then
                task.wait(0.5)
                continue
            end

            if AnimeGhosts.MapLoadTime and (tick() - AnimeGhosts.MapLoadTime) < 10 then
                task.wait(0.5)
                continue
            end

            if TargetState.CurrentTarget and TargetState.CurrentTarget.Parent then
                pcall(function()
                    FireBridge("ClickSystem", "Execute", TargetState.CurrentTarget.Name)
                    if player.Character then
                        local tool = player:FindFirstChildWhichIsA("Tool")
                        if tool then tool:Activate() end
                    end

                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(999, 999))
                end)
            end

            task.wait(0.05)
        end
    end)

    task.spawn(function()
        while task.wait(10) do
            if AnimeGhosts.SessionID ~= SessionID then break end
            if not AnimeGhosts.AutoAttack or AnimeGhosts.IsTeleporting then continue end

            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local gamemodeType = nil
            local gamemodeName = nil

            if Workspace:FindFirstChild("Raids") or Workspace:FindFirstChild("Raid") then
                gamemodeType, gamemodeName = "Trial", "TitanTown"
            elseif Workspace:FindFirstChild("Dungeons") or Workspace:FindFirstChild("Dungeon") then
                gamemodeType = "Dungeon"
                gamemodeName = Workspace:FindFirstChild("TheAbyss") and "TheAbyss" or "CrystalCave"
            end

            pcall(function()
                local waveValue = Workspace:FindFirstChild("Wave") or ReplicatedStorage:FindFirstChild("Wave")
                local currentWave = waveValue and (waveValue:IsA("ValueBase") and waveValue.Value or waveValue:GetAttribute("Wave")) or 0
            
                if gamemodeType == "Trial" and currentWave >= 100 then
                    AnimeGhosts.AutoAttack = false
                    print("Reached Wave 100. Stopping.")
                elseif gamemodeType == "Dungeon" and currentWave >= 50 then
                    print("Reached Wave 50. Monitoring.")
                end
            end)

            if gamemodeType and gamemodeName then
                pcall(function()
                    local assetSpawn = ReplicatedStorage.Assets.Gamemode[gamemodeType][gamemodeName].spawn
                    if assetSpawn then
                        local targetCFrame = assetSpawn:IsA("BasePart") and assetSpawn.CFrame or assetSpawn:FindFirstChildWhichIsA("BasePart").CFrame
                        if (root.Position - targetCFrame.Position).Magnitude > 500 then
                            AnimeGhosts.IsTeleporting = true
                            root.CFrame = targetCFrame
                            task.wait(1)
                            AnimeGhosts.IsTeleporting = false
                        end
                    end
                end)
            end
        end
    end)

    local function ClaimAchievements()
        local categories = {
            ["ProClicker"] = 5,
            ["TheKiller"] = 5,
            ["Vicious"] = 5,
            ["ScrollMaster"] = 6,
            ["ShinyBooster"] = 5,
            ["RadiantBooster"] = 5,
            ["Dungeon"] = 15,
            ["Raid"] = 10
        }

        for cat, maxTier in pairs(categories) do
            for tier = 1, maxTier do
                FireBridge("AchievementSystem", "Claim", cat .. tostring(tier))
                task.wait(0.05)
            end
        end
    end

    local function ClaimChests()
        FireBridge("ChestSystem", "Claim", "GroupChest")
        FireBridge("ChestSystem", "Claim", "PremiumChest")
        FireBridge("ChestSystem", "Claim", "VIPChest")
    end

    local function HatchScroll(scrollName)
        FireBridge("PetSystem", "Open", scrollName, "All")
    end
    
    local function ToggleAutoOpening()
        FireBridge("SettingSystem", "Toggle", "AutoOpening")
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
            Secret = Color3.fromRGB(255, 50, 50),
        }

        pcall(function()
            local RarityData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("RarityData"))
            if RarityData then
                for name, data in pairs(RarityData) do
                    if data.Color then
                        rarityColors[name] = data.Color
                    end
                end
            end
        end)

        local itemLookup = {}
        pcall(function()
            local DataPath = ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data")
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
            local Content = CenterGUI and CenterGUI:FindFirstChild("Inventory") and CenterGUI['Inventory']:FindFirstChild("Content")
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
                            itemName = lookup.Name
                            iconImage = lookup.Icon
                            itemColor = lookup.Color
                        else
                            local image = slot:FindFirstChild("ImageLabel", true)
                            if image then iconImage = image.Image end

                            for _, child in ipairs(slot:GetDescendants()) do
                                if child:IsA("TextLabel") and not tonumber(child.Text) and child.Text ~= "" and #child.Text > 1 then
                                    itemName = child.Text
                                    break
                                end
                            end
                        end

                        for _, child in ipairs(slot:GetDescendants()) do
                            if child:IsA("TextLabel") then
                                local number = tonumber(child.Text:match("%d+"))
                                if number and number > 0 then
                                    amount = number
                                    break
                                end
                            end
                        end

                        table.insert(formattedItems, {
                            Name = itemName,
                            Icon = iconImage,
                            Amount = amount,
                            Color = itemColor,
                            RawName = itemId
                        })
                    end
                end
            end
        end)

        if #formattedItems == 0 and not categoryName then
            pcall(function()
                local GachaData = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Modules"):WaitForChild("Data"):WaitForChild("GachaData"))
                if GachaData then
                    for _, gachaInfo in pairs(GachaData) do
                        if gachaInfo.Targets then
                            for targetId, targetData in pairs(gachaInfo.Targets) do
                                table.insert(formattedItems, {
                                    Name = targetData.name or targetId,
                                    Icon = targetData.Icon or "rbxassetid://10138402123",
                                    Amount = 1,
                                    Color = rarityColors[targetData.Rarity] or Color3.fromRGB(0, 255, 255),
                                    RawName = targetId
                                })
                            end
                        end
                    end
                end
            end)
        end

        if #formattedItems == 0 then
            pcall(function()
                local gameLibrary = GameLibrary or getgenv().GameLibrary
                if gameLibrary and gameLibrary.PlayerData then
                    local playerData = gameLibrary.PlayerData
                    local inventoryTable = playerData.Inventory or playerData.Weapons or playerData.Pets or {}

                    if categoryName == "Weapons" and playerData.Weapons then
                        inventoryTable = playerData.Weapons
                    elseif (categoryName == 'Avatars' or categoryName == 'Pets') and (playerData.Avatars or playerData.Pets) then
                        inventoryTable = playerData.Avatars or playerData.Pets
                    end

                    if type(inventoryTable) == 'table' then
                        for itemName, itemData in pairs(inventoryTable) do
                            if type(itemData) == 'table' then
                                local lookup = itemLookup[itemName]
                                table.insert(formattedItems, {
                                    Name = (lookup and lookup.Name) or tostring(itemName),
                                    Icon = (lookup and lookup.Icon) or itemData.Icon or "rbxassetid://10138402123",
                                    Amount = itemData.Amount or itemData.Quantity or itemData.Copies or 1,
                                    Color = (lookup and lookup.Color) or rarityColors[itemData.Rarity] or Color3.FromRGB(0, 255, 255),
                                    RawName = itemName
                                })
                            end
                        end
                    end
                end
            end)
        end

        if #formattedItems == 0 then
            table.insert(formattedItems, {
                Name = "Stash Empty",
                Amount = 0,
                Color = Color3.fromRGB(255, 50, 90)
            })
        end

        return formattedItems
    end

    -- LOAD UI LIBRARY
    local repo = 'https://raw.githubusercontent.com/Beaast-exe/BeaastHub/master/libs/LinoriaLib/' -- BEAAST HUB LINORIA
    local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
    local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

    AnimeGhosts.Running = true

    local Window = Library:CreateWindow({ Title = 'Beaast Hub | Anime Ghosts v2', Center = true, AutoShow = true })
    local Tabs = {
        ['Main'] = Window:AddTab('Main'),
        ['UI Settings'] = Window:AddTab('UI Settings')
    }

    local saveFolderName = 'BeaastHub'
    local gameFolderName = 'AnimeGhosts_v2'
    local saveFileName = game:GetService('Players').LocalPlayer.Name .. '.json'
    local saveFile = saveFolderName .. '/' .. gameFolderName .. '/' .. saveFileName

    local defaultSettings = {
        ['Misc'] = {
            ['BackPosition'] = nil,
            ['BackWorld'] = '1',
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

    task.spawn(function()
        local RS = game:GetService("RunService")
        local CP = game:GetService("CorePackages")
        local SG = game:GetService("StarterGui")

        while task.wait(0.2) do
            if Library.Unloaded or not AnimeGhosts.Running then break end

            pcall(function()
                local gui = player.PlayerGui:FindFirstChild("CenterGUI")
                if gui then
                    local enemyInfo = gui:FindFirstChild("EnemyInfo")
                    if enemyInfo and enemyInfo.Visible then
                        enemyInfo.Visible = false
                    end
                end
            end)

            pcall(function()
                local ignore = workspace:FindFirstChild("_IGNORE")
                if ignore then
                    local enemyInfo = ignore:FindFirstChild("EnemyInfo")
                    if enemyInfo then
                        enemyInfo:Destroy()
                    end

                    local removeInfo = ignore:FindFirstChild("RemoveInfo")
                    if removeInfo then
                        removeInfo:Destroy()
                    end
                end
            end)

            pcall(function()
                local enemyInfo = SG:FindFirstChild("CenterGUI") and SG.CenterGUI:FindFirstChild("EnemyInfo")
                if enemyInfo then
                    enemyInfo:Destroy()
                end
            end)

            pcall(function()
                local gachaAnimation = player.PlayerGui:FindFirstChild("GachaAnimation")
                if gachaAnimation then
                    gachaAnimation.Enabled = false
                    local root = gachaAnimation:FindFirstChild("Root")
                    if root then
                        root.Visible = false
                    end
                end
            end)

            pcall(function()
                local starterGachaAnimation = SG:FindFirstChild("GachaAnimation")
                if starterGachaAnimation then
                    starterGachaAnimation:Destroy()
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if not Library.Unloaded or AnimeGhosts.Running then break end

            pcall(function()
                local coreGui = game:GetService("CoreGui")
                local robloxGui = coreGui:FindFirstChild("RobloxGui")
                if robloxGui then
                    local errorPrompt = robloxGui:FindFirstChild("ErrorPrompt")
                    if errorPrompt and errorPrompt.Enabled then
                        errorPrompt.Enabled = false
                    end
                end
            end)
        end
    end)

    -- TAB 1: CORE (MAIN DASHBOARD)
    local Dashboard = Tabs['Main']:AddRightGroupbox('System Dashboard')
    
    local function ScanGamemode(name)
        local targetNode = nil
        local gamemodeFolder = workspace:FindFirstChild("_MAP") and workspace["_MAP"]:FindFirstChild("Gamemode")
        if gamemodeFolder then
            for _, gamemode in ipairs(gamemodeFolder:GetChildren()) do
                if gamemode.Name:match(name) and gamemode:FindFirstChild("Spawn") then
                    targetNode = gamemode.Spawn
                    break
                end
            end
        end

        if targetNode then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = targetNode:IsA("Model") and targetNode.PrimaryPart.CFrame + Vector3.new(0, 5, 0) or targetNode.CFrame + Vector3.new(0, 5, 0)
            end
        else
            Library:Notify("Couldn't find an active instance of " .. name .. "!", 5)
        end
    end

    -- TAB 2: COMBAT

    local TargetSystem = Tabs['Main']:AddLeftGroupbox('Target System')

    AnimeGhosts.SelectedEnemy = {"All"}
end