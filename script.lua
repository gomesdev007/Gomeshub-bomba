-- Gomes Hub PC - Versão Ultra Clean & Fixed
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Proteção da GUI
local ParentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
if ParentGui:FindFirstChild("GomesHubPC") then ParentGui.GomesHubPC:Destroy() end

local ScreenGui = Instance.new("ScreenGui", ParentGui)
ScreenGui.Name = "GomesHubPC"
ScreenGui.ResetOnSpawn = false

-- Janela Principal (Compacta)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 240)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 40)

-- Barra Superior (Drag corrigido)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -10, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "GOMES HUB PC"; Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -10, 1, -45); Container.Position = UDim2.new(0, 5, 0, 40)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- Sistema de Drag (Corrigido e Seguro)
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Funções Visuais (Hover Effect)
local function CreateButton(name, isToggle, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -5, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Font = Enum.Font.Gotham
    btn.TextSize = 12; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play() end)
    
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(25, 25, 25)
        end
        callback(state)
    end)
    return function() if isToggle then btn.MouseButton1Click:Fire() end end
end

-- Lógica das funções
local Speed, Jump, Noclip, ESP = false, false, false, false

local triggers = {
    X = CreateButton("Super Velocidade [X]", true, function(s) Speed = s end),
    Z = CreateButton("Pulo Infinito [Z]", true, function(s) Jump = s end),
    C = CreateButton("Modo ADM [C]", true, function(s) Noclip = s end),
    V = CreateButton("Olho Supremo [V]", true, function(s) ESP = s end),
    T = CreateButton("TP Supremo [T]", false, function()
        local c, d = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < d then c = p; d = dist end
            end
        end
        if c then LocalPlayer.Character.HumanoidRootPart.CFrame = c.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
    end)
}

-- Loops de Ação
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if Speed then char.Humanoid.WalkSpeed = 23 end
        if Noclip then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    end
end)

UserInputService.JumpRequest:Connect(function() if Jump then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and triggers[inp.KeyCode.Name] then triggers[inp.KeyCode.Name]() end
end)
