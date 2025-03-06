_G.ESP = false
_G.ESPColor = Color3.fromRGB(255, 255, 255)

pcall(
    function()
        local highlight = Instance.new("Highlight")

        game:GetService("RunService").RenderStepped:Connect(
            function()
                for _, v in pairs(game.Players:GetPlayers()) do
                    -- Create Highlight if not exists
                    if not v.Character:FindFirstChild("Highlight") then
                        highlight.FillTransparency = 1
                        highlight:Clone().Parent = v.Character
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end

                    -- Create ESP Name if not exists
                    if not v.Character:FindFirstChild("ESPName") then
                        local nameTag = Instance.new("BillboardGui")
                        nameTag.Name = "ESPName"
                        nameTag.Adornee = v.Character:WaitForChild("Head")
                        nameTag.Size = UDim2.new(0, 100, 0, 50)
                        nameTag.StudsOffset = Vector3.new(0, 3, 0) -- Adjust name position
                        nameTag.AlwaysOnTop = true
                        nameTag.Parent = v.Character

                        local textLabel = Instance.new("TextLabel")
                        textLabel.Text = v.Name
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        textLabel.TextStrokeTransparency = 0.8
                        textLabel.TextSize = 16
                        textLabel.BackgroundTransparency = 1
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.Parent = nameTag
                    end
                end

                -- Update highlight and name color based on ESP settings
                for _, v in pairs(game.Players:GetPlayers()) do
                    local hl = v.Character:FindFirstChild("Highlight")
                    local nameTag = v.Character:FindFirstChild("ESPName")
                    if hl then
                        hl.Enabled = _G.ESP
                        hl.OutlineColor = _G.ESPColor
                    end
                    if nameTag then
                        -- Change the text color of the player's name based on ESP settings
                        local textLabel = nameTag:FindFirstChildOfClass("TextLabel")
                        if textLabel then
                            textLabel.TextColor3 = _G.ESPColor
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

b:ColorPicker(
    "Color",
    Color3.fromRGB(255, 255, 255),
    function(color)
        _G.ESPColor = color
    end
)
