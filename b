local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "ServiceGame - MM2",
   LoadingTitle = "Made by Wibu",
   LoadingSubtitle = "by Wibu",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = MurderMysteryFre,
      FileName = "ServiceGame"
   }
})

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Trade op")

local TextBox = Tab:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        playerNameTextbox = Text
    end,
})

local Button = Tab:CreateButton({
    Name = "Force Trade",
    Callback = function()
        if playerNameTextbox and playerNameTextbox ~= "" then
            local player = game.Players:FindFirstChild(playerNameTextbox)

            if player then
                local args = {
                    [1] = player
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Trade"):WaitForChild("SendRequest"):InvokeServer(unpack(args))
                game:GetService("ReplicatedStorage"):WaitForChild("Trade"):WaitForChild("AcceptRequest"):FireServer()
                
                Rayfield:Notify({
                    Title = "Trade System",
                    Content = "Force Traded Player: " .. playerNameTextbox,
                    Duration = 5,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function() end
                        },
                    },
                })
            else
                Rayfield:Notify({
                    Title = "Trade System",
                    Content = "Player not found.",
                    Duration = 5,
                    Image = 4483362458,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function() end
                        },
                    },
                })
            end
        else
            Rayfield:Notify({
                Title = "Trade System",
                Content = "Please enter a valid player name.",
                Duration = 5,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay!",
                        Callback = function() end
                    },
                },
            })
        end
    end,
})

-- ESP Chams Toggle Functionality
local chamsEnabled = false

local function ApplyChams(player)
    if chamsEnabled and player and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local chams = Instance.new("Highlight")
                chams.Parent = part
                chams.FillColor = Color3.new(1, 0, 0) -- Red for Murderer
                chams.OutlineColor = Color3.new(1, 1, 1)
                chams.FillTransparency = 0.5
            end
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        ApplyChams(player)
    end)
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character then
        ApplyChams(player)
    end
end

local ChamsToggle = Tab:CreateToggle({
    Name = "Toggle Chams",
    CurrentValue = false,
    Callback = function(state)
        chamsEnabled = state
        for _, player in pairs(game.Players:GetPlayers()) do
            ApplyChams(player)
        end
    end,
})
