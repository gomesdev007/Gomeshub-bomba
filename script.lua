-- [[ GOMEZ AUTO PASS v6.2 - WELCOME SCREEN (7 SECONDS) ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza de UIs anteriores
if LocalPlayer.PlayerGui:FindFirstChild("GomesAutoPassGui") then LocalPlayer.PlayerGui.GomesAutoPassGui:Destroy() end
if LocalPlayer.PlayerGui:FindFirstChild("GomesWelcomeGui") then LocalPlayer.PlayerGui.GomesWelcomeGui:Destroy() end

-- Estados e Remotes
local autoPassActive = false
local autoX1Active = false
local speedBoostActive = false
local autoJumpActive = false
local dragLocked = false

local PassRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("PassRequestEvent")
local AttackRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("EndgameAttackEvent")

-- =======================================================================
-- [[ FUNÇÃO QUE INICIALIZA O SCRIPT PRINCIPAL ]]
-- =======================================================================
local function initMainGui()
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    ScreenGui.Name = "GomesAutoPassGui"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "GomesAutoPass"
    MainFrame.Size = UDim2.new(0, 145, 0, 260)
    MainFrame.Position = UDim2.new(0.5, -72, 0.5, -130)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(45, 45, 60)
    Stroke.Thickness = 1.5

    -- Título
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 32)
    Title.BackgroundTransparency = 1
    Title.Text = "Gomes Auto Pass"
    Title.TextColor3 = Color3.fromRGB(240, 240, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12

    -- Construtor de Botões
    local function createButton(text, pos, callback)
        local btn = Instance.new("TextButton", MainFrame)
        btn.Size = UDim2.new(0, 115, 0, 32)
        btn.Position = pos
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        btn.TextColor3 = Color3.fromRGB(220, 220, 235)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", btn)
        s.Color = Color3.fromRGB(45, 45, 60)
        s.Thickness = 1
        btn.MouseButton1Click:Connect(function() callback(btn, s) end)
        return btn
    end

    -- Botões
    createButton("PASS: OFF", UDim2.new(0, 15, 0, 42), function(btn, s) autoPassActive = not autoPassActive; btn.Text = autoPassActive and "PASS: ON" or "PASS: OFF"; btn.BackgroundColor3 = autoPassActive and Color3.fromRGB(35, 130, 45) or Color3.fromRGB(28, 28, 38); s.Color = autoPassActive and Color3.fromRGB(60, 180, 75) or Color3.fromRGB(45, 45, 60) end)
    createButton("AUTO X1: OFF", UDim2.new(0, 15, 0, 80), function(btn, s) autoX1Active = not autoX1Active; btn.Text = autoX1Active and "AUTO X1: ON" or "AUTO X1: OFF"; btn.BackgroundColor3 = autoX1Active and Color3.fromRGB(35, 130, 45) or Color3.fromRGB(28, 28, 38); s.Color = autoX1Active and Color3.fromRGB(60, 180, 75) or Color3.fromRGB(45, 45, 60) end)
    createButton("SPEED: OFF", UDim2.new(0, 15, 0, 118), function(btn, s) speedBoostActive = not speedBoostActive; btn.Text = speedBoostActive and "SPEED: ON" or "SPEED: OFF"; btn.BackgroundColor3 = speedBoostActive and Color3.fromRGB(35, 130, 45) or Color3.fromRGB(28, 28, 38); s.Color = speedBoostActive and Color3.fromRGB(60, 180, 75) or Color3.fromRGB(45, 45, 60) end)
    createButton("JUMP: OFF", UDim2.new(0, 15, 0, 156), function(btn, s) autoJumpActive = not autoJumpActive; btn.Text = autoJumpActive and "JUMP: ON" or "JUMP: OFF"; btn.BackgroundColor3 = autoJumpActive and Color3.fromRGB(35, 130, 45) or Color3.fromRGB(28, 28, 38); s.Color = autoJumpActive and Color3.fromRGB(60, 180, 75) or Color3.fromRGB(45, 45, 60) end)
    createButton("LOCK: OFF", UDim2.new(0, 15, 0, 194), function(btn, s) dragLocked = not dragLocked; btn.Text = dragLocked and "LOCK: ON" or "LOCK: OFF"; btn.BackgroundColor3 = dragLocked and Color3.fromRGB(140, 35, 35) or Color3.fromRGB(28, 28, 38); s.Color = dragLocked and Color3.fromRGB(190, 50, 50) or Color3.fromRGB(45, 45, 60) end)

    -- Arrasto
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragLocked then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and not dragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    -- Lógica de Funcionamento
    RunService.RenderStepped:Connect(function() local char = LocalPlayer.Character; if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum and speedBoostActive then hum.WalkSpeed = 25 end end end)
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end
        if autoJumpActive and hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
        if autoPassActive then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local tr = p.Character.HumanoidRootPart; if (root.Position - tr.Position).Magnitude <= 4.8 then PassRemote:FireServer(p, tr.Position, root.Position); task.wait(0.1); break end end end end
        if autoX1Active then local ct = nil; local sd = 12; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local tr = p.Character:FindFirstChild("HumanoidRootPart"); local th = p.Character:FindFirstChildOfClass("Humanoid"); if tr and th and th.Health > 0 then local dist = (root.Position - tr.Position).Magnitude; if dist < sd then sd = dist; ct = tr end end end end if ct then AttackRemote:FireServer(root.Position, (ct.Position - root.Position).Unit, ct.Position); task.wait(0.50) end end
    end)
end

-- =======================================================================
-- [[ TELA DE BOAS-VINDAS ]]
-- =======================================================================
local WelcomeGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
WelcomeGui.Name = "GomesWelcomeGui"
local WelcomeFrame = Instance.new("Frame", WelcomeGui)
WelcomeFrame.Size = UDim2.new(0, 280, 0, 70); WelcomeFrame.Position = UDim2.new(0.5, -140, 0.2, 0); WelcomeFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24); WelcomeFrame.BorderSizePixel = 0; WelcomeFrame.BackgroundTransparency = 1
Instance.new("UICorner", WelcomeFrame).CornerRadius = UDim.new(0, 14)
local WelcomeStroke = Instance.new("UIStroke", WelcomeFrame); WelcomeStroke.Color = Color3.fromRGB(55, 55, 75); WelcomeStroke.Transparency = 1
local AvatarImg = Instance.new("ImageLabel", WelcomeFrame); AvatarImg.Size = UDim2.new(0, 48, 0, 48); AvatarImg.Position = UDim2.new(0, 11, 0.5, -24); AvatarImg.BackgroundTransparency = 1; AvatarImg.ImageTransparency = 1; Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
task.spawn(function() AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
local WelcomeText = Instance.new("TextLabel", WelcomeFrame); WelcomeText.Size = UDim2.new(0, 200, 0, 20); WelcomeText.Position = UDim2.new(0, 68, 0, 15); WelcomeText.BackgroundTransparency = 1; WelcomeText.Text = "Seja Bem-Vindo,"; WelcomeText.TextColor3 = Color3.fromRGB(160, 160, 180); WelcomeText.Font = Enum.Font.Gotham; WelcomeText.TextSize = 11; WelcomeText.TextXAlignment = Enum.TextXAlignment.Left; WelcomeText.TextTransparency = 1
local NameText = Instance.new("TextLabel", WelcomeFrame); NameText.Size = UDim2.new(0, 200, 0, 22); NameText.Position = UDim2.new(0, 68, 0, 32); NameText.BackgroundTransparency = 1; NameText.Text = LocalPlayer.DisplayName; NameText.TextColor3 = Color3.fromRGB(255, 255, 255); NameText.Font = Enum.Font.GothamBold; NameText.TextSize = 14; NameText.TextXAlignment = Enum.TextXAlignment.Left; NameText.TextTransparency = 1

local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(WelcomeFrame, tweenInfo, {BackgroundTransparency = 0.1}):Play(); TweenService:Create(WelcomeStroke, tweenInfo, {Transparency = 0}):Play(); TweenService:Create(AvatarImg, tweenInfo, {ImageTransparency = 0}):Play(); TweenService:Create(WelcomeText, tweenInfo, {TextTransparency = 0}):Play(); TweenService:Create(NameText, tweenInfo, {TextTransparency = 0}):Play()

task.wait(7) -- Tempo ajustado para 7 segundos de exibição

local fadeOutInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
TweenService:Create(WelcomeFrame, fadeOutInfo, {BackgroundTransparency = 1}):Play(); TweenService:Create(WelcomeStroke, fadeOutInfo, {Transparency = 1}):Play(); TweenService:Create(AvatarImg, fadeOutInfo, {ImageTransparency = 1}):Play(); TweenService:Create(WelcomeText, fadeOutInfo, {TextTransparency = 1}):Play()
local nameFade = TweenService:Create(NameText, fadeOutInfo, {TextTransparency = 1})
nameFade:Play()
nameFade.Completed:Connect(function()
    WelcomeGui:Destroy()
    initMainGui() -- O script principal inicia após 7s + tempo de fade
end)
