-- Gomes Hub PC - Versão Ultimate (B to Toggle)
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

-- Frame Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 310)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 40)

-- Barra Superior
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "GOMES HUB | B to Toggle"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 10; Title.BackgroundTransparency = 1

-- Container
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -10, 1, -40); Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 4)

-- Sistema Drag
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- Estados e Funções
local States = {Speed = false, Jump = false, Noclip = false, ESP = false, Fly = false}
local actions = {}

local function CreateButton(text, key, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -4, 0, 28); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Font = Enum.Font.Gotham; btn.TextSize = 11; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local active = false
    local function Toggle()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(25, 25, 25)
        callback(active)
    end
    btn.MouseButton1Click:Connect(Toggle)
    actions[key] = Toggle
end

-- Lógicas
local bv, bg
local function ToggleFly(on)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if on then
        bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
        bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart); bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    else
        if bv then bv:Destroy() end; if bg then bg:Destroy() end
    end
end

-- Criação dos Botões
CreateButton("Velocidade [X]", "X", function(s) States.Speed = s end)
CreateButton("Pulo Infinito [Z]", "Z", function(s) States.Jump = s end)
CreateButton("Modo ADM [C]", "C", function(s) 
    States.Noclip = s 
    if not s and LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end)
CreateButton("Olho Supremo [V]", "V", function(s) 
    States.ESP = s
    if not s then for _, h in pairs(ParentGui:GetDescendants()) do if h:IsA("Highlight") then h:Destroy() end end end
end)
CreateButton("Modo Voo [F]", "F", function(s) States.Fly = s; ToggleFly(s) end)
CreateButton("TP Supremo [T]", "T", function()
    local c, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then c = p; dist = d end
        end
    end
    if c then LocalPlayer.Character.HumanoidRootPart.CFrame = c.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
end)

-- Main Loops
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    if States.Speed and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 23 end
    if States.Noclip then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    if States.Fly and bv then
        local move = Vector3.new(0,0,0); local cam = workspace.CurrentCamera.CFrame.LookVector
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        bv.Velocity = move * 50
    end
    if States.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", p.Character); h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function() if States.Jump then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- Keybinds (B para ocultar)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.B then MainFrame.Visible = not MainFrame.Visible end
    if actions[inp.KeyCode.Name] then actions[inp.KeyCode.Name]() end
end)
