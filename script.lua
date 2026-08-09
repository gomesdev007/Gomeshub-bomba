-- Gomes Hub PC - Versão Completa (Final)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local ParentGui = (gethui and gethui()) or (game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

if ParentGui:FindFirstChild("GomesHubPC") then ParentGui.GomesHubPC:Destroy() end

-- GUI Principal
local GomesHubPC = Instance.new("ScreenGui", ParentGui)
GomesHubPC.Name = "GomesHubPC"

local MainFrame = Instance.new("Frame", GomesHubPC)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(30, 30, 30)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36); TopBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -15, 1, 0); Title.Position = UDim2.new(0, 12, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "Gomes hub pc "; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 14; Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -16, 1, -44); Container.Position = UDim2.new(0, 8, 0, 40)
Container.BackgroundTransparency = 1; Container.BorderSizePixel = 0; Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)

-- Arrastar
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Estados e Keybinds
local States = {Speed = false, Jump = false, Noclip = false, ESP = false, Fly = false, AutoClick = false, AntiAFK = false}
local Keybinds = {}

local function AddToggle(name, key, callback)
    local state = false
    local ToggleFrame = Instance.new("Frame", Container); ToggleFrame.Size = UDim2.new(1, 0, 0, 36); ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", ToggleFrame).Color = Color3.fromRGB(30, 30, 30)
    local Label = Instance.new("TextLabel", ToggleFrame); Label.Size = UDim2.new(1, -50, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.BackgroundTransparency = 1; Label.Text = name; Label.TextColor3 = Color3.fromRGB(220, 220, 220); Label.TextSize = 13; Label.Font = Enum.Font.GothamMedium; Label.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchTrack = Instance.new("TextButton", ToggleFrame); SwitchTrack.Size = UDim2.new(0, 36, 0, 20); SwitchTrack.Position = UDim2.new(1, -44, 0.5, -10); SwitchTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SwitchTrack.AutoButtonColor = false; SwitchTrack.Text = ""
    Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)
    local SwitchKnob = Instance.new("Frame", SwitchTrack); SwitchKnob.Size = UDim2.new(0, 14, 0, 14); SwitchKnob.Position = UDim2.new(0, 3, 0.5, -7); SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

    local function Toggle()
        state = not state
        SwitchTrack.BackgroundColor3 = state and Color3.fromRGB(46, 160, 67) or Color3.fromRGB(40, 40, 40)
        TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        task.spawn(callback, state)
    end
    SwitchTrack.MouseButton1Click:Connect(Toggle)
    Keybinds[key] = Toggle
end

-- Voo
local bv, bg
local function ToggleFly(on)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if on then
        if char:FindFirstChild("Animate") then char.Animate.Enabled = false end
        bv = Instance.new("BodyVelocity", char.HumanoidRootPart); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
        bg = Instance.new("BodyGyro", char.HumanoidRootPart); bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = char.HumanoidRootPart.CFrame
    else
        if char:FindFirstChild("Animate") then char.Animate.Enabled = true end
        if bv then bv:Destroy() end; if bg then bg:Destroy() end
    end
end

-- Registro
AddToggle("speed", "X", function(s) States.Speed = s; if not s and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = 16 end end)
AddToggle("infnie jump", "Z", function(s) States.Jump = s end)
AddToggle("noclip", "C", function(s) States.Noclip = s; if not s and LocalPlayer.Character then for _,p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
AddToggle("chams", "V", function(s) States.ESP = s; if not s then for _,p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end end end)
AddToggle("fly", "F", function(s) States.Fly = s; ToggleFly(s) end)
AddToggle("Auto Clicker [H]", "H", function(s) States.AutoClick = s end)
AddToggle("Anti-AFK [J]", "J", function(s) States.AntiAFK = s end)

local btnTP = Instance.new("TextButton", Container); btnTP.Size = UDim2.new(1, 0, 0, 36); btnTP.BackgroundColor3 = Color3.fromRGB(18, 18, 18); btnTP.Text = "TP Supremo [T]"; btnTP.TextColor3 = Color3.fromRGB(220, 220, 220); btnTP.Font = Enum.Font.GothamMedium; btnTP.TextSize = 13
Instance.new("UICorner", btnTP).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", btnTP).Color = Color3.fromRGB(30, 30, 30)
btnTP.MouseButton1Click:Connect(function()
    local c, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then c = p; dist = d end
        end
    end
    if c then LocalPlayer.Character.HumanoidRootPart.CFrame = c.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
end)
Keybinds["T"] = function() btnTP.MouseButton1Click:Fire() end

-- Loop Principal
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    if States.Speed and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 23 end
    if States.Noclip then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    if States.AutoClick then VirtualUser:ClickButton1(Vector2.new(0,0)) end
    if States.AntiAFK then VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(0.1); VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end
    if States.Fly and bv then
        local move = Vector3.new(0,0,0); local cam = workspace.CurrentCamera.CFrame
        bg.CFrame = cam
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
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
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.B then MainFrame.Visible = not MainFrame.Visible end
    if Keybinds[inp.KeyCode.Name] then Keybinds[inp.KeyCode.Name]() end
end)
