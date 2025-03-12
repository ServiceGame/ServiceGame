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

-- Функция для создания переключателей
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

-- Функции переключения
local function toggleEspBox(state)
    espBoxEnabled = state
    print("ESP Box " .. (espBoxEnabled and "enabled" or "disabled"))
end

local function toggleEspDoors(state)
    espDoorsEnabled = state
    print("ESP for doors " .. (espDoorsEnabled and "enabled" or "disabled"))
end

local function toggleEspKeys(state)
    espKeysEnabled = state
    print("ESP for keys " .. (espKeysEnabled and "enabled" or "disabled"))
end

local function toggleEspLevers(state)
    espLeversEnabled = state
    print("ESP for levers " .. (espLeversEnabled and "enabled" or "disabled"))
end

local function toggleEspLocks(state)
    espLocksEnabled = state
    print("ESP for locks " .. (espLocksEnabled and "enabled" or "disabled"))
end

local function toggleSpeedBoost(state)
    speedBoostEnabled = state
    if speedBoostEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed * 1.3
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed / 1.3
    end
end

local function toggleLightBoost(state)
    lightBoostEnabled = state
    game.Lighting.Brightness = lightBoostEnabled and 2 or 1
    game.Lighting.GlobalShadows = not lightBoostEnabled
end

-- Функции для включения/выключения ESP
local function toggleEspDoors()
    espDoorsEnabled = not espDoorsEnabled
    if espDoorsEnabled then
        print("ESP for doors enabled")
    else
        print("ESP for doors disabled")
    end
end

local function toggleEspKeys()
    espKeysEnabled = not espKeysEnabled
    if espKeysEnabled then
        print("ESP for keys enabled")
    else
        print("ESP for keys disabled")
    end
end

local function toggleEspLevers()
    espLeversEnabled = not espLeversEnabled
    if espLeversEnabled then
        print("ESP for levers enabled")
    else
        print("ESP for levers disabled")
    end
end

local function toggleEspLocks()
    espLocksEnabled = not espLocksEnabled
    if espLocksEnabled then
        print("ESP for locks enabled")
    else
        print("ESP for locks disabled")
    end
end

-- Создание кнопок для включения/выключения ESP
createToggle("Toggle Doors ESP", toggleEspDoors)
createToggle("Toggle Keys ESP", toggleEspKeys)
createToggle("Toggle Levers ESP", toggleEspLevers)
createToggle("Toggle Locks ESP", toggleEspLocks)

-- Функции для активации SpeedBoost и LightBoost
local function toggleSpeedBoost()
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        print("Speed Boost enabled")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed * 1.3
    else
        print("Speed Boost disabled")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed / 1.3
    end
end

local function toggleLightBoost()
    lightBoostEnabled = not lightBoostEnabled
    if lightBoostEnabled then
        print("Light Boost enabled")
        game.Lighting.Brightness = 2
        game.Lighting.GlobalShadows = false
    else
        print("Light Boost disabled")
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
    end
end

-- Добавляем кнопки для SpeedBoost и LightBoost
createToggle("Toggle Speed +30%", toggleSpeedBoost)
createToggle("Toggle Light Boost", toggleLightBoost)

-- Функция для создания ESP
local function createESP(part, labelText)
    if not part:FindFirstChild("ESP") then
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

-- Функция для удаления старых ESP
local function removeESP()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("BillboardGui") and v.Name == "ESP" then
            v:Destroy()
        end
    end
end

-- Основной цикл для обновления ESP
spawn(function()
    while true do
        removeESP()  -- Удаляем старые обводки перед обновлением

        -- Обводка дверей
        if espDoorsEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    createESP(room.Door.Door, "door / " .. i)
                end
            end
        end

        -- Обводка ключей
        if espKeysEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Assets") then
                    local assets = room.Assets

                    if assets:FindFirstChild("Table") and assets.Table:FindFirstChild("DrawerContainer") and assets.Table.DrawerContainer:FindFirstChild("KeyObtain") then
                        local key = assets.Table.DrawerContainer.KeyObtain
                        if key:FindFirstChild("Hitbox") and key.Hitbox:FindFirstChild("KeyHitbox") then
                            createESP(key.Hitbox.KeyHitbox, "key / " .. i)
                        end
                    end
                end
            end
        end

        -- Обводка рычагов
        if espLeversEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Assets") and room.Assets:FindFirstChild("LeverForGate") then
                    createESP(room.Assets.LeverForGate.Main, "lever / " .. i)
                end
            end
        end

        -- Обводка замков дверей
        if espLocksEnabled then
            for i = 0, 100 do
                local room = game:GetService("Workspace").CurrentRooms:FindFirstChild(tostring(i))
                if room and room:FindFirstChild("Door") and room.Door:FindFirstChild("Lock") then
                    createESP(room.Door.Lock, "lock / " .. i)
                end
            end
        end

        wait(0.5)  -- Обновление каждые 0.5 секунд
    end
end)
