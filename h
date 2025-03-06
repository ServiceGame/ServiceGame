_G.ESP = false
_G.ESPName = false  -- Tính năng hiển thị tên
_G.ESPHealth = false  -- Tính năng hiển thị số máu
_G.ESPColor = Color3.fromRGB(255, 255, 255)
_G.ShowDistance = false  -- Thêm tính năng hiển thị khoảng cách

pcall(
    function()
        local highlight = Instance.new("Highlight")

        game:GetService("RunService").RenderStepped:Connect(
            function()
                local camera = game.Workspace.CurrentCamera

                for _, v in pairs(game.Players:GetPlayers()) do
                    local character = v.Character
                    if not character then continue end

                    -- Tính toán khoảng cách giữa camera và nhân vật (dù không kiểm tra khoảng cách nữa)
                    local distance = (camera.CFrame.Position - character.PrimaryPart.Position).Magnitude

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
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = character

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        local nameText = v.Name
                        if _G.ShowDistance then
                            nameText = nameText .. " [" .. math.floor(distance) .. "m]"  -- Hiển thị khoảng cách trong tên
                        end
                        label.Text = nameText
                        label.TextColor3 = _G.ESPColor
                        label.TextStrokeTransparency = 0.5
                        label.TextSize = 16
                        label.BackgroundTransparency = 1
                        label.Parent = billboard
                    end

                    -- Cập nhật số máu nếu có
                    if _G.ESPHealth and character:FindFirstChild("Humanoid") and not character:FindFirstChild("ESPHealth") then
                        local humanoid = character:FindFirstChild("Humanoid")
                        local healthLabel = Instance.new("BillboardGui")
                        healthLabel.Name = "ESPHealth"
                        healthLabel.Adornee = character:FindFirstChild("Head")
                        healthLabel.Size = UDim2.new(0, 100, 0, 20)
                        healthLabel.StudsOffset = Vector3.new(0, 3, 0)
                        healthLabel.AlwaysOnTop = true
                        healthLabel.Parent = character

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = "Health: " .. math.floor(humanoid.Health)
                        label.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Màu đỏ cho máu
                        label.TextStrokeTransparency = 0.5
                        label.TextSize = 14
                        label.BackgroundTransparency = 1
                        label.Parent = healthLabel
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

                    -- Cập nhật ESP Health (số máu)
                    if espHealth then
                        espHealth.Enabled = _G.ESPHealth  -- Hiển thị ESP Health nếu tính năng bật
                        -- Cập nhật số máu theo thời gian
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            local healthLabel = espHealth:FindFirstChild("TextLabel")
                            if healthLabel then
                                -- Cập nhật số máu
                                healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
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
    "ESP Health",  -- Thêm toggle cho ESP Health (chỉ hiển thị số máu)
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
    "Color",
    Color3.fromRGB(255, 255, 255),
    function(color)
        _G.ESPColor = color
    end
)
