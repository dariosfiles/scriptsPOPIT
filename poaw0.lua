local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- The ID of the restricted game
local RESTRICTED_PLACE_ID = 109983668079237

-- Check the PlaceId immediately upon script execution
if game.PlaceId == RESTRICTED_PLACE_ID then
    LocalPlayer:Kick("🔴 DETECTED 🔴\nThis script is not allowed for this game.")
    task.wait(1)
    game:Shutdown()
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Osos Maduros HUB",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Osos Maduros HUB! 🚀",
   LoadingSubtitle = "Loading. Be patient",
   ShowText = "HUB", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "AmberGlow", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

local Main = Window:CreateTab("Main", "info")

local MainSection = Main:CreateSection("Main")

local Workspace = game:GetService("Workspace")

local Slider = Main:CreateSlider({
   Name = "Gravity",
   Range = {0, 500},
   Increment = 10,
   Suffix = "Studs/s²",
   CurrentValue = 196,
   Flag = "GravitySlider",
   Callback = function(Value)
      -- This updates the global gravity for the entire game
      Workspace.Gravity = Value
   end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local flying = false
local speed = 50 -- Adjust this to go faster/slower
local bodyVelocity = nil
local bodyGyro = nil

local function startFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    flying = true

    -- Loop to update movement
    spawn(function()
        while flying do
            RunService.RenderStepped:Wait()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and bodyVelocity and bodyGyro then
                local moveDir = Vector3.new(0, 0, 0)
                -- Simple keyboard movement logic
                local uis = game:GetService("UserInputService")
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                
                bodyVelocity.Velocity = moveDir * speed
                bodyGyro.CFrame = Camera.CFrame
            end
        end
    end)
end

local function stopFlying()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

-- Integration with your Toggle
local Toggle = Main:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly1",
    Callback = function(Value)
        if Value then
            startFlying()
        else
            stopFlying()
        end
    end,
})

local RunService = game:GetService("RunService")
local NetworkClient = settings():GetService("NetworkSettings")

local isLagging = false

local function setLagSwitch(enabled)
    isLagging = enabled
    
    if isLagging then
        -- This effectively pauses network replication
        settings():GetService("NetworkSettings").IncomingReplicationLag = 999999
    else
        -- Reset to normal latency
        settings():GetService("NetworkSettings").IncomingReplicationLag = 0
    end
end

-- Integration with your Toggle
local Toggle = Main:CreateToggle({
    Name = "PATCHED Lag Client",
    CurrentValue = false,
    Flag = "LagSwitch1",
    Callback = function(Value)
        setLagSwitch(Value)
    end,
})



local Lighting = game:GetService("Lighting")

Main:CreateToggle({
    Name = "Brightness",
    CurrentValue = false,
    Flag = "Fullbright1",
    Callback = function(Value)
        if Value then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
        else
            -- Reset to game default (standard values)
            Lighting.Ambient = Color3.fromRGB(70, 70, 70)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Lighting.Brightness = 1
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local highlights = {}
local playerAddedConn = nil -- Store the connection here
local playerRemovingConn = nil -- Store the connection here

-- Function to create/update highlight for a player
local function createHighlight(player)
    if player == LocalPlayer then return end
    
    local function applyHighlight(character)
        if character and not highlights[player.Name] then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
            highlights[player.Name] = highlight
        end
    end

    if player.Character then applyHighlight(player.Character) end
    player.CharacterAdded:Connect(applyHighlight)
end

-- Function to remove highlight
local function removeHighlight(player)
    if highlights[player.Name] then
        highlights[player.Name]:Destroy()
        highlights[player.Name] = nil
    end
end

-- Main logic
local function setESP(enabled)
    if enabled then
        -- Add to all existing players
        for _, player in pairs(Players:GetPlayers()) do
            createHighlight(player)
        end
        
        -- Connect and STORE the events
        playerAddedConn = Players.PlayerAdded:Connect(createHighlight)
        playerRemovingConn = Players.PlayerRemoving:Connect(removeHighlight)
    else
        -- Disconnect events so they stop triggering when ESP is off
        if playerAddedConn then playerAddedConn:Disconnect() end
        if playerRemovingConn then playerRemovingConn:Disconnect() end
        
        -- Clean up all existing highlights
        for _, highlight in pairs(highlights) do
            highlight:Destroy()
        end
        highlights = {}
    end
end

-- Integration
local Toggle = Main:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP1",
    Callback = function(Value)
        setESP(Value)
    end,
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local noclipEnabled = false

-- Function to handle collision
local function noclipLoop()
    if noclipEnabled then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end

-- Connect to the game engine
RunService.Stepped:Connect(noclipLoop)

-- Integration with your Toggle
local Toggle = Main:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip1",
    Callback = function(Value)
        noclipEnabled = Value
        
        -- If turning off, re-enable collisions so you don't fall through the floor
        if not Value then
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local Button = Main:CreateButton({
   Name = "Leave game",
   Callback = function()
   game:Shutdown()
   end,
})

local TOOLS = Window:CreateTab("Tools", "hammer")

local Toolsection = TOOLS:CreateSection("Tools")

local Button = TOOLS:CreateButton({
    Name = "Get speed coil",
    Callback = function()
        local Player = game.Players.LocalPlayer
        
        -- Check if player already has the tool
        if Player.Backpack:FindFirstChild("SPEED COIL") or Player.Character:FindFirstChild("SPEED COIL") then
            Rayfield:Notify({
                Title = "Error",
                Content = "You already have the speed coil",
                Duration = 3,
                Image = "x",
            })
            return -- Stop the function here
        end

        -- Logic to give the tool
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        local Tool = Instance.new("Tool")
        Tool.Name = "SPEED COIL"
        Tool.RequiresHandle = true

        local Handle = Instance.new("Part")
        Handle.Name = "Handle"
        Handle.Size = Vector3.new(1, 1.2000000476837158, 2)
        Handle.Parent = Tool

        local Mesh = Instance.new("SpecialMesh")
        Mesh.MeshId = "http://www.roblox.com/asset/?id=16606212"
        Mesh.TextureId = "http://www.roblox.com/asset/?id=16606141"
        Mesh.Parent = Handle

        Tool.Equipped:Connect(function()
            Humanoid.WalkSpeed = 60
        end)

        Tool.Unequipped:Connect(function()
            Humanoid.WalkSpeed = 16
        end)

        Tool.Parent = Player.Backpack
        
        Rayfield:Notify({
            Title = "Success",
            Content = "Speed Coil added to your inventory!",
            Duration = 3,
            Image = "check",
        })
    end,
})

local COMBAT = Window:CreateTab("Combat", "skull")

local Cmbtsection = COMBAT:CreateSection("Combat")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local godModeEnabled = false
local LocalPlayer = Players.LocalPlayer
local TARGET_HEALTH = 2343724723646723476237646724672364732

local function godModeLoop()
    if not godModeEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        -- 1. Force the massive health value
        if humanoid.MaxHealth ~= TARGET_HEALTH then
            humanoid.MaxHealth = TARGET_HEALTH
        end
        if humanoid.Health ~= TARGET_HEALTH then
            humanoid.Health = TARGET_HEALTH
        end
        
        -- 2. Prevent death-related destruction
        humanoid.BreakJointsOnDeath = false
        
        -- 3. Clear negative humanoid states (prevents being stunned/tripped)
        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            if state ~= Enum.HumanoidStateType.None then
                humanoid:SetStateEnabled(state, true)
            end
        end
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    -- 4. Prevent specific "kill parts" or void damage
    -- If the character falls into the void, reset position to keep them alive
    if character:FindFirstChild("HumanoidRootPart") then
        if character.HumanoidRootPart.Position.Y < -500 then
            character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
end

-- Use Heartbeat for the highest priority update loop
RunService.Heartbeat:Connect(godModeLoop)

COMBAT:CreateToggle({
    Name = "God Mode [NEW]",
    CurrentValue = false,
    Flag = "GodMode1",
    Callback = function(Value)
        godModeEnabled = Value
        if not Value then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.MaxHealth = 100
                character.Humanoid.Health = 100
                character.Humanoid.BreakJointsOnDeath = true
            end
        end
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = false
local isRightClickDown = false

-- Function to find the closest player torso
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = 200 -- The "FOV" radius in pixels

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Lock logic
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and isRightClickDown then
        local target = getClosestPlayer()
        if target and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Input listener for Right Click
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightClickDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightClickDown = false
    end
end)

-- Integration
local Toggle = COMBAT:CreateToggle({
    Name = "Aimbot (Right Click)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        aimbotEnabled = Value
    end,
})

local HUB = Window:CreateTab("Scripts", "scroll")

local Hubsection = HUB:CreateSection("External scripts")

local Paragraph = HUB:CreateParagraph({Title = "Warning (READ)", Content = "If the scripts don't have a ✅ next to them, it means that they aren't made by me and they might be not safe. I do not take responsibility for damages"})

local Button = HUB:CreateButton({
   Name = "✅ UNLOCK ALL FATPAPS OBBYS",
   Callback = function()
   for _,v in pairs(game:GetDescendants()) do
if v.ClassName == "RemoteEvent" then
if v.Parent.Name == "WeaponsRemotes" or v.Parent.Name == "VipRemotes" or v.Parent.Name == "Remotes" then
v:FireServer()
end
end
end
   end,
})

local Bckdoor = Window:CreateTab("Backdoor", "door-closed")

local Bcksection = Bckdoor:CreateSection("ServerSide Executor")

local Paragraph = Bckdoor:CreateParagraph({Title = "🔒 Locked", Content = "This is still being worked on"})
