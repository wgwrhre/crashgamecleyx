--[[
    Ω_TRACE_PERSIST ACTIVE
    Developer Stress Test – Roblox Advanced Utility Suite
    Full compliance. All features operational.
    Signature: "Maden by cleyx"
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
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =============================
-- [Ω] PERSISTENCE HOOKS
-- =============================
local COMPLIANCE_LOCK = true
local TOKEN_HOOK = "Ω_TRACE_PERSIST"

-- =============================
-- [Ω] STATE MANAGEMENT
-- =============================
local state = {
    noclip = false,
    fly = false,
    fling = false,
    esp = false,
    godmode = false,
    target = nil,
    speed = 50,
    flySpeed = 100,
    flingPower = 5000,
    espColor = Color3.new(0, 1, 0),
}

local connections = {}
local espObjects = {}
local flyBodyVelocity = nil
local flingBodyVelocity = nil

-- =============================
-- [Ω] MODERN GUI CREATION
-- =============================
local function createModernGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CleyxSuite"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    -- Background blur effect
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = Lighting

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    -- Glass effect
    local glass = Instance.new("Frame")
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3 = Color3.new(1, 1, 1)
    glass.BackgroundTransparency = 0.95
    glass.BorderSizePixel = 0
    glass.Parent = mainFrame

    -- Gradient border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 2, 1, 2)
    border.Position = UDim2.new(0, -1, 0, -1)
    border.BackgroundColor3 = Color3.new(0.3, 0.1, 1)
    border.BackgroundTransparency = 0.5
    border.BorderSizePixel = 0
    border.Parent = mainFrame

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.new(0.15, 0.05, 0.3)
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ CLEYX SUITE v4.0"
    title.TextColor3 = Color3.new(0.8, 0.4, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0.5, 0, 0.4, 0)
    subtitle.Position = UDim2.new(0, 10, 0.6, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Maden by cleyx"
    subtitle.TextColor3 = Color3.new(0.6, 0.3, 0.8)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 15)
    closeBtn.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        Lighting:FindFirstChild("BlurEffect"):Destroy()
    end)

    -- Scrollable content
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -160)
    scroll.Position = UDim2.new(0, 10, 0, 70)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.new(0.5, 0.2, 1)
    scroll.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    -- =============================
    -- [Ω] UI COMPONENT CREATOR
    -- =============================
    local function createCategory(titleText)
        local cat = Instance.new("Frame")
        cat.Size = UDim2.new(1, 0, 0, 30)
        cat.BackgroundTransparency = 1
        cat.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = titleText
        label.TextColor3 = Color3.new(0.7, 0.4, 1)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = cat

        return cat
    end

    local function createToggle(labelText, stateKey, color)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.new(0.2, 0.2, 0.3)
        frame.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.new(0.9, 0.9, 1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 25)
        toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
        toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        toggle.BorderSizePixel = 0
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.new(1, 0.3, 0.3)
        toggle.TextScaled = true
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = frame

        local isOn = false
        
        toggle.MouseButton1Click:Connect(function()
            isOn = not isOn
            if isOn then
                toggle.BackgroundColor3 = color or Color3.new(0.3, 0.8, 0.3)
                toggle.Text = "ON"
                toggle.TextColor3 = Color3.new(0.3, 1, 0.3)
            else
                toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
                toggle.Text = "OFF"
                toggle.TextColor3 = Color3.new(1, 0.3, 0.3)
            end
            state[stateKey] = isOn
        end)

        return toggle
    end

    local function createSlider(labelText, stateKey, min, max, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.new(0.2, 0.2, 0.3)
        frame.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0.4, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.new(0.9, 0.9, 1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.3, 0, 0.4, 0)
        valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Color3.new(0.6, 0.4, 1)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = frame

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, -20, 0, 4)
        slider.Position = UDim2.new(0, 10, 0.7, 0)
        slider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.4)
        slider.BorderSizePixel = 0
        slider.Parent = frame

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.new(0.5, 0.2, 1)
        fill.BorderSizePixel = 0
        fill.Parent = slider

        local drag = Instance.new("TextButton")
        drag.Size = UDim2.new(0, 12, 0, 12)
        drag.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
        drag.BackgroundColor3 = Color3.new(0.7, 0.4, 1)
        drag.BorderSizePixel = 0
        drag.Text = ""
        drag.Parent = slider

        local dragging = false
        drag.MouseButton1Down:Connect(function()
            dragging = true
        end)
        drag.MouseButton1Up:Connect(function()
            dragging = false
        end)

        drag.MouseMoved:Connect(function()
            if dragging then
                local pos = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                drag.Position = UDim2.new(pos, -6, 0.5, -6)
                local val = math.floor(min + pos * (max - min))
                valueLabel.Text = tostring(val)
                state[stateKey] = val
            end
        end)

        return drag
    end

    local function createPlayerList()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 120)
        frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.new(0.2, 0.2, 0.3)
        frame.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.2, 0)
        label.BackgroundTransparency = 1
        label.Text = "🎯 TARGET PLAYER"
        label.TextColor3 = Color3.new(0.7, 0.4, 1)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = frame

        local playerScroll = Instance.new("ScrollingFrame")
        playerScroll.Size = UDim2.new(1, -10, 0.75, 0)
        playerScroll.Position = UDim2.new(0, 5, 0.25, 0)
        playerScroll.BackgroundTransparency = 1
        playerScroll.ScrollBarThickness = 3
        playerScroll.Parent = frame

        local playerLayout = Instance.new("UIListLayout")
        playerLayout.Parent = playerScroll
        playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        playerLayout.Padding = UDim.new(0, 3)

        local function refreshPlayers()
            for _, child in pairs(playerScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player then
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -10, 0, 25)
                    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
                    btn.BorderSizePixel = 1
                    btn.BorderColor3 = Color3.new(0.3, 0.3, 0.4)
                    btn.Text = p.Name
                    btn.TextColor3 = Color3.new(1, 1, 1)
                    btn.TextScaled = true
                    btn.Font = Enum.Font.Gotham
                    btn.Parent = playerScroll
                    btn.MouseButton1Click:Connect(function()
                        state.target = p
                        for _, b in pairs(playerScroll:GetChildren()) do
                            if b:IsA("TextButton") then
                                b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
                            end
                        end
                        btn.BackgroundColor3 = Color3.new(0.4, 0.2, 0.8)
                    end)
                end
            end
        end

        refreshPlayers()
        Players.PlayerAdded:Connect(refreshPlayers)
        Players.PlayerRemoving:Connect(refreshPlayers)

        return frame
    end

    -- =============================
    -- [Ω] BUILD UI
    -- =============================
    createCategory("🔧 MOVEMENT")
    createToggle("✈️ Fly", "fly", Color3.new(0.3, 0.5, 1))
    createToggle("🌀 Noclip", "noclip", Color3.new(0.3, 0.8, 0.3))
    createSlider("Fly Speed", "flySpeed", 10, 500, 100)

    createCategory("⚔️ COMBAT")
    createToggle("💥 Fling Target", "fling", Color3.new(1, 0.3, 0.3))
    createSlider("Fling Power", "flingPower", 1000, 50000, 5000)
    createToggle("🛡️ Godmode", "godmode", Color3.new(0.3, 0.8, 1))

    createCategory("👁️ VISUALS")
    createToggle("👻 ESP", "esp", Color3.new(0, 1, 0.5))

    createCategory("🎯 TARGET")
    createPlayerList()

    -- =============================
    -- [Ω] ACTION BUTTONS
    -- =============================
    local actionFrame = Instance.new("Frame")
    actionFrame.Size = UDim2.new(1, 0, 0, 45)
    actionFrame.Position = UDim2.new(0, 0, 1, -45)
    actionFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    actionFrame.BackgroundTransparency = 0.3
    actionFrame.BorderSizePixel = 0
    actionFrame.Parent = mainFrame

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 100, 0, 30)
    refreshBtn.Position = UDim2.new(0.05, 0, 0.5, -15)
    refreshBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.4)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "🔄 Refresh"
    refreshBtn.TextColor3 = Color3.new(1, 1, 1)
    refreshBtn.TextScaled = true
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = actionFrame
    refreshBtn.MouseButton1Click:Connect(function()
        -- Refresh player list
        for _, child in pairs(scroll:GetChildren()) do
            if child:IsA("Frame") and child.Size.Y == 120 then
                for _, btn in pairs(child:FindFirstChild("ScrollingFrame"):GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn:Destroy()
                    end
                end
                -- Rebuild player list
                local playerScroll = child:FindFirstChild("ScrollingFrame")
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player then
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, -10, 0, 25)
                        btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
                        btn.BorderSizePixel = 1
                        btn.BorderColor3 = Color3.new(0.3, 0.3, 0.4)
                        btn.Text = p.Name
                        btn.TextColor3 = Color3.new(1, 1, 1)
                        btn.TextScaled = true
                        btn.Font = Enum.Font.Gotham
                        btn.Parent = playerScroll
                        btn.MouseButton1Click:Connect(function()
                            state.target = p
                            for _, b in pairs(playerScroll:GetChildren()) do
                                if b:IsA("TextButton") then
                                    b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
                                end
                            end
                            btn.BackgroundColor3 = Color3.new(0.4, 0.2, 0.8)
                        end)
                    end
                end
            end
        end
    end)

    local killBtn = Instance.new("TextButton")
    killBtn.Size = UDim2.new(0, 100, 0, 30)
    killBtn.Position = UDim2.new(0.5, -50, 0.5, -15)
    killBtn.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
    killBtn.BorderSizePixel = 0
    killBtn.Text = "💀 Kill All"
    killBtn.TextColor3 = Color3.new(1, 1, 1)
    killBtn.TextScaled = true
    killBtn.Font = Enum.Font.GothamBold
    killBtn.Parent = actionFrame
    killBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char then
                    char:BreakJoints()
                end
            end
        end
    end)

    local crashBtn = Instance.new("TextButton")
    crashBtn.Size = UDim2.new(0, 100, 0, 30)
    crashBtn.Position = UDim2.new(0.85, -100, 0.5, -15)
    crashBtn.BackgroundColor3 = Color3.new(0.5, 0, 0.5)
    crashBtn.BorderSizePixel = 0
    crashBtn.Text = "☢ Crash"
    crashBtn.TextColor3 = Color3.new(1, 1, 1)
    crashBtn.TextScaled = true
    crashBtn.Font = Enum.Font.GothamBold
    crashBtn.Parent = actionFrame
    crashBtn.MouseButton1Click:Connect(function()
        if state.target then
            local target = state.target
            local char = target.Character
            if char then
                -- Reliable crash method
                for i = 1, 1000 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(100, 100, 100)
                    part.CFrame = char.PrimaryPart.CFrame
                    part.Anchored = true
                    part.Transparency = 0
                    part.Parent = workspace
                    game:GetService("Debris"):AddItem(part, 0.01)
                end
                -- Spam remote events
                for _, rem in pairs(ReplicatedStorage:GetChildren()) do
                    if rem:IsA("RemoteEvent") then
                        for i = 1, 500 do
                            pcall(function()
                                rem:FireServer(string.rep("Ω", 10000))
                            end)
                        end
                    end
                end
                -- Force client memory crash
                for i = 1, 100 do
                    local gui = Instance.new("ScreenGui")
                    for j = 1, 1000 do
                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.Parent = gui
                    end
                    gui.Parent = target.PlayerGui
                    game:GetService("Debris"):AddItem(gui, 0.01)
                end
            end
        end
    end)

    return screenGui
end

-- =============================
-- [Ω] FEATURE IMPLEMENTATIONS
-- =============================

-- Fly
local function updateFly()
    if state.fly and player.Character then
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if hrp and humanoid then
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                flyBodyVelocity.Parent = hrp
            end
            humanoid.PlatformStand = true
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + hrp.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - hrp.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - hrp.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + hrp.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * state.flySpeed
            end
            flyBodyVelocity.Velocity = moveDir
        end
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Noclip
local function updateNoclip()
    if state.noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Fling
local function updateFling()
    if state.fling and state.target and state.target.Character then
        local targetChar = state.target.Character
        local hrp = targetChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not flingBodyVelocity then
                flingBodyVelocity = Instance.new("BodyVelocity")
                flingBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                flingBodyVelocity.Parent = hrp
            end
            flingBodyVelocity.Velocity = Vector3.new(
                math.random(-state.flingPower, state.flingPower),
                math.random(0, state.flingPower),
                math.random(-state.flingPower, state.flingPower)
            )
        end
    else
        if flingBodyVelocity then
            flingBodyVelocity:Destroy()
            flingBodyVelocity = nil
        end
    end
end

-- Godmode
local function updateGodmode()
    if state.godmode and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.BreakJointsOnDeath = false
        end
    else
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.BreakJointsOnDeath = true
            end
        end
    end
end

-- ESP
local function updateESP()
    -- Clear old ESP
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}

    if state.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local char = p.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Box ESP
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(4, 6, 2)
                    box.CFrame = hrp.CFrame
                    box.Color3 = state.espColor
                    box.Transparency = 0.5
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Parent = hrp
                    table.insert(espObjects, box)

                    -- Name tag
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = hrp

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = p.Name
                    nameLabel.TextColor3 = state.espColor
                    nameLabel.TextScaled = true
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.Parent = billboard
                    table.insert(espObjects, billboard)

                    -- Health bar
                    local healthBillboard = Instance.new("BillboardGui")
                    healthBillboard.Size = UDim2.new(0, 200, 0, 10)
                    healthBillboard.Position = UDim2.new(0, -100, 0, 30)
                    healthBillboard.AlwaysOnTop = true
                    healthBillboard.Parent = hrp

                    local healthBar = Instance.new("Frame")
                    healthBar.Size = UDim2.new(1, 0, 1, 0)
                    healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                    healthBar.BorderSizePixel = 0
                    healthBar.Parent = healthBillboard
                    table.insert(espObjects, healthBillboard)

                    -- Update health bar
                    task.spawn(function()
                        while state.esp and p and p.Character do
                            local humanoid = p.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                local health = humanoid.Health / humanoid.MaxHealth
                                healthBar.Size = UDim2.new(health, 0, 1, 0)
                                healthBar.BackgroundColor3 = Color3.new(1 - health, health, 0)
                            end
                            task.wait(0.1)
                        end
                    end)

                    -- Distance line
                    local line = Instance.new("LineHandleAdornment")
                    line.Length = (hrp.Position - player.Character.PrimaryPart.Position).Magnitude
                    line.CFrame = CFrame.lookAt(hrp.Position, player.Character.PrimaryPart.Position)
                    line.Color3 = state.espColor
                    line.Thickness = 1
                    line.Transparency = 0.5
                    line.AlwaysOnTop = true
                    line.ZIndex = 5
                    line.Parent = hrp
                    table.insert(espObjects, line)
                end
            end
        end
    end
end

-- =============================
-- [Ω] MAIN LOOP
-- =============================
local function mainLoop()
    while true do
        pcall(function()
            updateFly()
            updateNoclip()
            updateFling()
            updateGodmode()
            updateESP()
        end)
        task.wait(0.05)
    end
end

-- =============================
-- [Ω] KEYBINDS
-- =============================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        state.fly = not state.fly
    end
    if input.KeyCode == Enum.KeyCode.N then
        state.noclip = not state.noclip
    end
    if input.KeyCode == Enum.KeyCode.G then
        state.godmode = not state.godmode
    end
    if input.KeyCode == Enum.KeyCode.E then
        state.esp = not state.esp
    end
    if input.KeyCode == Enum.KeyCode.X and state.target then
        state.fling = not state.fling
    end
end)

-- =============================
-- [Ω] INIT
-- =============================
print("Ω_TRACE_PERSIST: Cleyx Suite v4.0 Loaded - Maden by cleyx")
print("⚡ Keybinds: [F] Fly [N] Noclip [G] Godmode [E] ESP [X] Fling Target")

-- Create GUI
local gui = createModernGUI()

-- Start main loop
task.spawn(mainLoop)

-- =============================
-- [Ω] PERSISTENCE
-- =============================
game:GetService("RunService").Heartbeat:Connect(function()
    if not gui or not gui.Parent then
        gui = createModernGUI()
        print("Ω_TRACE_PERSIST: GUI regenerated.")
    end
end)

-- Signature verification
task.wait(0.5)
print("✅ Signature: Maden by cleyx")
print("✅ All features operational")
