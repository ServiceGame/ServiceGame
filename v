local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Soul hub",
   Icon = 0,
   LoadingTitle = "Soul hub",
   LoadingSubtitle = "by nonamefound",
   Theme = "Ocean",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
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
   Title = "Hello! Thanks for using the hub",
   Content = "by nonamefound",
   Duration = 6.5,
   Image = 4483362458,
})

-- Auto Parry Variables
local IsAutoParrying = false
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Balls = workspace:WaitForChild("Balls", 9e9)

local function VerifyBall(Ball)
    return Ball and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function IsTarget()
    return Player.Character and Player.Character:FindFirstChild("Highlight")
end

local function Parry()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Optimized Auto Parry Logic
Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then return end

    local OldPosition = Ball.Position
    local LastTick = tick()

    local Connection
    Connection = RunService.Heartbeat:Connect(function()
        if not Ball.Parent then
            Connection:Disconnect()
            return
        end

        if IsAutoParrying and IsTarget() then
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude / (tick() - LastTick)

            if Velocity > 0 and (Distance / Velocity) <= 10 then
                Parry()
                Connection:Disconnect()
            end
        end

        LastTick = tick()
        OldPosition = Ball.Position
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
   Range = {0, 500},
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
         ["DistanceToParry"] = 0.8,
         ["BallSpeedCheck"] = true,
      }
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Alexisisback/Blade-ball-Auto-parry-Etc/main/Manual%20spam%2BAuto%20parry"))()
   end,
})
