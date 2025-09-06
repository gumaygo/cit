local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================================
-- LUAKU UNIVERSAL v1.0
-- Works on ALL Roblox Games
-- ================================

local Window = Rayfield:CreateWindow({
   Name = "GamiCiter Universal",
   LoadingTitle = "🔥 Loading Universal Script...",
   LoadingSubtitle = "Works on ALL games!",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "LuaKuUniversal",
      FileName = "UniversalConfig"
   },
   Theme = "Default",
   ToggleUIKeybind = "RightShift",
})

-- ================================
-- SERVICES & VARIABLES
-- ================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- States
local flying = false
local noclip = false
local esp = false
local fullbright = false
local speedEnabled = false
local jumpEnabled = false
local infiniteJump = false
local clickTeleport = false
local autoWalk = false
local freezeCharacter = false

-- Values
local flySpeed = 50
local walkSpeed = 16
local jumpPower = 50
local espDistance = 2000

-- Connections
local flyConnection
local noclipConnection
local espConnection
local autoWalkConnection
local coordsConnection

-- ================================
-- MOVEMENT TAB
-- ================================
local MovementTab = Window:CreateTab("🚀 Movement", nil)
local FlightSection = MovementTab:CreateSection("Flight & Movement")

-- Enhanced Fly System
local function StartFly()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = hrp
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then
            bodyVel:Destroy()
            flyConnection:Disconnect()
            return
        end
        
        local cam = Camera
        local dir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            dir = dir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            dir = dir - Vector3.new(0, 1, 0)
        end
        
        if dir.Magnitude > 0 then
            bodyVel.Velocity = dir.Unit * flySpeed
        else
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

MovementTab:CreateToggle({
   Name = "✈️ Fly Mode",
   CurrentValue = false,
   Flag = "FlyMode",
   Callback = function(Value)
       flying = Value
       if flying then
           StartFly()
       end
   end,
})

MovementTab:CreateSlider({
   Name = "🚀 Fly Speed",
   Range = {1, 500},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
       flySpeed = Value
   end,
})

-- Noclip
local function StartNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

MovementTab:CreateToggle({
   Name = "👻 Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
       noclip = Value
       if noclip then
           StartNoclip()
       else
           if noclipConnection then
               noclipConnection:Disconnect()
           end
           -- Restore collision
           if LocalPlayer.Character then
               for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                   if part:IsA("BasePart") then
                       part.CanCollide = true
                   end
               end
           end
       end
   end,
})

-- Speed & Jump
local SpeedSection = MovementTab:CreateSection("Speed & Jump")

MovementTab:CreateSlider({
   Name = "🏃 Walk Speed",
   Range = {1, 1000},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
       walkSpeed = Value
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

MovementTab:CreateSlider({
   Name = "🦘 Jump Power",
   Range = {1, 1000},
   Increment = 1,
   Suffix = " Power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
       jumpPower = Value
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.JumpPower = Value
       end
   end,
})

-- Infinite Jump
MovementTab:CreateToggle({
   Name = "🌟 Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
       infiniteJump = Value
       if infiniteJump then
           _G.infinjump = true
           
           if _G.infinJumpStarted == nil then
               _G.infinJumpStarted = true
               
               local plr = LocalPlayer
               local m = plr:GetMouse()
               m.KeyDown:connect(function(k)
                   if _G.infinjump then
                       if k:byte() == 32 then
                           local humanoid = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                           if humanoid then
                               humanoid:ChangeState('Jumping')
                               wait()
                               humanoid:ChangeState('Seated')
                           end
                       end
                   end
               end)
           end
       else
           _G.infinjump = false
       end
   end,
})

-- Click Teleport
MovementTab:CreateToggle({
   Name = "🖱️ Click Teleport",
   CurrentValue = false,
   Flag = "ClickTeleport",
   Callback = function(Value)
       clickTeleport = Value
       if clickTeleport then
           local Mouse = LocalPlayer:GetMouse()
           Mouse.Button1Down:Connect(function()
               if clickTeleport and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                   LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 5, 0))
               end
           end)
       end
   end,
})

-- ================================
-- VISUAL TAB
-- ================================
local VisualTab = Window:CreateTab("👁️ Visual", nil)
local LightingSection = VisualTab:CreateSection("Lighting & Effects")

-- Fullbright
VisualTab:CreateToggle({
   Name = "💡 Fullbright",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
       fullbright = Value
       if fullbright then
           Lighting.Brightness = 3
           Lighting.ClockTime = 12
           Lighting.FogEnd = 100000
           Lighting.GlobalShadows = false
           Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
       else
           Lighting.Brightness = 1
           Lighting.ClockTime = 14
           Lighting.FogEnd = 100000
           Lighting.GlobalShadows = true
           Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
       end
   end,
})

-- ESP System
local espFolder
local function CreateESP()
    -- Remove old ESP
    if espFolder then
        espFolder:Destroy()
    end
    
    espFolder = Instance.new("Folder")
    espFolder.Name = "ESP"
    espFolder.Parent = workspace
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            
            if distance <= espDistance then
                -- Name ESP
                local billboard = Instance.new("BillboardGui")
                billboard.Parent = hrp
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.Name = "ESP_" .. player.Name
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Parent = billboard
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Parent = billboard
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.Text = math.floor(distance) .. " studs"
                distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                distanceLabel.TextScaled = true
                distanceLabel.Font = Enum.Font.Gotham
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                
                -- Box ESP
                local boxGui = Instance.new("BillboardGui")
                boxGui.Parent = hrp
                boxGui.Size = UDim2.new(0, 4, 0, 6)
                boxGui.StudsOffset = Vector3.new(0, 0, 0)
                boxGui.Name = "BoxESP_" .. player.Name
                
                local box = Instance.new("Frame")
                box.Parent = boxGui
                box.Size = UDim2.new(1, 0, 1, 0)
                box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                box.BackgroundTransparency = 0.7
                box.BorderSizePixel = 2
                box.BorderColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

local function UpdateESP()
    if esp and espFolder then
        espConnection = RunService.Heartbeat:Connect(function()
            if esp then
                CreateESP()
            else
                if espConnection then
                    espConnection:Disconnect()
                end
            end
        end)
    end
end

VisualTab:CreateToggle({
   Name = "👥 Player ESP",
   CurrentValue = false,
   Flag = "PlayerESP",
   Callback = function(Value)
       esp = Value
       if esp then
           UpdateESP()
       else
           if espConnection then
               espConnection:Disconnect()
           end
           if espFolder then
               espFolder:Destroy()
           end
       end
   end,
})

VisualTab:CreateSlider({
   Name = "📏 ESP Distance",
   Range = {100, 10000},
   Increment = 100,
   Suffix = " studs",
   CurrentValue = 2000,
   Flag = "ESPDistance",
   Callback = function(Value)
       espDistance = Value
   end,
})

-- Camera FOV
VisualTab:CreateSlider({
   Name = "📷 Camera FOV",
   Range = {10, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Flag = "CameraFOV",
   Callback = function(Value)
       Camera.FieldOfView = Value
   end,
})

-- ================================
-- PLAYER TAB
-- ================================
local PlayerTab = Window:CreateTab("👤 Player", nil)
local PlayerSection = PlayerTab:CreateSection("Player Modifications")

-- Character Control
PlayerTab:CreateToggle({
   Name = "🧊 Freeze Character",
   CurrentValue = false,
   Flag = "FreezeCharacter",
   Callback = function(Value)
       freezeCharacter = Value
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.Anchored = freezeCharacter
       end
   end,
})

-- Invisible Character
PlayerTab:CreateButton({
   Name = "👻 Invisible",
   Callback = function()
       if LocalPlayer.Character then
           for _, part in pairs(LocalPlayer.Character:GetChildren()) do
               if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                   part.Transparency = 1
               elseif part:IsA("Accessory") then
                   part.Handle.Transparency = 1
               end
           end
           LocalPlayer.Character.Head.face.Transparency = 1
       end
   end,
})

-- Visible Character
PlayerTab:CreateButton({
   Name = "👁️ Visible",
   Callback = function()
       if LocalPlayer.Character then
           for _, part in pairs(LocalPlayer.Character:GetChildren()) do
               if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                   part.Transparency = 0
               elseif part:IsA("Accessory") then
                   part.Handle.Transparency = 0
               end
           end
           LocalPlayer.Character.Head.face.Transparency = 0
       end
   end,
})

-- Reset Character
PlayerTab:CreateButton({
   Name = "🔄 Reset Character",
   Callback = function()
       LocalPlayer.Character.Humanoid.Health = 0
   end,
})

-- Respawn Character
PlayerTab:CreateButton({
   Name = "♻️ Respawn",
   Callback = function()
       LocalPlayer:LoadCharacter()
   end,
})

-- God Mode
PlayerTab:CreateToggle({
   Name = "🛡️ God Mode",
   CurrentValue = false,
   Flag = "GodMode",
   Callback = function(Value)
       if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.MaxHealth = math.huge
           LocalPlayer.Character.Humanoid.Health = math.huge
       elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.MaxHealth = 100
           LocalPlayer.Character.Humanoid.Health = 100
       end
   end,
})

-- ================================
-- TELEPORT TAB
-- ================================
local TeleportTab = Window:CreateTab("📍 Teleport", nil)
local TeleportSection = TeleportTab:CreateSection("Quick Teleports")

-- Teleport to Players
local function GetPlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

TeleportTab:CreateDropdown({
   Name = "Teleport to Player",
   Options = GetPlayerList(),
   CurrentOption = {"Select Player"},
   MultipleOptions = false,
   Flag = "TeleportPlayer",
   Callback = function(Option)
       for _, player in pairs(Players:GetPlayers()) do
           if player.Name == Option[1] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                   LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
               end
               break
           end
       end
   end,
})

-- Bring Player to You
TeleportTab:CreateDropdown({
   Name = "Bring Player to You",
   Options = GetPlayerList(),
   CurrentOption = {"Select Player"},
   MultipleOptions = false,
   Flag = "BringPlayer",
   Callback = function(Option)
       for _, player in pairs(Players:GetPlayers()) do
           if player.Name == Option[1] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                   player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
               end
               break
           end
       end
   end,
})

-- Teleport to Spawn
TeleportTab:CreateButton({
   Name = "🏠 Teleport to Spawn",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           for _, spawnLocation in pairs(workspace:GetChildren()) do
               if spawnLocation:IsA("SpawnLocation") then
                   LocalPlayer.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
                   break
               end
           end
       end
   end,
})

-- ================================
-- TOOLS TAB
-- ================================
local ToolsTab = Window:CreateTab("🔧 Tools", nil)
local UtilitySection = ToolsTab:CreateSection("Utility Tools")

-- Coordinates
local currentCoords = "Position: Not available"
local coordsEnabled = false

local function UpdateCoords()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        currentCoords = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z)
    else
        currentCoords = "Position: Character not found"
    end
end

ToolsTab:CreateToggle({
   Name = "📍 Show Coordinates",
   CurrentValue = false,
   Flag = "ShowCoordinates",
   Callback = function(Value)
       coordsEnabled = Value
       if coordsEnabled then
           coordsConnection = RunService.Heartbeat:Connect(function()
               if coordsEnabled then
                   UpdateCoords()
               end
           end)
       else
           if coordsConnection then
               coordsConnection:Disconnect()
           end
           currentCoords = "Position: Disabled"
       end
   end,
})

ToolsTab:CreateParagraph({
   Title = "Current Position",
   Content = function()
       return currentCoords
   end
})

-- Copy Position
ToolsTab:CreateButton({
   Name = "📋 Copy Position",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           local pos = LocalPlayer.Character.HumanoidRootPart.Position
           local posText = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
           
           pcall(function()
               setclipboard(posText)
           end)
           
           Rayfield:Notify({
              Title = "Position Copied!",
              Content = posText,
              Duration = 3,
           })
       end
   end,
})

-- Delete All Tools
ToolsTab:CreateButton({
   Name = "🗑️ Delete All Tools",
   Callback = function()
       if LocalPlayer.Backpack then
           LocalPlayer.Backpack:ClearAllChildren()
       end
       if LocalPlayer.Character then
           for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
               if tool:IsA("Tool") then
                   tool:Destroy()
               end
           end
       end
   end,
})

-- Anti-AFK
local antiAFK = false
ToolsTab:CreateToggle({
   Name = "⏰ Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(Value)
       antiAFK = Value
       if antiAFK then
           task.spawn(function()
               while antiAFK do
                   task.wait(300) -- 5 minutes
                   if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                       -- Small movement to prevent AFK
                       LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0.1, 0, 0)
                       task.wait(0.1)
                       LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(-0.1, 0, 0)
                   end
               end
           end)
       end
   end,
})

-- ================================
-- SERVER TAB
-- ================================
local ServerTab = Window:CreateTab("🌐 Server", nil)
local ServerSection = ServerTab:CreateSection("Server Functions")

-- Server Info
ServerTab:CreateButton({
   Name = "📊 Server Information",
   Callback = function()
       local playerCount = #Players:GetPlayers()
       local gameId = game.GameId
       local placeId = game.PlaceId
       local jobId = game.JobId
       
       Rayfield:Notify({
          Title = "Server Information",
          Content = "Players: " .. playerCount .. "\nGame ID: " .. gameId .. "\nPlace ID: " .. placeId,
          Duration = 6,
       })
   end,
})

-- Rejoin Server
ServerTab:CreateButton({
   Name = "🔄 Rejoin Server",
   Callback = function()
       TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

-- Join Smallest Server
ServerTab:CreateButton({
   Name = "👥 Join Smallest Server",
   Callback = function()
       TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
   end,
})

-- Copy Game Link
ServerTab:CreateButton({
   Name = "🔗 Copy Game Link",
   Callback = function()
       local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
       pcall(function()
           setclipboard(gameLink)
       end)
       
       Rayfield:Notify({
          Title = "Game Link Copied!",
          Content = gameLink,
          Duration = 4,
       })
   end,
})

-- ================================
-- SETTINGS TAB
-- ================================
local SettingsTab = Window:CreateTab("⚙️ Settings", nil)

SettingsTab:CreateKeybind({
   Name = "Toggle UI",
   CurrentKeybind = "RightShift",
   HoldToInteract = false,
   Flag = "ToggleUI",
   Callback = function(Keybind)
       -- Handled by Rayfield
   end,
})

SettingsTab:CreateButton({
   Name = "🗑️ Destroy GUI",
   Callback = function()
       Rayfield:Destroy()
   end,
})

-- ================================
-- AUTO-RESTORE ON RESPAWN
-- ================================
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(2)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Restore all settings
    if walkSpeed ~= 16 then
        humanoid.WalkSpeed = walkSpeed
    end
    if jumpPower ~= 50 then
        humanoid.JumpPower = jumpPower
    end
    if freezeCharacter then
        character.HumanoidRootPart.Anchored = true
    end
end)

-- Update dropdown lists periodically
task.spawn(function()
    while true do
        wait(5)
        pcall(function()
            local newPlayerList = GetPlayerList()
            if Rayfield.Flags then
                if Rayfield.Flags["TeleportPlayer"] then
                    Rayfield.Flags["TeleportPlayer"]:Set(newPlayerList)
                end
                if Rayfield.Flags["BringPlayer"] then
                    Rayfield.Flags["BringPlayer"]:Set(newPlayerList)
                end
            end
        end)
    end
end)

-- ================================
-- INITIALIZATION
-- ================================
Rayfield:Notify({
   Title = "🌍 Universal Script Loaded!",
   Content = "Works on ALL Roblox games!\nPress RightShift to toggle UI",
   Duration = 5,
})

print("🌍 LuaKu Universal v1.0 - Loaded Successfully!")
print("🎮 Compatible with ALL Roblox games")
print("⚡ " .. #MovementTab.Objects + #VisualTab.Objects + #PlayerTab.Objects + #TeleportTab.Objects + #ToolsTab.Objects + #ServerTab.Objects .. " features loaded")
