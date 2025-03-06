_G.ESP = false
_G.ESPName = false  -- Tính năng hiển thị tên
_G.ESPHealth = false  -- Tính năng hiển thị thanh máu và số máu
_G.ESPColor = Color3.fromRGB(255, 255, 255)
_G.NameColor = Color3.fromRGB(255, 255, 255)  -- Thêm màu cho ESP Name

pcall(
    function()
        local highlight = Instance.new("Highlight")

        game:GetService("RunService").RenderStepped:Connect(
            function()
                local camera = game.Workspace.CurrentCamera
                local localPlayer = game.Players.LocalPlayer  -- Lấy người chơi hiện tại

                for _, v in pairs(game.Players:GetPlayers()) do
                    -- Bỏ qua chính người chơi đang sử dụng script (localPlayer)
                    if v == localPlayer then
                        continue
                    end

                    local character = v.Character
                    if not character then continue end

                    -- Tạo Highlight nếu chưa có
                    if not character:FindFirstChild("Highlight") then
                        highlight.FillTransparency = 1
                        highlight:Clone().Parent = character
                        highlight.OutlineColor = _G.ESPColor
                    end

                    -- Cập nhật ESP Name (Tên người chơi)
                    if _G.ESPName and character:FindFirstChild("Head") and not character:FindFirstChild("ESPName") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESPName"
                        billboard.Adornee = character:FindFirstChild("Head")
                        billboard.Size = UDim2.new(0, 100, 0, 30)  -- Giảm kích thước để làm nhỏ gọn
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = character

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = v.Name
                        label.TextColor3 = _G.NameColor  -- Sử dụng màu được chọn từ ColorPicker
                        label.TextStrokeTransparency = 0.8  -- Mức độ trong suốt của viền đen
                        label.TextSize = 14  -- Giảm kích thước chữ để làm nhỏ gọn
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- Màu đen cho viền
                        label.BackgroundTransparency = 1
                        label.Parent = billboard
                    end

-- Cập nhật thanh máu và số máu nếu có
if _G.ESPHealth and character:FindFirstChild("Humanoid") and not character:FindFirstChild("ESPHealth") then
    local humanoid = character:FindFirstChild("Humanoid")

    -- Tạo BillboardGui cho thanh máu và số máu
    local healthBar = Instance.new("BillboardGui")
    healthBar.Name = "ESPHealth"
    healthBar.Adornee = character:FindFirstChild("Head")
    healthBar.Size = UDim2.new(0, 80, 0, 20)  -- Đặt chiều cao của health bar
    healthBar.StudsOffset = Vector3.new(0, -3, 0)  -- Di chuyển xuống dưới chân
    healthBar.AlwaysOnTop = true
    healthBar.Parent = character

    -- Tạo Frame cho thanh máu
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 10)  -- Kích thước thanh máu
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Màu đỏ cho thanh máu
    frame.BackgroundTransparency = 0
    frame.Parent = healthBar

    -- Tạo phần thanh máu (vùng màu xanh)
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)  -- Cập nhật chiều rộng theo máu
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Màu xanh cho phần đầy
    healthFill.BackgroundTransparency = 0
    healthFill.Parent = frame

    -- Tạo Label cho số máu (HP)
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health)  -- Hiển thị số máu
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Màu trắng cho số máu
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextSize = 12  -- Kích thước chữ nhỏ hơn
    healthLabel.Parent = healthBar
end

-- Cập nhật số máu local healthLabel = Instance.new("TextLabel") healthLabel.Size = UDim2.new(1, 0, 0, 20) healthLabel.Text = "HP: " .. math.floor(humanoid.Health)  -- Thay "Health" thành "HP" healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Màu trắng cho số máu healthLabel.TextStrokeTransparency = 0.5 healthLabel.TextSize = 12  -- Kích thước chữ nhỏ hơn healthLabel.BackgroundTransparency = 1 healthLabel.Parent = healthBar end

                    -- Hiển thị khoảng cách bên phải người chơi nếu tính năng ShowDistance bật
                    if _G.ShowDistance then
                        local distanceGui = character:FindFirstChild("DistanceGui")
                        if not distanceGui then
                            -- Tạo một BillboardGui cho khoảng cách
                            distanceGui = Instance.new("BillboardGui")
                            distanceGui.Name = "DistanceGui"
                            distanceGui.Adornee = character:FindFirstChild("Head")
                            distanceGui.Size = UDim2.new(0, 100, 0, 20)
                            distanceGui.StudsOffset = Vector3.new(3, 0, 0)  -- Đặt khoảng cách bên phải người chơi (thay đổi giá trị của StudsOffset để di chuyển)
                            distanceGui.AlwaysOnTop = true
                            distanceGui.Parent = character

                            local distanceLabel = Instance.new("TextLabel")
                            distanceLabel.Size = UDim2.new(1, 0, 1, 0)
                            distanceLabel.Text = math.floor((camera.CFrame.Position - character.PrimaryPart.Position).Magnitude) .. "m"
                            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Màu trắng cho khoảng cách
                            distanceLabel.TextStrokeTransparency = 0.8  -- Mức độ trong suốt của viền đen
                            distanceLabel.TextSize = 16
                            distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- Màu đen cho viền
                            distanceLabel.BackgroundTransparency = 1
                            distanceLabel.Parent = distanceGui
                        end
                    else
                        -- Nếu không bật ShowDistance, xóa các khoảng cách đã hiển thị
                        local distanceGui = character:FindFirstChild("DistanceGui")
                        if distanceGui then
                            distanceGui:Destroy()
                        end
                    end

                    -- Cập nhật trạng thái hiển thị của Highlight và ESP Name
                    local hl = character:FindFirstChild("Highlight")
                    local espName = character:FindFirstChild("ESPName")
                    local espHealth = character:FindFirstChild("ESPHealth")

                    -- Cập nhật Highlight
                    if hl then
                        hl.Enabled = _G.ESP  -- Hiển thị Highlight nếu tính năng ESP bật
                        hl.OutlineColor = _G.ESPColor
                    end

                    -- Cập nhật ESP Name
                    if espName then
                        espName.Enabled = _G.ESP and _G.ESPName  -- Hiển thị ESP Name nếu tính năng bật
                    end

                    -- Cập nhật ESP Health (số máu và thanh máu)
                    if espHealth then
                        espHealth.Enabled = _G.ESPHealth  -- Hiển thị ESP Health nếu tính năng bật
                        -- Cập nhật số máu và thanh máu theo thời gian
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            local healthLabel = espHealth:FindFirstChild("TextLabel")
                            local healthFill = espHealth:FindFirstChild("Frame"):FindFirstChild("Frame")
                            if healthLabel then
                                -- Cập nhật số máu
                                healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
                            end
                            if healthFill then
                                -- Cập nhật phần hiển thị thanh máu
                                healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                            end
                        end
                    end
                end
            end
        )
    end
)

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
    "ESP Health",  -- Thêm toggle cho ESP Health (số máu và thanh máu)
    function(bool)
        _G.ESPHealth = bool
    end
)

b:Toggle(
    "Show Distance",  -- Thêm toggle cho Show Distance
    function(bool)
        _G.ShowDistance = bool
    end
)

b:ColorPicker(
    "Name Color",  -- Thêm ColorPicker cho ESP Name
    Color3.fromRGB(255, 255, 255),
    function(color)
        _G.NameColor = color  -- Cập nhật màu cho ESP Name
    end
)

b:ColorPicker(
    "Color",
    Color3.fromRGB(255, 255, 255),
    function(color)
        _G.ESPColor = color
    end
)
