local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ServiceGame - Universal",
   LoadingTitle = "ServiceGame",
   LoadingSubtitle = "Made by Wibu",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "ServiceGame Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "gtQ54c43G3", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Wibu"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("HOME", nil) -- Title, Image
local Section = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "Enjoy!",
   Content = "ServiceGame  discord.gg/gtQ54c43G3",
   Duration = 6.5,
   Image = 4483362458,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})

local Button = MainTab:CreateButton({
   Name = "Wizard West",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/Wizard-West/refs/heads/main/ibs"))()
   end,
})

local Button2 = MainTab:CreateButton({
   Name = "War Tycoon",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/War-tycoon/refs/heads/main/ibs"))()
   end,
})

local Button3 = MainTab:CreateButton({
   Name = "WestBound",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/WestBound/refs/heads/main/ibs"))()
   end,
})

local Button4 = MainTab:CreateButton({
   Name = "WestBound FULL",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/WBFULL/refs/heads/main/ibs"))()
   end,
})

local Button5 = MainTab:CreateButton({
   Name = "Project Delta",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/Protect-Delta/refs/heads/main/Protect%20Delta"))()
   end,
})

local Button6 = MainTab:CreateButton({
   Name = "Arm Wrestle Simulator",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/Arm-Wrestle-Simulator/refs/heads/main/ibs"))()
   end,
})

local Button7 = MainTab:CreateButton({
   Name = "Build a Boat Treasue", 
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/ServiceGame/refs/heads/main/Build%20a%20Boat%20Treasue"))()
   end,
})

local Button8 = MainTab:CreateButton({
   Name = "Blade's Rebirth",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/Blade-s-Rebirth/refs/heads/main/r"))()
   end,
})

local Button9 = MainTab:CreateButton({
   Name = "Blox Fruit",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/BF/refs/heads/main/ibs"))()
   end,
})

local Button10 = MainTab:CreateButton({
   Name = "Jujutsu Infinite",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/JujutsuInfiniTE/refs/heads/main/ibs"))()
   end,
})

local Button11 = MainTab:CreateButton({
   Name = "Arsenal",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/ServiceGame/refs/heads/main/ArsenalVIP"))()
   end,
})

local Button12 = MainTab:CreateButton({
   Name = "One Piece: Legendary",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/ServiceGame/refs/heads/main/OPL"))()
   end,
})

local Button13 = MainTab:CreateButton({
   Name = "CDVN",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Albedo1224/CongDongVN/refs/heads/main/AutoShip.lua"))()
   end,
})

local Button14 = MainTab:CreateButton({
   Name = "Combat Warrior",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Wibudz123/ServiceGame/refs/heads/main/CombatWarrior"))()
   end,
})

local Button15 = MainTab:CreateButton({
   Name = "Evade",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/ServiceGame/ServiceGame/refs/heads/Loader/Evade"))()
   end,
})

local MainTab = Window:CreateTab("Other", nil) -- Title, Image
local Section = MainTab:CreateSection("Misc")

local Button = MainTab:CreateButton({
   Name = "Infinite Yield FE v6.3",
   Callback = function()
   loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
   end,
})

local Button2 = MainTab:CreateButton({
   Name = "DeadRails - Crack (NO KEY)",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/thientnn/Script/refs/heads/main/main.lua'))()
   end,
})

local Button3 = MainTab:CreateButton({
   Name = "Ro-Ghoul - Best (NO KEY)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/DashBoostSolora.lua"))()
   end,
})

local MainTab = Window:CreateTab("Credits", nil) -- Title, Image
local Section = MainTab:CreateSection("Discord - Owner")

local Button = MainTab:CreateButton({
   Name = "https://discord.gg/gtQ54c43G3",
   Callback = function()
   end,
})

local Button2 = MainTab:CreateButton({
   Name = "Owner Wibu",
   Callback = function()
   end,
})
