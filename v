-- Tối ưu AutoParry với Remote Events và tốc độ phản xạ nhanh hơn
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
local remotes = replicatedStorage:FindFirstChild("Remotes")
local parryButtonPress = remotes and remotes:FindFirstChild("ParryButtonPress")
local attackButtonPress = remotes and remotes:FindFirstChild("AttackButtonPress")

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
        local ping = math.floor(players.LocalPlayer:GetNetworkPing() * 1000)

        FPSLabel:Set("FPS: " .. fps)
        PingLabel:Set("PING: " .. ping .. "ms")

        task.wait(1)
    end
end)

-- Constants
local BASE_THRESHOLD = 0.015
local IMMEDIATE_PARRY_DISTANCE = 7
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

local function isBallDangerous(ball)
    if not character or not character.PrimaryPart or not ball then return false end
    local ballDirection = ball.Velocity.Unit
    local toPlayer = (character.PrimaryPart.Position - ball.Position).Unit
    local angle = math.acos(ballDirection:Dot(toPlayer))
    return angle < math.rad(30)
end

RunService.Heartbeat:Connect(function()
    if not isRunning and not autoSpamParry and not antiCurveBall then return end
    if not isRunning or not character or not character.PrimaryPart then return end

    local ball, HRP = getClosestBall(), character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end

    local distance = (HRP.Position - ball.Position).Magnitude
    local timeToImpact = (distance - sliderValue) / ball.Velocity.Magnitude

    if (ball:GetAttribute("target") == localPlayer.Name or isBallDangerous(ball)) and (distance <= IMMEDIATE_PARRY_DISTANCE or timeToImpact <= BASE_THRESHOLD) then
        repeat
            if parryButtonPress then
                parryButtonPress:FireServer()
            else
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            end
            task.wait(0.02)
            distance = (HRP.Position - ball.Position).Magnitude
        until distance > IMMEDIATE_PARRY_DISTANCE or not isBallDangerous(ball)
    end
    
    if isRunning and autoSpamParry and distance <= IMMEDIATE_PARRY_DISTANCE then
        repeat
            if parryButtonPress then
                parryButtonPress:FireServer()
            else
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            end
            task.wait(0.02)
            distance = (HRP.Position - ball.Position).Magnitude
        until distance > IMMEDIATE_PARRY_DISTANCE
    end
    
    if isRunning and antiCurveBall and ball.Velocity.Magnitude > 50 then
        if parryButtonPress then
            parryButtonPress:FireServer()
        else
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end
    end
    
    if autoAttack and distance <= sliderValue and attackButtonPress then
        attackButtonPress:FireServer()
    end
end)

-- UI Controls
AutoParryTab:CreateToggle({
    Name = "Enable AutoParry",
    CurrentValue = false,
    Callback = function(value)
        isRunning = value
    end
})

AutoParryTab:CreateToggle({
    Name = "Auto Attack After Parry",
    CurrentValue = false,
    Callback = function(value)
        autoAttack = value
    end
})

AutoParryTab:CreateToggle({
    Name = "Auto Spam Parry (When Ball is Very Close)",
    CurrentValue = false,
    Callback = function(value)
        autoSpamParry = value
    end
})

AutoParryTab:CreateToggle({
    Name = "Anti Curve Ball",
    CurrentValue = false,
    Callback = function(value)
        antiCurveBall = value
    end
})

players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)
