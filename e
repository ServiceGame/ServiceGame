-- Tối ưu script Visual 0.2
local version = '0.2'
print('Visual. - https://dsc.gg/52JdnPCzWr')
print(version)

setfpscap(165)

local Stats = game:GetService('Stats')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local local_player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local closest_Entity, parry_remote, hit_Sound = nil, nil, nil

getgenv().aura_Enabled = false
getgenv().hit_sound_Enabled = false
getgenv().hit_effect_Enabled = false
getgenv().trail_Enabled = false
getgenv().kill_effect_Enabled = false
getgenv().shaders_effect_Enabled = false
getgenv().auto_HitBall_Enabled = false

-- Tải thư viện
local library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = library:CreateWindow({
    Name = "Visual 0.2",
    LoadingTitle = "Loading UI...",
    LoadingSubtitle = "By ChatGPT",
    ConfigurationSaving = { Enabled = true, FolderName = "VisualConfig", FileName = "settings" },
    Discord = { Enabled = false, Invite = "52JdnPCzWr" }
})

-- Khởi tạo Tabs
local CombatTab = Window:CreateTab("Combat")
local MiscTab = Window:CreateTab("Misc")
local VisualTab = Window:CreateTab("Visual")
local ServerTab = Window:CreateTab("Server")
local SettingsTab = Window:CreateTab("Settings")

-- Thêm Toggle Button
CombatTab:CreateToggle({ Name = "Auto Parry", CurrentValue = false, Callback = function(t) getgenv().aura_Enabled = t end })
CombatTab:CreateToggle({ Name = "Auto Hit Ball", CurrentValue = false, Callback = function(t) getgenv().auto_HitBall_Enabled = t end })
CombatTab:CreateToggle({ Name = "Hit Sound", CurrentValue = false, Callback = function(t) getgenv().hit_sound_Enabled = t end })
MiscTab:CreateToggle({ Name = "Hit Effect", CurrentValue = false, Callback = function(t) getgenv().hit_effect_Enabled = t end })
MiscTab:CreateToggle({ Name = "Trail", CurrentValue = false, Callback = function(t) getgenv().trail_Enabled = t end })
MiscTab:CreateToggle({ Name = "Kill Effect", CurrentValue = false, Callback = function(t) getgenv().kill_effect_Enabled = t end })
ServerTab:CreateToggle({ Name = "FPS Boost", CurrentValue = false, Callback = function(t) if t then loadstring(game:HttpGet("https://pastebin.com/raw/uzLqqbec"))() end end })
ServerTab:CreateToggle({ Name = "Anti-Lag", CurrentValue = false, Callback = function(t) if t then loadstring(game:HttpGet("https://pastebin.com/raw/qtu4MBV0"))() end end })
SettingsTab:CreateButton({ Name = "Copy Discord Invite", Callback = function() setclipboard("https://discord.gg/52JdnPCzWr") end })
VisualTab:CreateToggle({ Name = "Shaders", CurrentValue = false, Callback = function(t) getgenv().shaders_effect_Enabled = t end })

-- Hàm xác định thực thể gần nhất
local function get_closest_entity()
    local closest, max_distance = nil, math.huge
    for _, entity in pairs(workspace.Alive:GetChildren()) do
        if entity and entity:FindFirstChild("PrimaryPart") then do
        if entity ~= local_player.Character then
            local distance = (local_player.Character.PrimaryPart.Position - entity.PrimaryPart.Position).Magnitude
            if distance < max_distance then
                closest, max_distance = entity, distance
            end
        end
    end
    return closest
end

-- Xử lý Auto Parry và Auto Hit Ball
RunService.PreRender:Connect(function()
    if getgenv().aura_Enabled and closest_Entity then
        if parry_remote and closest_Entity and closest_Entity.PrimaryPart then
        parry_remote:FireServer(0.5, camera.CFrame, { [closest_Entity.Name] = closest_Entity.PrimaryPart.Position }, false)
    end
    end
    
    if getgenv().auto_HitBall_Enabled then
        for _, ball in pairs(workspace.Balls:GetChildren()) do
            if ball:IsA("BasePart") and (local_player.Character.PrimaryPart.Position - ball.Position).Magnitude < 15 then
                if ReplicatedStorage.Remotes:FindFirstChild("HitBall") then
                    ReplicatedStorage.Remotes.HitBall:FireServer(ball)
                end
            end
        end
    end
end)

-- Hiệu ứng Kill Effect
function play_kill_effect(Part)
    task.defer(function()
        local bell = game:GetObjects("rbxassetid://17519762269")[1]
        bell.Parent, bell.Position = workspace, Part.Position
        bell:FindFirstChild('Sound'):Play()
        task.delay(5, function() bell:Destroy() end)
    end)
end

workspace.Alive.ChildRemoved:Connect(function(child)
    if workspace.Dead:FindFirstChild(child.Name) and getgenv().kill_effect_Enabled then
        play_kill_effect(child.PrimaryPart)
    end
end)

-- Hiệu ứng Shaders
while task.wait(1) do
    if getgenv().shaders_effect_Enabled then
        game:GetService("TweenService"):Create(game:GetService("Lighting").Bloom, TweenInfo.new(3), { Size = 100, Intensity = 2.1 }):Play()
    else
        game:GetService("TweenService"):Create(game:GetService("Lighting").Bloom, TweenInfo.new(3), { Size = 3, Intensity = 1 }):Play()
    end
end
