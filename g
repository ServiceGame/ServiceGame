local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ServiceGame - Blade Ball",
   Icon = 0,
   LoadingTitle = "ServiceGame",
   LoadingSubtitle = "by Wibu",
   Theme = "Dark",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "SG"
   },

   Discord = {
      Enabled = false,
      Invite = "gtQ54c43G3",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)

Rayfield:Notify({
   Title = "Hello! Thanks for using ServiceGame",
   Content = "by Wibu",
   Duration = 6.5,
   Image = 4483362458,
})

-- Auto Parry Variables
local IsAutoParrying = false
local ParryRange = 10 -- Default Parry Range
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local Balls = workspace:WaitForChild("Balls", 9e9)

local function VerifyBall(Ball)
    return Ball and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function IsTarget()
    return Player.Character and Player.Character:FindFirstChild("Highlight")
end

local function Parry()
    Remotes:WaitForChild("ParryButtonPress"):Fire()
end

-- Optimized Auto Parry for High Ping with Parry Range and Remote Support
Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then
        return
    end
    
    print(`Ball Spawned: {Ball}`)
    
    local OldPosition = Ball.Position
    local OldTick = tick()
    
    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then -- No need to do the math if we're not being attacked.
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude -- Fix for .Velocity not working. Yes I got the lowest possible grade in accuplacer math.
            
            print(`Distance: {Distance}\nVelocity: {Velocity}\nTime: {Distance / Velocity}`)
        
            if (Distance / Velocity) <= 10 then -- Sorry for the magic number. This just works. No, you don't get a slider for this because it's 2am.
                Parry()
            end
        end
        
        if (tick() - OldTick >= 1/60) then -- Don't want it to update too quickly because my velocity implementation is aids. Yes, I tried Ball.Velocity. No, it didn't work.
            OldTick = tick()
            OldPosition = Ball.Position
        end
    end)
end)

-- Auto Parry Toggle Button
local AutoParryToggle = MainTab:CreateToggle({
   Name = "Auto Parry",
   CurrentValue = false,
   Flag = "AutoParryToggle",
   Callback = function(state)
      IsAutoParrying = state
   end
})

-- Parry Range Slider
local ParryRangeSlider = MainTab:CreateSlider({
   Name = "Parry Range",
   Range = {0, 50},
   Increment = 1,
   Suffix = "Units",
   CurrentValue = ParryRange,
   Flag = "ParryRangeSlider",
   Callback = function(value)
      ParryRange = value
   end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

local Slider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(v)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
   end,
})

local Button = MainTab:CreateButton({
   Name = "Manual spam (gui)",
   Callback = function()
      getgenv().Paws = {
         ["AutoParry"] = true,
         ["PingBased"] = true,
         ["PingBasedOffset"] = 0,
         ["DistanceToParry"] = 1.2,
         ["BallSpeedCheck"] = true,
      }
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Alexisisback/Blade-ball-Auto-parry-Etc/main/Manual%20spam%2BAuto%20parry"))()
   end,
})
