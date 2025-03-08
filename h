local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 0.2, 0)
TextLabel.Position = UDim2.new(0, 0, 0.1, 0)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 28
TextLabel.TextScaled = true
TextLabel.TextWrap = true
TextLabel.BackgroundTransparency = 1
TextLabel.Text = ""

CopyButton.Parent = Frame
CopyButton.Size = UDim2.new(0.3, 0, 0.1, 0)
CopyButton.Position = UDim2.new(0.35, 0, 0.4, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
CopyButton.Text = "Copy Script Link"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 20
CopyButton.TextScaled = true

local textToDisplay = "Discover the New Version of Rayan’s Hub\nPrison Life - Keyless Edition"
local charIndex = 1

local function typeText()
    while charIndex <= #textToDisplay do
        TextLabel.Text = string.sub(textToDisplay, 1, charIndex)
        charIndex = charIndex + 1
        wait(0.04)
    end
end

local function animateButton()
    CopyButton:TweenSize(UDim2.new(0.35, 0, 0.12, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
    wait(0.5)
    CopyButton:TweenSize(UDim2.new(0.3, 0, 0.1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
end

typeText()

CopyButton.MouseButton1Click:Connect(function()
    setclipboard("https://scriptblox.com/script/Prison-Life-Rayans-hub-31130")
    CopyButton.Text = "Copied"
    CopyButton.BackgroundColor3 = Color3.fromRGB(34, 177, 76)
    animateButton()
    wait(0.5)
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    CopyButton.Text = "Copy Script Link"
    print("The link has been copied to the clipboard.")
end)
