local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("Carregando Script...") -- Isso aparecerá no console (F9) se rodar

-- Limpeza de menus anteriores
if PlayerGui:FindFirstChild("MiniDarkMenu") then
    PlayerGui.MiniDarkMenu:Destroy()
end

-- Criando a ScreenGui no PlayerGui (mais seguro)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniDarkMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Frame Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 26)
MainFrame.Position = UDim2.new(0.5, -90, 0, 50) -- Centralizado no topo
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 6)

-- Título
local TitleButton = Instance.new("TextButton", MainFrame)
TitleButton.Size = UDim2.new(1, 0, 1, 0)
TitleButton.BackgroundTransparency = 1
TitleButton.Text = "  Meu Menu"
TitleButton.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleButton.TextSize = 13
TitleButton.Font = Enum.Font.SourceSansBold
TitleButton.TextXAlignment = Enum.TextXAlignment.Left

-- Container das Opções
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.Position = UDim2.new(0, 0, 1, 4)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ContentFrame.BorderSizePixel = 0
ContentFrame.Visible = false
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.Padding = UDim.new(0, 4)
local UIPadding = Instance.new("UIPadding", ContentFrame)
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12)
end)

TitleButton.MouseButton1Click:Connect(function()
    ContentFrame.Visible = not ContentFrame.Visible
end)

--- Função Auxiliar
local function CriarFuncao(nome, callback)
    local state = false
    local Row = Instance.new("Frame", ContentFrame)
    Row.Size = UDim2.new(1, 0, 0, 22)
    Row.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Row)
    Label.Size = UDim2.new(1, -24, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = nome
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansSemibold

    local Box = Instance.new("TextButton", Row)
    Box.Size = UDim2.new(0, 16, 0, 16)
    Box.Position = UDim2.new(1, -16, 0.5, -8)
    Box.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Box.Text = ""
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

    local function desligar() state = false Box.BackgroundColor3 = Color3.fromRGB(0, 0, 0) end
    
    Box.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(220, 30, 30) or Color3.fromRGB(0, 0, 0)
        pcall(callback, state, desligar)
    end)
end

-- REGISTRO
local testThread = nil
CriarFuncao("Test", function(ativo, desligar)
    if ativo then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(2323.06, -11.65, 7452.02)
            if testThread then task.cancel(testThread) end
            testThread = task.spawn(function() task.wait(10) desligar() end)
        end
    else
        if testThread then task.cancel(testThread) end
    end
end)

CriarFuncao("Ativa auto execut", function(estado, desligar)
    if not writefile then warn("Executor não suporta writefile") return end
    if estado then writefile("autoexec/MeuScriptAutoExec.lua", "-- AutoExec Ativo")
    else if isfile("autoexec/MeuScriptAutoExec.lua") then delfile("autoexec/MeuScriptAutoExec.lua") end end
end)

print("Script carregado com sucesso!")
