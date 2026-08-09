-- Gomes Hub PC - Versão Final Completa
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Proteção e carregamento da Interface
local ParentGui
pcall(function()
    if gethui then
        ParentGui = gethui()
    else
        ParentGui = game:GetService("CoreGui")
    end
end)
if not ParentGui then
    ParentGui = LocalPlayer:WaitForChild("PlayerGui")
end

-- Limpa versões anteriores
if ParentGui:FindFirstChild("GomesHubPC") then
    ParentGui.GomesHubPC:Destroy()
end

local GomesHubPC = Instance.new("ScreenGui")
GomesHubPC.Name = "GomesHubPC"
GomesHubPC.ResetOnSpawn = false
GomesHubPC.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then syn.protect_gui(GomesHubPC) end
GomesHubPC.Parent = ParentGui

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Parent = GomesHubPC

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(35, 35, 35)
FrameStroke.Thickness = 1
FrameStroke.Parent = MainFrame

-- Barra Superior (Drag)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Gomes hub pc"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Lista de Funções
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -16, 1, -48)
Container.Position = UDim2.new(0, 8, 0, 42)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Sistema de Arrastar
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

-- Estados e Funções Auxiliares
local SpeedActive, InfiniteJumpActive, NoclipActive, ESPActive = false, false, false, false
local Toggles = {}

local function CreateToggle(name, callback)
    local state = false
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    ToggleFrame.Parent = Container
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -55, 1, 0); Label.Text = name; Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(230, 230, 230); Label.Font = Enum.Font.GothamMedium
    
    local SwitchTrack = Instance.new("TextButton", ToggleFrame)
    SwitchTrack.Size = UDim2.new(0, 38, 0, 20); SwitchTrack.Position = UDim2.new(1, -46, 0.5, -10)
    SwitchTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 35); SwitchTrack.AutoButtonColor = false; SwitchTrack.Text = ""
    Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)
    
    local SwitchKnob = Instance.new("Frame", SwitchTrack)
    SwitchKnob.Size = UDim2.new(0, 14, 0, 14); SwitchKnob.Position = UDim2.new(0, 3, 0.5, -7)
    Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

    local function ToggleState()
        state = not state
        SwitchTrack.BackgroundColor3 = state and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(35, 35, 35)
        TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        task.spawn(callback, state)
    end
    SwitchTrack.MouseButton1Click:Connect(ToggleState)
    return ToggleState
end

local function CreateButton(name, callback)
    local ButtonFrame = Instance.new("Frame", Container); ButtonFrame.Size = UDim2.new(1, 0, 0, 38); ButtonFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)
    local ActionBtn = Instance.new("TextButton", ButtonFrame); ActionBtn.Size = UDim2.new(1, 0, 1, 0); ActionBtn.BackgroundTransparency = 1; ActionBtn.Text = name; ActionBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    ActionBtn.MouseButton1Click:Connect(callback)
end

-- Lógica ESP
local ESPFolder = Instance.new("Folder", ParentGui)
local function UpdateESP()
    ESPFolder:ClearAllChildren()
    if not ESPActive then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h = Instance.new("Highlight", ESPFolder)
            h.Adornee = plr.Character; h.FillColor = Color3.new(1,0,0); h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end
end

-- Lógica TP
local function TeleportToClosest()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then closest = p; dist = d end
        end
    end
    if closest then LocalPlayer.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
end

-- Registros
Toggles.Speed = CreateToggle("Super Velocidade [X]", function(s) SpeedActive = s end)
Toggles.Jump = CreateToggle("Pulo Infinito [Z]", function(s) InfiniteJumpActive = s end)
Toggles.Noclip = CreateToggle("Modo ADM [C]", function(s) NoclipActive = s end)
Toggles.ESP = CreateToggle("Olho Supremo [V]", function(s) ESPActive = s; UpdateESP() end)
CreateButton("TP Supremo [T]", TeleportToClosest)

-- Loop principal
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if SpeedActive and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.WalkSpeed = 23 end
        if NoclipActive then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    end
end)

UserInputService.JumpRequest:Connect(function() if InfiniteJumpActive then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.X then Toggles.Speed()
    elseif input.KeyCode == Enum.KeyCode.Z then Toggles.Jump()
    elseif input.KeyCode == Enum.KeyCode.C then Toggles.Noclip()
    elseif input.KeyCode == Enum.KeyCode.V then Toggles.ESP()
    elseif input.KeyCode == Enum.KeyCode.T then TeleportToClosest() end
end)
