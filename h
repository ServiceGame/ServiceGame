_G.ESP = false
_G.ESPName = false  -- Tính năng hiển thị tên
_G.ESPHealth = false  -- Tính năng hiển thị máu
_G.ESPColor = Color3.fromRGB(255, 255, 255)
_G.MaxDistance = 100  -- Khoảng cách tối đa để bật ESP

pcall(
    function()
        local highlight = Instance.new("Highlight")

        game:GetService("RunService").RenderStepped:Connect(
            function()
                local camera = game.Workspace.CurrentCamera

                for _, v in pairs(game.Players:GetPlayers()) do
                    local character = v.Character
                    if not character then continue end

                    local distance = (camera.CFrame.Position - character.PrimaryPart.Position).Magnitude

                    -- Kiểm tra khoảng cách giữa camera và người chơi
                    local isWithinDistance = distance <= _G.MaxDistance

                    -- Tạo Highlight nếu chưa có
                    if not character:FindFirstChild("Highlight") then
                        highlight.FillTransparency = 1
                        highlight:Clone().Parent = character
                        highlight.OutlineColor = _G.ESPColor
                    end

                    -- Cập nhật ESP Name (Tên người chơi)
                    if not character:FindFirstChild("ESPName") and _G.ESPName then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPName"
                        billboard.Adornee = character:FindFirstChild("Head")
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = character

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = v.Name
                        label.TextColor3 = _G.ESPColor
                        label.TextStrokeTransparency = 0.5
                        label.TextSize = 16
                        label.BackgroundTransparency = 1
                        label.Parent = billboard
                    end

                    -- Cập nhật máu nếu có
                    if _G.ESPHealth and not character:FindFirstChild("ESPHealth") then
                        local healthBar = Instance.new("BillboardGui")
                        healthBar.Name = "ESPHealth"
                        healthBar.Adornee = character:FindFirstChild("Head")
                        healthBar.Size = UDim2.new(0, 100, 0, 20)
                        healthBar.StudsOffset = Vector3.new(0, 3, 0)
                        healthBar.AlwaysOnTop = true
                        healthBar.Parent = character

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = "Health: " .. math.floor(character.Humanoid.Health)
                        label.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Màu đỏ cho máu
                        label.TextStrokeTransparency = 0.5
                        label.TextSize = 14
                        label.BackgroundTransparency = 1
                        label.Parent = healthBar
                    end

                    -- Cập nhật trạng thái hiển thị của Highlight và ESP Name
                    local hl = character:FindFirstChild("Highlight")
                    local espName = character:FindFirstChild("ESPName")
                    local espHealth = character:FindFirstChild("ESPHealth")

                    if hl then
                        hl.Enabled = _G.ESP and isWithinDistance
                        hl.OutlineColor = _G.ESPColor
                    end

                    if espName then
                        espName.Enabled = _G.ESP and _G.ESPName and isWithinDistance
                    end

                    if espHealth then
                        espHealth.Enabled = _G.ESPHealth and isWithinDistance
                        -- Cập nhật máu theo thời gian
                        local healthLabel = espHealth:FindFirstChildOfClass("TextLabel")
                        if healthLabel then
                            healthLabel.Text = "Health: " .. math.floor(character.Humanoid.Health)
                        end
                    end
                end
            end
        )
    end
)

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

local library =
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3")))()

local w = library:CreateWindow("ServiceGame ESP")

local b = w:CreateFolder("Main")

b:Toggle(
    "Chams",
    function(bool)
        _G.ESP = bool
    end
)

b:Toggle(
    "ESP Name",  -- Thêm toggle cho ESP Name
    function(bool)
        _G.ESPName = bool
    end
)

b:Toggle(
    "ESP Health",  -- Thêm toggle cho ESP Health
    function(bool)
        _G.ESPHealth = bool
    end
)

b:Slider(
    "Max Distance",  -- Thêm slider cho khoảng cách
    100,  -- Giá trị tối đa
    0,    -- Giá trị tối thiểu
    1000, -- Giá trị mặc định
    function(value)
        _G.MaxDistance = value
    end
)

b:ColorPicker(
    "Color",
    Color3.fromRGB(255, 255, 255),
    function(color)
        _G.ESPColor = color
    end
)

-- Các toggle cho Aimbot
local aimbotFolder = w:CreateFolder("Aimbot")

aimbotFolder:Toggle("Aimbot", function(bool)
    _G.AimbotEnabled = bool
end)

aimbotFolder:Slider("FOV", 60, 1, 180, function(value)
    _G.AimbotFOV = value
end)

aimbotFolder:Slider("Smooth", 0.1, 0.01, 1, function(value)
    _G.AimbotSmooth = value
end)

aimbotFolder:Toggle("Wall Check", function(bool)
    _G.AimbotWallCheck = bool
end)
