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
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local Balls = workspace:WaitForChild("Balls", 9e9)

-- Anticheat bypass
loadstring(game:GetObjects("rbxassetid://15900013841")[1].Source)()

local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function IsTarget()
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))
end

local function Parry()
return
   Remotes:WaitForChild("ParryButtonPress"):Fire()
end

-- Auto Parry Logic (Now with Toggle Support)
Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then 
   return 
end

 print(`Ball Spawned: {Ball}`)

    local OldPosition = Ball.Position
    local OldTick = tick()

    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsAutoParrying and IsTarget() then
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude

            if (Distance / Velocity) <= 10 then
                Parry()
            end
        end

        if (tick() - OldTick >= 1/60) then
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

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

local Slider = PlayerTab:CreateSlider({
   Name = "Give Walkspeed",
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
         ["DistanceToParry"] = 1,
         ["BallSpeedCheck"] = true,
      }
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Alexisisback/Blade-ball-Auto-parry-Etc/main/Manual%20spam%2BAuto%20parry"))()
   end,
})
