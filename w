-- Optimized AutoParry Script with UI
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:WaitForChild("Balls")
local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
local abilityButtonPress = replicatedStorage.Remotes.AbilityButtonPress
local attackButtonPress = replicatedStorage.Remotes.AttackButtonPress

-- Load UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "AutoParry GUI",
    LoadingTitle = "Blade Ball AutoParry",
    LoadingSubtitle = "Optimized by ChatGPT",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AutoParryTab = Window:CreateTab("AutoParry")
local AutoParrySection = AutoParryTab:CreateSection("AutoParry Controls")

-- Constants
local BASE_THRESHOLD = 0.2
local VELOCITY_SCALING_FACTOR_FAST = 0.050
local VELOCITY_SCALING_FACTOR_SLOW = 0.1
local IMMEDIATE_PARRY_DISTANCE = 15

-- Variables
local sliderValue = 20
local isRunning = false
local focusedBall = nil

-- Function to determine closest and most dangerous ball
local function chooseNewFocusedBall()
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
    focusedBall = bestBall
end

-- Calculate time until impact
local function timeUntilImpact(ball)
    if not character or not ball then return math.huge end
    local direction = (character.PrimaryPart.Position - ball.Position).Unit
    local relativeVelocity = ball.Velocity:Dot(direction)
    local distance = (ball.Position - character.PrimaryPart.Position).Magnitude
    return relativeVelocity > 0 and (distance - sliderValue) / relativeVelocity or math.huge
end

-- Determine dynamic threshold
local function getDynamicThreshold(ballVelocityMagnitude)
    return ballVelocityMagnitude > 60 and math.max(0.20, BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_FAST))
                                 or math.min(0.01, BASE_THRESHOLD + (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR_SLOW))
end

-- Main auto-parry logic
local function checkBallDistance()
    if not focusedBall then chooseNewFocusedBall() end
    if not focusedBall then return end

    local timeToImpact = timeUntilImpact(focusedBall)
    if timeToImpact < getDynamicThreshold(focusedBall.Velocity.Magnitude) then
        parryButtonPress:Fire()
        Rayfield:Notify({Title = "AutoParry", Content = "Parried Successfully!", Duration = 0.5})
    end
    
    -- Attack ball if it is within parry distance
    if (focusedBall.Position - character.PrimaryPart.Position).Magnitude <= sliderValue then
        attackButtonPress:Fire()
    end
end

-- Auto-parry coroutine
local function autoParryLoop()
    while isRunning do
        checkBallDistance()
        task.wait()
    end
end

-- Start/Stop AutoParry
local function startAutoParry()
    isRunning = true
    task.spawn(autoParryLoop)
end

local function stopAutoParry()
    isRunning = false
end

-- UI Elements
local AutoParryToggle = AutoParryTab:CreateToggle({
    Name = "Enable AutoParry",
    CurrentValue = false,
    Callback = function(value)
        if value then startAutoParry() else stopAutoParry() end
    end
})

local DistanceSlider = AutoParryTab:CreateSlider({
    Name = "Parry Distance",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = sliderValue,
    Callback = function(value)
        sliderValue = value
    end
})

-- Event bindings
localPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    chooseNewFocusedBall()
end)

-- Keybinds for toggling auto-parry
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.One then startAutoParry() end
    if input.KeyCode == Enum.KeyCode.Two then stopAutoParry() end
end)
