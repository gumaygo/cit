local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================================
-- GAMICITER SIMPLE v1.0
-- Simple & Clean Interface
-- ================================

local Window = Rayfield:CreateWindow({
   Name = "GamiCiter Simple",
   Icon = 0,
   LoadingTitle = "Loading Simple Script...",
   LoadingSubtitle = "GamiCiter Simple v1.0",
   ShowText = "GAMITEX SIMPLE",
   Theme = "Default",
   ToggleUIKeybind = "K",
})

-- ================================
-- SERVICES & VARIABLES
-- ================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- States
local flying = false
local walkSpeedEnabled = false
local adminTextEnabled = false
local coordsEnabled = false

-- Values
local flySpeed = 50
local walkSpeed = 16

-- Connections
local flyConnection
local coordsConnection
local adminBillboard

-- ================================
-- MAIN TAB
-- ================================
local MainTab = Window:CreateTab("🎮 Main", nil)

-- ================================
-- FLY SYSTEM
-- ================================
local FlightSection = MainTab:CreateSection("Flight System")

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

        local camera = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)

        -- Movement controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        if direction.Magnitude > 0 then
            bodyVel.Velocity = direction.Unit * flySpeed
        else
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

MainTab:CreateToggle({
   Name = "✈️ Fly Mode",
   CurrentValue = false,
   Flag = "FlyMode",
   Callback = function(state)
       flying = state
       if flying then
           StartFly()
           Rayfield:Notify({
              Title = "Fly Enabled!",
              Content = "Use WASD + Space/Shift to fly",
              Duration = 3,
              Image = 4483362458,
           })
       else
           if flyConnection then
               flyConnection:Disconnect()
           end
           Rayfield:Notify({
              Title = "Fly Disabled",
              Content = "Flight mode deactivated",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

MainTab:CreateSlider({
   Name = "🚀 Fly Speed",
   Range = {10, 200},
   Increment = 5,
   Suffix = " Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
       flySpeed = Value
   end,
})

-- ================================
-- WALK SYSTEM
-- ================================
local WalkSection = MainTab:CreateSection("Walk System")

MainTab:CreateToggle({
   Name = "🏃 Walk Speed",
   CurrentValue = false,
   Flag = "WalkSpeed",
   Callback = function(state)
       walkSpeedEnabled = state
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           if walkSpeedEnabled then
               LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
               Rayfield:Notify({
                  Title = "Walk Speed Enabled!",
                  Content = "Speed set to " .. walkSpeed,
                  Duration = 2,
                  Image = 4483362458,
               })
           else
               LocalPlayer.Character.Humanoid.WalkSpeed = 16
               Rayfield:Notify({
                  Title = "Walk Speed Disabled",
                  Content = "Speed restored to normal",
                  Duration = 2,
                  Image = 4483362458,
               })
           end
       end
   end,
})

MainTab:CreateSlider({
   Name = "🏃 Speed Value",
   Range = {16, 200},
   Increment = 2,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedValue",
   Callback = function(Value)
       walkSpeed = Value
       if walkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- ================================
-- SERVER FUNCTIONS
-- ================================
local ServerSection = MainTab:CreateSection("Server Functions")

MainTab:CreateButton({
   Name = "🔄 Rejoin Server",
   Callback = function()
       Rayfield:Notify({
          Title = "Rejoining...",
          Content = "Reconnecting to server",
          Duration = 2,
          Image = 4483362458,
       })
       TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

MainTab:CreateButton({
   Name = "📊 Server Info",
   Callback = function()
       local playerCount = #Players:GetPlayers()
       local gameId = game.GameId
       local placeId = game.PlaceId
       
       Rayfield:Notify({
          Title = "Server Information",
          Content = "Players: " .. playerCount .. "\nGame ID: " .. gameId .. "\nPlace ID: " .. placeId,
          Duration = 5,
          Image = 4483362458,
       })
   end,
})

-- ================================
-- VISUAL TAB
-- ================================
local VisualTab = Window:CreateTab("👁️ Visual", nil)

-- ================================
-- ADMIN TEXT BILLBOARD
-- ================================
local TextSection = VisualTab:CreateSection("Admin Text")

local function AddAdminText()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then
        return
    end
    
    local head = LocalPlayer.Character.Head
    
    -- Remove existing billboard
    if adminBillboard then
        adminBillboard:Destroy()
    end
    
    -- Create new billboard - smaller size and higher position
    adminBillboard = Instance.new("BillboardGui")
    adminBillboard.Parent = head
    adminBillboard.Size = UDim2.new(0, 80, 0, 25)  -- Smaller size
    adminBillboard.StudsOffset = Vector3.new(0, 3.5, 0)  -- Higher position
    adminBillboard.Name = "AdminBillboard"
    
    local frame = Instance.new("Frame")
    frame.Parent = adminBillboard
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)  -- Smaller corner radius
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "admin"  -- Lowercase and smaller
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14  -- Fixed small text size
    label.Font = Enum.Font.Gotham
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

local function RemoveAdminText()
    if adminBillboard then
        adminBillboard:Destroy()
        adminBillboard = nil
    end
end

VisualTab:CreateToggle({
   Name = "👑 Admin Text",
   CurrentValue = false,
   Flag = "AdminText",
   Callback = function(state)
       adminTextEnabled = state
       if adminTextEnabled then
           AddAdminText()
           Rayfield:Notify({
              Title = "Admin Text Enabled!",
              Content = "Text added above your head",
              Duration = 3,
              Image = 4483362458,
           })
       else
           RemoveAdminText()
           Rayfield:Notify({
              Title = "Admin Text Disabled",
              Content = "Text removed",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- ================================
-- COORDINATES DISPLAY
-- ================================
local CoordsSection = VisualTab:CreateSection("Coordinates")

-- Variables for coordinates in GUI box
local currentCoords = "Loading..."

-- Function to update coordinates text
local function UpdateCoordinates()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        local x = math.floor(pos.X * 100) / 100
        local y = math.floor(pos.Y * 100) / 100
        local z = math.floor(pos.Z * 100) / 100
        
        currentCoords = string.format("X: %.2f, Y: %.2f, Z: %.2f", x, y, z)
        return currentCoords
    else
        currentCoords = "Character not found"
        return currentCoords
    end
end

-- Start coordinate monitoring
local function StartCoordMonitoring()
    coordsConnection = RunService.Heartbeat:Connect(function()
        if coordsEnabled then
            UpdateCoordinates()
        else
            if coordsConnection then
                coordsConnection:Disconnect()
                coordsConnection = nil
            end
        end
    end)
end

VisualTab:CreateToggle({
   Name = "📍 Show Coordinates",
   CurrentValue = false,
   Flag = "ShowCoords",
   Callback = function(state)
       coordsEnabled = state
       if coordsEnabled then
           StartCoordMonitoring()
           Rayfield:Notify({
              Title = "Coordinates Enabled!",
              Content = "Coordinates now updating in GUI",
              Duration = 3,
              Image = 4483362458,
           })
       else
           if coordsConnection then
               coordsConnection:Disconnect()
               coordsConnection = nil
           end
           Rayfield:Notify({
              Title = "Coordinates Disabled",
              Content = "Coordinate monitoring stopped",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

-- Display current coordinates in GUI box
VisualTab:CreateParagraph({
   Title = "Current Position",
   Content = function()
       if coordsEnabled then
           return UpdateCoordinates()
       else
           return "Enable 'Show Coordinates' to see position"
       end
   end
})

VisualTab:CreateButton({
   Name = "📋 Copy Current Position",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           local pos = LocalPlayer.Character.HumanoidRootPart.Position
           local coordText = string.format("CFrame.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
           
           Rayfield:Notify({
              Title = "Position Copied!",
              Content = coordText,
              Duration = 5,
              Image = 4483362458,
           })
           
           -- Try to copy to clipboard (may not work in all executors)
           pcall(function()
               setclipboard(coordText)
           end)
       else
           Rayfield:Notify({
              Title = "Copy Failed",
              Content = "Character not found",
              Duration = 3,
              Image = 4483362458,
           })
       end
   end,
})

VisualTab:CreateButton({
   Name = "📋 Copy Raw Coordinates",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           local pos = LocalPlayer.Character.HumanoidRootPart.Position
           local coordText = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
           
           Rayfield:Notify({
              Title = "Raw Coordinates Copied!",
              Content = coordText,
              Duration = 5,
              Image = 4483362458,
           })
           
           -- Try to copy to clipboard
           pcall(function()
               setclipboard(coordText)
           end)
       else
           Rayfield:Notify({
              Title = "Copy Failed",
              Content = "Character not found",
              Duration = 3,
              Image = 4483362458,
           })
       end
   end,
})

-- ================================
-- SETTINGS TAB
-- ================================
local SettingsTab = Window:CreateTab("⚙️ Settings", nil)

SettingsTab:CreateKeybind({
   Name = "Toggle UI",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "ToggleUI",
   Callback = function(Keybind)
       -- Keybind functionality is handled by Rayfield
   end,
})

SettingsTab:CreateButton({
   Name = "🗑️ Destroy GUI",
   Callback = function()
       Rayfield:Destroy()
   end,
})

-- ================================
-- CHARACTER RESPAWN HANDLING
-- ================================
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Restore walk speed
    if walkSpeedEnabled then
        humanoid.WalkSpeed = walkSpeed
    end
    
    -- Restore admin text
    if adminTextEnabled then
        task.wait(0.5)
        AddAdminText()
    end
end)

-- ================================
-- INITIALIZATION
-- ================================
Rayfield:Notify({
   Title = "GamiCiter Simple Loaded!",
   Content = "Simple version ready to use",
   Duration = 4,
   Image = 4483362458,
})

print("GamiCiter Simple v1.0 - Loaded Successfully!")
