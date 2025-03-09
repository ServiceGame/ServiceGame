-- Load Rayfield UI Library from Sirius Menu
loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
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
local parryButtonPress = replicatedStorage.Remotes:FindFirstChild("ParryButtonPress")
local attackButtonPress = replicatedStorage.Remotes:FindFirstChild("AttackButtonPress")
local abilityButtonPress = replicatedStorage.Remotes:FindFirstChild("AbilityButtonPress")

-- Config File Path
local configFilePath = "SGConfig.json"

-- Function to Save Config
local function autoSaveConfig()
    local config = {
        isRunning = isRunning,
        autoAttack = autoAttack,
        autoAbility = autoAbility,
        parryMode = parryMode,
        sliderValue = sliderValue,
        ballDirection = ballDirection
    }
    writefile(configFilePath, HttpService:JSONEncode(config))
end

-- Function to Load Config
local function autoLoadConfig()
    if isfile(configFilePath) then
        local config = HttpService:JSONDecode(readfile(configFilePath))
        isRunning = config.isRunning
        autoAttack = config.autoAttack
        autoAbility = config.autoAbility
        parryMode = config.parryMode
        sliderValue = config.sliderValue
        ballDirection = config.ballDirection
    end
end

-- Auto Load Config on Start
autoLoadConfig()

-- Constants
local BASE_THRESHOLD = 0.05  -- Faster reflex time
local IMMEDIATE_PARRY_DISTANCE = 20
local AUTO_ATTACK_THRESHOLD = 5
local ABILITY_TRIGGER_DISTANCE = 15
local HIGH_PING_PARRY_DELAY = 0.03

-- Variables
local sliderValue = 30
local isRunning = false
local autoAttack = true
local autoAbility = true
local ballDirection = "Forward"
local parryMode = "Blatant"

-- Create UI
local Window = Rayfield:CreateWindow({Name = "Blade Ball Script", LoadingTitle = "Loading...", LoadingSubtitle = "By Wibu", KeySystem = false})
local AutoParryTab = Window:CreateTab("Combat")
local SettingsSection = AutoParryTab:CreateSection("Settings")

local AutoParryToggle = SettingsSection:CreateToggle("Auto Parry", isRunning, function(value)
    isRunning = value
    autoSaveConfig()
end)

local AutoAbilityToggle = SettingsSection:CreateToggle("Auto Ability", autoAbility, function(value)
    autoAbility = value
    autoSaveConfig()
end)

local ParryModeDropdown = SettingsSection:CreateDropdown("Parry Mode", {"Blatant", "Legit", "High Ping"}, parryMode, function(value)
    parryMode = value
    autoSaveConfig()
end)

local DistanceSlider = SettingsSection:CreateSlider("Parry Distance", 0.5, 100, sliderValue, function(value)
    sliderValue = value
    autoSaveConfig()
end)

local AutoAttackToggle = SettingsSection:CreateToggle("Auto Attack", autoAttack, function(value)
    autoAttack = value
    autoSaveConfig()
end)

-- Function to Get Closest Ball
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
    if autoAbility and distance <= ABILITY_TRIGGER_DISTANCE then
        if abilityButtonPress then
            abilityButtonPress:Fire()
            Rayfield:Notify("Used Ability to Defend!")
        end
    end
end

-- Auto-Parry Logic
RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    
    local ball, distance = getClosestBall()
    local HRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end
    
    useAbilityIfNeeded(distance, ball)
    
    if distance <= IMMEDIATE_PARRY_DISTANCE and parryButtonPress then
        if parryMode == "Legit" then
            task.wait(0.15)
        elseif parryMode == "High Ping" then
            task.wait(HIGH_PING_PARRY_DELAY)
        end
        parryButtonPress:Fire()
        Rayfield:Notify("Parry!")
    end
    
    if autoAttack and distance <= AUTO_ATTACK_THRESHOLD and attackButtonPress then
        attackButtonPress:Fire()
    end
end)

-- ESP Toggle
local ESPEnabled = false
local ESPToggle = SettingsSection:CreateToggle("Enable Ball ESP", ESPEnabled, function(value)
    ESPEnabled = value
    for _, ball in ipairs(ballsFolder:GetChildren()) do
        if ESPEnabled then
            local billboard = Instance.new("BillboardGui", ball)
            local label = Instance.new("TextLabel", billboard)
            label.Text = "BALL"
            label.TextColor3 = Color3.new(1, 1, 1)
        else
            if ball:FindFirstChild("BillboardGui") then
                ball.BillboardGui:Destroy()
            end
        end
    end
end)

ballsFolder.ChildAdded:Connect(function(ball)
    if ESPEnabled and ball:GetAttribute("realBall") then
        local billboard = Instance.new("BillboardGui", ball)
        local label = Instance.new("TextLabel", billboard)
        label.Text = "BALL"
        label.TextColor3 = Color3.new(1, 1, 1)
    end
end)
