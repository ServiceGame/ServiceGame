_G.ESP = false
_G.ESPName = false
_G.ESPHealth = false
_G.ESPColor = Color3.fromRGB(255, 255, 255)
_G.MaxDistance = 100

_G.AimbotEnabled = false
_G.AimbotFOV = 60  -- FOV của aimbot (độ lớn góc nhìn)
_G.AimbotSmooth = 0.1  -- Độ mượt của aimbot (0.1 là mượt, 1 là thẳng tắp)
_G.AimbotWallCheck = true  -- Kiểm tra có bị vật thể che khuất không?

-- Hàm kiểm tra xem mục tiêu có bị vật thể che khuất không
local function isTargetOccluded(target)
    local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (target.Position - game.Workspace.CurrentCamera.CFrame.Position).unit * 100)
    local hitPart, hitPosition = game.Workspace:FindPartOnRay(ray, game.Workspace.CurrentCamera)
    return hitPart and hitPart.Parent ~= target.Parent  -- Nếu có vật thể ngăn cách, trả về true
end

-- Hàm để tính toán điểm ngắm mượt mà (smooth aiming)
local function smoothAim(targetPosition, smoothAmount)
    local camera = game.Workspace.CurrentCamera
    local currentPosition = camera.CFrame.Position
    local direction = (targetPosition - currentPosition).unit
    local newDirection = direction * smoothAmount + camera.CFrame.LookVector * (1 - smoothAmount)
    local newCFrame = CFrame.new(currentPosition, currentPosition + newDirection)
    return newCFrame
end

-- Hàm tìm mục tiêu gần nhất trong FOV
local function getClosestTarget(fov)
    local camera = game.Workspace.CurrentCamera
    local closestTarget = nil
    local closestDistance = math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local screenPos, onScreen = camera:WorldToScreenPoint(rootPart.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).magnitude
            
            -- Nếu đối tượng trong FOV và không bị che khuất
            if distance < fov and onScreen and (not _G.AimbotWallCheck or not isTargetOccluded(rootPart)) then
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = rootPart
                end
            end
        end
    end
    return closestTarget
end

pcall(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.AimbotEnabled then
            local target = getClosestTarget(_G.AimbotFOV)

            if target then
                -- Tính toán điểm ngắm mượt mà
                local camera = game.Workspace.CurrentCamera
                local aimPosition = target.Position
                local smoothedCFrame = smoothAim(aimPosition, _G.AimbotSmooth)
                
                -- Di chuyển camera đến vị trí mượt mà
                camera.CFrame = smoothedCFrame
            end
        end
    end)
end)

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()

local w = library:CreateWindow("ServiceGame ESP")

local b = w:CreateFolder("Main")

-- Các toggle cho các tính năng
b:Toggle("Chams", function(bool)
    _G.ESP = bool
end)

b:Toggle("ESP Name", function(bool)
    _G.ESPName = bool
end)

b:Toggle("ESP Health", function(bool)
    _G.ESPHealth = bool
end)

b:Slider("Max Distance", 100, 0, 1000, function(value)
    _G.MaxDistance = value
end)

b:ColorPicker("Color", Color3.fromRGB(255, 255, 255), function(color)
    _G.ESPColor = color
end)

-- Tạo một thư mục riêng cho Aimbot trong GUI
local aimbotFolder = w:CreateFolder("Aimbot")

-- Aimbot Toggle
aimbotFolder:Toggle("Aimbot", function(bool)
    _G.AimbotEnabled = bool
end)

-- Slider cho FOV
aimbotFolder:Slider("FOV", 60, 1, 180, function(value)
    _G.AimbotFOV = value
end)

-- Slider cho Smooth Aiming
aimbotFolder:Slider("Smooth", 0.1, 0.01, 1, function(value)
    _G.AimbotSmooth = value
end)

-- Wall Check Toggle
aimbotFolder:Toggle("Wall Check", function(bool)
    _G.AimbotWallCheck = bool
end)
