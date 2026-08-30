-- Roblox Targeted Ejection Utility
-- Signature: Made by cleyx

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EjectUtility"
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
Title.Text = "Eject Utility"
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

local EjectButton = Instance.new("TextButton")
EjectButton.Size = UDim2.new(1, -10, 0, 30)
EjectButton.Position = UDim2.new(0, 5, 1, -35)
EjectButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
EjectButton.Text = "EJECT TARGET"
EjectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EjectButton.Font = Enum.Font.GothamBold
EjectButton.TextSize = 14
EjectButton.Parent = Frame

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
                EjectButton.Text = "EJECT: " .. player.Name
                EjectButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- Ejection methods
local function EjectTarget(player)
    if not player or not player.Character then return end
    
    -- Method 1: Humanoid State Corruption
    spawn(function()
        local char = player.Character
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        -- Force invalid state transitions
        for i = 1, 50 do
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                wait(0.01)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                wait(0.01)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                wait(0.01)
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end)
        end
        
        -- Destroy root part to trigger respawn loop
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root:Destroy()
        end
    end)
    
    -- Method 2: Character Parenting Loop
    spawn(function()
        local char = player.Character
        if not char then return end
        
        for i = 1, 100 do
            pcall(function()
                char.Parent = nil
                wait()
                char.Parent = Workspace
            end)
        end
    end)
    
    -- Method 3: Animation Track Spam
    spawn(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end
        
        for i = 1, 200 do
            pcall(function()
                local track = animator:LoadAnimation(Instance.new("Animation"))
                track:Play()
                track:Stop()
                track:Destroy()
            end)
            wait()
        end
    end)
end

EjectButton.MouseButton1Click:Connect(function()
    if SelectedPlayer then
        EjectButton.Text = "EJECTING..."
        EjectButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        EjectTarget(SelectedPlayer)
        wait(2)
        EjectButton.Text = "EJECT: " .. SelectedPlayer.Name
        EjectButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)
