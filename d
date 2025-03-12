local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Doors GUI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "DoorsGUIConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

local espDoorsEnabled = false
local espKeysEnabled = false
local espLeversEnabled = false
local espLocksEnabled = false
local espBoxEnabled = false
local speedBoostEnabled = false
local lightBoostEnabled = false

local function createToggle(tab, name, callback)
    tab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Flag = name:gsub(" ", "_"),
        Callback = function(state)
            callback(state)
        end
    })
end

createToggle(Tab, "Toggle Doors ESP", function(state) espDoorsEnabled = state end)
createToggle(Tab, "Toggle Keys ESP", function(state) espKeysEnabled = state end)
createToggle(Tab, "Toggle Levers ESP", function(state) espLeversEnabled = state end)
createToggle(Tab, "Toggle Locks ESP", function(state) espLocksEnabled = state end)
createToggle(Tab, "Toggle Speed +30%", function(state) 
    speedBoostEnabled = state 
    if speedBoostEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed * 1.3
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed / 1.3
    end
end)
createToggle(Tab, "Toggle Light Boost", function(state) 
    lightBoostEnabled = state 
    game.Lighting.Brightness = lightBoostEnabled and 2 or 1
    game.Lighting.GlobalShadows = not lightBoostEnabled
end)

local function createESP(part, labelText)
    if part and not part:FindFirstChild("ESP") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = part
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)

        local textLabel = Instance.new("TextLabel")
        textLabel.Text = labelText
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 14
        textLabel.Parent = billboard

        billboard.Parent = part
    end
end

local function removeESP()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("BillboardGui") and v.Name == "ESP" then
            v:Destroy()
        end
    end
end

spawn(function()
    while true do
        removeESP()

        if espDoorsEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    createESP(room.Door.Door, "door / " .. i)
                end
            end
        end

        if espKeysEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Assets") then
                    local assets = room.Assets
                    if assets:FindFirstChild("Table") then
                        local tableContainer = assets.Table:FindFirstChild("DrawerContainer")
                        if tableContainer then
                            local key = tableContainer:FindFirstChild("KeyObtain")
                            if key then
                                print("Found KeyObtain in room", i)
                                for _, v in pairs(key:GetChildren()) do
                                    print("Key children:", v.Name)
                                end
                                if key:FindFirstChild("Hitbox") then
                                    createESP(key, "key / " .. i)
                                else
                                    print("KeyObtain has no Hitbox in room", i)
                                end
                            end
                        end
                    end
                end
            end
        end

        if espLeversEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Assets") and room.Assets:FindFirstChild("LeverForGate") then
                    createESP(room.Assets.LeverForGate.Main, "lever / " .. i)
                end
            end
        end

        if espLocksEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Door") and room.Door:FindFirstChild("Lock") then
                    createESP(room.Door.Lock, "lock / " .. i)
                end
            end
        end

        wait(0.5)
    end
end)
