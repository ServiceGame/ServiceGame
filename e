-- Optimized AutoParry Script with UI and RunService
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:WaitForChild("Balls")
local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
local attackButtonPress = replicatedStorage.Remotes.AttackButtonPress

-- Load Optimized UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "ServiceGame",
    LoadingTitle = "Blade Ball",
    LoadingSubtitle = "by Wibu",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AutoParryTab = Window:CreateTab("AutoParry")
local AutoParrySection = AutoParryTab:CreateSection("AutoParry Controls")
local SettingsSection = AutoParryTab:CreateSection("Settings")

-- Constants
local BASE_THRESHOLD = 0.2
local VELOCITY_SCALING_FACTOR_FAST = 0.050
local VELOCITY_SCALING_FACTOR_SLOW = 0.1
local IMMEDIATE_PARRY_DISTANCE = 15
local IMMEDIATE_HIGH_VELOCITY_THRESHOLD = 85

-- Variables
local sliderValue = 20
local isRunning = false
local isParried = false
local autoAttack = false

-- Optimized function to get closest ball
local function getClosestBall()
    local minDistance, bestBall = math.huge, nil
    for _, ball in ipairs(ballsFolder:GetChildren()) do
        if ball:GetAttribute("realBall") then
            local distance = (ball.Position - character.PrimaryPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                bestBall = ball
            end
        end
    end
    return bestBall
end

local function resetParry()
    isParried = false
end

workspace.Balls.ChildAdded:Connect(resetParry)

-- Calculate time until impact
local function timeUntilImpact(ball)
    if not character or not ball then return math.huge end
    local direction = (character.PrimaryPart.Position - ball.Position).Unit
    local relativeVelocity = ball.Velocity:Dot(direction)
    local distance = (ball.Position - character.PrimaryPart.Position).Magnitude
    return relativeVelocity > 0 and (distance - sliderValue) / relativeVelocity or math.huge
end

-- Main auto-parry logic
RunService.PreSimulation:Connect(function()
    if not isRunning then return end

    local ball, HRP = getClosestBall(), localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end

    local speed = ball.Velocity.Magnitude
    local distance = (HRP.Position - ball.Position).Magnitude
    local timeToImpact = timeUntilImpact(ball)

    if ball:GetAttribute("target") == localPlayer.Name and not isParried and timeToImpact <= BASE_THRESHOLD then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        isParried = true
        Rayfield:Notify({Title = "AutoParry", Content = "Parried Successfully!", Duration = 0.5})
    end

    -- Attack ball if it is within parry distance and auto attack is enabled
    if autoAttack and distance <= sliderValue then
        attackButtonPress:Fire()
    end
end)

-- UI Elements
local AutoParryToggle = AutoParryTab:CreateToggle({
    Name = "Enable AutoParry",
    CurrentValue = false,
    Callback = function(value)
        isRunning = value
        Rayfield:Notify({Title = "AutoParry", Content = value and "Enabled" or "Disabled", Duration = 1})
    end
})

local DistanceSlider = AutoParryTab:CreateSlider({
    Name = "Parry Distance",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = sliderValue,
    Callback = function(value)
        sliderValue = value
        Rayfield:Notify({Title = "Settings", Content = "Parry Distance: " .. value, Duration = 1})
    end
})

local ReflexSpeedSlider = AutoParryTab:CreateSlider({
    Name = "Reflex Speed",
    Range = {0.1, 1.0},
    Increment = 0.05,
    CurrentValue = BASE_THRESHOLD,
    Callback = function(value)
        BASE_THRESHOLD = value
        Rayfield:Notify({Title = "Settings", Content = "Reflex Speed: " .. value, Duration = 1})
    end
})

local AutoAttackToggle = AutoParryTab:CreateToggle({
    Name = "Auto Attack After Parry",
    CurrentValue = false,
    Callback = function(value)
        autoAttack = value
        Rayfield:Notify({Title = "Settings", Content = value and "Auto Attack Enabled" or "Auto Attack Disabled", Duration = 1})
    end
})

-- Event bindings
localPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    resetParry()
end)

-- Keybinds for toggling auto-parry
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.One then
        isRunning = true
        Rayfield:Notify({Title = "AutoParry", Content = "Enabled", Duration = 1})
    end
    if input.KeyCode == Enum.KeyCode.Two then
        isRunning = false
        Rayfield:Notify({Title = "AutoParry", Content = "Disabled", Duration = 1})
    end
end)
