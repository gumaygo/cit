local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "GamiCiter",
   Icon = 0,
   LoadingTitle = "hehe cit kita bang",
   LoadingSubtitle = "GamiCiter",
   ShowText = "GAMITEX",
   Theme = "Default",
   ToggleUIKeybind = "K",
})

local TeleportTab = Window:CreateTab("Teleport", nil)
local Section = TeleportTab:CreateSection("Teleport & Fly")

-- Tombol Teleport
TeleportTab:CreateButton({
   Name = "Base",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
         CFrame.new(16.4258919, 55.1701584, -1082.97791)
   end,
})

TeleportTab:CreateButton({
   Name = "Pos 1",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
         CFrame.new(5.49751902, 12.6079874, -403.985077)
   end,
})

TeleportTab:CreateButton({
   Name = "Pos 2",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
         CFrame.new(-184.413284, 128.098068, 409.574768)
   end,
})

-- ========================
-- FLY FEATURE
-- ========================
local flying = false
local flySpeed = 50

local function Fly()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVel.Velocity = Vector3.new(0,0,0)
    bodyVel.Parent = hrp

    while flying and task.wait() do
        local camCF = workspace.CurrentCamera.CFrame
        local moveDirection = Vector3.new(0,0,0)

        if game.UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camCF.LookVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camCF.LookVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camCF.RightVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camCF.RightVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0,1,0)
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0,1,0)
        end

        if moveDirection.Magnitude > 0 then
            bodyVel.Velocity = moveDirection.Unit * flySpeed
        else
            bodyVel.Velocity = Vector3.new(0,0,0)
        end
    end

    bodyVel:Destroy()
end

-- Toggle Fly
TeleportTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(state)
       flying = state
       if flying then
           task.spawn(Fly)
       end
   end,
})
