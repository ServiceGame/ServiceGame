-- Ultra-Fast Optimized AutoParry Script with Error Handling
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:WaitForChild("Balls")

-- Validate Remote Events
local function getRemote(name)
    local remote = replicatedStorage.Remotes:FindFirstChild(name)
    if not remote then
        warn(name .. " is missing from ReplicatedStorage.Remotes")
    end
    return remote
end

local abilityButtonPress = getRemote("AbilityButtonPress")

-- Load Sirius UI Library
local success, Sirius = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/sirius'))()
end)

if not success then
    warn("Failed to load Sirius UI Library: " .. tostring(Sirius))
end

-- Config File Path
local configFilePath = "AutoParryConfig.json"

-- Function to Save Config Automatically
local function autoSaveConfig()
    local config = {
        isRunning = isRunning,
        autoAttack = autoAttack,
        autoAbility = autoAbility,
        parryMode = parryMode,
        sliderValue = sliderValue,
        ballDirection = ballDirection,
        ESPEnabled = ESPEnabled
    }
    writefile(configFilePath, HttpService:JSONEncode(config))
end

-- Function to Load Config Automatically
local function autoLoadConfig()
    if isfile(configFilePath) then
        local config = HttpService:JSONDecode(readfile(configFilePath))
        isRunning = config.isRunning
        autoAttack = config.autoAttack
        autoAbility = config.autoAbility
        parryMode = config.parryMode
        sliderValue = config.sliderValue
        ballDirection = config.ballDirection
        ESPEnabled = config.ESPEnabled
    end
end

-- Auto Load Config on Start
autoLoadConfig()

-- Constants (Extreme Reflex Mode)
local BASE_THRESHOLD = 0.05
local IMMEDIATE_PARRY_DISTANCE = 20
local IMMEDIATE_HIGH_VELOCITY_THRESHOLD = 100
local AUTO_ATTACK_THRESHOLD = 5
local ABILITY_TRIGGER_DISTANCE = 15
local LEGIT_PARRY_DELAY = 0.15
local HIGH_PING_PARRY_DELAY = 0.03

-- Variables
local sliderValue = 30
local isRunning = false
local autoAttack = true
local autoAbility = true
local antiAFK = true
local ballDirection = "Forward"
local parryMode = "Blatant"
local ESPEnabled = false

-- Additional Features
local DebugMode = false
local SafetyMode = true
local FastMode = true
local BeastMode = false
local AutoSpamParry = true
local RageParry = false
local FollowBall = false
local CurveBall = true
local FreezeBall = false
local AimCamera = false
local AutoMove = false

-- Optimized function to get closest ball instantly
local function getClosestBall()
    local bestBall, minDistance = nil, math.huge
    for _, ball in ipairs(ballsFolder:GetChildren()) do
        if ball:GetAttribute("realBall") then
            local distance = (ball.Position - character.PrimaryPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                bestBall = ball
            end
        end
    end
    return bestBall, minDistance
end

-- Auto Ability Activation
local function useAbilityIfNeeded(distance, ball)
    if autoAbility and abilityButtonPress and distance <= ABILITY_TRIGGER_DISTANCE and ball.Velocity.Magnitude >= IMMEDIATE_HIGH_VELOCITY_THRESHOLD then
        abilityButtonPress:Fire()
        if Sirius then
            Sirius:Notify({Title = "Auto Ability", Content = "Used Ability to Defend!", Duration = 1})
        end
    end
end

-- ESP Ball Function
local function createESPBall(ball)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = ball
    billboard.AlwaysOnTop = true
    billboard.Parent = ball
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BALL"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
end

ballsFolder.ChildAdded:Connect(function(ball)
    if ESPEnabled and ball:GetAttribute("realBall") then
        createESPBall(ball)
    end
end)

-- Main auto-parry logic with mode selection
RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    local ball, distance = getClosestBall()
    local HRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end
    useAbilityIfNeeded(distance, ball)
    if ball:GetAttribute("target") == localPlayer.Name and distance <= IMMEDIATE_PARRY_DISTANCE then
        if parryMode == "Legit" then task.wait(LEGIT_PARRY_DELAY)
        elseif parryMode == "High Ping" then task.wait(HIGH_PING_PARRY_DELAY) end
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    end
end)
