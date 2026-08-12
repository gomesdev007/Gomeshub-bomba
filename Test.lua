-- [[ GOMES HUB - AUTO EXECUTE MINI GUI ]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Evita duplicar a GUI se executar mais de uma vez
if CoreGui:FindFirstChild("GomesMiniGui") then
    CoreGui.GomesMiniGui:Destroy()
end

-- ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GomesMiniGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Frame Principal (Dark Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18) -- Dark Purple / Preto
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Borda Arredondada MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Topbar (Para arrastar)
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 30)
Topbar.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 8)
TopbarCorner.Parent = Topbar

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Gomes Hub - Mini"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

-- Botão Minimizar (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 2)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Topbar

-- Lógica de Arrastar (Drag)
local dragging, dragInput, dragStart, startPos

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Lógica de Minimizar
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 260, 0, 30) or UDim2.new(0, 260, 0, 180)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
end)

-- Container dos Botões
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -40)
Content.Position = UDim2.new(0, 10, 0, 35)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Botão Test
local TestBtn = Instance.new("TextButton")
TestBtn.Size = UDim2.new(1, 0, 0, 35)
TestBtn.Position = UDim2.new(0, 0, 0, 10)
TestBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
TestBtn.Text = "Função Test"
TestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TestBtn.Font = Enum.Font.GothamSemibold
TestBtn.TextSize = 13
TestBtn.Parent = Content

local TestCorner = Instance.new("UICorner")
TestCorner.CornerRadius = UDim.new(0, 6)
TestCorner.Parent = TestBtn

TestBtn.MouseButton1Click:Connect(function()
    print("[GOMES HUB]: Função Test executada com sucesso!")
    -- Notificação na tela
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Gomes Hub",
        Text = "Função Test Ativada!",
        Duration = 3
    })
end)

-- Botão Ativar Auto Execut
local AutoExecBtn = Instance.new("TextButton")
AutoExecBtn.Size = UDim2.new(1, 0, 0, 35)
AutoExecBtn.Position = UDim2.new(0, 0, 0, 55)
AutoExecBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Red Accent
AutoExecBtn.Text = "Ativa Auto Execut"
AutoExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoExecBtn.Font = Enum.Font.GothamBold
AutoExecBtn.TextSize = 13
AutoExecBtn.Parent = Content

local AutoExecCorner = Instance.new("UICorner")
AutoExecCorner.CornerRadius = UDim.new(0, 6)
AutoExecCorner.Parent = AutoExecBtn

-- Lógica de Salvar na pasta autoexec do Delta
AutoExecBtn.MouseButton1Click:Connect(function()
    if writefile then
        -- Código que será salvo para executar automaticamente na próxima inicialização
        local scriptToSave = [[
-- Script Auto-Executado via Delta Executor
loadstring(game:HttpGet("SUA_URL_AQUI_SE_FOR_RAW"))() 
-- Ou insira o código direto aqui
print("[GOMES HUB]: Carregado via AutoExec!")
]]
        
        -- Salva o arquivo na pasta autoexec do executor
        writefile("autoexec/GomesHubAutoExec.lua", scriptToSave)
        
        AutoExecBtn.Text = "Salvo no AutoExec!"
        AutoExecBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "AutoExec Delta",
            Text = "Script salvo na pasta autoexec com sucesso!",
            Duration = 4
        })
    else
        warn("Seu executor não suporta a função writefile.")
    end
end)
