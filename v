-- Tối ưu AutoParry với UI mới và phản xạ nhanh khi bóng ở cực gần
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

-- Kiểm tra và tải Rayfield UI
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source', true))()
end)

if not success or not Rayfield then
    warn("Failed to load Rayfield UI: " .. (err or "Unknown error"))
    return
end

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:FindFirstChild("Balls")
local parryButtonPress = replicatedStorage:FindFirstChild("Remotes") and replicatedStorage.Remotes:FindFirstChild("ParryButtonPress")
local attackButtonPress = replicatedStorage:FindFirstChild("Remotes") and replicatedStorage.Remotes:FindFirstChild("AttackButtonPress")

if not ballsFolder or not parryButtonPress or not attackButtonPress then
    warn("Missing essential game elements. Script will not run.")
    return
end

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "AutoParry System",
    LoadingTitle = "Blade Ball AutoParry",
    LoadingSubtitle = "Optimized by Dev",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AutoParryTab = Window:CreateTab("AutoParry")
local AutoParrySection = AutoParryTab:CreateSection("Controls")
local SettingsSection = AutoParryTab:CreateSection("Settings")

-- Constants
local BASE_THRESHOLD = 0.03
local IMMEDIATE_PARRY_DISTANCE = 8
local sliderValue = 15
local isRunning = false
local isParried = false
local autoAttack = false

local function getClosestBall()
    if not character or not character.PrimaryPart then return nil end
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
if ballsFolder then
    ballsFolder.ChildAdded:Connect(resetParry)
end

local function timeUntilImpact(ball)
    if not character or not character.PrimaryPart or not ball then return math.huge end
    local direction = (character.PrimaryPart.Position - ball.Position).Unit
    local relativeVelocity = ball.Velocity:Dot(direction)
    local distance = (ball.Position - character.PrimaryPart.Position).Magnitude
    return relativeVelocity > 0 and (distance - sliderValue) / relativeVelocity or math.huge
end

RunService.PreSimulation:Connect(function()
    if not isRunning or not character or not character.PrimaryPart then return end

    local ball, HRP = getClosestBall(), character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end

    local distance = (HRP.Position - ball.Position).Magnitude
    local timeToImpact = timeUntilImpact(ball)

    if ball:GetAttribute("target") == localPlayer.Name and not isParried and (distance <= IMMEDIATE_PARRY_DISTANCE or timeToImpact <= BASE_THRESHOLD) then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        isParried = true
        Rayfield:Notify({Title = "AutoParry", Content = "Parried Successfully!", Duration = 0.5})
    end

    if autoAttack and distance <= sliderValue then
        pcall(function()
            attackButtonPress:Fire()
        end)
    end
end)

-- UI Controls
AutoParryTab:CreateToggle({
    Name = "Enable AutoParry",
    CurrentValue = false,
    Callback = function(value)
        isRunning = value
        Rayfield:Notify({Title = "AutoParry", Content = value and "Enabled" or "Disabled", Duration = 1})
    end
})

AutoParryTab:CreateToggle({
    Name = "Auto Attack After Parry",
    CurrentValue = false,
    Callback = function(value)
        autoAttack = value
        Rayfield:Notify({Title = "Settings", Content = value and "Auto Attack Enabled" or "Auto Attack Disabled", Duration = 1})
    end
})

AutoParryTab:CreateSlider({
    Name = "Parry Distance",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = sliderValue,
    Callback = function(value)
        sliderValue = value
        Rayfield:Notify({Title = "Settings", Content = "Parry Distance: " .. value, Duration = 1})
    end
})

AutoParryTab:CreateSlider({
    Name = "Reflex Speed",
    Range = {0.01, 0.1},
    Increment = 0.01,
    CurrentValue = BASE_THRESHOLD,
    Callback = function(value)
        BASE_THRESHOLD = value
        Rayfield:Notify({Title = "Settings", Content = "Reflex Speed: " .. value, Duration = 1})
    end
})

players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    resetParry()
end)
