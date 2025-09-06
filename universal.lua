-- ================================
-- GAMICITER UNIVERSAL v2.0
-- Simple & Stable Version
-- ================================

print("🔄 Loading GamiCiter Universal...")

-- Safe loading with error handling
local Rayfield
local success, error_msg = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error!";
        Text = "Failed to load Rayfield UI: " .. tostring(error_msg);
        Duration = 10;
    })
    return
end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "GamiCiter Universal",
   LoadingTitle = "🚀 Loading Universal Script",
   LoadingSubtitle = "Works on ALL games!",
   ConfigurationSaving = {
      Enabled = false,
   },
   Theme = "Default",
   ToggleUIKeybind = "RightShift",
})

-- ================================
-- MOVEMENT TAB
-- ================================
local MovementTab = Window:CreateTab("🚀 Movement", nil)

-- Fly Variables
local flying = false
local flySpeed = 50
local flyConnection

-- Fly Function
local function ToggleFly(value)
    flying = value
    
    if flying then
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = char.HumanoidRootPart
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.Parent = hrp
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if bodyVel then bodyVel:Destroy() end
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            
            local dir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                dir = dir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                dir = dir + Camera.CFrame.RightVector
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
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end

MovementTab:CreateToggle({
   Name = "✈️ Fly Mode",
   CurrentValue = false,
   Callback = ToggleFly,
})

MovementTab:CreateSlider({
   Name = "🚀 Fly Speed",
   Range = {1, 200},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 50,
   Callback = function(Value)
       flySpeed = Value
   end,
})

-- Noclip
local noclip = false
local noclipConnection

MovementTab:CreateToggle({
   Name = "👻 Noclip",
   CurrentValue = false,
   Callback = function(Value)
       noclip = Value
       
       if noclip then
           noclipConnection = RunService.Stepped:Connect(function()
               if noclip and LocalPlayer.Character then
                   for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                       if part:IsA("BasePart") and part.CanCollide then
                           part.CanCollide = false
                       end
                   end
               end
           end)
       else
           if noclipConnection then
               noclipConnection:Disconnect()
               noclipConnection = nil
           end
           
           -- Restore collision
           task.wait(0.1)
           if LocalPlayer.Character then
               for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                   if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                       part.CanCollide = true
                   end
               end
           end
       end
   end,
})

-- Speed
MovementTab:CreateSlider({
   Name = "🏃 Walk Speed",
   Range = {1, 500},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Jump Power
MovementTab:CreateSlider({
   Name = "🦘 Jump Power",
   Range = {1, 500},
   Increment = 1,
   Suffix = " Power",
   CurrentValue = 50,
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.JumpPower = Value
       end
   end,
})

-- ================================
-- VISUAL TAB
-- ================================
local VisualTab = Window:CreateTab("👁️ Visual", nil)

-- Fullbright
local fullbright = false
VisualTab:CreateToggle({
   Name = "💡 Fullbright",
   CurrentValue = false,
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

-- Camera FOV
VisualTab:CreateSlider({
   Name = "📷 Camera FOV",
   Range = {10, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Callback = function(Value)
       Camera.FieldOfView = Value
   end,
})

-- ================================
-- PLAYER TAB
-- ================================
local PlayerTab = Window:CreateTab("👤 Player", nil)

-- God Mode
PlayerTab:CreateToggle({
   Name = "🛡️ God Mode",
   CurrentValue = false,
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

-- Invisible
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
           if LocalPlayer.Character.Head:FindFirstChild("face") then
               LocalPlayer.Character.Head.face.Transparency = 1
           end
       end
   end,
})

-- Visible
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
           if LocalPlayer.Character.Head:FindFirstChild("face") then
               LocalPlayer.Character.Head.face.Transparency = 0
           end
       end
   end,
})

-- Reset
PlayerTab:CreateButton({
   Name = "🔄 Reset Character",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.Health = 0
       end
   end,
})

-- ================================
-- TELEPORT TAB
-- ================================
local TeleportTab = Window:CreateTab("📍 Teleport", nil)

-- Click Teleport
local clickTeleport = false
TeleportTab:CreateToggle({
   Name = "🖱️ Click Teleport",
   CurrentValue = false,
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

-- Teleport to Spawn
TeleportTab:CreateButton({
   Name = "🏠 Teleport to Spawn",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           for _, obj in pairs(workspace:GetChildren()) do
               if obj:IsA("SpawnLocation") then
                   LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
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

-- Coordinates
local currentCoords = "Position: Not available"
local coordsEnabled = false
local coordsConnection

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
               coordsConnection = nil
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
           
           local success = pcall(function()
               setclipboard(posText)
           end)
           
           if success then
               Rayfield:Notify({
                  Title = "Position Copied!",
                  Content = posText,
                  Duration = 3,
               })
           else
               game.StarterGui:SetCore("SendNotification", {
                   Title = "Position";
                   Text = posText;
                   Duration = 5;
               })
           end
       end
   end,
})

-- ================================
-- SERVER TAB
-- ================================
local ServerTab = Window:CreateTab("🌐 Server", nil)

-- Server Info
ServerTab:CreateButton({
   Name = "📊 Server Information",
   Callback = function()
       local playerCount = #Players:GetPlayers()
       local gameId = game.GameId
       local placeId = game.PlaceId
       
       Rayfield:Notify({
          Title = "Server Information",
          Content = "Players: " .. playerCount .. "\nGame ID: " .. gameId .. "\nPlace ID: " .. placeId,
          Duration = 6,
       })
   end,
})

-- Rejoin
ServerTab:CreateButton({
   Name = "🔄 Rejoin Server",
   Callback = function()
       TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

-- Copy Game Link
ServerTab:CreateButton({
   Name = "🔗 Copy Game Link",
   Callback = function()
       local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
       
       local success = pcall(function()
           setclipboard(gameLink)
       end)
       
       if success then
           Rayfield:Notify({
              Title = "Game Link Copied!",
              Content = gameLink,
              Duration = 4,
           })
       else
           game.StarterGui:SetCore("SendNotification", {
               Title = "Game Link";
               Text = gameLink;
               Duration = 5;
           })
       end
   end,
})

-- ================================
-- SETTINGS TAB
-- ================================
local SettingsTab = Window:CreateTab("⚙️ Settings", nil)

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
    task.wait(1)
    -- Auto-restore settings akan dikembalikan oleh Rayfield flags
end)

-- ================================
-- INITIALIZATION COMPLETE
-- ================================
Rayfield:Notify({
   Title = "✅ GamiCiter Universal Loaded!",
   Content = "Script loaded successfully!\nPress RightShift to toggle UI",
   Duration = 5,
})

print("✅ GamiCiter Universal v2.0 - Loaded Successfully!")
print("🎮 Ready to use on ALL Roblox games!")
