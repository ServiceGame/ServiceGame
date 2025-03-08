-- Tối ưu AutoParry với tốc độ phản xạ nhanh hơn và UI hiển thị FPS/PING
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Kiểm tra và tải Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:FindFirstChild("Balls")
local parryButtonPress = replicatedStorage:FindFirstChild("Remotes") and replicatedStorage.Remotes:FindFirstChild("ParryButtonPress")

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

-- Hiển thị FPS & PING
local FPSLabel = AutoParryTab:CreateLabel("FPS: Loading...")
local PingLabel = AutoParryTab:CreateLabel("PING: Loading...")

task.spawn(function()
    while true do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(players.LocalPlayer:GetNetworkPing() * 1000) -- Chuyển thành mili giây

        FPSLabel:Set("FPS: " .. fps)
        PingLabel:Set("PING: " .. ping .. "ms")

        task.wait(1) -- Cập nhật mỗi giây
    end
end)

-- Constants
local BASE_THRESHOLD = 0.015
local IMMEDIATE_PARRY_DISTANCE = 7
local IMMEDIATE_HIGH_VELOCITY_THRESHOLD = 85 -- Ngưỡng vận tốc cao
local VELOCITY_SCALING_FACTOR_FAST = 0.05  -- Hệ số điều chỉnh khoảng cách parry khi bóng nhanh
local VELOCITY_SCALING_FACTOR_SLOW = 0.1   -- Hệ số điều chỉnh khoảng cách parry khi bóng chậm

local sliderValue = 15
local isRunning = false
local autoAttack = false
local autoSpamParry = false
local antiCurveBall = false

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

local function isBallOnScreen(ball)
    local _, onScreen = Camera:WorldToViewportPoint(ball.Position)
    return onScreen
end

local function isBallDangerous(ball)
    if not character or not character.PrimaryPart or not ball then return false end
    local ballDirection = ball.Velocity.Unit
    local toPlayer = (character.PrimaryPart.Position - ball.Position).Unit
    local angle = math.acos(ballDirection:Dot(toPlayer))
    return angle < math.rad(30) and isBallOnScreen(ball)
end

local function timeUntilImpact(ball)
    if not character or not character.PrimaryPart or not ball then return math.huge end
    local direction = (character.PrimaryPart.Position - ball.Position).Unit
    local relativeVelocity = ball.Velocity:Dot(direction)
    local distance = (ball.Position - character.PrimaryPart.Position).Magnitude
    return relativeVelocity > 0 and (distance - sliderValue) / relativeVelocity or math.huge
end

RunService.Heartbeat:Connect(function()
    if not isRunning or not character or not character.PrimaryPart then return end

    local ball, HRP = getClosestBall(), character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end

    local distance = (HRP.Position - ball.Position).Magnitude
    local timeToImpact = timeUntilImpact(ball)
    local velocity = ball.Velocity.Magnitude

    -- Điều chỉnh khoảng cách parry dựa vào vận tốc bóng
    local adjustedParryDistance = IMMEDIATE_PARRY_DISTANCE
    if velocity >= IMMEDIATE_HIGH_VELOCITY_THRESHOLD then
        adjustedParryDistance = adjustedParryDistance + velocity * VELOCITY_SCALING_FACTOR_FAST
    else
        adjustedParryDistance = adjustedParryDistance + velocity * VELOCITY_SCALING_FACTOR_SLOW
    end

    if ball:GetAttribute("target") == localPlayer.Name or isBallDangerous(ball) then
        if distance <= adjustedParryDistance or timeToImpact <= BASE_THRESHOLD then
            repeat
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.02)
                distance = (HRP.Position - ball.Position).Magnitude
            until distance > adjustedParryDistance or not isBallDangerous(ball)
        end
    end
    
    if autoSpamParry and distance <= adjustedParryDistance then
        repeat
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            distance = (HRP.Position - ball.Position).Magnitude
        until distance > adjustedParryDistance
    end
    
    if antiCurveBall and velocity > 50 then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    end
    
    if autoAttack and distance <= sliderValue then
        pcall(function()
            attackButtonPress:Fire()
        end)
    end
end)

-- UI Controls
AutoParryTab:CreateSlider({
    Name = "High Velocity Threshold",
    Range = {50, 150},
    Increment = 5,
    CurrentValue = IMMEDIATE_HIGH_VELOCITY_THRESHOLD,
    Callback = function(value)
        IMMEDIATE_HIGH_VELOCITY_THRESHOLD = value
    end
})

AutoParryTab:CreateSlider({
    Name = "Velocity Scaling Fast",
    Range = {0.01, 0.1},
    Increment = 0.01,
    CurrentValue = VELOCITY_SCALING_FACTOR_FAST,
    Callback = function(value)
        VELOCITY_SCALING_FACTOR_FAST = value
    end
})

AutoParryTab:CreateSlider({
    Name = "Velocity Scaling Slow",
    Range = {0.05, 0.2},
    Increment = 0.01,
    CurrentValue = VELOCITY_SCALING_FACTOR_SLOW,
    Callback = function(value)
        VELOCITY_SCALING_FACTOR_SLOW = value
    end
})
