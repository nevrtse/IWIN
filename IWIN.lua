local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPEnabled = false
local UIVisible = true
local TargetUsername = ""
local TargetPlayer = nil
local ESPColor = Color3.fromRGB(255, 0, 0) 
local ESPThickness = 2
local TextSize = 14
local CustomKeybind = Enum.KeyCode.F2 

local ShowBox = true
local ShowLine = true
local ShowDistance = true

local ESPObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 300, 0, 350) 
Frame.Position = UDim2.new(0.5, -150, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Text = "IWINIWINIWINIWIN"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Name = "TargetLabel"
TargetLabel.Size = UDim2.new(1, 0, 0, 20)
TargetLabel.Position = UDim2.new(0, 0, 0, 40)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Pseudo ou DisplayName (partiel):"
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.TextSize = 14
TargetLabel.Font = Enum.Font.SourceSans
TargetLabel.Parent = Frame

local TargetInput = Instance.new("TextBox")
TargetInput.Name = "TargetInput"
TargetInput.Size = UDim2.new(0.8, 0, 0, 25)
TargetInput.Position = UDim2.new(0.1, 0, 0, 65)
TargetInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TargetInput.BorderColor3 = Color3.fromRGB(100, 100, 100)
TargetInput.Text = ""
TargetInput.PlaceholderText = "Entrez le pseudo ici"
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.TextSize = 14
TargetInput.Font = Enum.Font.SourceSans
TargetInput.ClearTextOnFocus = false
TargetInput.Parent = Frame

local AvatarFrame = Instance.new("Frame")
AvatarFrame.Name = "AvatarFrame"
AvatarFrame.Size = UDim2.new(0, 60, 0, 60)
AvatarFrame.Position = UDim2.new(0.5, -30, 0, 95)
AvatarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AvatarFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
AvatarFrame.BorderSizePixel = 1
AvatarFrame.Visible = false
AvatarFrame.Parent = Frame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = ""
AvatarImage.Parent = AvatarFrame

local TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.Name = "TargetNameLabel"
TargetNameLabel.Size = UDim2.new(1, 0, 0, 20)
TargetNameLabel.Position = UDim2.new(0, 0, 0, 165)
TargetNameLabel.BackgroundTransparency = 1
TargetNameLabel.Text = "Cible: Aucune"
TargetNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetNameLabel.TextSize = 14
TargetNameLabel.Font = Enum.Font.SourceSans
TargetNameLabel.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 190)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Statut ESP: Désactivé"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Parent = Frame

local OptionsLabel = Instance.new("TextLabel")
OptionsLabel.Name = "OptionsLabel"
OptionsLabel.Size = UDim2.new(1, 0, 0, 20)
OptionsLabel.Position = UDim2.new(0, 0, 0, 215)
OptionsLabel.BackgroundTransparency = 1
OptionsLabel.Text = "Options ESP:"
OptionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OptionsLabel.TextSize = 14
OptionsLabel.Font = Enum.Font.SourceSansBold
OptionsLabel.Parent = Frame

local function CreateCheckbox(parent, text, posX, posY, initialValue, callback)
    local container = Instance.new("Frame")
    container.Name = text .. "Container"
    container.Size = UDim2.new(0, 80, 0, 25)
    container.Position = UDim2.new(posX, 0, 0, posY)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local checkbox = Instance.new("Frame")
    checkbox.Name = "Checkbox"
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.Position = UDim2.new(0, 0, 0.5, -10)
    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkbox.BorderColor3 = Color3.fromRGB(100, 100, 100)
    checkbox.Parent = container
    
    local checkmark = Instance.new("TextLabel")
    checkmark.Name = "Checkmark"
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.BackgroundTransparency = 1
    checkmark.Text = initialValue and "✓" or ""
    checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
    checkmark.TextSize = 18
    checkmark.Font = Enum.Font.SourceSansBold
    checkmark.Parent = checkbox
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 75, 1, 0)
    label.Position = UDim2.new(0, 25, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = container
    
    local checked = initialValue
    
    button.MouseButton1Click:Connect(function()
        checked = not checked
        checkmark.Text = checked and "✓" or ""
        if callback then callback(checked) end
    end)
    
    return container, function(value)
        checked = value
        checkmark.Text = checked and "✓" or ""
    end
end

local boxContainer, setBoxChecked = CreateCheckbox(Frame, "Box ESP", 0.05, 240, ShowBox, function(value)
    ShowBox = value
end)

local lineContainer, setLineChecked = CreateCheckbox(Frame, "Line ESP", 0.38, 240, ShowLine, function(value)
    ShowLine = value
end)

local distanceContainer, setDistanceChecked = CreateCheckbox(Frame, "Distance", 0.7, 240, ShowDistance, function(value)
    ShowDistance = value
end)

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.Size = UDim2.new(0.3, 0, 0, 25)
KeybindLabel.Position = UDim2.new(0.1, 0, 0, 275)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Keybind ESP:"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.TextSize = 14
KeybindLabel.Font = Enum.Font.SourceSans
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = Frame

local KeybindInput = Instance.new("TextBox")
KeybindInput.Name = "KeybindInput"
KeybindInput.Size = UDim2.new(0.3, 0, 0, 25)
KeybindInput.Position = UDim2.new(0.5, 0, 0, 275)
KeybindInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeybindInput.BorderColor3 = Color3.fromRGB(100, 100, 100)
KeybindInput.Text = "F2"
KeybindInput.PlaceholderText = "Touche"
KeybindInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindInput.TextSize = 14
KeybindInput.Font = Enum.Font.SourceSans
KeybindInput.ClearTextOnFocus = true
KeybindInput.Parent = Frame

local UINote = Instance.new("TextLabel")
UINote.Name = "UINote"
UINote.Size = UDim2.new(1, 0, 0, 20)
UINote.Position = UDim2.new(0, 0, 0, 310)
UINote.BackgroundTransparency = 1
UINote.Text = "CTRL = Afficher/Masquer l'UI"
UINote.TextColor3 = Color3.fromRGB(200, 200, 200)
UINote.TextSize = 12
UINote.Font = Enum.Font.SourceSans
UINote.Parent = Frame

local function PlayerMatches(player, searchText)
    if searchText == "" then return true end
    searchText = searchText:lower()
    
    if player.Name:lower():find(searchText, 1, true) then
        return true
    end
    
    if player.DisplayName and player.DisplayName:lower():find(searchText, 1, true) then
        return true
    end
    
    return false
end

local function FindTargetPlayer(searchText)
    if searchText == "" then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and PlayerMatches(player, searchText) then
            return player
        end
    end
    
    return nil
end

local function UpdateAvatar(player)
    if player then
        local userId = player.UserId
        local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=60&height=60&format=png"
        AvatarImage.Image = avatarUrl
        AvatarFrame.Visible = true
        TargetNameLabel.Text = "Cible: " .. player.Name
        if player.Name ~= player.DisplayName then
            TargetNameLabel.Text = TargetNameLabel.Text .. " (" .. player.DisplayName .. ")"
        end
    else
        AvatarFrame.Visible = false
        TargetNameLabel.Text = "Cible: Aucune"
    end
end

local function CreateESP(player)
    local espObject = {
        Player = player,
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Line = Drawing.new("Line"),
        Distance = Drawing.new("Text"),
        Character = player.Character
    }
    
    espObject.Box.Visible = false
    espObject.Box.Color = ESPColor
    espObject.Box.Thickness = ESPThickness
    espObject.Box.Transparency = 1
    espObject.Box.Filled = false
    
    espObject.Name.Visible = false
    espObject.Name.Color = ESPColor
    espObject.Name.Size = TextSize
    espObject.Name.Center = true
    espObject.Name.Outline = true
    
    espObject.Line.Visible = false
    espObject.Line.Color = ESPColor
    espObject.Line.Thickness = ESPThickness
    espObject.Line.Transparency = 1
    
    espObject.Distance.Visible = false
    espObject.Distance.Color = ESPColor
    espObject.Distance.Size = TextSize
    espObject.Distance.Center = true
    espObject.Distance.Outline = true
    
    player.CharacterAdded:Connect(function(character)
        espObject.Character = character
    end)
    
    table.insert(ESPObjects, espObject)
    return espObject
end

local function CleanupESP()
    for _, espObject in ipairs(ESPObjects) do
        if espObject.Box then espObject.Box:Remove() end
        if espObject.Name then espObject.Name:Remove() end
        if espObject.Line then espObject.Line:Remove() end
        if espObject.Distance then espObject.Distance:Remove() end
    end
    ESPObjects = {}
end

local function CleanupPlayerESP(player)
    for i, espObject in ipairs(ESPObjects) do
        if espObject.Player == player then
            if espObject.Box then espObject.Box:Remove() end
            if espObject.Name then espObject.Name:Remove() end
            if espObject.Line then espObject.Line:Remove() end
            if espObject.Distance then espObject.Distance:Remove() end
            table.remove(ESPObjects, i)
            break
        end
    end
end

local function UpdateESP()
    for _, espObject in ipairs(ESPObjects) do
        local player = espObject.Player
        local Box = espObject.Box
        local Name = espObject.Name
        local Line = espObject.Line
        local Distance = espObject.Distance
        
        if not ESPEnabled then
            Box.Visible = false
            Name.Visible = false
            Line.Visible = false
            Distance.Visible = false
            continue
        end
        
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Box.Visible = false
            Name.Visible = false
            Line.Visible = false
            Distance.Visible = false
            continue
        end
        
        if player.Character ~= espObject.Character then
            espObject.Character = player.Character
        end
        
        local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local Head = player.Character:FindFirstChild("Head")
        local Humanoid = player.Character:FindFirstChild("Humanoid")
        
        if not HumanoidRootPart or not Head or not Humanoid then
            Box.Visible = false
            Name.Visible = false
            Line.Visible = false
            Distance.Visible = false
            continue
        end
        
        if Humanoid.Health <= 0 then
            Box.Visible = false
            Name.Visible = false
            Line.Visible = false
            Distance.Visible = false
            continue
        end
        
        if TargetPlayer and player ~= TargetPlayer then
            Box.Visible = false
            Name.Visible = false
            Line.Visible = false
            Distance.Visible = false
            continue
        end
        
        local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
        
        if not OnScreen then
            Box.Visible = false
            Name.Visible = false
            Line.Visible = false
            Distance.Visible = false
            continue
        end
        
        local Size = (Camera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - 
                    Camera:WorldToViewportPoint(HumanoidRootPart.Position + Vector3.new(0, 2.5, 0)).Y) / 2
        
        Box.Size = Vector2.new(Size * 1.5, Size * 3)
        Box.Position = Vector2.new(Vector.X - Box.Size.X / 2, Vector.Y - Box.Size.Y / 2)
        Box.Visible = ShowBox
        
        Name.Text = player.Name
        if player.DisplayName ~= player.Name then
            Name.Text = player.DisplayName .. " (" .. player.Name .. ")"
        end
        Name.Position = Vector2.new(Vector.X, Vector.Y - Box.Size.Y / 2 - 15)
        Name.Visible = true
        
        local LocalCharacter = LocalPlayer.Character
        if LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart") then
            local LocalPosition = Camera:WorldToViewportPoint(LocalCharacter.HumanoidRootPart.Position)
            Line.From = Vector2.new(LocalPosition.X, LocalPosition.Y)
            Line.To = Vector2.new(Vector.X, Vector.Y)
            Line.Visible = ShowLine
        else
            Line.Visible = false
        end
        
        local distance = math.floor((Camera.CFrame.Position - HumanoidRootPart.Position).Magnitude)
        Distance.Text = tostring(distance) .. "m"
        Distance.Position = Vector2.new(Vector.X, Vector.Y + Box.Size.Y / 2 + 5)
        Distance.Visible = ShowDistance
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

RunService.RenderStepped:Connect(function()
    UpdateESP()
end)

local keyMap = {
    ["F1"] = Enum.KeyCode.F1,
    ["F2"] = Enum.KeyCode.F2,
    ["F3"] = Enum.KeyCode.F3,
    ["F4"] = Enum.KeyCode.F4,
    ["F5"] = Enum.KeyCode.F5,
    ["F6"] = Enum.KeyCode.F6,
    ["F7"] = Enum.KeyCode.F7,
    ["F8"] = Enum.KeyCode.F8,
    ["F9"] = Enum.KeyCode.F9,
    ["F10"] = Enum.KeyCode.F10,
    ["F11"] = Enum.KeyCode.F11,
    ["F12"] = Enum.KeyCode.F12,
    ["Z"] = Enum.KeyCode.Z,
    ["Q"] = Enum.KeyCode.Q,
    ["S"] = Enum.KeyCode.S,
    ["D"] = Enum.KeyCode.D,
    ["E"] = Enum.KeyCode.E,
    ["R"] = Enum.KeyCode.R,
    ["T"] = Enum.KeyCode.T,
    ["Y"] = Enum.KeyCode.Y,
    ["U"] = Enum.KeyCode.U,
    ["I"] = Enum.KeyCode.I,
    ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P,
    ["A"] = Enum.KeyCode.A,
    ["F"] = Enum.KeyCode.F,
    ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H,
    ["J"] = Enum.KeyCode.J,
    ["K"] = Enum.KeyCode.K,
    ["L"] = Enum.KeyCode.L,
    ["M"] = Enum.KeyCode.M,
    ["W"] = Enum.KeyCode.W,
    ["X"] = Enum.KeyCode.X,
    ["C"] = Enum.KeyCode.C,
    ["V"] = Enum.KeyCode.V,
    ["B"] = Enum.KeyCode.B,
    ["N"] = Enum.KeyCode.N,
    ["0"] = Enum.KeyCode.Zero,
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,
    ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven,
    ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,
    ["LALT"] = Enum.KeyCode.LeftAlt,
    ["RALT"] = Enum.KeyCode.RightAlt,
    ["LCTRL"] = Enum.KeyCode.LeftControl,
    ["RCTRL"] = Enum.KeyCode.RightControl,
    ["INSERT"] = Enum.KeyCode.Insert,
    ["DELETE"] = Enum.KeyCode.Delete,
    ["SUPPR"] = Enum.KeyCode.Delete, 
    ["INS"] = Enum.KeyCode.Insert, 
    ["DEL"] = Enum.KeyCode.Delete, 
    ["ALT"] = Enum.KeyCode.LeftAlt, 
    ["CTRL"] = Enum.KeyCode.LeftControl, 
}

KeybindInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local keyText = KeybindInput.Text:upper()
        if keyMap[keyText] then
            CustomKeybind = keyMap[keyText]
            KeybindInput.Text = keyText
        else
            KeybindInput.Text = "F2" 
            CustomKeybind = Enum.KeyCode.F2
        end
    end
end)

TargetInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        TargetUsername = TargetInput.Text
        TargetPlayer = FindTargetPlayer(TargetUsername)
        
        if TargetUsername == "" then
            StatusLabel.Text = "Statut ESP: Tous les joueurs"
            TargetPlayer = nil
            UpdateAvatar(nil)
        else
            if TargetPlayer then
                StatusLabel.Text = "Statut ESP: Cible trouvée"
                UpdateAvatar(TargetPlayer)
            else
                StatusLabel.Text = "Statut ESP: Cible non trouvée"
                UpdateAvatar(nil)
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CustomKeybind then
        ESPEnabled = not ESPEnabled
        
        if not ESPEnabled then
            for _, espObject in ipairs(ESPObjects) do
                if espObject.Box then espObject.Box.Visible = false end
                if espObject.Name then espObject.Name.Visible = false end
                if espObject.Line then espObject.Line.Visible = false end
                if espObject.Distance then espObject.Distance.Visible = false end
            end
        end
        
        StatusLabel.Text = "Statut ESP: " .. (ESPEnabled and "Activé" or "Désactivé")
        StatusLabel.TextColor3 = ESPEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    elseif input.KeyCode == Enum.KeyCode.RCTRL then
        UIVisible = not UIVisible
        Frame.Visible = UIVisible
    end
end)

Players.PlayerRemoving:Connect(function(player)
    CleanupPlayerESP(player)
    
    if player == TargetPlayer then
        TargetPlayer = nil
        UpdateAvatar(nil)
        StatusLabel.Text = "Statut ESP: Cible partie"
    end
end)

local function ObserveHumanoid(player, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            for _, espObject in ipairs(ESPObjects) do
                if espObject.Player == player then
                    espObject.Box.Visible = false
                    espObject.Name.Visible = false
                    espObject.Line.Visible = false
                    espObject.Distance.Visible = false
                    break
                end
            end
        end)
    end
end

-- Observer les joueurs actuels
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        ObserveHumanoid(player, player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        ObserveHumanoid(player, character)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        ObserveHumanoid(player, character)
    end)
end)

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child == ScreenGui then
        CleanupESP()
    end
end)

print("Script ESP chargé")
print("CTRL = Afficher/Masquer l'interface")
print("F2 (par défaut) = Activer/Désactiver ESP")