-- Ultra-Fast Optimized AutoParry Script with Anti-AFK, Improved Auto Attack, Anti-Curve, Custom Ball Direction, Auto Ability, Auto Parry Mode, and Auto Config Load
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local ballsFolder = workspace:WaitForChild("Balls")
local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
local attackButtonPress = replicatedStorage.Remotes.AttackButtonPress
local abilityButtonPress = replicatedStorage.Remotes.AbilityButtonPress

-- Load Optimized UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Config File Path
local configFilePath = "SGConfig.json"

-- Function to Save Config Automatically
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
    end
end

-- Auto Load Config on Start
autoLoadConfig()

-- Constants (Extreme Reflex Mode)
local BASE_THRESHOLD = 0.05  -- Faster reflex time
local IMMEDIATE_PARRY_DISTANCE = 20  -- Increased auto-parry range
local IMMEDIATE_HIGH_VELOCITY_THRESHOLD = 100  -- Handles high-speed balls
local AUTO_ATTACK_THRESHOLD = 5  -- Immediate attack when ball is extremely close
local ABILITY_TRIGGER_DISTANCE = 15  -- Auto ability activation distance
local LEGIT_PARRY_DELAY = 0.15
local HIGH_PING_PARRY_DELAY = 0.03  -- Optimize for high ping users  -- Small delay for legit mode

-- Variables
local sliderValue = 30  -- Increased default parry distance
local isRunning = false
local autoAttack = true  -- Enabled by default
local autoAbility = true  -- Auto use ability when threatened
local antiAFK = true  -- Anti-AFK enabled by default
local ballDirection = "Forward"  -- Default direction for returning the ball
local parryMode = "Blatant"  -- Default to blatant mode

-- Optimized function to get closest ball instantly
local function getClosestBall()
    local bestBall = nil
    local minDistance = math.huge
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
    if autoAbility and distance <= ABILITY_TRIGGER_DISTANCE and ball.Velocity.Magnitude >= IMMEDIATE_HIGH_VELOCITY_THRESHOLD then
        abilityButtonPress:Fire()
        Rayfield:Notify({Title = "Auto Ability", Content = "Used Ability to Defend!", Duration = 1})
    end
end

-- Anti-Curve Function
local function adjustParryDirection(ball)
    local velocity = ball.Velocity.Unit
    local correctionFactor = Vector3.new(-velocity.X * 0.8, 0, -velocity.Z * 0.8)  -- Adjust against curve
    return correctionFactor
end

-- FPS & Ping Display
local fpsLabel = SettingsSection:CreateLabel("FPS: Calculating...")
local pingLabel = SettingsSection:CreateLabel("Ping: Calculating...")

RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    fpsLabel:Set("FPS: " .. fps)
    
    local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    pingLabel:Set("Ping: " .. ping .. " ms")
end)

-- Main auto-parry logic with mode selection
RunService.Heartbeat:Connect(function()
    if not isRunning then return end

    local ball, distance = getClosestBall()
    local HRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not ball or not HRP then return end

    useAbilityIfNeeded(distance, ball)

    if ball:GetAttribute("target") == localPlayer.Name and distance <= IMMEDIATE_PARRY_DISTANCE then
        local correction = adjustParryDirection(ball)
        HRP.CFrame = HRP.CFrame + correction  -- Adjust player positioning to counter curve
        
        if parryMode == "Legit" then
            task.wait(LEGIT_PARRY_DELAY)
        elseif parryMode == "High Ping" then
            task.wait(HIGH_PING_PARRY_DELAY)  -- Small delay to simulate manual timing
        end
        
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        Rayfield:Notify({Title = "AutoParry", Content = parryMode .. " Parry!", Duration = 0.3})
    end

    if autoAttack then
        if distance <= AUTO_ATTACK_THRESHOLD then
            for _ = 1, 3 do  -- Spam attack rapidly when ball is extremely close
                attackButtonPress:Fire()
                task.wait(0.05)
            end
        elseif distance <= sliderValue then
            attackButtonPress:Fire()
        end
    end
end)

-- UI Window
local CreditsTab = Window:CreateTab("Credits")
local CreditsSection = CreditsTab:CreateSection("Created by Wibu")

local CreatorLabel = CreditsSection:CreateLabel("Created by: Wibu")
local DiscordLabel = CreditsSection:CreateLabel("Discord: wibunek")

local CopyDiscordButton = CreditsSection:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/gtQ54c43G3")
        Rayfield:Notify({Title = "Discord Link", Content = "Copied to Clipboard!", Duration = 1})
    end
})
local VisualTab = Window:CreateTab("Visuals")
local ESPSection = VisualTab:CreateSection("Setting")

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
    label.TextColor3 = Color3.fromRGB(255, 255, 255) -- White Text
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black Outline
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold -- Bold Font
    label.TextScaled = true
end

-- Toggle for ESP
local ESPEnabled = false
local ESPToggle = ESPSection:CreateToggle({
    Name = "Enable Ball ESP",
    CurrentValue = ESPEnabled,
    Callback = function(value)
        ESPEnabled = value
        if ESPEnabled then
            for _, ball in ipairs(ballsFolder:GetChildren()) do
                if ball:GetAttribute("realBall") then
                    createESPBall(ball)
                end
            end
        else
            for _, ball in ipairs(ballsFolder:GetChildren()) do
                if ball:FindFirstChild("BillboardGui") then
                    ball.BillboardGui:Destroy()
                end
            end
        end
    end
})

ballsFolder.ChildAdded:Connect(function(ball)
    if ESPEnabled and ball:GetAttribute("realBall") then
        createESPBall(ball)
    end
end)


local Window = Rayfield:CreateWindow({
    Name = "ServiceGame - Blade Ball",
    LoadingTitle = "Blade Ball",
    LoadingSubtitle = "By Wibu",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local AutoParryTab = Window:CreateTab("Combat")
local SettingsSection = AutoParryTab:CreateSection("Setting")

-- UI Elements
local AutoParryToggle = AutoParryTab:CreateToggle({
    Name = "Auto Parry (Ultra-Fast)",
    CurrentValue = isRunning,
    Callback = function(value)
        isRunning = value
        autoSaveConfig()
    end
})

local AutoAbilityToggle = AutoParryTab:CreateToggle({
    Name = "Auto Ability",
    CurrentValue = autoAbility,
    Callback = function(value)
        autoAbility = value
        autoSaveConfig()
    end
})

local ParryModeDropdown = AutoParryTab:CreateDropdown({
    Name = "Auto Parry Mode",
    Options = {"Blatant", "Legit", "High Ping"},
    CurrentOption = parryMode,
    Callback = function(value)
        parryMode = value
        autoSaveConfig()
    end
})

local DistanceSlider = AutoParryTab:CreateSlider({
    Name = "Parry Distance",
    Range = {0.5, 100},
    Increment = 1,
    CurrentValue = sliderValue,
    Callback = function(value)
        sliderValue = value
        autoSaveConfig()
    end
})

local AutoAttackToggle = AutoParryTab:CreateToggle({
    Name = "Auto Attack After Parry",
    CurrentValue = autoAttack,
    Callback = function(value)
        autoAttack = value
        autoSaveConfig()
    end
})

-- Event bindings
localPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.One then isRunning = true autoSaveConfig() end
    if input.KeyCode == Enum.KeyCode.Two then isRunning = false autoSaveConfig() end
end)
